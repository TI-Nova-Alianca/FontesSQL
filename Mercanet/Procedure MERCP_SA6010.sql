SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SA6010] (@VEVENTO     FLOAT,
                                      @VA6_COD     VARCHAR(3),
                                      @VA6_AGENCIA VARCHAR(5),
                                      @VA6_DVAGE   VARCHAR(1),
                                      @VA6_NUMCON  VARCHAR(10),
                                      @VA6_DVCTA   VARCHAR(1),
                                      @VA6_NOME    VARCHAR(40),
                                      @VA6_FILIAL  VARCHAR(6)
                                     ) AS

BEGIN

DECLARE @VOBJETO        VARCHAR(15) SELECT @VOBJETO = 'MERCP_SA6010';
DECLARE @VDATA          DATETIME;
DECLARE @VCOD_ERRO      VARCHAR(1000);
DECLARE @VERRO          VARCHAR(255);
DECLARE	@VINSERE        FLOAT SELECT @VINSERE = 0;
DECLARE @VDB_TBPORT_COD INT SELECT @VDB_TBPORT_COD = 0;

---------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00001  16/01/2015  SERGIO LUCCHINI  DESENVOLVIMENTO
---  1.00002  24/08/2016  ALENCAR          CONVERSAO FINI
---  1.00003  11/10/2016  Alencar          Conversão Nova Aliança
---  1.00004  09/01/2017  Alencar          Importar apenas cadastros da Filial 01
---------------------------------------------------------------

IF @VA6_FILIAL <> '01'
BEGIN
   RETURN;
END


IF @VEVENTO = 2
BEGIN

   DELETE FROM DB_TB_PORT WHERE DB_TBPORT_CODORIG = @VA6_COD;

END
ELSE
BEGIN

   -- DE / PARA DO PORTADOR
   SELECT @VINSERE = 1, @VDB_TBPORT_COD = DB_TBPORT_COD
     FROM DB_TB_PORT
    WHERE DB_TBPORT_CODORIG = @VA6_COD;

   IF ISNULL(@VDB_TBPORT_COD,0) = 0
   BEGIN

      SELECT @VDB_TBPORT_COD = MAX(DB_TBPORT_COD) + 1 FROM DB_TB_PORT;

      IF ISNULL(@VDB_TBPORT_COD,0) = 0
      BEGIN
         SET @VDB_TBPORT_COD = 1;
      END

   END

   IF @VINSERE = 0
   BEGIN

      INSERT INTO DB_TB_PORT
        (
         DB_TBPORT_COD,
         DB_TBPORT_DESCR,
         DB_TBPORT_MODALID,
         DB_TBPORT_CODORIG,
         DB_TBPORT_EMPRESA,
         DB_TBPORT_CTACONT,
         DB_TBPORT_REPRES
        )
      VALUES
        (
         @VDB_TBPORT_COD,
         SUBSTRING(RTRIM(LTRIM(@VA6_NOME)),1,30),
         '',
         @VA6_COD,
         NULL,
         @VA6_NUMCON,
         NULL
        );
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VERRO = '1 - ERRO INSERT DB_TB_PORT:' + CAST(@VA6_COD AS VARCHAR) + ' - ERRO BANCO: ' + @VCOD_ERRO;
      END  

   END
   ELSE
   BEGIN

      UPDATE DB_TB_PORT 
         SET DB_TBPORT_DESCR   = SUBSTRING(RTRIM(LTRIM(@VA6_NOME)),1,30),
             DB_TBPORT_CTACONT = @VA6_NUMCON
       WHERE DB_TBPORT_COD     = @VDB_TBPORT_COD;
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VERRO = '1 - ERRO UPDATE DB_TB_PORT:' + @VA6_COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
      END  

   END

END

IF @VERRO IS NOT NULL
BEGIN
   SET @VDATA = GETDATE();
   INSERT INTO DBS_ERROS_TRIGGERS
     (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
   VALUES
     (@VERRO, @VDATA, @VOBJETO);
END
END
GO
