SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SD1010] (@VEVENTO       FLOAT,
                                     @VD1_FILIAL    VARCHAR(2),
                                     @VD1_ITEM      VARCHAR(4),
                                     @VD1_COD       VARCHAR(15),
                                     @VD1_UM        VARCHAR(2),
                                     @VD1_QUANT     FLOAT,
                                     @VD1_VUNIT     FLOAT,
                                     @VD1_TOTAL     FLOAT,
                                     @VD1_LOCAL     VARCHAR(2),
                                     @VD1_SEGUM     VARCHAR(2),
                                     @VD1_VALIPI    FLOAT,
                                     @VD1_VALICM    FLOAT,
                                     @VD1_TES       VARCHAR(3),
                                     @VD1_NFORI     VARCHAR(9),
                                     @VD1_CONTA     VARCHAR(20),
                                     @VD1_ITEMCTA   VARCHAR(9),
                                     @VD1_CC        VARCHAR(9),
                                     @VD1_CLVL      VARCHAR(9),
                                     @VD1_CF        VARCHAR(5),
                                     @VD1_DESC      FLOAT,
                                     @VD1_FORNECE   VARCHAR(6),
                                     @VD1_LOJA      VARCHAR(2),
                                     @VD1_IPI       FLOAT,
                                     @VD1_DOC       VARCHAR(9),
                                     @VD1_EMISSAO   VARCHAR(8),
                                     @VD1_DTDIGIT   VARCHAR(8),
                                     @VD1_PICM      FLOAT,
                                     @VD1_PESO      FLOAT,
                                     @VD1_SERIE     VARCHAR(3),
                                     @VD1_OP        VARCHAR(13),
                                     @VD1_PEDIDO    VARCHAR(6),
                                     @VD1_ITEMPC    VARCHAR(4),
                                     @VD1_GRUPO     VARCHAR(4),
                                     @VD1_TIPO      VARCHAR(1),
                                     @VD1_CUSTO2    FLOAT,
                                     @VD1_NUMSEQ    VARCHAR(6),
                                     @VD1_CUSTO3    FLOAT,
                                     @VD1_CUSTO4    FLOAT,
                                     @VD1_CUSTO5    FLOAT,
                                     @VD1_ITEMORI   VARCHAR(4),
                                     @VD1_TP        VARCHAR(2),
                                     @VD1_QTSEGUM   FLOAT,
                                     @VD1_ORIGLAN   VARCHAR(2),
                                     @VD1_DATACUS   VARCHAR(8),
                                     @VD1_SERIORI   VARCHAR(3),
                                     @VD1_NUMCQ     VARCHAR(6),
                                     @VD1_QTDEDEV   FLOAT,
                                     @VD1_VALDEV    FLOAT,
                                     @VD1_ICMSRET   FLOAT,
                                     @VD1_IDENTB6   VARCHAR(6),
                                     @VD1_BRICMS    FLOAT,
                                     @VD1_SKIPLOT   VARCHAR(1),
                                     @VD1_DATORI    VARCHAR(8),
                                     @VD1_SEQCALC   VARCHAR(14),
                                     @VD1_BASEICM   FLOAT,
                                     @VD1_VALDESC   FLOAT,
                                     @VD1_LOTEFOR   VARCHAR(18),
                                     @VD1_BASEIPI   FLOAT,
                                     @VD1_LOTECTL   VARCHAR(10),
                                     @VD1_NUMLOTE   VARCHAR(6),
                                     @VD1_DTVALID   VARCHAR(8),
                                     @VD1_PLACA     VARCHAR(7),
                                     @VD1_CHASSI    VARCHAR(17),
                                     @VD1_ANOFAB    VARCHAR(2),
                                     @VD1_MODFAB    VARCHAR(2),
                                     @VD1_FORMUL    VARCHAR(1),
                                     @VD1_MODELO    VARCHAR(15),
                                     @VD1_COMBUST   VARCHAR(10),
                                     @VD1_COR       VARCHAR(3),
                                     @VD1_NUMPV     VARCHAR(6),
                                     @VD1_ITEMPV    VARCHAR(2),
                                     @VD1_EQUIPS    VARCHAR(3),
                                     @VD1_II        FLOAT,
                                     @VD1_TEC       VARCHAR(16),
                                     @VD1_CONHEC    VARCHAR(17),
                                     @VD1_CUSFF1    FLOAT,
                                     @VD1_CUSFF2    FLOAT,
                                     @VD1_CLASFIS   VARCHAR(3),
                                     @VD1_CUSFF3    FLOAT,
                                     @VD1_REMITO    VARCHAR(9),
                                     @VD1_SERIREM   VARCHAR(3),
                                     @VD1_CUSFF4    FLOAT,
                                     @VD1_CUSFF5    FLOAT,
                                     @VD1_CODCIAP   VARCHAR(6),
                                     @VD1_BASIMP1   FLOAT,
                                     @VD1_CUSTO     FLOAT,
                                     @VD1_BASIMP3   FLOAT,
                                     @VD1_BASIMP4   FLOAT,
                                     @VD1_BASIMP5   FLOAT,
                                     @VD1_BASIMP6   FLOAT,
                                     @VD1_VALIMP1   FLOAT,
                                     @VD1_VALIMP2   FLOAT,
                                     @VD1_VALIMP3   FLOAT,
                                     @VD1_VALIMP4   FLOAT,
                                     @VD1_CIF       FLOAT,
                                     @VD1_ITEMREM   VARCHAR(4),
                                     @VD1_VALIMP5   FLOAT,
                                     @VD1_TIPO_NF   VARCHAR(1),
                                     @VD1_VALIMP6   FLOAT,
                                     @VD1_CBASEAF   VARCHAR(14),
                                     @VD1_ICMSCOM   FLOAT,
                                     @VD1_BASIMP2   FLOAT,
                                     @VD1_ALQIMP1   FLOAT,
                                     @VD1_ALQIMP2   FLOAT,
                                     @VD1_ALQIMP3   FLOAT,
                                     @VD1_ALQIMP4   FLOAT,
                                     @VD1_ALQIMP5   FLOAT,
                                     @VD1_ALQIMP6   FLOAT,
                                     @VD1_QTDPEDI   FLOAT,
                                     @VD1_VALFRE    FLOAT,
                                     @VD1_RATEIO    VARCHAR(1),
                                     @VD1_SEGURO    FLOAT,
                                     @VD1_DESPESA   FLOAT,
                                     @VD1_BASEIRR   FLOAT,
                                     @VD1_ALIQIRR   FLOAT,
                                     @VD1_VALIRR    FLOAT,
                                     @VD1_BASEISS   FLOAT,
                                     @VD1_ALIQISS   FLOAT,
                                     @VD1_CUSORI    FLOAT,
                                     @VD1_VALISS    FLOAT,
                                     @VD1_BASEINS   FLOAT,
                                     @VD1_ALIQINS   FLOAT,
                                     @VD1_VALINS    FLOAT,
                                     @VD1_VALACRS   FLOAT,
                                     @VD1_LOCPAD    VARCHAR(6),
                                     @VD1_ORDEM     VARCHAR(6),
                                     @VD1_SERVIC    VARCHAR(3),
                                     @VD1_STSERV    VARCHAR(1),
                                     @VD1_ENDER     VARCHAR(15),
                                     @VD1_TIPODOC   VARCHAR(2),
                                     @VD1_REGWMS    VARCHAR(1),
                                     @VD1_POTENCI   FLOAT,
                                     @VD1_TRT       VARCHAR(3),
                                     @VD1_GRADE     VARCHAR(1),
                                     @VD1_ITEMGRD   VARCHAR(3),
                                     @VD1_TESACLA   VARCHAR(3),
                                     @VD1_PRUNDA    FLOAT,
                                     @VD1_BASEPS3   FLOAT,
                                     @VD1_ALIQPS3   FLOAT,
                                     @VD1_VALPS3    FLOAT,
                                     @VD1_BASECF3   FLOAT,
                                     @VD1_ALIQCF3   FLOAT,
                                     @VD1_VALCF3    FLOAT,
                                     @VD1_CODISS    VARCHAR(9),
                                     @VD1_CFPS      VARCHAR(6),
                                     @VD1_NUMDESP   VARCHAR(16),
                                     @VD1_ORIGEM    VARCHAR(3),
                                     @VD1_DESCICM   FLOAT,
                                     @VD1_BASESES   FLOAT,
                                     @VD1_VALSES    FLOAT,
                                     @VD1_ALIQSES   FLOAT,
                                     @VD1_RGESPST   VARCHAR(1),
                                     @VD1_ABATISS   FLOAT,
                                     @VD1_ABATMAT   FLOAT,
                                     @VD1_BASNDES   FLOAT,
                                     @VD1_ICMNDES   FLOAT,
                                     @VD1_VALFDS    FLOAT,
                                     @VD1_PRFDSUL   FLOAT,
                                     @VD1_UFERMS    FLOAT,
                                     @VD1_ESTCRED   FLOAT,
                                     @VD1_VALANTI   FLOAT,
                                     @VD1_CRPRSIM   FLOAT,
                                     @VD1_ALIQSOL   FLOAT,
                                     @VD1_CRPRESC   FLOAT,
                                     @VD1_ALIQII    FLOAT,
                                     @VD1_MARGEM    FLOAT,
                                     @VD1_SLDDEP    FLOAT,
                                     @VD1_NFVINC    VARCHAR(9),
                                     @VD1_SERVINC   VARCHAR(3),
                                     @VD1_ITMVINC   VARCHAR(4),
                                     @VD1_ICMSDIF   FLOAT,
                                     @VD1_GARANTI   VARCHAR(1),
                                     @VD1_PCCENTR   VARCHAR(6),
                                     @VD1_ITPCCEN   VARCHAR(4),
                                     @VD1_QTPCCEN   FLOAT,
                                     @VD1_DFABRIC   VARCHAR(8),
                                     @VD1_ABATINS   FLOAT,
                                     @VD1_BASEFAB   FLOAT,
                                     @VD1_ALIQFAB   FLOAT,
                                     @VD1_VALFAB    FLOAT,
                                     @VD1_BASEFAC   FLOAT,
                                     @VD1_ALIQFAC   FLOAT,
                                     @VD1_VALFAC    FLOAT,
                                     @VD1_BASEFET   FLOAT,
                                     @VD1_ALIQFET   FLOAT,
                                     @VD1_VALFET    FLOAT,
                                     @VD1_CODLAN    VARCHAR(6),
                                     @VD1_AVLINSS   FLOAT,
                                     @VD_E_L_E_T_   VARCHAR(1),
                                     @VR_E_C_N_O_   INT,
                                     @VR_E_C_D_E_L_ INT
                                    ) AS

BEGIN

------------------------------------------------
--- 05/02/2016 ALENCAR     Passa a integrar a empresa usando a regra: empresa + filial, aonde tabelas da Sanchez 
---                        considera empresa 1 e Fini empresa 2
--- 15/03/2016 ALENCAR     Nao carrega notas: @VD1_FILIAL NOT IN ('01')
---                        Implementado with (nolock)
--- 17/05/2016 ALENCAR     Não integra notas da serie ECF, que sao notas emitidas pela loja Fini do Shopping
---                        Não integra notas de clientes que estiverem inativos no Protheus 
--- 19/05/2016 ALENCAR     Ao verificar o cliente, busca sempre com R_E_C_D_E_L_ = ' '
---                        Novamente a regra mudou, notas de clientes bloqueados devem ser carregadas
---                        Nao carrega notas clientes comercio exterior
---                        Passa a integrar o item da nota avaliando o campo D2_ITEM, pois no Protheus existem notas com 2 produtos iguais
--- 22/08/2016 ALENCAR     Removido o campo D1_TPESTR dos parametros de entrada
--- 11/09/2016 ALENCAR     Usando a nova regra para definir o nro e serie das notas fiscais
--- 21/09/2016 ALENCAR     Correçao no select que verifica se o cliente eh comercio exterior. Adicionado AND A1_LOJA  = @VF2_LOJA
--- 04/10/2016 ALENCAR     Não carregar notas de clientes e-commerce:   @VD1_FORNECE LIKE ('%A%')
---                                                                  OR @VD1_FORNECE LIKE ('%F%')
--- 26/10/2016 ALENCAR     Conversao Nova Alianca
--- 05/07/2016 ALENCAR     Somar o valor de ST e IPI no total da nota (db_notap_valor)
--- 06/07/2017 ALENCAR     Ajuste no @VINSERE
---                        Integrar o valor de ST (D1_ICMSRET)
--- 02/05/2018 ROBERT      Alterado nome do linked server de acesso ao ERP Protheus.
--- 23/03/2022 Robert      Versao inicial utilizando sinonimos
-----------------------------------------------

DECLARE @VDATA            DATETIME;
DECLARE @VERRO            VARCHAR(1000);
DECLARE @VOBJETO          VARCHAR(15) SELECT @VOBJETO = 'MERCP_SD1010 ';
DECLARE @VDB_NOTAP_ESTVLR NUMERIC;
DECLARE @VDB_NOTAP_TIPO   VARCHAR(1);
DECLARE @VF1_TIPO         VARCHAR(10);
DECLARE @VF1_DTDIGIT      VARCHAR(10);
DECLARE @VF1_FORNECE      VARCHAR(10);
DECLARE @VF1_LOJA         VARCHAR(3);
DECLARE @VSERIE           VARCHAR(3);
DECLARE @VDB_NOTAP_SEQ    INT SELECT @VDB_NOTAP_SEQ = 0;
DECLARE	@VINSERE          FLOAT SELECT @VINSERE = 0;
DECLARE @VEMPRESA	      VARCHAR(3);
DECLARE	@VFATUR           FLOAT SELECT @VFATUR = 3;

BEGIN TRY


	IF @VD1_FILIAL NOT IN ('01')
	 OR @VD1_SERIE IN ('ECF')
     OR @VD1_FORNECE LIKE ('%A%')
	 OR @VD1_FORNECE LIKE ('%F%')
	BEGIN
	   RETURN;
	END


	IF @VD1_TIPO = 'D' AND RTRIM(LTRIM(@VD1_DTDIGIT)) <> '        '
	BEGIN

	   SET @VEMPRESA = SUBSTRING(RTRIM(LTRIM(@VD1_FILIAL)), 1, 2)

	   SET @VSERIE = '';
	   SELECT TOP 1 @VSERIE = DB_NOTA_SERIE
		 FROM DB_NOTA_FISCAL
		WHERE DB_NOTA_NRO        = CAST(RTRIM(@VD1_DOC) AS INT)
		  --AND DB_NOTA_FATUR      = 3 -- ELIAS CHAMADO  86225
		  AND DB_NOTA_EMPRESA    = @VEMPRESA
		  AND DB_NOTA_CLIENTE    = @VD1_FORNECE


	   IF @VSERIE = '' OR @VSERIE IS NULL
	   BEGIN
		  RETURN;
	   END

      SET @VINSERE = 0;

		  SELECT @VF1_TIPO    = F1_TIPO,
				 @VF1_DTDIGIT = F1_DTDIGIT,
				 @VF1_FORNECE = F1_FORNECE,
				 @VF1_LOJA    = F1_LOJA
			FROM INTEGRACAO_PROTHEUS_SF1 WITH (NOLOCK)
		   WHERE F1_FILIAL   = @VD1_FILIAL
			 AND F1_DOC      = @VD1_DOC
			 AND F1_SERIE    = @VD1_SERIE
			 AND D_E_L_E_T_  = ' '
			 AND F1_DTDIGIT  = @VD1_DTDIGIT
			 AND F1_TIPO     = 'D'
			 AND F1_DTDIGIT <> '        '
			 AND F1_TIPO     = @VD1_TIPO
			 AND F1_DTDIGIT  = @VD1_DTDIGIT;

		  IF @VEVENTO = 2 OR (@VD_E_L_E_T_ <> ' ')
		  BEGIN
 
			 DELETE FROM DB_NOTA_PROD 
			  WHERE DB_NOTAP_EMPRESA = @VEMPRESA
				AND DB_NOTAP_NRO     = CAST(RTRIM(@VD1_DOC) AS INT)
				AND DB_NOTAP_SERIE   = @VSERIE
				AND DB_NOTAP_D2_ITEM = @VD1_ITEM;
				--AND DB_NOTAP_PRODUTO = RTRIM(LTRIM(@VD1_COD)); 
 
		  END
		  ELSE
		  BEGIN

			 SELECT @VINSERE = 1
			   FROM DB_NOTA_PROD  with (nolock)
			  WHERE DB_NOTAP_EMPRESA = @VEMPRESA
				AND DB_NOTAP_NRO     = CAST(RTRIM(@VD1_DOC) AS INT)
				AND DB_NOTAP_SERIE   = @VSERIE
				AND DB_NOTAP_D2_ITEM = @VD1_ITEM;
				--AND DB_NOTAP_PRODUTO = RTRIM(LTRIM(@VD1_COD));

			 SET @VDB_NOTAP_ESTVLR = 1;
			 SET @VDB_NOTAP_TIPO = 'V';

			 SELECT @VDB_NOTAP_SEQ = MAX(ISNULL(DB_NOTAP_SEQ,0)) + 1
			   FROM DB_NOTA_PROD   WITH(NOLOCK)
			  WHERE DB_NOTAP_EMPRESA = @VEMPRESA
				AND DB_NOTAP_NRO     = CAST(RTRIM(@VD1_DOC) AS INT)
				AND DB_NOTAP_SERIE   = @VSERIE;

			 IF @VDB_NOTAP_SEQ IS NULL OR
				@VDB_NOTAP_SEQ = 0
			 BEGIN
				SET @VDB_NOTAP_SEQ = 1;
			 END;

			 IF @VINSERE = 0
			 BEGIN

				INSERT INTO DB_NOTA_PROD
    			  (
				   DB_NOTAP_EMPRESA,
				   DB_NOTAP_NRO,
				   DB_NOTAP_SERIE,
				   DB_NOTAP_SEQ,
				   DB_NOTAP_D2_ITEM,
				   DB_NOTAP_PRODUTO,
				   DB_NOTAP_QTDE,
				   DB_NOTAP_VALOR,
				   DB_NOTAP_VLR_IPI,
				   DB_NOTAP_TIPO,
				   DB_NOTAP_PED_ORIG,
				   DB_NOTAP_ESTVLR,
				   DB_NOTAP_CDEPOSITO,
				   DB_NOTAP_VLR_ICMS,
				   DB_NOTAP_CUSTO,
				   DB_NOTAP_INCENTIVO,
				   DB_NOTAP_VLR_BRUTO,
				   DB_NOTAP_DESPESAS,
				   DB_NOTAP_VLR_SUBST,
				   DB_NOTAP_BASE_ICMS,
				   DB_NOTAP_BSUB_ICMS,
				   DB_NOTAP_ALIQ_ICMS,
				   DB_NOTAP_OPERACAO,
				   DB_NOTAP_DCTO_FIN,
				   DB_NOTAP_VLR_DESCT,
				   DB_NOTAP_QTDE_PED
				  )
				VALUES
				  (
				   @VEMPRESA,  --DB_NOTAP_EMPRESA,
				   CAST(RTRIM(@VD1_DOC) AS INT),              --DB_NOTAP_NRO,
				   @VSERIE,                    --DB_NOTAP_SERIE,
				   @VDB_NOTAP_SEQ,             --DB_NOTAP_SEQ,
				   @VD1_ITEM,                  --DB_NOTAP_D2_ITEM
				   RTRIM(LTRIM(@VD1_COD)),     --DB_NOTAP_PRODUTO,
				   @VD1_QUANT * -1,            --DB_NOTAP_QTDE,
				   (@VD1_TOTAL + isnull(@VD1_ICMSRET, 0) + isnull(@VD1_VALIPI,0)) * -1,            --DB_NOTAP_VALOR,
				   @VD1_VALIPI * -1,           --DB_NOTAP_VLR_IPI,
				   'N',                        --DB_NOTAP_TIPO,
				   @VD1_PEDIDO,                --DB_NOTAP_PED_ORIG,
				   1,                          --DB_NOTAP_ESTVLR,
				   NULL,                       --DB_NOTAP_CDEPOSITO,
				   @VD1_VALICM * -1,           --DB_NOTAP_VLR_ICMS,
				   NULL,                       --DB_NOTAP_CUSTO,
				   NULL,                       --DB_NOTAP_INCENTIVO,
				   @VD1_VALDEV * -1,           --DB_NOTAP_VLR_BRUTO,
				   @VD1_DESPESA,               --DB_NOTAP_DESPESAS,
				   isnull(@VD1_ICMSRET, 0) * -1,    --DB_NOTAP_VLR_SUBST,
				   @VD1_BASEICM,               --DB_NOTAP_BASE_ICMS,
				   0,                          --DB_NOTAP_BSUB_ICMS,
				   @VD1_PICM,                  --DB_NOTAP_ALIQ_ICMS,
				   RTRIM(LTRIM(@VD1_TES)),     --DB_NOTAP_OPERACAO,
				   0,                          --DB_NOTAP_DCTO_FIN,
				   0,                          --DB_NOTAP_VLR_DESCT,
				   0                           --DB_NOTAP_QTDE_PED 
				  );

			 END
			 ELSE
			 BEGIN

				UPDATE DB_NOTA_PROD
				   SET DB_NOTAP_PRODUTO   = RTRIM(LTRIM(@VD1_COD)),
					   DB_NOTAP_QTDE      = @VD1_QUANT * -1,
					   DB_NOTAP_VALOR     = (@VD1_TOTAL + isnull(@VD1_ICMSRET, 0) + isnull(@VD1_VALIPI,0)) * -1,
					   DB_NOTAP_VLR_IPI   = @VD1_VALIPI * -1,
					   DB_NOTAP_PED_ORIG  = @VD1_PEDIDO,
					   DB_NOTAP_ESTVLR    = 1,
					   DB_NOTAP_VLR_ICMS  = @VD1_VALICM * -1,
					   DB_NOTAP_VLR_BRUTO = @VD1_VALDEV * -1,
					   DB_NOTAP_DESPESAS  = @VD1_DESPESA * -1,
					   DB_NOTAP_BASE_ICMS = @VD1_BASEICM,
					   DB_NOTAP_ALIQ_ICMS = @VD1_PICM,
					   DB_NOTAP_OPERACAO  = RTRIM(@VD1_TES),
					   DB_NOTAP_VLR_SUBST = isnull(@VD1_ICMSRET, 0) * -1
				 WHERE DB_NOTAP_EMPRESA = @VEMPRESA
				   AND DB_NOTAP_NRO     = CAST(RTRIM(@VD1_DOC) AS INT)
				   AND DB_NOTAP_SERIE   = @VSERIE
				   AND DB_NOTAP_D2_ITEM = @VD1_ITEM;
				   --AND DB_NOTAP_PRODUTO = RTRIM(LTRIM(@VD1_COD));

			 END

			 /*ELIAS CHAMADO 86225 15-02-19*/
			  IF RTRIM(LTRIM(@VD1_TES)) IN ('031','431') 
			  BEGIN
			     SET @VFATUR = 2;
		      END

			 UPDATE DB_NOTA_FISCAL
				SET DB_NOTA_OPERACAO = RTRIM(LTRIM(@VD1_TES)),
					DB_NOTA_FATUR    = @VFATUR --3 elias chamado 86225
			  WHERE DB_NOTA_EMPRESA = @VEMPRESA
				AND DB_NOTA_NRO     = CAST(RTRIM(@VD1_DOC) AS INT)
				AND DB_NOTA_SERIE   = @VSERIE;

		  END

	   END  -- IF @VDB_NOTA_NRO IS NOT NULL

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

print 'erro --- ' +  @VERRO
   INSERT INTO DBS_ERROS_TRIGGERS
  		(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
		VALUES
  		( @VERRO, getdate(), @VOBJETO );			
END CATCH

END
GO
