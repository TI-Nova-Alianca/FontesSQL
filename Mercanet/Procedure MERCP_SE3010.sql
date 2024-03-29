ALTER PROCEDURE [dbo].[MERCP_SE3010](@VEVENTO        FLOAT
								  , @VE3_FILIAL    VARCHAR(50)
								  , @VE3_VEND      VARCHAR(50)
								  , @VE3_NUM       VARCHAR(50)
								  , @VE3_EMISSAO   VARCHAR(50)
								  , @VE3_SERIE     VARCHAR(50)
								  , @VE3_CODCLI    VARCHAR(50)
								  , @VE3_LOJA      VARCHAR(50)
								  , @VE3_BASE	   FLOAT
								  , @VE3_PORC	   FLOAT
								  , @VE3_COMIS	   FLOAT
								  , @VE3_DATA	   VARCHAR(50)
								  , @VE3_PREFIXO   VARCHAR(50)
								  , @VE3_PARCELA   VARCHAR(50)
								  , @VE3_TIPO      VARCHAR(50)
								  , @VE3_BAIEMI    VARCHAR(50)
								  , @VE3_PEDIDO    VARCHAR(50)
								  , @VE3_SEQ       VARCHAR(50)
								  , @VE3_ORIGEM    VARCHAR(50)
								  , @VE3_VENCTO    VARCHAR(50)
								  , @VD_E_L_E_T_   VARCHAR(50)
								  , @VR_E_C_N_O_   FLOAT

                                    ) AS

BEGIN

DECLARE @VDATA            DATETIME;
DECLARE @VCOD_ERRO        VARCHAR(1000);
DECLARE @VERRO            VARCHAR(255);
DECLARE @VOBJETO          VARCHAR(15) SELECT @VOBJETO = 'MERCP_SE3010';
DECLARE	@VINSERE          FLOAT SELECT @VINSERE = 0;
DECLARE @VDB_TBREP_CODIGO NUMERIC;
DECLARE @VEMPRESA	      VARCHAR(3);
DECLARE @VDB_TBPORT_COD   INT SELECT @VDB_TBPORT_COD = 0;
DECLARE @VANO_MES         VARCHAR(7);

-------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00001  03/06/2016  ALENCAR          DESENVOLVIMENTO - Rotina de integracao de comissoes
---  1.00002  26/08/2016  ALENCAR          Somente integra comissoes ja calculadas E3_DATA possui valor informado 
---                                        Gravar o novo campo DB_COM_EMPRESA
---  1.00003  05/10/2016  ALENCAR          Alteracoes para gravar informacoes detalhadas da comissao
---  1.00004  31/10/2016  ALENCAR          Conversao Nova Alianca
-------------------------------------------------------------------------
BEGIN TRY

	IF @VE3_LOJA IN ('SU', 'R:', 'A')
		OR @VE3_CODCLI LIKE ('%A%')
		OR @VE3_CODCLI LIKE ('%F%')
		OR @VE3_FILIAL NOT IN ('01')
	BEGIN
	   RETURN;
	END

	
	SET @VEMPRESA = SUBSTRING(RTRIM(LTRIM(@VE3_FILIAL)), 1, 2)
	SET @VANO_MES = SUBSTRING (@VE3_DATA, 1, 6)


	-- DE/PARA DE REPRESENTANTES
	SELECT @VDB_TBREP_CODIGO = DB_TBREP_CODIGO
	  FROM DB_TB_REPRES
	 WHERE DB_TBREP_CODORIG = RTRIM(LTRIM(@VE3_VEND));
	SET @VCOD_ERRO = @@ERROR;
	IF @VCOD_ERRO > 0
	BEGIN
	   SET @VDB_TBREP_CODIGO = 0;
	END

	IF @VD_E_L_E_T_ <> ' '
	BEGIN

	   DELETE FROM DB_COMISSAO
		WHERE DB_COM_REPRES   = @VDB_TBREP_CODIGO
		  AND DB_COM_ANOMES   = @VANO_MES
		  AND DB_COM_ESPECIE  = LTRIM(RTRIM(@VE3_TIPO))
		  AND DB_COM_DOCTO    = RTRIM(@VE3_NUM) + '-' + RTRIM(@VE3_PARCELA)
	   SET @VCOD_ERRO = @@ERROR;
	   IF @VCOD_ERRO > 0
	   BEGIN
		 SET @VERRO = '1 - ERRO DELETE DB_COMISSAO:' + @VE3_NUM + ' - ERRO BANCO: ' + @VCOD_ERRO;
	   END

	END
	ELSE
	BEGIN

	   SELECT @VINSERE = 1
		 FROM DB_COMISSAO
		WHERE DB_COM_REPRES   = ISNULL(@VDB_TBREP_CODIGO, 0)
		  AND DB_COM_ANOMES   = @VANO_MES
		  AND DB_COM_ESPECIE  = LTRIM(RTRIM(@VE3_TIPO))
		  AND DB_COM_DOCTO    = RTRIM(@VE3_NUM)
		  AND DB_COM_PARCELA  = RTRIM(@VE3_PARCELA);

	   IF @VINSERE = 0
	   BEGIN

		  INSERT INTO DB_COMISSAO
			(
			 DB_COM_REPRES,      -- 01
			 DB_COM_ANOMES,      -- 02
			 DB_COM_ESPECIE,     -- 03
			 DB_COM_DOCTO,       -- 04
			 DB_COM_PARCELA,     -- 05
			 DB_COM_CLIENTE,     -- 06
			 DB_COM_DATA_EMIS,   -- 07
			 DB_COM_DATA_VCTO,   -- 08
			 DB_COM_DATA_PGTO,   -- 09
			 DB_COM_BASE_CALC,   -- 10
			 DB_COM_PERC_COMIS,  -- 11
			 DB_COM_VLR_COMIS,   -- 12
			 DB_COM_EMPRESA     -- 13
			 --DB_COM_PREFIXO_FINI,-- 14
			 --DB_COM_PEDIDO_FINI  -- 15
			)
		  VALUES
			(
			 ISNULL(@VDB_TBREP_CODIGO, 0),                  -- 01
			 @VANO_MES,                                     -- 02
			 LTRIM(RTRIM(@VE3_TIPO)),                       -- 03
			 RTRIM(@VE3_NUM),                               -- 04
			 RTRIM(@VE3_PARCELA),                           -- 05
			 @VE3_CODCLI,                                  -- 06
			 CONVERT(CHAR,RTRIM(LTRIM(@VE3_EMISSAO)),103),  -- 07
			 CONVERT(CHAR,RTRIM(LTRIM(@VE3_VENCTO)),103),   -- 08
			 CONVERT(CHAR,RTRIM(LTRIM(@VE3_DATA)),103),     -- 09
			 @VE3_BASE,                                     -- 10
			 @VE3_PORC,                                     -- 11
			 @VE3_COMIS,                                    -- 12
			 @VEMPRESA                                     -- 13
			 --@VE3_PREFIXO,                                  -- 14
			 --@VE3_PEDIDO                                    -- 15
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '1 - ERRO INSERT DB_COMISSAO:' + @VE3_NUM + ' - ERRO BANCO: ' + @VCOD_ERRO;
		  END

	   END
	   ELSE
	   BEGIN

		  UPDATE DB_COMISSAO
			 SET DB_COM_CLIENTE      = @VE3_CODCLI
			   , DB_COM_DATA_EMIS    = CONVERT(CHAR,RTRIM(LTRIM(@VE3_EMISSAO)),103)
			   , DB_COM_DATA_VCTO    = CONVERT(CHAR,RTRIM(LTRIM(@VE3_VENCTO)),103)
			   , DB_COM_DATA_PGTO    = CONVERT(CHAR,RTRIM(LTRIM(@VE3_DATA)),103)
			   , DB_COM_BASE_CALC    = @VE3_BASE
			   , DB_COM_PERC_COMIS   = @VE3_PORC
			   , DB_COM_VLR_COMIS    = @VE3_COMIS
			   , DB_COM_EMPRESA      = @VEMPRESA
			   --, DB_COM_PREFIXO_FINI = @VE3_PREFIXO
			  -- , DB_COM_PEDIDO_FINI  = @VE3_PEDIDO
		    WHERE DB_COM_REPRES   = @VDB_TBREP_CODIGO
			  AND DB_COM_ANOMES   = @VANO_MES
			  AND DB_COM_ESPECIE  = LTRIM(RTRIM(@VE3_TIPO))
			  AND DB_COM_DOCTO    = RTRIM(@VE3_NUM)
			  AND DB_COM_PARCELA  = RTRIM(@VE3_PARCELA);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '1 - ERRO UPDATE DB_COMISSAO:' + @VE3_NUM + ' - ERRO BANCO: ' + @VCOD_ERRO;
		  END

	   END  -- IF @VINSERE = 0

	END  -- IF @VD_E_L_E_T_ <> ' '


	IF @VERRO IS NOT NULL
	BEGIN

	   SET @VDATA = GETDATE();
	   INSERT INTO DBS_ERROS_TRIGGERS
		 (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
	   VALUES
		 (@VERRO, @VDATA, @VOBJETO)
	END
END TRY

BEGIN CATCH
   SELECT @VERRO = cast(ERROR_NUMBER() as varchar) + ERROR_MESSAGE()

   PRINT 'ERRO' + @VERRO
   INSERT INTO DBS_ERROS_TRIGGERS
  		(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
		VALUES
  		( @VERRO, getdate(), @VOBJETO );			
END CATCH

END
