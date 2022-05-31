SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author     : Robert Koch
-- Create date: 26/07/2011
-- Description:	Recebe valor e retorna string formatada com separador de milhar e decimal.
-- =============================================
-- Adaptacao do codigo encontrado em http://sqlcomoumtodo.wordpress.com/2008/09/08/funcao-de-formatacao-de-numeros/
-- Creditos: Helder

ALTER FUNCTION [dbo].[FormataValor]
(
	@Valor  DECIMAL(20, 10),
	@qtdec  INT,
	@tamtot int
)
RETURNS VARCHAR(100)
AS

BEGIN
	DECLARE @inteiro     VARCHAR(98),
	        @Texto       VARCHAR(100),
	        @decimal     VARCHAR(100),
	        @retorno     VARCHAR(100),
	        @SepMilhar   CHAR(1),
	        @SepDecimal  CHAR(1),
	        @vazios VARCHAR (100),
	        @asteriscos VARCHAR (100)
	
	SET @SepMilhar = '.';
	SET @SepDecimal = ',';
	SET @Texto = RTRIM(CAST(@Valor AS VARCHAR(50)))
	SET @inteiro = CAST(CAST(@Valor AS INTEGER) AS VARCHAR(180))
	SET @decimal = SUBSTRING(@Texto, LEN(@inteiro) + 2, @qtdec)
	SET @retorno = ''
	
	WHILE (LEN(@inteiro) > 3)
	BEGIN
	    SET @retorno = @SepMilhar + SUBSTRING(@inteiro, LEN(@inteiro) -2, 3) + @retorno
	    SET @inteiro = SUBSTRING(@inteiro, 1, LEN(@inteiro) -3)
	END
	
	SET @retorno = @inteiro + @retorno
	if (@qtdec > 0)
		SET @retorno = @retorno + @SepDecimal + @decimal

	IF (@tamtot > 0)
	begin
		SET @vazios = '                                                                        ';
		SET @asteriscos = '************************************************************************';
		IF (LEN (@retorno) > @tamtot)
			SET @retorno = SUBSTRING (@asteriscos, 1, @tamtot);
		else
			SET @retorno = SUBSTRING (@vazios, 1, @tamtot - LEN (@retorno)) + @retorno;
		end
	RETURN @retorno
END;
GO
