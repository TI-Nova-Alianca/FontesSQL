SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
-- criare consulta em colunas semelhante VA_ACR (para poder ver diversasa OPs

DECLARE @FILIAL_OP1 AS VARCHAR (2) = '01'
DECLARE @FILIAL_OP2 AS VARCHAR (2) = '01'
--DECLARE @OP1 AS VARCHAR (14) = '13782101001'
--DECLARE @OP2 AS VARCHAR (14) = '13009801001' --'13792201001'

-- 2203
DECLARE @OP1 AS VARCHAR (14) = '13771101001'
DECLARE @OP2 AS VARCHAR (14) = '13735901001' -- '13009801001'


;WITH C AS (
SELECT 'PRODUCAO' AS MOVIMENTO
	, CODIGO
	-- TENHO CASOS DE TROCA DE UNIDADE DE MEDIDA, ENTAO VOU TER QUE FAZER UMAS CONVERSOES
	, CASE UN_MEDIDA WHEN 'HR' THEN 'H' WHEN 'LT' THEN 'L' ELSE UN_MEDIDA END AS UN_MEDIDA
	, SUM (CASE WHEN FILIAL = @FILIAL_OP1 AND OP = @OP1 THEN QUANT_REAL ELSE 0 END) AS OP1_QT
	, SUM (CASE WHEN FILIAL = @FILIAL_OP1 AND OP = @OP1 THEN LITROS     ELSE 0 END) AS OP1_LITROS
	, SUM (CASE WHEN FILIAL = @FILIAL_OP1 AND OP = @OP1 THEN CUSTO      ELSE 0 END) AS OP1_CUSTOMEDIO
	, SUM (CASE WHEN FILIAL = @FILIAL_OP2 AND OP = @OP2 THEN QUANT_REAL ELSE 0 END) AS OP2_QT
	, SUM (CASE WHEN FILIAL = @FILIAL_OP2 AND OP = @OP2 THEN LITROS     ELSE 0 END) AS OP2_LITROS
	, SUM (CASE WHEN FILIAL = @FILIAL_OP2 AND OP = @OP2 THEN CUSTO      ELSE 0 END) AS OP2_CUSTOMEDIO
FROM VA_VDADOS_OP
WHERE TIPO_MOVTO = 'P'
AND ((FILIAL = @FILIAL_OP1 AND OP = @OP1) OR (FILIAL = @FILIAL_OP2 AND OP = @OP2))
GROUP BY CODIGO, CASE UN_MEDIDA WHEN 'HR' THEN 'H' WHEN 'LT' THEN 'L' ELSE UN_MEDIDA END
UNION ALL
SELECT 'CONSUMO' AS MOVIMENTO
	, TIPO_PRODUTO
	, CASE UN_MEDIDA WHEN 'HR' THEN 'H' WHEN 'LT' THEN 'L' ELSE UN_MEDIDA END AS UN_MEDIDA
	, SUM (CASE WHEN FILIAL = @FILIAL_OP1 AND OP = @OP1 THEN QUANT_REAL ELSE 0 END) AS OP1_QT
	, SUM (CASE WHEN FILIAL = @FILIAL_OP1 AND OP = @OP1 THEN LITROS     ELSE 0 END) AS OP1_LITROS
	, SUM (CASE WHEN FILIAL = @FILIAL_OP1 AND OP = @OP1 THEN CUSTO      ELSE 0 END) AS OP1_CUSTOMEDIO
	, SUM (CASE WHEN FILIAL = @FILIAL_OP2 AND OP = @OP2 THEN QUANT_REAL ELSE 0 END) AS OP2_QT
	, SUM (CASE WHEN FILIAL = @FILIAL_OP2 AND OP = @OP2 THEN LITROS     ELSE 0 END) AS OP2_LITROS
	, SUM (CASE WHEN FILIAL = @FILIAL_OP2 AND OP = @OP2 THEN CUSTO      ELSE 0 END) AS OP2_CUSTOMEDIO
FROM VA_VDADOS_OP
WHERE TIPO_MOVTO = 'C'
AND ((FILIAL = @FILIAL_OP1 AND OP = @OP1) OR (FILIAL = @FILIAL_OP2 AND OP = @OP2))
GROUP BY TIPO_PRODUTO, CASE UN_MEDIDA WHEN 'HR' THEN 'H' WHEN 'LT' THEN 'L' ELSE UN_MEDIDA END
)
SELECT C.MOVIMENTO
	, C.CODIGO
	, C.UN_MEDIDA
	, C.OP1_QT
	, C.OP2_QT
	, C.OP1_LITROS
	, C.OP2_LITROS
	, C.OP1_CUSTOMEDIO
	, C.OP2_CUSTOMEDIO
	, CASE WHEN OP1_QT > 0 THEN OP1_CUSTOMEDIO / OP1_QT ELSE 0 END AS OP1_CUSTO_UNIT
	, CASE WHEN OP2_QT > 0 THEN OP2_CUSTOMEDIO / OP2_QT ELSE 0 END AS OP2_CUSTO_UNIT
FROM C
ORDER BY MOVIMENTO DESC, CODIGO