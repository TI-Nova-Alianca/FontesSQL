SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_ATUALIZA_RETORNO_CLIENTE] AS

BEGIN

DECLARE	@VERRO               VARCHAR(255);
DECLARE @VOBJETO             VARCHAR(30) SELECT @VOBJETO = 'MERCP_ATUALIZA_RETORNO_CLIENTE';
DECLARE @V_ZA1_CODMER      VARCHAR(20)
      , @V_ZA1_COD         VARCHAR(6)
	  , @V_ZA1_STATUS      VARCHAR(3)
      , @V_ZA1_ERRO        VARCHAR(2047)
	  ,	@V_ZA1_DTINI	   VARCHAR(8)
	  , @V_ZA1_HRINI       VARCHAR(8)
	  , @V_R_E_C_N_O_      INT;


---------------------------------------------------------
--- VERSAO   DATA        AUTOR           ALTERACAO
--- 1.00001  09/05/2016  ALENCAR         DESENVOLVIMENTO - Rotina que busca as informações processadas na tabela de interface de clientes e atualiza no Mercanet
---                                                        É atualizada no final da rotina de exportação (MERCP_CONCORRENTE_EXPORT_CLIENTE)
--- 1.00001  16/05/2016  ALENCAR         Quando o cliente retorna deve retirar a restrição que não permite digitar pedidos.
--- 1.00002  18/05/2016  ALENCAR         Quando o cliente retorna nao deve mais retirar a retrição. A restricao eh retirada somente quando o cliente eh desbloquado no Protheus, atraves da trigger da SA1010
--- 1.00003  20/06/2016  ALENCAR         Atualiza o codigo também na DB_CLIENTE_REPRES
--- 1.00004  10/11/2016  ALENCAR         Conversao Nova Alianca
---------------------------------------------------------

BEGIN TRY

    --------------------------------
	----- Atualiza clientes da interface da ZA1010
	----- Busca todos os registros que nao foram processados pelo retorno do Mercanet (ZA1_PROCRT) e que concluiram o processo (ZA1_DTFIM)
	----- ou que estao com status iniciado mas nao conseguiu concluir 
	--------------------------------

	DECLARE CCLI_INTERFACE CURSOR
	FOR select ZA1_CODMER, ZA1_COD, ZA1_STATUS
	         , ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), ZA1_ERRO)),'') AS ZA1_ERRO
			 , ZA1_DTINI, ZA1_HRINI, R_E_C_N_O_
	      from ZA1010 WITH(NOLOCK)
		 where ZA1_PROCRT = ' '
		   AND (ISNULL(ZA1_DTFIM,  ' ')  <> ' '
		      OR ZA1_STATUS = 'INI' AND ZA1_HRINI <= CONVERT(VARCHAR, dateadd(minute, -20, getdate()), 108) -- hora atual menos 20 minutos
			  );

	OPEN CCLI_INTERFACE
		FETCH NEXT FROM CCLI_INTERFACE
		INTO @V_ZA1_CODMER, @V_ZA1_COD, @V_ZA1_STATUS, @V_ZA1_ERRO, @V_ZA1_DTINI, @V_ZA1_HRINI, @V_R_E_C_N_O_
		WHILE @@FETCH_STATUS = 0
		BEGIN

		IF @V_ZA1_STATUS = 'PRO'   --> PROCESSADO COM SUCESSO
		BEGIN
		  PRINT 'CLIENTE PROCESSADO '
 		    --------------------------------------------------------
			--- SE O PEDIDO PROCESSOU COM SUCESSO GRAVA O CODIGO GERADO NO MERCANET E ATUALIZA TODAS AS TABELAS, INCLUSIVE O PEDIDO
			--------------------------------------------------------
			BEGIN TRY
				UPDATE DB_CLIENTE       
				   SET DB_CLI_CODIGO    = CAST(@V_ZA1_COD AS FLOAT) 
					 , DB_CLI_SITUACAO  = 0       --- COLOCA O CLIENTE COMO LIBERADO PARA DIGITAR PEDIDOS
				 WHERE DB_CLI_CODIGO    = @V_ZA1_CODMER;
				UPDATE DB_CLIENTE_COMPL 
				   SET DB_CLIC_COD       = CAST(@V_ZA1_COD AS FLOAT) 
					 --, DB_CLIC_RESTRICAO = null    -nao deve mais retirar a restricao
				 WHERE DB_CLIC_COD      = @V_ZA1_CODMER;
				UPDATE DB_CLIENTE_PESS  SET DB_CLIP_COD      = CAST(@V_ZA1_COD AS FLOAT) WHERE DB_CLIP_COD      = @V_ZA1_CODMER;
				UPDATE DB_CLIENTE_ENT   SET DB_CLIENT_CODIGO = CAST(@V_ZA1_COD AS FLOAT) WHERE DB_CLIENT_CODIGO = @V_ZA1_CODMER;
				UPDATE DB_PEDIDO        SET DB_PED_CLIENTE   = CAST(@V_ZA1_COD AS FLOAT) WHERE DB_PED_CLIENTE   = @V_ZA1_CODMER;
				UPDATE DB_CLIENTE_REPRES SET DB_CLIR_CLIENTE = CAST(@V_ZA1_COD AS FLOAT) WHERE DB_CLIR_CLIENTE  = @V_ZA1_CODMER;
			END TRY

			BEGIN CATCH
			   SELECT @VERRO = cast(ERROR_NUMBER() as varchar) + ERROR_MESSAGE()

			   INSERT INTO DBS_ERROS_TRIGGERS
  					(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
					VALUES
  					( @VERRO, GETDATE(), @VOBJETO );			
			END CATCH
	    END
		ELSE IF @V_ZA1_STATUS = 'ERR'  --> ERRO NA EXECUCAO DA EXECAUTO
		BEGIN
		    
			PRINT 'CLIENTE REJEITADO '
			-----------------------------------------------------------------------
			--- SE RETORNOU COM ERRO DEVE RETIRAR A DATA DE ENVIO, GRAVAR MENSAGEM DE ERRO NO ABTRIBUTO
			--- E COLOCAR NA ALCADA 10 PARA NOVA LIBERACAO
			-----------------------------------------------------------------------
    		UPDATE DB_CLIENTE
			   SET DB_CLI_DATA_ENVIO = NULL
				 , DB_CLI_SITUACAO = 1 
			WHERE DB_CLI_CODIGO  = @V_ZA1_CODMER; 

			DELETE DB_CLIENTE_ATRIB  
				WHERE DB_CLIA_CODIGO = @V_ZA1_CODMER 
				AND DB_CLIA_ATRIB = 100;

			INSERT INTO DB_CLIENTE_ATRIB  (DB_CLIA_CODIGO, DB_CLIA_ATRIB, DB_CLIA_VALOR)
									VALUES (@V_ZA1_CODMER, 100, substring(@V_ZA1_ERRO, 1, 255))

			
			DELETE DB_CLIENTE_ALCADA where DB_CLIAL_CLIENTE = @V_ZA1_CODMER

			INSERT INTO DB_CLIENTE_ALCADA (DB_CLIAL_CLIENTE, DB_CLIAL_SEQ, DB_CLIAL_ALCADA, DB_CLIAL_STATUS)
								VALUES( @V_ZA1_CODMER, 1, 10, 0)
			

		END
		ELSE IF @V_ZA1_STATUS = 'INI'
		BEGIN
		    PRINT 'CLIENTE INICIOU PROCESSO MAS NAO TERMINOU'

			-----------------------------------------------------------------------
			--- SE RETORNOU COM ERRO DEVE RETIRAR A DATA DE ENVIO, GRAVAR MENSAGEM DE ERRO NO ABTRIBUTO
			--- E COLOCAR NA ALCADA 10 PARA NOVA LIBERACAO
			-----------------------------------------------------------------------
    		UPDATE DB_CLIENTE
				SET DB_CLI_DATA_ENVIO = NULL
				  , DB_CLI_SITUACAO = 1
			WHERE DB_CLI_CODIGO  = @V_ZA1_CODMER; 

			DELETE DB_CLIENTE_ATRIB  
				WHERE DB_CLIA_CODIGO = @V_ZA1_CODMER 
				AND DB_CLIA_ATRIB = 100;

			INSERT INTO DB_CLIENTE_ATRIB  (DB_CLIA_CODIGO, DB_CLIA_ATRIB, DB_CLIA_VALOR)
									VALUES (@V_ZA1_CODMER, 100, substring('Cliente rejeitado pelo processo do Protheus', 1, 255))

			
			DELETE DB_CLIENTE_ALCADA where DB_CLIAL_CLIENTE = @V_ZA1_CODMER

			INSERT INTO DB_CLIENTE_ALCADA (DB_CLIAL_CLIENTE, DB_CLIAL_SEQ, DB_CLIAL_ALCADA, DB_CLIAL_STATUS)
								VALUES( @V_ZA1_CODMER, 1, 10, 0)

		END

		---- GRAVA NA INTERFACE DIZENDO QUE O CLIENTE FOI PROCESSADO
		UPDATE ZA1010 
		   SET ZA1_PROCRT = 'S'
		  WHERE ZA1_COD = @V_ZA1_COD
		

		FETCH NEXT FROM CCLI_INTERFACE
		INTO @V_ZA1_CODMER, @V_ZA1_COD, @V_ZA1_STATUS, @V_ZA1_ERRO, @V_ZA1_DTINI, @V_ZA1_HRINI, @V_R_E_C_N_O_
		END;

	CLOSE CCLI_INTERFACE
	DEALLOCATE CCLI_INTERFACE

END TRY

BEGIN CATCH
   SELECT @VERRO = cast(ERROR_NUMBER() as varchar) + ERROR_MESSAGE()

   INSERT INTO DBS_ERROS_TRIGGERS
  		(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
		VALUES
  		( @VERRO, GETDATE(), @VOBJETO );			
END CATCH

END
GO
