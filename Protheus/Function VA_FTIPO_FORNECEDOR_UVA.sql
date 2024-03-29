
--
-- Descricao: Retorna tipo de fornecedor de uva. Usada inicialmente para separar associados X nao associados.
-- Autor....: Robert Koch
-- Data.....: 23/04/2020
--
-- Historico de alteracoes:
-- 04/01/2023 - Robert - Criadas validacoes para 'fornecedor de uva'
--                     - Nao considerava loja 02 do fornecedor 001369 como 'prod.propria'
--

ALTER FUNCTION [dbo].[VA_FTIPO_FORNECEDOR_UVA]
(
	@CODIGO   AS VARCHAR(6),
	@LOJA     AS VARCHAR(2),
	@DATAREF  AS VARCHAR(8)
)
RETURNS VARCHAR(34)
AS
BEGIN
	DECLARE @RET AS VARCHAR(34);

	IF (@CODIGO + @LOJA IN ('00136901', '00136902', '00109401', '00311401'))
		SET @RET = '4-PROD PROPRIA'
	ELSE
		IF (dbo.VA_ASSOC_DT_ENTRADA (@CODIGO, @LOJA, @DATAREF) != '')
			SET @RET = '1-ASSOCIADO'
		ELSE
			IF (dbo.VA_ASSOC_DT_ENTRADA_FORN_UVA (@CODIGO, @LOJA, @DATAREF) != '')
				SET @RET = '2-NAO ASSOCIADO/FORNECEDOR'
			ELSE
				IF (dbo.VA_ASSOC_DT_SAIDA (@CODIGO, @LOJA, @DATAREF) != '')
					SET @RET = '3-EX ASSOCIADO'
				ELSE
					IF (dbo.VA_ASSOC_DT_SAIDA_FORN_UVA (@CODIGO, @LOJA, @DATAREF) != '')
						SET @RET = '5-NAO ASSOCIADO/FORNECEDOR INATIVO'
					ELSE
						SET @RET = '6-NAO FORNECE UVA'
	RETURN @RET;
END



