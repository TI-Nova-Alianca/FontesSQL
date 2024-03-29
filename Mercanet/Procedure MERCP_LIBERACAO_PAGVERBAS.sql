ALTER PROCEDURE MERCP_LIBERACAO_PAGVERBAS (@P_NROVERBA    INT,
                                            @P_SEQAPURACAO INT,
                                            @P_USUARIO     VARCHAR(50),
                                            @P_ACAO        INT, ----0- BUSCAR ALÇADA OU 1- LIBERAR OU 2-NÃO AUTORIZAR
											@P_LIBERADO    INT OUT
                                            ) AS
BEGIN                                                      
DECLARE
@VDB_ALCADA_LIBERA           VARCHAR(5),
@V_ALCP_GRPALCADA_ANTERIOR   VARCHAR(25),
@V_ALCP_CODIGO_ANTERIOR      VARCHAR(25),
@V_ALCP_GRPLIB_ANTERIOR      INT,
@V_ALCP_NIVLIB_ANTERIOR      INT,
@VDB_ALCP_CODIGO             VARCHAR(25),
@V_ALCADA_OK                 INT,
@V_CODIGO_USUARIO            INT,
@V_ALCADA_ATUAL              VARCHAR(255),
@V_ALCP_CODIGO_TEMP          VARCHAR(255),
@V_ALCP_CODIGO			     VARCHAR(255),
@VERRO                       VARCHAR(1024),
@V_TIPO_VERBA                INT,
@V_MOTIVO_VERBA              INT,
@V_SITUACAO                  INT,
@V_EXIGELIBPAGAMENTO         INT,
@V_EXISTE_PAGAMENTOS         INT,
@V_DB_ALCP_VLRMAXLIB         FLOAT,
@V_VALOR_VERBA               FLOAT,
@V_LIBERAR                   INT,
@V_SEQ_ALCADA                INT,
@V_SIT_CORPORATIVO			 INT,
@V_VER_FORMATOSALDOVERBA     VARCHAR(5);
SET NOCOUNT ON; 
BEGIN TRANSACTION
BEGIN TRY
    --- BUSCA ALCADA QUE O USUARIO PODE LIBERAR, O NIVEL DE LIBERACAO E O SEU GRUPO DE LIBERACAO
	SET @V_CODIGO_USUARIO = NULL;
	SET @P_LIBERADO = 0;
	SELECT @V_VER_FORMATOSALDOVERBA = DB_PRMS_VALOR
      FROM DB_PARAM_SISTEMA
	 WHERE DB_PARAM_SISTEMA.DB_PRMS_ID = 'VER_FORMATOSALDOVERBA'
    SELECT @V_CODIGO_USUARIO = CODIGO        
      FROM DB_USUARIO
     WHERE USUARIO         = @P_USUARIO;
	SET @V_MOTIVO_VERBA = NULL;
    SET @V_TIPO_VERBA = NULL;     
    SET @V_VALOR_VERBA = NULL;    
    SELECT @V_MOTIVO_VERBA = MOTIVO,
           @V_TIPO_VERBA		= TIPO_VERBA,               
           @V_VALOR_VERBA		= DB_VC_VERBAAPURACAO.VALOR_VERBA,
           @V_SITUACAO			= DB_VC_VERBAAPURACAO.SITUACAO,
		   @V_SIT_CORPORATIVO	= DB_VC_VERBAAPURACAO.SIT_CORPORATIVO
      FROM DB_VC_VERBA, 
           DB_VC_VERBAAPURACAO
     WHERE NUMERO = @P_NROVERBA
       AND DB_VC_VERBAAPURACAO.NUMERO_VERBA = DB_VC_VERBA.NUMERO
       AND DB_VC_VERBAAPURACAO.SEQUENCIA    = @P_SEQAPURACAO;
    -- SE RECEBEU USUARIO DEVE VALIDAR SE O REGISTRO DA DB_PEDIDO_ALCADA ESTA NA SUA ALCADA
        -- ISSO DEVE SER FEITO POIS 2 USUARIOS DA MESMA ALCADA PODEM TENTAR LIBERAR O MESMO PEDIDO NO MESMO INSTANTE
    IF ISNULL(@V_CODIGO_USUARIO, '') <> ''
    BEGIN
	  SET @V_ALCADA_OK = 0;
      SELECT @V_ALCADA_ATUAL = DB_PGAL_ALCADA         
        FROM DB_PAGAMENTO_ALCADA
       WHERE DB_PGAL_CONTRATO = @P_NROVERBA
         and DB_PGAL_SEQAPURACAO = @P_SEQAPURACAO
         AND DB_PGAL_STATUS = 0;
      IF ISNULL(@V_ALCADA_ATUAL, '') <> ''
	  BEGIN      
		  SET @V_ALCADA_OK = 0;
          SELECT @V_ALCADA_OK = 1       
            FROM DB_ALCADA_USUARIO
           WHERE DB_ALCU_ALCADA = @V_ALCADA_ATUAL
             AND DB_ALCU_USUARIO = @V_CODIGO_USUARIO;
      END
    END
    ELSE     
      SET @V_ALCADA_OK = 1;
    IF @V_ALCADA_OK <> 1
	BEGIN
      SET @VERRO = 'PAGAMENTO ' + CAST(@P_NROVERBA AS VARCHAR) + ' - ' + CAST(@P_SEQAPURACAO AS VARCHAR) + ' ESTA TENTANDO SER LIBERADO POR UM USUARIO  QUE NÃO PERTENCE A ALCADA ATUAL. USUÁRIO: ' + @P_USUARIO;
      INSERT INTO DBS_ERROS_TRIGGERS(DBS_ERROS_DATA, DBS_ERROS_ERRO, DBS_ERROS_OBJETO) 
                                     VALUES
                                    (GETDATE(), @VERRO, 'MERCP_LIBERACAO_PAGVERBAS ');      
	  COMMIT
	  RETURN
    END
	SET @V_DB_ALCP_VLRMAXLIB = NULL;
    SET @V_ALCP_GRPALCADA_ANTERIOR = NULL;
    SET @V_ALCP_NIVLIB_ANTERIOR = NULL;
    SET @V_ALCP_GRPLIB_ANTERIOR = NULL;
    SELECT @V_DB_ALCP_VLRMAXLIB		= DB_ALCP_VLRMAXLIB,
           @V_ALCP_GRPALCADA_ANTERIOR = DB_ALCP_GRPALCADA,
           @V_ALCP_NIVLIB_ANTERIOR	= DB_ALCP_NIVELLIB,
           @V_ALCP_GRPLIB_ANTERIOR    = DB_ALCP_GRUPOLIB       
      FROM DB_ALCADA_PED
     WHERE DB_ALCP_CODIGO = @V_ALCADA_ATUAL;     
    IF ISNULL(@P_USUARIO, '') <> ''
	BEGIN
       ---- LIBERAR
       IF @P_ACAO = 1
	   BEGIN
          IF @V_VALOR_VERBA <= @V_DB_ALCP_VLRMAXLIB
            SET @V_LIBERAR = 1;
          ELSE
            SET @V_LIBERAR = 0;
          IF @V_LIBERAR = 1
		  BEGIN
            UPDATE DB_VC_VERBAAPURACAO
               SET SITUACAO = 2
             WHERE NUMERO_VERBA = @P_NROVERBA
               AND SEQUENCIA    = @P_SEQAPURACAO;          
             UPDATE DB_VC_APURADETALHE
                SET SITUACAO = 2 
              WHERE NUMERO_VERBA = @P_NROVERBA
                AND SEQ_PERIODOAPURA = @P_SEQAPURACAO;
             UPDATE DB_VC_APURADETPEDIDO
                SET SITUACAO = 2
              WHERE NUMERO_VERBA = @P_NROVERBA
                AND SEQ_PERIODOAPURA = @P_SEQAPURACAO;
			 IF @V_SIT_CORPORATIVO = 2
			 BEGIN
				UPDATE DB_VC_VERBAAPURACAO
				   SET DATA_ENVIO = NULL,
				       SIT_CORPORATIVO = 0
				 WHERE NUMERO_VERBA = @P_NROVERBA
                   AND SEQUENCIA    = @P_SEQAPURACAO;
             END
			 SET @V_SEQ_ALCADA = 0
             SELECT @V_SEQ_ALCADA = MAX(DB_PGAL_SEQ)                 
               FROM DB_PAGAMENTO_ALCADA
              WHERE DB_PGAL_CONTRATO = @P_NROVERBA
                AND DB_PGAL_SEQAPURACAO = @P_SEQAPURACAO;
            --- ATUALIZA ALÇADA ATUAL 
            UPDATE DB_PAGAMENTO_ALCADA
               SET DB_PGAL_USULIB     = @V_CODIGO_USUARIO,
                   DB_PGAL_DATA_LIB   = GETDATE(),
                   DB_PGAL_STATUS     = 1
             WHERE DB_PGAL_CONTRATO    = @P_NROVERBA
               AND DB_PGAL_SEQAPURACAO = @P_SEQAPURACAO
               AND DB_PGAL_SEQ         = @V_SEQ_ALCADA;
			   IF @V_VER_FORMATOSALDOVERBA = '0'
				SET @P_LIBERADO = 1
          END
          ELSE ---- SE NÃO PODE LIBERAR BUSCA O PROXIMO NIVEL DA ALÇADA     
		  BEGIN
             SET @V_SEQ_ALCADA = 0
             SELECT @V_SEQ_ALCADA = MAX(DB_PGAL_SEQ)                 
               FROM DB_PAGAMENTO_ALCADA
              WHERE DB_PGAL_CONTRATO = @P_NROVERBA
                AND DB_PGAL_SEQAPURACAO = @P_SEQAPURACAO;
            --- ATUALIZA ALÇADA ATUAL COM SITUAÇÃO 2, POIS FOI ENCAMINHADA PARA O PROXIMO NIVEL
            UPDATE DB_PAGAMENTO_ALCADA
               SET DB_PGAL_USULIB     = @V_CODIGO_USUARIO,
                   DB_PGAL_DATA_LIB   = GETDATE(),
                   DB_PGAL_STATUS     = 2
             WHERE DB_PGAL_CONTRATO    = @P_NROVERBA
               AND DB_PGAL_SEQAPURACAO = @P_SEQAPURACAO
               AND DB_PGAL_SEQ         = @V_SEQ_ALCADA;       
             ---- BUSCA NOVA ALÇADA            
			 SET @V_ALCP_CODIGO = NULL
			 BEGIN
				DECLARE C	CURSOR
				FOR SELECT DB_ALCP_CODIGO
						FROM DB_ALCADA_PED
						WHERE DB_ALCP_CODIGO IN (
							SELECT DB_ALCP_CODIGO
								FROM DB_ALCADA_PED
								WHERE DBO.MERCF_VALIDA_LISTA(@V_TIPO_VERBA,   DB_ALCP_LSTTIPOVERBA,    0, ',') > 0
									AND DBO.MERCF_VALIDA_LISTA(@V_MOTIVO_VERBA,   DB_ALCP_LSTMOTVERBA,    0, ',') > 0
									AND ( DB_ALCP_GRPALCADA = @V_ALCP_GRPALCADA_ANTERIOR OR ISNULL(@V_ALCP_GRPALCADA_ANTERIOR, '') = '') ---- se ja foi liberado por alguem deve seguir na mesma alcada
									AND (((DB_ALCP_GRUPOLIB = @V_ALCP_GRPLIB_ANTERIOR AND DB_ALCP_NIVELLIB > @V_ALCP_NIVLIB_ANTERIOR)
										OR (DB_ALCP_GRUPOLIB > @V_ALCP_GRPLIB_ANTERIOR)) 
										OR isnull(@V_ALCP_CODIGO_ANTERIOR, '') = '')
									AND DB_ALCP_CODIGO NOT IN( SELECT DB_ALCP_CODIGO   --- NAO DEVE SER IGUALAO ULTIMO NIVEL LIBERADEO
                                                      FROM DB_ALCADA_PED A, DB_PAGAMENTO_ALCADA B
                                                     WHERE DB_ALCP_CODIGO = DB_PGAL_ALCADA
                                                       AND DB_PGAL_CONTRATO = @P_NROVERBA
                                                       AND DB_PGAL_SEQAPURACAO = @P_SEQAPURACAO)
									and DB_ALCP_TIPO = 7)
								ORDER BY DB_ALCP_GRPALCADA, DB_ALCP_GRUPOLIB, DB_ALCP_NIVELLIB
			 OPEN C
			 FETCH NEXT FROM C
			 INTO @V_ALCP_CODIGO_TEMP
			 BEGIN
				IF ISNULL(@V_ALCP_CODIGO, '') = ''
					SET @VDB_ALCP_CODIGO = @V_ALCP_CODIGO_TEMP;
			 END
			 FETCH NEXT FROM C
			 INTO @V_ALCP_CODIGO_TEMP
			 END
			 CLOSE C
			 DEALLOCATE C
             IF ISNULL(@VDB_ALCP_CODIGO, '') <> ''
             BEGIN
                INSERT INTO DB_PAGAMENTO_ALCADA(
                                                DB_PGAL_CONTRATO,
                                                DB_PGAL_SEQAPURACAO,
                                                DB_PGAL_SEQ,
                                                DB_PGAL_ALCADA,                                      
                                                DB_PGAL_STATUS)
                                        VALUES (
                                                @P_NROVERBA,
                                                @P_SEQAPURACAO,
                                                ISNULL((SELECT MAX(DB_PGAL_SEQ) FROM DB_PAGAMENTO_ALCADA WHERE DB_PGAL_CONTRATO = @P_NROVERBA AND DB_PGAL_SEQAPURACAO = @P_SEQAPURACAO), 0) + 1,
                                                @VDB_ALCP_CODIGO,
                                                0
                                               );             
             END
             ELSE
			 BEGIN
                INSERT INTO DBS_ERROS_TRIGGERS
                       (DBS_ERROS_OBJETO, DBS_ERROS_ERRO, DBS_ERROS_DATA)
                VALUES
                       ('MERCP_LIBERACAO_PAGVERBAS', 'NÃO FOI ENCONTRADA UMA ALÇADA PARA O PAGAMENTO. NRO = ' + CAST(@P_NROVERBA AS VARCHAR) + ' - ' + CAST(@P_SEQAPURACAO AS VARCHAR) , GETDATE());
             END
          END
       END
       ELSE IF @P_ACAO = 2  --- NÃO AUTORIZADO
	   BEGIN
            UPDATE DB_VC_VERBAAPURACAO
               SET SITUACAO = 3
             WHERE NUMERO_VERBA = @P_NROVERBA
               AND SEQUENCIA    = @P_SEQAPURACAO;          
             UPDATE DB_VC_APURADETALHE
                SET SITUACAO = 3 
              WHERE NUMERO_VERBA = @P_NROVERBA
                AND SEQ_PERIODOAPURA = @P_SEQAPURACAO;
             UPDATE DB_VC_APURADETPEDIDO
                SET SITUACAO = 3
              WHERE NUMERO_VERBA = @P_NROVERBA
                AND SEQ_PERIODOAPURA = @P_SEQAPURACAO;              
             SET @V_SEQ_ALCADA = 0
             SELECT @V_SEQ_ALCADA = MAX(DB_PGAL_SEQ)                 
               FROM DB_PAGAMENTO_ALCADA
              WHERE DB_PGAL_CONTRATO = @P_NROVERBA
                AND DB_PGAL_SEQAPURACAO = @P_SEQAPURACAO;
            --- ATUALIZA ALÇADA ATUAL 
            UPDATE DB_PAGAMENTO_ALCADA
               SET DB_PGAL_USULIB     = @V_CODIGO_USUARIO,
                   DB_PGAL_DATA_LIB   = GETDATE(),
                   DB_PGAL_STATUS     = 1
             WHERE DB_PGAL_CONTRATO    = @P_NROVERBA
               AND DB_PGAL_SEQAPURACAO = @P_SEQAPURACAO
               AND DB_PGAL_SEQ         = @V_SEQ_ALCADA;   
       END
    END
    ELSE
    BEGIN
       --- ENCONTRA ALÇADA PARA O PAGAMENTO
       DELETE FROM DB_PAGAMENTO_ALCADA WHERE  DB_PGAL_CONTRATO = @P_NROVERBA AND DB_PGAL_SEQAPURACAO = @P_SEQAPURACAO;    
	   SET @V_ALCP_CODIGO = NULL
			 BEGIN
				DECLARE C	CURSOR
				FOR SELECT DB_ALCP_CODIGO
						FROM DB_ALCADA_PED
						WHERE DB_ALCP_CODIGO IN (
							SELECT DB_ALCP_CODIGO
								FROM DB_ALCADA_PED
								WHERE DBO.MERCF_VALIDA_LISTA(@V_TIPO_VERBA,   DB_ALCP_LSTTIPOVERBA,    0, ',') > 0
									AND DBO.MERCF_VALIDA_LISTA(@V_MOTIVO_VERBA,   DB_ALCP_LSTMOTVERBA,    0, ',') > 0
									AND ( DB_ALCP_GRPALCADA = @V_ALCP_GRPALCADA_ANTERIOR OR ISNULL(@V_ALCP_GRPALCADA_ANTERIOR, '') = '') ---- se ja foi liberado por alguem deve seguir na mesma alcada
									AND (((DB_ALCP_GRUPOLIB = @V_ALCP_GRPLIB_ANTERIOR AND DB_ALCP_NIVELLIB > @V_ALCP_NIVLIB_ANTERIOR)
										OR (DB_ALCP_GRUPOLIB > @V_ALCP_GRPLIB_ANTERIOR)) 
										OR isnull(@V_ALCP_CODIGO_ANTERIOR, '') = '')
									AND DB_ALCP_CODIGO NOT IN( SELECT DB_ALCP_CODIGO   --- NAO DEVE SER IGUALAO ULTIMO NIVEL LIBERADEO
																FROM DB_ALCADA_PED A, DB_PAGAMENTO_ALCADA B
																WHERE DB_ALCP_CODIGO = DB_PGAL_ALCADA
																AND DB_PGAL_CONTRATO = @P_NROVERBA
																AND DB_PGAL_SEQAPURACAO = @P_SEQAPURACAO)
									and DB_ALCP_TIPO = 7)
								ORDER BY DB_ALCP_GRPALCADA, DB_ALCP_GRUPOLIB, DB_ALCP_NIVELLIB
			 OPEN C
			 FETCH NEXT FROM C
			 INTO @V_ALCP_CODIGO_TEMP
			 BEGIN
				IF ISNULL(@V_ALCP_CODIGO, '') = ''
					SET @VDB_ALCP_CODIGO = @V_ALCP_CODIGO_TEMP;
			 END
			 FETCH NEXT FROM C
			 INTO @V_ALCP_CODIGO_TEMP
			 END
			 CLOSE C
			 DEALLOCATE C
       IF ISNULL(@VDB_ALCP_CODIGO, '') <> ''
       BEGIN
          INSERT INTO DB_PAGAMENTO_ALCADA(
											DB_PGAL_CONTRATO,
											DB_PGAL_SEQAPURACAO,
											DB_PGAL_SEQ,
											DB_PGAL_ALCADA,                                      
											DB_PGAL_STATUS)
									VALUES (
											@P_NROVERBA,
											@P_SEQAPURACAO,
											ISNULL((SELECT MAX(DB_PGAL_SEQ) FROM DB_PAGAMENTO_ALCADA WHERE DB_PGAL_CONTRATO = @P_NROVERBA AND DB_PGAL_SEQAPURACAO = @P_SEQAPURACAO), 0) + 1,
											@VDB_ALCP_CODIGO,
											0
											);  
       END
       ELSE
       BEGIN
          INSERT INTO DBS_ERROS_TRIGGERS
                 (DBS_ERROS_OBJETO, DBS_ERROS_ERRO, DBS_ERROS_DATA)
          VALUES
                 ('MERCP_LIBERACAO_PAGVERBAS', 'NÃO FOI ENCONTRADA UMA ALÇADA PARA O PAGAMENTO. NRO = ' + CAST(@P_NROVERBA AS VARCHAR) + ' - ' + CAST(@P_SEQAPURACAO AS VARCHAR), GETDATE());
       END
    END
    COMMIT;
END TRY
BEGIN CATCH
	    ROLLBACK		
		SET @VERRO = 'ERRO AO LIBERAR PAGAMENTO :' + CAST(@P_NROVERBA AS VARCHAR) + ' - ' + CAST(@P_SEQAPURACAO AS VARCHAR) + ' ' + ERROR_MESSAGE();
		INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, GETDATE(), 'MERCP_LIBERACAO_PAGVERBAS');
END CATCH
END
