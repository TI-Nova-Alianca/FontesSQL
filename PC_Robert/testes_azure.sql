use protheus
/*

-- Usuario para o BI da empresa Mirar acessar nosso database DW na nuvem da Azure (eles nao acessam nosso servidor interno)
-- conectar em db-alianca.database.windows.net
use master
	CREATE LOGIN pbimirar WITH PASSWORD = 'M1ra89@23!'
	CREATE LOGIN server_interno WITH PASSWORD = 'Tdedpn23!'
	-- esta propriedade nao existe na Azure ---> ALTER LOGIN pbimirar WITH DEFAULT_DATABASE=[DW]
use DW
	CREATE USER [pbimirar] FOR LOGIN [pbimirar]
	CREATE USER [server_interno] FOR LOGIN [server_interno]
	ALTER ROLE db_owner ADD MEMBER [pbimirar];  -- nao to gostando deste aqui...
	GRANT SELECT, INSERT, UPDATE, DELETE on DRE TO [server_interno]
	GRANT SELECT on DRE TO [pbimirar]


--SELECT TOP 10 * INTO LKSRV_AZURE_DBALIANCA.DW.dbo.TESTE_ROBERT FROM SERVERSQL.protheus.dbo.ZZ9010

--SELECT * FROM LKSRV_AZURE_DBALIANCA.DW.dbo.DRE_2023

UPDATE LKSRV_AZURE_DBALIANCA.DW.dbo.DRE_2023 SET DESTACAR = 'N' WHERE DESTACAR = '0'


CREATE TABLE LKSRV_AZURE_DBALIANCA.DW.[dbo].[teste_robert](
	[DATAHORA] [datetime] NULL,
	[ORIGEM] [varchar](50) NULL,
	[TEXTO] [varchar](max) NULL
)
*/
--select * FROM VA_FCONS_ORCAMENTO_525 ('', 'Z', '2023', '01', '12', 8, NULL, NULL, NULL, NULL)

/* Versao 1
-- Gera tabela de numeros (tally table). Royalties para https://www.sqlservercentral.com/articles/the-numbers-or-tally-table-what-it-is-and-how-it-replaces-a-loop-1
-- Faz um produto cartesiano de uma tabela grande com ela mesma para ter certeza de que vai gerar milhares de registros.
SELECT TOP 11000
	IDENTITY (INT, 1, 1) AS N
	INTO #TALLY
FROM SA1010 S1, SA1010 S2
--===== Add a Primary Key to maximize performance
ALTER TABLE #TALLY
ADD CONSTRAINT PK_TALLY_N 
PRIMARY KEY CLUSTERED (N) WITH FILLFACTOR = 100
*/
/* aCABEI NAO USANDO, MAS QUERO GUARDAR O EXEMPLO
-- Versao 2
-- Gera tabela de numeros (tally table) com 1000 linhas. Se este codigo
-- permanecer ativo gerando mais de 1000 meses de movimentacao, eu realmente
-- gostaria de estar ainda vivo para ver!
-- Royalties (conceito) para Jeff Moden em https://www.sqlservercentral.com/articles/the-numbers-or-tally-table-what-it-is-and-how-it-replaces-a-loop-1 e https://www.sqlservercentral.com/articles/tally-oh-an-improved-sql-8k-“csv-splitter”-function
-- "Inline" CTE Driven "Tally Table" produces values from 0 up to 1000
;WITH E1(N) AS (
                 SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
                 SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
                 SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
                ),                          --10E+1 or 10 rows
       E2(N) AS (SELECT 1 FROM E1 a, E1 b), --10E+2 or 100 rows
       E4(N) AS (SELECT 1 FROM E2 a, E1 b), --10E+3 or 1000 rows (para meu caso estah mais que suficiente)
 cteTally(N) AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM E4)
select * from cteTally
*/

/*
-- Cria tabela no database da nuvem, para posterior leitura pela Mirar (executar no database DW da Azure!)
-- DROP TABLE DRE
CREATE TABLE [dbo].[DRE](
	[ANO] [varchar](4) NOT NULL,
	[MES] [varchar](2) NOT NULL,
	[FILIAL] [varchar](2) NULL,
	--[CODPLA] [varchar](3) NULL,
	[ORDEM] [int] NULL,
	[DESC_N1] [varchar](40) NULL,
	[DESC_N2] [varchar](60) NULL,
	[NIVEL] [varchar](1) NULL,
	[CONTA] [varchar](20) NULL,
	[DESCRICAO] [varchar](40) NULL,
	[CC] [varchar](9) NULL,
	--[ORC_ANO] [float] NULL,
	--[ORC_ANO_FP] [varchar](1) NULL,
	--[ORC_ANO_AV] [float] NULL,
	[ORC_PER] [float] NULL,
	--[ORC_PER_FP] [varchar](1) NULL,
	--[ORC_PER_AV] [float] NULL,
	--[REA_MES] [float] NULL,
	--[REA_MES_FP] [varchar](1) NULL,
	--[REA_MES_AV] [float] NULL,
	[REA_PER] [float] NULL,
	--[REA_PER_FP] [varchar](1) NULL,
	--[REA_PER_AV] [float] NULL,
	--[REA_ANT] [float] NULL,
	--[REA_ANT_FP] [varchar](1) NULL,
	--[REA_ANT_AV] [float] NULL,
	--[PAG_FIN_BANC] [varchar](1) NULL,
	--[EH_DEPRECIACAO] [varchar](1) NULL,
	[INFORMATIVO] [varchar](1) NULL
	--[DESTACAR] [varchar](1) NULL,
	--[PERSISTIR] [varchar](1) NULL,
	--[FILTRACC] [varchar](9) NULL
)
CREATE NONCLUSTERED INDEX DRE_IDX ON DRE (ANO, MES, FILIAL, ORDEM, CONTA)
*/

;WITH VA_ANOS AS
(
	-- Sugiro rodar um ano por vez (comentariar os demais) por causa da demora
	--SELECT '2021' AS ANO --UNION ALL
	--SELECT '2022' AS ANO --UNION ALL
	SELECT '2023' AS ANO --UNION ALL
	--SELECT '2024' AS ANO
)
, VA_MESES AS
(
	SELECT '01' AS MES, 'JAN' AS NOME3 UNION ALL
	SELECT '02' AS MES, 'FEV' AS NOME3 UNION ALL
	SELECT '03' AS MES, 'MAR' AS NOME3 UNION ALL
	SELECT '04' AS MES, 'ABR' AS NOME3 UNION ALL
	SELECT '05' AS MES, 'MAI' AS NOME3 UNION ALL
	SELECT '06' AS MES, 'JUN' AS NOME3 UNION ALL
	SELECT '07' AS MES, 'JUL' AS NOME3 UNION ALL
	SELECT '08' AS MES, 'AGO' AS NOME3 UNION ALL
	SELECT '09' AS MES, 'SET' AS NOME3 UNION ALL
	SELECT '10' AS MES, 'OUT' AS NOME3 UNION ALL
	SELECT '11' AS MES, 'NOV' AS NOME3 UNION ALL
	SELECT '12' AS MES, 'DEZ' AS NOME3
)
, ANO_MES AS (
	SELECT ANO, MES
	FROM VA_ANOS, VA_MESES
)
insert INTO LKSRV_AZURE_DBALIANCA.DW.dbo.DRE (ANO, MES, FILIAL, ORDEM, DESC_N1, DESC_N2, NIVEL, CONTA, DESCRICAO, CC, ORC_PER, REA_PER, INFORMATIVO)
SELECT ANO, MES, FILIAL, ORDEM, DESC_N1, DESC_N2, NIVEL, CONTA, DESCRICAO, CC, ORC_PER, REA_PER, INFORMATIVO
	FROM ANO_MES CROSS APPLY VA_FCONS_ORCAMENTO_525 ('', 'Z', ANO, MES, MES, 8, NULL, NULL, NULL, NULL) F

--------------------

SELECT TOP 1 * INTO LKSRV_AZURE_DBALIANCA.DW.dbo.BALPAT
FROM BI_ALIANCA.dbo.VPBI_BALPAT
