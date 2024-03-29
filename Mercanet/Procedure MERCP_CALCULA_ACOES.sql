ALTER PROCEDURE dbo.MERCP_CALCULA_ACOES (@PCODIGO INT) AS
DECLARE @VENCONTROU_ROTA           FLOAT;
DECLARE @VCLIENTE_OLD              FLOAT;
DECLARE @VDIASEMANA                FLOAT;
DECLARE @VDIAS_INTERVALO           FLOAT;
DECLARE @VDIFERENCA                FLOAT;
DECLARE @VDATA_PRIMEIRO_DIA_SEMANA DATETIME;
DECLARE @VEXISTE_PERIODO           FLOAT;
DECLARE @VEXISTE_ACAO_CLIENTE      FLOAT;
DECLARE @VDATA_FINAL               DATETIME;
DECLARE @VATRIBUTO                 INT;
DECLARE @VSEQ_CODIGO               INT;
-- CURSOR C_ACOES
DECLARE @VCODIGO                   INT;
DECLARE @VTIPO_PESQUISA            INT;
DECLARE @VVALIDADE_INICIAL         DATETIME;
DECLARE @VVALIDADE_FINAL           DATETIME;
DECLARE @VTIPO_RECORRENCIA         INT;
DECLARE @VTEMPO_RESPOSTA           INT;
DECLARE @VPERIODICIDADE            INT;
DECLARE @VDIAS_SEMANA              VARCHAR(7);
DECLARE @VPERIODO                  INT;
-- C_USUARIOS
DECLARE @VUSUARIO                  VARCHAR(20);
-- CURSOR C_CLIENTES
DECLARE @VCODIGO_CLIEN             FLOAT;
-- CURSOR C_ATRIB
DECLARE @VID                       VARCHAR(30);
DECLARE @VCOD_ATRIB                VARCHAR(30);
-- CURSOR C_ROTAS
DECLARE @VCLIENTE                  FLOAT;
DECLARE @VDATA                     DATETIME;
-- CURSOR C_PESQ
DECLARE @SEPARADOR                 VARCHAR(1) SELECT @SEPARADOR = ';';
DECLARE @POS                       INT;
DECLARE @BUFFER                    VARCHAR(8000);
DECLARE @VVALOR                    VARCHAR(8000)
      , @V_DIASPARAEXPURGO         INT;
DECLARE @V_DELETE_OCORRENCIAS      INT;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00001  23/05/2016  ALENCAR          DESENVOLVIMENTO - ROTINA QUE CRIA ACOES (73888)
---  1.00002  31/05/2016  ALENCAR          SOMENTE ELIMINA ACOES QUE NAO FORAM RESPONDIDAS - SITUACAO = 0
---  1.00003  13/06/2016  ALENCAR          BUSCA ROTAS MAIORES QUE O INICIO DA PESQUISA
---  1.00004  14/06/2016  TIAGO            ALTERADO BUSCA DOS USUARIOS QUE AS PESQUISAS DEVEM SER SALVAS, PASSANDO A FAZER JOIN COM DB_PESQ_APLICADAS PARA BUSCAR A SELECAO
---  1.00005  14/06/2016  ALENCAR          CORRIGIDO FILTRO POR REDE DE CLIENTES
---  1.00006  16/06/2016  ALENCAR          DEVE ELIMINAR TODAS AS ACOES NAO PROCESSADAS PELA ROTINA MAIORES OU IGUAL AO DIA DE HOJE
---                                        PESQUISAS SEM RECORRENCIA VERIFICA SE A ACAO JA FOI CRIADA PARA O USUARIO E CLIENTE. SE JA CRIOU
---                                        NAO DEVE CRIAR UM NOVO REGISTRO
---                                        ADICIONADO PARAMETRO P_CODIGO
---                                        A DATA FINAL DA AÇÃO NÃO DEVE SER MAIOR QUE A VALIDADE DA PESQUISA
---  1.00007  17/06/2016  ALENCAR          GRAVAR OS NOVOS CAMPOS DATA INICIAL E FINAL NA DB_PESQ_OCORRENCIAS
---                                        TRATA QUANDO A PESQUISA EH CADASTRADA APENAS PARA 1 USUARIO
---                                        ELIMINA AS ACOES NAO PROCESSADAS SOMENTE DA PESQUISA DO PARAMETRO P_CODIGO
---                                        QUANDO EXISTIR A ACAO DEVE APENAS UPDATAR O PROCESSADO_ROTINA
---                                        JOIN CORRETO COM A TABELA DB_PERIODOS_TEMPO
---                                        CORRIGIDO WHILE QUE ENCONTRA O PRIMEIRO DIA DA ROTA QUANDO SEMANAL
---  1.00008  29/06/2016  ALENCAR          CORRIGIDO ERRO DE INVALID NUMBER - CONVERTE PARA STRING OS CAMPOS MCLI.CODIGO_CLIEN, MCLI.CNPJ_CLIEN E MCLI.VINCULO_CLIEN
---  1.00009  01/07/2016  ALENCAR          PASSA A TRATAR O CAMPO LISTA DE VALORES SEPARADOS(DB_PESQ_APLICADAS_CLIENTES) POR PONTO-E-VIRGULA
---  1.00010  07/07/2016  MATEUS           COMENTADA A UTILIZAÇÃO DA FUNÇÃO VW_CONCAT E SUBSTITUIDA PELA LISTAGG.
---                                        EM VERSÕES MAIS RECENTES DO ORACLE A VW_CONCAT RETORNAR UM CLOB E GERAVA ERRO   
---  1.00011  03/08/2016  ALENCAR          TROCADOR WM_CONCAT/LISTAGG POR XMLAGG, POIS ESSA FUNCAO EXECUTA EM TODAS AS VERSOES DO ORACLE
---  1.00012  18/09/2016  ALENCAR          AJUSTA VARIAVEL P_CODIGO QUE ESTAVA FIXA NO INSERT DA TABELA PESQ_APLICADAS_CLIENTES_A_TMP
---  1.00013  18/01/2017  SERGIO LUCCHINI  CONVERSAO PARA O SQL SERVER
---  1.00014  13/03/2017  ALENCAR          NAO UTILIZA SEQUENCE, POIS ELAS NAO SAO PERMITIDAS NO SQL 2008
---  1.00015  16/03/2017  ALENCAR          Setar os parametros de entrada para 0 quando estiverem nulos
---  1.00016  27/10/2017  ALENCAR          Utiliza cast(getdate as date) para encontrar acoes com data final no dia de hoje 
---  1.00017  20/12/2017  ALENCAR          79882 - Avaliar expurgo/deleção de registros da tabela de Ações do módulo de TradeMarketing
---  1.00018  23/04/2018  tiago            deleta registros da db_pesq_ocorrencias antes de inserir
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
set @PCODIGO = ISNULL(@PCODIGO, 0)
SET @V_DELETE_OCORRENCIAS = 0;
SET @VTEMPO_RESPOSTA = 1
SELECT @VTEMPO_RESPOSTA = DB_PRMS_VALOR
  FROM DB_PARAM_SISTEMA
 WHERE DB_PRMS_ID = 'ACAO_NUMERODIASACOES'
-- SETA TODAS AS ACOES COM O CAMPO PROCESSADO_ROTINA = 0. OS REGISTROS QUE NAO FOREM ATUALIZADOS NA ROTINA SERÃO ELIMINADOS
UPDATE DB_ACOES
   SET PROCESSADO_ROTINA = 0
 WHERE DATA_FINAL >= cast(GETDATE() as date)
-- CURSOR QUE ENCONTRA TODAS AS ACOES A SEREM CRIADAS NO INTERVALO DE DATAS, COM BASE NO PARAMETRO ACAO_NUMERODIASACOES
DECLARE C_ACOES CURSOR
FOR SELECT CODIGO, TIPO_PESQUISA, VALIDADE_INICIAL, VALIDADE_FINAL, TIPO_RECORRENCIA, TEMPO_RESPOSTA, PERIODICIDADE, DIAS_SEMANA, PERIODO
      FROM DB_PESQ_APLICADAS
     WHERE VALIDADE_INICIAL <= cast(GETDATE() + @VTEMPO_RESPOSTA  as date)
       AND VALIDADE_FINAL   >= cast(GETDATE() as date)
       AND (CODIGO = @PCODIGO OR @PCODIGO = 0)
      OPEN C_ACOES
     FETCH NEXT FROM C_ACOES
      INTO @VCODIGO, @VTIPO_PESQUISA, @VVALIDADE_INICIAL, @VVALIDADE_FINAL, @VTIPO_RECORRENCIA, @VTEMPO_RESPOSTA, @VPERIODICIDADE, @VDIAS_SEMANA, @VPERIODO
     WHILE @@FETCH_STATUS = 0
    BEGIN
      -- ENCONTRA TODOS OS USUARIOS PARA QUEM AS PESQUISAS DEVEM SER CADASTRADAS
      DECLARE C_USUARIOS CURSOR
      FOR SELECT USU.USUARIO
            FROM DB_PESQ_APLICADAS_PROMOTORES PESQ_USU,
                 DB_PESQ_APLICADAS PA,
                 DB_USUARIO        USU
           WHERE PESQ_USU.CODIGO     = @VCODIGO
             AND PA.CODIGO           = PESQ_USU.CODIGO
             AND PA.SELECAO_PROMOTOR = 1  -- 1 - SELECAO POR USUARIO OU GRUPO_USUARIO
             AND ((PESQ_USU.USUARIO = USU.USUARIO AND PESQ_USU.USUARIO IS NOT NULL)
                  OR PESQ_USU.GRUPO_USUARIO = USU.GRUPO_USUARIO AND PESQ_USU.GRUPO_USUARIO IS NOT NULL AND PESQ_USU.USUARIO IS NULL)
          UNION  -- ALL ***** AVALIAR SE DEVE SER UNION ALL MESMO *****
          SELECT USU.USUARIO
            FROM DB_ESTRUT_VENDA   X,
                 DB_ESTRUT_VENDA   Y,
                 DB_ESTRUT_REGRA   Z,
                 DB_ESTRUT_REGRA   Z1,
                 DB_USUARIO        USU,
                 DB_PESQ_APLICADAS_PROMOTORES PESQ_USU,
                 DB_PESQ_APLICADAS PA
           WHERE X.DB_EVDA_ESTRUTURA  = Y.DB_EVDA_ESTRUTURA
             AND Y.DB_EVDA_CODIGO     LIKE (X.DB_EVDA_CODIGO + '%')
             AND X.DB_EVDA_ESTRUTURA  = Z.DB_EREG_ESTRUTURA
             AND Y.DB_EVDA_ID         = Z.DB_EREG_ID
             AND X.DB_EVDA_ESTRUTURA  = Z1.DB_EREG_ESTRUTURA
             AND X.DB_EVDA_ID         = Z1.DB_EREG_ID
--             AND Z.DB_EREG_SEQ        = 1
             AND Z1.DB_EREG_ESTRUTURA = PESQ_USU.ESTRUTURA
             AND Z1.DB_EREG_ID        = PESQ_USU.REPRESENTANTE
             AND USU.CODIGO_ACESSO    = Z.DB_EREG_REPRES
             AND PESQ_USU.CODIGO      = @VCODIGO
             AND PA.SELECAO_PROMOTOR  = 2  -- SELECAO POR ESTRUTURA
             AND PA.CODIGO            = PESQ_USU.CODIGO
            OPEN C_USUARIOS
           FETCH NEXT FROM C_USUARIOS
            INTO @VUSUARIO
           WHILE @@FETCH_STATUS = 0
          BEGIN
            -- PESQUISAS AGENDADAS
            IF @VTIPO_PESQUISA = 1
            BEGIN
               -- ELIMINA E INSERE AS INFORMACOES DAS TEMPORARIAS
               DELETE FROM PESQ_APLICADAS_CLIENTES_A_TMP;
               DECLARE C_PESQ CURSOR
               FOR SELECT ID, VALOR
                     FROM DB_PESQ_APLICADAS_CLIENTES
                    WHERE CODIGO = @VCODIGO
                     OPEN C_PESQ
                    FETCH NEXT FROM C_PESQ
                     INTO @VID, @VVALOR
                    WHILE @@FETCH_STATUS = 0
                   BEGIN
                     WHILE CHARINDEX(@SEPARADOR, @VVALOR) > 0
                     BEGIN
                       SET @POS = CHARINDEX(@SEPARADOR,@VVALOR)
                       SET @BUFFER = LEFT(@VVALOR,@POS - 1)
                       SET @VVALOR = RIGHT(@VVALOR,LEN(RTRIM(@VVALOR)) - @POS)
                       SET @BUFFER = REPLACE(@BUFFER, CHAR(254), @SEPARADOR)
                       SET @BUFFER = REPLACE(@BUFFER, CHAR(253), ';')
                       INSERT INTO PESQ_APLICADAS_CLIENTES_A_TMP (CODIGO, ID, VALOR)
                       VALUES (@VCODIGO, @VID, @BUFFER)
                   END
                   IF @VVALOR <> ''
                   BEGIN
                      SET @BUFFER = REPLACE(@VVALOR,@SEPARADOR,'')
                      INSERT INTO PESQ_APLICADAS_CLIENTES_A_TMP (CODIGO, ID, VALOR)
                      VALUES (@VCODIGO, @VID, @BUFFER)
                   END
                    FETCH NEXT FROM C_PESQ
                     INTO @VID, @VVALOR
                   END
                    CLOSE C_PESQ
               DEALLOCATE C_PESQ
			   EXEC SP_EXECUTESQL N'TRUNCATE TABLE MVA_CLIENTE_ACOES_TMP';
               INSERT INTO MVA_CLIENTE_ACOES_TMP
                 (
                  USUARIO,
                  CODIGO_CLIEN,
                  RAMOATIVIDADE_CLIEN,
                  RAMOATIVIDADEII_CLIEN,
                  AREAATUACAO_CLIEN,
                  CLASSIFICACAOCOMERCIAL_CLIEN,
                  REGIAOCOMERCIAL_CLIEN,
                  ESTADO_CLIEN,
                  CIDADE_CLIEN,
                  VINCULO_CLIEN,
                  CNPJ_CLIEN
                 )
               SELECT USUARIO,
                      CODIGO_CLIEN,
                      RAMOATIVIDADE_CLIEN,
                      RAMOATIVIDADEII_CLIEN,
                      AREAATUACAO_CLIEN,
                      CLASSIFICACAOCOMERCIAL_CLIEN,
                      REGIAOCOMERCIAL_CLIEN,
                      ESTADO_CLIEN,
                      CIDADE_CLIEN,
                      VINCULO_CLIEN,
                      CNPJ_CLIEN
                 FROM MVA_CLIENTE
                WHERE USUARIO = @VUSUARIO
               DECLARE C_CLIENTES CURSOR
               FOR SELECT CODIGO_CLIEN
                     FROM MVA_CLIENTE_ACOES_TMP MCLI
                    WHERE USUARIO = @VUSUARIO
                       -- RAMO DE ATIVIDADE I
                      AND (MCLI.RAMOATIVIDADE_CLIEN IN (SELECT VALOR FROM PESQ_APLICADAS_CLIENTES_A_TMP
                                                         WHERE CODIGO = @VCODIGO
                                                           AND ID     = 'RAMO')
                       OR NOT EXISTS (SELECT 1 FROM DB_PESQ_APLICADAS_CLIENTES
                                       WHERE CODIGO = @VCODIGO
                                         AND ID     = 'RAMO')
                          )
                       -- RAMO DE ATIVIDADE II
                      AND (MCLI.RAMOATIVIDADEII_CLIEN IN (SELECT VALOR FROM PESQ_APLICADAS_CLIENTES_A_TMP
                                                           WHERE CODIGO = @VCODIGO
                                                             AND ID     = 'RAMOII')
                       OR NOT EXISTS (SELECT 1 FROM DB_PESQ_APLICADAS_CLIENTES
                                       WHERE CODIGO = @VCODIGO
                                         AND ID     = 'RAMOII')
                          )
                       -- AREA DE ATUACAO
                      AND (MCLI.AREAATUACAO_CLIEN IN (SELECT VALOR FROM PESQ_APLICADAS_CLIENTES_A_TMP
                                                       WHERE CODIGO = @VCODIGO
                                                         AND ID     = 'AREAATU')
                       OR NOT EXISTS (SELECT 1 FROM DB_PESQ_APLICADAS_CLIENTES
                                       WHERE CODIGO = @VCODIGO
                                         AND ID     = 'AREAATU')
                          )
                       -- CLASSIFICACAO COMERCIAL CLIENTE
                      AND (MCLI.CLASSIFICACAOCOMERCIAL_CLIEN IN (SELECT VALOR FROM PESQ_APLICADAS_CLIENTES_A_TMP
                                                                  WHERE CODIGO = @VCODIGO
                                                                    AND ID     = 'CLASCOMCLI')
                       OR NOT EXISTS (SELECT 1 FROM DB_PESQ_APLICADAS_CLIENTES
                                       WHERE CODIGO = @VCODIGO
                                         AND ID     = 'CLASCOMCLI')
                          )
                       -- REGIAO COMERCIAL
                      AND (MCLI.REGIAOCOMERCIAL_CLIEN IN (SELECT VALOR FROM PESQ_APLICADAS_CLIENTES_A_TMP
                                                           WHERE CODIGO = @VCODIGO
                                                             AND ID     = 'REGIAOCOM')
                       OR NOT EXISTS (SELECT 1 FROM DB_PESQ_APLICADAS_CLIENTES
                                       WHERE CODIGO = @VCODIGO
                                         AND ID     = 'REGIAOCOM')
                          )
                       -- ESTADO
                      AND (MCLI.ESTADO_CLIEN IN (SELECT VALOR FROM PESQ_APLICADAS_CLIENTES_A_TMP
                                                  WHERE CODIGO = @VCODIGO
                                                    AND ID     = 'ESTADO')
                       OR NOT EXISTS (SELECT 1 FROM DB_PESQ_APLICADAS_CLIENTES
                                       WHERE CODIGO = @VCODIGO
                                         AND ID     = 'ESTADO')
                          )
                       -- CIDADE
                      AND (MCLI.CIDADE_CLIEN IN (SELECT VALOR FROM PESQ_APLICADAS_CLIENTES_A_TMP
                                                  WHERE CODIGO = @VCODIGO
                                                    AND ID     = 'CIDADE')
                       OR NOT EXISTS (SELECT 1 FROM DB_PESQ_APLICADAS_CLIENTES
                                       WHERE CODIGO = @VCODIGO
                                         AND ID     = 'CIDADE')
                          )
                       -- CLIENTE
                      AND (CAST(MCLI.CODIGO_CLIEN AS VARCHAR) IN (SELECT VALOR FROM PESQ_APLICADAS_CLIENTES_A_TMP
                                                                   WHERE CODIGO = @VCODIGO
                                                                     AND ID     = 'CLIENTE')
                       OR NOT EXISTS (SELECT 1 FROM DB_PESQ_APLICADAS_CLIENTES
                                       WHERE CODIGO = @VCODIGO
                                         AND ID     = 'CLIENTE')
                          )
                       -- RAIZ CNPJ
                      AND (CAST(SUBSTRING(MCLI.CNPJ_CLIEN,1,8) AS VARCHAR) IN (SELECT SUBSTRING(VALOR,1,8) FROM PESQ_APLICADAS_CLIENTES_A_TMP
                                                                                WHERE CODIGO = @VCODIGO
                                                                                  AND ID     = 'CNPJ')
                       OR NOT EXISTS (SELECT 1 FROM DB_PESQ_APLICADAS_CLIENTES
                                       WHERE CODIGO = @VCODIGO
                                         AND ID     = 'CNPJ')
                          )
                       -- VINCULO - REDE
                      AND (CAST(MCLI.VINCULO_CLIEN AS VARCHAR) IN (SELECT VALOR FROM PESQ_APLICADAS_CLIENTES_A_TMP
                                                                    WHERE CODIGO = @VCODIGO
                                                                      AND ID     = 'REDE')
                       OR NOT EXISTS (SELECT 1 FROM DB_PESQ_APLICADAS_CLIENTES
                                       WHERE CODIGO = @VCODIGO
                                         AND ID     = 'REDE')
                          )
                     OPEN C_CLIENTES
                    FETCH NEXT FROM C_CLIENTES
                     INTO @VCODIGO_CLIEN
                    WHILE @@FETCH_STATUS = 0
                   BEGIN
                     -- VALIDA OS ATRIBUTOS
                     SET @VATRIBUTO = 1
                     DECLARE C_ATRIB CURSOR
                     FOR SELECT DISTINCT CODIGO,
                                         ID,
                                         SUBSTRING(ID, 4, LEN(ID) - 1)
                           FROM PESQ_APLICADAS_CLIENTES_A_TMP
                          WHERE CODIGO = @VCODIGO
                            AND ID     LIKE 'ATC%'
                           OPEN C_ATRIB
                          FETCH NEXT FROM C_ATRIB
                           INTO @VCODIGO, @VID, @VCOD_ATRIB
                          WHILE @@FETCH_STATUS = 0 AND @VATRIBUTO = 1  -- SE ALGUM ATRIBUTO NAO ESTA PARAMETRIZADO PARA O CLIENTE DEVE SAIR DO LACO E O REGISTRO NAO EH VALIDO
                         BEGIN
                           SET @VATRIBUTO = 0
                           SELECT @VATRIBUTO = 1
                             FROM DB_CLIENTE_ATRIB
                            WHERE DB_CLIA_CODIGO  = @VCODIGO_CLIEN
                              AND DB_CLIA_ATRIB   = @VCOD_ATRIB
                              AND DB_CLIA_VALOR  IN (SELECT PESQ_TMP.VALOR
                                                       FROM PESQ_APLICADAS_CLIENTES_A_TMP PESQ_TMP
                                                      WHERE PESQ_TMP.CODIGO = @VCODIGO
                                                        AND PESQ_TMP.ID     = @VID)
                          FETCH NEXT FROM C_ATRIB
                           INTO @VCODIGO, @VID, @VCOD_ATRIB
                         END
                          CLOSE C_ATRIB
                     DEALLOCATE C_ATRIB
                     IF @VATRIBUTO = 1
                     BEGIN
                        -- ENCONTRA AS ROTAS DOS CLIENTES
                        SET @VENCONTROU_ROTA = 0
                        DECLARE C_ROTAS CURSOR
                        FOR SELECT CLIENTE, DATA
                              FROM DB_ROTAS_CLIENTES
                             WHERE USUARIO  = @VUSUARIO
                               AND CLIENTE  = @VCODIGO_CLIEN
                               AND DATA    >= @VVALIDADE_INICIAL
							   AND isnull(EXCLUIDO, 0) <> 1
                               AND DATA    BETWEEN CONVERT(VARCHAR(25), GETDATE(), 23)                    -- BUSCA AS DATAS QUE O CLIENTE SERA ATENDIDO NO INTERVALO
                                               AND CONVERT(VARCHAR(25), GETDATE() + 7, 23)  -- DE EXECUCAO DA ROTINA
                             ORDER BY CLIENTE, DATA
                              OPEN C_ROTAS
                             FETCH NEXT FROM C_ROTAS
                              INTO @VCLIENTE, @VDATA
                             WHILE @@FETCH_STATUS = 0
                            BEGIN
                              SET @VENCONTROU_ROTA = 1
                              IF @VTIPO_RECORRENCIA = 0  -- SEM RECORRENCIA
                              BEGIN
                                 -- SOMENTE INSERE 1 REGISTRO POR CLIENTE
                                 IF ISNULL(@VCLIENTE_OLD, 0) <> @VCLIENTE
                                 BEGIN
                                    SET @VCLIENTE_OLD = @VCLIENTE
                                    -- VERIFICA SE A ACAO JA FOI CRIADA PARA O USUARIO E CLIENTE. SE JA CRIOU NAO DEVE CRIAR UM NOVO REGISTRO
                                    -- POIS A ACAO EH SEM RECORRENCIA
                                    SET @VEXISTE_ACAO_CLIENTE = 0
                                    SELECT @VEXISTE_ACAO_CLIENTE = 1
                                      FROM DB_ACOES
                                     WHERE USUARIO          = @VUSUARIO
                                       AND CLIENTE          = @VCLIENTE
                                       AND APLICAR_PESQUISA = @VCODIGO;
                                    IF @VEXISTE_ACAO_CLIENTE = 0
                                    BEGIN
                                       -- A DATA FINAL DA AÇÃO NÃO DEVE SER MAIOR QUE A VALIDADE DA PESQUISA
                                       SET @VDATA_FINAL = CASE WHEN @VDATA + @VTEMPO_RESPOSTA - 1 > @VVALIDADE_FINAL
                                                               THEN @VVALIDADE_FINAL
                                                               ELSE @VDATA + @VTEMPO_RESPOSTA - 1
                                                          END
                                       -- INSERE ACAO
                                       --SELECT @VSEQ_CODIGO = NEXT VALUE FOR SEQ_DB_ACOES
									   SELECT @VSEQ_CODIGO = ISNULL(MAX(CODIGO), 0) + 1
									     FROM DB_ACOES
                                       MERGE DB_ACOES
                                       USING (SELECT @VUSUARIO    AS MRG_USUARIO,
                                                     @VCLIENTE    AS MRG_CLIENTE,
                                                     @VCODIGO     AS MRG_CODIGO,
                                                     @VDATA       AS MRG_DATA,
                                                     @VDATA_FINAL AS MRG_DATA_FINAL,
                                                     @VSEQ_CODIGO AS MRG_SEQ_CODIGO
                                             ) AS SOURCE
                                          ON (    USUARIO          = SOURCE.MRG_USUARIO
                                              AND CLIENTE          = SOURCE.MRG_CLIENTE
                                              AND APLICAR_PESQUISA = SOURCE.MRG_CODIGO
                                              AND DATA_INICIAL     = SOURCE.MRG_DATA
                                             )
                                        WHEN MATCHED THEN
                                             UPDATE SET PROCESSADO_ROTINA = 1,
                                                        DATA_FINAL        = SOURCE.MRG_DATA_FINAL
                                        WHEN NOT MATCHED THEN
                                             INSERT
                                               (
                                                CODIGO,            -- 01
                                                USUARIO,           -- 02
                                                CLIENTE,           -- 03
                                                APLICAR_PESQUISA,  -- 04
                                                DATA_INICIAL,      -- 05
                                                DATA_FINAL,        -- 06
                                                SITUACAO,          -- 07
                                                DATA_SITUACAO,     -- 08
                                                PROCESSADO_ROTINA  -- 09
                                               )
                                             VALUES
                                               (
                                                SOURCE.MRG_SEQ_CODIGO,  -- 01
                                                SOURCE.MRG_USUARIO,     -- 02
                                                SOURCE.MRG_CLIENTE,     -- 03
                                                SOURCE.MRG_CODIGO,      -- 04
                                                SOURCE.MRG_DATA,        -- 05
                                                SOURCE.MRG_DATA_FINAL,  -- 06
                                                0,                      -- 07
                                                GETDATE(),              -- 08
                                                1                       -- 09
                                               );
                                       -- FIM INSERE ACAO
                                    END
                                    ELSE
                                    BEGIN
                                       -- SE EXISTE A ACAO DEVE APENASR UPDATAR O PROCESSADO_ROTINA
                                       UPDATE DB_ACOES
                                          SET PROCESSADO_ROTINA = 1
                                        WHERE USUARIO          = @VUSUARIO
                                          AND CLIENTE          = @VCLIENTE
                                          AND APLICAR_PESQUISA = @VCODIGO;
                                    END  -- IF @VEXISTE_ACAO_CLIENTE = 0
                                 END  -- IF ISNULL(@VCLIENTE_OLD, 0) <> @VCLIENTE
                              END
                              ELSE IF @VTIPO_RECORRENCIA = 1  -- DIARIA
                              BEGIN
                                 -- O RETORNO DE ((DATA DA AÇÃO – DATA INICIAL DE VALIDADE DA PESQUISA) / PERIODICIDADE) DEVE SER IGUAL A ZERO
                                 IF DATEDIFF(DAY, @VDATA, @VVALIDADE_INICIAL) % @VPERIODICIDADE = 0
								 BEGIN
                                    -- A DATA FINAL DA ACAO NAO DEVE SER MAIOR QUE A VALIDADE DA PESQUISA
                                    SET @VDATA_FINAL = CASE WHEN @VDATA + @VTEMPO_RESPOSTA - 1 > @VVALIDADE_FINAL
                                                            THEN @VVALIDADE_FINAL
                                                            ELSE @VDATA + @VTEMPO_RESPOSTA - 1
                                                       END
                                    -- INSERE ACAO
                                    --SELECT @VSEQ_CODIGO = NEXT VALUE FOR SEQ_DB_ACOES
								    SELECT @VSEQ_CODIGO = ISNULL(MAX(CODIGO), 0) + 1
									  FROM DB_ACOES
                                    MERGE DB_ACOES
                                    USING (SELECT @VUSUARIO    AS MRG_USUARIO,
                                                  @VCLIENTE    AS MRG_CLIENTE,
                                                  @VCODIGO     AS MRG_CODIGO,
                                                  @VDATA       AS MRG_DATA,
                                                  @VDATA_FINAL AS MRG_DATA_FINAL,
                                                  @VSEQ_CODIGO AS MRG_SEQ_CODIGO
                                          ) AS SOURCE
                                       ON (    USUARIO          = SOURCE.MRG_USUARIO
                                           AND CLIENTE          = SOURCE.MRG_CLIENTE
                                           AND APLICAR_PESQUISA = SOURCE.MRG_CODIGO
                                           AND DATA_INICIAL     = SOURCE.MRG_DATA
                                          )
                                     WHEN MATCHED THEN
                                          UPDATE SET PROCESSADO_ROTINA = 1,
                                                     DATA_FINAL        = SOURCE.MRG_DATA_FINAL
                                     WHEN NOT MATCHED THEN
                                          INSERT
                                            (
                                             CODIGO,            -- 01
                                             USUARIO,           -- 02
                                             CLIENTE,           -- 03
                                             APLICAR_PESQUISA,  -- 04
                                             DATA_INICIAL,      -- 05
                                             DATA_FINAL,        -- 06
                                             SITUACAO,          -- 07
                                             DATA_SITUACAO,     -- 08
                                             PROCESSADO_ROTINA  -- 09
                                            )
                                          VALUES
                                            (
                                             SOURCE.MRG_SEQ_CODIGO,  -- 01
                                             SOURCE.MRG_USUARIO,     -- 02
                                             SOURCE.MRG_CLIENTE,     -- 03
                                             SOURCE.MRG_CODIGO,      -- 04
                                             SOURCE.MRG_DATA,        -- 05
                                             SOURCE.MRG_DATA_FINAL,  -- 06
                                             0,                      -- 07
                                             GETDATE(),              -- 08
                                             1                       -- 09
                                            );
                                    -- FIM INSERE ACAO
                                 END  -- IF DATEDIFF(DAY, @VDATA, @VVALIDADE_INICIAL) % @VPERIODICIDADE = 0
                              END
                              ELSE IF @VTIPO_RECORRENCIA = 2  -- SEMANAL
                              BEGIN
                                 -- @VDIAS_SEMANA POSSUI = 1-SEGUNDA-FEIRA, 2-TERÇA-FEIRA, 3-QUARTA-FEIRA, 4-QUINTA-FEIRA, 5-SEXTA-FEIRA, 6-SÁBADO E 7-DOMINGO
                                 SET @VDIASEMANA = CASE DATEPART(DW, @VDATA) WHEN 1 THEN 7
                                                                             WHEN 2 THEN 1
                                                                             WHEN 3 THEN 2
                                                                             WHEN 4 THEN 3
                                                                             WHEN 5 THEN 4
                                                                             WHEN 6 THEN 5
                                                                             WHEN 7 THEN 6
                                                   END
                                 IF CHARINDEX(CAST(@VDIASEMANA AS VARCHAR), @VDIAS_SEMANA) > 0
                                 BEGIN
                                    -- ENCONTRA O PROXIMO DIA DA SEMANA VALIDO PARA SE TORNAR A DATA INICIAL
                                    -- EX.: SE ESTA PROCESSANDO SEGUNDA, ENCONTRA A PROXIMA SEGUNDA, SE TERCA, ENCONTRA A PROXIMA TERCA...
                                    SET @VDATA_PRIMEIRO_DIA_SEMANA = @VVALIDADE_INICIAL;
                                    WHILE DATEPART(DW, @VDATA_PRIMEIRO_DIA_SEMANA) <> DATEPART(DW, @VDATA)
                                    BEGIN
                                      SET @VDATA_PRIMEIRO_DIA_SEMANA = @VDATA_PRIMEIRO_DIA_SEMANA + 1;
                                    END
                                    -- CFME ANALISE TECNICA
                                    -- DATA_PRIMEIRO_DIA_SEMANA = SISTEMA DEVERA IDENTIFICAR A PRIMEIRA DATA CORRESPONDENTE AO PRIMEIRO DIA DA SEMANA DENTRO DO PERÍODO DE VALIDADE DA PESQUISA.
                                    -- DIFERENCA = (DATA DA ACAO -  DATA_PRIMEIRO_DIA_SEMANA) / PERIODICIDADE
                                    -- SE DIFERENCA FOR UM NUMERO INTEIRO A ACAO DEVERA SER GERADA.
                                    IF DATEDIFF(DAY, @VDATA, @VDATA_PRIMEIRO_DIA_SEMANA) % @VPERIODICIDADE = 0
                                    BEGIN
                                       -- A DATA FINAL DA ACAO NAO DEVE SER MAIOR QUE A VALIDADE DA PESQUISA
                                       SET @VDATA_FINAL = CASE WHEN @VDATA + @VTEMPO_RESPOSTA - 1 > @VVALIDADE_FINAL
                                                               THEN @VVALIDADE_FINAL
                                                               ELSE @VDATA + @VTEMPO_RESPOSTA - 1
                                                          END
                                       -- INSERE ACAO
                                       --SELECT @VSEQ_CODIGO = NEXT VALUE FOR SEQ_DB_ACOES
									   SELECT @VSEQ_CODIGO = ISNULL(MAX(CODIGO), 0) + 1
									     FROM DB_ACOES
                                       MERGE DB_ACOES
                                       USING (SELECT @VUSUARIO    AS MRG_USUARIO,
                                                     @VCLIENTE    AS MRG_CLIENTE,
                                                     @VCODIGO     AS MRG_CODIGO,
                                                     @VDATA       AS MRG_DATA,
                                                     @VDATA_FINAL AS MRG_DATA_FINAL,
                                                     @VSEQ_CODIGO AS MRG_SEQ_CODIGO
                                             ) AS SOURCE
                                          ON (    USUARIO          = SOURCE.MRG_USUARIO
                                              AND CLIENTE          = SOURCE.MRG_CLIENTE
                                              AND APLICAR_PESQUISA = SOURCE.MRG_CODIGO
                                              AND DATA_INICIAL     = SOURCE.MRG_DATA
                                             )
                                        WHEN MATCHED THEN
                                             UPDATE SET PROCESSADO_ROTINA = 1,
                                                        DATA_FINAL        = SOURCE.MRG_DATA_FINAL
                                        WHEN NOT MATCHED THEN
                                             INSERT
                                               (
                                                CODIGO,            -- 01
                                                USUARIO,           -- 02
                                                CLIENTE,           -- 03
                                                APLICAR_PESQUISA,  -- 04
                                                DATA_INICIAL,      -- 05
                                                DATA_FINAL,        -- 06
                                                SITUACAO,          -- 07
                                                DATA_SITUACAO,     -- 08
                                                PROCESSADO_ROTINA  -- 09
                                               )
                                             VALUES
                                               (
                                                SOURCE.MRG_SEQ_CODIGO,  -- 01
                                                SOURCE.MRG_USUARIO,     -- 02
                                                SOURCE.MRG_CLIENTE,     -- 03
                                                SOURCE.MRG_CODIGO,      -- 04
                                                SOURCE.MRG_DATA,        -- 05
                                                SOURCE.MRG_DATA_FINAL,  -- 06
                                                0,                      -- 07
                                                GETDATE(),              -- 08
                                                1                       -- 09
                                               );
                                       -- FIM INSERE ACAO
                                    END  -- IF DATEDIFF(DAY, @VDATA, @VDATA_PRIMEIRO_DIA_SEMANA) % @VPERIODICIDADE = 0
                                 END  -- IF CHARINDEX(CAST(@VDIASEMANA AS VARCHAR), @VDIAS_SEMANA) > 0
                              END
                              ELSE IF @VTIPO_RECORRENCIA = 3  -- PERIODO
                              BEGIN
                                 SET @VEXISTE_PERIODO = 0
                                 SELECT @VEXISTE_PERIODO = 1
                                   FROM DB_PERIODOS_TEMPO
                                  WHERE CODIGO = @VPERIODO
                                    AND DATA   = @VDATA
                                 IF @VEXISTE_PERIODO = 1
                                 BEGIN
                                    -- A DATA FINAL DA ACAO NAO DEVE SER MAIOR QUE A VALIDADE DA PESQUISA
                                    SET @VDATA_FINAL = CASE WHEN @VDATA + @VTEMPO_RESPOSTA - 1 > @VVALIDADE_FINAL
                                                            THEN @VVALIDADE_FINAL
                                                            ELSE @VDATA + @VTEMPO_RESPOSTA - 1
                                                       END
                                    -- INSERE ACAO
                                    --SELECT @VSEQ_CODIGO = NEXT VALUE FOR SEQ_DB_ACOES
								    SELECT @VSEQ_CODIGO = ISNULL(MAX(CODIGO), 0) + 1
									  FROM DB_ACOES
                                    MERGE DB_ACOES
                                    USING (SELECT @VUSUARIO    AS MRG_USUARIO,
                                                  @VCLIENTE    AS MRG_CLIENTE,
                                                  @VCODIGO     AS MRG_CODIGO,
                                                  @VDATA       AS MRG_DATA,
                                                  @VDATA_FINAL AS MRG_DATA_FINAL,
                                                  @VSEQ_CODIGO AS MRG_SEQ_CODIGO
                                          ) AS SOURCE
                                       ON (    USUARIO          = SOURCE.MRG_USUARIO
                                           AND CLIENTE          = SOURCE.MRG_CLIENTE
                                           AND APLICAR_PESQUISA = SOURCE.MRG_CODIGO
                                           AND DATA_INICIAL     = SOURCE.MRG_DATA
                                          )
                                     WHEN MATCHED THEN
                                          UPDATE SET PROCESSADO_ROTINA = 1,
                                                     DATA_FINAL        = SOURCE.MRG_DATA_FINAL
                                     WHEN NOT MATCHED THEN
                                          INSERT
                                            (
                                             CODIGO,            -- 01
                                             USUARIO,           -- 02
                                             CLIENTE,           -- 03
                                             APLICAR_PESQUISA,  -- 04
                                             DATA_INICIAL,      -- 05
                                             DATA_FINAL,        -- 06
                                             SITUACAO,          -- 07
                                             DATA_SITUACAO,     -- 08
                                             PROCESSADO_ROTINA  -- 09
                                            )
                                          VALUES
                                            (
                                             SOURCE.MRG_SEQ_CODIGO,  -- 01
                                             SOURCE.MRG_USUARIO,     -- 02
                                             SOURCE.MRG_CLIENTE,     -- 03
                                             SOURCE.MRG_CODIGO,      -- 04
                                             SOURCE.MRG_DATA,        -- 05
                                             SOURCE.MRG_DATA_FINAL,  -- 06
                                             0,                      -- 07
                                             GETDATE(),              -- 08
                                             1                       -- 09
                                            );
                                    -- FIM INSERE ACAO
                                 END  -- IF @VEXISTE_PERIODO = 1
                              END  -- IF @VTIPO_RECORRENCIA = 0
                             FETCH NEXT FROM C_ROTAS
                              INTO @VCLIENTE, @VDATA
                            END
                             CLOSE C_ROTAS
                        DEALLOCATE C_ROTAS
                        -- SE NAO ENCONTROU O CLIENTE NA ROTA DO USUARIO DEVE GRAVAR ACAO COM DATA INICIAL E FINAL IGUAL A PESQUISA
                        IF @VENCONTROU_ROTA = 0
                        BEGIN
IF ISNULL(@VCODIGO_CLIEN,'') <> ''  -- TESTE PROVISORIO
BEGIN
   --PRINT('@VUSUARIO: ' + CAST(@VUSUARIO AS VARCHAR))
   --PRINT('@VCLIENTE: ' + CAST(@VCLIENTE AS VARCHAR))
   --PRINT('@VCODIGO: ' + CAST(@VCODIGO AS VARCHAR))
   --PRINT('@VVALIDADE_INICIAL: ' + CAST(@VVALIDADE_INICIAL AS VARCHAR))
   --PRINT('@VVALIDADE_FINAL: ' + CAST(@VVALIDADE_FINAL AS VARCHAR))
   --PRINT('@VSEQ_CODIGO: ' + CAST(@VSEQ_CODIGO AS VARCHAR))
                           -- INSERE ACAO
                           --SELECT @VSEQ_CODIGO = NEXT VALUE FOR SEQ_DB_ACOES
						   SELECT @VSEQ_CODIGO = ISNULL(MAX(CODIGO), 0) + 1
							 FROM DB_ACOES
                           MERGE DB_ACOES
                           USING (SELECT @VUSUARIO          AS MRG_USUARIO,
                                         @VCODIGO_CLIEN          AS MRG_CLIENTE,
                                         @VCODIGO           AS MRG_CODIGO,
                                         @VVALIDADE_INICIAL AS MRG_DATA,
                                         @VVALIDADE_FINAL   AS MRG_DATA_FINAL,
                                         @VSEQ_CODIGO       AS MRG_SEQ_CODIGO
                                 ) AS SOURCE
                              ON (    USUARIO          = SOURCE.MRG_USUARIO
                                  AND CLIENTE          = SOURCE.MRG_CLIENTE
                                  AND APLICAR_PESQUISA = SOURCE.MRG_CODIGO
                                  AND DATA_INICIAL     = SOURCE.MRG_DATA
                                 )
                            WHEN MATCHED THEN
                                 UPDATE SET PROCESSADO_ROTINA = 1,
                                            DATA_FINAL        = SOURCE.MRG_DATA_FINAL
                            WHEN NOT MATCHED THEN
                                 INSERT
                                   (
                                    CODIGO,            -- 01
                                    USUARIO,           -- 02
                                    CLIENTE,           -- 03
                                    APLICAR_PESQUISA,  -- 04
                                    DATA_INICIAL,      -- 05
                                    DATA_FINAL,        -- 06
                                    SITUACAO,          -- 07
                                    DATA_SITUACAO,     -- 08
                                    PROCESSADO_ROTINA  -- 09
                                   )
                                 VALUES
                                   (
                                    SOURCE.MRG_SEQ_CODIGO,  -- 01
                                    SOURCE.MRG_USUARIO,     -- 02
                                    SOURCE.MRG_CLIENTE,     -- 03
                                    SOURCE.MRG_CODIGO,      -- 04
                                    SOURCE.MRG_DATA,        -- 05
                                    SOURCE.MRG_DATA_FINAL,  -- 06
                                    0,                      -- 07
                                    GETDATE(),              -- 08
                                    1                       -- 09
                                   );
                           -- FIM INSERE ACAO
END
                        END  -- IF @VENCONTROU_ROTA = 0
                     END  -- IF @VATRIBUTO = 1
                    FETCH NEXT FROM C_CLIENTES
                     INTO @VCODIGO_CLIEN
                   END
                    CLOSE C_CLIENTES
               DEALLOCATE C_CLIENTES
            -- PESQUISAS OCORRENCIAS
			END
            ELSE IF @VTIPO_PESQUISA = 2 OR @VTIPO_PESQUISA = 3
			BEGIN
				IF @V_DELETE_OCORRENCIAS = 0
				BEGIN
					IF @PCODIGO = 0
					BEGIN					          
						DELETE FROM DB_PESQ_OCORRENCIAS;
						SET @V_DELETE_OCORRENCIAS = 1;
					END
					ELSE
					BEGIN
						DELETE FROM DB_PESQ_OCORRENCIAS
						 WHERE APLICAR_PESQUISA = @PCODIGO;   
						SET @V_DELETE_OCORRENCIAS = 1;
					END
				END
               --SELECT @VSEQ_CODIGO = NEXT VALUE FOR SEQ_DB_PESQ_OCORRENCIAS
			   SELECT @VSEQ_CODIGO = ISNULL(MAX(CODIGO), 0) + 1
				 FROM DB_PESQ_OCORRENCIAS
               MERGE DB_PESQ_OCORRENCIAS
               USING (SELECT @VUSUARIO          AS MRG_USUARIO,
                             @VCODIGO           AS MRG_CODIGO,
                             @VVALIDADE_INICIAL AS MRG_DATA,
                             @VVALIDADE_FINAL   AS MRG_DATA_FINAL,
                             @VSEQ_CODIGO       AS MRG_SEQ_CODIGO
                     ) AS SOURCE
                  ON (APLICAR_PESQUISA = SOURCE.MRG_CODIGO AND USUARIO = SOURCE.MRG_USUARIO)
                WHEN NOT MATCHED THEN
                     INSERT
                       (
                        CODIGO,            -- 01
                        APLICAR_PESQUISA,  -- 02
                        USUARIO,           -- 03
                        DATA_INICIAL,      -- 04
                        DATA_FINAL         -- 05
                       )
                     VALUES
                       (
                        SOURCE.MRG_SEQ_CODIGO,  -- 01
                        SOURCE.MRG_CODIGO,      -- 02
                        SOURCE.MRG_USUARIO,     -- 03
                        SOURCE.MRG_DATA,        -- 04
                        SOURCE.MRG_DATA_FINAL   -- 05
                       );
            END  -- IF @VTIPO_PESQUISA = 1
           FETCH NEXT FROM C_USUARIOS
            INTO @VUSUARIO
          END
           CLOSE C_USUARIOS
      DEALLOCATE C_USUARIOS
     FETCH NEXT FROM C_ACOES
      INTO @VCODIGO, @VTIPO_PESQUISA, @VVALIDADE_INICIAL, @VVALIDADE_FINAL, @VTIPO_RECORRENCIA, @VTEMPO_RESPOSTA, @VPERIODICIDADE, @VDIAS_SEMANA, @VPERIODO
    END
     CLOSE C_ACOES
DEALLOCATE C_ACOES
-- NO FINAL DO PROCESSO, DEVE ELIMINAR OS REGISTROS QUE NAO FORAM ATUALIZADOS PELA ROTINA
-- DEVE ELIMINAR TODAS AS ACOES NAO PROCESSADAS PELA ROTINA MAIORES OU IGUAL AO DIA DE HOJE
DELETE DB_ACOES
 WHERE SITUACAO          = 0
   AND PROCESSADO_ROTINA = 0
   AND (APLICAR_PESQUISA = @PCODIGO OR @PCODIGO = 0)
----------------------------------------------------------------------
--- 79882 - Avaliar expurgo/deleção de registros da tabela de Ações do módulo de TradeMarketing
---         Eliminar acoes com base no parametro ACAO_DIASPARAEXPURGO
SET @V_DIASPARAEXPURGO = 1  
select @V_DIASPARAEXPURGO = db_prms_valor
  from db_param_sistema
 where db_prms_id = 'ACAO_DIASPARAEXPURGO'
IF ISNULL(@V_DIASPARAEXPURGO, 0) <> 0 
BEGIN
    DELETE DB_ACOES
    WHERE DATA_FINAL < cast(GETDATE() - @V_DIASPARAEXPURGO as date);
END;
---  FIM 79882 Eliminar acoes com base no parametro ACAO_DIASPARAEXPURGO  
----------------------------------------------------------------------
