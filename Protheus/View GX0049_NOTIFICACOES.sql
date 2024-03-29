CREATE   view [dbo].[GX0049_NOTIFICACOES]
AS
    SELECT 
	  CAST(R_E_C_N_O_ as varchar) AS COD
	, ZAB_DTEMIS + ' ' + ZAB_HREMIS AS EMISSAO
	, ZAB_VALID AS DIAS_VALIDADE
	, DATEADD (DAY, ZAB_VALID, CAST (ZAB_DTEMIS + ' ' + ZAB_HREMIS AS DATETIME)) AS DATA_VALIDADE
	, CASE ZAB_TIPO WHEN 'A' THEN 'AVISO' WHEN 'E' THEN 'ERRO' ELSE ZAB_TIPO END AS TIPO
	, CAST(CAST (ZAB_TEXTO AS VARBINARY (8000)) AS VARCHAR (8000)) AS TEXTO
	, RTRIM (ZAB_ORIGEM) AS ORIGEM
	, UPPER (ZAB_DESTIN) AS DESTINATARIO
	, ZAB_LIDO as LIDO
	, '' AS LINK
	, '' AS ICONE
FROM ZAB010
where D_E_L_E_T_ = ''
