
-- Descricao: Importa arquivos em formato CSV exportados pelo Totvs LicenseServer (opcao Historico de consumo -> Usuarios -> CSV)
-- Autor....: Robert Koch
-- Data.....: 09/04/2021
--
-- Historico de alteracoes:
-- 27/09/2021 - Robert - Pequenas melhorias nos comentarios
--

ALTER PROCEDURE [dbo].[SP_IMPORTA_LICENSESERVER]
(
	@ARQUIVO VARCHAR (MAX)
) AS
BEGIN

	if object_id ('tempdb..#IMPORTA_LICSERVER') IS NOT NULL
		DROP TABLE #IMPORTA_LICSERVER

	CREATE TABLE #IMPORTA_LICSERVER(
		DTCONEXAO varchar(10) NOT NULL,
		HRCONEXAO varchar(8) NOT NULL,
		END_IP varchar(30) NOT NULL,
		THREAD INT NOT NULL,
		MAINTHREAD INT NOT NULL,
		IDEMPRESA VARCHAR(36) NOT NULL,
		EMPRESA VARCHAR(40) NOT NULL,
		IDUSR VARCHAR (36) NOT NULL,
		NOMEUSR VARCHAR(80) NOT NULL,
		MODULO INT NOT NULL,
		IDAGRUPADOR INT NOT NULL,
		IDLICENCA INT NOT NULL,
		ROTINA VARCHAR (40) NOT NULL,
		TEMPOUSO INT NOT NULL,
		STATUS_LIC VARCHAR (12) NOT NULL,
		TPOPER VARCHAR (12) NOT NULL,
		TX VARCHAR (12) NOT NULL
	)

	/*
	BULK INSERT #IMPORTA_LICSERVER
		FROM 'C:\TEMP\LS_SC000200.csv'
		WITH
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ';',  --CSV field delimiter
		ROWTERMINATOR = '\n',   --Use to shift the control to next row
		ERRORFILE = 'C:\TEMP\LICENSESERVER_ERROS.csv',
		TABLOCK
		)
	*/
	DECLARE @SQL_BULK VARCHAR(MAX)
	SET @SQL_BULK = 'BULK INSERT #IMPORTA_LICSERVER
		FROM ''' + @ARQUIVO + '''
		WITH
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = '';'',  --CSV field delimiter
		ROWTERMINATOR = ''\n'',   --Use to shift the control to next row
		ERRORFILE = ''C:\TEMP\LICENSESERVER_ERROS.csv'',
		TABLOCK
		)'

	EXEC (@SQL_BULK)

	-- CRIA LISTA DE TIPOS DE LICENCAS
	if object_id ('tempdb..#TIPOS_LICENCAS') IS NOT NULL
		DROP TABLE #TIPOS_LICENCAS

	CREATE TABLE #TIPOS_LICENCAS(
		ID INT NOT NULL,
		DESCRICAO VARCHAR (20) NOT NULL
	)
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4000, 'FULL')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4001, 'TOTVS I')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4007, 'DEV TEST')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4092, 'DBACCESS')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4118, 'COMPRAS')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4122, 'CONTABIL')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4132, 'ESTOQUE')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4133, 'FINANCEIRO')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4134, 'FISCAL')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4154, 'LOJAS')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4159, 'AMBIENTAL')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4160, 'MANUTENCAO')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4162, 'OMS-CARGAS')
	INSERT INTO #TIPOS_LICENCAS	(ID, DESCRICAO) (SELECT 4173, 'FATURAMENTO')

	/*
	-- CRIA ESTRUTURA DEFINITIVA
	if object_id ('LICENSESERVER') IS NOT NULL
		DROP TABLE LICENSESERVER

	CREATE TABLE LICENSESERVER(
		DTHR DATETIME NOT NULL,
		THREAD INT NOT NULL,
		MAINTHREAD INT NOT NULL,
		USUARIO VARCHAR(20) NOT NULL,
		MODULO VARCHAR (7) NOT NULL,
		AGRUPADOR_LIC VARCHAR (25) NOT NULL,
		LICENCA VARCHAR (25) NOT NULL,
		ROTINA VARCHAR (50) NOT NULL,
		TEMPOUSO INT NOT NULL,
		STATUS_LIC VARCHAR (12) NOT NULL,
		TPOPER VARCHAR (12) NOT NULL,
	)
	CREATE NONCLUSTERED INDEX LICENSESERVER_IDX1 ON LICENSESERVER (DTHR, THREAD)
	*/
	-- PASSA OS DADOS DA TABELA TEMPORARIA PARA A DEFINITIVA
	;WITH C AS (
		 SELECT CAST (SUBSTRING (DTCONEXAO, 7, 4) + SUBSTRING (DTCONEXAO, 4, 2) + SUBSTRING (DTCONEXAO, 1, 2) + ' ' + HRCONEXAO AS DATETIME) AS DTHR
		,THREAD, MAINTHREAD
		,CASE WHEN #IMPORTA_LICSERVER.ROTINA IN ('RPC', 'WebServices') THEN '' ELSE SUBSTRING (NOMEUSR, 1, 15) END AS USR
		,RTRIM (CAST (#IMPORTA_LICSERVER.MODULO AS VARCHAR (2))) + ISNULL ('-' + RTRIM (M.SIGLA), '') AS MODULO
		,RTRIM (CAST (#IMPORTA_LICSERVER.IDAGRUPADOR AS VARCHAR (4))) + ISNULL ('-' + RTRIM (TLA.DESCRICAO), '') AS LIC1
		,RTRIM (CAST (#IMPORTA_LICSERVER.IDLICENCA AS VARCHAR (4))) + ISNULL ('-' + RTRIM (TLL.DESCRICAO), '') AS LIC2
		,SUBSTRING (RTRIM (#IMPORTA_LICSERVER.ROTINA) + ISNULL (' - ' + RTRIM (R.DESCRICAO), ''), 1, 50) AS ROT
		,TEMPOUSO, STATUS_LIC, TPOPER
	FROM #IMPORTA_LICSERVER
		LEFT JOIN #TIPOS_LICENCAS TLA ON (TLA.ID = #IMPORTA_LICSERVER.IDAGRUPADOR)
		LEFT JOIN #TIPOS_LICENCAS TLL ON (TLL.ID = #IMPORTA_LICSERVER.IDLICENCA)
		LEFT JOIN protheus.dbo.VA_USR_MODULOS M ON (CAST (M.ID_MODULO AS INT) = #IMPORTA_LICSERVER.MODULO)
		LEFT JOIN (SELECT ROTINA, MAX (DESCRICAO) AS DESCRICAO FROM protheus.dbo.VA_USR_ROTINAS GROUP BY ROTINA) AS R ON (R.ROTINA = #IMPORTA_LICSERVER.ROTINA)
	)
	INSERT INTO LICENSESERVER (DTHR, THREAD, MAINTHREAD, USUARIO, MODULO, AGRUPADOR_LIC, LICENCA, ROTINA, TEMPOUSO, STATUS_LIC, TPOPER)
		 (SELECT *
		 FROM C
		WHERE NOT EXISTS (select * from LICENSESERVER
							where LICENSESERVER.DTHR = C.DTHR
							AND LICENSESERVER.THREAD = C.THREAD)
	)

	DROP TABLE #IMPORTA_LICSERVER
END
/*
select ROTINA, SUM (CASE WHEN STATUS_LIC != 'Obtida' THEN 1 ELSE 0 END) AS NEGADAS
	, SUM (CASE WHEN STATUS_LIC = 'Obtida' THEN 1 ELSE 0 END) AS OBTIDAS
	, SUM (CASE WHEN STATUS_LIC = 'Obtida' THEN TEMPOUSO ELSE 0 END) as TEMPOUSO_SEGUNDOS
from LICENSESERVER
WHERE DTHR BETWEEN '20210101 00:00:00' AND '20210408 16:15:00'
AND LICENCA IN ('4160-MANUTENCAO','4159-AMBIENTAL')
GROUP BY ROTINA
ORDER BY COUNT (*) DESC

exec SP_IMPORTA_LICENSESERVER 'c:\temp\LS_SC000200.csv'

*/

