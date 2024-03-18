
-- Rastrear as notas de faturamento de determinado lote, com base nas cargas separada pelo FullWMS
declare @lote varchar (10) = '13744201'

-- COM LOTE CONSIGO LOCALIZAR DENTRO DA FULL O NUMERO DA CARGA
;with separacoes as (
SELECT SUBSTRING(documento_id,6,6) as carga, cod_item, SUM (qtde) as quant
FROM tb_wms_lotes
WHERE lote = @lote
group by SUBSTRING(documento_id,6,6), cod_item
)

-- DENTRO DO PROTHEUS SF2 COM AS CARGAS CONSIGO LOCALIZAR AS NOTAS OU PODERIA USAR OS PEDIDOS CONFORME TABELA DAI
SELECT F2_FILIAL AS FILIAL, F2_CARGA as CARGA_OMS, F2_DOC AS NOTA, F2_SERIE AS SERIE_NOTA, A1_NOME AS CLIENTE, F2_LOJA, F2_EMISSAO
		, SD2.D2_COD, SD2.D2_QUANT AS QT_TOTAL_NF
		, S.quant AS QT_SEPARADA_DESTE_LOTE
 FROM SF2010 SF2, SA1010 SA1, SD2010 SD2, separacoes S
 WHERE F2_CLIENTE = A1_COD
 AND F2_LOJA = A1_LOJA
 AND F2_FILIAL = '01'
 AND SF2.D_E_L_E_T_ = ''
 AND SA1.D_E_L_E_T_ = ''
 AND SD2.D_E_L_E_T_ = ''
 AND SD2.D2_FILIAL = SF2.F2_FILIAL
 AND SD2.D2_DOC = SF2.F2_DOC
 AND SD2.D2_SERIE = SF2.F2_SERIE
 AND F2_CARGA = S.carga
 AND SD2.D2_COD = S.cod_item
 AND SF2.F2_CARGA != ''  -- PARA NAO LER OUTRAS SEPARACOES FEITAS PELO FULL

;

----------------------------------------------------------------------------------------------------
-- Partindo das notas fiscais, buscar os lotes separados pelo Full.
WITH NF_ITEM_CARGA AS (
	SELECT F2_FILIAL AS FILIAL, F2_CARGA as CARGA, F2_DOC AS NOTA, F2_SERIE AS SERIE_NOTA, A1_NOME AS CLIENTE, F2_LOJA, F2_EMISSAO
		, SD2.D2_COD, SD2.D2_QUANT AS QT_TOTAL_NF
	FROM SF2010 SF2
	, SA1010 SA1
	, SD2010 SD2
	 WHERE F2_CLIENTE = A1_COD
		 AND F2_LOJA = A1_LOJA
		 AND F2_FILIAL = '01'
		 AND SF2.D_E_L_E_T_ = ''
		 AND SA1.D_E_L_E_T_ = ''
		 AND SD2.D_E_L_E_T_ = ''
		 AND SD2.D2_FILIAL = SF2.F2_FILIAL
		 AND SD2.D2_DOC = SF2.F2_DOC
		 AND SD2.D2_SERIE = SF2.F2_SERIE
		 AND F2_DOC IN ('000222873')
		-- AND SD2.D2_COD = '0329'
		 AND SF2.F2_CARGA != ''  -- PARA NAO LER OUTRAS SEPARACOES FEITAS PELO FULL
)
, SEPARACOES AS (
	SELECT SUBSTRING(documento_id,6,6) as carga, cod_item, lote, SUM (qtde) as quant
	FROM tb_wms_lotes
	group by SUBSTRING(documento_id,6,6), cod_item, lote
)
SELECT NF_ITEM_CARGA.*, SEPARACOES.lote, SEPARACOES.quant as qt_separada_Full
FROM NF_ITEM_CARGA
	LEFT JOIN SEPARACOES
		ON (SEPARACOES.carga = NF_ITEM_CARGA.CARGA
		AND SEPARACOES.cod_item = NF_ITEM_CARGA.D2_COD)
order by FILIAL, NOTA, D2_COD, NF_ITEM_CARGA.CARGA


select * from tb_wms_lotes
where cod_item = '0358'
and lote = '13491501'
