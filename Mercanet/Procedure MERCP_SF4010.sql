SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SF4010](@VEVENTO      FLOAT,
									@VF4_FILIAL     VARCHAR(10),
									@VF4_CODIGO     VARCHAR(10), 
									@VF4_TIPO       VARCHAR(10), 
									@VF4_ICM        VARCHAR(10), 
									@VF4_IPI        VARCHAR(10), 
									@VF4_CREDICM    VARCHAR(10), 
									@VF4_CREDIPI    VARCHAR(10), 
									@VF4_DUPLIC     VARCHAR(10), 
									@VF4_ESTOQUE    VARCHAR(10), 
									@VF4_CF         VARCHAR(10), 
									@VF4_TEXTO      VARCHAR(20), 
									@VF4_BASEIPI    FLOAT, 
									@VF4_PODER3     VARCHAR(10), 
									@VF4_LFICM      VARCHAR(10), 
									@VF4_LFIPI      VARCHAR(10), 
									@VF4_DESTACA    VARCHAR(10), 
									@VF4_INCIDE     VARCHAR(10), 
									@VF4_COMPL      VARCHAR(10), 
									@VF4_IPIFRET    VARCHAR(10), 
									@VF4_ISS        VARCHAR(10), 
									@VF4_LFISS      VARCHAR(10), 
									@VF4_NRLIVRO    VARCHAR(10), 
									@VF4_UPRC       VARCHAR(10), 
									@VF4_CONSUMO    VARCHAR(10), 
									@VF4_FORMULA    VARCHAR(10), 
									@VF4_AGREG      VARCHAR(10), 
									@VF4_CIAP       VARCHAR(10), 
									@VF4_INCSOL     VARCHAR(10), 
									@VF4_DESPIPI    VARCHAR(10), 
									@VF4_LIVRO      VARCHAR(64), 
									@VF4_ATUTEC     VARCHAR(10), 
									@VF4_ATUATF     VARCHAR(10), 
									@VF4_TPIPI      VARCHAR(10), 
									@VF4_PISCOF     VARCHAR(10), 
									@VF4_PISCRED    VARCHAR(10), 
									@VF4_BASEISS    FLOAT, 
									@VF4_BSICMST    FLOAT, 
									@VF4_CREDST     VARCHAR(10), 
									@VF4_STDESC     VARCHAR(10), 
									@VF4_DESPICM    VARCHAR(10), 
									@VF4_SITTRIB    VARCHAR(10), 
									@VF4_TESDV      VARCHAR(10), 
									@VF4_MOVPRJ     VARCHAR(10), 
									@VF4_IPILICM    VARCHAR(10), 
									@VF4_ICMSDIF    VARCHAR(10), 
									@VF4_TESP3      VARCHAR(10), 
									@VF4_QTDZERO    VARCHAR(10), 
									@VF4_SLDNPT     VARCHAR(10), 
									@VF4_DEVZERO    VARCHAR(10), 
									@VF4_TIPOPER    VARCHAR(10), 
									@VF4_TRFICM     VARCHAR(10), 
									@VF4_TESENV     VARCHAR(10), 
									@VF4_REGDSTA    VARCHAR(10), 
									@VF4_LFICMST    VARCHAR(10), 
									@VF4_PSCFST     VARCHAR(10), 
									@VF4_CRDTRAN    FLOAT, 
									@VF4_ISSST      VARCHAR(10), 
									@VF4_CONTSOC    VARCHAR(10), 
									@VF4_CRPRST     FLOAT, 
									@VF4_IPIPC      VARCHAR(10), 
									@VF4_CRPRELE    FLOAT, 
									@VF4_CTIPI      VARCHAR(10), 
									@VF4_CALCFET    VARCHAR(10), 
									@VF4_OBSICM     VARCHAR(10), 
									@VF4_OBSSOL     VARCHAR(10), 
									@VF4_CFPS       VARCHAR(10), 
									@VD_E_L_E_T_    VARCHAR(10), 
									@VR_E_C_N_O_    FLOAT, 
									@VR_E_C_D_E_L_  FLOAT, 
									@VF4_CFEXT      VARCHAR(10), 
									@VF4_BASEPIS    FLOAT, 
									@VF4_BASECOF    FLOAT, 
									@VF4_MSBLQL     VARCHAR(10), 
									@VF4_PICMDIF    FLOAT, 
									@VF4_SELO       VARCHAR(10), 
									@VF4_FINALID    VARCHAR(260), 
									@VF4_RETISS     VARCHAR(10), 
									@VF4_TPREG      VARCHAR(10), 
									@VF4_AFRMM      VARCHAR(10), 
									@VF4_CRDPRES    FLOAT, 
									@VF4_DSPRDIC    VARCHAR(10), 
									@VF4_AGRCOF     VARCHAR(10), 
									@VF4_AGRPIS     VARCHAR(10), 
									@VF4_CRDEST     VARCHAR(10), 
									@VF4_COFDSZF    VARCHAR(10), 
									@VF4_PISBRUT    VARCHAR(10), 
									@VF4_COFBRUT    VARCHAR(10), 
									@VF4_PISDSZF    VARCHAR(10), 
									@VF4_BCRDPIS    FLOAT, 
									@VF4_BCRDCOF    FLOAT, 
									@VF4_TRANFIL    VARCHAR(10), 
									@VF4_OPEMOV     VARCHAR(10), 
									@VF4_FRETAUT    VARCHAR(10), 
									@VF4_MKPCMP     VARCHAR(10), 
									@VF4_ICMSST     VARCHAR(10), 
									@VF4_BENSATF    VARCHAR(10), 
									@VF4_AGRRETC    VARCHAR(10), 
									@VF4_TESE3      VARCHAR(10), 
									@VF4_IPIOBS     VARCHAR(10), 
									@VF4_MKPSOL     VARCHAR(10),
									@VF4_MARGEM     VARCHAR(20)
									) AS

BEGIN

	DECLARE @VDATA DATETIME,
			@VCOD_ERRO VARCHAR(1000),
			@VERRO VARCHAR(255),
			@VOBJETO VARCHAR(15) SELECT @VOBJETO = 'MERCP_SF4010 ';
	DECLARE	@VINSERE FLOAT SELECT @VINSERE = 0;
	DECLARE @VDB_TBOPS_FAT VARCHAR(1);

--------------------------------------------------------------------------------
--- VERSÃO     DATA     ALTERAÇÃO
--- 1.00001 11/10/2016  ALENCAR  Conversão Nova Aliança
--- 1.00002 26/04/2017  ALENCAR  Não atualiza o campo DB_TBOPS_FAT no update
--- 1.00003 16/06/2017  ALENCAR  Atualizar o campo DB_TBOPS_FAT com informacoes do F4_MARGEM
--------------------------------------------------------------------------------


BEGIN TRY

	IF @VF4_CODIGO = ' ' 
	BEGIN
	    RETURN;
	END 


    IF @VEVENTO = 2 OR @VD_E_L_E_T_ <> ' '
    BEGIN

        DELETE FROM DB_TB_OPERS 
              WHERE DB_TBOPS_COD = @VF4_CODIGO;
	END
    ELSE    
    BEGIN
	     
		   -- @VF4_MARGEM = 1 - VENDA
		   --               2 - DEVOLUÇÕES
		   --               3 - BONIFICAÇÃO
		   --               9 - OUTRAS SAIDAS

            IF @VF4_MARGEM = '1'
	            SET @VDB_TBOPS_FAT = 'S';
			ELSE IF @VF4_MARGEM = '2'
			    SET @VDB_TBOPS_FAT = 'D';
			ELSE IF @VF4_MARGEM = '3'
			    SET @VDB_TBOPS_FAT = 'B';
			ELSE IF @VF4_MARGEM = '9'
			    SET @VDB_TBOPS_FAT = 'N';
			ELSE SET @VDB_TBOPS_FAT = 'S';

			
            SELECT @VINSERE = 1
              FROM DB_TB_OPERS
             WHERE DB_TBOPS_COD = @VF4_CODIGO;
		    
		    SET @VCOD_ERRO = @@ERROR;
			IF @VCOD_ERRO > 0
			BEGIN
				SET  @VINSERE = 0;
			END
                    
        IF @VINSERE = 0
        BEGIN

            INSERT INTO DB_TB_OPERS
            (
                DB_TBOPS_COD,
                DB_TBOPS_DESCR,
                DB_TBOPS_NATUR,
                DB_TBOPS_TRIB_ICMS,
                DB_TBOPS_TRIB_IPI,
                DB_TBOPS_DESCTO,
                DB_TBOPS_FAT,
                DB_TBOPS_SITUACAO
            )
            VALUES
            (
                @VF4_CODIGO,
                RTRIM(@VF4_TEXTO),
                @VF4_CF,
                CASE WHEN @VF4_ICM = 'S' THEN 0 ELSE 1 END,
                CASE WHEN @VF4_IPI = 'S' THEN 0 ELSE 1 END,
                0,
				@VDB_TBOPS_FAT,
				'I'
            );
			SET @VCOD_ERRO = @@ERROR;
			IF @VCOD_ERRO > 0
			BEGIN
				SET @VERRO = '1 - ERRO INSERT DB_TB_OPERS:' + @VF4_CODIGO + ' - ERRO BANCO: ' + @VCOD_ERRO;
			END
		END      
        ELSE
		BEGIN
            UPDATE DB_TB_OPERS
               SET DB_TBOPS_DESCR     = RTRIM(@VF4_TEXTO),
                   DB_TBOPS_NATUR     = @VF4_CF,
                   DB_TBOPS_TRIB_ICMS = CASE WHEN @VF4_ICM = 'S' THEN 0 ELSE 1 END,
                   DB_TBOPS_TRIB_IPI  = CASE WHEN @VF4_IPI = 'S' THEN 0 ELSE 1 END,
                   DB_TBOPS_FAT       = @VDB_TBOPS_FAT,
                   DB_TBOPS_SITUACAO  = 'I'
             WHERE DB_TBOPS_COD = @VF4_CODIGO;
             
            SET @VCOD_ERRO = @@ERROR;
			IF @VCOD_ERRO > 0
			BEGIN
				SET @VERRO = '1 - ERRO UPDATE DB_TB_OPERS:' + @VF4_CODIGO + ' - ERRO BANCO: ' + @VCOD_ERRO;
			END  
        END    

        --- Gravar o percentual de PIS
		MERGE INTO DB_TB_OPERS_PERC  AS TARGET
		 USING(SELECT @VF4_CODIGO    F4_CODIGO
		            , 1              IMPOSTO
					, '2017-01-01'   DT_INI
                    , '2099-12-31'   DT_FIN
                    , 3.2            PERC
				    , (SELECT ISNULL(MAX(DB_TBOPSP_SEQ), 0) + 1 
					     FROM DB_TB_OPERS_PERC 
						WHERE DB_TBOPSP_COD = @VF4_CODIGO)  SEQ_MAX
					) AS SOURCE
		 ON ( TARGET.DB_TBOPSP_COD        = SOURCE.F4_CODIGO
		  AND TARGET.DB_TBOPSP_IMPOSTO   = SOURCE.IMPOSTO)
		 WHEN MATCHED THEN
			UPDATE SET DB_TBOPSP_IMPOSTO = SOURCE.IMPOSTO
                     , DB_TBOPSP_DT_INI  = SOURCE.DT_INI
                     , DB_TBOPSP_DT_FIN  = SOURCE.DT_FIN
                     , DB_TBOPSP_PERC    = SOURCE.PERC
		 WHEN NOT MATCHED THEN
			INSERT (DB_TBOPSP_COD    
                   , DB_TBOPSP_SEQ    
                   , DB_TBOPSP_IMPOSTO
                   , DB_TBOPSP_DT_INI
                   , DB_TBOPSP_DT_FIN
                   , DB_TBOPSP_PERC 
				  )
			VALUES (SOURCE.F4_CODIGO
			      , SOURCE.SEQ_MAX
				  , SOURCE.IMPOSTO
				  , SOURCE.DT_INI
				  , SOURCE.DT_FIN
				  , SOURCE.PERC
				  );




    END
           
    IF @VERRO IS NOT NULL
	BEGIN
		SET @VDATA = GETDATE();
		INSERT INTO DBS_ERROS_TRIGGERS
			(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
		VALUES
			( @VERRO, @VDATA, @VOBJETO );
			
	END
END TRY

BEGIN CATCH
   SELECT @VERRO = cast(ERROR_NUMBER() as varchar) + ERROR_MESSAGE()

   INSERT INTO DBS_ERROS_TRIGGERS
  		(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
		VALUES
  		( @VERRO, @VDATA, @VOBJETO );			
END CATCH

END
GO
