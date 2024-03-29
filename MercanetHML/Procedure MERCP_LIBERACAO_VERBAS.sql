ALTER PROCEDURE MERCP_LIBERACAO_VERBAS(@P_NROVERBA    INT,
                                        @P_USUARIO     VARCHAR(100),
                                        @P_ACAO        INT ----0- BUSCAR ALÇADA OU 1- LIBERAR OU 2-NÃO AUTORIZAR
                                        ) AS
BEGIN
DECLARE
@VDB_ALCADA_LIBERA           VARCHAR(5),
@V_ALCP_GRPALCADA_ANTERIOR   VARCHAR(25),
@V_ALCP_CODIGO_ANTERIOR      VARCHAR(25),
@V_ALCP_GRPLIB_ANTERIOR      INT,
@V_ALCP_NIVLIB_ANTERIOR	     INT,
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
@V_CAL_VALOR_VERBA           INT;
SET NOCOUNT ON; 
BEGIN TRANSACTION
BEGIN TRY
	--- BUSCA ALCADA QUE O USUARIO PODE LIBERAR, O NIVEL DE LIBERACAO E O SEU GRUPO DE LIBERACAO
	SET @V_CODIGO_USUARIO = 0
    SELECT @V_CODIGO_USUARIO = CODIGO
      FROM DB_USUARIO
     WHERE USUARIO = @P_USUARIO;    
	SET @V_MOTIVO_VERBA = 0;
    SET @V_TIPO_VERBA = 0;     
    SET @V_VALOR_VERBA = 0;    
    SELECT @V_MOTIVO_VERBA	= MOTIVO,
           @V_TIPO_VERBA	= TIPO_VERBA,               
           @V_VALOR_VERBA	= VALOR,
           @V_SITUACAO		= SITUACAO        
      FROM DB_VC_VERBA
     WHERE NUMERO = @P_NROVERBA;
	 SET @V_CAL_VALOR_VERBA = 0;
	 SELECT TOP 1 @V_CAL_VALOR_VERBA = 1
	   FROM DB_VC_VERBA,
	        DB_VC_REGRACALCULO
	  WHERE DB_VC_VERBA.REGRA_CALCULO = DB_VC_REGRACALCULO.CODIGO 
	    AND DB_VC_REGRACALCULO.TIPO = 2
		AND NUMERO = @P_NROVERBA;
	 IF @V_CAL_VALOR_VERBA = 0
	 BEGIN
		SELECT @V_VALOR_VERBA = SUM(DB_VC_VERBAAPURACAO.VALOR_VERBA)
		  FROM DB_VC_VERBAAPURACAO
		 WHERE NUMERO_VERBA = @P_NROVERBA
	 END
	 IF @V_SITUACAO = 0
	 BEGIN
		ROLLBACK
		RETURN
	 END
    -- SE RECEBEU USUARIO DEVE VALIDAR SE O REGISTRO DA DB_PEDIDO_ALCADA ESTA NA SUA ALCADA
        -- ISSO DEVE SER FEITO POIS 2 USUARIOS DA MESMA ALCADA PODEM TENTAR LIBERAR O MESMO PEDIDO NO MESMO INSTANTE
    IF ISNULL(@V_CODIGO_USUARIO, '') <> ''
	BEGIN
	  SET @V_ALCADA_OK = NULL
      SELECT @V_ALCADA_ATUAL = DB_VCAL_ALCADA         
        FROM DB_VERBA_ALCADA
       WHERE DB_VCAL_NUMERO_VERBA = @P_NROVERBA
         AND DB_VCAL_STATUS = 0;
      IF ISNULL(@V_ALCADA_ATUAL, '') <> ''
	  BEGIN
		SET @V_ALCADA_OK = NULL
        SELECT @V_ALCADA_OK = 1
          FROM DB_ALCADA_USUARIO
         WHERE DB_ALCU_ALCADA = @V_ALCADA_ATUAL
           AND DB_ALCU_USUARIO = @V_CODIGO_USUARIO;      
       END
    END
    ELSE     
	BEGIN
      SET @V_ALCADA_OK = 1;
    END
    IF @V_ALCADA_OK <> 1
	BEGIN
      SET @VERRO  = 'VERBA ' + CAST(@P_NROVERBA AS VARCHAR) + ' ESTA TENTANDO SER LIBERADO POR UM USUARIO  QUE NÃO PERTENCE A ALCADA ATUAL. USUÁRIO: ' + @P_USUARIO;
      INSERT INTO DBS_ERROS_TRIGGERS(DBS_ERROS_DATA, DBS_ERROS_ERRO, DBS_ERROS_OBJETO) 
                                     VALUES
                                    (GETDATE(), @VERRO, 'MERCP_LIBERACAO_VERBAS ');     
	  COMMIT
	  RETURN
    END
	  SELECT @V_DB_ALCP_VLRMAXLIB    = DB_ALCP_VLRMAXLIB,
		     @V_ALCP_GRPLIB_ANTERIOR = DB_ALCP_GRUPOLIB,
			 @V_ALCP_NIVLIB_ANTERIOR = DB_ALCP_NIVELLIB,
			 @V_ALCP_CODIGO_ANTERIOR = DB_ALCP_CODIGO,
			 @V_ALCP_GRPALCADA_ANTERIOR = DB_ALCP_GRPALCADA
       FROM DB_ALCADA_PED
      WHERE DB_ALCP_CODIGO = @V_ALCADA_ATUAL   
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
            UPDATE DB_VC_VERBA
               SET SITUACAO = 0
             WHERE NUMERO = @P_NROVERBA;                
			 SET @V_SEQ_ALCADA = 0
             SELECT @V_SEQ_ALCADA = MAX(DB_VCAL_SEQUENCIA)                   
               FROM DB_VERBA_ALCADA
              WHERE DB_VCAL_NUMERO_VERBA = @P_NROVERBA;             
            --- ATUALIZA ALÇADA ATUAL 
            UPDATE DB_VERBA_ALCADA
               SET DB_VCAL_USULIB     = @V_CODIGO_USUARIO,
                   DB_VCAL_DATA_LIB   = GETDATE(),
                   DB_VCAL_STATUS     = 1
             WHERE DB_VCAL_NUMERO_VERBA = @P_NROVERBA
               AND DB_VCAL_SEQUENCIA    = @V_SEQ_ALCADA;               
            SET @V_EXIGELIBPAGAMENTO = 0   
            SELECT @V_EXIGELIBPAGAMENTO = EXIGELIBPAGAMENTO            
              FROM DB_VC_TIPOVERBA
             WHERE DB_VC_TIPOVERBA.CODIGO = @V_TIPO_VERBA;               
               --se exige deve seta a situacao 1 para valores que a situacao é 4(aguardando liberação de verba)               
               IF @V_EXIGELIBPAGAMENTO = 1
			   BEGIN
                  UPDATE DB_VC_VERBAAPURACAO
                     SET SITUACAO = 1
                   WHERE NUMERO_VERBA = @P_NROVERBA
                     AND SITUACAO = 4;
				  UPDATE DB_VC_APURADETPEDIDO
					 SET SITUACAO = 1
			       WHERE SITUACAO = 4
					 AND NUMERO_VERBA = @P_NROVERBA;
               END
               ELSE
               BEGIN
                 UPDATE DB_VC_VERBAAPURACAO
                     SET SITUACAO = 2
                   WHERE NUMERO_VERBA = @P_NROVERBA
                     AND SITUACAO = 4;
				 UPDATE DB_VC_APURADETPEDIDO
					SET SITUACAO = 2
			      WHERE SITUACAO = 4
					AND NUMERO_VERBA = @P_NROVERBA;
               END
          END
          ELSE ---- SE NÃO PODE LIBERAR BUSCA O PROXIMO NIVEL DA ALÇADA     
          BEGIN   
			 SET @V_SEQ_ALCADA = 0   
             SELECT @V_SEQ_ALCADA = MAX(DB_VCAL_SEQUENCIA)                 
              FROM DB_VERBA_ALCADA
             WHERE DB_VCAL_NUMERO_VERBA = @P_NROVERBA;             
            --- ATUALIZA ALÇADA ATUAL COM SITUAÇÃO 2, POIS FOI ENCAMINHADA PARA O PROXIMO NIVEL
            UPDATE DB_VERBA_ALCADA
               SET DB_VCAL_USULIB     = @V_CODIGO_USUARIO,
                   DB_VCAL_DATA_LIB   = GETDATE(),
                   DB_VCAL_STATUS     = 2
             WHERE DB_VCAL_NUMERO_VERBA = @P_NROVERBA
               AND DB_VCAL_SEQUENCIA    = @V_SEQ_ALCADA;          
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
														FROM DB_ALCADA_PED A, DB_VERBA_ALCADA B
														WHERE DB_ALCP_CODIGO = DB_VCAL_ALCADA
														AND DB_VCAL_NUMERO_VERBA = @P_NROVERBA)
									and DB_ALCP_TIPO = 6)
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
                INSERT INTO DB_VERBA_ALCADA(
                                            DB_VCAL_NUMERO_VERBA,
                                            DB_VCAL_SEQUENCIA,
                                            DB_VCAL_ALCADA,                                      
                                            DB_VCAL_STATUS)
                                    VALUES (
                                            @P_NROVERBA,
                                            ISNULL((SELECT MAX(DB_VCAL_SEQUENCIA) FROM DB_VERBA_ALCADA WHERE DB_VCAL_NUMERO_VERBA = @P_NROVERBA), 0) + 1,
                                            @VDB_ALCP_CODIGO,
                                            0
                                           );
			 END             
             ELSE
			 BEGIN
                INSERT INTO DBS_ERROS_TRIGGERS
                       (DBS_ERROS_OBJETO, DBS_ERROS_ERRO, DBS_ERROS_DATA)
                VALUES
                       ('MERCP_LIBERACAO_VERBAS', 'NÃO FOI ENCONTRADA UMA ALÇADA PARA A VERBA. NRO = ' + CAST(@P_NROVERBA AS VARCHAR) , GETDATE());
             END
		  END           
       END          
       ELSE IF @P_ACAO = 2 --- NÃO AUTORIZADO
       BEGIN
            UPDATE DB_VC_VERBA
               SET SITUACAO = 2 
             WHERE NUMERO = @P_NROVERBA;
			 DELETE DB_PAGAMENTO_ALCADA 
			   WHERE EXISTS (SELECT 1
			                  FROM DB_VC_VERBAAPURACAO
							 WHERE SITUACAO = 4
							   AND NUMERO_VERBA = @P_NROVERBA
							   AND NUMERO_VERBA = DB_PGAL_CONTRATO
							   AND SEQUENCIA = DB_PGAL_SEQAPURACAO)
            UPDATE DB_VC_VERBAAPURACAO
               SET SITUACAO = 3
             WHERE SITUACAO = 4
               AND NUMERO_VERBA = @P_NROVERBA;
			UPDATE DB_VC_APURADETPEDIDO
			   SET SITUACAO = 3
             WHERE SITUACAO = 4
               AND NUMERO_VERBA = @P_NROVERBA;
            SELECT @V_SEQ_ALCADA = MAX(DB_VCAL_SEQUENCIA)                 
              FROM DB_VERBA_ALCADA
             WHERE DB_VCAL_NUMERO_VERBA = @P_NROVERBA;            
            UPDATE DB_VERBA_ALCADA
               SET DB_VCAL_USULIB     = @V_CODIGO_USUARIO,
                   DB_VCAL_DATA_LIB   = GETDATE(),
                   DB_VCAL_STATUS     = 1
             WHERE DB_VCAL_NUMERO_VERBA = @P_NROVERBA
               AND DB_VCAL_SEQUENCIA    = @V_SEQ_ALCADA;      
       END
    END
    ELSE
	BEGIN
       --- ENCONTRA ALÇADA PARA A VERBA
       DELETE FROM DB_VERBA_ALCADA WHERE DB_VCAL_NUMERO_VERBA = @P_NROVERBA;
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
												FROM DB_ALCADA_PED A, DB_VERBA_ALCADA B
												WHERE DB_ALCP_CODIGO = DB_VCAL_ALCADA
												AND DB_VCAL_NUMERO_VERBA = @P_NROVERBA)
							and DB_ALCP_TIPO = 6)
						ORDER BY DB_ALCP_GRPALCADA, DB_ALCP_GRUPOLIB, DB_ALCP_NIVELLIB
	   OPEN C
	   FETCH NEXT FROM C
	   INTO @V_ALCP_CODIGO_TEMP
	   BEGIN
		IF ISNULL(@V_ALCP_CODIGO, '') = ''
		BEGIN
			SET @VDB_ALCP_CODIGO = @V_ALCP_CODIGO_TEMP;
	    END
	   END
	   FETCH NEXT FROM C
	   INTO @V_ALCP_CODIGO_TEMP
	   END
	   CLOSE C
	   DEALLOCATE C	  
       IF ISNULL(@VDB_ALCP_CODIGO, '') <> ''
	   BEGIN
          INSERT INTO DB_VERBA_ALCADA(
                                      DB_VCAL_NUMERO_VERBA,
                                      DB_VCAL_SEQUENCIA,
                                      DB_VCAL_ALCADA,                                      
                                      DB_VCAL_STATUS)
                              VALUES (
                                      @P_NROVERBA,
                                      ISNULL((SELECT MAX(DB_VCAL_SEQUENCIA) FROM DB_VERBA_ALCADA WHERE DB_VCAL_NUMERO_VERBA = @P_NROVERBA), 0) + 1,
                                      @VDB_ALCP_CODIGO,
                                      0
                                     );
       END
       ELSE
	   BEGIN
          INSERT INTO DBS_ERROS_TRIGGERS
                 (DBS_ERROS_OBJETO, DBS_ERROS_ERRO, DBS_ERROS_DATA)
          VALUES
                 ('MERCP_LIBERACAO_VERBAS', 'NÃO FOI ENCONTRADA UMA ALÇADA PARA A VERBA. NRO = ' + CAST(@P_NROVERBA AS VARCHAR) , GETDATE());
       END
    END
    COMMIT;
END TRY
BEGIN CATCH
	    ROLLBACK		
		SET @VERRO = 'ERRO AO LIBERAR O VERBA :' + CAST(@P_NROVERBA AS VARCHAR) + ' ' + ERROR_MESSAGE();
		INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, GETDATE(), 'MERCP_LIBERACAO_VERBAS');
END CATCH
END -- FIM PROGRAMA
