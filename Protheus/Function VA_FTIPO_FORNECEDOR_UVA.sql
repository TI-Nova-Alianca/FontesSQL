SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
-- Descricao: Retorna tipo de fornecedor de uva. Usada inicialmente para separar associados X nao associados.
-- Autor....: Robert Koch
-- Data.....: 23/04/2020
--
-- Historico de alteracoes:
--

ALTER FUNCTION [dbo].[VA_FTIPO_FORNECEDOR_UVA]
(
	@CODIGO   AS VARCHAR(6),
	@LOJA     AS VARCHAR(2),
	@DATAREF  AS VARCHAR(8)
)
RETURNS VARCHAR(13)
AS
BEGIN
	DECLARE @RET AS VARCHAR(13);

	IF (@CODIGO + @LOJA IN ('00136901', '00109401', '00311401'))
		SET @RET = 'PROD PROPRIA'
	ELSE
		IF (dbo.VA_ASSOC_DT_ENTRADA (@CODIGO, @LOJA, @DATAREF) != '')
			SET @RET = 'ASSOCIADO'
		ELSE
			IF (dbo.VA_ASSOC_DT_SAIDA (@CODIGO, @LOJA, @DATAREF) != '')
				SET @RET = 'EX ASSOCIADO'
			ELSE
				SET @RET = 'NAO ASSOCIADO'
	
	RETURN @RET;
END

GO
