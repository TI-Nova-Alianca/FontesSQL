CREATE  PROCEDURE MERCP_LIBERACAO_CARGA (@P_NUMERO_CARGA INT,
                                         @P_USUARIO      VARCHAR(25),
                                         @P_ACAO         INT) AS
DECLARE
  @V_CODIGO_USUARIO   VARCHAR(40),
  @VDB_ALCP_GRPALCADA VARCHAR(25),
  @V_ALCADA_ATUAL     VARCHAR(5),
  @VERRO              VARCHAR(512),
  @V_ALCADA_CODIGO    VARCHAR(25),
  @V_ALCP_CODIGO_TEMP VARCHAR(25),
  @V_PERCENTUAL       FLOAT,
  @V_ALCADA_OK        INT;
BEGIN
BEGIN TRY
	SELECT @V_CODIGO_USUARIO = CODIGO        
    FROM DB_USUARIO
    WHERE USUARIO = @P_USUARIO;
  -- SE RECEBEU USUARIO DEVE VALIDAR SE O REGISTRO DA DB_PEDIDO_ALCADA ESTA NA SUA ALCADA
  -- ISSO DEVE SER FEITO POIS 2 USUARIOS DA MESMA ALCADA PODEM TENTAR LIBERAR O MESMO PEDIDO NO MESMO INSTANTE
  IF ISNULL(@V_CODIGO_USUARIO, '') <> ''
  BEGIN
    SELECT @V_ALCADA_ATUAL = DB_CARGAL_ALCADA     
      FROM DB_CARGA_ALCADA
     WHERE DB_CARGAL_CARGA   = @P_NUMERO_CARGA
       AND DB_CARGAL_STATUS  = 0;
    IF @V_ALCADA_ATUAL IS NOT NULL
	BEGIN
        SELECT @V_ALCADA_OK = 1
          FROM DB_ALCADA_USUARIO
         WHERE DB_ALCU_ALCADA = @V_ALCADA_ATUAL
           AND DB_ALCU_USUARIO = @V_CODIGO_USUARIO;      
    END
  END
  ELSE
  BEGIN
    SET @V_ALCADA_OK = 1;
  END;
  IF @V_ALCADA_OK <> 1
  BEGIN
    SET @VERRO = 'USUARIO ' + @P_USUARIO + ' ESTA TENTANDO LIBERAR UMA CARGA QUE NÃO ESTA EM SUA ALÇADA ';  
    INSERT INTO DBS_ERROS_TRIGGERS
      (DBS_ERROS_DATA, DBS_ERROS_ERRO, DBS_ERROS_OBJETO)
    VALUES
      (GETDATE(), @VERRO, 'MERCP_LIBERACAO_CARGAS');  
  END
  IF @V_ALCADA_OK = 1 
  BEGIN
    IF ISNULL(@P_USUARIO, '') <> '' AND @P_ACAO = 1
	BEGIN	
      --IRA LIBERAR A CARGA      
      UPDATE DB_CARGA_ALCADA
         SET DB_CARGAL_USULIB   = @V_CODIGO_USUARIO,
             DB_CARGAL_DATA_LIB = GETDATE(),
             DB_CARGAL_STATUS   = 1
       WHERE DB_CARGAL_CARGA = @P_NUMERO_CARGA;
       UPDATE DB_ROMANEIO
          SET DB_ROM_SITUACAO = 5
        WHERE DB_ROM_ROMANEIO = @P_NUMERO_CARGA;
	END
    ELSE
	BEGIN
      --QUANDO NAO TIVER USUARIO POR PARAMETRO BUSCA UMA ALCADA PARA A CARGA E GRAVA NA DB_CARGA_ALCADA
        SELECT @V_PERCENTUAL = DB_ROM_PERCFRETE - DB_ROM_PERCFRETE_UF           
          FROM DB_ROMANEIO
         WHERE DB_ROM_ROMANEIO = @P_NUMERO_CARGA
		 BEGIN
		    DECLARE C CURSOR
			FOR SELECT DB_ALCP_CODIGO
				  FROM DB_ALCADA_PED
				 WHERE DB_ALCP_CODIGO IN (SELECT DB_ALCP_CODIGO
										    FROM DB_ALCADA_PED
										   WHERE @V_PERCENTUAL <= DB_ALCP_VLRMAXLIB
										     AND DB_ALCP_TIPO = 4)
										   ORDER BY DB_ALCP_GRPALCADA, DB_ALCP_GRUPOLIB, DB_ALCP_NIVELLIB
					OPEN C
					FETCH NEXT FROM C
					INTO @V_ALCP_CODIGO_TEMP
					BEGIN
						IF @V_ALCADA_CODIGO IS NULL
							SET @V_ALCADA_CODIGO = @V_ALCP_CODIGO_TEMP;
					END
					FETCH NEXT FROM C
					INTO @V_ALCP_CODIGO_TEMP
	     END
			CLOSE C
			DEALLOCATE C   
		  IF ISNULL(@V_ALCADA_CODIGO, '') <> ''
		  BEGIN
		    DELETE DB_CARGA_ALCADA WHERE DB_CARGAL_CARGA = @P_NUMERO_CARGA
			INSERT INTO DB_CARGA_ALCADA
			  (DB_CARGAL_CARGA,
			   DB_CARGAL_SEQ,
			   DB_CARGAL_ALCADA,
			   DB_CARGAL_STATUS)
			VALUES
			  (@P_NUMERO_CARGA, 
			   1, 
			   @V_ALCADA_CODIGO, 
			   0);
		  END
    END
  END -- IF ALCADA OK = 1
END TRY
BEGIN CATCH
	INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_OBJETO, DBS_ERROS_ERRO, DBS_ERROS_DATA)
							 VALUES
								   ('MERCP_LIBERACAO_CARGA', 'ERRO: ' + ERROR_MESSAGE() + @P_USUARIO, GETDATE())
END CATCH
END;
