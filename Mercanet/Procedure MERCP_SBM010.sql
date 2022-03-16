SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SBM010] (@VEVENTO     FLOAT,
									@VBM_FILIAL	varchar(2),
									@VBM_GRUPO	varchar(4),
									@VBM_DESC	varchar(30),
									@VBM_PICPAD	varchar(30),
									@VBM_PROORI	varchar(1),
									@VBM_CODMAR	varchar(3),
									@VBM_STATUS	varchar(1),
									@VBM_GRUREL	varchar(40),
									@VBM_TIPGRU	varchar(2),
									@VBM_MARKUP	float,
									@VBM_PRECO	varchar(3),
									@VBM_LENREL	float,
									@VBM_TIPMOV	varchar(1),
									@VD_E_L_E_T_	varchar(1),
									@VR_E_C_N_O_	int,
									@VR_E_C_D_E_L_	int,
									@VBM_CLASGRU	varchar(1),
									@VBM_FORMUL	varchar(6)
                                    ) AS

BEGIN

-------------------------------------------------------------------
--- 1.00001 31/10/2016  ALENCAR     Conversao Nova Alianca
-------------------------------------------------------------------


DECLARE @VDATA     DATETIME;
DECLARE @VCOD_ERRO VARCHAR(1000);
DECLARE @VERRO     VARCHAR(255);
DECLARE @VOBJETO   VARCHAR(15) SELECT @VOBJETO = 'MERCP_SBM010';
DECLARE	@VINSERE   FLOAT SELECT @VINSERE = 0;

BEGIN TRY

   IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '
   BEGIN
      --- Elimina a familia
      DELETE FROM DB_TB_FAMILIA
       WHERE DB_TBFAM_CODIGO = RTRIM(LTRIM(@VBM_GRUPO));

   END
   ELSE
   BEGIN

		SELECT @VINSERE = 1
		  FROM DB_TB_FAMILIA
		 WHERE DB_TBFAM_CODIGO = RTRIM(LTRIM(@VBM_GRUPO));
		SET @VCOD_ERRO = @@ERROR;
		IF @VCOD_ERRO > 0
		BEGIN
			SET @VINSERE = 0;
		END

		IF @VINSERE = 0
		BEGIN
			INSERT INTO DB_TB_FAMILIA
								(
								DB_TBFAM_CODIGO,
								DB_TBFAM_DESCRICAO,
								DB_TBFAM_COD_ORIG           )
							VALUES
								(
								RTRIM(LTRIM(@VBM_GRUPO)),
								RTRIM(LTRIM(@VBM_DESC)),
								RTRIM(LTRIM(@VBM_GRUPO))
								);
			SET @VCOD_ERRO = @@ERROR;
			IF @VCOD_ERRO > 0
			BEGIN
			SET @VERRO = '1 - ERRO INSERT DB_TB_GRUPO:' + @VBM_GRUPO + ' - ERRO BANCO: ' + @VCOD_ERRO;
			END

		END
		ELSE
		BEGIN
			UPDATE DB_TB_FAMILIA
			   SET DB_TBFAM_DESCRICAO = RTRIM(LTRIM(@VBM_DESC))
			 WHERE DB_TBFAM_CODIGO = RTRIM(LTRIM(@VBM_GRUPO));

			SET @VCOD_ERRO = @@ERROR;
			IF @VCOD_ERRO > 0
			BEGIN
			SET @VERRO = '1 - ERRO UPDATE DB_TB_GRUPO:' + @VBM_GRUPO + ' - ERRO BANCO: ' + @VCOD_ERRO;
			END  

		END  -- IF @VINSERE = 0

   END  -- IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '

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
