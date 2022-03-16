SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[MERCP_DA0010] (@VEVENTO       FLOAT,
                                      @VDA0_CODTAB   VARCHAR(3),
                                      @VDA0_DESCRI   VARCHAR(30),
                                      @VDA0_DATDE    VARCHAR(8),
                                      @VDA0_HORADE   VARCHAR(5),
                                      @VDA0_DATATE   VARCHAR(8),
                                      @VDA0_HORATE   VARCHAR(5),
                                      @VDA0_CONDPG   VARCHAR(3),
                                      @VDA0_TPHORA   VARCHAR(1),
                                      @VDA0_ATIVO    VARCHAR(1),
                                      @VDA0_FILIAL   VARCHAR(2),
                                      @VD_E_L_E_T_   VARCHAR(1),
                                      @VR_E_C_N_O_   INT,
                                      @VR_E_C_D_E_L_ INT,
									  @VDA0_VAUF     VARCHAR(50),
									  @VDA0_VAESDI   VARCHAR(10),
									  @VDA0_PERMAX   FLOAT,
									  @VDA0_PERMIN   FLOAT
									  ) AS

BEGIN

DECLARE @VDATA            DATETIME;
DECLARE @VERRO            VARCHAR(1000);
DECLARE @VOBJETO          VARCHAR(100) SELECT @VOBJETO = 'MERCP_DA0010';
DECLARE @VCOD_ERRO        VARCHAR(1000);
DECLARE @VINSERE          INT SELECT @VINSERE = 0;
DECLARE @VDB_PRECO_CODIGO VARCHAR(8);
DECLARE @C_PRECOPROD          CURSOR
      , @V_DB_PRECOP_PRODUTO  VARCHAR(16)
	  , @V_DB_PRECOP_SEQ      VARCHAR(7)

---------------------------------------------------------------------
-- VERSAO   DATA        AUTOR            ALTERACAO
-- 1.00001  05/08/2010  SERGIO LUCCHINI  DESENVOLVIMENTO
-- 1.00002  12/09/2016  ALENCAR          QUANDO O REGISTRO ESTIVER DELETADO NAO DEVE ATUALIZAR
-- 1.00003  13/09/2016  ALENCAR          Alterada a forma de update na data de validade dos itens, passando a usar um loop
--                                       Isso e feito pois o Protheus set rowcount=40 e um update unico altera apenas 40 registros
-- 1.00004  11/10/2016  ALENCAR          Conversão Nova Aliança
-- 1.00005  01/11/2016  ALENCAR		     Gravar filtro de estados: DB_PRECO_ESTADOS   = DA0_VAUF
--                                       Integrar apenas listas da filial 01
-- 1.00006  21/11/2016  ALENCAR          Sempre que a lista estiver cadastrada como ESTATICA coloca como preco minimo no Mercanet e discrepancia 0,01
-- 1.00007  13/02/2017  ALENCAR          Retirada a customização para gravar flag preço mínimo (76466)
-- 1.00008  14/03/2017  ALENCAR          Passar a gravar o campo DB_PRECO_TPFRETE com valor 1,3
--          16/04/2021  CLAUDIA          Incluido % de desconto máximo DA0_PERMAX
--          20/04/2021  CLAUDIA          Incluido % de desconto máximo DA0_PERMIN
--
---------------------------------------------------------------------


    IF @VDA0_FILIAL NOT IN ('01')
	BEGIN
	   RETURN;
	END

	--- SE O REGISTRO ESTA DELETADO NAO DEVE FAZER NADA, NEM MESMO APAGAR, POIS EXISTEM 2 LISTAS DE PRECOS COM O MESMO CODIGO, SENDO UMA DELETADA
	IF @VD_E_L_E_T_ <> ' '
	BEGIN
	   RETURN;
	END

BEGIN TRY
	SET @VDB_PRECO_CODIGO = LTRIM(RTRIM(@VDA0_CODTAB));

	IF @VEVENTO = 2
	BEGIN

	   DELETE FROM DB_PRECO WHERE DB_PRECO_CODIGO = @VDB_PRECO_CODIGO;

	END
	ELSE
	BEGIN

	   SELECT @VINSERE = 1
		 FROM DB_PRECO
		WHERE DB_PRECO_CODIGO = @VDB_PRECO_CODIGO;
	   SET @VCOD_ERRO = @@ERROR;
	   IF @VCOD_ERRO > 0
	   BEGIN
			SET @VINSERE = 0;
	   END

	   IF @VINSERE = 0
	   BEGIN

		  INSERT INTO DB_PRECO
			(
			 DB_PRECO_MOEDA,      -- 01
			 DB_PRECO_SITUACAO,   -- 02
			 DB_PRECO_DESCTO,     -- 03
			 DB_PRECO_ORIG_PREC,  -- 04
			 DB_PRECO_TPDESCTO,   -- 05
			 DB_PRECO_EMPRESA,    -- 06
			 DB_PRECO_CLIENTES,   -- 07
			 DB_PRECO_ESTADOS,    -- 08
			 DB_PRECO_PROMOCAO,   -- 09
			 DB_PRECO_PRM_ESPEC,  -- 10
			 DB_PRECO_PRM_QTDE,   -- 11
			 DB_PRECO_PRM_TPQTD,  -- 12
			 DB_PRECO_PRM_VALOR,  -- 13
			 DB_PRECO_PRM_TPVLR,  -- 14
			 DB_PRECO_PRM_CPGTO,  -- 15
			 DB_PRECO_PRM_ITENS,  -- 16
			 DB_PRECO_ECON_PRME,  -- 17
			 DB_PRECO_CODIGO,     -- 18
			 DB_PRECO_DESCR,      -- 19
			 DB_PRECO_DATA_INI,   -- 20
			 DB_PRECO_DATA_FIN,   -- 21

			 DB_PRECO_POLPREMIN,  -- 22
			 DB_PRECO_DMENOR,     -- 23 
			 DB_PRECO_DMAIOR,     -- 24
			 DB_PRECO_TPFRETE     -- 25 
			)
		  VALUES
			(
			 0,                           -- 01
			 CASE WHEN @VDA0_ATIVO = 1 THEN 'A' ELSE 'I' END,  -- 02
			 0,                           -- 03
			 NULL,                        -- 04
			 '',                          -- 05
			 LTRIM(RTRIM(@VDA0_FILIAL)),  -- 06
			 '',                          -- 07
			 LTRIM(RTRIM(@VDA0_VAUF)),    -- 08
			 'N',                         -- 09
			 '0',                         -- 10
			 0,                           -- 11
			 0,                           -- 12
			 0,                           -- 13
			 0,                           -- 14
			 @VDA0_CONDPG,                -- 15
			 0,                           -- 16
			 '0',                         -- 17
			 @VDB_PRECO_CODIGO,           -- 18
			 @VDA0_DESCRI,                -- 19
			 @VDA0_DATDE,                 -- 20
			 @VDA0_DATATE,                -- 21
			 0,                           -- 22
		     --- Sempre que a lista estiver cadastrada como ESTATICA coloca como preco minimo no Mercanet e discrepancia 0,01
			--CASE @VDA0_VAESDI WHEN 'E' THEN 0.01
			--                           ELSE 0
			--				END,          -- 23
			--CASE @VDA0_VAESDI WHEN 'E' THEN 0.01
			--                           ELSE 0
			--			      END,        -- 24
			@VDA0_PERMIN,                 -- 23
			@VDA0_PERMAX,                 -- 24
			'1,3'                         -- 25
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '1 - ERRO INSERT DB_PRECO:' + @VDA0_CODTAB + ' - ERRO BANCO: ' + @VCOD_ERRO;
		  END

	   END
	   ELSE
	   BEGIN

		  UPDATE DB_PRECO
			 SET DB_PRECO_DESCR     = @VDA0_DESCRI,
				 DB_PRECO_DATA_INI  = @VDA0_DATDE,
				 DB_PRECO_DATA_FIN  = @VDA0_DATATE,
				 DB_PRECO_PRM_CPGTO = @VDA0_CONDPG,
				 DB_PRECO_EMPRESA   = LTRIM(RTRIM(@VDA0_FILIAL)),
				 DB_PRECO_SITUACAO  = CASE WHEN @VDA0_ATIVO = 1 THEN 'A' ELSE 'I' END,
				 DB_PRECO_ESTADOS   = LTRIM(RTRIM(@VDA0_VAUF)),

				 --- Sempre que a lista estiver cadastrada como ESTATICA coloca como preco minimo no Mercanet e discrepancia 0,01
				 DB_PRECO_POLPREMIN = 0,
				 DB_PRECO_DMENOR = @VDA0_PERMIN,
				 DB_PRECO_DMAIOR = @VDA0_PERMAX,
				 --DB_PRECO_DMENOR = CASE @VDA0_VAESDI WHEN 'E' THEN 0.01
				 --                                                ELSE 0
				 --										END,
				 --DB_PRECO_DMAIOR = CASE @VDA0_VAESDI WHEN 'E' THEN 0.01
				 --                                                ELSE 0
				 --										END,
				 DB_PRECO_TPFRETE	= '1,3'
		   WHERE DB_PRECO_CODIGO = @VDB_PRECO_CODIGO;
				SET @VCOD_ERRO = @@ERROR;
				IF @VCOD_ERRO > 0
				BEGIN
					SET @VERRO = '2 - ERRO UPDATE DB_PRECO:' + @VDA0_CODTAB + ' - ERRO BANCO: ' + @VCOD_ERRO;
		  END

	   END

	   ------------------------------------------
	   ---- ATUALIZAR OS ITENS DA LISTA COM A DATA DE VALIDADE DA CAPA
	   ----     Esse update eh feito atraves de um cursor pois o Protheus seta ROWCOUNT com valor 40, e isso 
	   ----     faz com que um update em todos os itens da lista de preco execute apenas para 40 registros
	   ------------------------------------------
		SET @C_PRECOPROD = CURSOR STATIC FOR
		SELECT DB_PRECOP_PRODUTO,   DB_PRECOP_SEQ
				 FROM DB_PRECO_PROD 
				WHERE DB_PRECOP_CODIGO = @VDB_PRECO_CODIGO
		  OPEN @C_PRECOPROD
		 FETCH NEXT FROM @C_PRECOPROD				
		  INTO @V_DB_PRECOP_PRODUTO,  @V_DB_PRECOP_SEQ 
		 WHILE @@FETCH_STATUS = 0
		 BEGIN

				UPDATE DB_PRECO_PROD
				SET DB_PRECOP_DTVALI = @VDA0_DATDE,
					DB_PRECOP_DTVALF = @VDA0_DATATE
				WHERE DB_PRECOP_CODIGO    = @VDB_PRECO_CODIGO
				  AND DB_PRECOP_PRODUTO   = @V_DB_PRECOP_PRODUTO
				  AND DB_PRECOP_SEQ       = @V_DB_PRECOP_SEQ

		  FETCH NEXT FROM @C_PRECOPROD
		  INTO @V_DB_PRECOP_PRODUTO,  @V_DB_PRECOP_SEQ
		END

		CLOSE @C_PRECOPROD
		DEALLOCATE @C_PRECOPROD
	   ------------------------------------------
	   ---- FIM ATUALIZAR OS ITENS DA LISTA COM A DATA DE VALIDADE DA CAPA
	   ------------------------------------------

	   SET @VCOD_ERRO = @@ERROR;
	   IF @VCOD_ERRO > 0
	   BEGIN
		  SET @VERRO = '3 - ERRO UPDATE DB_PRECO_PROD:' + @VDA0_CODTAB + ' - ERRO BANCO: ' + @VCOD_ERRO;
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
