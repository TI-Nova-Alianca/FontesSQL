SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SX5010] (@VEVENTO     FLOAT,
                                      @VX5_FILIAL  VARCHAR(20),
                                      @VX5_TABELA  VARCHAR(20),
                                      @VX5_CHAVE   VARCHAR(20),
                                      @VX5_DESCRI  VARCHAR(55),
                                      @VX5_DESCSPA VARCHAR(55),
                                      @VX5_DESCENG VARCHAR(55),
                                      @VD_E_L_E_T_ VARCHAR(20),
                                      @VR_E_C_N_O_ FLOAT --,
                                      --@VZX5_46COD  VARCHAR(40),
                                      --@VZX5_46DESC VARCHAR(40)
                                     ) AS

BEGIN

---------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00000  11/10/2016  ALENCAR          CADASTRO DE ESTADOS E RAMO II
---                                        CONVERSAO NOVA ALIANCA
---           19/06/2018  ROBERT           PROMOTORES DEVEM SER BUSCADOS APENAS NA TABELA ZX5
---------------------------------------------------------------------------------------------------------

DECLARE @VOBJETO   VARCHAR(15) SELECT @VOBJETO = 'MERCP_SX5010';
DECLARE @VCOD_ERRO VARCHAR(1000);
DECLARE @VERRO     VARCHAR(255);
DECLARE @VINSERE   FLOAT SELECT @VINSERE = 0;

BEGIN TRY

-- INTEGRACAO DE ESTADOS
IF @VX5_TABELA = '12'
BEGIN

   IF @VEVENTO = 2 OR @VD_E_L_E_T_ <> ' '
   BEGIN

      DELETE FROM DB_TB_ESTADO
       WHERE DB_TBUF_SIGLA = RTRIM(LTRIM(@VX5_CHAVE));

   END
   ELSE
   BEGIN

      SELECT @VINSERE = 1
        FROM DB_TB_ESTADO
       WHERE DB_TBUF_SIGLA = RTRIM(LTRIM(@VX5_CHAVE));
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VINSERE = 0;
      END

      IF @VINSERE = 0
      BEGIN

         INSERT INTO DB_TB_ESTADO
           (
            DB_TBUF_SIGLA,
            DB_TBUF_NOME,
            DB_TBUF_UF,
            DB_TBUF_PAIS
           )
         VALUES
           (
            RTRIM(LTRIM(@VX5_CHAVE)),
            RTRIM(LTRIM(@VX5_DESCRI)),
            RTRIM(LTRIM(@VX5_CHAVE)),
            105  -- BRASIL
           );
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO INSERT DB_TB_ESTADO:' + @VX5_CHAVE + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END

      END
      ELSE
      BEGIN

         UPDATE DB_TB_ESTADO
            SET DB_TBUF_NOME = RTRIM(LTRIM(@VX5_DESCRI)),
                DB_TBUF_PAIS = 105  -- BRASIL
          WHERE DB_TBUF_SIGLA = RTRIM(LTRIM(@VX5_CHAVE));
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO UPDATE DB_TB_ESTADO:' + @VX5_CHAVE + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END

      END  -- IF @VINSERE = 0

   END  -- IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '

END
-- INTEGRACAO DE RAMOS DE ATIVIDADE II
ELSE IF @VX5_TABELA = 'T3' AND @VX5_CHAVE <> ' '
BEGIN

   IF @VEVENTO = 2 OR @VD_E_L_E_T_ <> ' '
   BEGIN

      DELETE DB_TB_RAMO_ATIV
       WHERE DB_TBATV_CODIGO = SUBSTRING(RTRIM(@VX5_CHAVE),1,5)
         AND DB_TBATV_TIPO = 2;

   END
   ELSE
   BEGIN

      SELECT @VINSERE = 1
        FROM DB_TB_RAMO_ATIV
       WHERE DB_TBATV_CODIGO = SUBSTRING(RTRIM(@VX5_CHAVE),1,5);
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
            SUBSTRING(RTRIM(@VX5_CHAVE),1,5),
            SUBSTRING(RTRIM(LTRIM(@VX5_DESCRI)),1,30),
            0,
            1,
            0,
            2
           );
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO INSERT DB_TB_RAMO_ATIV:' + @VX5_CHAVE + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END

      END
      ELSE
      BEGIN

         UPDATE DB_TB_RAMO_ATIV
            SET DB_TBATV_DESCRICAO = SUBSTRING(RTRIM(LTRIM(@VX5_DESCRI)),1,30)
          WHERE DB_TBATV_CODIGO = SUBSTRING(RTRIM(@VX5_CHAVE),1,5);
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO UPDATE DB_TB_RAMO_ATIV:' + @VX5_CHAVE + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END

      END  -- IF @VINSERE = 0

   END  -- IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '

END

/* PROMOTORES DEVEM SER BUSCADOS APENAS NA TABELA ZX5. ROBERT, 19/06/2018
-- INTEGRACAO DE PROMOTORES
ELSE IF @VX5_TABELA = '46' AND @VX5_CHAVE <> ' '
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
*/

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
