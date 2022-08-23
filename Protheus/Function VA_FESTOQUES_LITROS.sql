SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[VA_FESTOQUES_LITROS]
-- PARAMETROS DE CHAMADA
(	
	@DATAREF AS VARCHAR(8),
	@FILIALINI AS VARCHAR(2),
	@FILIALFIM AS VARCHAR(2)
)
RETURNS TABLE
AS

RETURN

WITH C AS (
              SELECT B2_FILIAL AS FILIAL, RTRIM(SM0.M0_FILIAL) AS DESCRI_FILIAL,
                     RTRIM (B1_COD) AS PRODUTO,
                     RTRIM(B1_DESC) AS DESCRI_PRODUTO,
                     --SB2.B2_LOCAL AS ALMOX,
                     --RTRIM(SX5_AL.X5_DESCRI) AS DESCRI_LOCAL,
                     CASE SB1.B1_GRPEMB
                          WHEN '18' THEN dbo.VA_SALDOESTQ (SB2.B2_FILIAL, SB2.B2_COD, SB2.B2_LOCAL, @DATAREF) * SB1.B1_LITROS
                          ELSE 0
                     END AS ESTQ_LITROS_GRANEL,
                     CASE SB1.B1_GRPEMB
                          WHEN '18' THEN 0
                          ELSE dbo.VA_SALDOESTQ (SB2.B2_FILIAL, SB2.B2_COD, SB2.B2_LOCAL, @DATAREF) * SB1.B1_LITROS
                     END AS ESTQ_LITROS_ENVASADO
              FROM   SB1010 SB1,
                     SB2010 SB2
                     LEFT JOIN VA_SM0 SM0
                          ON  (
                                  SM0.D_E_L_E_T_ = ''
                                  AND SM0.M0_CODIGO = '01'
                                  AND SM0.M0_CODFIL = SB2.B2_FILIAL
                              )
                     LEFT JOIN SX5010 SX5_AL
                          ON  (
                                  SX5_AL.D_E_L_E_T_ = ''
                                  AND SX5_AL.X5_FILIAL = '  '
                                  AND SX5_AL.X5_TABELA = 'AL'
                                  AND SX5_AL.X5_CHAVE = SB2.B2_LOCAL
                              )
              WHERE  SB2.D_E_L_E_T_ = ''
					 AND SB2.B2_FILIAL IN ('01', '03', '07', '08', '09', '10', '11', '13', '16')	
                     --AND SB2.B2_FILIAL != '02' -- PROBLEMATICA
					 --AND SB2.B2_FILIAL >= '01'
					 --AND SB2.B2_FILIAL <= '16'
                     --AND SB2.B2_LOCAL >= '01'  --Fixos a pedido da Sara - DayRibas
                     --AND SB2.B2_LOCAL <= '99'  --Fixos a pedido da Sara - DayRibas
					 AND SB2.B2_LOCAL IN ('01', '02', '03', '07', '08', '09', '10', '11', '13', '25', '50', '66', '70', '71', '72', '73', '90', '91', '92', '99', '21', '60', '15', '30', '16', '14', '12', '31', '93', '94', '22', '99')
                   
					 AND SB2.B2_COD = SB1.B1_COD
                     AND SB1.D_E_L_E_T_ = ''
                     AND SB1.B1_FILIAL = '  '
                     AND SB1.B1_TIPO IN ('PA', 'PI', 'VD')--Somente os litros - Fixos a pedido da Sara - DayRibas
                     
          )
SELECT 'GERAL' AS GERAL, C.*  , ESTQ_LITROS_GRANEL + ESTQ_LITROS_ENVASADO as ESTQ_LITROS_TOTAL 
FROM   C
WHERE  ESTQ_LITROS_GRANEL != 0
OR ESTQ_LITROS_ENVASADO != 0
GROUP BY C.FILIAL, DESCRI_FILIAL, C.PRODUTO, C.DESCRI_PRODUTO, C.ESTQ_LITROS_GRANEL, C.ESTQ_LITROS_ENVASADO
GO
