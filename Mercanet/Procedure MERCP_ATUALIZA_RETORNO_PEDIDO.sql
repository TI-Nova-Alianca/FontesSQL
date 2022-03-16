SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_ATUALIZA_RETORNO_PEDIDO] AS

BEGIN

DECLARE	@VERRO               VARCHAR(255);
DECLARE @VOBJETO             VARCHAR(15) SELECT @VOBJETO = 'MERCP_ATUALIZA_RETORNO_PEDIDO';

DECLARE @V_ZC5_FILIAL     VARCHAR(2),
        @V_ZC5_NUM        VARCHAR(6),
		@V_ZC5_PEDMER     VARCHAR(20),
		@V_ZC5_STATUS     VARCHAR(3),
		@V_ZC5_ERRO       VARCHAR(2047),
		@V_ZC5_DTINI	  VARCHAR(8),
		@V_ZC5_HRINI      VARCHAR(8),
		@V_R_E_C_N_O_     INT,
		@V_REPRES         INT,
		@V_CLIENTE        FLOAT,
		@V_PED_NRO        INT,
		@V_MAX_SEQ        NUMERIC SELECT @V_MAX_SEQ = 0



---------------------------------------------------------
--- VERSAO   DATA        AUTOR           ALTERACAO
--- 1.00001  25/04/2016  ALENCAR         DESENVOLVIMENTO - Rotina que busca as informações processadas na tabela de interface e atualiza no Mercanet
---                                                        É atualizada no final da rotina de exportação (MERCP_CONCORRENTE_EXPORT)
--- 1.00002  19/06/2017  ALENCAR         Avaliar o campo ZC5_PROCRT para não reprocessar pedidos velhos
---------------------------------------------------------

BEGIN TRY


    --------------------------------
	----- Atualiza pedidos da interface da ZC5010 - SANCHEZ
	----- Busca todos os registros que nao foram processados pelo retorno do Mercanet (Z1A_PROCRT) e que concluiram o processo (Z1A_DTFIM)
	----- ou que estao com status iniciado mas nao conseguiu concluir 
	--------------------------------

	DECLARE CPED_INTERFACE CURSOR
	FOR select ZC5_FILIAL, ZC5_NUM, ZC5_PEDMER, ZC5_STATUS
	         , ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), ZC5_ERRO)),'') AS ZC5_ERRO
			 , ZC5_DTINI, ZC5_HRINI, R_E_C_N_O_
	      from ZC5010 
		 where ZC5_PEDMER NOT LIKE 'M%'
		   AND ZC5_PROCRT <> 'S'
		   AND (ISNULL(ZC5_DTFIM,  ' ')  <> ' '
		      OR ZC5_STATUS = 'INI' AND ZC5_HRINI <= CONVERT(VARCHAR, dateadd(minute, -10, getdate()), 108) -- hora atual menos 10 minutos
			  );

	OPEN CPED_INTERFACE
		FETCH NEXT FROM CPED_INTERFACE
		INTO @V_ZC5_FILIAL, @V_ZC5_NUM, @V_ZC5_PEDMER, @V_ZC5_STATUS, @V_ZC5_ERRO, @V_ZC5_DTINI, @V_ZC5_HRINI, @V_R_E_C_N_O_
		WHILE @@FETCH_STATUS = 0
		BEGIN

		SET @V_PED_NRO = CAST(SUBSTRING(@V_ZC5_PEDMER, 1, 4) + SUBSTRING(@V_ZC5_PEDMER, 6, 4) AS INT)

		SELECT @V_REPRES = DB_PED_REPRES  
		     , @V_CLIENTE = DB_PED_CLIENTE
		  FROM DB_PEDIDO
		 WHERE DB_PED_NRO = @V_PED_NRO


		IF @V_ZC5_STATUS = 'PRO'   --> PROCESSADO COM SUCESSO
		BEGIN
		  PRINT 'PEDIDO PROCESSADO '
		   --- SE O PEDIDO PROCESSOU COM SUCESSO GRAVA O NRO GERADO NO MERCANET
		   UPDATE DB_PEDIDO
		      SET DB_PED_NRO_ORIG = @V_ZC5_NUM
			    , DB_PED_SITCORP  = '02'
			WHERE DB_PED_NRO = @V_PED_NRO

	    END
		ELSE IF @V_ZC5_STATUS = 'ERR'  --> ERRO NA EXECUCAO DA EXECAUTO
		BEGIN
		   --- SE OCORREU ERRO AO EFETIVAR O PEDIDO NO TOTVS GRAVA MENSAGEM NO MERCANET
		   PRINT 'PEDIDO REJEITADO '

		      UPDATE DB_PEDIDO 
			     SET DB_PED_SITCORP = '999'  -- PEDIDO REJEITADO
			   WHERE DB_PED_NRO = @V_PED_NRO

			  SELECT @V_MAX_SEQ = ISNULL(MAX(DB_MSG_SEQUENCIA),0) + 1
			    FROM DB_MENSAGEM
			   WHERE DB_MSG_REPRES = @V_REPRES;

			  INSERT INTO DB_MENSAGEM(  DB_MSG_REPRES,     -- 01
										DB_MSG_SEQUENCIA,  -- 02
										DB_MSG_DATA,       -- 03
										DB_MSG_USU_ENVIO,  -- 04
										DB_MSG_USU_RECEB,  -- 05
										DB_MSG_MOTIVO,     -- 06
										DB_MSG_PEDIDO,     -- 07
										DB_MSG_CLIENTE,    -- 08
										DB_MSG_TIPO,       -- 09
										DB_MSG_TEXTO,      -- 10
										DB_MSG_VISTO,      -- 11
										DB_MSG_DATAHORA,   -- 12
										DB_MSG_ENVCORP     -- 13
										)
									VALUES
										(
										@V_REPRES,
										@V_MAX_SEQ,
										GETDATE(),
										'MERCANET',
										NULL,
										1,
										@V_PED_NRO,
										@V_CLIENTE,
										1,
										SUBSTRING(@V_ZC5_ERRO, 1, 1024),
										0,
										NULL,
										NULL
									  );


		END
		ELSE IF @V_ZC5_STATUS = 'INI'
		BEGIN
		   PRINT 'PEDIDO INICIOU PROCESSO MAS NAO TERMINOU'

		    UPDATE DB_PEDIDO 
			   SET DB_PED_SITCORP = '999'  -- PEDIDO REJEITADO
			 WHERE DB_PED_NRO = @V_PED_NRO

			SELECT @V_MAX_SEQ = ISNULL(MAX(DB_MSG_SEQUENCIA),0) + 1
			FROM DB_MENSAGEM
			WHERE DB_MSG_REPRES = @V_REPRES;

			INSERT INTO DB_MENSAGEM(DB_MSG_REPRES,     -- 01
									DB_MSG_SEQUENCIA,  -- 02
									DB_MSG_DATA,       -- 03
									DB_MSG_USU_ENVIO,  -- 04
									DB_MSG_USU_RECEB,  -- 05
									DB_MSG_MOTIVO,     -- 06
									DB_MSG_PEDIDO,     -- 07
									DB_MSG_CLIENTE,    -- 08
									DB_MSG_TIPO,       -- 09
									DB_MSG_TEXTO,      -- 10
									DB_MSG_VISTO,      -- 11
									DB_MSG_DATAHORA,   -- 12
									DB_MSG_ENVCORP     -- 13
									)
								VALUES
									(
									@V_REPRES,
									@V_MAX_SEQ,
									GETDATE(),
									'MERCANET',
									NULL,
									1,
									@V_PED_NRO,
									@V_CLIENTE,
									1,
									'ERRO FATAL NA EXECAUTO - PROCESSO NAO CONCLUÍDO COM SUCESSO',
									0,
									NULL,
									NULL
									);
	    END


		---- GRAVA NA INTERFACE DIZENDO QUE O PEDIDO FOI PROCESSADO
		UPDATE ZC5010 
		   SET ZC5_PROCRT = 'S'
		  WHERE R_E_C_N_O_ = @V_R_E_C_N_O_
		

		FETCH NEXT FROM CPED_INTERFACE
		INTO @V_ZC5_FILIAL, @V_ZC5_NUM, @V_ZC5_PEDMER, @V_ZC5_STATUS, @V_ZC5_ERRO, @V_ZC5_DTINI, @V_ZC5_HRINI, @V_R_E_C_N_O_
		END;
	CLOSE CPED_INTERFACE
	DEALLOCATE CPED_INTERFACE



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
