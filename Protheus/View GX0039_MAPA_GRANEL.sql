ALTER VIEW GX0039_MAPA_GRANEL AS
WITH C AS (
	SELECT 
		BF_FILIAL   AS GX0039_MAPA_GRANEL_FILIAL,
		BF_LOCAL    AS GX0039_MAPA_GRANEL_ALMOX,
		BF_LOCALIZ	AS GX0039_MAPA_GRANEL_TANQUE,
		BF_PRODUTO	AS GX0039_MAPA_GRANEL_PRODUTO,
		RTRIM (B1_DESC) AS GX0039_MAPA_GRANEL_DESCRICAO,
		BF_LOTECTL AS GX0039_MAPA_GRANEL_LOTE,
		BF_QUANT AS GX0039_MAPA_GRANEL_ESTQ_ATUAL_TANQUE,
		CASE BE_STATUS
			WHEN '1'  THEN 'Desocupado'
			WHEN '2'  THEN 'Ocupado'
			WHEN '3'  THEN 'Bloqueado'
			WHEN '4'  THEN 'Bloqueio Entrada'
			WHEN '5'  THEN 'Bloqueio Saída'
			WHEN '6'  THEN 'Bloqueio Inventário'
		END  AS GX0039_MAPA_GRANEL_STATUS_TANQUE,
		ISNULL (
		CASE B8_VADESTI  
			WHEN 'V'  THEN 'Venda'
			WHEN 'E'  THEN 'Envase'
			WHEN 'C'  THEN 'Concentracao'
			WHEN 'T'  THEN 'Corte'
			WHEN 'G'  THEN 'Vinagre'
			WHEN 'B'  THEN 'Borra'
			WHEN 'A'  THEN 'A definir'
		END , '') AS GX0039_MAPA_GRANEL_DESTINACAO,
		ISNULL (
		CASE B8_VASTVEN
			WHEN 'A' THEN 'Amostra em aprovacao'
			WHEN 'V' THEN 'Venda efetivada'
		END , '') AS GX0039_MAPA_GRANEL_STATUS_VENDA,
		B8_VACLIEN + '/' + B8_VALOJA + '-' + RTRIM (ISNULL (A1_NOME, '')) AS GX0039_MAPA_GRANEL_CLIENTE,
		B8_VACRSIS AS GX0039_MAPA_GRANEL_CODIGO_CR,
		ISNULL(
		(SELECT 
			TOP 1 ZAF_ENSAIO 
		 FROM ZAF010 ZAF
		 WHERE ZAF.D_E_L_E_T_ = '' 
			AND ZAF.ZAF_FILIAL = SBF.BF_FILIAL
			AND ZAF.ZAF_PRODUT = SBF.BF_PRODUTO
			AND ZAF.ZAF_LOTE   = SBF.BF_LOTECTL
			AND ZAF.ZAF_DATA  <= convert(varchar, getdate(), 112) 
			AND ZAF.ZAF_VALID >= convert(varchar, getdate(), 112) 
			AND NOT EXISTS (
				SELECT * FROM ZAF010 MAIS_RECENTE
				WHERE MAIS_RECENTE.D_E_L_E_T_ = ''
					AND MAIS_RECENTE.ZAF_FILIAL = ZAF.ZAF_FILIAL
					AND MAIS_RECENTE.ZAF_LOTE   = ZAF.ZAF_LOTE
					AND MAIS_RECENTE.ZAF_ENSAIO > ZAF.ZAF_ENSAIO) 
				ORDER BY ZAF.ZAF_ENSAIO DESC), '') AS GX0039_MAPA_GRANEL_ENSAIO 
		FROM SBF010 SBF, SB8010 SB8
		LEFT JOIN SA1010 SA1 ON (SA1.D_E_L_E_T_ = '' AND SA1.A1_FILIAL  = '  ' AND SA1.A1_COD     = SB8.B8_VACLIEN AND SA1.A1_LOJA = SB8.B8_VALOJA),SB1010 SB1, SBE010 SBE
		WHERE SB1.D_E_L_E_T_ = '' 
			AND SB1.B1_FILIAL  = '  '
			AND SB1.B1_COD     = SBF.BF_PRODUTO
			AND SBE.D_E_L_E_T_ = ''
			AND SBE.BE_FILIAL  = SBF.BF_FILIAL
			AND SBE.BE_LOCAL   = SBF.BF_LOCAL
			AND SBE.BE_LOCALIZ = SBF.BF_LOCALIZ
			AND SBE.BE_VATANQ  = 'S'
			AND SB8.D_E_L_E_T_ = ''
			AND SB8.B8_FILIAL  = SBF.BF_FILIAL
			AND SB8.B8_LOCAL   = SBF.BF_LOCAL
			AND SB8.B8_PRODUTO = SBF.BF_PRODUTO
			AND SB8.B8_LOTECTL = SBF.BF_LOTECTL
			AND SBF.D_E_L_E_T_ = ''
			AND SBF.BF_FILIAL BETWEEN '  ' AND 'zz'
			AND SBF.BF_PRODUTO BETWEEN '               ' AND 'zzzzzzzzzzzzzzz'
			AND SUBSTRING (SBF.BF_LOCALIZ, 4, 4) BETWEEN '    ' AND 'zzzz' AND SBF.BF_QUANT != 0 )


SELECT 
	C.*, 
	dbo.VA_DTOC (ISNULL (ZAF_DATA, '')) AS GX0039_MAPA_GRANEL_DATA_ENSAIO,
	ISNULL (ZAF_ESTQ,   0) AS GX0039_MAPA_GRANEL_ESTQ_ENSAIADO,
	ISNULL (ZAF_ACTOT,  0) AS GX0039_MAPA_GRANEL_ACIDEZ_TOTAL,
	ISNULL (ZAF_ACVOL,  0) AS GX0039_MAPA_GRANEL_ACIDEZ_VOLATIL,
	ISNULL (ZAF_ACRED,  0) AS GX0039_MAPA_GRANEL_ACUCARES_REDUTORES,
	ISNULL (ZAF_ALCOOL, 0) AS GX0039_MAPA_GRANEL_ALCOOL,
	ISNULL (ZAF_DENSID, 0) AS GX0039_MAPA_GRANEL_DENSIDADE,
	ISNULL (ZAF_EXTRSE, 0) AS GX0039_MAPA_GRANEL_EXTRATO_SECO,
	ISNULL (ZAF_SO2LIV, 0) AS GX0039_MAPA_GRANEL_SO2_LIVRE,
	ISNULL (ZAF_SO2TOT, 0) AS GX0039_MAPA_GRANEL_SO2_TOTAL,
	ISNULL (ZAF_BRIX,   0) AS GX0039_MAPA_GRANEL_BRIX,
	ISNULL (ZAF_PH,     0) AS GX0039_MAPA_GRANEL_pH,
	ISNULL (ZAF_TURBID, 0) AS GX0039_MAPA_GRANEL_TURBIDEZ,
	ISNULL (ZAF_COR420, 0) AS GX0039_MAPA_GRANEL_COR_420,
	ISNULL (ZAF_COR520, 0) AS GX0039_MAPA_GRANEL_COR_520,
	ISNULL (ZAF_COR620, 0) AS GX0039_MAPA_GRANEL_COR_620,
	ISNULL ((ISNULL (ZAF_COR420, 0) + ISNULL (ZAF_COR520, 0) + ISNULL (ZAF_COR620, 0)), 0) AS GX0039_MAPA_GRANEL_INTENSIDADE,
	ISNULL (ZAF_BOLOR,  0) AS GX0039_MAPA_GRANEL_BOLORES,
	ISNULL (ZAF_COLIF,  0) AS GX0039_MAPA_GRANEL_COLIFORMES_TOTAIS,
	ISNULL (ZAF_COR,    0) AS GX0039_MAPA_GRANEL_COR,
	ISNULL (ZAF_SABOR,  0) AS GX0039_MAPA_GRANEL_SABOR,
	ISNULL (ZAF_AROMA,  0) AS GX0039_MAPA_GRANEL_AROMA,
	ISNULL (ZAF_CRQRES, '') AS GX0039_MAPA_GRANEL_CRQ_RESPONS,
	dbo.VA_DTOC (ISNULL (ZAF_VALID, '')) AS GX0039_MAPA_GRANEL_VALIDADE,
	ISNULL (ZAF_OBS, '') AS GX0039_MAPA_GRANEL_OBSERVACAO,
	ISNULL (ZAF_SAFRA1 + '(' + RTRIM (CAST (ZAF_PSAFR1 AS NCHAR)) + '%)' + CASE WHEN ZAF_SAFRA2 = '' THEN '' ELSE ';' + ZAF_SAFRA2 + '(' + RTRIM (CAST (ZAF_PSAFR2 AS NCHAR)) + '%)' END + CASE WHEN ZAF_SAFRA3 = '' THEN '' ELSE ';' + ZAF_SAFRA3 + '(' + RTRIM (CAST (ZAF_PSAFR3 AS NCHAR)) + '%)' END + CASE WHEN ZAF_SAFRA4 = '' THEN '' ELSE ';' + ZAF_SAFRA4 + '(' + RTRIM (CAST (ZAF_PSAFR4 AS NCHAR)) + '%)' END, '') AS GX0039_MAPA_GRANEL_SAFRA,
	CASE ZAF_STOPER  WHEN '1'  THEN 'Em fermentacao Alcoolica'  WHEN '2'  THEN 'Em fermentacao malolatica'  WHEN '3'  THEN 'Bruto'  WHEN '4'  THEN 'Clarificando'  WHEN '5'  THEN 'Clarificado'  WHEN '6'  THEN 'Estabilizado'  WHEN '7'  THEN 'Filtrado'  END  AS GX0039_MAPA_GRANEL_STATUS_OPERACIONAL,
	ISNULL (ZAF_CLASS, '') AS GX0039_MAPA_GRANEL_CLASSIFICACAO,
	CASE ZAF_PADRAO  WHEN '1'  THEN 'Especial'  WHEN '2'  THEN 'Standard'  END  AS GX0039_MAPA_GRANEL_PADRAO,
	ISNULL (ZAF_ACETAL, '') AS GX0039_MAPA_GRANEL_ACETALDEIDO
FROM C LEFT JOIN ZAF010 ZAF ON (ZAF.D_E_L_E_T_ = '' AND ZAF.ZAF_FILIAL = C.GX0039_MAPA_GRANEL_FILIAL AND ZAF.ZAF_ENSAIO = C.GX0039_MAPA_GRANEL_ENSAIO) 



