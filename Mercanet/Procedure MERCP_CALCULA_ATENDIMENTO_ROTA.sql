ALTER PROCEDURE [dbo].[MERCP_CALCULA_ATENDIMENTO_ROTA] ( @P_DIAS_INICIO   FLOAT = 0
                                                       , @P_CODIGO_ROTA   FLOAT = 0) AS
DECLARE  @VOBJETO                         VARCHAR(1000) = 'MERCP_CALCULA_ATENDIMENTO_ROTA';
DECLARE  @VERRO                           VARCHAR(1000);
declare @V_ACAO_NUMERODIASACOES           VARCHAR(5),
        @V_USUARIO                        VARCHAR(20),
		@V_DB_ROTA_CODIGO                 FLOAT,
		@V_DB_ROTA_DATAI                  DATETIME,
		@V_DB_ROTA_DATAF                  DATETIME,
		@V_DB_ROTA_DURACAO                INT,
		@V_DB_ROTAL_DIA                   SMALLINT,
		@V_DB_ROTAL_INICIO                SMALLINT,
		@V_DB_ROTAL_FREQ                  SMALLINT,
		@V_DB_ROTAL_FREQ_NOTNULL          SMALLINT,
		@V_DATA                           DATETIME,
		@V_DATA_INICIAL                   DATETIME,
		@V_DATA_MAX                       DATETIME,
		@V_DIASEMANA	                  INT,
		@V_NUMERO_DIAS_ADD                INT;
  ---------------------------------------------------------------
  ---  VERSAO   DATA        AUTOR      ALTERACAO
  ---  1.00000  11/05/2016  ALENCAR    DESENVOLVIMENTO - ROTINA CRIADA PARA CALCULAR A TABELA DB_ROTAS_CLIENTES
  ---  1.00001  03/06/2016  ALENCAR    Parametro P_DIAS_INICIO - define o nro de dias que deve iniciar, se é o dia atual ou x dias a mais. Isso deve ser feito alinhado com o 
  ---                                       sincronismo de dados dos vendedores
  ---                                  Criado o campo DB_ROTAS_CLIENTES.SEQUENCIA  
  ---  1.00002  11/06/2016  PATRICIA   Alteração para calcular a rota até a data de validade e inclusive o último dia válido
  ---  1.00003  13/06/2016  ALENCAR    Ajustado os lacoes WHILE para avaliar o dia/semana atual
  ---  1.00004  16/03/2017  ALENCAR    Setar os parametros de entrada para 0 quando estiverem nulos
  ---  1.00005  30/06/2017  ALENCAR    No insert da DB_ROTAS_CLIENTES deve validar tambem o campo DB_ROTAL_INICIO
  ---  1.00006  15/05/2018  ALENCAR    Gravar o novo campo CAPTA_PEDIDOS na DB_ROTAS_CLIENTES
  ---------------------------------------------------------------
SET NOCOUNT ON;
BEGIN TRY
set @P_DIAS_INICIO = ISNULL(@P_DIAS_INICIO, 0)
set @P_CODIGO_ROTA = ISNULL(@P_CODIGO_ROTA, 0)
	--- PRIMEIRO BUSCA O PARAMETRO PARA DEFINIR O NRO DE DIAS A SEREM CALCULADOS 
	select @V_ACAO_NUMERODIASACOES = DB_PRMS_VALOR 
	     , @V_DATA_MAX = CONVERT(DATE, GETDATE() + cast(DB_PRMS_VALOR as numeric) + cast(@P_DIAS_INICIO as numeric), 103)
	  from DB_PARAM_SISTEMA
	where DB_PARAM_SISTEMA.DB_PRMS_ID = 'ACAO_NUMERODIASACOES'
	----------------------------------------------------
	--- PASSO 1 - Eliminar os registros com data maior igual ao dia atual
	----------------------------------------------------
	DELETE DB_ROTAS_CLIENTES
	 WHERE DATA     >= CONVERT(DATE, GETDATE()  + cast(@P_DIAS_INICIO as numeric), 103)
	  AND (ROTA      = @P_CODIGO_ROTA or @P_CODIGO_ROTA = 0)	  
	  AND (isnull(DB_ROTAS_CLIENTES.MANUAL, 0) <> 1 AND isnull(DB_ROTAS_CLIENTES.EXCLUIDO, 0) <> 1);
	--------------------------------------
	--- PASSO 2 - Cursor que busca as rotas validas para o período, agrupando para melhorar o desempenho
	--------------------------------------
	DECLARE CUR_ROTAS CURSOR
	FOR SELECT USU.USUARIO
			 , ROTA.DB_ROTA_CODIGO
			 , ROTA.DB_ROTA_DATAI
			 , ROTA.DB_ROTA_DATAF
			 , ROTA.DB_ROTA_DURACAO
			 , ROTAL.DB_ROTAL_DIA
			 , ROTAL.DB_ROTAL_INICIO
			 , ROTAL.DB_ROTAL_FREQ
			 , case isnull(DB_ROTAL_FREQ, 0) when 0 then 1 
                                   else DB_ROTAL_FREQ 
               end
		  FROM DB_ROTAS         ROTA
			 , DB_ROTAS_LINHAS  ROTAL 
			 , DB_USUARIO       USU
		 WHERE ROTA.DB_ROTA_CODIGO   = ROTAL.DB_ROTAL_CODIGO
		   AND ROTA.DB_ROTA_REPRES   =  USU.CODIGO_ACESSO
		   AND ROTA.DB_ROTA_DATAF   >= CONVERT(DATE, GETDATE(), 103)
		   AND (DB_ROTA_CODIGO       = @P_CODIGO_ROTA or @P_CODIGO_ROTA = 0)
--and ROTAL.DB_ROTAL_CLIENTE = 3543
	        GROUP BY USU.USUARIO
					 , ROTA.DB_ROTA_CODIGO
					 , ROTA.DB_ROTA_DATAI
					 , ROTA.DB_ROTA_DATAF
					 , ROTA.DB_ROTA_DURACAO
					 , ROTAL.DB_ROTAL_DIA
					 , ROTAL.DB_ROTAL_INICIO
					 , ROTAL.DB_ROTAL_FREQ
	  OPEN CUR_ROTAS
	 FETCH NEXT FROM CUR_ROTAS
	  INTO @V_USUARIO,           @V_DB_ROTA_CODIGO,      @V_DB_ROTA_DATAI,     @V_DB_ROTA_DATAF,     @V_DB_ROTA_DURACAO
	     , @V_DB_ROTAL_DIA,      @V_DB_ROTAL_INICIO,     @V_DB_ROTAL_FREQ,     @V_DB_ROTAL_FREQ_NOTNULL
	 WHILE @@FETCH_STATUS = 0
	BEGIN
		----------------------------------------
		---- @V_DB_ROTAL_DIA = 0 --> DIARIAMENTE
		----------------------------------------
		IF @V_DB_ROTAL_DIA = 0 
		BEGIN
				IF @V_DB_ROTAL_INICIO = 2				
					SET @V_NUMERO_DIAS_ADD = 14				
				ELSE IF @V_DB_ROTAL_INICIO = 3				
					SET @V_NUMERO_DIAS_ADD = 21				
				ELSE IF @V_DB_ROTAL_INICIO = 4				
					SET @V_NUMERO_DIAS_ADD = 28
				ELSE
					SET @V_NUMERO_DIAS_ADD = @V_DB_ROTAL_INICIO
			    SET @V_DATA_INICIAL = @V_DB_ROTA_DATAI + @V_NUMERO_DIAS_ADD;
				SET @V_DATA         = @V_DATA_INICIAL;				
				--WHILE (SELECT @V_DATA + (1 * @V_DB_ROTAL_FREQ_NOTNULL)) <= @V_DB_ROTA_DATAF
				WHILE @V_DATA <= @V_DB_ROTA_DATAF
				BEGIN
				   --- Teste para inserir somente ate a data máxima
				   IF @V_DATA > @V_DB_ROTA_DATAF
					OR @V_DATA > @V_DATA_MAX
					  BREAK
				   --- Insere se a data do laco estiver dentro do período valido, que compreende do dia atual até o número de dias do parâmetro ACAO_NUMERODIASACOES
				   IF @V_DATA >= @V_DB_ROTA_DATAI
					 AND @V_DATA >= CONVERT(DATE, GETDATE()  + cast(@P_DIAS_INICIO as numeric), 103)
				   BEGIN
					  BEGIN TRY					  
						  --- Insere todos os registros da rota, do dia e frequencia 
						  INSERT INTO DB_ROTAS_CLIENTES (USUARIO, ROTA, CLIENTE, DATA,	SEQUENCIA, CAPTA_PEDIDOS)
								 (SELECT @V_USUARIO, @V_DB_ROTA_CODIGO, ROTAL.DB_ROTAL_CLIENTE, @V_DATA, ROTAL.DB_ROTAL_SEQ, ROTAL.DB_ROTAL_CAPTA_PEDIDOS
									FROM DB_ROTAS         ROTA
										, DB_ROTAS_LINHAS  ROTAL 
									WHERE ROTA.DB_ROTA_CODIGO   = ROTAL.DB_ROTAL_CODIGO
									  AND ROTA.DB_ROTA_CODIGO   = @V_DB_ROTA_CODIGO
									  AND ROTAL.DB_ROTAL_DIA    = @V_DB_ROTAL_DIA
									  AND ROTAL.DB_ROTAL_FREQ   = @V_DB_ROTAL_FREQ)
				      END TRY
					  BEGIN CATCH					  
						 --set @VERRO  = cast(ERROR_NUMBER() as varchar) + ERROR_MESSAGE()					  	 
					  --	 SET @VERRO = @VERRO;
					  --	 INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
					  --	 						VALUES (substring(@VERRO, 1, 200), getdate(), @VOBJETO);
					  END CATCH
				   END
				   SET @V_DATA = @V_DATA + (1 * @V_DB_ROTAL_FREQ_NOTNULL)
				END
		END;
		----------------------------------------
		---- @V_DB_ROTAL_DIA = 1, 2, 3, 4, 5, 6, 7 --> DIA DA SEMANA
		----------------------------------------
		ELSE
		BEGIN			
				SET @V_DATA_INICIAL = @V_DB_ROTA_DATAI + (@V_DB_ROTAL_INICIO * 7)
				---- @V_DB_ROTAL_DIA = 1-Segunda-feira, 2-Terça-feira, 3-Quarta-feira, 4-Quinta-feira, 5-Sexta-feira, 6-Sábado e 7-Domingo
				SET @V_DIASEMANA = CASE @V_DB_ROTAL_DIA WHEN 7 THEN 1 
				                                        WHEN 1 THEN 2
				                                        WHEN 2 THEN 3
									                    WHEN 3 THEN 4
														WHEN 4 THEN 5
														WHEN 5 THEN 6
														WHEN 6 THEN 7
				                 	END
                ---- Encontra o proximo dia da semana válido para se tornar a data inicial
				---- Ex.: se esta processando segunda, encontra a proxima segunda, se terca, encontra a proxima terca...
				While DATEPART(DW,@V_DATA_INICIAL) <> @V_DIASEMANA
				  --and @V_DATA_INICIAL < CONVERT(DATE, GETDATE()  + cast(@P_DIAS_INICIO as numeric), 103)
				Begin
				   Set @V_DATA_INICIAL =  dateadd (day, 1, @V_DATA_INICIAL)				
				End			
				SET @V_DATA     = @V_DATA_INICIAL;
				--WHILE (SELECT @V_DATA + (7 * @V_DB_ROTAL_FREQ_NOTNULL)) <= @V_DB_ROTA_DATAF
				WHILE @V_DATA <= @V_DB_ROTA_DATAF
				BEGIN
				   --- Teste para inserir somente ate a data máxima
				   IF @V_DATA > @V_DB_ROTA_DATAF
					OR @V_DATA > @V_DATA_MAX					
					  BREAK										
				   --- Insere se a data do laco estiver dentro do período valido, que compreende do dia atual até o número de dias do parâmetro ACAO_NUMERODIASACOES
				   IF @V_DATA >= @V_DB_ROTA_DATAI
					 AND @V_DATA >= CONVERT(DATE, GETDATE()  + cast(@P_DIAS_INICIO as numeric), 103)
				   BEGIN				 
					  BEGIN TRY
						  --- Insere todos os registros da rota, do dia e frequencia 
						  INSERT INTO DB_ROTAS_CLIENTES (USUARIO, ROTA, CLIENTE, DATA, SEQUENCIA, CAPTA_PEDIDOS)
								 (SELECT @V_USUARIO, @V_DB_ROTA_CODIGO, ROTAL.DB_ROTAL_CLIENTE, @V_DATA, ROTAL.DB_ROTAL_SEQ, ROTAL.DB_ROTAL_CAPTA_PEDIDOS
									FROM DB_ROTAS         ROTA
										, DB_ROTAS_LINHAS  ROTAL 
									WHERE ROTA.DB_ROTA_CODIGO   = ROTAL.DB_ROTAL_CODIGO
									  AND ROTA.DB_ROTA_CODIGO   = @V_DB_ROTA_CODIGO
									  AND ROTAL.DB_ROTAL_DIA    = @V_DB_ROTAL_DIA
									  and ROTAL.DB_ROTAL_INICIO = @V_DB_ROTAL_INICIO
									  AND ROTAL.DB_ROTAL_FREQ   = @V_DB_ROTAL_FREQ									  )
					  END TRY
					  BEGIN CATCH
						 --set @VERRO  = cast(ERROR_NUMBER() as varchar) + ERROR_MESSAGE()
					  --	 SET @VERRO = @VERRO;
					  --	 INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
					  --	 						VALUES (substring(@VERRO, 1, 200), getdate(), @VOBJETO);
					  END CATCH				   
				   END
				   SET @V_DATA = @V_DATA + (7 * @V_DB_ROTAL_FREQ_NOTNULL)
				END
		END
	  FETCH NEXT FROM CUR_ROTAS
	  INTO @V_USUARIO,           @V_DB_ROTA_CODIGO,      @V_DB_ROTA_DATAI,     @V_DB_ROTA_DATAF,     @V_DB_ROTA_DURACAO
	     , @V_DB_ROTAL_DIA,      @V_DB_ROTAL_INICIO,     @V_DB_ROTAL_FREQ,     @V_DB_ROTAL_FREQ_NOTNULL
	  END
	  CLOSE CUR_ROTAS
	  DEALLOCATE CUR_ROTAS
END TRY
BEGIN CATCH
    set @VERRO  = cast(ERROR_NUMBER() as varchar) + ERROR_MESSAGE()
	SET @VERRO = @VERRO;
    INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
                            VALUES (substring(@VERRO, 1, 200), getdate(), @VOBJETO);
END CATCH
