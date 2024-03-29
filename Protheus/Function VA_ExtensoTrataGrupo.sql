
-- Descricao: Retorna valor por extenso
-- Autor....: Robert Koch (baseado no script de Elton Bicalho do Carmo, consultado em 06/05/2013 em http://eltonbicalho.blogspot.com.br/2010/01/escrever-um-valor-por-extenso-sql.html)
-- Data.....: 06/05/2013
--
-- Historico de alteracoes:
-- 

create FUNCTION [dbo].[VA_ExtensoTrataGrupo]
(
	@GRUPO     DECIMAL(18, 5),
	@SINGULAR  VARCHAR(50),
	@PLURAL    VARCHAR(50),
	@FLAG_E    INT,
	@STR_EXT   VARCHAR(255)
)
RETURNS @RESULTADO TABLE (FLAG_E INT, STR_EXT varchar(250))
AS

BEGIN
	DECLARE @RETORNO  VARCHAR(255),
	        @FLAG     INT
	
	SET @RETORNO = @STR_EXT
	SET @FLAG = @FLAG_E
	
	IF (@GRUPO <> 0)
	BEGIN
	    IF (@FLAG_E = 1)
	        SET @RETORNO = @RETORNO + ' e'
	    
	    SET @FLAG_E = 1
	    SET @RETORNO = @RETORNO + (
	            SELECT dbo.VA_ExtensoGrupo(@GRUPO)
	        )
	    
	    IF (@GRUPO = 1)
	        SET @RETORNO = @RETORNO + @SINGULAR
	    ELSE
	        SET @RETORNO = @RETORNO + @PLURAL
	END
	
	INSERT @RESULTADO
	  (
	    FLAG_E,
	    STR_EXT
	  )
	VALUES
	  (
	    @FLAG,
	    @RETORNO
	  )
	RETURN
END

