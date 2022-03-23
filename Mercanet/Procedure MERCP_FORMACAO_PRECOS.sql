SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_FORMACAO_PRECOS] AS
BEGIN

-- Cria sinonimos para os caminhos/nomes das tabelas, de modo que possa ser usada a mesma
-- rotina de integracao, mas acessando o database correto cfe. cada ambiente.
EXEC MERCP_CRIA_SINONIMOS_TABELAS;

DECLARE @VDATA            DATETIME;
DECLARE @VERRO            VARCHAR(1000) = '';
DECLARE @VOBJETO                VARCHAR(200) = 'MERCP_FORMACAO_PRECOS';

DECLARE @VDB_CLI_CODIGO             FLOAT
      , @VDB_CLI_NOME               VARCHAR(40)
    , @VCONTROLE                  FLOAT
    , @VSEQ                       FLOAT
    , @VIDENT                     VARCHAR(1024)
    , @VPOLITICA                  VARCHAR(4)
    , @VPOLITICA_INI              VARCHAR(4)
    , @VPOLITICA_FIM              VARCHAR(4)
    , @VPROXREGRA                 NUMERIC
    , @VCODCLI_ANTERIOR           VARCHAR(6)
    , @VPERC_MERCANET             FLOAT
    , @VPROX_LUCRATIV             NUMERIC
    , @VPROXSEQ_LUCRATIV          NUMERIC
    , @VLUCRATIV_INI              NUMERIC
    , @VLUCRATIV_FIM              NUMERIC
    , @VDB_CLIE_SEQ               INT
    , @V_NRO_REGRAS_POL           INT;

DECLARE @VCODCLI    VARCHAR(6),
    @VCODPRO        VARCHAR(16),
    @VCUSTOPRO      FLOAT,
    @VMARGEM        FLOAT,
    @VRAPEL         FLOAT,
    @VPFRETE        FLOAT,
    @VPERTOT        FLOAT,
    @VMARGEM_BLQ    FLOAT,
	@VNOMECLI		VARCHAR(50),
	@VPRODUTO		VARCHAR(15);

DECLARE @VFATOR_INI     INT
    , @VFATOR_FIM     INT
    , @VCODIGO   FLOAT


----------------------------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR          ALTERACAO
---  1.00001  11/05/2012  ALENCAR        ROTINA CRIADA PARA GERAR CONDICOES DE VENDA PARA A FORMACAO DE PRECOS DA NOVA ALIANCA
---                                        ETAPAS EXECUTADAS:
---                                             - Cria uma condicao de venda para cada cliente com todos os produtos ativos
---                                                   Por definicao sera criada a condicao de codigo 5000
---                                             - Cria a lucratividade usando a MARGEM_BLQ. Serão criadas no intervalo de 5000 e 7999
---                                             - Grava o frete na economia do cliente
---                                             - Atualiza os custos do produto
---                                             - Atualiza o fator de lucratividade - rapel - intervalo de codigo de 5000 a 7999
---                                             - Grava backup das informacoes
---  1.00002  01/02/2017  ALENCAR        Inserido filtro de lista de precos 990
---                                      Arrendondamento do percentual de acrescimo em 3 casas decimais
---                                      Gravar a economia (Frete)
---                                      Gravar 100 clientes em cada politica
---  1.00003  03/02/2017 ALENCAR         Alteracao da view VA_PERCOMP para a tabela MER_PERCOMP
---  1.00004  13/02/2017 ALENCAR         Gravar um registro unico na economia por cliente
---  1.00005  16/02/2017 ALENCAR         Gravar o rapel no fator de lucratividade
---                                          Quando cliente possui % unico de rapel grava o fator para o atributo 200 do produto
---                                          Quando cliente possui % diferentes de rapel grava o fator por produto
---  1.00006  30/10/2017 ALENCAR         Criar 3 faixas de conceito de lucratividade:
---                                          de 99999 a 0 = Não Aceita
---                                          de 0,01 a MARGEM_BLQ = Bloqueado
---                                          de @VMARGEM_BLQ a 99999 = Normal
---                                      Retirado os campos não utilizados: COMIS, ICMS, PISCOF, FINAN, COMPOSICAO, PR_PRATICADO
---  1.00007  07/11/2017  ALENCAR        Alterado o intervalo de codigos utilizados
---  1.00008  09/11/2017  ALENCAR        Ajuste ao inserir a chave primaria da DB_CONC_LUCRAT_FX
---  1.00009  11/12/2019  ANDRE			 Ajustada integração DB_LUC_FATOR e DB_LUC_FATOR_PRODUTO
---           23/03/2022  Robert     VERSAO INICIAL USANDO SONONIMOS PARA NOMES DE TABELAS
----------------------------------------------------------------------------------------------------------------------------

set nocount on;

  BEGIN TRANSACTION

  BEGIN TRY
     --- Define o codigo da condicao que sera criada. A lucratividade sera criada no intervalo de 5000 e 7999
   SET @VPOLITICA = '4999';
   SET @VPOLITICA_INI = 5000;
   SET @VPOLITICA_FIM = 9999;

   SET @VPROX_LUCRATIV = 4999;
   SET @VLUCRATIV_INI = 5000;
   SET @VLUCRATIV_FIM = 9999;

   SET @V_NRO_REGRAS_POL = 0;
   
     ---------------------------------------------
   --- Eliminar/atualizar tabelas da politica comercial
   ---------------------------------------------
   DELETE FROM MPV06 WHERE PV06_TIPO  = 'C' AND PV06_POLITICA BETWEEN @VPOLITICA_INI AND @VPOLITICA_FIM
   DELETE FROM DB_POLCOM_REGRA WHERE TIPO = 'C' AND POLITICA BETWEEN @VPOLITICA_INI AND @VPOLITICA_FIM
   DELETE FROM DB_POLCOM_PRINCIPAL WHERE TIPO = 'C' AND POLITICA BETWEEN @VPOLITICA_INI AND @VPOLITICA_FIM

     ---------------------------------------------
   --- Fim - Eliminar/atualizar tabelas da politica comercial
   ---------------------------------------------



     ---------------------------------------------
   --- Eliminar tabelas da lucratividade do intervalo
   ---------------------------------------------
   DELETE FROM DB_CONC_LUCRAT WHERE DB_CONL_CODIGO BETWEEN @VLUCRATIV_INI AND @VLUCRATIV_FIM
   DELETE FROM DB_CONC_LUCRAT_FX WHERE DB_CONL_CODIGO BETWEEN @VLUCRATIV_INI AND @VLUCRATIV_FIM


     ---------------------------------------------
   --- Eliminar tabelas da Economia (frete)
   ---------------------------------------------
   DELETE FROM DB_CLIENTE_ECON WHERE DB_CLIE_TIPO = 'D' AND DB_CLIE_HISTCC = 1


   ------------------------------------------------------
   --- Encontrar o controle com as variaveis cliente e produto
   ------------------------------------------------------
     SELECT @VCONTROLE = PV04_CONTROLE
       FROM MPV04
      WHERE EXISTS (SELECT 1 FROM MPV05 WHERE PV05_CONTROLE = PV04_CONTROLE AND PV05_TAGFILTRO = 'CLIENTE')
        AND EXISTS (SELECT 1 FROM MPV05 WHERE PV05_CONTROLE = PV04_CONTROLE AND PV05_TAGFILTRO = 'LPRECO')
    AND EXISTS (SELECT 1 FROM MPV05 WHERE PV05_CONTROLE = PV04_CONTROLE AND PV05_TAGFILTRO = 'PRODUTO')    
        AND (SELECT COUNT(1) FROM MPV05 WHERE PV05_CONTROLE = PV04_CONTROLE ) = 3
     
   --- Se não encontrou controle deve criar a MPV04 e MPV05
   IF ISNULL(@VCONTROLE, 0) = 0 
   BEGIN
       SELECT @VCONTROLE = isnull(MAX(PV04_CONTROLE), 0) + 1 FROM MPV04;

         INSERT INTO MPV04 (PV04_CONTROLE, PV04_TIPO, PV04_ORDEMBUSCA, PV04_INDDESCTO, PV04_PESO, PV04_PESO_IMP)
                    VALUES (@VCONTROLE, 'I', 0, 1, 1160, 0);
  
       INSERT INTO MPV05 (PV05_CONTROLE, PV05_SEQ, PV05_TAGFILTRO)
                    VALUES (@VCONTROLE, 1, 'CLIENTE');
       INSERT INTO MPV05 (PV05_CONTROLE, PV05_SEQ, PV05_TAGFILTRO)
                    VALUES (@VCONTROLE, 2, 'LPRECO');
       INSERT INTO MPV05 (PV05_CONTROLE, PV05_SEQ, PV05_TAGFILTRO)
                    VALUES (@VCONTROLE, 3, 'PRODUTO');
   END;

   ------------------------------------------------------
   --- Fim - Encontrar o controle com as variaveis cliente e produto
   ------------------------------------------------------

   SET @VPROXREGRA = 0;

     DECLARE C_VA_PERCOMP CURSOR   
   FOR SELECT CODCLI, CODPRO, CUSTOPRO, MARGEM, RAPEL, PFRETE, PERTOT, MARGEM_BLQ
           FROM INTEGRACAO_PROTHEUS_MER_PERCOMP
      ORDER BY CODCLI

   OPEN C_VA_PERCOMP
   FETCH NEXT FROM C_VA_PERCOMP
   INTO @VCODCLI, @VCODPRO, @VCUSTOPRO, @VMARGEM, @VRAPEL, @VPFRETE, @VPERTOT, @VMARGEM_BLQ
   WHILE @@FETCH_STATUS = 0
   BEGIN

     --PRINT 'PRODUTO ' + @VCODPRO

     ------------------------------------------------------
     --- Para cada cliente deve:
     ---     1 - Criar uma regra na politica comercial
     ---     2 - Gravar a tabela de lucratividade
     ---     3 - Gravar a lucratividade
     ------------------------------------------------------
     IF @VCODCLI <> ISNULL(@VCODCLI_ANTERIOR, '0') 
     BEGIN 
      
         set @V_NRO_REGRAS_POL  = @V_NRO_REGRAS_POL + 1

print '@V_NRO_REGRAS_POL ' + cast(@V_NRO_REGRAS_POL as varchar)
       --- A cada 100 clientes gera uma nova politica
       IF @V_NRO_REGRAS_POL = 1 
         or @V_NRO_REGRAS_POL%100 = 0  --- isso eh o mesmo que MOD
       BEGIN

           SET @VPOLITICA = @VPOLITICA + 1
           SET @VPROXREGRA = 0;


         MERGE INTO DB_POLCOM_PRINCIPAL  AS TARGET
          USING(SELECT @VPOLITICA        POLITICA
                   , 'C'               TIPO
                 , 'Formacao Preco'  DESCRICAO
                 , 'Condicao de venda importada automaticamente do Protheus e utilizada para formacao de precos.' COMENTARIO
                 , 1                 SITUACAO
                ) AS SOURCE
          ON ( TARGET.POLITICA = SOURCE.POLITICA
           AND TARGET.TIPO     = SOURCE.TIPO)
          WHEN MATCHED THEN
            UPDATE SET TIPO   = SOURCE.TIPO
                 , DESCRICAO = SOURCE.DESCRICAO
                    , COMENTARIO = SOURCE.COMENTARIO
                 , SITUACAO = SOURCE.SITUACAO
          WHEN NOT MATCHED THEN
            INSERT (POLITICA
                , TIPO
                , DESCRICAO
                , COMENTARIO
                , SITUACAO)
            VALUES (SOURCE.POLITICA
                , SOURCE.TIPO
                , SOURCE.DESCRICAO
                , SOURCE.COMENTARIO
                , SOURCE.SITUACAO);
       END



         --- 1 - Criar uma regra na politica comercial
         SET @VPROXREGRA       = @VPROXREGRA + 1;

             SELECT @VDB_CLI_NOME = DB_CLI_NOME
           FROM DB_CLIENTE
          WHERE DB_CLI_CODIGO = @VCODCLI

         INSERT INTO DB_POLCOM_REGRA (POLITICA
                                        , TIPO
                            , REGRA
                            , DESCRICAO
                             )
                         VALUES (@VPOLITICA
                             , 'C'
                           , @VPROXREGRA
                           , @VCODCLI + '-' + @VDB_CLI_NOME);
             
       --- 2 - Gravar o cabecalho da tabela de lucratividade
       SET @VPROX_LUCRATIV = @VPROX_LUCRATIV + 1
       INSERT INTO DB_CONC_LUCRAT (DB_CONL_CODIGO, DB_CONL_DTINI, DB_CONL_DTFIN, DB_CONL_LEMPRESA, DB_CONL_PESO
                                       , DB_CONL_AVAL, DB_CONL_LCLIENTE)
                                 VALUES (@VPROX_LUCRATIV, '01/01/2017','12/31/2099', '01', 1
                             , 1, cast(@VCODCLI as float))

       SET @VCODCLI_ANTERIOR = @VCODCLI;
         END;

     --------------------------------
     --- Calcular o % de acrescimo
     --------------------------------
     set @VPERC_MERCANET = round(((1/((100 - @VPERTOT)/100))*100)-100, 3)

     --------------------------------
     --- Montar o hash com os valores das variaves de cliente e produtos
     --------------------------------
     SET @VIDENT = CAST(CAST(@VCODCLI AS NUMERIC) AS VARCHAR) + '#' + ltrim(rtrim(@VCODPRO)) + '#990'

--PRINT '@VIDENT' + @VIDENT

       SELECT @VSEQ = ISNULL(MAX(PV06_SEQ), 0) + 1
         FROM MPV06 
        WHERE PV06_CONTROLE = @VCONTROLE;

     ---------------------------------
     --- Inserir na MPV06
     ---------------------------------
     INSERT INTO MPV06 (PV06_CONTROLE
              , PV06_SEQ
              , PV06_TIPO
              , PV06_POLITICA
              , PV06_IDENT
              , PV06_HASH
              , PV06_PRAZOMIN
              , PV06_PRAZOMAX
              , PV06_QTDEMIN
              , PV06_QTDEMAX
              , PV06_CVI
              , PV06_COMIS
              , PV06_DATA_INI
              , PV06_DATA_FIM
              , PV06_PRECOLIQ
              , PV06_BONIF
              , PV06_BONQTD
              , PV06_BONVLR
              , PV06_PEDMIN
              , PV06_PARTIC
              , PV06_PARTMAX
              , PV06_ACRVLR
              , PV06_VALMIN
              , PV06_VALMAX
              , PV06_DESCTO
              , PV06_AVALIACAO
              , PV06_APLIC_OL
              , PV06_QTDEMULT
              , PV06_PARTMAXFIS
              , PV06_FATCONV
              , PV06_AplicBruto
              , PV06_Aplicacao
              , PV06_IDRegra
              , PV06_DESCTOMIN
              , PV06_DESCTOMAX
              , PV06_PartSobre
              , PV06_TpAvaliacao
              , PV06_DIASAMAIS
              , PV06_VALMIX
              , PV06_CLICONTRIB
              , PV06_CLIIE
              , PV06_CLIVENDOR
              , PV06_CLISUFRAMA
              , PV06_APRESCLI
              , PV06_DIAINI
              , PV06_DIAFIN
              , PV06_VALIDADE
              , PV06_DCTOMEDIOMIN
              , PV06_UMQTDE
              , PV06_DATA_ALTER
              , PV06_NCALCCOMIS
              , PV06_DESCONSCONDVDA
              , PV06_FORMAPRECO
              , PV06_CUBAGEMMIN
              , PV06_CUBAGEMMAX
              , PV06_REGRA
              , PV06_PROMOCAO_PRODUTO
              , PV06_MOTIVODESCTO)
          VALUES (@VCONTROLE              -- PV06_CONTROLE
              , @VSEQ                 -- PV06_SEQ
              , 'C'                   -- PV06_TIPO
              , @VPOLITICA            -- PV06_POLITICA
              , @VIDENT               -- PV06_IDENT
              , NULL                  -- PV06_HASH
              , 0                     -- PV06_PRAZOMIN
              , 999                   -- PV06_PRAZOMAX
              , 0                     -- PV06_QTDEMIN
              , 0                     -- PV06_QTDEMAX
              , 0                     -- PV06_CVI
              , 0                     -- PV06_COMIS
              , '01/01/2017'          -- PV06_DATA_INI
              , '12/31/2099'          -- PV06_DATA_FIM
              , 0                     -- PV06_PRECOLIQ
              , 0                     -- PV06_BONIF
              , 0                     -- PV06_BONQTD
              , 0                     -- PV06_BONVLR
              , 0                     -- PV06_PEDMIN
              , 0                     -- PV06_PARTIC
              , 0                     -- PV06_PARTMAX
              , @VPERC_MERCANET       -- PV06_ACRVLR
              , 0                     -- PV06_VALMIN
              , 0                     -- PV06_VALMAX
              , 0                     -- PV06_DESCTO
              , 0                     -- PV06_AVALIACAO
              , 0                     -- PV06_APLIC_OL
              , 0                     -- PV06_QTDEMULT
              , 0                     -- PV06_PARTMAXFIS
              , 0                     -- PV06_FATCONV
              , 1                     -- PV06_AplicBruto
              , 0                     -- PV06_Aplicacao
              , 0                     -- PV06_IDRegra
              , 0                     -- PV06_DESCTOMIN
              , 0                     -- PV06_DESCTOMAX
              , 0                     -- PV06_PartSobre
              , 0                     -- PV06_TpAvaliacao
              , 0                     -- PV06_DIASAMAIS
              , 0                     -- PV06_VALMIX
              , 0                     -- PV06_CLICONTRIB
              , 0                     -- PV06_CLIIE
              , 0                     -- PV06_CLIVENDOR
              , 0                     -- PV06_CLISUFRAMA
              , 0                     -- PV06_APRESCLI
              , 0                     -- PV06_DIAINI
              , 0                     -- PV06_DIAFIN
              , 0                     -- PV06_VALIDADE
              , 0                     -- PV06_DCTOMEDIOMIN
              , 0                     -- PV06_UMQTDE
              , GETDATE()             -- PV06_DATA_ALTER
              , 0                     -- PV06_NCALCCOMIS
              , 0                     -- PV06_DESCONSCONDVDA
              , 0                     -- PV06_FORMAPRECO
              , 0                     -- PV06_CUBAGEMMIN
              , 0                     -- PV06_CUBAGEMMAX
              , @VPROXREGRA           -- PV06_REGRA
              , 0                     -- PV06_PROMOCAO_PRODUTO
              , 0                     -- PV06_MOTIVODESCTO
              );

       ---------------------------------
       --- Fim Insere na MPV06
       ---------------------------------


       ---------------------------------
       --- Gravar os itens da tabela de lucratividade
       ---    o primeiro registro (Margem Baixa) é sempre de -9999 ate o % menos 0.01 
       ---    o segundo registro (Margem Boa) é sempre do % ate 9999
        ---------------------------------
             SELECT @VPROXSEQ_LUCRATIV = ISNULL(MAX(DB_CONL_SEQ), 0) + 1 
         FROM DB_CONC_LUCRAT_FX
        WHERE DB_CONL_CODIGO = @VPROX_LUCRATIV;
       -- DB_CONL_SITPED = 2-nao aceitar
             INSERT INTO DB_CONC_LUCRAT_FX (DB_CONL_CODIGO,   DB_CONL_SEQ,        DB_CONL_FXINI,   DB_CONL_FXFIN,           DB_CONL_CONCEITO    
                                          , DB_CONL_DESCR,    DB_CONL_SITPED,     DB_CONL_PRODUTO, DB_CONL_PESO,            DB_CONL_COR)
                            VALUES (@VPROX_LUCRATIV,  @VPROXSEQ_LUCRATIV, -9999,           0.00,                    2
                                  , 'Margem Ruim',    2,                  @VCODPRO,        8,                       '#DE0E0E')
             -- DB_CONL_SITPED = 1-bloquear
             INSERT INTO DB_CONC_LUCRAT_FX (DB_CONL_CODIGO,   DB_CONL_SEQ,        DB_CONL_FXINI,   DB_CONL_FXFIN,           DB_CONL_CONCEITO    
                                          , DB_CONL_DESCR,    DB_CONL_SITPED,     DB_CONL_PRODUTO, DB_CONL_PESO,            DB_CONL_COR)
                            VALUES (@VPROX_LUCRATIV,  @VPROXSEQ_LUCRATIV + 1, 0.01,            @VMARGEM_BLQ - 0.01,     2
                                  , 'Margem Baixa',   1,                  @VCODPRO,        8,                       '#DE0E0E')
             -- DB_CONL_SITPED = 0-normal
             INSERT INTO DB_CONC_LUCRAT_FX (DB_CONL_CODIGO,   DB_CONL_SEQ,            DB_CONL_FXINI,   DB_CONL_FXFIN,            DB_CONL_CONCEITO    
                                          , DB_CONL_DESCR,    DB_CONL_SITPED,         DB_CONL_PRODUTO, DB_CONL_PESO,             DB_CONL_COR)
                            VALUES (@VPROX_LUCRATIV,  @VPROXSEQ_LUCRATIV + 2, @VMARGEM_BLQ,    9999,                     0
                                  , 'Margem Boa',     0,                      @VCODPRO,        8,                        '#008000')
       ---------------------------------
       --- Fim - Gravar os itens da tabela de lucratividade
        ---------------------------------


     FETCH NEXT FROM C_VA_PERCOMP
     INTO @VCODCLI, @VCODPRO, @VCUSTOPRO, @VMARGEM, @VRAPEL, @VPFRETE, @VPERTOT, @VMARGEM_BLQ
   END 
   CLOSE C_VA_PERCOMP
   DEALLOCATE C_VA_PERCOMP

   -------------------------------------------
   --- Atualiza o parâmetro que define que o cache de politicas deve ser atualizado
   -------------------------------------------
     UPDATE DB_PARAM_SISTEMA        SET DB_PRMS_VALOR = GETDATE() 
    WHERE db_prms_id = 'SIS_DATAATUPOLITICAS'


  COMMIT

  END TRY

  BEGIN CATCH
      rollback
    SET @VDATA = GETDATE();
    SET @VERRO = 'ERRO AO INSERIR CONDICOES:' + ERROR_MESSAGE();
    INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, @VDATA, @VOBJETO);

  END CATCH


  ---------------------------------
  --- Atualizar a economia do cliente - (Frete)
  ---------------------------------
    BEGIN TRY
       MERGE INTO DB_CLIENTE_ECON  AS TARGET
     USING(SELECT CAST(CODCLI AS FLOAT)  CODCLI
                , 'D'                    TIPO
                , MAX(PFRETE)            PFRETE
            , '01/01/2017'       DATAINI
          , '12/31/2099'       DATAFIN
          , 1                  HISTCC
          , (SELECT ISNULL(MAX(DB_CLIE_SEQ), 0) + 1 
               FROM DB_CLIENTE_ECON 
            WHERE DB_CLIE_CODIGO = CAST(CODCLI AS FLOAT))  SEQ_MAX
             FROM INTEGRACAO_PROTHEUS_MER_PERCOMP
        GROUP BY CODCLI
          ) AS SOURCE
     ON ( TARGET.DB_CLIE_CODIGO = SOURCE.CODCLI 
      AND TARGET.DB_CLIE_TIPO   = SOURCE.TIPO)
     WHEN MATCHED THEN
      UPDATE SET DB_CLIE_DESCTO   = SOURCE.PFRETE 
               , DB_CLIE_TIPO     = SOURCE.TIPO
           , DB_CLIE_DATAINI  = SOURCE.DATAINI
           , DB_CLIE_DATAFIN  = SOURCE.DATAFIN
           , DB_CLIE_HISTCC   = SOURCE.HISTCC
     WHEN NOT MATCHED THEN
      INSERT (DB_CLIE_CODIGO
                  , DB_CLIE_SEQ
          , DB_CLIE_DESCTO
          , DB_CLIE_TIPO
          , DB_CLIE_DATAINI
          , DB_CLIE_DATAFIN
          , DB_CLIE_HISTCC
          )
      VALUES (SOURCE.CODCLI
          , SOURCE.SEQ_MAX
          , SOURCE.PFRETE
          , SOURCE.TIPO
          , SOURCE.DATAINI
          , SOURCE.DATAFIN
          , SOURCE.HISTCC
          );
  END TRY

  BEGIN CATCH
    SET @VDATA = GETDATE();
    SET @VERRO = 'ERRO AO ATUALIZAR  ECONOMIA DO CLIENTE:' + ERROR_MESSAGE();
    INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, @VDATA, @VOBJETO);

  END CATCH
  ---------------------------------
  --- Fim Atualizar a economia do cliente
  ---------------------------------


  ---------------------------------
  --- Atualizar o custo do produto
  ---------------------------------
    BEGIN TRY

       MERGE INTO DB_CUSTO_PROD  AS TARGET
     USING(SELECT DISTINCT CODPRO
                         , DATEPART (YEAR, GETDATE()) ANO
               , DATEPART (MONTH, GETDATE()) MES
                         , CUSTOPRO 
               , '1'    TIPO
               , '01'   EMPRESA
             FROM INTEGRACAO_PROTHEUS_MER_PERCOMP
          ) AS SOURCE
     ON ( TARGET.DB_CUSTO_PRODUTO = SOURCE.CODPRO COLLATE SQL_Latin1_General_CP1_CI_AS
       AND TARGET.DB_CUSTO_ANO     = SOURCE.ANO
      AND TARGET.DB_CUSTO_MES     = SOURCE.MES
      AND TARGET.DB_CUSTO_TIPO    = SOURCE.TIPO
      AND TARGET.DB_CUSTO_EMPRESA = SOURCE.EMPRESA)
     WHEN MATCHED THEN
      UPDATE SET DB_CUSTO_MATPRIM   = SOURCE.CUSTOPRO 
               , DB_CUSTO_DTALTER   = GETDATE()
     WHEN NOT MATCHED THEN
      INSERT (DB_CUSTO_PRODUTO
            , DB_CUSTO_ANO
          , DB_CUSTO_MES
          , DB_CUSTO_TIPO
          , DB_CUSTO_EMPRESA
          , DB_CUSTO_MATPRIM
          , DB_CUSTO_MAOOBRA
          , DB_CUSTO_FIXO
          , DB_CUSTO_ADMCOM
          , DB_CUSTO_QTDEVI
          , DB_CUSTO_QTDEVD
          , DB_CUSTO_DTALTER
          )
      VALUES (SOURCE.CODPRO
            , SOURCE.ANO
          , SOURCE.MES
          , SOURCE.TIPO
          , SOURCE.EMPRESA
          , SOURCE.CUSTOPRO
          , 0
          , 0
          , 0
          , 0
          , 0
          , GETDATE()
          );
  END TRY

  BEGIN CATCH
    SET @VDATA = GETDATE();
    SET @VERRO = 'ERRO AO ATUALIZAR CUSTO DOS PRODUTOS:' + ERROR_MESSAGE();
    INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, @VDATA, @VOBJETO);

  END CATCH
  ---------------------------------
  --- Fim Atualizar o custo do produto
  ---------------------------------



  ---------------------------------
  --- Atualizar o fator de lucratividade - Rapel
  --- Criar um fator para cada cliente
  --- Utiliza o intervalo de códigos de 5000 a 49999
  --- Utiliza o atributo 200
  ---------------------------------
   SET @VFATOR_INI = 5000
   SET @VFATOR_FIM = 49999

   DELETE DB_LUC_FATOR WHERE CODIGO BETWEEN @VFATOR_INI AND @VFATOR_FIM
   DELETE DB_LUC_FATOR_PRODUTO WHERE CODIGO_FATOR BETWEEN @VFATOR_INI AND @VFATOR_FIM
   DELETE DB_LUC_FATOR_ATRIB_PRODUTO WHERE CODIGO_FATOR BETWEEN @VFATOR_INI AND @VFATOR_FIM

   -----------------------
   ---- Passo 1 - Criar o fator para os clientes que possuem o mesmo % de rapel.
   ----           Nestes casos o fator é criado com o atributo do produto 200
   -----------------------
     DECLARE C_VA_PERCOMP_FATOR CURSOR   
   FOR  SELECT CLIENTE
			  ,CLIENTE + '-' + NOME_CLIENTE
			  ,PRODUTO
			  ,PERC_RAPEL
			  FROM INTEGRACAO_PROTHEUS_VA_VRAPEL_PADRAO
			  WHERE ATIVO = 'S'
			  AND PRODUTO = ''

   OPEN C_VA_PERCOMP_FATOR
   FETCH NEXT FROM C_VA_PERCOMP_FATOR
   INTO @VCODCLI, @VNOMECLI, @VPRODUTO, @VRAPEL
   WHILE @@FETCH_STATUS = 0
   BEGIN

      PRINT '@VCODCLI ' + CAST(@VCODCLI AS VARCHAR)

    SELECT @VCODIGO = ISNULL(MAX(CODIGO), @VFATOR_INI) + 1 
      FROM DB_LUC_FATOR  
     WHERE CODIGO BETWEEN @VFATOR_INI AND @VFATOR_FIM

    INSERT INTO DB_LUC_FATOR (CODIGO
                , DESCRICAO
                   , DATA_INICIAL
                   , DATA_FINAL
                   , SITUACAO
                   , CLIENTE_CODIGO
                   )
                VALUES (@VCODIGO                                     -- CODIGO
                   , @VNOMECLI					                     -- DESCRICAO
                   , '2017-01-01'                                    -- DATA_INICIAL
                   , '2099-12-31'                                    -- DATA_FINAL
                   , 1                                               -- SITUACAO
                   , CAST(@VCODCLI AS INT)                           -- CLIENTE_CODIGO
                )

    INSERT INTO DB_LUC_FATOR_PRODUTO (CODIGO_FATOR 
                    , SEQUENCIA
					, PRODUTO
					, FATOR
                    , PESO
                     )
                  VALUES (@VCODIGO          -- CODIGO_FATOR 
                    , 1                 -- SEQUENCIA
					, @VPRODUTO			-- PRODUTO
                    , @VRAPEL           -- FATOR
                    , 160               -- PESO
                     )

        INSERT INTO DB_LUC_FATOR_ATRIB_PRODUTO (CODIGO_FATOR 
                        , SEQUENCIA
                        , ATRIBUTO
                        , VALOR
                         )
                    VALUES (@VCODIGO    -- CODIGO_FATOR 
                        , 1           -- SEQUENCIA
                        , 200         -- ATRIBUTO
                        , 1           -- VALOR
                         )

     FETCH NEXT FROM C_VA_PERCOMP_FATOR
     INTO @VCODCLI, @VNOMECLI, @VPRODUTO, @VRAPEL
   END 
   CLOSE C_VA_PERCOMP_FATOR
   DEALLOCATE C_VA_PERCOMP_FATOR


   -----------------------
   ---- Passo 2 - Criar o fator para os clientes que possuem % de rapel diferentes por produtos.
   ----           Nestes casos o fator é criado com o produto
   -----------------------
     DECLARE C_VA_PERCOMP_FATOR_PROD CURSOR   
   FOR  SELECT CLIENTE
			  ,CLIENTE + '-' + NOME_CLIENTE
			  ,PRODUTO
			  ,PERC_RAPEL
			  FROM INTEGRACAO_PROTHEUS_VA_VRAPEL_PADRAO
			  WHERE ATIVO = 'S'
			  AND PRODUTO != ''

   OPEN C_VA_PERCOMP_FATOR_PROD
   FETCH NEXT FROM C_VA_PERCOMP_FATOR_PROD
   INTO @VCODCLI, @VNOMECLI, @VPRODUTO, @VRAPEL
   WHILE @@FETCH_STATUS = 0
   BEGIN

      PRINT '@VCODCLI ' + CAST(@VCODCLI AS VARCHAR)

    SELECT @VCODIGO = ISNULL(MAX(CODIGO), @VFATOR_INI) + 1 
      FROM DB_LUC_FATOR  
     WHERE CODIGO BETWEEN @VFATOR_INI AND @VFATOR_FIM

    INSERT INTO DB_LUC_FATOR (CODIGO
                , DESCRICAO
                   , DATA_INICIAL
                   , DATA_FINAL
                   , SITUACAO
                   , CLIENTE_CODIGO
                   )
               VALUES (@VCODIGO                                     -- CODIGO
                   , @VNOMECLI					                     -- DESCRICAO
                   , '2017-01-01'                                    -- DATA_INICIAL
                   , '2099-12-31'                                    -- DATA_FINAL
                   , 1                                               -- SITUACAO
                   , CAST(@VCODCLI AS INT)                           -- CLIENTE_CODIGO
                )

    INSERT INTO DB_LUC_FATOR_PRODUTO (CODIGO_FATOR 
                    , SEQUENCIA
                    , PRODUTO
                    , FATOR
                    , PESO
                     )
                  VALUES (@VCODIGO          -- CODIGO_FATOR 
                    , 1                 -- SEQUENCIA
					, @VPRODUTO			-- PRODUTO
                    , @VRAPEL           -- FATOR
                    , 192               -- PESO
                     )

	INSERT INTO DB_LUC_FATOR_ATRIB_PRODUTO (CODIGO_FATOR 
                      , SEQUENCIA
                      , ATRIBUTO
                      , VALOR
                         )
                  VALUES (@VCODIGO    -- CODIGO_FATOR 
                      , 1           -- SEQUENCIA
                      , 200         -- ATRIBUTO
                      , 1           -- VALOR
                     )

     FETCH NEXT FROM C_VA_PERCOMP_FATOR_PROD
     INTO @VCODCLI, @VNOMECLI, @VPRODUTO, @VRAPEL
   END 
   CLOSE C_VA_PERCOMP_FATOR_PROD
   DEALLOCATE C_VA_PERCOMP_FATOR_PROD
   
  ---------------------------------
  --- Fim Atualizar o fator de lucratividade - Rapel
  ---------------------------------


  
END -- FIM PROGRAMA

GO
