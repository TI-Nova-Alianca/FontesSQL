-- Descricao: Retorna data de saida de 'fornecedor de uva' na cooperativa.
-- Autor....: Robert Koch
-- Data.....: 04/01/2023
--
-- Historico de alteracoes:
--

ALTER FUNCTION [dbo].[VA_ASSOC_DT_SAIDA_FORN_UVA]
(
	@CODIGO   AS VARCHAR(6),
	@LOJA     AS VARCHAR(2),
	@DATAREF  AS VARCHAR(8)
)
RETURNS VARCHAR(8)
AS
BEGIN
	DECLARE @RET AS VARCHAR(8);
	SET @RET = (
	        SELECT ISNULL(
	                   (
	                       SELECT MAX(ZI_DATA)
	                       FROM   SZI010 SZI
	                       WHERE  D_E_L_E_T_ = ''
	                              AND ZI_ASSOC = @CODIGO
	                              AND ZI_LOJASSO = @LOJA
	                              AND ZI_DATA <= @DATAREF
	                              AND ZI_TM = '40'
	                              AND NOT EXISTS (
	                                      SELECT * -- Se existir filiacao posterior, invalida a saida.
	                                      FROM   SZI010 REASSOC
	                                      WHERE  REASSOC.D_E_L_E_T_ = ''
	                                             AND REASSOC.ZI_ASSOC = SZI.ZI_ASSOC
	                                             AND REASSOC.ZI_LOJASSO = SZI.ZI_LOJASSO
	                                             AND REASSOC.ZI_DATA > SZI.ZI_DATA
	                                             AND REASSOC.ZI_DATA <= @DATAREF
	                                             AND REASSOC.ZI_TM = '39'
	                                  )
	                   ),
	                   ''
	               )
	    );
	
	RETURN @RET;
END

