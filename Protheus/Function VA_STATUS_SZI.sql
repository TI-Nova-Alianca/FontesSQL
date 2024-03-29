
-- =============================================
-- Author     : Robert Koch
-- Create date: 29/06/2011
-- Description:	Retorna status do associado cfe. tabela SZI (conta corrente)
-- =============================================
ALTER FUNCTION [dbo].[VA_STATUS_SZI]
(
	@ASSOC  AS VARCHAR(6),
	@LOJA   AS VARCHAR(2),
	@DATA   AS VARCHAR(8)
)
RETURNS VARCHAR(1)
AS
BEGIN
	DECLARE @RET VARCHAR(1);
	
	-- VERIFICA MOVIMENTOS DE ASSOCIACAO / DESLIGAMENTO EM TODAS AS FILIAIS.
	SET @RET = ISNULL ((
	        SELECT TOP 1 CASE ZI_TM
	                          WHEN '08' THEN 'S'
	                          ELSE 'N'
	                     END
	        FROM   SZI010
	        WHERE  D_E_L_E_T_ = ''
	               AND ZI_ASSOC = @ASSOC
	               AND ZI_LOJASSO = @LOJA
	               AND ZI_DATA <= @DATA
	               AND ZI_TM IN ('08', '09')
	        ORDER BY
	               ZI_DATA DESC
	    ), 'N')
			
	RETURN @RET
END

