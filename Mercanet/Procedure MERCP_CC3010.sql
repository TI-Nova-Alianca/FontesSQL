SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_CC3010] (@VEVENTO     FLOAT,
                                     @VCC3_FILIAL  VARCHAR(20),
									 @VCC3_COD     VARCHAR(15),
                                     @VCC3_DESC    VARCHAR(50),
                                     @VD_E_L_E_T_  VARCHAR(20),
                                     @VR_E_C_N_O_  FLOAT
                                    ) AS

BEGIN

-------------------------------------------------------------------
--- 1.00001 13/03/2017  ALENCAR     Implementação - Classificacao Comercial do Cliente
-------------------------------------------------------------------


DECLARE @VDATA     DATETIME;
DECLARE @VCOD_ERRO VARCHAR(1000);
DECLARE @VERRO     VARCHAR(255);
DECLARE @VOBJETO   VARCHAR(15) SELECT @VOBJETO = 'MERCP_CC3010';
DECLARE	@VINSERE   FLOAT SELECT @VINSERE = 0;

BEGIN TRY

	   IF @VEVENTO = 2 OR @VD_E_L_E_T_ <> ' '
	   BEGIN
	      DELETE DB_TB_CLASS_COM
		   WHERE DB_TBCLS_CODIGO = @VCC3_COD;

	   END
	   ELSE
	   BEGIN

		  SELECT @VINSERE = 1
			FROM DB_TB_CLASS_COM
		   WHERE DB_TBCLS_CODIGO = @VCC3_COD;
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VINSERE = 0;
		  END

		  IF @VINSERE = 0
		  BEGIN

			 INSERT INTO DB_TB_CLASS_COM
			   (
				DB_TBCLS_CODIGO ,
                DB_TBCLS_DESCRICAO
			   )
			 VALUES
			   (
				@VCC3_COD,
				SUBSTRING(RTRIM(LTRIM(@VCC3_DESC)),1,40)
			   );
			 SET @VCOD_ERRO = @@ERROR;
			 IF @VCOD_ERRO > 0
			 BEGIN
				SET @VERRO = '1 - ERRO INSERT DB_TB_CLASS_COM:' + @VCC3_COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
			 END

		  END
		  ELSE
		  BEGIN

			 UPDATE DB_TB_CLASS_COM
				SET DB_TBCLS_DESCRICAO = SUBSTRING(RTRIM(LTRIM(@VCC3_DESC)),1,40)
			  WHERE DB_TBCLS_CODIGO = @VCC3_COD;
			 SET @VCOD_ERRO = @@ERROR;
			 IF @VCOD_ERRO > 0
			 BEGIN
				SET @VERRO = '1 - ERRO UPDATE DB_TB_CLASS_COM:' + @VCC3_COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
			 END

		  END  -- IF @VINSERE = 0

	   END  -- IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '

	IF @VERRO IS NOT NULL
	BEGIN
	   SET @VDATA = GETDATE();
	   INSERT INTO DBS_ERROS_TRIGGERS
		 (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
	   VALUES
		 (@VERRO, @VDATA, @VOBJETO);
	END

END TRY

BEGIN CATCH
   SELECT @VERRO = cast(ERROR_NUMBER() as varchar) + ERROR_MESSAGE()

   INSERT INTO DBS_ERROS_TRIGGERS
  		(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
		VALUES
  		( @VERRO, getdate(), @VOBJETO );			
END CATCH

END
GO
