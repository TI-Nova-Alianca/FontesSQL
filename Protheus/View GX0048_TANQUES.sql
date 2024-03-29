
--USE [protheus]
--GO

--/****** Object:  View [dbo].[GX0048_TANQUES]    Script Date: 08/12/2022 14:51:11 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO




CREATE view [dbo].[GX0048_TANQUES]
AS
SELECT
	ROW_NUMBER() OVER (ORDER BY BF_FILIAL, BF_LOCAL, BF_PRODUTO) AS GX0048_LINHA
   ,BF_FILIAL AS GX0048_FILIAL
   ,(SELECT
			NNR_CODIGO + ' - ' + NNR_DESCRI
		FROM NNR010
		WHERE NNR010.D_E_L_E_T_ = ''
		AND NOT NNR_DESCRI LIKE '%(BLOQ)%'
		AND NNR_CODIGO = BF_LOCAL)
	AS GX0048_ALMOXARIFADO
  -- ,(SELECT
		--	NNR_CODIGO
		--FROM NNR010
		--WHERE NNR010.D_E_L_E_T_ = ''
		--AND NOT NNR_DESCRI LIKE '%(BLOQ)%'
		--AND NNR_CODIGO = BF_LOCAL)  -- DAYANA 12/05/2022 - 10930
   ,BF_LOCAL AS GX0048_ALMOX_COD
   ,BF_LOCALIZ AS GX0048_TANQUE
   ,BF_PRODUTO AS GX0048_PRODUTO
   ,B1_DESC AS GX0048_DESCRICAO

   ,BF_LOTECTL AS GX0048_LOTE

   ,CAST(CAST(BE_CAPACID AS DECIMAL(15, 0)) AS VARCHAR) AS GX0048_CAPACIDADE
   ,CAST(CAST(BE_CAPREAL AS DECIMAL(15, 0)) AS VARCHAR) AS GX0048_CAPAC_REAL -- DAYANA 13/05/2022 - 11810
   ,REPLACE(CAST(CAST(BF_QUANT AS DECIMAL(15, 4)) AS VARCHAR) , '.', ',') AS GX0048_ESTOQUEATUAL   -- DAYANA 08/12/2022 - 12898  
	--,CAST(CAST(BF_QUANT AS DECIMAL(15, 4)) AS VARCHAR) AS GX0048_ESTOQUEATUAL 
  
  ,CASE BE_STATUS
		WHEN '1' THEN 'Desocupado'
		WHEN '2' THEN 'Ocupado'
		WHEN '3' THEN 'Bloqueado'
		WHEN '4' THEN 'Bloqueio Entrada'
		WHEN '5' THEN 'Bloqueio Saída'
		WHEN 6 THEN 'Bloqueio Inventário'
	END AS GX0048_STATUS
   ,ISNULL((SELECT TOP 1
			ISNULL(CASE B8_VADESTI
				WHEN 'V' THEN 'Venda'
				WHEN 'E' THEN 'Envase'
				WHEN 'C' THEN 'Concentração'
			END, '')
		FROM SB8010
		WHERE B8_FILIAL = BF_FILIAL
		--AND B8_LOCAL = BF_LOCAL  -- DAYANA 12/05/2022 - 10930
		AND B8_PRODUTO = BF_PRODUTO
		AND B8_LOTECTL = BF_LOTECTL
		AND SB8010.D_E_L_E_T_ = '')
	, '') AS GX0048_DESTINACAO
   ,BE_VATANQ AS GX0048_EH_TANQUE
FROM SBF010
	,SB1010
	,SBE010
WHERE SBF010.D_E_L_E_T_ = ''
AND SB1010.D_E_L_E_T_ = ''
AND SBE010.D_E_L_E_T_ = ''
AND BF_QUANT != 0
--AND BF_LOCALIZ NOT LIKE '%PCP%' -- DAYANA 12/05/2022 - 10930
AND B1_COD = BF_PRODUTO
AND BE_FILIAL = BF_FILIAL
AND BE_LOCAL = BF_LOCAL
AND BE_LOCALIZ = BF_LOCALIZ  
	--and B1_COD = '600729'

