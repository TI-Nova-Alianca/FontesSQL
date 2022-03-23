SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SD2010] (@VEVENTO       NUMERIC,
                                      @VD2_FILIAL    VARCHAR(2),
                                      @VD2_COD       VARCHAR(15), 
                                      @VD2_UM        VARCHAR(2), 
                                      @VD2_SEGUM     VARCHAR(2), 
                                      @VD2_QUANT     FLOAT, 
                                      @VD2_PRCVEN    FLOAT, 
                                      @VD2_TOTAL     FLOAT, 
                                      @VD2_VALIPI    FLOAT, 
                                      @VD2_VALICM    FLOAT, 
                                      @VD2_TES       VARCHAR(3), 
                                      @VD2_CF        VARCHAR(5), 
                                      @VD2_DESC      FLOAT, 
                                      @VD2_IPI       FLOAT, 
                                      @VD2_PICM      FLOAT, 
                                      @VD2_PESO      FLOAT, 
                                      @VD2_CONTA     VARCHAR(20), 
                                      @VD2_PEDIDO    VARCHAR(6), 
                                      @VD2_ITEMPV    VARCHAR(2), 
                                      @VD2_CLIENTE   VARCHAR(6), 
                                      @VD2_LOJA      VARCHAR(2), 
                                      @VD2_LOCAL     VARCHAR(2), 
                                      @VD2_DOC       VARCHAR(9), 
                                      @VD2_EMISSAO   VARCHAR(8), 
                                      @VD2_GRUPO     VARCHAR(4), 
                                      @VD2_TP        VARCHAR(2), 
                                      @VD2_SERIE     VARCHAR(3), 
                                      @VD2_CUSTO1    FLOAT, 
                                      @VD2_CUSTO2    FLOAT, 
                                      @VD2_CUSTO3    FLOAT, 
                                      @VD2_CUSTO4    FLOAT, 
                                      @VD2_CUSTO5    FLOAT, 
                                      @VD2_PRUNIT    FLOAT, 
                                      @VD2_QTSEGUM   FLOAT, 
                                      @VD2_NUMSEQ    VARCHAR(6), 
                                      @VD2_EST       VARCHAR(2), 
                                      @VD2_DESCON    FLOAT, 
                                      @VD2_TIPO      VARCHAR(1), 
                                      @VD2_NFORI     VARCHAR(9), 
                                      @VD2_SERIORI   VARCHAR(3), 
                                      @VD2_QTDEDEV   FLOAT, 
                                      @VD2_VALDEV    FLOAT, 
                                      @VD2_ORIGLAN   VARCHAR(2), 
                                      @VD2_BRICMS    FLOAT, 
                                      @VD2_BASEORI   FLOAT, 
                                      @VD2_BASEICM   FLOAT, 
                                      @VD2_VALACRS   FLOAT, 
                                      @VD2_IDENTB6   VARCHAR(6), 
                                      @VD2_ITEM      VARCHAR(9), 
                                      @VD2_CODISS    VARCHAR(9), 
                                      @VD2_GRADE     VARCHAR(1), 
                                      @VD2_SEQCALC   VARCHAR(14), 
                                      @VD2_ICMSRET   FLOAT, 
                                      @VD2_COMIS1    FLOAT, 
                                      @VD2_COMIS2    FLOAT, 
                                      @VD2_COMIS3    FLOAT, 
                                      @VD2_COMIS4    FLOAT, 
                                      @VD2_COMIS5    FLOAT, 
                                      @VD2_LOTECTL   VARCHAR(10), 
                                      @VD2_NUMLOTE   VARCHAR(6), 
                                      @VD2_DTVALID   VARCHAR(8), 
                                      @VD2_DESCZFR   FLOAT, 
                                      @VD2_PDV       VARCHAR(10), 
                                      @VD2_NUMSERI   VARCHAR(20), 
                                      @VD2_DTLCTCT   VARCHAR(8), 
                                      @VD2_CUSFF1    FLOAT, 
                                      @VD2_CUSFF2    FLOAT, 
                                      @VD2_CUSFF3    FLOAT, 
                                      @VD2_CUSFF4    FLOAT, 
                                      @VD2_CUSFF5    FLOAT, 
                                      @VD2_CLASFIS   VARCHAR(3), 
                                      @VD2_BASIMP1   FLOAT, 
                                      @VD2_BASIMP2   FLOAT, 
                                      @VD2_BASIMP3   FLOAT, 
                                      @VD2_BASIMP4   FLOAT, 
                                      @VD2_BASIMP5   FLOAT, 
                                      @VD2_BASIMP6   FLOAT, 
                                      @VD2_VALIMP1   FLOAT, 
                                      @VD2_VALIMP2   FLOAT, 
                                      @VD2_VALIMP3   FLOAT, 
                                      @VD2_VALIMP4   FLOAT, 
                                      @VD2_VALIMP5   FLOAT, 
                                      @VD2_VALIMP6   FLOAT, 
                                      @VD2_ITEMORI   VARCHAR(4), 
                                      @VD2_CODFAB    VARCHAR(6), 
                                      @VD2_LOJAFA    VARCHAR(2), 
                                      @VD2_ALIQINS   FLOAT, 
                                      @VD2_ALIQISS   FLOAT, 
                                      @VD2_BASEINS   FLOAT, 
                                      @VD2_BASEIPI   FLOAT, 
                                      @VD2_BASEISS   FLOAT, 
                                      @VD2_CCUSTO    VARCHAR(50), 
                                      @VD2_DESPESA   FLOAT, 
                                      @VD2_ENVCNAB   VARCHAR(50), 
                                      @VD2_ITEMCC    VARCHAR(50), 
                                      @VD2_LOCALIZ   VARCHAR(50), 
                                      @VD2_PREEMB    VARCHAR(50), 
                                      @VD2_SEGURO    FLOAT, 
                                      @VD2_VALFRE    FLOAT, 
                                      @VD2_VALINS    FLOAT, 
                                      @VD2_VALISS    FLOAT, 
                                      @VD2_CLVL      VARCHAR(50), 
                                      @VD2_ICMFRET   FLOAT, 
                                      @VD2_SERVIC    VARCHAR(50), 
                                      @VD2_STSERV    VARCHAR(50), 
                                      @VD2_PROJPMS   VARCHAR(50), 
                                      @VD2_TASKPMS   VARCHAR(50), 
                                      @VD2_LICITA    VARCHAR(50), 
                                      @VD2_REMITO    VARCHAR(50), 
                                      @VD2_SERIREM   VARCHAR(50), 
                                      @VD2_ITEMREM   VARCHAR(50), 
                                      @VD2_ALQIMP1   FLOAT, 
                                      @VD2_ALQIMP2   FLOAT, 
                                      @VD2_ALQIMP3   FLOAT, 
                                      @VD2_ALQIMP4   FLOAT, 
                                      @VD2_ALQIMP5   FLOAT, 
                                      @VD2_ALQIMP6   FLOAT, 
                                      @VD2_TPDCENV   VARCHAR(50), 
                                      @VD2_OK        VARCHAR(50), 
                                      @VD2_EDTPMS    VARCHAR(50), 
                                      @VD2_VARPRUN   FLOAT, 
                                      @VD2_FORMUL    VARCHAR(50), 
                                      @VD2_TIPODOC   VARCHAR(50), 
                                      @VD2_VAC       FLOAT, 
                                      @VD2_TIPOREM   VARCHAR(50), 
                                      @VD2_QTDEFAT   FLOAT, 
                                      @VD2_QTDAFAT   FLOAT, 
                                      @VD2_SEQUEN    VARCHAR(50), 
                                      @VD2_POTENCI   FLOAT, 
                                      @VD2_DESCICM   FLOAT, 
                                      @VD2_BASEPS3   FLOAT, 
                                      @VD2_ALIQPS3   FLOAT, 
                                      @VD2_VALPS3    FLOAT, 
                                      @VD2_BASECF3   FLOAT, 
                                      @VD2_ALIQCF3   FLOAT, 
                                      @VD2_VALCF3    FLOAT, 
                                      @VD_E_L_E_T_   VARCHAR(50), 
                                      @VR_E_C_N_O_   FLOAT, 
                                      @VR_E_C_D_E_L_ FLOAT, 
                                      @VD2_OP        VARCHAR(50), 
                                      @VD2_TPESTR    VARCHAR(50), 
                                      @VD2_VALBRUT   FLOAT, 
                                      @VD2_REGWMS    VARCHAR(50), 
                                      @VD2_DTDIGIT   VARCHAR(50), 
                                      @VD2_NUMCP     VARCHAR(50), 
                                      @VD2_CFPS      VARCHAR(50)) AS

BEGIN

------------------------------------------------
--- 05/02/2016 ALENCAR     Passa a integrar a empresa usando a regra: empresa + filial, aonde tabelas da Sanchez 
---                        considera empresa 1 e Fini empresa 2
--- 15/03/2016 ALENCAR     Nao carrega notas: @VD2_CLIENTE LIKE ('%A%')
---                                        OR @VD2_CLIENTE LIKE ('%F%')
---                                        or @VD2_FILIAL NOT IN ('01')
---                                        OR @VD2_TIPO = 'D'
--- 17/05/2016 ALENCAR     Não integra notas da serie ECF, que sao notas emitidas pela loja Fini do Shopping
---                        Soma o valor de ST no total da nota
---                        Não integra notas de clientes que estiverem inativos no Protheus 
--- 18/05/2016 ALENCAR     Não integra notas que o F2_CHVNFE = ' ' (Regra utilizada pelo Sadig)
--- 19/05/2016 ALENCAR     Ao verificar o cliente, busca sempre com R_E_C_D_E_L_ = ' '
---                        Novamente a regra mudou, notas de clientes bloqueados devem ser carregadas
---                        Nao carrega notas de clientes comercio exterior
---                        Passa a integrar o item da nota avaliando o campo D2_ITEM, pois no Protheus existem notas com 2 produtos iguais
--- 25/08/2016 ALENCAR     Filtro para importar notas de tipos diferentes de N, D e espaco
--- 21/09/2016 ALENCAR     Correçao no select que verifica se o cliente eh comercio exterior. Adicionado AND A1_LOJA  = @VF2_LOJA
--- 19/06/2017 ALENCAR     SE TEM ALGUM ITEM DE VENDA O FATUR DA NOTA DEVE SER CONSIDERADO VENDA, DO CONTRARIO MANTEM A REGRA ANTIGA, QUE AVALIA A OPERACAO DO ITEM
---                        ISSO DEVE SER FEITO POIS NA NOVA ALIANCA UMA MESMA NOTA TEM ITENS DE VENDA E BONIFICACAO
--- 05/07/2017 ALENCAR     Somar o valor de IPI no total da nota (db_notap_valor)
--- 11/07/2017 ALENCAR     Passa a atualizar o campo DB_NOTAP_TIPO cfme operacao do item da nota
--- 18/07/2017 ALENCAR     78226 - NÃO IMPORTAR ITENS QUE A OPERACAO FOR OUTRAS SAIDAS
--- 02/05/2018 ROBERT      Alterado nome do linked server de acesso ao ERP Protheus.
--- 23/03/2022 Robert      Versao inicial utilizando sinonimos
------------------------------------------------

DECLARE @VDATA              DATETIME;
DECLARE @VERRO              VARCHAR(1000);
DECLARE @VOBJETO            VARCHAR(15) SELECT @VOBJETO = 'MERCP_SD2010'
DECLARE @VINSERE            NUMERIC SELECT @VINSERE = 0;
DECLARE @VDB_TBOPS_FAT      VARCHAR(1);
DECLARE @VNOTA_FATUR        NUMERIC;
DECLARE @VDB_NOTAP_ESTVLR   NUMERIC;
DECLARE @VDB_NOTAP_TIPO     VARCHAR(1);
DECLARE @VDB_PED_NRO        NUMERIC;
DECLARE @VDB_PED_ORD_COMPRA VARCHAR(12);
DECLARE @VRETORNO           NUMERIC;
DECLARE @VCOD_ERRO          VARCHAR(1000);
DECLARE @VDB_NOTAP_SEQ      INT SELECT @VDB_NOTAP_SEQ = 0;
DECLARE @VEMPRESA	        VARCHAR(3)
      , @V_TEM_VENDA        NUMERIC;

BEGIN TRY

	IF @VD2_CLIENTE LIKE ('%A%')
	  OR @VD2_CLIENTE LIKE ('%F%')
	  OR @VD2_FILIAL NOT IN ('01')
	  OR @VD2_TIPO = 'D'
	  OR @VD2_SERIE IN ('ECF')
	BEGIN
	   RETURN;
	END

	IF (SELECT F2_CHVNFE
		  FROM INTEGRACAO_PROTHEUS_SF2
		 WHERE F2_FILIAL   = @VD2_FILIAL
		   AND F2_DOC      = @VD2_DOC
		   AND F2_SERIE    = @VD2_SERIE
		   AND F2_CLIENTE  = @VD2_CLIENTE
		   AND F2_LOJA     = @VD2_LOJA) = ' '
	BEGIN
	   RETURN;
	END


    SELECT @VDB_TBOPS_FAT = DB_TBOPS_FAT
	  FROM DB_TB_OPERS
	 WHERE DB_TBOPS_COD = RTRIM(@VD2_TES);
	  SET @VCOD_ERRO = @@ERROR;
	   IF @VCOD_ERRO > 0
	   BEGIN
		  SET @VDB_TBOPS_FAT = 'N';
	   END

    --- 78226 - NÃO IMPORTAR ITENS QUE A OPERACAO FOR OUTRAS SAIDAS
	IF @VDB_TBOPS_FAT = 'N' 
	BEGIN
	   RETURN;
	END     

	SET @VEMPRESA = SUBSTRING(RTRIM(@VD2_FILIAL), 1, 2)


	IF @VEVENTO = 2 OR (@VD_E_L_E_T_ <> ' ')
	BEGIN

	   DELETE FROM DB_NOTA_PROD
			 WHERE DB_NOTAP_EMPRESA = @VEMPRESA
			   AND DB_NOTAP_NRO     = REPLACE(RTRIM(@VD2_DOC),' ','')
			   AND DB_NOTAP_SERIE   = REPLACE(REPLACE(RTRIM(@VD2_SERIE),' ',''), '-', '')
			   AND DB_NOTAP_D2_ITEM = @VD2_ITEM;
			   --AND DB_NOTAP_PRODUTO = RTRIM(@VD2_COD); 

	END
	ELSE
	BEGIN


	   IF @VDB_TBOPS_FAT = 'B'
	   BEGIN
		  SET @VDB_NOTAP_ESTVLR = 0;
		  SET @VDB_NOTAP_TIPO = 'B';
	   END
	   ELSE
	   BEGIN
		  SET @VDB_NOTAP_ESTVLR = 1;
		  SET @VDB_NOTAP_TIPO = 'V';
	   END

		print '@VD2_TES ' + @VD2_TES
		print '@VDB_NOTAP_TIPO ' + @VDB_NOTAP_TIPO


	   SET @V_TEM_VENDA = 0
	   SELECT @V_TEM_VENDA = COUNT(1)
		  FROM INTEGRACAO_PROTHEUS_SD2
			 , DB_TB_OPERS
		 WHERE D2_FILIAL    = @VD2_FILIAL
		   AND D2_DOC       = @VD2_DOC
		   AND D2_SERIE     = @VD2_SERIE
		   AND DB_TBOPS_COD = D2_TES  COLLATE SQL_Latin1_General_CP1_CI_AS
		   AND DB_TBOPS_FAT IN ('S', 'V')

	   
	   ---- SE TEM ALGUM ITEM DE VENDA O FATUR DA NOTA DEVE SER CONSIDERADO VENDA, DO CONTRARIO MANTEM A REGRA ANTIGA, QUE AVALIA A OPERACAO DO ITEM
	   ---- ISSO DEVE SER FEITO POIS NA NOVA ALIANCA UMA MESMA NOTA TEM ITENS DE VENDA E BONIFICACAO
	   IF @V_TEM_VENDA >= 1
	   BEGIN
	       SET @VNOTA_FATUR = 0;
	   END
	   ELSE 
	   BEGIN
		   IF @VDB_TBOPS_FAT = 'S' OR
			  @VDB_TBOPS_FAT = 'V'
		   BEGIN
			  SET @VNOTA_FATUR = 0;
		   END

		   IF @VDB_TBOPS_FAT = 'N'
		   BEGIN
			  SET @VNOTA_FATUR = 1;
		   END   

		   IF @VDB_TBOPS_FAT = 'B'
		   BEGIN
			  SET @VNOTA_FATUR = 2;
		   END

		   IF @VDB_TBOPS_FAT = 'D'
		   BEGIN
			  SET @VNOTA_FATUR = 3;
		   END

		   IF @VDB_TBOPS_FAT = 'T'
		   BEGIN
			  SET @VNOTA_FATUR = 4;
		   END
       END


PRINT 'PASSOU COM @VNOTA_FATUR ' + CAST(@VNOTA_FATUR AS VARCHAR)

	   SELECT @VINSERE = 1
		 FROM DB_NOTA_PROD
		WHERE DB_NOTAP_EMPRESA = @VEMPRESA
		  AND DB_NOTAP_NRO     = REPLACE(RTRIM(@VD2_DOC),' ','')
		  AND DB_NOTAP_SERIE   = REPLACE(REPLACE(RTRIM(@VD2_SERIE),' ',''), '-', '')
		  AND DB_NOTAP_D2_ITEM = @VD2_ITEM;
		  --AND DB_NOTAP_PRODUTO = RTRIM(@VD2_COD);

	   SELECT @VDB_NOTAP_SEQ = MAX(ISNULL(DB_NOTAP_SEQ,0)) + 1
		 FROM DB_NOTA_PROD 
		WHERE DB_NOTAP_EMPRESA = @VEMPRESA
		  AND DB_NOTAP_NRO     = REPLACE(RTRIM(@VD2_DOC),' ','')
		  AND DB_NOTAP_SERIE   = REPLACE(REPLACE(RTRIM(@VD2_SERIE),' ',''), '-', '');

	   IF @VDB_NOTAP_SEQ IS NULL OR
		  @VDB_NOTAP_SEQ = 0
	   BEGIN
		  SET @VDB_NOTAP_SEQ = 1;
	   END;

	PRINT('@VDB_NOTAP_SEQ: ' + CAST(@VDB_NOTAP_SEQ AS VARCHAR));

	   IF @VINSERE = 0
	   BEGIN

		  INSERT INTO DB_NOTA_PROD --DB_NOTA_FISCAL -- hmk
			(
			 DB_NOTAP_EMPRESA,    -- 01
			 DB_NOTAP_NRO,        -- 02
			 DB_NOTAP_SERIE,      -- 03
			 DB_NOTAP_SEQ,        -- 04
			 DB_NOTAP_D2_ITEM,    -- 04a
			 DB_NOTAP_PRODUTO,    -- 05
			 DB_NOTAP_QTDE,       -- 06
			 DB_NOTAP_VALOR,      -- 07
			 DB_NOTAP_VLR_IPI,    -- 08
			 DB_NOTAP_TIPO,       -- 09
			 DB_NOTAP_PED_ORIG,   -- 10
			 DB_NOTAP_ESTVLR,     -- 11
			 DB_NOTAP_CDEPOSITO,  -- 12
			 DB_NOTAP_VLR_ICMS,   -- 13
			 DB_NOTAP_CUSTO,      -- 14
			 DB_NOTAP_INCENTIVO,  -- 15
			 DB_NOTAP_VLR_BRUTO,  -- 16
			 DB_NOTAP_DESPESAS,   -- 17
			 DB_NOTAP_VLR_SUBST,  -- 18
			 DB_NOTAP_BASE_ICMS,  -- 19
			 DB_NOTAP_BSUB_ICMS,  -- 20
			 DB_NOTAP_ALIQ_ICMS,  -- 21
			 DB_NOTAP_OPERACAO,   -- 22
			 DB_NOTAP_DCTO_FIN,   -- 23
			 DB_NOTAP_VLR_DESCT,  -- 24
	--         DB_NOTAP_NROSERIE,   -- 25
			 DB_NOTAP_QTDE_PED    -- 26
			) 
		  VALUES 
			( 
			 @VEMPRESA,                  -- 01
			 REPLACE(RTRIM(@VD2_DOC),' ',''),     -- 02
			 REPLACE(REPLACE(RTRIM(@VD2_SERIE),' ',''), '-', ''),  -- 03
			 @VDB_NOTAP_SEQ,                      -- 04
			 @VD2_ITEM,                           -- 04a
			 RTRIM(@VD2_COD),                     -- 05
			 @VD2_QUANT,                          -- 06
			 @VD2_TOTAL + isnull(@VD2_ICMSRET, 0) + isnull(@VD2_VALIPI, 0),           -- 07
			 @VD2_VALIPI,                         -- 08
			 @VDB_NOTAP_TIPO,                     -- 09
			 @VD2_PEDIDO,                         -- 10
			 CASE WHEN @VDB_TBOPS_FAT = 'B' THEN 0 ELSE 1 END,  -- 11
			 NULL,                                -- 12
			 @VD2_VALICM,                         -- 13
			 NULL,                                -- 14
			 NULL,                                -- 15
			 @VD2_VALBRUT,                        -- 16
			 @VD2_DESPESA,                        -- 17
			 @VD2_ICMSRET,                        -- 18
			 @VD2_BASEICM,                        -- 19
			 0,                                   -- 20
			 @VD2_PICM,                           -- 21
			 @VD2_TES,                            -- 22
			 0,                                   -- 23
			 0,                                   -- 24
	--         NULL,                                -- 25
			 0                                    -- 26
			);

	   END
	   ELSE
	   BEGIN

		  UPDATE DB_NOTA_PROD
			 SET DB_NOTAP_PRODUTO   = RTRIM(@VD2_COD),
				 DB_NOTAP_QTDE      = @VD2_QUANT,
				 DB_NOTAP_VALOR     = @VD2_TOTAL + isnull(@VD2_ICMSRET, 0) + isnull(@VD2_VALIPI, 0),
				 DB_NOTAP_VLR_SUBST = @VD2_ICMSRET,
				 DB_NOTAP_VLR_IPI   = @VD2_VALIPI,
				 DB_NOTAP_PED_ORIG  = @VD2_PEDIDO,
				 DB_NOTAP_ESTVLR    = CASE WHEN @VDB_TBOPS_FAT = 'B' THEN 0 ELSE 1 END,
				 DB_NOTAP_VLR_ICMS  = @VD2_VALICM,
				 DB_NOTAP_VLR_BRUTO = @VD2_VALBRUT,
				 DB_NOTAP_DESPESAS  = @VD2_DESPESA,
				 DB_NOTAP_BASE_ICMS = @VD2_BASEICM,
				 DB_NOTAP_ALIQ_ICMS = @VD2_PICM,
				 DB_NOTAP_OPERACAO  = RTRIM(@VD2_TES),
				 DB_NOTAP_TIPO      = @VDB_NOTAP_TIPO
		   WHERE DB_NOTAP_EMPRESA = @VEMPRESA
			 AND DB_NOTAP_NRO     = REPLACE(RTRIM(@VD2_DOC),' ','')
			 AND DB_NOTAP_SERIE   = REPLACE(REPLACE(RTRIM(@VD2_SERIE),' ',''), '-', '')
			 AND DB_NOTAP_D2_ITEM = @VD2_ITEM;
			 --AND DB_NOTAP_PRODUTO = RTRIM(@VD2_COD);

	   END


	   SELECT @VDB_PED_NRO = DB_PED_NRO, @VDB_PED_ORD_COMPRA = DB_PED_ORD_COMPRA
		 FROM DB_PEDIDO
		WHERE DB_PED_NRO_ORIG = @VD2_PEDIDO
		  AND DB_PED_EMPRESA  = @VEMPRESA;
	   SET @VCOD_ERRO = @@ERROR;
	   IF @VCOD_ERRO > 0
	   BEGIN
		  SET @VDB_PED_NRO = 0;
	   END

	   UPDATE DB_NOTA_FISCAL 
		  SET DB_NOTA_PED_MERC = @VDB_PED_NRO, 
			  DB_NOTA_PED_ORIG = @VD2_PEDIDO, 
			  DB_NOTA_OPERACAO = RTRIM(@VD2_TES),
			  DB_NOTA_FATUR    = @VNOTA_FATUR,
			  DB_NOTA_PEDIDO   = @VDB_PED_ORD_COMPRA
		WHERE DB_NOTA_EMPRESA = @VEMPRESA
		  AND DB_NOTA_NRO     = REPLACE(RTRIM(@VD2_DOC),' ','')   
		  AND DB_NOTA_SERIE   = REPLACE(REPLACE(RTRIM(@VD2_SERIE),' ',''), '-', '');

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
