SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SA4010] (@VEVENTO FLOAT,
            @VA4_FILIAL     VARCHAR(40), 
            @VA4_COD        VARCHAR(40), 
            @VA4_NOME       VARCHAR(40), 
            @VA4_NREDUZ     VARCHAR(40), 
            @VA4_VIA        VARCHAR(40), 
            @VA4_END        VARCHAR(40), 
            @VA4_MUN        VARCHAR(40), 
            @VA4_CEP        VARCHAR(40), 
            @VA4_EST        VARCHAR(40), 
            @VA4_CGC        VARCHAR(40), 
            @VA4_TEL        VARCHAR(40), 
            @VA4_TELEX      VARCHAR(40), 
            @VA4_CONTATO    VARCHAR(40), 
            @VA4_INSEST     VARCHAR(40), 
            @VA4_EMAIL      VARCHAR(40), 
            @VA4_HPAGE      VARCHAR(40), 
            @VA4_BAIRRO     VARCHAR(40), 
            @VA4_DDI        VARCHAR(40), 
            @VA4_DDD        VARCHAR(40), 
            @VA4_ENDPAD     VARCHAR(40), 
            @VD_E_L_E_T_    VARCHAR(40), 
            @VR_E_C_N_O_    FLOAT, 
            @VR_E_C_D_E_L_  FLOAT, 
            @VA4_ESTFIS     VARCHAR(40), 
            @VA4_LOCAL      VARCHAR(40)) AS

BEGIN

DECLARE @VDATA     DATETIME;
DECLARE @VCOD_ERRO VARCHAR(1000);
DECLARE @VERRO     VARCHAR(255);
DECLARE @VOBJETO   VARCHAR(15) SELECT @VOBJETO = 'MERCP_SA4010 ';
DECLARE	@VINSERE   FLOAT SELECT @VINSERE = 0;

-------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00001  11/10/2016  ALENCAR          Conversão Nova Aliança
---			  27/08/2019  ANDRE			   TRATAMENTO PARA TRANSPORTADORA COM '/' NO CODIGO	
-------------------------------------------------------------------------


BEGIN TRY

	IF @VEVENTO = 2 OR @VD_E_L_E_T_ <> ' '
	   BEGIN
			DELETE FROM DB_TB_TRANSP WHERE DB_TBTRA_COD = @VA4_COD;
		END 
		ELSE    
		BEGIN
				SELECT @VINSERE = 1 
				  FROM DB_TB_TRANSP 
				 WHERE DB_TBTRA_COD = @VA4_COD;
             
				SET @VCOD_ERRO = @@ERROR;
				IF @VCOD_ERRO > 0
				BEGIN
					SET  @VINSERE = 0;
				END
        
			IF @VINSERE = 0
			BEGIN
        
				INSERT INTO DB_TB_TRANSP 
				(                
					DB_TBTRA_COD, 
					DB_TBTRA_NOME, 
					DB_TBTRA_COGNOME, 
					DB_TBTRA_CIDADE, 
					DB_TBTRA_ESTADO, 
					DB_TBTRA_ENDERECO, 
					DB_TBTRA_ATIVO, 
					DB_TBTRA_CGCMF, 
					DB_TBTRA_EMPRESAS,
					DB_TBTRA_PLACA,
					DB_TBTRA_CGCTE, 
					DB_TBTRA_TP_PESSOA, 
					DB_TBTRA_UF_PLACA, 
					DB_TBTRA_TELEFONE, 
					DB_TBTRA_BAIRRO 
				)
				VALUES
				(
					REPLACE(@VA4_COD,'/',''),
					RTRIM(LTRIM(SUBSTRING(@VA4_NOME,1,40))),
					RTRIM(LTRIM(SUBSTRING(@VA4_NREDUZ,1,15))),
					RTRIM(LTRIM(SUBSTRING(@VA4_MUN,1,30))),
					RTRIM(LTRIM(@VA4_EST)),
					RTRIM(LTRIM(SUBSTRING(@VA4_END,1,30))),
					1,
					@VA4_CGC,
					NULL,
					NULL,
					@VA4_INSEST,
					NULL,
					NULL,
					@VA4_TEL,
					SUBSTRING(RTRIM(LTRIM(@VA4_BAIRRO)),1,25)
				);
				SET @VCOD_ERRO = @@ERROR;
				IF @VCOD_ERRO > 0
				BEGIN
					SET @VERRO = '1 - ERRO INSERT DB_TB_TRANSP:' + @VA4_COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
				END   
    
			END
			ELSE
			BEGIN
    
				UPDATE DB_TB_TRANSP
				   SET DB_TBTRA_NOME     = RTRIM(LTRIM(SUBSTRING(@VA4_NOME,1,40))),
					   DB_TBTRA_COGNOME  = RTRIM(LTRIM(SUBSTRING(@VA4_NREDUZ,1,15))),
					   DB_TBTRA_CIDADE   = RTRIM(LTRIM(SUBSTRING(@VA4_MUN,1,30))),
					   DB_TBTRA_ESTADO   = RTRIM(LTRIM(@VA4_EST)),
					   DB_TBTRA_ENDERECO = RTRIM(LTRIM(SUBSTRING(@VA4_END,1,30))),
					   DB_TBTRA_CGCMF    = @VA4_CGC,
					   DB_TBTRA_CGCTE    = @VA4_INSEST,
					   DB_TBTRA_TELEFONE = @VA4_TEL,
					   DB_TBTRA_BAIRRO   = SUBSTRING(RTRIM(LTRIM(@VA4_BAIRRO)),1,25)
				 WHERE DB_TBTRA_COD = @VA4_COD;
				SET @VCOD_ERRO = @@ERROR;
				IF @VCOD_ERRO > 0
				BEGIN
				   SET @VERRO = '1 - ERRO UPDATE DB_TB_TRANSP:' + @VA4_COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
				END   
             
    		END
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
  		( @VERRO, getdate(), @VOBJETO );			
END CATCH

END
GO
