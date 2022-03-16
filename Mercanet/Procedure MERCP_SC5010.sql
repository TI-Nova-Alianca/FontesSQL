SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SC5010] (@VEVENTO      FLOAT,
			@VC5_FILIAL     VARCHAR(2),
			@VC5_NUM        VARCHAR(6),
			@VC5_TIPO       VARCHAR(1),
			@VC5_CLIENTE    VARCHAR(6),
			@VC5_LOJACLI    VARCHAR(2),
			@VC5_CLIENT     VARCHAR(6),
			@VC5_LOJAENT    VARCHAR(2),
			@VC5_TRANSP     VARCHAR(6),
			@VC5_TIPOCLI    VARCHAR(1),
			@VC5_CONDPAG    VARCHAR(3),
			@VC5_TABELA     VARCHAR(3),
			@VC5_VEND1      VARCHAR(6),
			@VC5_COMIS1     FLOAT,
			@VC5_VEND2      VARCHAR(6),
			@VC5_COMIS2     FLOAT,
			@VC5_VEND3      VARCHAR(6),
			@VC5_COMIS3     FLOAT,
			@VC5_VEND4      VARCHAR(6),
			@VC5_COMIS4     FLOAT,
			@VC5_VEND5      VARCHAR(6),
			@VC5_COMIS5     FLOAT,
			@VC5_DESC1      FLOAT,
			@VC5_DESC2      FLOAT,
			@VC5_DESC3      FLOAT,
			@VC5_DESC4      FLOAT,
			@VC5_BANCO      VARCHAR(3),
			@VC5_DESCFI     FLOAT,
			@VC5_EMISSAO    VARCHAR(8),
			@VC5_COTACAO    VARCHAR(6),
			@VC5_PARC1      FLOAT,
			@VC5_DATA1      VARCHAR(8),
			@VC5_PARC2      FLOAT,
			@VC5_DATA2      VARCHAR(8),
			@VC5_PARC3      FLOAT,
			@VC5_DATA3      VARCHAR(8),
			@VC5_PARC4      FLOAT,
			@VC5_DATA4      VARCHAR(8),
			@VC5_TPFRETE    VARCHAR(1),
			@VC5_FRETE      FLOAT,
			@VC5_DESPESA    FLOAT,
			@VC5_FRETAUT    FLOAT,
			@VC5_REAJUST    VARCHAR(3),
			@VC5_MOEDA      FLOAT,
			@VC5_SEGURO     FLOAT,
			@VC5_PESOL      FLOAT,
			@VC5_PBRUTO     FLOAT,
			@VC5_REIMP      FLOAT,
			@VC5_REDESP     VARCHAR(6),
			@VC5_VOLUME1    FLOAT,
			@VC5_VOLUME2    FLOAT,
			@VC5_VOLUME3    FLOAT,
			@VC5_VOLUME4    FLOAT,
			@VC5_ESPECI1    VARCHAR(10),
			@VC5_ESPECI2    VARCHAR(10),
			@VC5_ESPECI3    VARCHAR(10),
			@VC5_ESPECI4    VARCHAR(10),
			@VC5_ACRSFIN    FLOAT,
			@VC5_INCISS     VARCHAR(1),
			@VC5_LIBEROK    VARCHAR(1),
			@VC5_OK         VARCHAR(2),
			@VC5_NOTA       VARCHAR(9),
			@VC5_MENNOTA    VARCHAR(120),
			@VC5_MENPAD     VARCHAR(3),
			@VC5_OS         VARCHAR(6),
			@VC5_SERIE      VARCHAR(3),
			@VC5_KITREP     VARCHAR(6),
			@VC5_TIPLIB     VARCHAR(1),
			@VC5_TXMOEDA    FLOAT,
			@VC5_DESCONT    FLOAT,
			@VC5_PEDEXP     VARCHAR(20),
			@VC5_TPCARGA    VARCHAR(1),
			@VC5_PDESCAB    FLOAT,
			@VC5_BLQ        VARCHAR(1),
			@VC5_FORNISS    VARCHAR(6),
			@VC5_CONTRA     VARCHAR(10),
			@VC5_VLR_FRT    FLOAT,
			--@VC5_PEDCLI     VARCHAR(13),
			--@VC5_OBSINTE    VARCHAR(250),
			@VD_E_L_E_T_    VARCHAR(1),
			@VR_E_C_N_O_    INT,
			@VR_E_C_D_E_L_  INT,
			@VC5_VAPDMER    VARCHAR(20)) AS

BEGIN

------------------------------------------------
---         05/02/2016 ALENCAR     Passa a integrar a empresa usando a regra: empresa + filial, aonde tabelas da Sanchez 
---                                considera empresa 1 e Fini empresa 2
---                                Nao integra pedidos de clientes com letras, que sao clientes do e-commerce 
---         27/04/2016 ALENCAR     Passa a verificar o campo @VC5_ZZMERCA para definir o nro do pedido a ser integrado. Este campo possui o nro do pedido Mercanet
---         21/06/2016 ALENCAR     Alterado o nome do campo @VC5_ZZMERCA para @VC5_ZZMERC
--- 1.00001 24/10/2016 ALENCAR     Conversão Nova Aliança
--- 1.00002 28/10/2016 ALENCAR     Insere na DB_PEDIDO_COMPL
--- 1.00003 21/11/2016 ALENCAR     Regra para definir a condicao de pagamento:
---                                   Se possuir letras ou for menor que 3 caracteres assume a condicao 666
---                                   Se for condicao 000 assume a 900
------------------------------------------------

DECLARE @VDATA            DATETIME;
DECLARE @VCOD_ERRO        VARCHAR(1000);
DECLARE @VERRO            VARCHAR(255);
DECLARE @VDB_TBREP_CODIGO FLOAT;
DECLARE @VOBJETO          VARCHAR(15) SELECT @VOBJETO = 'MERCP_SC5010';
DECLARE	@VINSERE          FLOAT SELECT @VINSERE = 0;
DECLARE	@VDB_PED_NRO      FLOAT SELECT @VDB_PED_NRO = 0;
DECLARE @VC6_TES          VARCHAR(3);
DECLARE @VEMPRESA	      VARCHAR(3)
      , @VC5_CONDPAG_AUX  VARCHAR(3);

BEGIN TRY

	IF @VC5_LOJACLI IN ('SU', 'R:', 'A')
		OR @VC5_CLIENTE LIKE ('%A%')
		OR @VC5_CLIENTE LIKE ('%F%')
		OR @VC5_FILIAL NOT IN ('01')
		OR @VC5_EMISSAO < '20140101'
		OR @VC5_NUM LIKE ('%c%')
		OR @VC5_NUM LIKE ('%M%')
		OR @VC5_NUM = ',GTF'
	BEGIN
		RETURN;
	END

	print '@VC5_NUM ' + @VC5_NUM


	SET @VEMPRESA = SUBSTRING(RTRIM(LTRIM(@VC5_FILIAL)), 1, 2)


	--- SE O CAMPO @VC5_ZZMERC POSSUIR VALOR SIGNIFICA QUE EH UM PEDIDO MERCANET
	IF ISNULL(@VC5_VAPDMER, ' ') <> ' ' 
	  AND LEN(@VC5_VAPDMER) = 9
	  AND SUBSTRING(@VC5_VAPDMER, 5, 1) = '/'
	BEGIN
		SET @VDB_PED_NRO = CAST(SUBSTRING(@VC5_VAPDMER, 1, 4) + SUBSTRING(@VC5_VAPDMER, 6, 4) AS FLOAT)
		PRINT 'CONSEGUIU MONTAR'
		PRINT CAST(@VDB_PED_NRO AS NUMERIC);
	END 
	ELSE
	BEGIN
	   SELECT @VDB_PED_NRO = DB_PED_NRO
		 FROM DB_PEDIDO
		WHERE DB_PED_NRO_ORIG = @VC5_NUM
		  AND DB_PED_EMPRESA  = @VEMPRESA;
	END


	IF ISNULL(@VDB_PED_NRO, 0) = 0
	BEGIN
		SET @VDB_PED_NRO = '99'+@VC5_NUM;
	END


	SELECT TOP 1 @VDB_TBREP_CODIGO = DB_TBREP_CODIGO
		FROM DB_TB_REPRES
		WHERE DB_TBREP_CODORIG = RTRIM(@VC5_VEND1);
	SET @VCOD_ERRO = @@ERROR;
	IF @VCOD_ERRO > 0
	BEGIN
		SET  @VDB_TBREP_CODIGO = SUBSTRING(RTRIM(@VC5_VEND1),1,4);
	END

	--- Define a condicao de pagamento:
	    -- Se possuir letras ou for menor que 3 caracteres assume a condicao 666
		-- se for condicao 000 assume a 900
	IF ISNUMERIC(@VC5_CONDPAG) = 0 
	  or LEN(RTRIM(LTRIM(@VC5_CONDPAG))) <> 3 
	    SET @VC5_CONDPAG_AUX = '666'
    ELSE IF @VC5_CONDPAG = '000'
	    SET @VC5_CONDPAG_AUX = '900'
	ELSE 
	    SET @VC5_CONDPAG_AUX = @VC5_CONDPAG

	IF @VEVENTO = 2 OR @VD_E_L_E_T_ <> ' '
	BEGIN

		UPDATE DB_PEDIDO
			SET DB_PED_SITUACAO = 9
		WHERE DB_PED_NRO = @VDB_PED_NRO;
		IF @VCOD_ERRO > 0
		BEGIN
			SET @VERRO = '1 - ERRO UPDATE DB_PEDIDO:' + @VDB_PED_NRO + ' - ERRO BANCO: ' + @VCOD_ERRO;
		END

		UPDATE DB_PEDIDO_PROD
			SET DB_PEDI_SITUACAO  = 9,
				DB_PEDI_QTDE_CANC = DB_PEDI_QTDE_SOLIC,
				DB_PEDI_MOTCANC   = '01'
		WHERE DB_PEDI_PEDIDO = @VDB_PED_NRO;
		IF @VCOD_ERRO > 0
		BEGIN
			SET @VERRO = '2 - ERRO UPDATE DB_PEDIDO_PROD:' + @VDB_PED_NRO + ' - ERRO BANCO: ' + @VCOD_ERRO;
		END

	--   -- CRIA LANCAMENTOS DE DÉDITO DOS PRODUTOS PDV
	--   EXECUTE [DBO].[CQMP_INSERE_LCTO_PDV] 'PEDIDO', @VDB_PED_NRO, NULL

	END
	ELSE
	BEGIN
	PRINT('ENTROU NO INSERT/UPDATE')
		SELECT @VC6_TES = C6_TES
			FROM LKSRV_PROTHEUS.protheus.dbo.SC6010
		WHERE C6_FILIAL = @VC5_FILIAL
			AND C6_NUM    = @VC5_NUM
			AND C6_ITEM   = '01';
		SET @VCOD_ERRO = @@ERROR;
		IF @VCOD_ERRO > 0
		BEGIN
			SET @VC6_TES = NULL;
		END

		SELECT @VINSERE = 1
			FROM DB_PEDIDO
		WHERE DB_PED_NRO = @VDB_PED_NRO;
		SET @VCOD_ERRO = @@ERROR;
		IF @VCOD_ERRO > 0
		BEGIN
			SET @VINSERE = 0;
		END

		IF @VINSERE = 0
		BEGIN

			INSERT INTO DB_PEDIDO
			(
				DB_PED_NRO,                 -- 1
				DB_PED_CLIENTE,
				DB_PED_DT_EMISSAO,
				DB_PED_DT_PREVENT,
				DB_PED_LISTA_PRECO,         -- 5
				DB_PED_COND_PGTO,
				DB_PED_OPERACAO,
				DB_PED_PORTADOR,
				DB_PED_COD_MOEDA,
				DB_PED_REPRES,              -- 10
				DB_PED_COMISO,
				DB_PED_COMISI,
				DB_PED_PERC_FRETE,
				DB_PED_COD_TRANSP,
				DB_PED_COD_REDESP,          -- 15
				DB_PED_TIPO_FRETE,
				--DB_PED_ORD_COMPRA,
				DB_PED_DESCTO,
				DB_PED_DESCTO2,
				DB_PED_DESCTO3,             -- 20
				DB_PED_DESCTO4,
				DB_PED_DESCTO5,
				DB_PED_DESCTO6,
				DB_PED_DESCTO7,
				DB_PED_ACRESCIMO,           -- 25
				DB_PED_MOTIVO_BLOQ,
				DB_PED_SITUACAO,
				DB_PED_DATA_ALTER,
				DB_PED_DATA_ENVIO,
				--DB_PED_OBSERV,            -- 30
				DB_PED_TEXTO,
				DB_PED_NRO_ORIG,
				DB_PED_TIPO_PRECO,
				DB_PED_FATUR,
				DB_PED_VLR_FRETE,           -- 35
				DB_PED_VLR_SEGURO,
				DB_PED_EMPRESA,
				DB_PED_CDV,
				DB_PED_TIPO,
				DB_PED_REDESPACHO,          -- 40
				DB_PED_DT_PRODUC,
				DB_PED_SITCORP,
				DB_PED_FORAREGRA
			)
			VALUES
			(
				@VDB_PED_NRO,                                                         -- 1
				RTRIM(LTRIM(@VC5_CLIENTE)),
				CONVERT(CHAR,RTRIM(@VC5_EMISSAO),103),
				NULL,
				@VC5_TABELA,      --'1',                                              -- 5
				@VC5_CONDPAG_AUX,
				NULL,
				REPLACE(REPLACE(@VC5_BANCO,' ',''), 'CX1', ''),
				@VC5_MOEDA,
				@VDB_TBREP_CODIGO,                                                    -- 10
				@VC5_COMIS1,
				@VC5_COMIS1,
				0,
				REPLACE(REPLACE(@VC5_TRANSP,' ',''),'/',''),
				RTRIM(LTRIM(@VC5_REDESP)),                                            -- 15
				CASE WHEN @VC5_TPFRETE = 'C' THEN 1 ELSE 2 END,
				--SUBSTRING(RTRIM(LTRIM(@VC5_PEDCLI)),1,13),
				0,  --@VC5_DESC1,
				0,  --@VC5_DESC2,
				0,  --@VC5_DESC3,                                                      -- 20
				0,  --@VC5_DESC4,
				0,
				0,
				0,
				0,  --@VC5_ACRSFIN,	                                                -- 25
				NULL,
				0,
				NULL,
				GETDATE(),
				--RTRIM(LTRIM(@VC5_OBSINTE)),                                          -- 30
				NULL,
				@VC5_NUM,
				0,
				0,
				@VC5_FRETE,                                                            -- 35
				@VC5_SEGURO,
				@VEMPRESA,
				0,
				RTRIM(LTRIM(@VC6_TES)),
				NULL,                                                                  -- 40
				NULL,
				0,
				NULL
			);
			SET @VCOD_ERRO = @@ERROR;
			IF @VCOD_ERRO > 0
			BEGIN
				SET @VERRO = '3 - ERRO INSERT DB_PEDIDO:' + @VDB_PED_NRO + ' - ERRO BANCO: ' + @VCOD_ERRO;
			END 

		END
		ELSE
		BEGIN

			UPDATE DB_PEDIDO
				SET DB_PED_CLIENTE     = RTRIM(LTRIM(@VC5_CLIENTE)),
					DB_PED_DT_EMISSAO  = CONVERT(CHAR,RTRIM(@VC5_EMISSAO),103),
					DB_PED_LISTA_PRECO = @VC5_TABELA,      --'1',
					DB_PED_COND_PGTO   = @VC5_CONDPAG_AUX,
					DB_PED_PORTADOR    = REPLACE(REPLACE(@VC5_BANCO,' ',''), 'CX1', ''),
					DB_PED_COD_MOEDA   = @VC5_MOEDA,
					DB_PED_REPRES      = @VDB_TBREP_CODIGO,
					DB_PED_COMISO      = @VC5_COMIS1,
					DB_PED_COMISI      = @VC5_COMIS1,
					DB_PED_COD_TRANSP  = REPLACE(REPLACE(@VC5_TRANSP,' ',''),'/',''),
					DB_PED_COD_REDESP  = RTRIM(LTRIM(@VC5_REDESP)),
					DB_PED_TIPO_FRETE  = CASE WHEN @VC5_TPFRETE = 'C' THEN 1 ELSE 2 END,
					DB_PED_DESCTO      = 0,  -- @VC5_DESC1,
					DB_PED_DESCTO2     = 0,  -- @VC5_DESC2,
					DB_PED_DESCTO3     = 0,  -- @VC5_DESC1,
					DB_PED_DESCTO4     = 0,  -- @VC5_DESC1,
					DB_PED_DESCTO7     = 0,
					DB_PED_ACRESCIMO   = 0,  --@VC5_ACRSFIN,
					DB_PED_FORAREGRA   = NULL,
					DB_PED_DATA_ALTER  = NULL,
					--DB_PED_OBSERV      = RTRIM(LTRIM(@VC5_OBSINTE)),
					DB_PED_NRO_ORIG    = @VC5_NUM,
					DB_PED_VLR_FRETE   = @VC5_FRETE,
					DB_PED_VLR_SEGURO  = @VC5_SEGURO,
					DB_PED_EMPRESA     = @VEMPRESA
					--DB_PED_ORD_COMPRA  = SUBSTRING(RTRIM(LTRIM(@VC5_PEDCLI)),1,13)
					--DB_PED_TIPO        = RTRIM(LTRIM(@VC6_TES)) comentado cfme chamado 40109
			WHERE DB_PED_NRO = @VDB_PED_NRO;
			SET @VCOD_ERRO = @@ERROR;
			IF @VCOD_ERRO > 0
			BEGIN
				SET @VERRO = '4 - ERRO UPDATE DB_PEDIDO:' + @VDB_PED_NRO + ' - ERRO BANCO: ' + @VCOD_ERRO;
			END
		END


		----------------------------
		---- INSERE NA DB_PEDIDO_COMPL
		----------------------------
		SET @VINSERE = 0;
		SELECT @VINSERE = 1
		  FROM DB_PEDIDO_COMPL
		 WHERE DB_PEDC_NRO = @VDB_PED_NRO;
		SET @VCOD_ERRO = @@ERROR;
		IF @VCOD_ERRO > 0
		BEGIN
			SET @VINSERE = 0;
		END

		IF @VINSERE = 0
		BEGIN

			INSERT INTO DB_PEDIDO_COMPL
			      (
				     DB_PEDC_NRO           -- 1
			      )
				VALUES
				  (  @VDB_PED_NRO          -- 1
				  )
        END

	END

	IF @VERRO IS NOT NULL
	BEGIN

	PRINT('@VERRO: '+@VERRO)
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
