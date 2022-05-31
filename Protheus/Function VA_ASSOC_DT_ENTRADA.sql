SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- Descricao: Retorna data de entrada de associado na cooperativa.
-- Autor....: Robert Koch
-- Data.....: 27/07/2012
--
-- Historico de alteracoes:
-- 19/08/2014 - Robert - Nao retornava dados quando data de admissao = data de demissao.
--

ALTER FUNCTION [dbo].[VA_ASSOC_DT_ENTRADA]
(
	@CODIGO   AS VARCHAR(6),
	@LOJA     AS VARCHAR(2),
	@DATAREF  AS VARCHAR(8)
)
RETURNS VARCHAR(8)
AS
BEGIN
	DECLARE @RET AS VARCHAR (8);
	SET @RET = (SELECT ISNULL(
	           (
	               SELECT MAX(ZI_DATA)
	               FROM   SZI010 SZI
	               WHERE  D_E_L_E_T_ = ''
	                      AND ZI_ASSOC = @CODIGO
	                      AND ZI_LOJASSO = @LOJA
	                      AND ZI_DATA <= @DATAREF
	                      AND ZI_TM = '08'
	                      AND NOT EXISTS (
	                              SELECT * -- Se existir desligamento posterior, invalida a entrada.
	                              FROM   SZI010 DESASSOC
	                              WHERE  DESASSOC.D_E_L_E_T_ = ''
	                                     AND DESASSOC.ZI_ASSOC = SZI.ZI_ASSOC
	                                     AND DESASSOC.ZI_LOJASSO = SZI.ZI_LOJASSO
	                                     AND DESASSOC.ZI_DATA > SZI.ZI_DATA
	                                     AND DESASSOC.ZI_DATA < @DATAREF
	                                     AND DESASSOC.ZI_TM = '09'
	                          )
	           ),
	           ''
	));
	
	RETURN @RET;
END

/* versao ate 19/08/2014:
ALTER FUNCTION [dbo].[VA_ASSOC_DT_ENTRADA]
(
	@CODIGO   AS VARCHAR(6),
	@LOJA     AS VARCHAR(2),
	@DATAREF  AS VARCHAR(8)
)
RETURNS VARCHAR(8)
AS
BEGIN
	DECLARE @RET AS VARCHAR (8);
	SET @RET = (SELECT ISNULL(
	           (
	               SELECT MAX(ZI_DATA)
	               FROM   SZI010 SZI
	               WHERE  D_E_L_E_T_ = ''
	                      AND ZI_ASSOC = @CODIGO
	                      AND ZI_LOJASSO = @LOJA
	                      AND ZI_DATA <= @DATAREF
	                      AND ZI_TM = '08'
	                      AND NOT EXISTS (
	                              SELECT * -- Se existir desligamento posterior, invalida a entrada.
	                              FROM   SZI010 DESASSOC
	                              WHERE  DESASSOC.D_E_L_E_T_ = ''
	                                     AND DESASSOC.ZI_ASSOC = SZI.ZI_ASSOC
	                                     AND DESASSOC.ZI_LOJASSO = SZI.ZI_LOJASSO
	                                     AND DESASSOC.ZI_DATA >= SZI.ZI_DATA
	                                     AND DESASSOC.ZI_DATA < @DATAREF
	                                     AND DESASSOC.ZI_TM = '09'
	                          )
	           ),
	           ''
	));
	
	RETURN @RET;
END

*/
GO
