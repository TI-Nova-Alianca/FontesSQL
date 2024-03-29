


-- Cooperativa Vinicola Nova Alianca Ltda
-- View utilizada no Mercanet para buscar precos de ultimos produtos vendidos
-- Criada devido a limitação do mobile com clausulas SQL (TOP, ROWNOW....)
-- Autor:  Claudia Lionço
-- Data :  12/07/2023
-- Historico de alteracoes:
--

ALTER VIEW [dbo].[VA_VMERC_PRECOPROD] AS

SELECT
		TOP (5) *
	FROM (SELECT
			ROW_NUMBER() OVER (PARTITION BY DB_TBREP_CODIGO ORDER BY FD.EMISSAO DESC) AS ID
		   ,FD.PRODUTO AS COD_PROD
		   ,SB1.B1_DESC AS DESC_PROD
		   ,FD.TOTAL / IIF(FD.QUANTIDADE = 0, 1, FD.QUANTIDADE) AS PRCUNIT
		   ,CAST(FD.EMISSAO AS DATETIME) AS EMISSAO
		   ,FD.CLIENTE AS COD_CLI
		   ,SA1.A1_NOME AS NOME_CLI
		   ,DB_TBREP_CODIGO AS REPRESENTANTE
		FROM BI_ALIANCA.dbo.VA_FATDADOS FD
		INNER JOIN protheus.dbo.SA1010 SA1
			ON SA1.D_E_L_E_T_ = ''
			AND SA1.A1_COD = FD.CLIENTE
			AND SA1.A1_LOJA = FD.LOJA
		INNER JOIN protheus.dbo.SB1010 SB1
			ON SB1.D_E_L_E_T_ = ''
			AND SB1.B1_COD = FD.PRODUTO
		INNER JOIN MercanetPRD.dbo.DB_TB_REPRES
			ON FD.VEND1 = DB_TBREP_CODORIG
		INNER JOIN protheus.dbo.SF4010 SF4
			ON SF4.D_E_L_E_T_ = ''
			AND SF4.F4_CODIGO = FD.TES
			AND SF4.F4_MARGEM = '1'
		WHERE FD.EMISSAO >= GETDATE() - 730) TB_AUX


