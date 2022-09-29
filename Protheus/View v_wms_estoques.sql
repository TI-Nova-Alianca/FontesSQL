SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[v_wms_estoques]
AS
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para integracao de cadastro com o FullWMS.
-- Autor: Robert Koch
-- Data:  21/11/2014
-- Historico de alteracoes:
-- 28/05/2018 - Robert - Exporta local 02 para integracao com almox. 02
-- 27/09/2022 - Robert - Passa a exportar saldo dos almox.01+91
--

SELECT
	RTRIM(B2_COD) AS CodItem
	,'' AS Lote
	,sum (B2_QATU) AS Qtde
	,'1' AS TpEst
	,0 AS Custo
	,1 AS Empresa
	,1 AS CD
FROM SB2010 SB2
	,SB1010 SB1
WHERE SB2.D_E_L_E_T_ = ''
AND B2_FILIAL = '01'
AND B2_LOCAL IN ('01', '91')
AND SB1.D_E_L_E_T_ = ''
AND SB1.B1_FILIAL = '  '
AND SB1.B1_COD = SB2.B2_COD
AND SB1.B1_VAFULLW = 'S'
GROUP BY B2_COD
GO
