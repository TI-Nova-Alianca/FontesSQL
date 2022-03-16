SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_ZAZ010] (@VEVENTO         FLOAT,
										@VZAZ_FILIAL	varchar(2),
										@VZAZ_CLINF	    varchar(6),
										@VZAZ_NLINF	    varchar(30),
										@VD_E_L_E_T_	varchar(1),
										@VR_E_C_N_O_	int
                                    ) AS
BEGIN

DECLARE @VDATA     DATETIME;
DECLARE @VCOD_ERRO VARCHAR(1000);
DECLARE @VERRO     VARCHAR(255);
DECLARE @VOBJETO   VARCHAR(15) SELECT @VOBJETO = 'MERCP_ZAZ010';
DECLARE	@VINSERE   FLOAT SELECT @VINSERE = 0;

BEGIN TRY

   IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '
   BEGIN

      DELETE FROM DB_TB_MARCA
       WHERE DB_TBMAR_CODIGO = SUBSTRING(RTRIM(@VZAZ_CLINF),3,4);

   END
   ELSE
   BEGIN

      SELECT @VINSERE = 1
        FROM DB_TB_MARCA
       WHERE DB_TBMAR_CODIGO = SUBSTRING(RTRIM(@VZAZ_CLINF),3,4);
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VINSERE = 0;
      END

      IF @VINSERE = 0
      BEGIN

         INSERT INTO DB_TB_MARCA
           (
			DB_TBMAR_CODIGO,
			DB_TBMAR_DESCR,
			DB_TBMAR_COD_ERP           )
         VALUES
           (
            SUBSTRING(RTRIM(@VZAZ_CLINF),3,4),
            RTRIM(LTRIM(@VZAZ_NLINF)),
            @VZAZ_CLINF
           );
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO INSERT DB_TB_MARCA:' + @VZAZ_CLINF + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END

      END
      ELSE
      BEGIN

         UPDATE DB_TB_MARCA
            SET DB_TBMAR_DESCR = RTRIM(LTRIM(@VZAZ_NLINF))
          WHERE DB_TBMAR_CODIGO = SUBSTRING(RTRIM(@VZAZ_CLINF),3,4);
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO UPDATE DB_TB_MARCA:' + @VZAZ_CLINF + ' - ERRO BANCO: ' + @VCOD_ERRO;
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
