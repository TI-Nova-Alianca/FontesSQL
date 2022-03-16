SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_DA1010] (@VEVENTO       FLOAT,
                                     @VDA1_FILIAL   VARCHAR(2),
                                     @VDA1_ITEM     VARCHAR(4),
                                     @VDA1_CODTAB   VARCHAR(3),
                                     @VDA1_CODPRO   VARCHAR(15),
                                     @VDA1_GRUPO    VARCHAR(4),
                                     @VDA1_REFGRD   VARCHAR(14),
                                     @VDA1_PRCVEN   FLOAT,
                                     @VDA1_VLRDES   FLOAT,
                                     @VDA1_PERDES   FLOAT,
                                     @VDA1_ATIVO    VARCHAR(1),
                                     @VDA1_FRETE    FLOAT,
                                     @VDA1_ESTADO   VARCHAR(2),
                                     @VDA1_TPOPER   VARCHAR(1),
                                     @VDA1_QTDLOT   FLOAT,
                                     @VDA1_INDLOT   VARCHAR(20),
                                     @VDA1_MOEDA    FLOAT,
                                     @VDA1_DATVIG   VARCHAR(8),
                                     @VD_E_L_E_T_   VARCHAR(1),
                                     @VR_E_C_N_O_   INT,
                                     @VR_E_C_D_E_L_ INT) AS

BEGIN

DECLARE @VDATA             DATETIME;
DECLARE @VERRO             VARCHAR(1000);
DECLARE @VOBJETO           VARCHAR(100) SELECT @VOBJETO = 'MERCP_DA1010';
DECLARE @VCOD_ERRO         VARCHAR(1000);
DECLARE @VINSERE           INT SELECT @VINSERE = 0;
DECLARE @VDB_PRECOP_DTVALI DATETIME;
DECLARE @VDB_PRECOP_DTVALF DATETIME;
DECLARE @VDB_PRECO_CODIGO  VARCHAR(8);
DECLARE @V_SEQ             VARCHAR(7);

---------------------------------------------------------------------
-- VERSAO   DATA        AUTOR            ALTERACAO
-- 1.00001  05/08/2010  SERGIO LUCCHINI  DESENVOLVIMENTO
-- 1.00002  08/04/2016  ALENCAR          RETIRA ESPACOS DO CODIGO DO PRODUTO
-- 1.00003  11/10/2016  ALENCAR          Conversão Nova Aliança
-- 1.00004  01/11/2016  ALENCAR          Integrar apenas listas da filial 01
-- 1.00005  24/02/2017  ALENCAR          Passar a avaliar o campo DB_PRECOP_RECNO para definir o registro a ser atualizado
--                                       Gravar o estado DB_PRECOP_ESTADO = @VDA1_ESTADO
-- 1.00006  09/03/2017  ROBERT           Alterada geracao do DB_PRECOP_SEQ de "ISNULL(MAX(DB_PRECOP_SEQ), 0) + 1" para "ISNULL(MAX(CAST (DB_PRECOP_SEQ AS INT)), 0) + 1"

---------------------------------------------------------------------
BEGIN TRY
	SET @VDB_PRECO_CODIGO = LTRIM(RTRIM(@VDA1_CODTAB));

    IF @VDA1_FILIAL NOT IN ('01')
	BEGIN
	   RETURN;
	END

	IF @VEVENTO = 2  OR @VD_E_L_E_T_ <> ' '
	BEGIN

	   DELETE FROM DB_PRECO_PROD
		WHERE DB_PRECOP_CODIGO  = @VDB_PRECO_CODIGO
		  AND DB_PRECOP_RECNO   = @VR_E_C_N_O_
		  --AND DB_PRECOP_PRODUTO = rtrim(@VDA1_CODPRO)
		  --AND DB_PRECOP_SEQ     = 0;

	END
	ELSE
	BEGIN

	   SELECT @VINSERE = 1
		 FROM DB_PRECO_PROD
		WHERE DB_PRECOP_CODIGO  = @VDB_PRECO_CODIGO
		  AND DB_PRECOP_RECNO   = @VR_E_C_N_O_
		  --AND DB_PRECOP_PRODUTO = rtrim(@VDA1_CODPRO)
		  --AND DB_PRECOP_SEQ     = 0;
	   SET @VCOD_ERRO = @@ERROR;
	   IF @VCOD_ERRO > 0
	   BEGIN
			SET @VINSERE = 0;
	   END

	   -- LOCALIZA A DATA INICIAL E FINAL NO CABECALHO DA LISTA
	   SELECT @VDB_PRECOP_DTVALI = DB_PRECO_DATA_INI, @VDB_PRECOP_DTVALF = DB_PRECO_DATA_FIN
		 FROM DB_PRECO
		WHERE DB_PRECO_CODIGO = @VDB_PRECO_CODIGO;

	   UPDATE DB_PRECO
		  SET DB_PRECO_DESCTO = @VDA1_PERDES
		WHERE DB_PRECO_CODIGO = @VDB_PRECO_CODIGO
		  AND DB_PRECO_ORIG_PREC IS NULL;

	   IF @VINSERE = 0
	   BEGIN

	      --SELECT @V_SEQ = ISNULL(MAX(DB_PRECOP_SEQ), 0) + 1 
		  SELECT @V_SEQ = ISNULL(MAX(CAST (DB_PRECOP_SEQ AS INT)), 0) + 1 
		    FROM DB_PRECO_PROD
		   WHERE DB_PRECOP_CODIGO  = @VDB_PRECO_CODIGO
		     AND DB_PRECOP_PRODUTO = rtrim(@VDA1_CODPRO)

		  INSERT INTO DB_PRECO_PROD
			(
			 DB_PRECOP_CODIGO,    -- 01
			 DB_PRECOP_PRODUTO,   -- 02
			 DB_PRECOP_SEQ,       -- 03
			 DB_PRECOP_VALOR,     -- 04
			 DB_PRECOP_DESCTO,    -- 05
			 DB_PRECOP_SITUACAO,  -- 06
			 DB_PRECOP_DTVALI,    -- 07
			 DB_PRECOP_DTVALF,    -- 08
			 DB_PRECOP_RECNO,     -- 09
			 DB_PRECOP_ESTADO     -- 10
			)
		  VALUES
			(
			 @VDB_PRECO_CODIGO,   -- 01
			 rtrim(@VDA1_CODPRO), -- 02
			 @V_SEQ,              -- 03
			 @VDA1_PRCVEN,        -- 04
			 @VDA1_VLRDES,        -- 05
			 CASE WHEN @VDA1_ATIVO = 1 THEN 'A' ELSE 'I' END,  -- 06
			 @VDB_PRECOP_DTVALI,  -- 07
			 @VDB_PRECOP_DTVALF,  -- 08
			 @VR_E_C_N_O_,        -- 09
			 rtrim(@VDA1_ESTADO)  -- 10
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '1 - ERRO INSERT DB_PRECO_PROD:' + @VDA1_CODTAB + ' ITEM: ' + @VDA1_CODPRO + ' - ERRO BANCO: ' + @VCOD_ERRO;
		  END

	   END
	   ELSE
	   BEGIN

		  UPDATE DB_PRECO_PROD
			 SET DB_PRECOP_VALOR  = @VDA1_PRCVEN,
				 DB_PRECOP_DESCTO = @VDA1_VLRDES,
				 DB_PRECOP_DTVALI = @VDB_PRECOP_DTVALI,
				 DB_PRECOP_DTVALF = @VDB_PRECOP_DTVALF,
				 DB_PRECOP_ESTADO = rtrim(@VDA1_ESTADO)
		   WHERE DB_PRECOP_CODIGO  = @VDB_PRECO_CODIGO
		     AND DB_PRECOP_RECNO   = @VR_E_C_N_O_
			 --AND DB_PRECOP_PRODUTO = rtrim(@VDA1_CODPRO)
			 --AND DB_PRECOP_SEQ     = 0;
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '2 - ERRO UPDATE DB_PRECO_PROD:' + @VDA1_CODTAB + ' ITEM: ' + @VDA1_ITEM + ' - ERRO BANCO: ' + @VCOD_ERRO;
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
