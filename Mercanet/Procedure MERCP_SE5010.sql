SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SE5010](@VEVENTO        FLOAT,
                                    @VE5_FILIAL	varchar(2),
									@VE5_DATA	varchar(8),
									@VE5_TIPO	varchar(3),
									@VE5_MOEDA	varchar(2),
									@VE5_VALOR	float,
									@VE5_NATUREZ	varchar(10),
									@VE5_BANCO	varchar(3),
									@VE5_AGENCIA	varchar(5),
									@VE5_CONTA	varchar(10),
									@VE5_NUMCHEQ	varchar(15),
									@VE5_DOCUMEN	varchar(50),
									@VE5_VENCTO	varchar(8),
									@VE5_RECPAG	varchar(1),
									@VE5_BENEF	varchar(30),
									@VE5_HISTOR	varchar(40),
									@VE5_TIPODOC	varchar(2),
									@VE5_VLMOED2	float,
									@VE5_LA	varchar(2),
									@VE5_SITUACA	varchar(1),
									@VE5_LOTE	varchar(8),
									@VE5_PREFIXO	varchar(3),
									@VE5_NUMERO	varchar(9),
									@VE5_PARCELA	varchar(1),
									@VE5_CLIFOR	varchar(6),
									@VE5_LOJA	varchar(2),
									@VE5_DTDIGIT	varchar(8),
									@VE5_TIPOLAN	varchar(1),
									@VE5_DEBITO	varchar(20),
									@VE5_CREDITO	varchar(20),
									@VE5_MOTBX	varchar(3),
									@VE5_RATEIO	varchar(1),
									@VE5_RECONC	varchar(1),
									@VE5_SEQ	varchar(2),
									@VE5_DTDISPO	varchar(8),
									@VE5_CCD	varchar(9),
									@VE5_CCC	varchar(9),
									@VE5_OK	varchar(2),
									@VE5_ARQRAT	varchar(50),
									@VE5_IDENTEE	varchar(6),
									@VE5_ORDREC	varchar(6),
									@VE5_FILORIG	varchar(2),
									@VE5_ARQCNAB	varchar(12),
									@VE5_VLJUROS	float,
									@VE5_VLMULTA	float,
									@VE5_VLCORRE	float,
									@VE5_VLDESCO	float,
									@VE5_CNABOC	varchar(2),
									@VE5_SITUA	varchar(2),
									@VE5_ITEMD	varchar(9),
									@VE5_ITEMC	varchar(9),
									@VE5_CLVLDB	varchar(9),
									@VE5_CLVLCR	varchar(9),
									@VE5_PROJPMS	varchar(10),
									@VE5_EDTPMS	varchar(12),
									@VE5_TASKPMS	varchar(12),
									@VE5_MODSPB	varchar(1),
									@VE5_FATURA	varchar(9),
									@VE5_TXMOEDA	float,
									@VE5_CODORCA	varchar(8),
									@VE5_FATPREF	varchar(3),
									@VE5_SITCOB	varchar(1),
									@VE5_FORNADT	varchar(6),
									@VE5_LOJAADT	varchar(2),
									@VE5_CLIENTE	varchar(6),
									@VE5_FORNECE	varchar(6),
									@VE5_SERREC	varchar(3),
									@VE5_OPERAD	varchar(6),
									@VE5_MOVCX	varchar(1),
									@VE5_KEY	varchar(50),
									@VE5_MULTNAT	varchar(1),
									@VE5_AGLIMP	varchar(9),
									@VE5_VLACRES	float,
									@VE5_VLDECRE	float,
									@VE5_VRETPIS	float,
									@VE5_VRETCOF	float,
									@VE5_VRETCSL	float,
									@VE5_PRETPIS	varchar(1),
									@VE5_PRETCOF	varchar(1),
									@VE5_PRETCSL	varchar(1),
									@VE5_AUTBCO	varchar(25),
									@VE5_PRETIRF	varchar(1),
									@VE5_VRETIRF	float,
									@VE5_VRETISS	float,
									@VE5_NUMMOV	varchar(2),
									@VE5_DIACTB	varchar(2),
									@VE5_NODIA	varchar(10),
									@VE5_BASEIRF	float,
									@VE5_PROCTRA	varchar(20),
									@VD_E_L_E_T_	varchar(1),
									@VR_E_C_N_O_	int,
									@VE5_ORIGEM	varchar(8),
									@VE5_FORMAPG	varchar(5),
									@VE5_TPDESC	varchar(1),
									@VE5_PRINSS	float,
									@VE5_PRISS	float,
									@VE5_PRETINS	varchar(1),
									@VE5_VRETINS	float,
									@VE5_IDMOVI	varchar(10),
									@VE5_DTCANBX	varchar(8),
									@VE5_FLDMED	varchar(1),
									@VE5_CGC	varchar(14)
                                    ) AS

BEGIN

DECLARE @VDATA            DATETIME;
DECLARE @VCOD_ERRO        VARCHAR(1000);
DECLARE @VERRO            VARCHAR(255);
DECLARE @VOBJETO          VARCHAR(15) SELECT @VOBJETO = 'MERCP_SE5020';
DECLARE	@VINSERE          FLOAT SELECT @VINSERE = 0;
DECLARE @VEMPRESA	      VARCHAR(3);
DECLARE @V_TEM_SE1        FLOAT;


-------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00001  28/04/2016  ALENCAR          DESENVOLVIMENTO - Integra MCR02
---  1.00002  31/10/2016  ALENCAR          Conversao Nova Alianca
---           02/05/2018  ROBERT           Alterado nome do linked server de acesso ao ERP Protheus.
---           23/03/2022  Robert           Versao inicial utilizando sinonimos
-------------------------------------------------------------------------

BEGIN TRY

	IF @VE5_LOJA IN ('SU', 'R:', 'A')
		OR @VE5_CLIENTE LIKE ('%A%')
		OR @VE5_CLIENTE LIKE ('%F%')
		OR @VE5_FILIAL NOT IN ('01')
	BEGIN
	   RETURN;
	END


	----------------------------
	--- So integra o movimento se tem relacionamento com a SE1
	----------------------------
	SET @V_TEM_SE1 = 0;

	SELECT @V_TEM_SE1 = 1
	  FROM INTEGRACAO_PROTHEUS_SE1
	 WHERE E1_FILIAL     = @VE5_FILIAL 
	   AND E1_PREFIXO    = @VE5_PREFIXO 
	   AND E1_NUM        = @VE5_NUMERO
	   AND E1_PARCELA    = @VE5_PARCELA 
	   AND E1_TIPO       = @VE5_TIPO 
	   AND E1_CLIENTE    = @VE5_CLIENTE;

	PRINT '@V_TEM_SE1 ' + CAST(@V_TEM_SE1 AS VARCHAR)

	IF @V_TEM_SE1 = 0 
	   RETURN;


	SET @VEMPRESA = SUBSTRING(RTRIM(LTRIM(@VE5_FILIAL)), 1, 2)

	print '@VE5_NUMERO ' + @VE5_NUMERO


	IF @VD_E_L_E_T_ <> ' '
	BEGIN

	   DELETE FROM MCR02
		WHERE CR02_EMPRESA = @VEMPRESA
		  AND CR02_TIPODOC = LTRIM(RTRIM(@VE5_TIPO))
		  AND CR02_TITULO  = RTRIM(@VE5_NUMERO) + '-' + RTRIM(@VE5_PARCELA)
		  AND CR02_CLIENTE = @VE5_CLIENTE
		  AND CR02_SEQLCTO = @VE5_SEQ;
	   SET @VCOD_ERRO = @@ERROR;
	   IF @VCOD_ERRO > 0
	   BEGIN
		 SET @VERRO = '1 - ERRO DELETE MCR02:' + @VE5_NUMERO + ' - ERRO BANCO: ' + @VCOD_ERRO;
	   END

	END
	ELSE
	BEGIN

	   SELECT @VINSERE = 1
		 FROM MCR02
		WHERE CR02_EMPRESA = @VEMPRESA
		  AND CR02_TIPODOC = LTRIM(RTRIM(@VE5_TIPO))
		  AND CR02_TITULO  = RTRIM(@VE5_NUMERO) + '-' + RTRIM(@VE5_PARCELA)
		  AND CR02_CLIENTE = @VE5_CLIENTE
		  AND CR02_SEQLCTO = @VE5_SEQ;

	   IF @VINSERE = 0
	   BEGIN

		  INSERT INTO MCR02
			(
			CR02_EMPRESA,             -- 01
			CR02_TIPODOC,             -- 02
			CR02_TITULO,              -- 03
			CR02_CLIENTE,             -- 04
			CR02_SEQLCTO,             -- 05
			--CR02_CODHIST,             -- 06
			CR02_VLPGTO,              -- 07
			CR02_VLDESC,              -- 08
			CR02_VLJURO,              -- 09
			CR02_DTLCTO,              -- 10
			CR02_DTLCTOCORP           -- 11
			)
		  VALUES
			(
			 @VEMPRESA,                                     -- 01
			 LTRIM(RTRIM(@VE5_TIPO)),                       -- 02
			 RTRIM(LTRIM(@VE5_NUMERO)) + '-' + RTRIM(@VE5_PARCELA),                        -- 03
			 @VE5_CLIENTE,                                  -- 04
			 @VE5_SEQ,                                      -- 05
			 --LTRIM(RTRIM(@VE5_HISTOR)),                   -- 06
			 @VE5_VALOR,                                    -- 07
			 @VE5_VLDESCO,                                  -- 08
			 @VE5_VLJUROS,                                  -- 09
			 CONVERT(CHAR,RTRIM(LTRIM(@VE5_DATA)),103),     -- 10
			 CONVERT(CHAR,RTRIM(LTRIM(@VE5_DATA)),103)      -- 11
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '1 - ERRO INSERT MCR02:' + @VE5_NUMERO + ' - ERRO BANCO: ' + @VCOD_ERRO;
		  END

	   END
	   ELSE
	   BEGIN

		  UPDATE MCR02
			 SET --CR02_CODHIST	= LTRIM(RTRIM(@VE5_HISTOR))
				 CR02_VLPGTO	= @VE5_VALOR
			   , CR02_VLDESC	= @VE5_VLDESCO
			   , CR02_VLJURO	= @VE5_VLJUROS
			   , CR02_DTLCTO    = CONVERT(CHAR,RTRIM(LTRIM(@VE5_DATA)),103)
			   , CR02_DTLCTOCORP = CONVERT(CHAR,RTRIM(LTRIM(@VE5_DATA)),103)
		   WHERE CR02_EMPRESA = @VEMPRESA
			 AND CR02_TIPODOC = LTRIM(RTRIM(@VE5_TIPO))
			 AND CR02_TITULO  = RTRIM(@VE5_NUMERO) + '-' + RTRIM(@VE5_PARCELA)
			 AND CR02_CLIENTE = @VE5_CLIENTE
			 AND CR02_SEQLCTO	= @VE5_SEQ;
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '1 - ERRO UPDATE MCR02:' + @VE5_NUMERO + ' - ERRO BANCO: ' + @VCOD_ERRO;
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
