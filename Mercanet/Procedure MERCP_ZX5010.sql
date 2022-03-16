SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_ZX5010] (@VEVENTO     FLOAT,
                                      @VZX5_FILIAL VARCHAR(20),
                                      @VZX5_TABELA VARCHAR(20),
                                      @VZX5_CHAVE  VARCHAR(20),
                                      @VZX5_DESCRI VARCHAR(55),
                                      @VZX5_18COD  VARCHAR(20),
                                      @VZX5_18DESC VARCHAR(255),
                                      @VD_E_L_E_T_ VARCHAR(20),
                                      @VR_E_C_N_O_ FLOAT,
                                      @VZX5_39COD  VARCHAR(20),
                                      @VZX5_39DESC VARCHAR(255),
                                      @VZX5_40COD  VARCHAR(20),
                                      @VZX5_40DESC VARCHAR(255),
                                      @VZX5_46COD  VARCHAR(20),
                                      @VZX5_46DESC VARCHAR(255)
                                     ) AS

BEGIN

-----------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00001  11/10/2016  ALENCAR          IMPLEMENTACAO - INTEGRACAO DE RAMOS DE ATIVIDADE I
---  1.00002  31/10/2016  ALENCAR          INTEGRAR CADASTROS DE TIPO DE PRODUTOS E GRUPOS DE PRODUTOS
---  1.00003  22/05/2018  SERGIO LUCCHINI  IMPORTAR O CADASTRO DE PROMOTORES DE VENDA. CHAMADO 81267
-----------------------------------------------------------------------------------------------------------

DECLARE @VOBJETO             VARCHAR(15) SELECT @VOBJETO = 'MERCP_ZX5010';
DECLARE @VCOD_ERRO           VARCHAR(1000);
DECLARE @VERRO               VARCHAR(255);
DECLARE @VINSERE             FLOAT SELECT @VINSERE = 0;
DECLARE @VDB_TBFAM_CODIGO    VARCHAR(8);
DECLARE @VDB_TBFAM_DESCRICAO VARCHAR(60);

BEGIN TRY

-- RAMOS DE ATIVIDADE I
IF @VZX5_TABELA = '18' AND @VZX5_CHAVE <> ' '  -- INTEGRACAO DE RAMOS DE ATIVIDADE I
BEGIN

   IF @VEVENTO = 2 OR @VD_E_L_E_T_ <> ' '
   BEGIN

      DELETE DB_TB_RAMO_ATIV
       WHERE DB_TBATV_CODIGO = SUBSTRING(RTRIM(@VZX5_18COD),1,5)
         AND DB_TBATV_TIPO = 1;

   END
   ELSE
   BEGIN

      SELECT @VINSERE = 1
        FROM DB_TB_RAMO_ATIV
       WHERE DB_TBATV_CODIGO = SUBSTRING(RTRIM(@VZX5_18COD),1,5);
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VINSERE = 0;
      END

      IF @VINSERE = 0
      BEGIN

         INSERT INTO DB_TB_RAMO_ATIV
           (
            DB_TBATV_CODIGO,
            DB_TBATV_DESCRICAO,
            DB_TBATV_SIT,
            DB_TBATV_GMARGEM,
            DB_TBATV_TPVENDA,
            DB_TBATV_TIPO
           )
         VALUES
           (
            SUBSTRING(RTRIM(@VZX5_18COD),1,5),
            SUBSTRING(RTRIM(LTRIM(@VZX5_18DESC)),1,30),
            0,
            1,
            0,
            1
           );
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO INSERT DB_TB_RAMO_ATIV:' + @VZX5_18COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END

      END
      ELSE
      BEGIN

         UPDATE DB_TB_RAMO_ATIV
            SET DB_TBATV_DESCRICAO = SUBSTRING(RTRIM(LTRIM(@VZX5_18DESC)),1,30)
          WHERE DB_TBATV_CODIGO = SUBSTRING(RTRIM(@VZX5_18COD),1,5);
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO UPDATE DB_TB_RAMO_ATIV:' + @VZX5_CHAVE + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END

      END  -- IF @VINSERE = 0

   END  -- IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '

END
-- FIM - RAMOS DE ATIVIDADE I

-- TIPOS DE PRODUTOS
IF @VZX5_TABELA = '40' AND @VZX5_FILIAL = '  '
BEGIN

   IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '
   BEGIN

          DELETE FROM DB_TB_TPPROD
           WHERE DB_TBTPR_CODIGO = SUBSTRING(RTRIM(@VZX5_40COD),1,5);

   END
   ELSE
   BEGIN

      SELECT @VINSERE = 1
        FROM DB_TB_TPPROD
       WHERE DB_TBTPR_CODIGO = SUBSTRING(RTRIM(@VZX5_40COD),1,5);
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VINSERE = 0;
      END

      IF @VINSERE = 0
      BEGIN

         INSERT INTO DB_TB_TPPROD
           (
            DB_TBTPR_CODIGO,
            DB_TBTPR_DESCR,
            DB_TBTPR_COD_ORIG
           )
         VALUES
           (
            SUBSTRING(RTRIM(@VZX5_40COD),1,5),
            SUBSTRING(RTRIM(LTRIM(@VZX5_40DESC)),1,30),
            @VZX5_18COD
           );
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO INSERT DB_TB_TPPROD:' + @VZX5_40COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END

      END
      ELSE
      BEGIN

         UPDATE DB_TB_TPPROD
            SET DB_TBTPR_DESCR = SUBSTRING(RTRIM(LTRIM(@VZX5_40DESC)),1,30)
          WHERE DB_TBTPR_CODIGO = SUBSTRING(RTRIM(@VZX5_40COD),1,5);
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO UPDATE DB_TB_TPPROD:' + @VZX5_40COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END  

      END  -- IF @VINSERE = 0

   END  -- IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '

END
-- FIM - TIPOS DE PRODUTOS

-- GRUPOS DE PRODUTOS
IF @VZX5_TABELA = '39' AND @VZX5_FILIAL = '  '
BEGIN

   IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '
   BEGIN
      -- ELIMINA O GRUPO DE TODAS AS FAMILIAS 
      DELETE FROM DB_TB_GRUPO WHERE DB_GRUPO_COD = SUBSTRING(RTRIM(@VZX5_39COD),1,8);

   END
   ELSE
   BEGIN

      DECLARE @C_FAMILIA CURSOR
          SET @C_FAMILIA = CURSOR STATIC FOR
       SELECT DB_TBFAM_CODIGO, DB_TBFAM_DESCRICAO
         FROM DB_TB_FAMILIA
         OPEN @C_FAMILIA
        FETCH NEXT FROM @C_FAMILIA
         INTO @VDB_TBFAM_CODIGO, @VDB_TBFAM_DESCRICAO
        WHILE @@FETCH_STATUS = 0
       BEGIN

         SELECT @VINSERE = 1
           FROM DB_TB_GRUPO
          WHERE DB_GRUPO_FAMILIA = @VDB_TBFAM_CODIGO
            AND DB_GRUPO_COD = SUBSTRING(RTRIM(@VZX5_39COD),1,8);
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VINSERE = 0;
         END

         IF @VINSERE = 0
         BEGIN

            INSERT INTO DB_TB_GRUPO
              (
               DB_GRUPO_FAMILIA,
               DB_GRUPO_COD,
               DB_GRUPO_DESCRICAO,
               DB_GRUPO_COD_ORIG
              )
            VALUES
              (
               @VDB_TBFAM_CODIGO,
               SUBSTRING(RTRIM(@VZX5_39COD),1,8),
               SUBSTRING(RTRIM(LTRIM(@VZX5_39DESC)),1,35),
               SUBSTRING(RTRIM(@VZX5_39COD),1,30)
              );
            SET @VCOD_ERRO = @@ERROR;
            IF @VCOD_ERRO > 0
            BEGIN
               SET @VERRO = '1 - ERRO INSERT DB_TB_GRUPO:' + @VZX5_39COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
            END

         END
         ELSE
         BEGIN

            UPDATE DB_TB_GRUPO
               SET DB_GRUPO_DESCRICAO = SUBSTRING(RTRIM(LTRIM(@VZX5_39DESC)),1,35)
             WHERE DB_GRUPO_FAMILIA = @VDB_TBFAM_CODIGO
               AND DB_GRUPO_COD = SUBSTRING(RTRIM(@VZX5_39COD),1,8);
            SET @VCOD_ERRO = @@ERROR;
            IF @VCOD_ERRO > 0
            BEGIN
               SET @VERRO = '1 - ERRO UPDATE DB_TB_GRUPO:' + @VZX5_39COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
            END  

         END  -- IF @VINSERE = 0

        FETCH NEXT FROM @C_FAMILIA
         INTO @VDB_TBFAM_CODIGO, @VDB_TBFAM_DESCRICAO
       END
           CLOSE @C_FAMILIA
      DEALLOCATE @C_FAMILIA

   END  -- IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '

END
-- FIM - GRUPOS DE PRODUTOS

-- INTEGRACAO DE PROMOTORES
IF @VZX5_TABELA = '46' AND @VZX5_46COD <> ' '
BEGIN

   IF @VEVENTO = 2 OR @VD_E_L_E_T_ <> ' '
   BEGIN

      DELETE FROM DB_TB_REPRES
       WHERE DB_TBREP_CODIGO = RTRIM(LTRIM(@VZX5_46COD));

   END
   ELSE
   BEGIN

      SELECT @VINSERE = 1
        FROM DB_TB_REPRES
       WHERE DB_TBREP_CODIGO = RTRIM(LTRIM(@VZX5_46COD));
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VINSERE = 0;
      END

      IF @VINSERE = 0
      BEGIN

         INSERT INTO DB_TB_REPRES
           (
            DB_TBREP_CODIGO,
            DB_TBREP_NOME,
            DB_TBREP_COGNOME,
            DB_TBREP_SITUACAO,
            DB_TBREP_CODORIG,
            DB_TBREP_CAD_CLI,
            DB_TBREP_COMPACT,
            DB_TBREP_MEIO_COM,
            DB_TBREP_APL_PROM,
            DB_TBREP_ALT_DESC,
            DB_TBREP_ALT_COMI,
            DB_TBREP_SIT_VENDA,
            DB_TBREP_NOMEFIS
           )
         VALUES
           (
            RTRIM(LTRIM(@VZX5_46COD)),
            SUBSTRING(RTRIM(@VZX5_46DESC),1,40),
            SUBSTRING(RTRIM(@VZX5_46DESC),1,12),
            2,
            @VZX5_46COD,
            1,
            4,
            '2',
            1,
            1,
            1,
            1,
            SUBSTRING(RTRIM(@VZX5_46DESC),1, 40)
           );
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO INSERT PROMOTOR:' + @VZX5_46COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END

      END
      ELSE
      BEGIN

         UPDATE DB_TB_REPRES
            SET DB_TBREP_NOME    = SUBSTRING(RTRIM(@VZX5_46DESC),1,40),
                DB_TBREP_COGNOME = SUBSTRING(RTRIM(@VZX5_46DESC),1,12),
                DB_TBREP_NOMEFIS = SUBSTRING(RTRIM(@VZX5_46DESC),1,40)
          WHERE DB_TBREP_CODIGO = RTRIM(LTRIM(@VZX5_46COD));
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '2 - ERRO UPDATE PROMOTOR:' + @VZX5_46COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END

      END  -- IF @VINSERE = 0

   END  -- IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '

END

IF @VERRO IS NOT NULL
BEGIN

   INSERT INTO DBS_ERROS_TRIGGERS
     (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
   VALUES
     (@VERRO, GETDATE(), @VOBJETO);
END

END TRY

BEGIN CATCH
  SELECT @VERRO = CAST(ERROR_NUMBER() AS VARCHAR) + ERROR_MESSAGE()

  INSERT INTO DBS_ERROS_TRIGGERS
          (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
  VALUES
  (@VERRO, GETDATE(), @VOBJETO);
END CATCH

END
GO
