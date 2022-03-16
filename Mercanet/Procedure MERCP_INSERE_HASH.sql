SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_INSERE_HASH] (@P_CODIGO VARCHAR(25),
                                    @P_TIPO   VARCHAR(10)
                                   ) AS

DECLARE @V_SITUACAO                VARCHAR(2);
DECLARE @V_UTILBASERED             FLOAT;
DECLARE @V_ID                      INT;
DECLARE @V_EMPRESA                 VARCHAR(1024);
DECLARE @V_UF_DEST                 VARCHAR(1024);
DECLARE @ERRO                      VARCHAR(255);
DECLARE @V_CLIENTE                 VARCHAR(1024);
DECLARE @V_RAMO                    VARCHAR(1024);
DECLARE @V_OPERACAO                VARCHAR(1024);
DECLARE @V_CIDADE                  VARCHAR(1024);
DECLARE @V_LPRECO                  VARCHAR(1024);
DECLARE @V_TPPED                   VARCHAR(1024);
DECLARE @V_CLICCOM                 VARCHAR(1024);
DECLARE @V_REPRES                  VARCHAR(1024);
DECLARE @V_RAMOII                  VARCHAR(1024);
DECLARE @V_AREAATU                 VARCHAR(1024);
DECLARE @V_OPERLOG                 VARCHAR(1024);
DECLARE @V_LABORATOR               VARCHAR(1024);
DECLARE @V_REGCOM                  VARCHAR(1024);
DECLARE @V_MARCA                   VARCHAR(1024);
DECLARE @V_FAMILIA                 VARCHAR(1024);
declare @v_DB_MPRI_LST_CLFISCLI    varchar(1024);
-- COND VENDA
DECLARE @V_CODIGO_REGRA            VARCHAR(1024);
DECLARE @V_DATA_INI                DATE;
DECLARE @V_DATA_FIM                DATE;
DECLARE @V_ESTADOS                 VARCHAR(1024);        
DECLARE @V_PRODUTOS                VARCHAR(1024);
DECLARE @V_TIPOPED                 VARCHAR(1024);
DECLARE @V_CLIENTES                VARCHAR(1024);
DECLARE @V_RAMOATVS                VARCHAR(1024);
DECLARE @V_RAMOATV1                VARCHAR(1024);
DECLARE @V_SUFRAMA                 INT;
DECLARE @V_LPRECOS                 VARCHAR(1024);
DECLARE @V_LPRECOS1                VARCHAR(1024);
DECLARE @V_CLASSCOM                VARCHAR(1024);
DECLARE @V_TIPO                    VARCHAR(1024);
DECLARE @VDB_TBCVP_LCPGTO          VARCHAR(128);  
DECLARE @VDB_TBCV_CPGTO            VARCHAR(512);
DECLARE @VDB_TBCVP_PRZMED          FLOAT;
DECLARE @VDB_TBCVP_QTDEMAX         FLOAT;
DECLARE @VDB_TBCVP_QTDEMIN         FLOAT;
DECLARE @VDB_TBCVP_CVI             FLOAT;
DECLARE @VDB_TBCVP_COMIS           FLOAT;
DECLARE @VDB_TBCVP_PEDMIN          FLOAT;
DECLARE @VDB_TBCVP_DESCTO          FLOAT;
DECLARE @VDB_TBCV_APLICA_AUT       FLOAT;
DECLARE @VDB_TBCV_APLIC_OL         FLOAT;
DECLARE @VDB_TBCV_GRUPOEMP         FLOAT;
DECLARE @VDB_TBCV_TPAVAL           FLOAT;
DECLARE @V_PEDMIN                  INT;
DECLARE @V_RVALPDV                 INT;
DECLARE @V_REFERP                  VARCHAR(512);
DECLARE @V_LSTMIXV                 VARCHAR(512);
DECLARE @V_PRECOLIQ                FLOAT;
DECLARE @V_BONIF                   FLOAT;
DECLARE @V_BONQTD                  FLOAT;
DECLARE @V_BONVLR                  FLOAT;
DECLARE @V_PARTIC                  FLOAT;
DECLARE @V_PARTMAX                 FLOAT;
DECLARE @V_ACRVLR                  FLOAT;
DECLARE @V_VALMIN                  FLOAT;
DECLARE @V_VALMAX                  FLOAT;
DECLARE @V_DIAINI                  INT;
DECLARE @V_DIAFIN                  INT;
DECLARE @V_APRESCLI                INT;
DECLARE @V_DIASMAIS                INT;
DECLARE @V_DESCONTO                FLOAT;
DECLARE @V_LCPGTO                  VARCHAR(512) 
DECLARE @V_MIXVDA                  VARCHAR(512)
DECLARE @PDB_TBPRM_PRODPRM         VARCHAR(1024)
DECLARE @V_AUX                     VARCHAR(512);
DECLARE @V_RESULTADO               VARCHAR(255);
DECLARE @V_LISTA                   VARCHAR(1024) = '';
DECLARE @VDB_TBCV_CLIREDE          INT;
DECLARE @V_QUANTIDADE              INT;
DECLARE @V_COUNT                   INT;
DECLARE @VDB_MPRI_MRGPRESUM        FLOAT
DECLARE @VDB_MPRI_DCTOPMC          FLOAT;
DECLARE @VDB_MPRI_TPCALC           INT;
DECLARE @V_PESO                    FLOAT;
DECLARE @V_BASERED                 FLOAT;
DECLARE @VDB_MPRI_CALC_SUBS        VARCHAR(5);
DECLARE @V_CLASFIS                 VARCHAR(512);
DECLARE @V_OPERACAO_VENDA          VARCHAR(512);
DECLARE @V_GRUPO                   VARCHAR(512);
DECLARE @V_COND_PGTO               VARCHAR(1024) = '';
DECLARE @V_SEQ_PAI                 INT;
DECLARE @V_TPPESSOA                INT;
DECLARE @V_CLASSFIS                VARCHAR(10);
DECLARE @V_CLASSFCLI               VARCHAR(10);
DECLARE @V_CONTRIB                 VARCHAR(1);
DECLARE @V_TXTICMS                 FLOAT;
DECLARE @V_SEQ                     INT;
DECLARE @V_CLASSPRD                VARCHAR(16);
DECLARE @V_TPVENDA                 VARCHAR(25);
DECLARE @V_FATUR                   INT;
DECLARE @VDB_TBCV_TIPO             INT;
DECLARE @V_IND_DESCTO              INT;
DECLARE @V_TIPO_FRETE              VARCHAR(512);
DECLARE @VDB_TBPRM_TIPOPRM         VARCHAR(255);
DECLARE @VDB_TBCVP_ACRESC          FLOAT;
DECLARE @VDB_TBCV_CLICONTR         FLOAT;
DECLARE @VDB_TBCV_IE               FLOAT;
DECLARE @VDB_TBCV_AVALCLIVD        FLOAT;   
DECLARE @VDB_TBCV_SUFRAMA          FLOAT;
DECLARE @VDB_TBCV_APRESCLI         FLOAT;
DECLARE @VDB_TBCVP_DIAINI          FLOAT;
DECLARE @VDB_TBCVP_DIAFIN          FLOAT;
DECLARE @VDB_TBCV_DTPEDVAL         FLOAT;
DECLARE @VDB_TBCV_APL_OLCLI        FLOAT;
DECLARE @VDB_TBPRM_DCTQTDMUL       INT;
DECLARE @VDB_TBPRM_PPARTIC         INT;
DECLARE @VDB_TBPRM_CLICONTR        INT;
DECLARE @VDB_TBPRM_DTPEDVAL        INT;
DECLARE @VDB_TBPRM_APL_OLCLI       INT;
DECLARE @VPDB_TBPRM_TIPO           INT;
DECLARE @VDB_TBPRM_PRODFORA        VARCHAR(1024);
DECLARE @VDB_MPRI_GRPITCONT        VARCHAR(5);
DECLARE @VDB_TBPRM_GRPPRM          VARCHAR(512);
DECLARE @V_FORCAVENDAS             VARCHAR(255);
DECLARE @DB_TBCV_FORMAPRECO        FLOAT;
DECLARE @V_DB_MPRI_OPTANTESIMPLES  INT;
DECLARE @V_DB_MPRI_DESCONTO_FISCAL INT;

DECLARE @VDB_RIEI_SEQ              INT;
DECLARE @VDB_MPRI_SEQ              INT;

BEGIN

--------------------------------------------------------------------------------------
---  OPCAO DE GEREAR HASH
---  C - CONDICOES DE VENDA
---  P - PROMOCAO DE VENDA
---  R, A, S - RESTRICAO DE VENDA
---  ST - MARGEM PRESUMIDA
---  RI - REGRA EXCECAO ICMS/IPI

---  VERSAO  DATA        AUTOR  ALTERACAO
---  1.0002  10/10/2013  TIAGO  UPDATA DATA DE MODIFICACAO DA POLITICA
---  1.0003  04/09/2014  TIAGO  GRAVA MIX PARA PRODUTOS FORA DA PROMOCAO
---  1.0004  26/02/2016  TIAGO  INCLUIDO NOVOS CAMPO DE FORCA VENDAS E FORMAPRECO
---  1.0005  12/04/2016  TIAGO  INCLUIDO FILTRO CLIOPTSIMPLES
---  1.0006  14/03/2017  TIAGO  GRAVA CAMPO DESCONTO FISCAL
--------------------------------------------------------------------------------------

SET NOCOUNT ON
IF @P_TIPO = 'C'  -- CONDICOES DE VENDA
BEGIN

   IF @P_CODIGO IS NOT NULL
   BEGIN

      DELETE MPV06_TEMP_HASH
       WHERE PV06_TIPO     = @P_TIPO
         AND PV06_POLITICA = @P_CODIGO;

      -- SOMENTE EXECUTA O HASH SE A REGRA ESTIVER ATIVA
      SET @V_SITUACAO = 'A';

      SELECT @V_SITUACAO =  DB_TBCV_SITUACAO         
        FROM DB_TB_COND_VENDA
       WHERE DB_TBCV_CODIGO = @P_CODIGO;

      IF @V_SITUACAO = 'A'
      BEGIN

         SET @V_ID = ROUND(RAND() * 1000000, 0);

         SELECT @V_EMPRESA        = REPLACE(DB_TBCV_EMPRESAS, ';', ','),
                @V_UF_DEST        = REPLACE(DB_TBCV_ESTADOS, ';', ','),
                @V_CLIENTE        = REPLACE(DB_TBCV_CLIENTES, ';', ','),
                @V_RAMO           = REPLACE(DB_TBCV_RAMOATVS + ISNULL(DB_TBCV_RAMOATV1, ''),  ';',  ','),
                @V_OPERACAO       = REPLACE(DB_TBCV_OPERACAO, ';', ','),
                @V_CIDADE         = REPLACE(DB_TBCV_CIDADES, ';', ','),
                @V_LPRECO         = REPLACE(DB_TBCV_LPRECOS + ISNULL(DB_TBCV_LPRECOS1, ''), ';', ','),
                @V_TPPED          = REPLACE(DB_TBCV_TIPOPED, ';', ','),
                @V_CLICCOM        = REPLACE(DB_TBCV_CLASSCOM, ';', ','),
                @V_REPRES         = REPLACE(DB_TBCV_REPRES, ';', ','),
                @V_RAMOII         = REPLACE(DB_TBCV_RAMOII, ';', ','),
                @V_AREAATU        = REPLACE(DB_TBCV_AREAATU, ';', ','),
                @V_OPERLOG        = REPLACE(DB_TBCV_OPERLOG, ';', ','),
                @V_LABORATOR      = DB_TBCV_LABORATOR,
                @V_REGCOM         = DB_TBCV_REGCOM,
                @VDB_TBCV_CLIREDE = DB_TBCV_CLIREDE,
                @V_FORCAVENDAS    = REPLACE(DB_TBCV_FORCAVENDAS, ';', ',')
           FROM DB_TB_COND_VENDA
          WHERE DB_TBCV_CODIGO = @P_CODIGO;

         SET @V_COUNT = 1

         -- CASO O FILTRO DE CLINTES ESTEJA PREENCHIDO, CONSIDERA POR REDE, CNPJ OU CODIGO DO CLIENTE
         IF @V_CLIENTE IS NOT NULL
         BEGIN
        
            IF @VDB_TBCV_CLIREDE = 0
            BEGIN
               -- CODIGO DO CLIENTE
               SET @V_LISTA = @V_CLIENTE;
               SET @V_AUX   = 'CLIENTE';
            END
            ELSE IF @VDB_TBCV_CLIREDE = 1  -- REDE
            BEGIN

               SET @V_QUANTIDADE = LEN(@V_CLIENTE) - LEN(REPLACE(@V_CLIENTE, ',', '')) + 1;

               WHILE @V_COUNT <= @V_QUANTIDADE
               BEGIN

                 SET  @V_AUX = DBO.MERCF_PIECE(@V_CLIENTE, ',', @V_COUNT);

                 SET @V_RESULTADO = @V_AUX;

                 SELECT @V_RESULTADO = CAST(CAST(DB_CLI_VINCULO AS BIGINT) AS VARCHAR)
                   FROM DB_CLIENTE
                  WHERE DB_CLI_CODIGO = @V_AUX;

                 SET @V_LISTA = @V_LISTA + @V_RESULTADO + ',';
                 SET @V_COUNT = @V_COUNT + 1;

               END

               SET @V_LISTA = SUBSTRING(@V_LISTA, 1, LEN(@V_LISTA) - 1);
               SET @V_AUX   = 'REDE'

            END
            ELSE IF @VDB_TBCV_CLIREDE = 2  -- CNPJ
            BEGIN

               SET  @V_QUANTIDADE = LEN(@V_CLIENTE) -  LEN(REPLACE(@V_CLIENTE, ',', '')) + 1;

               WHILE @V_COUNT <= @V_QUANTIDADE
               BEGIN

                 SET @V_AUX = DBO.MERCF_PIECE(@V_CLIENTE, ',', @V_COUNT);

                 SET @V_RESULTADO = @V_AUX;

                 SELECT @V_RESULTADO = SUBSTRING(DB_CLI_CGCMF, 1, 8)                    
                   FROM DB_CLIENTE
                  WHERE DB_CLI_CODIGO = @V_AUX;               

                 SET @V_LISTA = @V_LISTA + @V_RESULTADO + ',';

                 SET @V_COUNT = @V_COUNT + 1;

               END

               SET @V_LISTA = SUBSTRING(@V_LISTA, 1, LEN(@V_LISTA) - 1);
               SET @V_AUX   = 'CNPJ';

            END

         END

         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'EMPRESA', @V_EMPRESA, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'ESTADO', @V_UF_DEST, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CLIENTE', @V_LISTA, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'RAMO', @V_RAMO, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'OPERACA', @V_OPERACAO, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CIDADE', @V_CIDADE, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'LPRECO', @V_LPRECO, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPPED', @V_TPPED, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CLACCLI', @V_CLICCOM, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'REPRES', @V_REPRES, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'RAMOII', @V_RAMOII, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'AREAATU', @V_AREAATU, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'OPERLOG', @V_OPERLOG, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'LABOROL', @V_LABORATOR, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'REGCOM', @V_REGCOM, @V_ID;
         EXEC DBO.MERCP_INSERE_MPV06_TEMP 'FORCAVENDAS', @V_FORCAVENDAS, @V_ID;

         DECLARE CUR_COND_VENDA CURSOR
         FOR SELECT DB_TBCV_CODIGO,                     DB_TBCV_DATA_INI,                             DB_TBCV_DATA_FIM,
                    REPLACE(DB_TBCV_EMPRESAS, ';', ','), REPLACE(DB_TBCV_ESTADOS,';',','),             REPLACE(DB_TBCVP_PRODUTOS,';',','),
                    REPLACE(DB_TBCVP_TIPOS,';',','),     REPLACE(DB_TBCVP_MARCAS,';',','),             REPLACE(DB_TBCV_CLIENTES,';',','),
                    REPLACE(DB_TBCV_RAMOATVS,';',',') + ISNULL(REPLACE(DB_TBCV_RAMOATV1,';',','), ''), REPLACE(DB_TBCV_OPERACAO,';',','),
                    DB_TBCV_SUFRAMA,                     REPLACE(DB_TBCV_CIDADES,';',','),             REPLACE((DB_TBCV_LPRECOS + ISNULL(DB_TBCV_LPRECOS1, '')), ';', ','),
                    DB_TBCV_TIPOPED,                     REPLACE(DB_TBCV_CLASSCOM,';',','),            DB_TBCVP_TPFRETE,
                    REPLACE(DB_TBCV_REPRES,';',','),     REPLACE(DB_TBCV_RAMOII,';',','),              REPLACE(DB_TBCV_AREAATU,';',','),
                    REPLACE(DB_TBCV_OPERLOG,';',','),    DB_TBCVP_PRZMED,                              DB_TBCVP_QTDEMAX,
                    DB_TBCVP_QTDEMIN,                    DB_TBCVP_CVI,                                 DB_TBCVP_COMIS,
                    DB_TBCVP_PEDMIN,                     DB_TBCVP_DESCTO,                              DB_TBCV_APLICA_AUT,
                    DB_TBCV_APLIC_OL,                    DB_TBCV_GRUPOEMP,                             DB_TBCV_TPAVAL,
                    DB_TBCV_LABORATOR,                   DB_TBCV_REGCOM,                               DB_TBCVP_LCPGTO,
                    DB_TBCV_CPGTO,                       DB_TBCV_TIPO,                                 DB_TBCV_IND_DESCTO,
                    DB_TBCVP_ACRESC,                     DB_TBCV_APLIC_OL,                             DB_TBCV_CLICONTR,
                    DB_TBCV_IE,                          DB_TBCV_AVALCLIVD,                            DB_TBCV_SUFRAMA,
                    DB_TBCV_APRESCLI,                    DB_TBCVP_DIAINI,                              DB_TBCVP_DIAFIN,
                    DB_TBCV_DTPEDVAL,                    DB_TBCV_APL_OLCLI,                            REPLACE(DB_TBCV_FORCAVENDAS, ';', ','),
                    ISNULL(DB_TBCV_FORMAPRECO, 0)
               FROM DB_TB_COND_VENDA,        DB_TB_COND_VPRZ
              WHERE DB_TBCVP_CODIGO = DB_TBCV_CODIGO
                AND DB_TBCV_CODIGO = @P_CODIGO
               OPEN CUR_COND_VENDA
              FETCH NEXT FROM CUR_COND_VENDA
               INTO @V_CODIGO_REGRA,    @V_DATA_INI,         @V_DATA_FIM,
                    @V_EMPRESA,         @V_ESTADOS,          @V_PRODUTOS,
                    @V_TIPO,            @V_MARCA,            @V_CLIENTES,
                    @V_RAMOATVS,        @V_OPERACAO,
                    @V_SUFRAMA,         @V_CIDADE,           @V_LPRECOS,
                    @V_TIPOPED,         @V_CLASSCOM,         @V_TIPO_FRETE,
                    @V_REPRES,          @V_RAMOII,           @V_AREAATU,
                    @V_OPERLOG,         @VDB_TBCVP_PRZMED,   @VDB_TBCVP_QTDEMAX,
                    @VDB_TBCVP_QTDEMIN, @VDB_TBCVP_CVI,      @VDB_TBCVP_COMIS,
                    @VDB_TBCVP_PEDMIN,  @VDB_TBCVP_DESCTO,   @VDB_TBCV_APLICA_AUT,
                    @VDB_TBCV_APLIC_OL, @VDB_TBCV_GRUPOEMP,  @VDB_TBCV_TPAVAL,
                    @V_LABORATOR,       @V_REGCOM,           @VDB_TBCVP_LCPGTO,
                    @VDB_TBCV_CPGTO,    @VDB_TBCV_TIPO,      @V_IND_DESCTO,
                    @VDB_TBCVP_ACRESC,  @VDB_TBCV_APLIC_OL,  @VDB_TBCV_CLICONTR,
                    @VDB_TBCV_IE,       @VDB_TBCV_AVALCLIVD, @VDB_TBCV_SUFRAMA,
                    @VDB_TBCV_APRESCLI, @VDB_TBCVP_DIAINI,   @VDB_TBCVP_DIAFIN,
                    @VDB_TBCV_DTPEDVAL, @VDB_TBCV_APL_OLCLI, @V_FORCAVENDAS,
                    @DB_TBCV_FORMAPRECO
              WHILE @@FETCH_STATUS = 0
             BEGIN

               IF ISNULL(@VDB_TBCVP_LCPGTO, '') <> ''
               BEGIN
                  SET @V_COND_PGTO = REPLACE(@VDB_TBCVP_LCPGTO, ';', ',');
               END
               ELSE
               BEGIN
                  IF ISNULL(@VDB_TBCV_CPGTO, '') <> ''
                     SET @V_COND_PGTO = REPLACE(@VDB_TBCV_CPGTO, ';', ',');
                  ELSE
                     SET @V_COND_PGTO = '';
               END

               EXECUTE DBO.MERCP_HASH_COND_VENDA '0',                   -- 01
                                                 @V_CODIGO_REGRA,       -- 02
                                                 0,                     -- 03
                                                 @V_DATA_INI,           -- 04
                                                 @V_DATA_FIM,           -- 05
                                                 @V_EMPRESA,            -- 06
                                                 '',                    -- 07
                                                 @V_ESTADOS,            -- 08
                                                 @V_PRODUTOS,           -- 09
                                                 @V_TIPO,               -- 10
                                                 @V_MARCA,              -- 11
                                                 '',                    -- 12
                                                 '',                    -- 13
                                                 @V_CLIENTES,           -- 14
                                                 @V_RAMOATVS,           -- 15
                                                 @V_OPERACAO,           -- 16
                                                 '',                    -- 17
                                                 @V_SUFRAMA,            -- 18
                                                 '',                    -- 19
                                                 -1,                    -- 20
                                                 -1,                    -- 21
                                                 '',                    -- 22
                                                 '',                    -- 23
                                                 @V_CIDADE,             -- 24
                                                 '',                    -- 25
                                                 @V_LPRECOS,            -- 26
                                                 @V_TIPOPED,            -- 27
                                                 @V_CLASSCOM,           -- 28
                                                 0,                     -- 29
                                                 0,                     -- 30
                                                 0,                     -- 31
                                                 @V_TIPO_FRETE,         -- 32
                                                 -- COND VENDA
                                                 @V_REPRES,             -- 33
                                                 @V_RAMOII,             -- 34
                                                 @V_COND_PGTO,          -- 35
                                                 @V_AREAATU,            -- 36
                                                 @V_OPERLOG,            -- 37
                                                 @VDB_TBCVP_PRZMED,     -- 38
                                                 @VDB_TBCVP_QTDEMAX,    -- 39
                                                 @VDB_TBCVP_QTDEMIN,    -- 40
                                                 @VDB_TBCVP_CVI,        -- 41
                                                 @VDB_TBCVP_COMIS,      -- 42
                                                 @VDB_TBCVP_PEDMIN,     -- 43
                                                 @VDB_TBCVP_DESCTO,     -- 44
                                                 @VDB_TBCV_APLICA_AUT,  -- 45
                                                 @VDB_TBCV_GRUPOEMP,    -- 46
                                                 @VDB_TBCV_TPAVAL,      -- 47
                                                 @VDB_TBCV_APLIC_OL,    -- 48                                  
                                                 @V_LABORATOR,
                                                 @V_REGCOM,
                                                 @V_ID,
                                                 @VDB_TBCVP_ACRESC,
                                                 @VDB_TBCV_APLIC_OL,
                                                 @VDB_TBCV_CLICONTR,
                                                 @VDB_TBCV_IE,
                                                 @VDB_TBCV_AVALCLIVD,
                                                 @VDB_TBCV_SUFRAMA,
                                                 @VDB_TBCV_APRESCLI,
                                                 @VDB_TBCVP_DIAINI,
                                                 @VDB_TBCVP_DIAFIN,
                                                 @V_AUX,
                                                 @VDB_TBCV_TIPO,
                                                 @V_IND_DESCTO,
                                                 @VDB_TBCV_DTPEDVAL,
                                                 @VDB_TBCV_APL_OLCLI,
                                                 @V_FORCAVENDAS,
                                                 @DB_TBCV_FORMAPRECO
                                    
        FETCH NEXT FROM CUR_COND_VENDA
          INTO   @V_CODIGO_REGRA,       @V_DATA_INI,         @V_DATA_FIM,         
                 @V_EMPRESA,            @V_ESTADOS,           @V_PRODUTOS,            
                 @V_TIPO,                @V_MARCA,             @V_CLIENTES,         
                 @V_RAMOATVS,           @V_OPERACAO,         
                 @V_SUFRAMA,            @V_CIDADE,             @V_LPRECOS ,
                 @V_TIPOPED,            @V_CLASSCOM,         @V_TIPO_FRETE,             
                 @V_REPRES,              @V_RAMOII,             @V_AREAATU,
                 @V_OPERLOG,               @VDB_TBCVP_PRZMED,   @VDB_TBCVP_QTDEMAX,
                 @VDB_TBCVP_QTDEMIN,    @VDB_TBCVP_CVI,         @VDB_TBCVP_COMIS,    
                 @VDB_TBCVP_PEDMIN,     @VDB_TBCVP_DESCTO,   @VDB_TBCV_APLICA_AUT,    
                 @VDB_TBCV_APLIC_OL,    @VDB_TBCV_GRUPOEMP,  @VDB_TBCV_TPAVAL,  
                 @V_LABORATOR,            @V_REGCOM,             @VDB_TBCVP_LCPGTO,    
                 @VDB_TBCV_CPGTO,       @VDB_TBCV_TIPO,         @V_IND_DESCTO,
                 @VDB_TBCVP_ACRESC,        @VDB_TBCV_APLIC_OL,  @VDB_TBCV_CLICONTR,
                 @VDB_TBCV_IE,             @VDB_TBCV_AVALCLIVD, @VDB_TBCV_SUFRAMA,
                 @VDB_TBCV_APRESCLI,     @VDB_TBCVP_DIAINI,     @VDB_TBCVP_DIAFIN,
                 @VDB_TBCV_DTPEDVAL,    @VDB_TBCV_APL_OLCLI, @V_FORCAVENDAS,
                 @DB_TBCV_FORMAPRECO
          END
          CLOSE CUR_COND_VENDA
        DEALLOCATE CUR_COND_VENDA

        BEGIN TRY
        
          DELETE MPV06
           WHERE PV06_TIPO = @P_TIPO
             AND PV06_POLITICA = @P_CODIGO;
        
          INSERT INTO MPV06
            (PV06_CONTROLE,
             PV06_SEQ,
             PV06_TIPO,
             PV06_POLITICA,
             PV06_IDENT,
             PV06_HASH,
             PV06_PRAZOMIN,
             PV06_PRAZOMAX,
             PV06_QTDEMIN,
             PV06_QTDEMAX,
             PV06_CVI,
             PV06_COMIS,
             PV06_MIX,
             PV06_DATA_INI,
             PV06_DATA_FIM,
             PV06_PRECOLIQ,
             PV06_BONIF,
             PV06_BONQTD,
             PV06_BONVLR,
             PV06_PEDMIN,
             PV06_PARTIC,
             PV06_PARTMAX,
             PV06_ACRVLR,
             PV06_VALMIN,
             PV06_VALMAX,
             PV06_DESCTO,
             PV06_PRODUTO,
             PV06_AVALIACAO,
             PV06_APLIC_OL,
             PV06_QTDEMULT,
             PV06_PARTMAXFIS,
             PV06_FATCONV,
             PV06_APLICBRUTO,
             PV06_APLICACAO,
             PV06_IDREGRA,
             PV06_DESCTOMIN,
             PV06_DESCTOMAX,
             PV06_GRUPOEMP,
             PV06_MSGERRO,
             PV06_PARTSOBRE,
             PV06_TPAVALIACAO,
             PV06_DIASAMAIS,
             PV06_VALMIX,
             PV06_CLICONTRIB,
             PV06_CLIIE,
             PV06_CLIVENDOR,
             PV06_CLISUFRAMA,
             PV06_APRESCLI,
             PV06_DIAINI,
             PV06_DIAFIN,
             PV06_VALIDADE,
             PV06_APLIC_OLCLI,
             PV06_FORMAPRECO)
            SELECT PV06_CONTROLE,
                   ROW_NUMBER() OVER(ORDER BY PV06_CONTROLE) +
                   (SELECT ISNULL(MAX(PV06_SEQ), 0)
                      FROM MPV06
                     WHERE PV06_CONTROLE = MPV06_TEMP_HASH.PV06_CONTROLE),
                   PV06_TIPO,
                   PV06_POLITICA,
                   PV06_IDENT,
                   PV06_HASH,
                   PV06_PRAZOMIN,
                   PV06_PRAZOMAX,
                   PV06_QTDEMIN,
                   PV06_QTDEMAX,
                   PV06_CVI,
                   PV06_COMIS,
                   PV06_MIX,
                   PV06_DATA_INI,
                   PV06_DATA_FIM,
                   PV06_PRECOLIQ,
                   PV06_BONIF,
                   PV06_BONQTD,
                   PV06_BONVLR,
                   PV06_PEDMIN,
                   PV06_PARTIC,
                   PV06_PARTMAX,
                   PV06_ACRVLR,
                   PV06_VALMIN,
                   PV06_VALMAX,
                   PV06_DESCTO,
                   PV06_PRODUTO,
                   PV06_AVALIACAO,
                   PV06_APLIC_OL,
                   PV06_QTDEMULT,
                   PV06_PARTMAXFIS,
                   PV06_FATCONV,
                   PV06_APLICBRUTO,
                   PV06_APLICACAO,
                   PV06_IDREGRA,
                   PV06_DESCTOMIN,
                   PV06_DESCTOMAX,
                   PV06_GRUPOEMP,
                   PV06_MSGERRO,
                   PV06_PARTSOBRE,
                   PV06_TPAVALIACAO,
                   PV06_DIASAMAIS,
                   PV06_VALMIX,
                   PV06_CLICONTRIB,
                   PV06_CLIIE,
                   PV06_CLIVENDOR,
                   PV06_CLISUFRAMA,
                   PV06_APRESCLI,
                   PV06_DIAINI,
                   PV06_DIAFIN,
                   PV06_VALIDADE,
                   PV06_APLIC_OLCLI,
                   PV06_FORMAPRECO
              FROM MPV06_TEMP_HASH
             WHERE PV06_POLITICA = @P_CODIGO
               AND PV06_TIPO = @P_TIPO;
        
          UPDATE MPV06
             SET PV06_DATA_ALTER = GETDATE()
           WHERE PV06_TIPO = @P_TIPO
             AND PV06_POLITICA = (SELECT TOP 1 PV06_POLITICA
                                    FROM MPV06_TEMP_HASH)

          DELETE FROM MPV06_TEMP_HASH
           WHERE PV06_TIPO = @P_TIPO
             AND PV06_POLITICA = @P_CODIGO;
                  
          DELETE FROM MPV04
           WHERE NOT
                  (EXISTS
                   (SELECT 1 FROM MPV06 WHERE PV04_CONTROLE = PV06_CONTROLE))
             AND NOT
                  (EXISTS
                   (SELECT 1 FROM MPF01 WHERE PV04_CONTROLE = PF01_CONTROLE));
          DELETE FROM MPV05
           WHERE NOT
                  (EXISTS
                   (SELECT 1 FROM MPV06 WHERE PV05_CONTROLE = PV06_CONTROLE))
             AND NOT
                  (EXISTS
                   (SELECT 1 FROM MPF01 WHERE PV05_CONTROLE = PF01_CONTROLE));
        
        
      END TRY
      BEGIN CATCH
            SET @ERRO = 'ERRO AO INSERIR MPV06: TIPO ' + @P_TIPO +
                          ' POLITICA: ' + @P_CODIGO + ' : ' + ERROR_MESSAGE()
            INSERT INTO DBS_ERROS_TRIGGERS
              (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
            VALUES
              (@ERRO, GETDATE(), 'MERCP_INSERE_HASH');
            
        END CATCH
              
      
        DELETE TEMP_MPV06_EMPRESA WHERE ID = @V_ID;
        DELETE TEMP_MPV06_REPRES WHERE ID = @V_ID;
        DELETE TEMP_MPV06_RAMO WHERE ID = @V_ID;
        DELETE TEMP_MPV06_CLIENTE WHERE ID = @V_ID;
        DELETE TEMP_MPV06_LPRECO WHERE ID = @V_ID;
        DELETE TEMP_MPV06_RAMOII WHERE ID = @V_ID;
        DELETE TEMP_MPV06_OPERACA WHERE ID = @V_ID;
        DELETE TEMP_MPV06_CIDADE WHERE ID = @V_ID;
        DELETE TEMP_MPV06_TPPED WHERE ID = @V_ID;
        DELETE TEMP_MPV06_OPERLOG WHERE ID = @V_ID;
        DELETE TEMP_MPV06_LABOROL WHERE ID = @V_ID;
        DELETE TEMP_MPV06_AREAATU WHERE ID = @V_ID;
        DELETE TEMP_MPV06_UFEMP WHERE ID = @V_ID;
        DELETE TEMP_MPV06_CLACCLI WHERE ID = @V_ID;
        DELETE TEMP_MPV06_REGCOM WHERE ID = @V_ID;
        DELETE TEMP_MPV06_CPGTOIT WHERE ID = @V_ID;
        DELETE TEMP_MPV06_FORCAVENDAS WHERE ID = @V_ID;
    
      
      END -- @V_SITUACAO = 0
    
    END -- VREGRA IS NOT NULL
    ELSE
    BEGIN

        DELETE MPV06
           WHERE PV06_TIPO = @P_TIPO
             AND PV06_POLITICA = @P_CODIGO;

        DELETE FROM MPV04
           WHERE NOT
                  (EXISTS
                   (SELECT 1 FROM MPV06 WHERE PV04_CONTROLE = PV06_CONTROLE))
             AND NOT
                  (EXISTS
                   (SELECT 1 FROM MPF01 WHERE PV04_CONTROLE = PF01_CONTROLE));
          DELETE FROM MPV05
           WHERE NOT
                  (EXISTS
                   (SELECT 1 FROM MPV06 WHERE PV05_CONTROLE = PV06_CONTROLE))
             AND NOT
                  (EXISTS
                   (SELECT 1 FROM MPF01 WHERE PV05_CONTROLE = PF01_CONTROLE));
                   
    END

END  -- IF @P_TIPO = 'C'
ELSE
IF @P_TIPO = 'P'  -- PROMOCAO DE VENDA
BEGIN

      IF @P_CODIGO IS NOT NULL
      BEGIN
          DELETE MPV06_TEMP_HASH
           WHERE PV06_TIPO = @P_TIPO
             AND PV06_POLITICA = @P_CODIGO;
                   
            SET @V_SITUACAO = 'I';
            SELECT @V_SITUACAO = DB_TBPRM_SITUACAO              
              FROM DB_TB_PROMOCAO
             WHERE DB_TBPRM_CODIGO = @P_CODIGO;
         
          IF @V_SITUACAO = 'A'
          BEGIN
            SET @V_ID = ROUND(RAND() * 1000000, 0)
      
            SELECT @V_EMPRESA = REPLACE(DB_TBPRM_EMPRESAS, ';', ','),
                   @V_UF_DEST = REPLACE(DB_TBPRM_ESTADOS, ';', ','),
                   @V_MARCA = REPLACE(DB_TBPRM_MARPRM, ';', ','),
                   @V_FAMILIA = REPLACE(DB_TBPRM_FAMPRM, ';', ','),
                   @V_CLIENTE = REPLACE(DB_TBPRM_CLIENTES, ';', ','),
                   @V_RAMO = REPLACE(DB_TBPRM_RAMOATV + ISNULL(DB_TBPRM_RAMOATV1, ''),  ';',  ','),  
                   @V_LPRECO = REPLACE(ISNULL(DB_TBPRM_LPRECOS, '') +   ISNULL(DB_TBPRM_LPRECOS1, ''), ';',  ','),
                   @V_TPPED = REPLACE(DB_TBPRM_TPPED, ';', ','),
                   @V_CLICCOM = REPLACE(DB_TBPRM_CLASCOM, ';', ','),
                   @V_REPRES = REPLACE(DB_TBPRM_REPRES, ';', ','),
                   @V_RAMOII = REPLACE(DB_TBPRM_RAMOII, ';', ','),
                   @V_AREAATU = REPLACE(DB_TBPRM_AREAATU, ';', ','),
                   @V_OPERLOG = REPLACE(DB_TBPRM_OPERLOG, ';', ','),
                   @V_REGCOM = REPLACE(DB_TBPRM_REGCOM, ';', ','),
                   @V_LABORATOR = REPLACE(DB_TBPRM_LABORATOR, ';', ','),
                   @V_FORCAVENDAS = REPLACE(DB_TBPRM_FORCAVENDAS, ';', ',')     
              FROM DB_TB_PROMOCAO
             WHERE DB_TBPRM_CODIGO = @P_CODIGO
      
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'MARCA', @V_MARCA, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'FAMILIA', @V_FAMILIA, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'EMPRESA', @V_EMPRESA, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'ESTADO', @V_UF_DEST, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CLIENTE', @V_CLIENTE, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'RAMO', @V_RAMO, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'LPRECO', @V_LPRECO, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPPED', @V_TPPED, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CLACCLI', @V_CLICCOM, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'REPRES', @V_REPRES, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'RAMOII', @V_RAMOII, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'AREAATU', @V_AREAATU, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'OPERLOG', @V_OPERLOG, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'LABOROL', @V_LABORATOR, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'REGCOM', @V_REGCOM, @V_ID
            EXEC DBO.MERCP_INSERE_MPV06_TEMP 'FORCAVENDAS', @V_FORCAVENDAS, @V_ID




            DECLARE CUR_PROMOCAO CURSOR
         FOR SELECT DB_TBPRM_CODIGO,                       DB_TBPRM_DATA_INI,                            DB_TBPRM_DATA_FIM,
                     REPLACE(RTRIM(DB_TBPRM_EMPRESAS), ';', ','), REPLACE(DB_TBPRM_ESTADOS, ';', ','),      REPLACE(DB_TBPRMD_PRODS, ';', ','),
                     REPLACE(DB_TBPRM_MARPRM, ';', ','),   REPLACE(DB_TBPRM_FAMPRM, ';', ','),        REPLACE(DB_TBPRM_CLIENTES, ';', ','),
                    REPLACE(DB_TBPRM_RAMOATV + ISNULL(DB_TBPRM_RAMOATV1, ''), ';', ','),            REPLACE(DB_TBPRMD_CIDADE, ';', ','),                    
                    REPLACE(ISNULL(DB_TBPRM_LPRECOS, '') + ISNULL(DB_TBPRM_LPRECOS1, ''), ';', ','), REPLACE(DB_TBPRM_TPPED, ';', ','),
                    REPLACE(DB_TBPRM_CLASCOM, ';', ','),  DB_TBPRMD_TPFRETE,                         REPLACE(DB_TBPRM_REPRES, ';', ','),
                    REPLACE(DB_TBPRM_RAMOII, ';', ','),      REPLACE(DB_TBPRM_AREAATU, ';', ','),        REPLACE(DB_TBPRM_OPERLOG, ';', ','),
                    DB_TBPRMD_QTDEMAX,      DB_TBPRMD_QTDEMIN,      DB_TBPRMD_PEDMIN,       DB_TBPRM_RVALPDV, 
                    DB_TBPRM_REGCOM,        DB_TBPRM_LABORATOR,        DB_TBPRMD_REFERP,         DB_TBPRMD_PCOMIS, 
                    DB_TBPRM_LSTMIXV,         DB_TBPRMD_PRECOLIQ,        DB_TBPRMD_BONIF,        DB_TBPRMD_BONQTD,
                    DB_TBPRMD_BONVLR,        DB_TBPRMD_PARTIC,        DB_TBPRMD_PARTMAX,         DB_TBPRMD_ACRVLR,
                    DB_TBPRMD_VALMIN,        DB_TBPRMD_VALMAX,         DB_TBPRM_APLIC_AUT,        DB_TBPRMD_DIAINI, 
                    DB_TBPRMD_DIAFIN,         DB_TBPRM_APRESCLI,        DB_TBPRM_DIASMAIS,        DB_TBPRMD_DESCONTO, 
                    DB_TBPRM_APLIC_OL,        DB_TBPRM_MIXVDA,        DB_TBPRM_PRODPRM,       DB_TBPRM_IND_DCTO,
                    DB_TBPRM_TIPOPRM,
                    DB_TBPRM_DCTQTDMUL,     DB_TBPRM_PPARTIC,        DB_TBPRM_CLICONTR,        DB_TBPRM_DTPEDVAL,
                    DB_TBPRM_APL_OLCLI,     DB_TBPRM_TIPO,          DB_TBPRM_PRODFORA,      DB_TBPRM_GRPPRM,
                    REPLACE(DB_TBPRM_FORCAVENDAS, ';', ',')    
              FROM DB_TB_PROMOCAO, DB_TB_PROMOCAO_DCT
             WHERE DB_TBPRM_CODIGO = DB_TBPRMD_CODIGO
               AND DB_TBPRM_CODIGO = @P_CODIGO
            OPEN CUR_PROMOCAO
           FETCH NEXT FROM CUR_PROMOCAO
            INTO @V_CODIGO_REGRA,       @V_DATA_INI,        @V_DATA_FIM,         
                 @V_EMPRESA,             @V_ESTADOS,         @V_PRODUTOS,            
                 @V_MARCA,                @V_FAMILIA,         @V_CLIENTES,         
                 @V_RAMOATVS,              @V_CIDADE,            
                 @V_LPRECOS,            @V_TIPOPED,             
                 @V_CLASSCOM,            @V_TIPO,              @V_REPRES,                
                 @V_RAMOII,                @V_AREAATU,            @V_OPERLOG,
                 @VDB_TBCVP_QTDEMAX,    @VDB_TBCVP_QTDEMIN,    @V_PEDMIN,           @V_RVALPDV,
                 @V_REGCOM,                @V_LABORATOR,        @V_REFERP,             @VDB_TBCVP_COMIS,
                 @V_LSTMIXV,            @V_PRECOLIQ,         @V_BONIF,             @V_BONQTD,
                 @V_BONVLR,                @V_PARTIC,            @V_PARTMAX,             @V_ACRVLR,
                 @V_VALMIN,                @V_VALMAX,          @VDB_TBCV_APLICA_AUT, @V_DIAINI, 
                 @V_DIAFIN,             @V_APRESCLI,        @V_DIASMAIS,         @V_DESCONTO,         
                 @VDB_TBCV_APLIC_OL,    @V_MIXVDA,          @PDB_TBPRM_PRODPRM,  @V_IND_DESCTO,
                 @VDB_TBPRM_TIPOPRM,
                 @VDB_TBPRM_DCTQTDMUL, @VDB_TBPRM_PPARTIC,    @VDB_TBPRM_CLICONTR, @VDB_TBPRM_DTPEDVAL,
                 @VDB_TBPRM_APL_OLCLI, @VPDB_TBPRM_TIPO,    @VDB_TBPRM_PRODFORA, @VDB_TBPRM_GRPPRM,
                 @V_FORCAVENDAS
        WHILE @@FETCH_STATUS = 0
           BEGIN       
              EXEC DBO.MERCP_HASH_PROMOCAO_VENDA 0, -- 01
                                        @V_CODIGO_REGRA, -- 02
                                        0, -- 03
                                        @V_DATA_INI, -- 04
                                        @V_DATA_FIM, -- 05
                                        @V_EMPRESA, -- 06
                                        '', -- 07
                                        @V_ESTADOS, -- 08
                                        @V_PRODUTOS, -- 09
                                        @VDB_TBPRM_TIPOPRM, -- 10
                                        @V_MARCA, -- 11
                                        @V_FAMILIA, -- 12
                                        @VDB_TBPRM_GRPPRM, -- 13
                                        @V_CLIENTE,  -- 14
                                        @V_RAMO, -- 15
                                        '', -- 16
                                        '', -- 17
                                        '', -- 18
                                        '', -- 19
                                        -1, -- 20
                                        -1, -- 21
                                        '', -- 22
                                        '', -- 23
                                        @V_CIDADE,  -- 24
                                        '', -- 25
                                        @V_LPRECOS, -- 26
                                        @V_TPPED,  -- 27
                                        @V_CLASSCOM,  -- 28
                                        0, -- 29
                                        0, -- 30
                                        0, -- 31
                                        @V_TIPO, -- 32
                                    
                                        ----PROMOCAO DE VENDA
                                    
                                        @V_REPRES,  -- 33
                                        @V_RAMOII,  -- 34
                                        '', -- 35
                                        @V_AREAATU, -- 36
                                        @V_OPERLOG,  -- 37
                                        @VDB_TBCVP_QTDEMAX, -- 38
                                        @VDB_TBCVP_QTDEMIN, -- 39
                                        @V_PEDMIN, -- 40
                                        @V_RVALPDV, -- 41
                                        @V_REGCOM, -- 42
                                        @V_LABORATOR, -- 43
                                        @V_REFERP, -- 44
                                        @VDB_TBCVP_COMIS, -- 45
                                        @V_LSTMIXV, -- 46
                                        @V_PRECOLIQ, -- 47
                                        @V_BONIF, -- 48
                                        @V_BONQTD, -- 49
                                        @V_BONVLR, -- 50
                                        @V_PARTIC, -- 51
                                        @V_PARTMAX, -- 52
                                        @V_ACRVLR, -- 53
                                        @V_VALMIN, --54
                                        @V_VALMAX, -- 55
                                        @VDB_TBCV_APLICA_AUT, -- 56
                                        @V_DIAINI, -- 57
                                        @V_DIAFIN, -- 58
                                        @V_APRESCLI, -- 59
                                        @V_DIASMAIS, -- 60
                                        @V_DESCONTO, -- 61
                                        @VDB_TBCV_APLIC_OL, -- 62
                                        @V_MIXVDA, -- 63
                                        @V_ID,
                                        @PDB_TBPRM_PRODPRM,
                                        @V_IND_DESCTO,
                                        @VDB_TBPRM_DCTQTDMUL,
                                        @VDB_TBPRM_PPARTIC,
                                        @VDB_TBPRM_CLICONTR,
                                        @VDB_TBPRM_DTPEDVAL,
                                        @VDB_TBPRM_APL_OLCLI,
                                        @VPDB_TBPRM_TIPO,
                                        @VDB_TBPRM_PRODFORA,
                                        @V_FORCAVENDAS

        FETCH NEXT FROM CUR_PROMOCAO
      INTO  @V_CODIGO_REGRA,       @V_DATA_INI,        @V_DATA_FIM,         
                 @V_EMPRESA,             @V_ESTADOS,         @V_PRODUTOS,            
                 @V_MARCA,                @V_FAMILIA,         @V_CLIENTES,         
                 @V_RAMOATVS,              @V_CIDADE,            
                 @V_LPRECOS,            @V_TIPOPED,             
                 @V_CLASSCOM,            @V_TIPO,              @V_REPRES,                
                 @V_RAMOII,                @V_AREAATU,            @V_OPERLOG,
                 @VDB_TBCVP_QTDEMAX,    @VDB_TBCVP_QTDEMIN,    @V_PEDMIN,           @V_RVALPDV,
                 @V_REGCOM,                @V_LABORATOR,        @V_REFERP,             @VDB_TBCVP_COMIS,
                 @V_LSTMIXV,            @V_PRECOLIQ,         @V_BONIF,             @V_BONQTD,
                 @V_BONVLR,                @V_PARTIC,            @V_PARTMAX,             @V_ACRVLR,
                 @V_VALMIN,                @V_VALMAX,          @VDB_TBCV_APLICA_AUT, @V_DIAINI, 
                 @V_DIAFIN,             @V_APRESCLI,        @V_DIASMAIS,         @V_DESCONTO,         
                 @VDB_TBCV_APLIC_OL,     @V_MIXVDA,         @PDB_TBPRM_PRODPRM,  @V_IND_DESCTO,
                 @VDB_TBPRM_TIPOPRM,
                 @VDB_TBPRM_DCTQTDMUL, @VDB_TBPRM_PPARTIC,    @VDB_TBPRM_CLICONTR, @VDB_TBPRM_DTPEDVAL,
                 @VDB_TBPRM_APL_OLCLI, @VPDB_TBPRM_TIPO,    @VDB_TBPRM_PRODFORA, @VDB_TBPRM_GRPPRM,
                 @V_FORCAVENDAS
      END
      CLOSE CUR_PROMOCAO
    DEALLOCATE CUR_PROMOCAO


          BEGIN TRY
        
              DELETE MPV06
               WHERE PV06_TIPO = @P_TIPO
                 AND PV06_POLITICA = @P_CODIGO;
        PRINT 'INICIO'
        SELECT * FROM MPV06_TEMP_HASH
              INSERT INTO MPV06
                (PV06_CONTROLE,
                 PV06_SEQ,
                 PV06_TIPO,
                 PV06_POLITICA,
                 PV06_IDENT,
                 PV06_HASH,
                 PV06_PRAZOMIN,
                 PV06_PRAZOMAX,
                 PV06_QTDEMIN,
                 PV06_QTDEMAX,
                 PV06_CVI,
                 PV06_COMIS,
                 PV06_MIX,
                 PV06_DATA_INI,
                 PV06_DATA_FIM,
                 PV06_PRECOLIQ,
                 PV06_BONIF,
                 PV06_BONQTD,
                 PV06_BONVLR,
                 PV06_PEDMIN,
                 PV06_PARTIC,
                 PV06_PARTMAX,
                 PV06_ACRVLR,
                 PV06_VALMIN,
                 PV06_VALMAX,
                 PV06_DESCTO,
                 PV06_PRODUTO,
                 PV06_AVALIACAO,
                 PV06_APLIC_OL,
                 PV06_QTDEMULT,
                 PV06_PARTMAXFIS,
                 PV06_FATCONV,
                 PV06_APLICBRUTO,
                 PV06_APLICACAO,
                 PV06_IDREGRA,
                 PV06_DESCTOMIN,
                 PV06_DESCTOMAX,
                 PV06_GRUPOEMP,
                 PV06_MSGERRO,
                 PV06_PARTSOBRE,
                 PV06_TPAVALIACAO,
                 PV06_DIASAMAIS,
                 PV06_VALMIX,
                 PV06_CLICONTRIB,
                 PV06_CLIIE,
                 PV06_CLIVENDOR,
                 PV06_CLISUFRAMA,
                 PV06_APRESCLI,
                 PV06_DIAINI,
                 PV06_DIAFIN,
                 PV06_VALIDADE,
                 PV06_APLIC_OLCLI,
                 PV06_MIXEXCECAO)
                SELECT PV06_CONTROLE,
                       ROW_NUMBER() OVER(ORDER BY PV06_CONTROLE) +
                       (SELECT ISNULL(MAX(PV06_SEQ), 0)
                          FROM MPV06
                         WHERE PV06_CONTROLE = MPV06_TEMP_HASH.PV06_CONTROLE),
                       PV06_TIPO,
                       PV06_POLITICA,
                       PV06_IDENT,
                       PV06_HASH,
                       PV06_PRAZOMIN,
                       PV06_PRAZOMAX,
                       PV06_QTDEMIN,
                       PV06_QTDEMAX,
                       PV06_CVI,
                       PV06_COMIS,
                       PV06_MIX,
                       PV06_DATA_INI,
                       PV06_DATA_FIM,
                       PV06_PRECOLIQ,
                       PV06_BONIF,
                       PV06_BONQTD,
                       PV06_BONVLR,
                       PV06_PEDMIN,
                       PV06_PARTIC,
                       PV06_PARTMAX,
                       PV06_ACRVLR,
                       PV06_VALMIN,
                       PV06_VALMAX,
                       PV06_DESCTO,
                       PV06_PRODUTO,
                       PV06_AVALIACAO,
                       PV06_APLIC_OL,
                       PV06_QTDEMULT,
                       PV06_PARTMAXFIS,
                       PV06_FATCONV,
                       PV06_APLICBRUTO,
                       PV06_APLICACAO,
                       PV06_IDREGRA,
                       PV06_DESCTOMIN,
                       PV06_DESCTOMAX,
                       PV06_GRUPOEMP,
                       PV06_MSGERRO,
                       PV06_PARTSOBRE,
                       PV06_TPAVALIACAO,
                       PV06_DIASAMAIS,
                       PV06_VALMIX,
                       PV06_CLICONTRIB,
                       PV06_CLIIE,
                       PV06_CLIVENDOR,
                       PV06_CLISUFRAMA,
                       PV06_APRESCLI,
                       PV06_DIAINI,
                       PV06_DIAFIN,
                       PV06_VALIDADE,
                       PV06_APLIC_OLCLI,
                       PV06_MIXEXCECAO
                  FROM MPV06_TEMP_HASH
                 WHERE PV06_POLITICA = @P_CODIGO
                   AND PV06_TIPO = @P_TIPO;
        
              UPDATE MPV06
                 SET PV06_DATA_ALTER = GETDATE()
               WHERE PV06_TIPO = @P_TIPO
                 AND PV06_POLITICA = (SELECT TOP 1 PV06_POLITICA
                                        FROM MPV06_TEMP_HASH)

              DELETE FROM MPV06_TEMP_HASH
               WHERE PV06_TIPO = @P_TIPO
                 AND PV06_POLITICA = @P_CODIGO;
                  
              DELETE FROM MPV04
               WHERE NOT
                      (EXISTS
                       (SELECT 1 FROM MPV06 WHERE PV04_CONTROLE = PV06_CONTROLE))
                 AND NOT
                      (EXISTS
                       (SELECT 1 FROM MPF01 WHERE PV04_CONTROLE = PF01_CONTROLE));
              DELETE FROM MPV05
               WHERE NOT
                      (EXISTS
                       (SELECT 1 FROM MPV06 WHERE PV05_CONTROLE = PV06_CONTROLE))
                 AND NOT
                      (EXISTS
                       (SELECT 1 FROM MPF01 WHERE PV05_CONTROLE = PF01_CONTROLE));
        
        
          END TRY
          BEGIN CATCH
                SET @ERRO = 'ERRO AO INSERIR MPV06: TIPO ' + @P_TIPO +
                              ' POLITICA: ' + @P_CODIGO + ' : ' + ERROR_MESSAGE()
                INSERT INTO DBS_ERROS_TRIGGERS
                  (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
                VALUES
                  (@ERRO, GETDATE(), 'MERCP_INSERE_HASH');
            
            END CATCH


      
            DELETE TEMP_MPV06_EMPRESA WHERE ID = @V_ID;
            DELETE TEMP_MPV06_REPRES WHERE ID = @V_ID;
            DELETE TEMP_MPV06_RAMO WHERE ID = @V_ID;
            DELETE TEMP_MPV06_CLIENTE WHERE ID = @V_ID;
            DELETE TEMP_MPV06_LPRECO WHERE ID = @V_ID;
            DELETE TEMP_MPV06_RAMOII WHERE ID = @V_ID;
            DELETE TEMP_MPV06_FAMILIA WHERE ID = @V_ID;
            DELETE TEMP_MPV06_TPPED WHERE ID = @V_ID;
            DELETE TEMP_MPV06_OPERLOG WHERE ID = @V_ID;
            DELETE TEMP_MPV06_LABOROL WHERE ID = @V_ID;
            DELETE TEMP_MPV06_AREAATU WHERE ID = @V_ID;
            DELETE TEMP_MPV06_UFEMP WHERE ID = @V_ID;
            DELETE TEMP_MPV06_CLACCLI WHERE ID = @V_ID;
            DELETE TEMP_MPV06_REGCOM WHERE ID = @V_ID;
            DELETE TEMP_MPV06_REFERPR WHERE ID = @V_ID;
            DELETE TEMP_MPV06_FORCAVENDAS WHERE ID = @V_ID;
        
      
      END -- V_SITUACAO = 0
      ELSE
      BEGIN

        DELETE MPV06
           WHERE PV06_TIPO = @P_TIPO
             AND PV06_POLITICA = @P_CODIGO;

        DELETE FROM MPV04
           WHERE NOT
                  (EXISTS
                   (SELECT 1 FROM MPV06 WHERE PV04_CONTROLE = PV06_CONTROLE))
             AND NOT
                  (EXISTS
                   (SELECT 1 FROM MPF01 WHERE PV04_CONTROLE = PF01_CONTROLE));
          DELETE FROM MPV05
           WHERE NOT
                  (EXISTS
                   (SELECT 1 FROM MPV06 WHERE PV05_CONTROLE = PV06_CONTROLE))
             AND NOT
                  (EXISTS
                   (SELECT 1 FROM MPF01 WHERE PV05_CONTROLE = PF01_CONTROLE));
        


      END


    END ---

END  -- IF @P_TIPO = 'P'
ELSE IF @P_TIPO = 'ST'  -- MARGEM PRESUMIDA
BEGIN

    IF ISNULL(@P_CODIGO, '') <> ''
    BEGIN
      DELETE MPF01_TEMP_HASH
       WHERE PF01_TIPO = @P_TIPO
         AND PF01_REGRA = @P_CODIGO;

         
      --- SOMENTE EXECUTA O HASH SE A REGRA ESTIVER ATIVA
      
      SET @V_SITUACAO = 0;
        SELECT @V_SITUACAO = DB_MPR_SITUACAO, 
               @V_UTILBASERED = DB_MPR_UTILBASERED
          FROM DB_MRG_PRESUMIDA
         WHERE DB_MPR_CODIGO = @P_CODIGO;
      
      IF @V_SITUACAO = 0
      BEGIN

        SET @V_ID = ROUND(RAND() * 1000000, 0)
    
        DECLARE CUR_MARGEM_PRES CURSOR
        FOR SELECT DB_MPRI_CODIGO,                         DB_MPRI_DTVALINI,                     DB_MPRI_DTVALFIN,
                   REPLACE(DB_MPRI_EMPRESA,';',','),     REPLACE(DB_MPRI_UF_ORIG,';',','),     REPLACE(DB_MPRI_UF_DEST, ';',','),
                   REPLACE(DB_MPRI_LST_PROD, ';',','),   REPLACE(DB_MPRI_LST_TPPROD, ';',','), REPLACE(DB_MPRI_LST_MARCA, ';',','),
                   REPLACE(DB_MPRI_LST_FAM, ';',','),    REPLACE(DB_MPRI_LST_GRUPO, ';',','),  REPLACE(DB_MPRI_LST_CLIENT, ';',','),
                   REPLACE(DB_MPRI_LST_RAMATV, ';',','), REPLACE(DB_MPRI_LST_OPVDA, ';',','),  REPLACE(DB_MPRI_LST_CLAFIS, '',''),
                   REPLACE(DB_MPRI_LST_CLCOM, ';', ','), DB_MPRI_BASERED,                        DB_MPRI_PESO,
                   DB_MPRI_CALC_SUBS,                     DB_MPRI_APLIC,                            DB_MPRI_PRECOMAX,
                   DB_MPRI_TPCALC,                         DB_MPRI_DCTOPMC,                        DB_MPRI_DESCTO,
                   DB_MPRI_MRGPRESUM,                    DB_MPRI_GRPITCONT,                     DB_MPRI_OPTANTESIMPLES,
                   DB_MPRI_DESCONTO_FISCAL,              DB_MPRI_SEQ,			     replace(DB_MPRI_LST_CLFISCLI, '','')
             FROM DB_MRG_PRES_ITEM
            WHERE DB_MPRI_CODIGO = @P_CODIGO
            OPEN CUR_MARGEM_PRES
           FETCH NEXT FROM CUR_MARGEM_PRES

            INTO   @V_CODIGO_REGRA,        @V_DATA_INI,            @V_DATA_FIM,
                   @V_EMPRESA,            @V_ESTADOS,                @V_UF_DEST,
                   @V_PRODUTOS,            @V_TIPOPED,                @V_MARCA,
                   @V_FAMILIA,            @V_GRUPO,                @V_CLIENTE,
                   @V_RAMOATVS,            @V_OPERACAO_VENDA,        @V_CLASFIS,                   
                   @V_CLASSCOM,            @V_BASERED,        @V_PESO,
                   @VDB_MPRI_CALC_SUBS, @VDB_TBCV_APLICA_AUT,   @V_VALMAX,
                   @VDB_MPRI_TPCALC,    @VDB_MPRI_DCTOPMC,        @VDB_TBCVP_DESCTO,
                   @VDB_MPRI_MRGPRESUM, @VDB_MPRI_GRPITCONT,    @V_DB_MPRI_OPTANTESIMPLES,
                   @V_DB_MPRI_DESCONTO_FISCAL, @VDB_MPRI_SEQ,                @v_DB_MPRI_LST_CLFISCLI

        WHILE @@FETCH_STATUS = 0
           BEGIN
            
                EXEC DBO.MERCP_INSERE_HASH_ST @V_CODIGO_REGRA,  -- 01
                                               @VDB_MPRI_SEQ,                -- 02
                                               @V_DATA_INI,        -- 03
                                               @V_DATA_FIM,        -- 04
                                               @V_EMPRESA,        -- 05
                                               @V_ESTADOS,        -- 06
                                               @V_UF_DEST,        -- 07
                                               @V_PRODUTOS,        -- 08
                                               @V_TIPOPED,        -- 09
                                               @V_MARCA,        -- 10
                                               @V_FAMILIA,        -- 11
                                               @V_GRUPO,        -- 12
                                               @V_CLIENTE,        -- 13
                                               @V_RAMOATVS,        -- 14
                                               @V_OPERACAO_VENDA, -- 15
                                               '',                -- 16
                                               '',                -- 17
                                               '',                -- 18
                                               0,                -- 19
                                               0,                -- 20
                                               @V_CLASFIS,        -- 21
                                               @v_DB_MPRI_LST_CLFISCLI,                -- 22
                                               '',                -- 23
                                               '',                -- 24
                                               '',                -- 25
                                               '',                -- 26
                                               @V_CLASSCOM,        -- 27
                                               '',                -- 28
                                               @V_BASERED, -- 29
                                               @V_PESO,    -- 30
                                               'ST',            --31
                                               -----    ST   ---------
                                               @VDB_MPRI_CALC_SUBS,        --32
                                               @VDB_TBCV_APLICA_AUT,    --33
                                               @V_VALMAX,                --34
                                               @VDB_MPRI_TPCALC,        --35
                                               @VDB_MPRI_DCTOPMC,        --36
                                               @VDB_TBCVP_DESCTO,        --37
                                               @VDB_MPRI_MRGPRESUM,        --38
                                               @V_UTILBASERED,            -- 39
                                               @V_ID,                    -- 40
                                               @VDB_MPRI_GRPITCONT,
                                               @V_DB_MPRI_OPTANTESIMPLES,
                                               @V_DB_MPRI_DESCONTO_FISCAL;
            
        FETCH NEXT FROM CUR_MARGEM_PRES
          INTO  @V_CODIGO_REGRA,				@V_DATA_INI,                @V_DATA_FIM,
                   @V_EMPRESA,					@V_ESTADOS,					@V_UF_DEST,
                   @V_PRODUTOS,					@V_TIPOPED,					@V_MARCA,
                   @V_FAMILIA,					@V_GRUPO,					@V_CLIENTE,
                   @V_RAMOATVS,					@V_OPERACAO_VENDA,			@V_CLASFIS,                   
                   @V_CLASSCOM,					@V_BASERED,					@V_PESO,
                   @VDB_MPRI_CALC_SUBS,			@VDB_TBCV_APLICA_AUT,		@V_VALMAX,
                   @VDB_MPRI_TPCALC,			@VDB_MPRI_DCTOPMC,			@VDB_TBCVP_DESCTO,
                   @VDB_MPRI_MRGPRESUM,			@VDB_MPRI_GRPITCONT,		@V_DB_MPRI_OPTANTESIMPLES,
                   @V_DB_MPRI_DESCONTO_FISCAL,	@VDB_MPRI_SEQ,  @v_DB_MPRI_LST_CLFISCLI
          END
          CLOSE CUR_MARGEM_PRES
        DEALLOCATE CUR_MARGEM_PRES

         BEGIN TRY
        
              DELETE FROM MPF01
               WHERE PF01_REGRA = @P_CODIGO
                 AND PF01_TIPO = @P_TIPO;

              INSERT INTO MPF01
                (PF01_CONTROLE,
                 PF01_SEQ,
                 PF01_REGRA,
                 PF01_TIPO,
                 PF01_HASH,
                 PF01_IDENT,
                 PF01_PERCENTUAL,
                 PF01_BASERED,
                 PF01_TPCALC,
                 PF01_PRCMAX,
                 PF01_APLIC,
                 PF01_CALC,
                 PF01_DESCTO,
                 PF01_DATAINI,
                 PF01_DATAFIN,
                 PF01_DCTOPMC,
                 PF01_UTILBASERED)
                SELECT PF01_CONTROLE,
                       ROW_NUMBER() OVER(ORDER BY PF01_CONTROLE) +
                       (SELECT ISNULL(MAX(PF01_SEQ), 0)
                          FROM MPF01
                         WHERE PF01_CONTROLE = MPF01_TEMP_HASH.PF01_CONTROLE),
                       PF01_REGRA,
                       PF01_TIPO,
                       PF01_HASH,
                       PF01_IDENT,
                       PF01_PERCENTUAL,
                       PF01_BASERED,
                       PF01_TPCALC,
                       PF01_PRCMAX,
                       PF01_APLIC,
                       PF01_CALC,
                       PF01_DESCTO,
                       PF01_DATAINI,
                       PF01_DATAFIN,
                       PF01_DCTOPMC,
                       PF01_UTILBASERED
                  FROM MPF01_TEMP_HASH
                 WHERE PF01_REGRA = @P_CODIGO
                   AND PF01_TIPO = @P_TIPO;
        
              UPDATE MPF01
                 SET PF01_DATA_ALTER = GETDATE()
               WHERE PF01_TIPO = @P_TIPO
                 AND PF01_REGRA = (SELECT TOP 1 PF01_REGRA
                                     FROM MPF01_TEMP_HASH)


              DELETE FROM MPF01_TEMP_HASH
               WHERE PF01_REGRA = @P_CODIGO
                 AND PF01_TIPO = @P_TIPO;
        
              DELETE FROM MPV04
               WHERE NOT
                      (EXISTS
                       (SELECT 1 FROM MPV06 WHERE PV04_CONTROLE = PV06_CONTROLE))
                 AND NOT
                      (EXISTS
                       (SELECT 1 FROM MPF01 WHERE PV04_CONTROLE = PF01_CONTROLE));
              DELETE FROM MPV05
               WHERE NOT
                      (EXISTS
                       (SELECT 1 FROM MPV06 WHERE PV05_CONTROLE = PV06_CONTROLE))
                 AND NOT
                      (EXISTS
                       (SELECT 1 FROM MPF01 WHERE PV05_CONTROLE = PF01_CONTROLE));
            
        
            END TRY
            BEGIN CATCH

                SET @ERRO = 'ERRO AO INSERIR MPV06: TIPO ' + @P_TIPO + ' POLITICA: ' + @P_CODIGO + ' : ' + ERROR_MESSAGE();
                INSERT INTO DBS_ERROS_TRIGGERS
                  (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
                VALUES
                  (@ERRO, GETDATE(), 'MERCP_INSERE_HASH');
                
            END CATCH


      END -- @V_SITUACAO = 0
      ELSE
      BEGIN

        DELETE FROM MPF01
            WHERE PF01_REGRA = @P_CODIGO
                AND PF01_TIPO = @P_TIPO;

        DELETE FROM MPV04
        WHERE NOT
                (EXISTS
                (SELECT 1 FROM MPV06 WHERE PV04_CONTROLE = PV06_CONTROLE))
            AND NOT
                (EXISTS
                (SELECT 1 FROM MPF01 WHERE PV04_CONTROLE = PF01_CONTROLE));
        DELETE FROM MPV05
        WHERE NOT
                (EXISTS
                (SELECT 1 FROM MPV06 WHERE PV05_CONTROLE = PV06_CONTROLE))
            AND NOT
                (EXISTS
                (SELECT 1 FROM MPF01 WHERE PV05_CONTROLE = PF01_CONTROLE));


      END



    END -- VREGRA IS NOT NULL

END  -- ELSE IF @P_TIPO = 'ST'
ELSE IF @P_TIPO = 'RI' OR @P_TIPO = 'IP' OR @P_TIPO = 'DF' OR @P_TIPO = 'CI'
BEGIN
  
    DELETE MPF01_TEMP_HASH
     WHERE PF01_TIPO = @P_TIPO
       AND PF01_REGRA = @P_CODIGO;
  
       
      SET @V_SITUACAO = 1;
      SELECT @V_SITUACAO = DB_RIE_SITUACAO        
        FROM DB_REGICMS_EXC
       WHERE DB_RIE_CODIGO = @P_CODIGO;
      

    IF @V_SITUACAO = 0
    BEGIN

        SET @V_ID = ROUND(RAND() * 1000000, 0)

        DECLARE CUR_ICMS CURSOR
        FOR  SELECT DB_RIEI_CODIGO,                    DB_RIEI_DTVALINI,                 DB_RIEI_PESO,
                    DB_RIEI_DTVALFIN,                  DB_RIEI_EMPRESA,                  DB_RIEI_UF_ORIG,
                    DB_RIEI_UF_DEST,                   DB_RIEI_PRODUTO,                  DB_RIEI_TPPROD,
                    DB_RIEI_MARCA,                     DB_RIEI_FAMILIA,                  DB_RIEI_GRUPO,
                    cast(cast(DB_RIEI_CLIENTE as bigint) as varchar),                   DB_RIEI_RAMO,                     DB_RIEI_OPERACAO,
                    DB_RIEI_TPPESSOA,                  DB_RIEI_SUFRAMA,                  DB_RIEI_CLASSPRD, 
                    DB_RIEI_TPVDAPRD,                  DB_RIEI_FATUR,                    DB_RIEI_CLASSFIS,
                    DB_RIEI_CLASSFCLI,                 DB_RIEI_CIDADE,                   DB_RIEI_CONTRIB,
                    DB_RIEI_LPRECO,                    DB_RIEI_TPPED,                    DB_RIEI_CLICCOM,
                    DB_RIEI_TXICMS,                    DB_RIEI_BASERED,	                 DB_RIEI_SEQ
             FROM DB_REGICMS_EXC_IT
            WHERE DB_RIEI_CODIGO = @P_CODIGO
            OPEN CUR_ICMS
           FETCH NEXT FROM CUR_ICMS
            INTO @V_CODIGO_REGRA,       @V_DATA_INI,     @V_PESO,
                 @V_DATA_FIM,            @V_EMPRESA,         @V_ESTADOS,
                 @V_UF_DEST,            @V_PRODUTOS,     @V_TIPO,
                 @V_MARCA,                @V_FAMILIA,         @V_GRUPO,
                 @V_CLIENTE,            @V_RAMOATVS,     @V_OPERACAO_VENDA,
                 @V_TPPESSOA,            @V_SUFRAMA,         @V_CLASSPRD   ,
                 @V_TPVENDA,            @V_FATUR,           @V_CLASSFIS,
                 @V_CLASSFCLI,            @V_CIDADE,         @V_CONTRIB,
                 @V_LPRECO,                @V_TIPOPED,         @V_CLICCOM,
                 @V_TXTICMS,            @V_BASERED,            @VDB_RIEI_SEQ
        WHILE @@FETCH_STATUS = 0
           BEGIN
              EXEC DBO.MERCP_INSERE_HASH_ICMS
                                   @V_CODIGO_REGRA,        -- 01
                                   @VDB_RIEI_SEQ,          -- 02
                                   @V_DATA_INI,            -- 03
                                   @V_DATA_FIM,            -- 04
                                   @V_EMPRESA,            -- 05
                                   @V_ESTADOS,            -- 06
                                   @V_UF_DEST,            -- 07
                                   @V_PRODUTOS,            -- 08
                                   @V_TIPO,                -- 09
                                   @V_MARCA,            -- 10
                                   @V_FAMILIA,            -- 11
                                   @V_GRUPO,            -- 12
                                   @V_CLIENTE,            -- 13
                                   @V_RAMOATVS,            -- 14
                                   @V_OPERACAO_VENDA,    -- 15
                                   @V_TPPESSOA,            -- 16
                                   @V_SUFRAMA,            -- 17
                                   @V_CLASSPRD,            -- 18
                                   @V_TPVENDA,            -- 19
                                   @V_FATUR,            -- 20
                                   @V_CLASSFIS,            -- 21
                                   @V_CLASSFCLI,        -- 22
                                   @V_CIDADE,            -- 23
                                   @V_CONTRIB,            -- 24
                                   @V_LPRECO,            -- 25
                                   @V_TIPOPED,            -- 26
                                   @V_CLICCOM,            -- 27
                                   @V_TXTICMS,            -- 28
                                   @V_BASERED,            -- 29
                                   @V_PESO,                -- 30
                                   @P_TIPO,                -- 31
                                   -----   ST     -----------
                                   0,            --32
                                   0,            --33
                                   0,            --34
                                   0,            --35
                                   0,            --36
                                   0,            --37
                                   0,            --38
                                   0,                --39
                                   @V_ID
                               
          FETCH NEXT FROM CUR_ICMS
          INTO   @V_CODIGO_REGRA,       @V_DATA_INI,     @V_PESO,
                 @V_DATA_FIM,            @V_EMPRESA,         @V_ESTADOS,
                 @V_UF_DEST,            @V_PRODUTOS,     @V_TIPO,
                 @V_MARCA,                @V_FAMILIA,         @V_GRUPO,
                 @V_CLIENTE,            @V_RAMOATVS,     @V_OPERACAO_VENDA,
                 @V_TPPESSOA,            @V_SUFRAMA,         @V_CLASSPRD   ,
                 @V_TPVENDA,            @V_FATUR,           @V_CLASSFIS,
                 @V_CLASSFCLI,            @V_CIDADE,         @V_CONTRIB,
                 @V_LPRECO,                @V_TIPOPED,         @V_CLICCOM,
                 @V_TXTICMS,            @V_BASERED,            @VDB_RIEI_SEQ
           END
          CLOSE CUR_ICMS
        DEALLOCATE CUR_ICMS                    
     


         BEGIN TRY
        
                  DELETE FROM MPF01
                   WHERE PF01_REGRA = @P_CODIGO
                     AND PF01_TIPO = @P_TIPO;

                  INSERT INTO MPF01
                    (PF01_CONTROLE,
                     PF01_SEQ,
                     PF01_REGRA,
                     PF01_TIPO,
                     PF01_HASH,
                     PF01_IDENT,
                     PF01_PERCENTUAL,
                     PF01_BASERED,
                     PF01_TPCALC,
                     PF01_PRCMAX,
                     PF01_APLIC,
                     PF01_CALC,
                     PF01_DESCTO,
                     PF01_DATAINI,
                     PF01_DATAFIN,
                     PF01_DCTOPMC,
                     PF01_UTILBASERED)
                    SELECT PF01_CONTROLE,
                           ROW_NUMBER() OVER(ORDER BY PF01_CONTROLE) +
                           (SELECT ISNULL(MAX(PF01_SEQ), 0)
                              FROM MPF01
                             WHERE PF01_CONTROLE = MPF01_TEMP_HASH.PF01_CONTROLE),
                           PF01_REGRA,
                           PF01_TIPO,
                           PF01_HASH,
                           PF01_IDENT,
                           PF01_PERCENTUAL,
                           PF01_BASERED,
                           PF01_TPCALC,
                           PF01_PRCMAX,
                           PF01_APLIC,
                           PF01_CALC,
                           PF01_DESCTO,
                           PF01_DATAINI,
                           PF01_DATAFIN,
                           PF01_DCTOPMC,
                           PF01_UTILBASERED
                      FROM MPF01_TEMP_HASH
                     WHERE PF01_REGRA = @P_CODIGO
                       AND PF01_TIPO = @P_TIPO;

                  UPDATE MPF01
                     SET PF01_DATA_ALTER = GETDATE()
                   WHERE PF01_TIPO = @P_TIPO
                     AND PF01_REGRA = (SELECT TOP 1 PF01_REGRA
                                         FROM MPF01_TEMP_HASH)


                  DELETE FROM MPF01_TEMP_HASH
                   WHERE PF01_REGRA = @P_CODIGO
                     AND PF01_TIPO = @P_TIPO;
        
                  DELETE FROM MPV04
                   WHERE NOT
                          (EXISTS
                           (SELECT 1 FROM MPV06 WHERE PV04_CONTROLE = PV06_CONTROLE))
                     AND NOT
                          (EXISTS
                           (SELECT 1 FROM MPF01 WHERE PV04_CONTROLE = PF01_CONTROLE));
                  DELETE FROM MPV05
                   WHERE NOT
                          (EXISTS
                           (SELECT 1 FROM MPV06 WHERE PV05_CONTROLE = PV06_CONTROLE))
                     AND NOT
                          (EXISTS
                           (SELECT 1 FROM MPF01 WHERE PV05_CONTROLE = PF01_CONTROLE));
            
            
                END TRY
                BEGIN CATCH

                    SET @ERRO = 'ERRO AO INSERIR MPV06: TIPO ' + @P_TIPO + ' POLITICA: ' + @P_CODIGO + ' : ' + ERROR_MESSAGE();
                    INSERT INTO DBS_ERROS_TRIGGERS
                      (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
                    VALUES
                      (@ERRO, GETDATE(), 'MERCP_INSERE_HASH');
        
                END CATCH

    END
    ELSE
    BEGIN

          DELETE FROM MPF01
            WHERE PF01_REGRA = @P_CODIGO
                AND PF01_TIPO = @P_TIPO;

        DELETE FROM MPV04
        WHERE NOT
                (EXISTS
                (SELECT 1 FROM MPV06 WHERE PV04_CONTROLE = PV06_CONTROLE))
            AND NOT
                (EXISTS
                (SELECT 1 FROM MPF01 WHERE PV04_CONTROLE = PF01_CONTROLE));
        DELETE FROM MPV05
        WHERE NOT
                (EXISTS
                (SELECT 1 FROM MPV06 WHERE PV05_CONTROLE = PV06_CONTROLE))
            AND NOT
                (EXISTS
                (SELECT 1 FROM MPF01 WHERE PV05_CONTROLE = PF01_CONTROLE));
                
    END




END  -- ELSE IF @P_TIPO = 'RI' OR @P_TIPO = 'IP'
ELSE IF @P_TIPO = 'R' OR @P_TIPO = 'A' OR @P_TIPO = 'S'  -- RESTRICAO DE VENDA
BEGIN

    DELETE MPV06_TEMP_HASH
     WHERE PV06_TIPO = @P_TIPO
       AND PV06_POLITICA = @P_CODIGO;

    SET @V_ID = ROUND(RAND() * 1000000, 0)

    DECLARE CUR_RESTRICAO CURSOR
    FOR SELECT DB_RES_CODIGO, DB_RESRP_SEQ, DB_RES_DTINI, DB_RES_DTFIM
            FROM DB_RESTR_REGRAS_PAI, DB_RESTRICAO
        WHERE DB_RESRP_CODIGO = DB_RES_CODIGO
          AND DB_RES_CODIGO = @P_CODIGO
        OPEN CUR_RESTRICAO
       FETCH NEXT FROM CUR_RESTRICAO
        INTO @V_CODIGO_REGRA, @V_SEQ_PAI, @V_DATA_INI,        @V_DATA_FIM
    WHILE @@FETCH_STATUS = 0
       BEGIN
    
         EXEC DBO.MERCP_HASH_RESTRICAO_VENDA @V_CODIGO_REGRA,
                                             @V_SEQ_PAI,
                                             @V_DATA_INI,
                                             @V_DATA_FIM,
                                             @P_TIPO,                                 
                                             @V_ID

        


    FETCH NEXT FROM CUR_RESTRICAO
      INTO @V_CODIGO_REGRA, @V_SEQ_PAI, @V_DATA_INI,        @V_DATA_FIM
      END
      CLOSE CUR_RESTRICAO
    DEALLOCATE CUR_RESTRICAO


    BEGIN TRY
        
              DELETE MPV06
               WHERE PV06_TIPO = @P_TIPO
                 AND PV06_POLITICA = @P_CODIGO;
        
              INSERT INTO MPV06
                (PV06_CONTROLE,
                 PV06_SEQ,
                 PV06_TIPO,
                 PV06_POLITICA,
                 PV06_IDENT,
                 PV06_HASH,
                 PV06_PRAZOMIN,
                 PV06_PRAZOMAX,
                 PV06_QTDEMIN,
                 PV06_QTDEMAX,
                 PV06_CVI,
                 PV06_COMIS,
                 PV06_MIX,
                 PV06_DATA_INI,
                 PV06_DATA_FIM,
                 PV06_PRECOLIQ,
                 PV06_BONIF,
                 PV06_BONQTD,
                 PV06_BONVLR,
                 PV06_PEDMIN,
                 PV06_PARTIC,
                 PV06_PARTMAX,
                 PV06_ACRVLR,
                 PV06_VALMIN,
                 PV06_VALMAX,
                 PV06_DESCTO,
                 PV06_PRODUTO,
                 PV06_AVALIACAO,
                 PV06_APLIC_OL,
                 PV06_QTDEMULT,
                 PV06_PARTMAXFIS,
                 PV06_FATCONV,
                 PV06_APLICBRUTO,
                 PV06_APLICACAO,
                 PV06_IDREGRA,
                 PV06_DESCTOMIN,
                 PV06_DESCTOMAX,
                 PV06_GRUPOEMP,
                 PV06_MSGERRO,
                 PV06_PARTSOBRE,
                 PV06_TPAVALIACAO,
                 PV06_DIASAMAIS,
                 PV06_VALMIX,
                 PV06_CLICONTRIB,
                 PV06_CLIIE,
                 PV06_CLIVENDOR,
                 PV06_CLISUFRAMA,
                 PV06_APRESCLI,
                 PV06_DIAINI,
                 PV06_DIAFIN,
                 PV06_VALIDADE,
                 PV06_APLIC_OLCLI)
                SELECT PV06_CONTROLE,
                       ROW_NUMBER() OVER(ORDER BY PV06_CONTROLE) +
                       (SELECT ISNULL(MAX(PV06_SEQ), 0)
                          FROM MPV06
                         WHERE PV06_CONTROLE = MPV06_TEMP_HASH.PV06_CONTROLE),
                       PV06_TIPO,
                       PV06_POLITICA,
                       PV06_IDENT,
                       PV06_HASH,
                       PV06_PRAZOMIN,
                       PV06_PRAZOMAX,
                       PV06_QTDEMIN,
                       PV06_QTDEMAX,
                       PV06_CVI,
                       PV06_COMIS,
                       PV06_MIX,
                       PV06_DATA_INI,
                       PV06_DATA_FIM,
                       PV06_PRECOLIQ,
                       PV06_BONIF,
                       PV06_BONQTD,
                       PV06_BONVLR,
                       PV06_PEDMIN,
                       PV06_PARTIC,
                       PV06_PARTMAX,
                       PV06_ACRVLR,
                       PV06_VALMIN,
                       PV06_VALMAX,
                       PV06_DESCTO,
                       PV06_PRODUTO,
                       PV06_AVALIACAO,
                       PV06_APLIC_OL,
                       PV06_QTDEMULT,
                       PV06_PARTMAXFIS,
                       PV06_FATCONV,
                       PV06_APLICBRUTO,
                       PV06_APLICACAO,
                       PV06_IDREGRA,
                       PV06_DESCTOMIN,
                       PV06_DESCTOMAX,
                       PV06_GRUPOEMP,
                       PV06_MSGERRO,
                       PV06_PARTSOBRE,
                       PV06_TPAVALIACAO,
                       PV06_DIASAMAIS,
                       PV06_VALMIX,
                       PV06_CLICONTRIB,
                       PV06_CLIIE,
                       PV06_CLIVENDOR,
                       PV06_CLISUFRAMA,
                       PV06_APRESCLI,
                       PV06_DIAINI,
                       PV06_DIAFIN,
                       PV06_VALIDADE,
                       PV06_APLIC_OLCLI
                  FROM MPV06_TEMP_HASH
                 WHERE PV06_POLITICA = @P_CODIGO
                   AND PV06_TIPO = @P_TIPO;
              
              UPDATE MPV06
                 SET PV06_DATA_ALTER = GETDATE()
               WHERE PV06_TIPO = @P_TIPO
                 AND PV06_POLITICA = (SELECT TOP 1 PV06_POLITICA
                                        FROM MPV06_TEMP_HASH);

              DELETE FROM MPV06_TEMP_HASH
               WHERE PV06_TIPO = @P_TIPO
                 AND PV06_POLITICA = @P_CODIGO;
                  
              DELETE FROM MPV04
               WHERE NOT
                      (EXISTS
                       (SELECT 1 FROM MPV06 WHERE PV04_CONTROLE = PV06_CONTROLE))
                 AND NOT
                      (EXISTS
                       (SELECT 1 FROM MPF01 WHERE PV04_CONTROLE = PF01_CONTROLE));
              DELETE FROM MPV05
               WHERE NOT
                      (EXISTS
                       (SELECT 1 FROM MPV06 WHERE PV05_CONTROLE = PV06_CONTROLE))
                 AND NOT
                      (EXISTS
                       (SELECT 1 FROM MPF01 WHERE PV05_CONTROLE = PF01_CONTROLE));
        
        
          END TRY
          BEGIN CATCH
                SET @ERRO = 'ERRO AO INSERIR MPV06: TIPO ' + @P_TIPO +
                              ' POLITICA: ' + @P_CODIGO + ' : ' + ERROR_MESSAGE()
                INSERT INTO DBS_ERROS_TRIGGERS
                  (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
                VALUES
                  (@ERRO, GETDATE(), 'MERCP_INSERE_HASH');
            
          END CATCH

END -- ELSE IF @P_TIPO = 'R' OR @P_TIPO = 'A' OR @P_TIPO = 'S'

END
GO
