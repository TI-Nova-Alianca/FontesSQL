ALTER FUNCTION [DBO].[MERCF_PIECE](@PLISTA     VARCHAR(3000),
									  @PDELIMITADOR VARCHAR(5),
									  @PPOSICAO     NUMERIC ) RETURNS VARCHAR(255)
	BEGIN
	DECLARE @VSTRING VARCHAR(2000)
	DECLARE @VIND    INT SELECT @VIND = 1
	DECLARE @VPOSCOR NUMERIC
	------------------------------------------------------------------------------------------------------------------
	---  VERSAO    DATA        AUTOR            ALTERACAO                                                          ---
	---  1.000000  11/01/2010  SERGIO LUCCHINI  DESENVOLVIMENTO                                                    ---
	---  1.000001  05/20/2013  tiago pradella   aumentado tamanho do campo da lista                                ---
	------------------------------------------------------------------------------------------------------------------
	IF @PLISTA IS NULL
	BEGIN
	   SET @VSTRING = NULL;
	END
	IF @PLISTA IS NOT NULL
	BEGIN
	   IF PATINDEX('%'+@PDELIMITADOR+'%',@PLISTA) = 0
	   BEGIN
		  IF @PPOSICAO = 1
		  BEGIN
			 SET @VSTRING = @PLISTA;
		  END
		  ELSE
		  BEGIN
			 SET @VSTRING = NULL;
		  END
	   END
	   IF @VSTRING IS NULL
	   BEGIN
		  SET @VSTRING = '';
		  SET @VPOSCOR = 1;
		  WHILE @VIND <= LEN(@PLISTA)
		  BEGIN
			IF SUBSTRING(@PLISTA, @VIND, LEN(@PDELIMITADOR)) = @PDELIMITADOR
			BEGIN
			   SET @VPOSCOR = @VPOSCOR + 1;
			END
			ELSE IF @PPOSICAO = @VPOSCOR
			BEGIN
			   SET @VSTRING = @VSTRING + SUBSTRING(@PLISTA,@VIND,1);
			END
			SET @VIND = @VIND + 1
		  END  -- WHILE @VIND <= LEN(@PLISTA)
	   END  -- IF @VSTRING IS NULL
	END  -- IF @PLISTA IS NOT NULL
	RETURN @VSTRING;
	END
