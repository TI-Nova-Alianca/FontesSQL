
-- Descricao: Converte campos tipo 'image' (tipo 'memo real' do Protheus) para varchar
-- Autor....: Robert Koch
-- Data.....: 05/07/2023
--
-- Historico de alteracoes:
-- 10/07/2023 - Robert - Tratamento para casos que o campo tinha tamanho zero.
--

ALTER FUNCTION [dbo].[VA_FImageToChar]
(
	@IN_IMAGE_ORIGINAL IMAGE
	,@IN_MANTER_QUEBRAS_DE_LINHA VARCHAR (1)
)
RETURNS VARCHAR (MAX)
AS

BEGIN
	DECLARE @RET VARCHAR (MAX)
	DECLARE @TAMANHO INT

	SET @RET = CAST (CAST (@IN_IMAGE_ORIGINAL AS VARBINARY (8000)) AS VARCHAR (8000))

	-- CASO SOLICITADO, TROCA QUEBRAS DE LINHA POR ''.
	IF (UPPER (@IN_MANTER_QUEBRAS_DE_LINHA) != 'S')
		SET @RET = REPLACE(ISNULL(REPLACE (REPLACE ( REPLACE (@RET, char(13), ''), char(10), ''), char(14), ''),''),char(34),' ')

	-- REMOVE O ULTIMO CARACTERE (DEVE SER ALGUM CONTROLE, NUNCA DESCOBRI)
	SET @TAMANHO = LEN (@RET) - 1
	SET @TAMANHO = CASE WHEN @TAMANHO < 0 THEN 0 ELSE @TAMANHO END
	SET @RET = SUBSTRING (@RET, 1, @TAMANHO)

	RETURN @RET;
END

