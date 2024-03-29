ALTER PROCEDURE       MERCP_WORKFLOW  (@PWL_SITUACAO  INTEGER,
                                        @PWL_CLICOD    FLOAT,
                                        @PWL_PEDIDO    INTEGER,
                                        @PWL_EMPRESA   VARCHAR(10),
                                        @PWL_NOTA      INTEGER,
                                        @PWL_SERIE     VARCHAR(512),
                                        @PWL_DUPLICATA VARCHAR(512),
                                        @PWL_PARCELA   VARCHAR(100),
                                        @PWL_USUARIO   VARCHAR(50),
                                        @PWL_MENSAGEM  VARCHAR(3000) = '',
										@PWL_TIPO_CHAMA int = 0  ---- QUAM CHAMAROU O WORKFLOW  0 = NAO FAZ NADA, 1 - LIBERAÇÃO INVESTIMENTO
                                       ) AS
BEGIN
DECLARE @VVWF2_ACAO        INTEGER;
DECLARE @VVWF2_DADOS       VARCHAR(6);
DECLARE @VVWF2_CLIENTE     FLOAT;
DECLARE @VVDBS_EML_SEQ     INTEGER;
DECLARE @VVWF3_NOME_REMET  VARCHAR(255);
DECLARE @VVWF3_EMAIL_REMET VARCHAR(255);
DECLARE @VVWF3_TITULO      VARCHAR(255);
DECLARE @VVWF3_TEXTO       VARCHAR(2000);
DECLARE @VV_EML_DEST       VARCHAR(2000);
DECLARE @VV_EML_END_DEST   VARCHAR(2000);
DECLARE @VV_EML_ASSUNTO    VARCHAR(2000);
DECLARE @VV_EML_MENSAGEM   VARCHAR(4000);
DECLARE @VWL_CLI_CNPJ      VARCHAR(15);
DECLARE @VWL_CLI_VINCULO   FLOAT;
DECLARE @VWL_CLIENTE       FLOAT;
DECLARE @VVDATA            DATETIME;
DECLARE @VERRO             VARCHAR(512);
DECLARE @WF3_MODELOIMPRESSAO INT;
DECLARE @DB_PEDC_USU_CRIA   VARCHAR(20);
---------------------------------------------------------------------
---  VERSAO   DATA        AUTOR           ALTERACAO
---  1.00001              ALENCAR BOITO   DESENVOLVIMENTO
---  1.00002  22/07/2011  FERNANDO LESSA  CONVERSAO PARA SQLSERVER
---  1.00003  09/07/2015  TIAGO PRADELLA  DEFINIDO TAMANHO DE CAMPOS VARCHAR NS PARAMETROS DE ENTRADA
---  1.00004  16/07/2015  tiago           incluido try catch
---  1.00005  06/06/2017  tiago           novo parametro mensagem complementar, utilizada para a liberação de investimentos
---------------------------------------------------------------------
BEGIN TRY
-- SE CLIENTE FOR ZERO PEGA O CLIENTE PEDIDO OU DA NOTA
SET @VWL_CLIENTE = @PWL_CLICOD;
IF @VWL_CLIENTE = 0
BEGIN
   IF @PWL_PEDIDO > 0
   BEGIN
      SELECT @VWL_CLIENTE = DB_PED_CLIENTE
        FROM DB_PEDIDO
       WHERE DB_PED_NRO = @PWL_PEDIDO;
   END
   ELSE
   BEGIN
      IF @PWL_NOTA > 0
      BEGIN
         SELECT @VWL_CLIENTE = DB_NOTA_CLIENTE
           FROM DB_NOTA_FISCAL
          WHERE DB_NOTA_EMPRESA = @PWL_EMPRESA
            AND DB_NOTA_NRO     = @PWL_NOTA
            AND DB_NOTA_SERIE   = @PWL_SERIE;
      END
   END
END
-- WORKFLOW POR CLIENTE
IF @VWL_CLIENTE > 0
BEGIN
   SELECT @VWL_CLI_CNPJ = DB_CLI_CGCMF, @VWL_CLI_VINCULO = DB_CLI_VINCULO
     FROM DB_CLIENTE
    WHERE DB_CLI_CODIGO = @VWL_CLIENTE
   DECLARE CUR CURSOR
        FOR (SELECT WF2_ACAO, WF2_DADOS, WF2_CLIENTE --INTO  VWF2_ACAO, VWF2_DADOS, VWF2_CLIENTE
                          FROM MWF2, DB_CLIENTE
                         WHERE WF2_CLIENTE = DB_CLI_CODIGO
                           AND WF2_SITUACAO = @PWL_SITUACAO                             
                           AND (    (WF2_AGRUPAR=0 AND WF2_CLIENTE = @VWL_CLIENTE )
                                 OR (WF2_AGRUPAR=2 AND DB_CLI_VINCULO = @VWL_CLI_VINCULO ) 
                                 OR (WF2_AGRUPAR=1 AND DB_CLI_CGCMF BETWEEN SUBSTRING(@VWL_CLI_CNPJ,1,8) + '000000'
                                                                        AND SUBSTRING(@VWL_CLI_CNPJ,1,8) + '999999'))
                   )
        OPEN CUR
        FETCH NEXT FROM CUR
             INTO  @VVWF2_ACAO, @VVWF2_DADOS, @VVWF2_CLIENTE
        WHILE @@FETCH_STATUS = 0
        BEGIN
			      SELECT @VVWF3_NOME_REMET = WF3_NOME_REMET, @VVWF3_EMAIL_REMET = WF3_EMAIL_REMET, 
							@VVWF3_TEXTO = WF3_TEXTO, @VVWF3_TITULO = WF3_TITULO, @WF3_MODELOIMPRESSAO = WF3_MODELOIMPRESSAO
				     FROM MWF3
				     WHERE WF3_CODIGO = @VVWF2_DADOS ;
               EXECUTE DBO.MERCP_WORKFLOW_DEST 0
                                , @VVWF2_ACAO  
                                , @PWL_SITUACAO
                                , @VVWF2_CLIENTE
                                , @PWL_PEDIDO
                                , @PWL_EMPRESA
                                , @PWL_NOTA
                                , @PWL_SERIE
                                , @PWL_USUARIO
                                , @VV_EML_DEST OUTPUT
                                , @VV_EML_END_DEST OUTPUT;
               IF @VV_EML_END_DEST IS NOT NULL --THEN 
               BEGIN
                   EXECUTE DBO.MERCP_WORKFLOW_MENS @VVWF2_CLIENTE 
                                    , @PWL_PEDIDO
                                    , @PWL_EMPRESA
                                    , @PWL_NOTA
                                    , @PWL_SERIE
                                    , @PWL_USUARIO
                                    , @VVWF3_TITULO
                                    , @VVWF3_TEXTO
                                    , @VV_EML_ASSUNTO OUTPUT
                                    , @VV_EML_MENSAGEM OUTPUT
									, @PWL_MENSAGEM
									, @PWL_TIPO_CHAMA;
                   SELECT @VVDBS_EML_SEQ = MAX(DBS_EML_SEQ) FROM DBS_EMAIL
                          WHERE  DATEADD(DD, 0, DATEDIFF(DD, 0, DBS_EML_DT_EMISSAO)) = DATEADD(DD, 0, DATEDIFF(DD, 0, GETDATE())); --TRUNC(SYSDATETIME);
                   IF @VVDBS_EML_SEQ IS NULL 
                   BEGIN
                      SET @VVDBS_EML_SEQ = 0;
                   END
                   SET @VVDBS_EML_SEQ  = @VVDBS_EML_SEQ + 1;
				   SET @DB_PEDC_USU_CRIA = ''
				   IF @WF3_MODELOIMPRESSAO = 1
				   BEGIN
						SELECT @DB_PEDC_USU_CRIA = DB_PEDC_USU_CRIA
						  FROM DB_PEDIDO_COMPL
						WHERE DB_PEDC_NRO = @PWL_PEDIDO
				   END
                   INSERT INTO DBS_EMAIL
                               (DBS_EML_SEQ,       
                                DBS_EML_REPRES,    
                                DBS_EML_EMPRESA,   
                                DBS_EML_DT_EMISSAO,
                                DBS_EML_DT_ENVIO,  
                                DBS_EML_REMET,     
                                DBS_EML_END_REMET, 
                                DBS_EML_DEST,      
                                DBS_EML_END_DEST,  
                                DBS_EML_ASSUNTO,   
                                DBS_EML_MENSAGEM,  
                                DBS_EML_DADOS,     
                                DBS_EML_PEDIDO,    
                                DBS_EML_NOTA,      
                                DBS_EML_SERIE,     
                                DBS_EML_EMP_NF,
								DBS_EML_USUARIO,
								DBS_EML_USUARIO_REL)    
                       VALUES(@VVDBS_EML_SEQ ,       
                                0,    
                                '0',   
                               CONVERT(varchar,GETDATE(),120) , --TRUNC(SYSDATETIME),
                                NULL,  
                                @VVWF3_NOME_REMET,     
                                @VVWF3_EMAIL_REMET, 
                                @VV_EML_DEST,      
                                @VV_EML_END_DEST,  
                                @VV_EML_ASSUNTO,   
                                @VV_EML_MENSAGEM,  
                                @VVWF2_DADOS,     
                                @PWL_PEDIDO ,    
                                @PWL_NOTA ,      
                                @PWL_SERIE ,     
                                @PWL_EMPRESA,
								@PWL_USUARIO,
								@DB_PEDC_USU_CRIA);
                END
           FETCH NEXT FROM CUR
             INTO  @VVWF2_ACAO, @VVWF2_DADOS, @VVWF2_CLIENTE
       END;
   CLOSE CUR
   DEALLOCATE CUR
END
-- WORKFLOW GERAL
DECLARE CUR2 CURSOR
FOR (SELECT WF1_ACAO, WF1_DADOS
       FROM MWF1
      WHERE WF1_SITUACAO = @PWL_SITUACAO
             )
   OPEN CUR2
   FETCH NEXT FROM CUR2
      INTO  @VVWF2_ACAO, @VVWF2_DADOS
   WHILE @@FETCH_STATUS = 0
   BEGIN
       SET @VVWF2_CLIENTE  = @VWL_CLIENTE ;
       SELECT @VVWF3_NOME_REMET = WF3_NOME_REMET, @VVWF3_EMAIL_REMET = WF3_EMAIL_REMET, 
            @VVWF3_TEXTO = WF3_TEXTO, @VVWF3_TITULO = WF3_TITULO, @WF3_MODELOIMPRESSAO = WF3_MODELOIMPRESSAO
          FROM MWF3
          WHERE WF3_CODIGO = @VVWF2_DADOS;
       EXECUTE DBO.MERCP_WORKFLOW_DEST 1
                        , @VVWF2_ACAO
                        , @PWL_SITUACAO
                        , @VVWF2_CLIENTE
                        , @PWL_PEDIDO
                        , @PWL_EMPRESA
                        , @PWL_NOTA
                        , @PWL_SERIE
                        , @PWL_USUARIO
                        , @VV_EML_DEST OUTPUT
                        , @VV_EML_END_DEST OUTPUT;
       IF @VV_EML_END_DEST IS NOT NULL  
       BEGIN
           EXECUTE MERCP_WORKFLOW_MENS @VVWF2_CLIENTE
                            , @PWL_PEDIDO
                            , @PWL_EMPRESA
                            , @PWL_NOTA
                            , @PWL_SERIE
                            , @PWL_USUARIO
                            , @VVWF3_TITULO 
                            , @VVWF3_TEXTO
                            , @VV_EML_ASSUNTO OUTPUT
                            , @VV_EML_MENSAGEM OUTPUT
							, @PWL_MENSAGEM
							, @PWL_TIPO_CHAMA;
           SELECT @VVDBS_EML_SEQ = ISNULL(MAX(DBS_EML_SEQ), 0)  FROM DBS_EMAIL
                  WHERE DATEADD(DD, 0, DATEDIFF(DD, 0, DBS_EML_DT_EMISSAO)) = DATEADD(DD, 0, DATEDIFF(DD, 0, GETDATE())) --TRUNC(SYSDATE);
           IF @VVDBS_EML_SEQ IS NULL 
           BEGIN
                SET @VVDBS_EML_SEQ  = 0;
           END;
           SET @VVDBS_EML_SEQ = @VVDBS_EML_SEQ + 1;
		   SET @DB_PEDC_USU_CRIA = ''
		   IF @WF3_MODELOIMPRESSAO = 1
		   BEGIN
				SELECT @DB_PEDC_USU_CRIA = DB_PEDC_USU_CRIA
					FROM DB_PEDIDO_COMPL
				WHERE DB_PEDC_NRO = @PWL_PEDIDO
		   END
           INSERT INTO DBS_EMAIL
                       (DBS_EML_SEQ,       
                        DBS_EML_REPRES,    
                        DBS_EML_EMPRESA,   
                        DBS_EML_DT_EMISSAO,
                        DBS_EML_DT_ENVIO,  
                        DBS_EML_REMET,     
                        DBS_EML_END_REMET, 
                        DBS_EML_DEST,      
                        DBS_EML_END_DEST,  
                        DBS_EML_ASSUNTO,   
                        DBS_EML_MENSAGEM,  
                        DBS_EML_DADOS,     
                        DBS_EML_PEDIDO,    
                        DBS_EML_NOTA,      
                        DBS_EML_SERIE,     
                        DBS_EML_EMP_NF,
						DBS_EML_USUARIO,
						DBS_EML_USUARIO_REL)    
           VALUES(@VVDBS_EML_SEQ,       
                        0,    
                        '0',   
                       CONVERT(varchar,GETDATE(),120) , --TRUNC(SYSDATE),
                        NULL,  
                        @VVWF3_NOME_REMET,     
                        @VVWF3_EMAIL_REMET, 
                        @VV_EML_DEST,      
                        @VV_EML_END_DEST,  
                        @VV_EML_ASSUNTO,   
                        @VV_EML_MENSAGEM,  
                        @VVWF2_DADOS,--CUR2.WF1_DADOS,     
                        @PWL_PEDIDO,    
                        @PWL_NOTA,      
                        @PWL_SERIE,     
                        @PWL_EMPRESA,
						@PWL_USUARIO,
						@DB_PEDC_USU_CRIA);
       END;
	   FETCH NEXT FROM CUR2
		  INTO  @VVWF2_ACAO, @VVWF2_DADOS
   END;
CLOSE CUR2
DEALLOCATE CUR2
END TRY
	BEGIN CATCH
		SET @VERRO = 'ERRO : '  + ERROR_MESSAGE() + ' - LINHA : ' + CAST(ERROR_LINE() AS VARCHAR);
		INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, GETDATE(), 'WORKFLOW');
    --COMMIT;
	END CATCH
END;
