SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_CC2010] (@VEVENTO       FLOAT,
                                     @VCC2_FILIAL   VARCHAR(2),
                                     @VCC2_EST      VARCHAR(2),
                                     @VCC2_CODMUN   VARCHAR(5),
                                     @VCC2_MUN      VARCHAR(60),
                                     @VD_E_L_E_T_   VARCHAR(1),
                                     @VR_E_C_N_O_   INT,
                                     @VR_E_C_D_E_L_ INT) AS

BEGIN

DECLARE @VDATA     DATETIME;
DECLARE @VERRO     VARCHAR(1000);
DECLARE @VOBJETO   VARCHAR(100) SELECT @VOBJETO = 'MERCP_CC2010';
DECLARE @VCOD_ERRO VARCHAR(1000);
DECLARE @VINSERE   INT SELECT @VINSERE = 0;

---------------------------------------------------------------------
-- VERSAO   DATA        AUTOR            ALTERACAO
-- 1.00001  09/08/2010  SERGIO LUCCHINI  DESENVOLVIMENTO
-- 1.00001  11/10/2016  ALENCAR          Conversão Nova Aliança
---------------------------------------------------------------------
BEGIN TRY
	IF @VEVENTO = 2
	BEGIN

		DELETE FROM DB_TB_CIDADE WHERE DB_TBCID_COD = RTRIM(LTRIM(@VCC2_EST)) + RTRIM(LTRIM(@VCC2_CODMUN));

	END
	ELSE
	BEGIN

		SELECT @VINSERE = 1
			FROM DB_TB_CIDADE
		WHERE DB_TBCID_COD = RTRIM(LTRIM(@VCC2_EST)) + RTRIM(LTRIM(@VCC2_CODMUN));
		SET @VCOD_ERRO = @@ERROR;
		IF @VCOD_ERRO > 0
		BEGIN
			SET @VINSERE = 0;
		END

		IF @VINSERE = 0
		BEGIN

			INSERT INTO DB_TB_CIDADE
			(
				DB_TBCID_COD,      -- 00
				DB_TBCID_NOME,     -- 01
				DB_TBCID_ESTADO,   -- 02
				DB_TBCID_PAIS,     -- 03
				DB_TBCID_CEP_INI,  -- 04
				DB_TBCID_CEP_FIM   -- 05
			)
			VALUES
			(
				SUBSTRING(RTRIM(LTRIM(@VCC2_EST)) + RTRIM(LTRIM(@VCC2_CODMUN)),1,8),  -- 00
				SUBSTRING(@VCC2_MUN,1,30),    -- 01
				SUBSTRING(@VCC2_EST,1,8),     -- 02
				'105',                        -- 03
				0,                            -- 04
				0                             -- 05
			);
			SET @VCOD_ERRO = @@ERROR;
			IF @VCOD_ERRO > 0
			BEGIN
				SET @VERRO = '1 - ERRO INSERT DB_TB_CIDADE:' + @VCC2_CODMUN + ' - ERRO BANCO: ' + @VCOD_ERRO;
			END

		END
		ELSE
		BEGIN

			UPDATE DB_TB_CIDADE
				SET DB_TBCID_NOME   = SUBSTRING(@VCC2_MUN,1,30),
					DB_TBCID_ESTADO = SUBSTRING(@VCC2_EST,1,8)
			WHERE DB_TBCID_COD = RTRIM(LTRIM(@VCC2_EST)) + RTRIM(LTRIM(@VCC2_CODMUN));
			SET @VCOD_ERRO = @@ERROR;
			IF @VCOD_ERRO > 0
			BEGIN
			SET @VERRO = '2 - ERRO UPDATE DB_TB_CIDADE:' + @VCC2_CODMUN + ' - ERRO BANCO: ' + @VCOD_ERRO;
			END

		END

	END;

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
