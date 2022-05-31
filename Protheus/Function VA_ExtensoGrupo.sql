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

ALTER FUNCTION [dbo].[VA_ExtensoGrupo]
(
	@VALOR DECIMAL(18, 2)
)
RETURNS VARCHAR(255)
AS

BEGIN
	DECLARE @STR_EXT  VARCHAR(255),
	        @AUX      INT,
	        @VALOR_T  INT
	
	SET @STR_EXT = ''
	SET @AUX = 0
	
	SET @VALOR_T = ROUND(@VALOR, 0)
	SET @AUX = @VALOR_T -(@VALOR_T % 100)
	
	
	IF (@VALOR_T = 100)
	    SET @STR_EXT = ' Cem'
	ELSE 
	IF (@AUX = 100)
	    SET @STR_EXT = ' Cento'
	ELSE 
	IF (@AUX = 200)
	    SET @STR_EXT = ' Duzentos'
	ELSE 
	IF (@AUX = 300)
	    SET @STR_EXT = ' Trezentos'
	ELSE 
	IF (@AUX = 400)
	    SET @STR_EXT = ' Quatrocentos'
	ELSE 
	IF (@AUX = 500)
	    SET @STR_EXT = ' Quinhentos'
	ELSE 
	IF (@AUX = 600)
	    SET @STR_EXT = ' Seiscentos'
	ELSE 
	IF (@AUX = 700)
	    SET @STR_EXT = ' Setecentos'
	ELSE 
	IF (@AUX = 800)
	    SET @STR_EXT = ' Oitocentos'
	ELSE 
	IF (@AUX = 900)
	    SET @STR_EXT = ' Novecentos'
	
	IF (
	       ((@VALOR_T - @AUX) <> 0)
	       AND (@AUX <> 0)
	       AND (
	               UPPER(SUBSTRING(RTRIM(@STR_EXT), LEN(RTRIM(@STR_EXT)) -1, 2)) 
	               <> ' E'
	           )
	   )
	    SET @STR_EXT = @STR_EXT + ' e'
	
	SET @AUX = (@VALOR_T % 100) -(@VALOR_T % 10)
	
	IF (@AUX = 10)
	BEGIN
	    SET @AUX = (@VALOR_T % 10)
	    IF (@AUX = 0)
	        SET @STR_EXT = @STR_EXT + ' Dez'
	    ELSE 
	    IF (@AUX = 1)
	        SET @STR_EXT = @STR_EXT + ' Onze'
	    ELSE 
	    IF (@AUX = 2)
	        SET @STR_EXT = @STR_EXT + ' Doze'
	    ELSE 
	    IF (@AUX = 3)
	        SET @STR_EXT = @STR_EXT + ' Treze'
	    ELSE 
	    IF (@AUX = 4)
	        SET @STR_EXT = @STR_EXT + ' Quatorze'
	    ELSE 
	    IF (@AUX = 5)
	        SET @STR_EXT = @STR_EXT + ' Quinze'
	    ELSE 
	    IF (@AUX = 6)
	        SET @STR_EXT = @STR_EXT + ' Dezesseis'
	    ELSE 
	    IF (@AUX = 7)
	        SET @STR_EXT = @STR_EXT + ' Dezessete'
	    ELSE 
	    IF (@AUX = 8)
	        SET @STR_EXT = @STR_EXT + ' Dezoito'
	    ELSE 
	    IF (@AUX = 9)
	        SET @STR_EXT = @STR_EXT + ' Dezenove'
	END
	ELSE
	BEGIN
	    IF (@AUX = 20)
	        SET @STR_EXT = @STR_EXT + ' Vinte'
	    ELSE 
	    IF (@AUX = 30)
	        SET @STR_EXT = @STR_EXT + ' Trinta'
	    ELSE 
	    IF (@AUX = 40)
	        SET @STR_EXT = @STR_EXT + ' Quarenta'
	    ELSE 
	    IF (@AUX = 50)
	        SET @STR_EXT = @STR_EXT + ' Cinquenta'
	    ELSE 
	    IF (@AUX = 60)
	        SET @STR_EXT = @STR_EXT + ' Sessenta'
	    ELSE 
	    IF (@AUX = 70)
	        SET @STR_EXT = @STR_EXT + ' Setenta'
	    ELSE 
	    IF (@AUX = 80)
	        SET @STR_EXT = @STR_EXT + ' Oitenta'
	    ELSE 
	    IF (@AUX = 90)
	        SET @STR_EXT = @STR_EXT + ' Noventa'
	    
	    IF (((@VALOR_T % 10) <> 0))
	    BEGIN
	        IF (
	               (@STR_EXT <> '')
	               AND (
	                       UPPER(SUBSTRING(RTRIM(@STR_EXT), LEN(RTRIM(@STR_EXT)) -1, 2)) 
	                       <> ' E'
	                   )
	           )
	            SET @STR_EXT = @STR_EXT + ' e'
	        
	        SET @AUX = (@VALOR_T % 10)
	        IF (@AUX = 1)
	            SET @STR_EXT = @STR_EXT + ' Um'
	        ELSE 
	        IF (@AUX = 2)
	            SET @STR_EXT = @STR_EXT + ' Dois'
	        ELSE 
	        IF (@AUX = 3)
	            SET @STR_EXT = @STR_EXT + ' Tres'
	        ELSE 
	        IF (@AUX = 4)
	            SET @STR_EXT = @STR_EXT + ' Quatro'
	        ELSE 
	        IF (@AUX = 5)
	            SET @STR_EXT = @STR_EXT + ' Cinco'
	        ELSE 
	        IF (@AUX = 6)
	            SET @STR_EXT = @STR_EXT + ' Seis'
	        ELSE 
	        IF (@AUX = 7)
	            SET @STR_EXT = @STR_EXT + ' Sete'
	        ELSE 
	        IF (@AUX = 8)
	            SET @STR_EXT = @STR_EXT + ' Oito'
	        ELSE 
	        IF (@AUX = 9)
	            SET @STR_EXT = @STR_EXT + ' Nove'
	    END
	END
	RETURN(@STR_EXT);
END
GO
