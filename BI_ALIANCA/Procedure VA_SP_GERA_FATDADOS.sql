



--
-- Descricao: Gera tabela VA_FATDADOS. A tabela eh usada em diversas consultas de faturamento.
-- Autor....: Robert Koch
-- Data.....: 25/07/2022
--
-- Historico de alteracoes:
-- 17/07/2023 - Robert  - Removido comando SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--                        por que tive caso de usuario exportando para planilha exatamente
--                        no momento em que o job estava regerando a tabela.
--                      - Inseridos comandos de BEGIN TRAN e COMMIT
-- 01/09/2023 - Claudia - Incluidos campos de desconto PIS/COFINS Zonha franca. GLPI: 14152
-- 19/01/2024 - Claudia - Incluido novo campo VALOR_NET_ATE_2023. GLPI: 14638
--

ALTER PROCEDURE [dbo].[VA_SP_GERA_FATDADOS]
(
	@DIAS_RETROATIVOS INT
) AS
BEGIN
	DECLARE @MAIOR_DATA_TABELA VARCHAR (8);
	DECLARE @DATAINI           VARCHAR (8);

	-- NAO VEJO NECESSIDADE DE FICAR COM ESTE PROCESSO PARADO ALGUARDANDO
	-- FINALIZAR ALGUMA TRANSACAO, ATEH MESMO POR QUE O PROPRIO PROTHEUS
	-- TRABALHA USANDO 'READ UNCOMMITED'.
	-- SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- SE RECEBER ZERO DIAS, BUSCO DESDE A ULTIMA DATA ENCONTRADA NA TABELA ATEH 
	-- HOJE (DIGAMOS QUE TENHA FICADO PARADO POR 1 OU 2 DIAS POR ALGUM MOTIVO)
	-- ASSIM ESPERO NUNCA FICAR COM LACUNA NOS DADOS.
	IF (@DIAS_RETROATIVOS = 0)
	BEGIN
		PRINT 'PARAMETRO DE DIAS ZERADO. VOU BUSCAR ULTIMA DATA EXISTENTE NA TABELA'
SET @MAIOR_DATA_TABELA = (SELECT
		MAX(EMISSAO)
	FROM BI_ALIANCA.dbo.VA_FATDADOS)

		IF (@MAIOR_DATA_TABELA IS NULL)
		BEGIN
			PRINT 'MAIOR DATA DA TABELA RETORNOU NULL. ASSUMINDO A DATA DE HOJE.'
SET @DATAINI = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMdd')
		END
		ELSE
		BEGIN
			PRINT 'ASSUMINDO INICIO COMO A MAIOR DATA DA TABELA'
SET @DATAINI = @MAIOR_DATA_TABELA
		END
	END
	ELSE
	BEGIN
		PRINT 'CALCULANDO DATA DE INICIO CFE. PARAMETRO DE DIAS RETROATIVOS'
SET @DATAINI = FORMAT(DATEADD(DAY, -1 * @DIAS_RETROATIVOS, CURRENT_TIMESTAMP), 'yyyyMMdd')
	END

	IF (@DATAINI IS NOT NULL AND @DATAINI != '')
	BEGIN
		PRINT 'DATA DE INICIO: ' + @DATAINI

BEGIN TRAN;

-- ELIMINA OS REGISTROS A PARTIR DESTA DATA E GERA NOVAMENTE.
DELETE FROM BI_ALIANCA.dbo.VA_FATDADOS
WHERE EMISSAO >= @DATAINI

INSERT INTO BI_ALIANCA.dbo.VA_FATDADOS (EMPRESA				-- 1
, ORIGEM				-- 2
, FILIAL				-- 3
, TES				-- 4
, CLIENTE			-- 5
, LOJA				-- 6
, GRUPOPROD			-- 7
, PRODUTO			-- 8
, TIPOPROD			-- 9
, TIPONFENTR			-- 10
, TIPONFSAID			-- 11
, QUANTIDADE			-- 12
, QTLITROS			-- 13
, DOC				-- 14
, SERIE				-- 15
, EMISSAO			-- 16
, VEND1				-- 17
, VEND2				-- 18
, PEDVENDA			-- 19
, ITEMPDVEND			-- 20
, PVCOND				-- 21
, SEGURO				-- 22
, DESPESA			-- 23
, TOTAL				-- 24
, VALIPI				-- 25
, COMIS1				-- 26
, COMIS2				-- 27
, COMIS3				-- 28
, COMIS4				-- 29
, COMIS5				-- 30
, RAPELPREV			-- 31
, BASERAPEL			-- 32
, VALICM				-- 33
, VALPIS				-- 34
, VALCOFINS			-- 35
, CUSTOMEDIO			-- 36
, QTCAIXAS			-- 37
, F4_DUPLIC			-- 38
, F4_ESTOQUE			-- 39
, F4_MARGEM			-- 40
, EST				-- 41
, PRODPAI			-- 42
, NFORI				-- 43
, SERIORI			-- 44
, ITEMORI			-- 45
, ITEMNOTA			-- 46
, PESOBRUTO			-- 47
, UMPROD				-- 48
, UMPRODPAI			-- 49
, ICMSRET			-- 50
, MOTDEV				-- 51
, DESCONTO			-- 52
, PRUNIT				-- 53
, CFOP				-- 54
, TRANSP				-- 55
, CUSTOREPOS			-- 56
, DTGERACAO			-- 57
, VALBRUT			-- 58
, MARGEMCONT			-- 59
, TIPOFRETE			-- 60
, FRETEPREV			-- 61
, VALORFRETE			-- 62
, FRETEREENT			-- 63
, FRETEREDSP			-- 64
, FRETEPALET			-- 65
, DFRAPEL			-- 66
, DFENCART			-- 67
, DFFEIRAS			-- 68
, DFFRETES			-- 69
, DFDESCONT			-- 70
, DFDEVOL			-- 71
, DFCAMPANH			-- 72
, DFABLOJA			-- 73
, DFCONTRAT			-- 74
, DFOUTROS			-- 75
, ATIVIDADE			-- 76
, PRAZOMEDIO			-- 77
, MARCA				-- 78
, GRPEMB				-- 79
, CODLINHA			-- 80
, DESCRIATIV			-- 81
, CANAL				-- 82
, DESCRICANAL		-- 83
, D2_VALFRE			-- 84
, VALOR_NET			-- 85
, DESCZFPIS			-- 86
, DESCZFCOF			-- 87
, VALOR_NET_ATE_2023 -- 88
)
	SELECT
		EMPRESA      -- 1
	   ,ORIGEM         -- 2
	   ,FILIAL         -- 3
	   ,TES            -- 4
	   ,CLIENTE        -- 5
	   ,LOJA           -- 6
	   ,GRUPOPROD      -- 7
	   ,PRODUTO        -- 8
	   ,TIPOPROD       -- 9
	   ,TIPONFENTR     -- 10
	   ,TIPONFSAID     -- 11
	   ,QUANTIDADE     -- 12
	   ,QTLITROS       -- 13
	   ,DOC            -- 14
	   ,SERIE          -- 15
	   ,EMISSAO        -- 16
	   ,VEND1          -- 17
	   ,VEND2          -- 18
	   ,PEDVENDA       -- 19
	   ,ITEMPDVEND     -- 20
	   ,PVCOND         -- 21
	   ,SEGURO         -- 22
	   ,DESPESA        -- 23
	   ,TOTAL          -- 24
	   ,VALIPI         -- 25
	   ,COMIS1         -- 26
	   ,COMIS2         -- 27
	   ,COMIS3         -- 28
	   ,COMIS4         -- 29
	   ,COMIS5         -- 30
	   ,RAPELPREV      -- 31
	   ,BASERAPEL      -- 32
	   ,VALICM         -- 33
	   ,VALPIS         -- 34
	   ,VALCOFINS      -- 35
	   ,CUSTOMEDIO     -- 36
	   ,QTCAIXAS       -- 37
	   ,F4_DUPLIC      -- 38
	   ,F4_ESTOQUE     -- 39
	   ,F4_MARGEM      -- 40
	   ,EST            -- 41
	   ,PRODPAI        -- 42
	   ,NFORI          -- 43
	   ,SERIORI        -- 44
	   ,ITEMORI        -- 45
	   ,ITEMNOTA       -- 46
	   ,PESOBRUTO      -- 47
	   ,UMPROD         -- 48
	   ,UMPRODPAI      -- 49
	   ,ICMSRET        -- 50
	   ,MOTDEV         -- 51
	   ,DESCONTO       -- 52
	   ,PRUNIT         -- 53
	   ,CFOP           -- 54
	   ,TRANSP         -- 55
	   ,CUSTOREPOS     -- 56
	   ,DTGERACAO      -- 57
	   ,VALBRUT        -- 58
	   ,MARGEMCONT     -- 59
	   ,TIPOFRETE      -- 60
	   ,FRETEPREV      -- 61
	   ,VALORFRETE     -- 62
	   ,FRETEREENT     -- 63
	   ,FRETEREDSP     -- 64
	   ,FRETEPALET     -- 65
	   ,DFRAPEL        -- 66
	   ,DFENCART       -- 67
	   ,DFFEIRAS       -- 68
	   ,DFFRETES       -- 69
	   ,DFDESCONT      -- 70
	   ,DFDEVOL        -- 71
	   ,DFCAMPANH      -- 72
	   ,DFABLOJA       -- 73
	   ,DFCONTRAT      -- 74
	   ,DFOUTROS       -- 75
	   ,ATIVIDADE      -- 76
	   ,PRAZOMEDIO     -- 77
	   ,MARCA          -- 78
	   ,GRPEMB         -- 79
	   ,CODLINHA       -- 80
	   ,DESCRIATIV     -- 81
	   ,CANAL          -- 82
	   ,DESCRICANAL    -- 83
	   ,D2_VALFRE      -- 84
	   ,(TOTAL
		- VALCOFINS
		- (TOTAL * COMIS1 / 100)
		- (TOTAL * COMIS2 / 100)
		- (TOTAL * COMIS3 / 100)
		- (TOTAL * COMIS4 / 100)
		- (TOTAL * COMIS5 / 100)
		-
		CASE
			WHEN VALORFRETE > 0 THEN VALORFRETE
			ELSE FRETEPREV
		END
		-
		CASE
			WHEN DFRAPEL > 0 THEN DFRAPEL
			ELSE RAPELPREV
		END
		)  -- 85
	   ,DESCZFPIS	    -- 86
	   ,DESCZFCOF      -- 87
	   ,(TOTAL - VALICM -
		CASE
			WHEN DFRAPEL > 0 THEN DFRAPEL
			ELSE RAPELPREV
		END
		-
		CASE
			WHEN VALORFRETE > 0 THEN VALORFRETE
			ELSE FRETEPREV
		END
		- DFENCART
		- DFFEIRAS
		- DFFRETES
		- DFDESCONT
		- DFDEVOL
		- DFCAMPANH
		- DFABLOJA
		- DFCONTRAT
		- DFOUTROS
		- (TOTAL * COMIS1 / 100))  -- 88

	FROM protheus.dbo.VA_VFAT
	WHERE EMISSAO >= @DATAINI

COMMIT

END
ELSE
BEGIN
PRINT 'DATA DE INICIO NAO DEFINIDA!'
END

END

