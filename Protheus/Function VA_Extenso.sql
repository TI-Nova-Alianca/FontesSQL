SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Descricao: Retorna valor por extenso
-- Autor....: Robert Koch (baseado no script de Elton Bicalho do Carmo, consultado em 06/05/2013 em http://eltonbicalho.blogspot.com.br/2010/01/escrever-um-valor-por-extenso-sql.html)
-- Data.....: 06/05/2013
--
-- Historico de alteracoes:
-- 

ALTER FUNCTION [dbo].[VA_Extenso]
(
	@VALOR DECIMAL(18, 5)
)
RETURNS VARCHAR(255)
AS


BEGIN
	DECLARE @STR_EXT        VARCHAR(255),
	        @FLAG_E         INT,
	        @GRUPO          DECIMAL(10, 2),
	        @MOEDA          VARCHAR(10),
	        @MOEDA_PLURAL   VARCHAR(10),
	        @FLAG_CENTAVOS  DECIMAL(18, 5)
	-- Aqui vc podera configurar a descricao da Moeda
	SET @MOEDA = 'Real'
	SET @MOEDA_PLURAL = 'Reais'
	SET @FLAG_CENTAVOS = 1 -- Exibir os centavos [ 0) Nao 1) Sim ]
	
	SET @STR_EXT = ''
	SET @FLAG_E = 0
	SET @GRUPO = 0
	
	IF ((CONVERT(INT, @VALOR) -(CONVERT(INT, @VALOR) % 1)) = 0)
	BEGIN
	    SET @STR_EXT = ' Zero'
	END
	ELSE
	BEGIN
	    DECLARE @TEMPINT BIGINT
	    SET @TEMPINT = .000001 * (
	            (CONVERT(INT, @VALOR) % 1000000000)
	            -(CONVERT(INT, @VALOR) % 1000000)
	        )
	    
	    SELECT @FLAG_E = FLAG_E,
	           @STR_EXT = STR_EXT
	    FROM   dbo.VA_ExtensoTrataGrupo(@TEMPINT, ' Milhao', ' Milhoes', @FLAG_E, @STR_EXT)
	    
	    SET @TEMPINT = .001 * (
	            (CONVERT(INT, @VALOR) % 1000000) -(CONVERT(INT, @VALOR) % 1000)
	        )
	    
	    SELECT @FLAG_E = FLAG_E,
	           @STR_EXT = STR_EXT
	    FROM   dbo.VA_ExtensoTrataGrupo(@TEMPINT, ' Mil', ' Mil', @FLAG_E, @STR_EXT)
	    
	    SET @TEMPINT = (CONVERT(INT, @VALOR) % 1000)
	    SELECT @FLAG_E = FLAG_E,
	           @STR_EXT = STR_EXT
	    FROM   dbo.VA_ExtensoTrataGrupo(@TEMPINT, '', '', @FLAG_E, @STR_EXT)
	END
	IF (ROUND(@VALOR, 0) = 1)
	BEGIN
	    SET @STR_EXT = @STR_EXT + ' ' + RTRIM(@MOEDA)
	END
	ELSE
	BEGIN
	    IF (ROUND(@VALOR, -6) <> 0)
	       AND (ROUND(@VALOR, 0) - ROUND(@VALOR, -6) = 0)
	        SET @STR_EXT = @STR_EXT + ' de ' + RTRIM(@MOEDA_PLURAL)
	    ELSE
	        SET @STR_EXT = @STR_EXT + ' ' + RTRIM(@MOEDA_PLURAL)
	END
	
	IF (@FLAG_CENTAVOS = 1)
	BEGIN
	    SET @FLAG_E = 1;
	    DECLARE @TEMPINT2 BIGINT
	    SET @TEMPINT2 = 100 * (@VALOR - FLOOR(@VALOR))
	    
	    -- Aqui vc podera mudar a descricao dos centavos
	    SELECT @FLAG_E = FLAG_E,
	           @STR_EXT = STR_EXT
	    FROM   dbo.VA_ExtensoTrataGrupo(@TEMPINT2, ' centavo', ' centavos', @FLAG_E, @STR_EXT)
	END
	
	RETURN(@STR_EXT)
END
GO
