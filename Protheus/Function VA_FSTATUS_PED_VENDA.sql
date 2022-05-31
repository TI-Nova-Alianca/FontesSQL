SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Cooperativa Vinicola Nova Alianca Ltda
-- Monta string com status de pedidos de venda.
-- Autor: Robert Koch
-- Data:  14/10/2015
-- Historico de alteracoes:
-- 08/11/2017 - Robert  - Verifica camp C5_LIBEROK e tambem conteudo X no C5_VABLOQ
-- 21/02/2020 - Claudia - incluida a verificação de todos os conteudos. Caso tenha mais de um digito no C5_VABLOQ, será impresso 'Bloq.Gerencial'
--
ALTER FUNCTION [dbo].[VA_FSTATUS_PED_VENDA]
(
	@FILIAL VARCHAR (2),
	@PEDIDO VARCHAR (6)
)
RETURNS VARCHAR(24)
AS
BEGIN
	DECLARE @RET AS VARCHAR (24);

SET @RET = (SELECT  CASE
					WHEN SC5.C5_NOTA > '' THEN 'NF ' + SC5.C5_NOTA
					WHEN SC5.C5_LIBEROK != '' AND SC5.C5_VABLOQ = 'P' THEN 'Blq.ger(preco)'
					WHEN SC5.C5_LIBEROK != '' AND SC5.C5_VABLOQ = 'M' THEN 'Blq.ger(margem)'
					WHEN SC5.C5_LIBEROK != '' AND SC5.C5_VABLOQ = 'X' THEN 'Blq.ger(negado)'
					WHEN SC5.C5_LIBEROK != '' AND SC5.C5_VABLOQ = 'N' THEN 'Blq.ger(margem) + % aumento'
					WHEN SC5.C5_LIBEROK != '' AND SC5.C5_VABLOQ = 'A' THEN '% aumento'
					WHEN SC5.C5_LIBEROK != '' AND (CHARINDEX('P', SC5.C5_VABLOQ ) <> 0 OR CHARINDEX('M', SC5.C5_VABLOQ ) <> 0 OR CHARINDEX('X', SC5.C5_VABLOQ ) <> 0 OR CHARINDEX('N', SC5.C5_VABLOQ ) <> 0 OR CHARINDEX('A', SC5.C5_VABLOQ ) <> 0) THEN 'Bloq.Gerencial'
					WHEN SC9.CARGA != '' THEN 'Carga ' + SC9.CARGA
					WHEN SC9.BLCRED > 0 THEN CASE WHEN ( SELECT COUNT(*)
															FROM SZN010 SZN
															WHERE SZN.D_E_L_E_T_ = ''
																AND SZN.ZN_FILIAL = @FILIAL
																AND SZN.ZN_PEDVEND = @PEDIDO
																AND SZN.ZN_CODEVEN = 'SC9002') > 0 THEN 'Blq.cred(credito negado)'
												  ELSE 'Blq.cred'
											  END
					WHEN SC9.BLEST > 0 THEN 'Blq.estq'
					WHEN SC9.BLWMS > 0 THEN 'Blq.WMS'
					WHEN SC9.BLTMS > 0 THEN 'Blq.TMS'
					WHEN SC9.QT_REG_SC9 > 0 THEN 'Lib.coml'
					ELSE 'Novo'
				END  AS STATUS
	FROM SC5010 SC5
	LEFT JOIN (SELECT
			C9_PEDIDO
			,ISNULL(MIN(C9_CARGA), '') AS CARGA
			,ISNULL(SUM(CASE
				WHEN C9_BLCRED NOT IN ('  ', '09', '10') THEN 1
				ELSE 0
			END), 0) AS BLCRED
			,ISNULL(SUM(CASE
				WHEN C9_BLEST NOT IN ('  ', '10') THEN 1
				ELSE 0
			END), 0) AS BLEST
			,ISNULL(SUM(CASE
				WHEN C9_BLWMS <= '05' AND
					C9_BLWMS != '  ' THEN 1
				ELSE 0
			END), 0) AS BLWMS
			,ISNULL(SUM(CASE
				WHEN C9_BLTMS != '  ' THEN 1
				ELSE 0
			END), 0) AS BLTMS
			,ISNULL(COUNT(*), 0) AS QT_REG_SC9
		FROM SC9010 SC9
		WHERE SC9.D_E_L_E_T_ = ''
		AND SC9.C9_FILIAL = @FILIAL
		AND SC9.C9_PEDIDO = @PEDIDO
		GROUP BY C9_PEDIDO) AS SC9
		ON (C9_PEDIDO = SC5.C5_NUM)
	WHERE SC5.D_E_L_E_T_ = ''
	AND SC5.C5_FILIAL = @FILIAL
	AND SC5.C5_NUM = @PEDIDO)

RETURN @RET
END
GO
