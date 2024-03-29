ALTER PROCEDURE MERCP_LIBERACAO_DEVOLUCAO  ( @P_NRODEVOLUCAO      INT,
											  @P_USUARIO           VARCHAR(50),										  
											  @P_ACAO              SMALLINT   -- AÇÃO=1 (LIBERAR) OU 2 (NÃO AUTORIZAR).
										    ) AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	08/01/2015	TIAGO PRADELLA	CRIACAO ROTINA DE LIBERACAO DE DEVOLUCAO
-- 1.0001   22/09/2016  tiago           valida parametro DEV_FORMATOLIBERACAO, para realizar a liberacao passando por todas as alcadas ate encontrar uma que consiga liberar
--										ou ir diretamente para a alcada que pode liberar a devolucao
---------------------------------------------------------------------------------------------------
DECLARE 
@VERRO                       VARCHAR(255), 
@VDB_ALCP_CODIGO             VARCHAR(25),   
@V_ALCP_CODIGO_TEMP          VARCHAR(25),
@V_EMPRESA			         VARCHAR(3), 
@V_ALCADA_OK                 INT,
@V_ALCADA_ATUAL              VARCHAR(5),
@V_CODIGO_USUARIO            VARCHAR(40),
@V_REPRES                    VARCHAR(9),
@V_CLI_CLASCOM               VARCHAR(15),
@V_CLI_REGIAOCOM             VARCHAR(8),
@V_CLI_RAMATIV               VARCHAR(5),
@V_VALOR_DEVOLUCAO           FLOAT,
@VDB_ALCADA_LIBERA           varchar(50),
@VDB_ALCP_GRPALCADA          varchar(50),
@V_FORMATO_LIBERACAO         int = 0,
@V_VALOR_DEVOLUCAO_ALCADA    FLOAT,
@V_ALCP_CODIGO_ANTERIOR     VARCHAR(5),
@V_ALCP_GRPALCADA_ANTERIOR  VARCHAR(12)
BEGIN
BEGIN TRY
		select @V_FORMATO_LIBERACAO = db_prms_valor
	   	  from DB_PARAM_SISTEMA where db_prms_id = 'DEV_FORMATOLIBERACAO'  
    -- BUSCA ALCADA QUE O USUARIO PODE LIBERAR, O NIVEL DE LIBERACAO E O SEU GRUPO DE LIBERACAO
		SELECT @VDB_ALCADA_LIBERA    = DB_ALCP_CODIGO,
			   @VDB_ALCP_GRPALCADA   = DB_ALCP_GRPALCADA,			  
			   @V_CODIGO_USUARIO     = CODIGO
		  FROM DB_ALCADA_USUARIO, 
			   DB_ALCADA_PED, 
			   DB_USUARIO
		 WHERE DB_ALCU_USUARIO = CODIGO
		   AND DB_ALCU_ALCADA = DB_ALCP_CODIGO
		   AND USUARIO = @P_USUARIO 	
		   AND DB_ALCP_TIPO = 3
		SET @V_ALCADA_OK = 0;				
		-- SE RECEBEU USUARIO DEVE VALIDAR SE O REGISTRO DA DB_PEDIDO_ALCADA ESTA NA SUA ALCADA
        -- ISSO DEVE SER FEITO POIS 2 USUARIOS DA MESMA ALCADA PODEM TENTAR LIBERAR O MESMO PEDIDO NO MESMO INSTANTE
		IF ISNULL(@P_USUARIO, '') <> ''
		BEGIN
			SELECT @V_ALCADA_ATUAL = DB_DEVAL_ALCADA
			  FROM DB_DEVOLUCAO_ALCADA
			 WHERE DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO
			   AND DB_DEVAL_STATUS = 0
			IF ISNULL(@V_ALCADA_ATUAL, '') <> ''
			BEGIN
				SET @V_ALCADA_OK = 0
				SELECT @V_ALCADA_OK = 1          
				  FROM DB_ALCADA_USUARIO
				 WHERE DB_ALCU_ALCADA = @V_ALCADA_ATUAL
				   AND DB_ALCU_USUARIO = @V_CODIGO_USUARIO;
			END
	    END
		ELSE
		BEGIN
			SET @V_ALCADA_OK = 1
		END		
		IF @V_FORMATO_LIBERACAO = 0    --- Devolução é avaliada apenas pela alçada com permissão para liberação conforme valor
		BEGIN
			IF @V_ALCADA_OK <> 1 
			BEGIN
				SET @VERRO  = 'DEVOLUCAO ' + CAST(CAST(@P_NRODEVOLUCAO AS BIGINT) AS VARCHAR) + ', ESTA TENTANDO SER LIBERADA POR UM USUARIO  QUE NÃO PERTENCE A ALCADA ATUAL. USUÁRIO: ' + @P_USUARIO
				INSERT INTO DBS_ERROS_TRIGGERS(DBS_ERROS_DATA, DBS_ERROS_ERRO, DBS_ERROS_OBJETO) 
										VALUES
											  (GETDATE(), @VERRO, 'MERCP_LIBERACAO_DEVOLUCAO')
			END
			IF @V_ALCADA_OK = 1
			BEGIN
				IF ISNULL(@P_USUARIO, '') <> '' AND @P_ACAO = 1 -- LIBERAR
				BEGIN
					 UPDATE DB_DEVOLUCAO_ALCADA
						SET DB_DEVAL_STATUS     = 1,
							DB_DEVAL_USULIB     = @V_CODIGO_USUARIO,
							DB_DEVAL_DATA_LIB   = GETDATE()
					  WHERE DB_DEVAL_DEVOLUCAO  = @P_NRODEVOLUCAO
						AND DB_DEVAL_SEQ = (SELECT ISNULL(MAX(DB_DEVAL_SEQ), 1) FROM DB_DEVOLUCAO_ALCADA WHERE DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO)
					 UPDATE MDV01 
						SET DV01_SITUACAO = 1
					  WHERE DV01_NRO = @P_NRODEVOLUCAO
				END
				ELSE IF ISNULL(@P_USUARIO, '') <> '' AND @P_ACAO = 2  -- NAO AUTORIZAR
				BEGIN
					 UPDATE DB_DEVOLUCAO_ALCADA 
						SET DB_DEVAL_STATUS    = 2,
							DB_DEVAL_USULIB    = @V_CODIGO_USUARIO,
							DB_DEVAL_DATA_LIB  = GETDATE()
					  WHERE DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO
						AND DB_DEVAL_SEQ = (SELECT ISNULL(MAX(DB_DEVAL_SEQ), 1) FROM DB_DEVOLUCAO_ALCADA WHERE DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO)
					 UPDATE MDV01 
						SET DV01_SITUACAO = 2
					  WHERE DV01_NRO = @P_NRODEVOLUCAO
				END
				ELSE
				BEGIN
					SELECT @V_REPRES        = DV01_REPRES,
						   @V_EMPRESA       = DV01_EMPRESA,
						   @V_CLI_CLASCOM   = DB_CLI_CLASCOM,
						   @V_CLI_REGIAOCOM = DB_CLI_REGIAOCOM,
						   @V_CLI_RAMATIV   = DB_CLI_RAMATIV
					  FROM MDV01, DB_CLIENTE
					 WHERE DV01_NRO = @P_NRODEVOLUCAO
					   AND DB_CLI_CODIGO = DV01_CLIENTE;
					SELECT @V_VALOR_DEVOLUCAO = SUM(DV02_QTDE * DV02_PRECO)
					  FROM MDV02
					 WHERE DV02_NRO = @P_NRODEVOLUCAO;
					BEGIN
						DECLARE C	CURSOR
						FOR SELECT DB_ALCP_CODIGO
							  FROM DB_ALCADA_PED
					  		 WHERE DB_ALCP_CODIGO IN (
														SELECT DB_ALCP_CODIGO
														  FROM DB_ALCADA_PED
														 WHERE DBO.MERCF_VALIDA_LISTA(@V_EMPRESA,	         DB_ALCP_LSTEMP,    0, ',') > 0
														   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_RAMATIV,	     DB_ALCP_LSTRAMO,   0, ',') > 0
														   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_CLASCOM,	     DB_ALCP_LSTCLASS,  0, ',') > 0
														   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_REGIAOCOM,	     DB_ALCP_LSTREGCOM, 0, ',') > 0
														   AND DBO.MERCF_VALIDA_LISTA(@V_REPRES,	         DB_ALCP_LSTREP,    0, ',') > 0
														   AND ((@V_REPRES IN (SELECT Z.DB_EREG_REPRES
																				 FROM DB_ESTRUT_VENDA X, 
																					  DB_ESTRUT_VENDA Y, 
																					  DB_ESTRUT_REGRA Z, 
																					  DB_ESTRUT_REGRA Z1, 
																					  DB_ALCADA_ESTRUT AL
																				WHERE X.DB_EVDA_ESTRUTURA  = Y.DB_EVDA_ESTRUTURA																				
																				  AND Y.DB_EVDA_CODIGO     LIKE (X.DB_EVDA_CODIGO + '%')
																				  AND X.DB_EVDA_ESTRUTURA  = Z.DB_EREG_ESTRUTURA
																				  AND Y.DB_EVDA_ID         = Z.DB_EREG_ID
																				  AND X.DB_EVDA_ESTRUTURA  = Z1.DB_EREG_ESTRUTURA
																				  AND X.DB_EVDA_ID         = Z1.DB_EREG_ID
																				  AND Z.DB_EREG_SEQ        = 1
																				  AND AL.DB_ALCE_ESTRUTURA = Z1.DB_EREG_ESTRUTURA
																				  AND DB_ALCP_CODIGO       = AL.DB_ALCE_ALCADA
																				  AND AL.DB_ALCE_ID        =  Z1.DB_EREG_ID ))  OR ((SELECT TOP(1) DB_ALCE_ALCADA
																																	   FROM DB_ALCADA_ESTRUT
																																	  WHERE DB_ALCP_CODIGO = DB_ALCE_ALCADA) IS NULL))																	
															AND @V_VALOR_DEVOLUCAO < DB_ALCP_VLRMAXLIB
															AND DB_ALCP_TIPO = 3
																)
														  ORDER BY DB_ALCP_GRPALCADA, DB_ALCP_GRUPOLIB, DB_ALCP_NIVELLIB
							OPEN C
							FETCH NEXT FROM C
							INTO @V_ALCP_CODIGO_TEMP
							BEGIN
								IF @VDB_ALCP_CODIGO IS NULL
									SET @VDB_ALCP_CODIGO = @V_ALCP_CODIGO_TEMP;
								END
							FETCH NEXT FROM C
							INTO @V_ALCP_CODIGO_TEMP
						END
							CLOSE C
							DEALLOCATE C
						IF ISNULL(@VDB_ALCP_CODIGO, '') <> ''
						BEGIn
							delete DB_DEVOLUCAO_ALCADA where DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO
							INSERT INTO DB_DEVOLUCAO_ALCADA
									(DB_DEVAL_DEVOLUCAO,
									 DB_DEVAL_SEQ,
									 DB_DEVAL_ALCADA,
									 DB_DEVAL_STATUS														
									)
							VALUES
									(@P_NRODEVOLUCAO,
									 (SELECT ISNULL(MAX(DB_DEVAL_SEQ), 0) + 1 FROM DB_DEVOLUCAO_ALCADA WHERE DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO),
									 @VDB_ALCP_CODIGO,
									 0														
									);
						END
						ELSE
						BEGIN
							INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_OBJETO, DBS_ERROS_ERRO, DBS_ERROS_DATA)
													VALUES 
														   ('MERCP_LIBERACAO_DEVOLUCAO', 'DEVOLUCAO: ' + CAST(@P_NRODEVOLUCAO AS VARCHAR) + ' - NÃO ENCONTROU ALÇADA' , GETDATE())
						END
				END
			END
		END
		ELSE --- Devolução é avaliada por todas as alçadas conforme valor
		BEGIn
			IF @V_ALCADA_OK <> 1 
			BEGIN
				SET @VERRO  = 'DEVOLUCAO ' + CAST(CAST(@P_NRODEVOLUCAO AS BIGINT) AS VARCHAR) + ', ESTA TENTANDO SER LIBERADA POR UM USUARIO  QUE NÃO PERTENCE A ALCADA ATUAL. USUÁRIO: ' + @P_USUARIO
				INSERT INTO DBS_ERROS_TRIGGERS(DBS_ERROS_DATA, DBS_ERROS_ERRO, DBS_ERROS_OBJETO) 
										VALUES
											  (GETDATE(), @VERRO, 'MERCP_LIBERACAO_DEVOLUCAO')
			END
			ELSE
			BEGIN
				---- BUSCA ALCADA QUANDO DEVOLUCAO E GRAVADA
				IF ISNULL(@P_USUARIO, '') = ''
				BEGIn
					SELECT @V_REPRES        = DV01_REPRES,
							   @V_EMPRESA       = DV01_EMPRESA,
							   @V_CLI_CLASCOM   = DB_CLI_CLASCOM,
							   @V_CLI_REGIAOCOM = DB_CLI_REGIAOCOM,
							   @V_CLI_RAMATIV   = DB_CLI_RAMATIV
						  FROM MDV01, DB_CLIENTE
						 WHERE DV01_NRO = @P_NRODEVOLUCAO
						   AND DB_CLI_CODIGO = DV01_CLIENTE;
						SELECT @V_VALOR_DEVOLUCAO = SUM(DV02_QTDE * DV02_PRECO)
						  FROM MDV02
						 WHERE DV02_NRO = @P_NRODEVOLUCAO;
						BEGIN
							DECLARE C	CURSOR
							FOR SELECT DB_ALCP_CODIGO
								  FROM DB_ALCADA_PED
					  			 WHERE DB_ALCP_CODIGO IN (
															SELECT DB_ALCP_CODIGO
															  FROM DB_ALCADA_PED
															 WHERE DBO.MERCF_VALIDA_LISTA(@V_EMPRESA,	         DB_ALCP_LSTEMP,    0, ',') > 0
															   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_RAMATIV,	     DB_ALCP_LSTRAMO,   0, ',') > 0
															   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_CLASCOM,	     DB_ALCP_LSTCLASS,  0, ',') > 0
															   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_REGIAOCOM,	     DB_ALCP_LSTREGCOM, 0, ',') > 0
															   AND DBO.MERCF_VALIDA_LISTA(@V_REPRES,	         DB_ALCP_LSTREP,    0, ',') > 0
															   AND ((@V_REPRES IN (SELECT Z.DB_EREG_REPRES
																					 FROM DB_ESTRUT_VENDA X, 
																						  DB_ESTRUT_VENDA Y, 
																						  DB_ESTRUT_REGRA Z, 
																						  DB_ESTRUT_REGRA Z1, 
																						  DB_ALCADA_ESTRUT AL
																					WHERE X.DB_EVDA_ESTRUTURA  = Y.DB_EVDA_ESTRUTURA																				
																					  AND Y.DB_EVDA_CODIGO     LIKE (X.DB_EVDA_CODIGO + '%')
																					  AND X.DB_EVDA_ESTRUTURA  = Z.DB_EREG_ESTRUTURA
																					  AND Y.DB_EVDA_ID         = Z.DB_EREG_ID
																					  AND X.DB_EVDA_ESTRUTURA  = Z1.DB_EREG_ESTRUTURA
																					  AND X.DB_EVDA_ID         = Z1.DB_EREG_ID
																					  AND Z.DB_EREG_SEQ        = 1
																					  AND AL.DB_ALCE_ESTRUTURA = Z1.DB_EREG_ESTRUTURA
																					  AND DB_ALCP_CODIGO       = AL.DB_ALCE_ALCADA
																					  AND AL.DB_ALCE_ID        =  Z1.DB_EREG_ID ))  OR ((SELECT TOP(1) DB_ALCE_ALCADA
																																		   FROM DB_ALCADA_ESTRUT
																																		  WHERE DB_ALCP_CODIGO = DB_ALCE_ALCADA) IS NULL))																																																	  																												
																AND DB_ALCP_TIPO = 3
																	)
															  ORDER BY DB_ALCP_GRPALCADA, DB_ALCP_GRUPOLIB, DB_ALCP_NIVELLIB
								OPEN C
								FETCH NEXT FROM C
								INTO @V_ALCP_CODIGO_TEMP
								BEGIN
									IF @VDB_ALCP_CODIGO IS NULL
										SET @VDB_ALCP_CODIGO = @V_ALCP_CODIGO_TEMP;
									END
								FETCH NEXT FROM C
								INTO @V_ALCP_CODIGO_TEMP
							END
								CLOSE C
								DEALLOCATE C
							IF ISNULL(@VDB_ALCP_CODIGO, '') <> ''
							BEGIn
								delete DB_DEVOLUCAO_ALCADA where DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO
								INSERT INTO DB_DEVOLUCAO_ALCADA
										(DB_DEVAL_DEVOLUCAO,
										 DB_DEVAL_SEQ,
										 DB_DEVAL_ALCADA,
										 DB_DEVAL_STATUS														
										)
								VALUES
										(@P_NRODEVOLUCAO,
										 (SELECT ISNULL(MAX(DB_DEVAL_SEQ), 0) + 1 FROM DB_DEVOLUCAO_ALCADA WHERE DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO),
										 @VDB_ALCP_CODIGO,
										 0														
										);
							END
							ELSE
							BEGIN
								INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_OBJETO, DBS_ERROS_ERRO, DBS_ERROS_DATA)
														VALUES 
															   ('MERCP_LIBERACAO_DEVOLUCAO', 'DEVOLUCAO: ' + CAST(@P_NRODEVOLUCAO AS VARCHAR) + ' - NÃO ENCONTROU ALÇADA' , GETDATE())
							END
				END
				ELSE ---- VERIFICA SE EXISTE UMA PROXIMA ALCADA DE LIBERACAO
				BEGIN
					SELECT @V_VALOR_DEVOLUCAO = SUM(DV02_QTDE * DV02_PRECO)
					  FROM MDV02
					 WHERE DV02_NRO = @P_NRODEVOLUCAO;
					 SELECT @V_VALOR_DEVOLUCAO_ALCADA = DB_ALCP_VLRMAXLIB
					   FROM DB_DEVOLUCAO_ALCADA, DB_ALCADA_PED
					  WHERE DB_ALCP_TIPO = 3
					    AND DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO
						AND DB_DEVAL_ALCADA = DB_ALCP_CODIGO
						and DB_DEVAL_ALCADA = @V_ALCADA_ATUAL
					-- PODE LIBERAR OU AUTORIZAR
					IF @V_VALOR_DEVOLUCAO < @V_VALOR_DEVOLUCAO_ALCADA
					BEGIn
						IF @P_ACAO = 1 -- LIBERAR
						BEGIN
							 UPDATE DB_DEVOLUCAO_ALCADA
								SET DB_DEVAL_STATUS     = 1,
									DB_DEVAL_USULIB     = @V_CODIGO_USUARIO,
									DB_DEVAL_DATA_LIB   = GETDATE()
							  WHERE DB_DEVAL_DEVOLUCAO  = @P_NRODEVOLUCAO
								AND DB_DEVAL_SEQ = (SELECT ISNULL(MAX(DB_DEVAL_SEQ), 1) FROM DB_DEVOLUCAO_ALCADA WHERE DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO)
							 UPDATE MDV01 
								SET DV01_SITUACAO = 1
							  WHERE DV01_NRO = @P_NRODEVOLUCAO
						END
						ELSE IF @P_ACAO = 2  -- NAO AUTORIZAR
						BEGIN
							 UPDATE DB_DEVOLUCAO_ALCADA 
								SET DB_DEVAL_STATUS    = 2,
									DB_DEVAL_USULIB    = @V_CODIGO_USUARIO,
									DB_DEVAL_DATA_LIB  = GETDATE()
							  WHERE DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO
								AND DB_DEVAL_SEQ = (SELECT ISNULL(MAX(DB_DEVAL_SEQ), 1) FROM DB_DEVOLUCAO_ALCADA WHERE DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO)
							 UPDATE MDV01 
								SET DV01_SITUACAO = 2
							  WHERE DV01_NRO = @P_NRODEVOLUCAO
						END
					END
					ELSE --- BUSCA PROXIMA ALCADA PARA LIBERACAO
					BEGIN
						SET @V_ALCP_GRPALCADA_ANTERIOR = NULL;
						SET @V_ALCP_CODIGO_ANTERIOR = NULL;
						SELECT @V_ALCP_GRPALCADA_ANTERIOR = DB_ALCP_GRPALCADA,
							   @V_ALCP_CODIGO_ANTERIOR    = MAX(DB_ALCP_CODIGO)
						  FROM DB_ALCADA_PED A, DB_DEVOLUCAO_ALCADA B
						 WHERE DB_ALCP_CODIGO     = DB_DEVAL_ALCADA
						   AND DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO
						 GROUP BY DB_ALCP_GRPALCADA				    
						SELECT @V_REPRES        = DV01_REPRES,
							   @V_EMPRESA       = DV01_EMPRESA,
							   @V_CLI_CLASCOM   = DB_CLI_CLASCOM,
							   @V_CLI_REGIAOCOM = DB_CLI_REGIAOCOM,
							   @V_CLI_RAMATIV   = DB_CLI_RAMATIV
						  FROM MDV01, DB_CLIENTE
						 WHERE DV01_NRO = @P_NRODEVOLUCAO
						   AND DB_CLI_CODIGO = DV01_CLIENTE;
						BEGIN
							DECLARE C	CURSOR
							FOR SELECT DB_ALCP_CODIGO
								  FROM DB_ALCADA_PED
					  			 WHERE DB_ALCP_CODIGO IN (
															SELECT DB_ALCP_CODIGO
															  FROM DB_ALCADA_PED
															 WHERE DBO.MERCF_VALIDA_LISTA(@V_EMPRESA,	         DB_ALCP_LSTEMP,    0, ',') > 0
															   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_RAMATIV,	     DB_ALCP_LSTRAMO,   0, ',') > 0
															   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_CLASCOM,	     DB_ALCP_LSTCLASS,  0, ',') > 0
															   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_REGIAOCOM,	     DB_ALCP_LSTREGCOM, 0, ',') > 0
															   AND DBO.MERCF_VALIDA_LISTA(@V_REPRES,	         DB_ALCP_LSTREP,    0, ',') > 0
															   AND ((@V_REPRES IN (SELECT Z.DB_EREG_REPRES
																					 FROM DB_ESTRUT_VENDA X, 
																						  DB_ESTRUT_VENDA Y, 
																						  DB_ESTRUT_REGRA Z, 
																						  DB_ESTRUT_REGRA Z1, 
																						  DB_ALCADA_ESTRUT AL
																					WHERE X.DB_EVDA_ESTRUTURA  = Y.DB_EVDA_ESTRUTURA																				
																					  AND Y.DB_EVDA_CODIGO     LIKE (X.DB_EVDA_CODIGO + '%')
																					  AND X.DB_EVDA_ESTRUTURA  = Z.DB_EREG_ESTRUTURA
																					  AND Y.DB_EVDA_ID         = Z.DB_EREG_ID
																					  AND X.DB_EVDA_ESTRUTURA  = Z1.DB_EREG_ESTRUTURA
																					  AND X.DB_EVDA_ID         = Z1.DB_EREG_ID
																					  AND Z.DB_EREG_SEQ        = 1
																					  AND AL.DB_ALCE_ESTRUTURA = Z1.DB_EREG_ESTRUTURA
																					  AND DB_ALCP_CODIGO       = AL.DB_ALCE_ALCADA
																					  AND AL.DB_ALCE_ID        =  Z1.DB_EREG_ID ))  OR ((SELECT TOP(1) DB_ALCE_ALCADA
																																		   FROM DB_ALCADA_ESTRUT
																																		  WHERE DB_ALCP_CODIGO = DB_ALCE_ALCADA) IS NULL))																																																	  																												
																AND DB_ALCP_TIPO = 3
																AND ( DB_ALCP_GRPALCADA = @V_ALCP_GRPALCADA_ANTERIOR OR ISNULL(@V_ALCP_GRPALCADA_ANTERIOR, '') = '') ---- se ja foi liberado por alguem deve seguir na mesma alcada										                       
															    AND DB_ALCP_CODIGO NOT IN ( SELECT DB_ALCP_CODIGO   --- NAO DEVE SER IGUALAO ULTIMO NIVEL LIBERADEO
																							  FROM DB_ALCADA_PED A, 
																							       DB_DEVOLUCAO_ALCADA B
																							 WHERE DB_ALCP_CODIGO     = DB_DEVAL_ALCADA
																							   AND DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO)
																	)
															  ORDER BY DB_ALCP_GRPALCADA, DB_ALCP_GRUPOLIB, DB_ALCP_NIVELLIB
								OPEN C
								FETCH NEXT FROM C
								INTO @V_ALCP_CODIGO_TEMP
								BEGIN
									IF @VDB_ALCP_CODIGO IS NULL
										SET @VDB_ALCP_CODIGO = @V_ALCP_CODIGO_TEMP;
									END
								FETCH NEXT FROM C
								INTO @V_ALCP_CODIGO_TEMP
							END
								CLOSE C
								DEALLOCATE C
							IF ISNULL(@VDB_ALCP_CODIGO, '') <> ''
							BEGIn
								update DB_DEVOLUCAO_ALCADA
								   set DB_DEVAL_STATUS    = 2,
								       dB_DEVAL_USULIB    = @V_CODIGO_USUARIO,
									   DB_DEVAL_DATA_LIB  = GETDATE()
								where DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO
								  and DB_DEVAL_SEQ = (SELECT ISNULL(MAX(DB_DEVAL_SEQ), 0) FROM DB_DEVOLUCAO_ALCADA WHERE DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO)
								INSERT INTO DB_DEVOLUCAO_ALCADA
										(DB_DEVAL_DEVOLUCAO,
										 DB_DEVAL_SEQ,
										 DB_DEVAL_ALCADA,
										 DB_DEVAL_STATUS														
										)
								VALUES
										(@P_NRODEVOLUCAO,
										 (SELECT ISNULL(MAX(DB_DEVAL_SEQ), 0) + 1 FROM DB_DEVOLUCAO_ALCADA WHERE DB_DEVAL_DEVOLUCAO = @P_NRODEVOLUCAO),
										 @VDB_ALCP_CODIGO,
										 0														
										);
							END
							ELSE
							BEGIN
								INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_OBJETO, DBS_ERROS_ERRO, DBS_ERROS_DATA)
														VALUES 
															   ('MERCP_LIBERACAO_DEVOLUCAO', 'DEVOLUCAO: ' + CAST(@P_NRODEVOLUCAO AS VARCHAR) + ' - NÃO ENCONTROU ALÇADA' , GETDATE())
							END
					END
				END
			END
		END
END TRY
BEGIN CATCH
	INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_OBJETO, DBS_ERROS_ERRO, DBS_ERROS_DATA)
							VALUES
			                       ('MERCP_LIBERACAO_DEVOLUCAO', 'ERRO: ' + ERROR_MESSAGE() + @P_USUARIO, GETDATE())
END CATCH
END -- FIM
