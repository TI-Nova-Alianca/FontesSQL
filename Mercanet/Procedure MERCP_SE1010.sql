SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SE1010](@VEVENTO        FLOAT,
                                     @VE1_FILIAL     VARCHAR(50), 
                                     @VE1_PREFIXO    VARCHAR(50), 
                                     @VE1_NUM        VARCHAR(50), 
                                     @VE1_PARCELA    VARCHAR(50), 
                                     @VE1_EMISSAO    VARCHAR(50), 
                                     @VE1_VENCTO     VARCHAR(50), 
                                     @VE1_VENCREA    VARCHAR(50), 
                                     @VE1_CLIENTE    VARCHAR(50), 
                                     @VE1_NOMCLI     VARCHAR(50), 
                                     @VE1_VALOR      FLOAT, 
                                     @VE1_TIPO       VARCHAR(50), 
                                     @VE1_NATUREZ    VARCHAR(50), 
                                     @VE1_PORTADO    VARCHAR(50), 
                                     @VE1_AGEDEP     VARCHAR(50), 
                                     @VE1_LOJA       VARCHAR(50), 
                                     @VE1_IRRF       FLOAT, 
                                     @VE1_ISS        FLOAT, 
                                     @VE1_INSS       FLOAT, 
                                     @VE1_NUMBCO     VARCHAR(50), 
                                     @VE1_INDICE     VARCHAR(50), 
                                     @VE1_BAIXA      VARCHAR(50), 
                                     @VE1_NUMBOR     VARCHAR(50), 
                                     @VE1_DATABOR    VARCHAR(50), 
                                     @VE1_EMIS1      VARCHAR(50), 
                                     @VE1_HIST       VARCHAR(50), 
                                     @VE1_LA         VARCHAR(50), 
                                     @VE1_LOTE       VARCHAR(50), 
                                     @VE1_MOTIVO     VARCHAR(50), 
                                     @VE1_MOVIMEN    VARCHAR(50), 
                                     @VE1_OP         VARCHAR(50), 
                                     @VE1_SITUACA    VARCHAR(50), 
                                     @VE1_CONTRAT    VARCHAR(50), 
                                     @VE1_SALDO      FLOAT, 
                                     @VE1_SUPERVI    VARCHAR(50), 
                                     @VE1_VEND1      VARCHAR(50), 
                                     @VE1_VEND2      VARCHAR(50), 
                                     @VE1_VEND3      VARCHAR(50), 
                                     @VE1_VEND4      VARCHAR(50), 
                                     @VE1_VEND5      VARCHAR(50), 
                                     @VE1_COMIS1     FLOAT, 
                                     @VE1_COMIS2     FLOAT, 
                                     @VE1_COMIS3     FLOAT, 
                                     @VE1_COMIS4     FLOAT, 
                                     @VE1_COMIS5     FLOAT, 
                                     @VE1_DESCONT    FLOAT, 
                                     @VE1_MULTA      FLOAT, 
                                     @VE1_JUROS      FLOAT, 
                                     @VE1_CORREC     FLOAT, 
                                     @VE1_VALLIQ     FLOAT, 
                                     @VE1_VENCORI    VARCHAR(50), 
                                     @VE1_CONTA      VARCHAR(50), 
                                     @VE1_VALJUR     FLOAT, 
                                     @VE1_PORCJUR    FLOAT, 
                                     @VE1_MOEDA      FLOAT, 
                                     @VE1_BASCOM1    FLOAT, 
                                     @VE1_BASCOM2    FLOAT, 
                                     @VE1_BASCOM3    FLOAT, 
                                     @VE1_BASCOM4    FLOAT, 
                                     @VE1_BASCOM5    FLOAT, 
                                     @VE1_OK         VARCHAR(50), 
                                     @VE1_FATPREF    VARCHAR(50), 
                                     @VE1_FATURA     VARCHAR(50), 
                                     @VE1_PROJETO    VARCHAR(50), 
                                     @VE1_CLASCON    VARCHAR(50), 
                                     @VE1_VALCOM1    FLOAT, 
                                     @VE1_VALCOM2    FLOAT, 
                                     @VE1_VALCOM3    FLOAT, 
                                     @VE1_VALCOM4    FLOAT, 
                                     @VE1_VALCOM5    FLOAT, 
                                     @VE1_OCORREN    VARCHAR(50), 
                                     @VE1_INSTR1     VARCHAR(50), 
                                     @VE1_INSTR2     VARCHAR(50), 
                                     @VE1_PEDIDO     VARCHAR(50), 
                                     @VE1_DTVARIA    VARCHAR(50), 
                                     @VE1_VARURV     FLOAT, 
                                     @VE1_NUMNOTA    VARCHAR(50), 
                                     @VE1_SERIE      VARCHAR(50), 
                                     @VE1_VLCRUZ     FLOAT, 
                                     @VE1_DTFATUR    VARCHAR(50), 
                                     @VE1_IDENTEE    VARCHAR(50), 
                                     @VE1_STATUS     VARCHAR(50), 
                                     @VE1_ORIGEM     VARCHAR(50), 
                                     @VE1_NUMCART    VARCHAR(50), 
                                     @VE1_FLUXO      VARCHAR(50), 
                                     @VE1_DESCFIN    FLOAT, 
                                     @VE1_DIADESC    FLOAT, 
                                     @VE1_CARTAO     VARCHAR(50), 
                                     @VE1_CARTVAL    VARCHAR(50), 
                                     @VE1_VLRREAL    FLOAT, 
                                     @VE1_CARTAUT    VARCHAR(50), 
                                     @VE1_ADM        VARCHAR(50), 
                                     @VE1_TRANSF     VARCHAR(50), 
                                     @VE1_ORDPAGO    VARCHAR(50), 
                                     @VE1_BCOCHQ     VARCHAR(50), 
                                     @VE1_AGECHQ     VARCHAR(50), 
                                     @VE1_CTACHQ     VARCHAR(50), 
                                     @VE1_NUMLIQ     VARCHAR(50), 
                                     @VE1_COFINS     FLOAT, 
                                     @VE1_FLAGFAT    VARCHAR(50), 
                                     @VE1_CSLL       FLOAT, 
                                     @VE1_FILORIG    VARCHAR(50), 
                                     @VE1_PIS        FLOAT, 
                                     @VE1_TIPOFAT    VARCHAR(50), 
                                     @VE1_TIPOLIQ    VARCHAR(50), 
                                     @VE1_MESBASE    VARCHAR(50), 
                                     @VE1_ANOBASE    VARCHAR(50), 
                                     @VE1_PLNUCOB    VARCHAR(50), 
                                     @VE1_CODINT     VARCHAR(50), 
                                     @VE1_CODEMP     VARCHAR(50), 
                                     @VE1_MATRIC     VARCHAR(50), 
                                     @VE1_ACRESC     FLOAT, 
                                     @VE1_SDACRES    FLOAT, 
                                     @VE1_DECRESC    FLOAT, 
                                     @VE1_SDDECRE    FLOAT, 
                                     @VE1_MULTNAT    VARCHAR(50), 
                                     @VE1_MSFIL      VARCHAR(50), 
                                     @VE1_MSEMP      VARCHAR(50), 
                                     @VE1_PROJPMS    VARCHAR(50), 
                                     @VE1_TIPODES    VARCHAR(50), 
                                     @VE1_TXMOEDA    FLOAT, 
                                     @VE1_DESDOBR    VARCHAR(50), 
                                     @VE1_NRDOC      VARCHAR(50), 
                                     @VE1_MODSPB     VARCHAR(50), 
                                     @VE1_FETHAB     FLOAT, 
                                     @VE1_NFELETR    VARCHAR(50), 
                                     @VE1_IDCNAB     VARCHAR(50), 
                                     @VE1_PARCFET    VARCHAR(50), 
                                     @VE1_PLCOEMP    VARCHAR(50), 
                                     @VE1_PLTPCOE    VARCHAR(50), 
                                     @VE1_BASEPIS    FLOAT, 
                                     @VE1_BASECOF    FLOAT, 
                                     @VE1_BASECSL    FLOAT, 
                                     @VE1_CODCOR     VARCHAR(50), 
                                     @VE1_PARCCSS    VARCHAR(50), 
                                     @VE1_SABTPIS    FLOAT, 
                                     @VE1_SABTCOF    FLOAT, 
                                     @VE1_SABTCSL    FLOAT, 
                                     @VD_E_L_E_T_    VARCHAR(50), 
                                     @VR_E_C_N_O_    FLOAT, 
                                     @VR_E_C_D_E_L_  FLOAT, 
                                     @VE1_RECIBO     VARCHAR(50), 
                                     @VE1_DTACRED    VARCHAR(50), 
                                     @VE1_EMITCHQ    VARCHAR(50), 
                                     @VE1_CODORCA    VARCHAR(50), 
                                     @VE1_CODIMOV    VARCHAR(50), 
                                     @VE1_FILDEB     VARCHAR(50), 
                                     @VE1_NUMSOL     VARCHAR(50), 
                                     @VE1_NUMRA      VARCHAR(50), 
                                     @VE1_INSCRIC    VARCHAR(50), 
                                     @VE1_SERREC     VARCHAR(50), 
                                     @VE1_DATAEDI    VARCHAR(50), 
                                     @VE1_CODBAR     VARCHAR(50), 
                                     @VE1_CHQDEV     VARCHAR(50), 
                                     @VE1_CODDIG     VARCHAR(50), 
                                     @VE1_VLBOLSA    FLOAT, 
                                     @VE1_LIDESCF    VARCHAR(50), 
                                     @VE1_VLFIES     FLOAT, 
                                     @VE1_NUMCRD     VARCHAR(50), 
                                     @VE1_DEBITO     VARCHAR(50), 
                                     @VE1_CCD        VARCHAR(50), 
                                     @VE1_ITEMD      VARCHAR(50), 
                                     @VE1_CLVLDB     VARCHAR(50), 
                                     @VE1_CREDIT     VARCHAR(50), 
                                     @VE1_CCC        VARCHAR(50), 
                                     @VE1_ITEMC      VARCHAR(50), 
                                     @VE1_CLVLCR     VARCHAR(50), 
                                     @VE1_DESCON1    FLOAT, 
                                     @VE1_DESCON2    FLOAT, 
                                     @VE1_DTDESC3    VARCHAR(50), 
                                     @VE1_DTDESC1    VARCHAR(50), 
                                     @VE1_DTDESC2    VARCHAR(50), 
                                     @VE1_VLMULTA    FLOAT, 
                                     @VE1_DESCON3    FLOAT, 
                                     @VE1_MOTNEG     VARCHAR(50), 
                                     @VE1_FORNISS    VARCHAR(50), 
                                     @VE1_PARTOT     VARCHAR(50), 
                                     @VE1_SITFAT     VARCHAR(50), 
                                     @VE1_VRETISS    FLOAT, 
                                     @VE1_PARCIRF    VARCHAR(50), 
                                     @VE1_SCORGP     VARCHAR(50), 
                                     @VE1_FRETISS    VARCHAR(50), 
                                     @VE1_TXMDCOR    FLOAT,
                                     @VE1_SATBIRF    FLOAT,
                                     @VE1_TIPREG     VARCHAR(50),
                                     @VE1_CONEMP     VARCHAR(50),
                                     @VE1_VERCON     VARCHAR(50),
                                     @VE1_SUBCON     VARCHAR(50),
                                     @VE1_VERSUB     VARCHAR(50),
                                     @VE1_PLLOTE     VARCHAR(50),
                                     @VE1_PLOPELT    VARCHAR(50),
                                     @VE1_CODRDA     VARCHAR(50),
                                     @VE1_FORMREC    VARCHAR(50),
                                     @VE1_BCOCLI     VARCHAR(50),
                                     @VE1_AGECLI     VARCHAR(50),
                                     @VE1_CTACLI     VARCHAR(50),
                                     @VE1_NUMCON     VARCHAR(50)
                                    ) AS

BEGIN

DECLARE @VDATA            DATETIME;
DECLARE @VCOD_ERRO        VARCHAR(1000);
DECLARE @VERRO            VARCHAR(255);
DECLARE @VOBJETO          VARCHAR(15) SELECT @VOBJETO = 'MERCP_SE1010';
DECLARE	@VINSERE          FLOAT SELECT @VINSERE = 0;
DECLARE @VDB_TBREP_CODIGO NUMERIC;
DECLARE @VEMPRESA	      VARCHAR(3);
DECLARE @VDB_TBPORT_COD   INT SELECT @VDB_TBPORT_COD = 0;
DECLARE @V_DC             SMALLINT;

-------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00001  16/01/2015  SERGIO LUCCHINI  DESENVOLVIMENTO
---  1.00002  06/03/2015  SERGIO LUCCHINI  GRAVAR 1 NO CAMPO CR01_DC
---  1.00003  28/04/2016  ALENCAR          INTEGRA TODOS OS TITULOS, INCLUSIVE OS COM SALDO 0
---                                        NRO DO TITULO: E1_NUM + - + E1_PARCELA
---  1.00004  09/09/2016  ALENCAR          SE @VE1_VEND1 ESTIVER EM BRANCO GRAVA REPRES 0 NO MERCANET
---                                        TITULOS AB, RA e NCC DEVE GRAVAR CR01_DC = -1
---  1.00005  13/09/2016  ALENCAR          Gravar o campo CR01_HISTOR = SUBSTRING(@VE1_HIST, 1, 255)
---  1.00006  15/09/2016  ALENCAR          Regra para gravar os campos: SALDO = E1_SALDO - E1_SDDECRE
---                                                                     DESCONTO = E1_DESCONTO - E1_SDDECRE
---                                        Data de vencimento: 	CR01_DTVCTO   = E1_VENCREA
--- 				                                            CR01_VCTORIG  = E1_VENCTO
---  1.00007  26/10/2016  ALENCAR          Conversão Nova Aliança
-------------------------------------------------------------------------
BEGIN TRY

	IF @VE1_LOJA IN ('SU', 'R:', 'A')
		OR @VE1_CLIENTE LIKE ('%A%')
		OR @VE1_CLIENTE LIKE ('%F%')
		OR @VE1_FILIAL NOT IN ('01')
	BEGIN
	   RETURN;
	END

	SET @VEMPRESA = SUBSTRING(RTRIM(LTRIM(@VE1_FILIAL)), 1, 2)

	print '@VE1_NUM ' + @VE1_NUM

	-- DE/PARA DO PORTADOR
	SELECT @VDB_TBPORT_COD = DB_TBPORT_COD
	  FROM DB_TB_PORT
	 WHERE DB_TBPORT_CODORIG = @VE1_PORTADO;


    IF RTRIM(LTRIM(@VE1_VEND1)) = '' 
	    SET @VDB_TBREP_CODIGO = 0;
	ELSE
		-- DE/PARA DE REPRESENTANTES
		SELECT @VDB_TBREP_CODIGO = DB_TBREP_CODIGO
		  FROM DB_TB_REPRES
		 WHERE DB_TBREP_CODORIG = RTRIM(LTRIM(@VE1_VEND1));
	SET @VCOD_ERRO = @@ERROR;
	IF @VCOD_ERRO > 0
	BEGIN
	   SET @VDB_TBREP_CODIGO = 0;
	END

	IF @VD_E_L_E_T_ <> ' '
	BEGIN

	   DELETE FROM MCR01
		WHERE CR01_EMPRESA = @VEMPRESA
		  AND CR01_TIPODOC = LTRIM(RTRIM(@VE1_TIPO))
		  AND CR01_TITULO  = RTRIM(LTRIM(@VE1_NUM)) + '-' + RTRIM(@VE1_PARCELA)
		  AND CR01_CLIENTE = @VE1_CLIENTE;
	   SET @VCOD_ERRO = @@ERROR;
	   IF @VCOD_ERRO > 0
	   BEGIN
		 SET @VERRO = '1 - ERRO DELETE MCR01:' + @VE1_NUM + ' - ERRO BANCO: ' + @VCOD_ERRO;
	   END

	END
	ELSE
	BEGIN

	   IF @VE1_TIPO IN ('AB', 'RA', 'NCC')
	      SET @V_DC = -1
	   ELSE 
	      SET @V_DC = 1

	   SELECT @VINSERE = 1
		 FROM MCR01
		WHERE CR01_EMPRESA = @VEMPRESA
		  AND CR01_TIPODOC = LTRIM(RTRIM(@VE1_TIPO))
		  AND CR01_TITULO  = RTRIM(@VE1_NUM) + '-' + RTRIM(@VE1_PARCELA)
		  AND CR01_CLIENTE = @VE1_CLIENTE;

	   IF @VINSERE = 0
	   BEGIN

		  INSERT INTO MCR01
			(
			 CR01_EMPRESA,   -- 01
			 CR01_TIPODOC,   -- 02
			 CR01_TITULO,    -- 03
			 CR01_CLIENTE,   -- 04
			 CR01_DTEMIS,    -- 05
			 CR01_DTVCTO,    -- 06
			 CR01_VCTORIG,   -- 07
			 CR01_PORTADOR,  -- 08
			 CR01_VLTOTAL,   -- 09
			 CR01_SALDO,     -- 10
			 CR01_REPRES,    -- 12
			 CR01_NFNRO,     -- 13
			 CR01_NFSER,     -- 14
			 CR01_DC,        -- 15
			 CR01_VLJURO,    -- 16
			 CR01_VDCTFIN,   -- 17
			 CR01_HISTOR     -- 18
			)
		  VALUES
			(
			 @VEMPRESA,                                           -- 01
			 LTRIM(RTRIM(@VE1_TIPO)),                             -- 02
			 RTRIM(LTRIM(@VE1_NUM)) + '-' + RTRIM(@VE1_PARCELA),  -- 03
			 @VE1_CLIENTE,                                        -- 04
			 CONVERT(CHAR,RTRIM(LTRIM(@VE1_EMISSAO)),103),        -- 05
			 CONVERT(CHAR,RTRIM(LTRIM(@VE1_VENCREA)),103),        -- 06
			 CONVERT(CHAR,RTRIM(LTRIM(@VE1_VENCTO)),103),         -- 07
			 @VDB_TBPORT_COD,                                     -- 08
			 @VE1_VALOR,                                          -- 09
			 ISNULL(@VE1_SALDO, 0) - ISNULL(@VE1_SDDECRE, 0),     -- 10
			 @VDB_TBREP_CODIGO,                                   -- 12
			 REPLACE(RTRIM(LTRIM(@VE1_NUMNOTA)), '/', ''),        -- 13
			 REPLACE(RTRIM(LTRIM(@VE1_SERIE)), '-', ''),          -- 14
			 @V_DC,                                               -- 15
			 @VE1_VALJUR,                                         -- 16
			 ISNULL(@VE1_DESCONT, 0) + ISNULL(@VE1_SDDECRE, 0),   -- 17
			 SUBSTRING(@VE1_HIST, 1, 255)                         -- 18
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '1 - ERRO INSERT DB_CTA_RECEBER:' + @VE1_NUM + ' - ERRO BANCO: ' + @VCOD_ERRO;
		  END

	   END
	   ELSE
	   BEGIN

 	      UPDATE MCR01
			 SET CR01_DTEMIS   = CONVERT(CHAR,RTRIM(LTRIM(@VE1_EMISSAO)),103),
				 CR01_DTVCTO   = CONVERT(CHAR,RTRIM(LTRIM(@VE1_VENCREA)),103),
				 CR01_VCTORIG  = CONVERT(CHAR,RTRIM(LTRIM(@VE1_VENCTO)),103),
				 CR01_PORTADOR = @VDB_TBPORT_COD,
				 CR01_VLTOTAL  = @VE1_VALOR,
				 CR01_SALDO    = ISNULL(@VE1_SALDO, 0) - ISNULL(@VE1_SDDECRE, 0),
				 CR01_REPRES   = @VDB_TBREP_CODIGO,
				 CR01_NFNRO    = REPLACE(RTRIM(LTRIM(@VE1_NUMNOTA)), '/', ''),
				 CR01_NFSER    = REPLACE(RTRIM(LTRIM(@VE1_SERIE)), '-', ''),
				 CR01_VLJURO   = @VE1_VALJUR,
				 CR01_VDCTFIN  = ISNULL(@VE1_DESCONT, 0) + ISNULL(@VE1_SDDECRE, 0),
				 CR01_DC       = @V_DC,
				 CR01_HISTOR   = SUBSTRING(@VE1_HIST, 1, 255)
		   WHERE CR01_EMPRESA = @VEMPRESA
			 AND CR01_TIPODOC = LTRIM(RTRIM(@VE1_TIPO))
			 AND CR01_TITULO  = RTRIM(@VE1_NUM) + '-' + RTRIM(@VE1_PARCELA)
			 AND CR01_CLIENTE = @VE1_CLIENTE;
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '1 - ERRO UPDATE MCR01:' + @VE1_NUM + ' - ERRO BANCO: ' + @VCOD_ERRO;
		  END

	   END  -- IF @VINSERE = 0

	END  -- IF @VE1_SALDO <= 0 OR @VD_E_L_E_T_ <> ' '

	-- ATUALIZA O PARAMETRO DE CONTAS A RECEBER
	UPDATE DB_PARAMETRO
	   SET DB_PRM_DATA_POSCR  = GETDATE()
	 WHERE CONVERT(CHAR,DB_PRM_DATA_POSCR,101) <> CONVERT(CHAR,GETDATE(),101);

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

   INSERT INTO DBS_ERROS_TRIGGERS
  		(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
		VALUES
  		( @VERRO, getdate(), @VOBJETO );			
END CATCH

END
GO
