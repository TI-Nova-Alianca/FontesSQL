SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SYA010] (@VEVENTO     FLOAT,
									@VYA_FILIAL	varchar(2),
									@VYA_CODGI	varchar(3),
									@VYA_DESCR	varchar(25),
									@VYA_SIGLA	varchar(3),
									@VYA_IDIOMA	varchar(25),
									@VYA_NOIDIOM	varchar(25),
									@VYA_DINALAD	varchar(4),
									@VYA_NALADI	varchar(1),
									@VYA_ALADI	varchar(1),
									@VYA_COMUM	varchar(1),
									@VYA_MERCOSU	varchar(1),
									@VYA_SGPC	varchar(1),
									@VYA_LI	varchar(1),
									@VYA_PAIS_I	varchar(25),
									@VYA_ABICS	varchar(3),
									@VYA_SISEXP	varchar(4),
									@VYA_CODRIEX	varchar(25),
									@VD_E_L_E_T_	varchar(1),
									@VR_E_C_N_O_	int,
									@VR_E_C_D_E_L_	int,
									@VYA_CODFIES	varchar(3),
									@VYA_SGLMEX	varchar(2),
									@VYA_NASCIO	varchar(40),
									@VYA_CODERP	varchar(3)
                                    ) AS

BEGIN

DECLARE @VDATA     DATETIME;
DECLARE @VCOD_ERRO VARCHAR(1000);
DECLARE @VERRO     VARCHAR(255);
DECLARE @VOBJETO   VARCHAR(15) SELECT @VOBJETO = 'MERCP_SX5010';
DECLARE	@VINSERE   FLOAT SELECT @VINSERE = 0;

-------------------------------------------------------------------
--- 1.00001 11/10/2016  ALENCAR     Conversão Nova Aliança
-------------------------------------------------------------------


BEGIN TRY

   IF @VYA_CODGI = ' ' 
   BEGIN
      RETURN;
   END

   IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '
   BEGIN

      DELETE FROM DB_TB_PAIS  
       WHERE db_pais_sigla = RTRIM(LTRIM(@VYA_CODGI));
   END
   ELSE
   BEGIN

      SELECT @VINSERE = 1
        FROM DB_TB_PAIS
       WHERE DB_PAIS_SIGLA = RTRIM(LTRIM(@VYA_CODGI));
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VINSERE = 0;
      END

      IF @VINSERE = 0
      BEGIN

         INSERT INTO DB_TB_PAIS
           (
            DB_PAIS_SIGLA,
            DB_PAIS_NOME,
            DB_PAIS_ABREV
           )
         VALUES
           (
            RTRIM(LTRIM(@VYA_CODGI)),
            RTRIM(LTRIM(@VYA_DESCR)),
            SUBSTRING(LTRIM(LTRIM(@VYA_DESCR)), 1, 20)
           );
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO INSERT DB_TB_PAIS:' + @VYA_CODGI + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END

      END
      ELSE
      BEGIN

         UPDATE DB_TB_PAIS
            SET DB_PAIS_NOME = RTRIM(LTRIM(@VYA_DESCR))
			  , DB_PAIS_ABREV  = SUBSTRING(RTRIM(LTRIM(@VYA_DESCR)), 1, 20)
          WHERE DB_PAIS_SIGLA = RTRIM(LTRIM(@VYA_CODGI));
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO UPDATE DB_TB_PAIS:' + @VYA_CODGI + ' - ERRO BANCO: ' + @VCOD_ERRO;
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
