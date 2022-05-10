SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[MERCP_SA1010] (@VEVENTO      FLOAT,
                                      @VA1_FILIAL   VARCHAR(50),
                                      @VA1_COD      VARCHAR(50),
                                      @VA1_LOJA     VARCHAR(50),
                                      @VA1_NOME     VARCHAR(50),
                                      @VA1_PESSOA   VARCHAR(50),
                                      @VA1_CGC      VARCHAR(50),
                                      @VA1_END      VARCHAR(50),
                                      @VA1_BAIRRO   VARCHAR(50),
                                      @VA1_INSCR    VARCHAR(50),
                                      @VA1_MUN      VARCHAR(50),
                                      @VA1_EST      VARCHAR(50),
                                      @VA1_CEP      VARCHAR(50),
                                      @VA1_CONTATO  VARCHAR(50),
                                      @VA1_DDI      VARCHAR(50),
                                      @VA1_TEL      VARCHAR(50),
                                      @VA1_ULTCOM   VARCHAR(50),
                                      @VA1_NREDUZ   VARCHAR(50),
                                      @VA1_ENDCOB   VARCHAR(50),
                                      @VA1_BAIRROC  VARCHAR(50),
                                      @VA1_MUNC     VARCHAR(50),
                                      @VA1_ESTC     VARCHAR(50),
                                      @VA1_CEPC     VARCHAR(50),
                                      @VA1_FAX      VARCHAR(50),
                                      @VA1_TIPO     VARCHAR(50),
                                      @VA1_NATUREZ  VARCHAR(50),
                                      @VA1_CONTA    VARCHAR(50),
                                      @VA1_RISCO    VARCHAR(50),
                                      @VA1_ATIVIDA  VARCHAR(50),
                                      @VA1_TELEX    VARCHAR(50),
                                      @VA1_ENDENT   VARCHAR(50),
                                      @VA1_ENDREC   VARCHAR(50),
                                      @VA1_RECINSS  VARCHAR(50),
                                      @VA1_INSCRM   VARCHAR(50),
                                      @VA1_COMIS    FLOAT,
                                      @VA1_REGIAO   VARCHAR(50),
                                      @VA1_BCO1     VARCHAR(50),
                                      @VA1_BCO2     VARCHAR(50),
                                      @VA1_BCO3     VARCHAR(50),
                                      @VA1_BCO4     VARCHAR(50),
                                      @VA1_BCO5     VARCHAR(50),
                                      @VA1_TRANSP   VARCHAR(50),
                                      @VA1_TPFRET   VARCHAR(50),
                                      @VA1_COND     VARCHAR(50),
                                      @VA1_CLASSE   VARCHAR(50),
                                      @VA1_DESC     FLOAT,
                                      @VA1_PRIOR    VARCHAR(50),
                                      @VA1_LC       FLOAT,
                                      @VA1_VENCLC   VARCHAR(50),
                                      @VA1_MCOMPRA  FLOAT,
                                      @VA1_METR     FLOAT,
                                      @VA1_MSALDO   FLOAT,
                                      @VA1_NROCOM   FLOAT,
                                      @VA1_PRICOM   VARCHAR(50),
                                      @VA1_TEMVIS   FLOAT,
                                      @VA1_ULTVIS   VARCHAR(50),
                                      @VA1_MENSAGE  VARCHAR(50),
                                      @VA1_NROPAG   FLOAT,
                                      @VA1_SALDUP   FLOAT,
                                      @VA1_SALPEDL  FLOAT,
                                      @VA1_SUFRAMA  VARCHAR(50),
                                      @VA1_TRANSF   VARCHAR(50),
                                      @VA1_ATR      FLOAT,
                                      @VA1_VACUM    FLOAT,
                                      @VA1_SALPED   FLOAT,
                                      @VA1_TITPROT  FLOAT,
                                      @VA1_DTULTIT  VARCHAR(50),
                                      @VA1_CHQDEVO  FLOAT,
                                      @VA1_DTULCHQ  VARCHAR(50),
                                      @VA1_MATR     FLOAT,
                                      @VA1_MAIDUPL  FLOAT,
                                      @VA1_TABELA   VARCHAR(50),
                                      @VA1_INCISS   VARCHAR(50),
                                      @VA1_AGREG    VARCHAR(50),
                                      @VA1_SALDUPM  FLOAT,
                                      @VA1_PAGATR   FLOAT,
                                      @VA1_CARGO1   VARCHAR(50),
                                      @VA1_CARGO2   VARCHAR(50),
                                      @VA1_CARGO3   VARCHAR(50),
                                      @VA1_SUPER    VARCHAR(50),
                                      @VA1_RTEC     VARCHAR(50),
                                      @VA1_ALIQIR   FLOAT,
                                      @VA1_OBSERV   VARCHAR(50),
                                      @VA1_CALCSUF  VARCHAR(50),
                                      @VA1_RG       VARCHAR(50),
                                      @VA1_DTNASC   VARCHAR(50),
                                      @VA1_SALPEDB  FLOAT,
                                      @VA1_CLIFAT   VARCHAR(50),
                                      @VA1_GRPTRIB  VARCHAR(50),
                                      @VA1_BAIRROE  VARCHAR(50),
                                      @VA1_CEPE     VARCHAR(50),
                                      @VA1_MUNE     VARCHAR(50),
                                      @VA1_ESTE     VARCHAR(50),
                                      @VA1_SATIV1   VARCHAR(50),
                                      @VA1_SATIV2   VARCHAR(50),
                                      @VA1_SATIV3   VARCHAR(50),
                                      @VA1_SATIV4   VARCHAR(50),
                                      @VA1_SATIV5   VARCHAR(50),
                                      @VA1_SATIV6   VARCHAR(50),
                                      @VA1_CODMUN   VARCHAR(50),
                                      @VA1_SATIV7   VARCHAR(50),
                                      @VA1_SATIV8   VARCHAR(50),
                                      @VA1_CODHIST  VARCHAR(50),
                                      @VA1_PAIS     VARCHAR(50),
                                      @VA1_EMAIL    VARCHAR(70),
                                      @VA1_HPAGE    VARCHAR(50),
                                      @VA1_OBS      VARCHAR(50),
                                      @VA1_CODMARC  VARCHAR(50),
                                      @VA1_TMPSTD   VARCHAR(50),
                                      @VA1_COMAGE   FLOAT,
                                      @VA1_DEST_3   VARCHAR(50),
                                      @VA1_ESTADO   VARCHAR(50),
                                      @VA1_CXPOSTA  VARCHAR(50),
                                      @VA1_DEST_2   VARCHAR(50),
                                      @VA1_CODAGE   VARCHAR(50),
                                      @VA1_TIPCLI   VARCHAR(50),
                                      @VA1_CONDPAG  VARCHAR(50),
                                      @VA1_DEST_1   VARCHAR(50),
                                      @VA1_DIASPAG  FLOAT,
                                      @VA1_CLASVEN  VARCHAR(50),
                                      @VA1_FORMVIS  VARCHAR(50),
                                      @VA1_RECCOFI  VARCHAR(50),
                                      @VA1_RECCSLL  VARCHAR(50),
                                      @VA1_RECPIS   VARCHAR(50),
                                      @VA1_TMPVIS   VARCHAR(50),
                                      @VA1_PFISICA  VARCHAR(50),
                                      @VA1_LCFIN    FLOAT,
                                      @VA1_MOEDALC  FLOAT,
                                      @VA1_RECISS   VARCHAR(50),
                                      @VA1_DDD      VARCHAR(50),
                                      @VA1_TIPPER   VARCHAR(50),
                                      @VA1_COD_MUN  VARCHAR(50),
                                      @VA1_SALFIN   FLOAT,
                                      @VA1_SALFINM  FLOAT,
                                      @VA1_B2B      VARCHAR(50),
                                      @VA1_GRPVEN   VARCHAR(50),
                                      @VA1_VEND     VARCHAR(50),
                                      @VA1_CLICNV   VARCHAR(50),
                                      @VA1_SITUA    VARCHAR(50),
                                      @VA1_TPESSOA  VARCHAR(50),
                                      @VA1_ABATIMP  VARCHAR(50),
                                      @VA1_TPISSRS  VARCHAR(50),
                                      @VA1_CTARE    VARCHAR(50),
                                      @VA1_RECFET   VARCHAR(50),
                                      @VD_E_L_E_T_  VARCHAR(50),
                                      @VR_E_C_N_O_  INT,
                                      @VA1_MSBLQL   VARCHAR(1),
                                      @VA1_VACANAL  VARCHAR(100),
                                      @VA1_SIMPNAC  INT,
                                      @VA1_OBSALI   VARCHAR(50),
                                      @VA1_CNAE     VARCHAR(15),
                                      @VA1_VAREGE   VARCHAR(10),
                                      @VA1_VAOC     VARCHAR(50),
                                      @VA1_VAPROMO  VARCHAR(50),
									  @VA1_CONTAT3  VARCHAR(15),	
									  @VA1_TELCOB   VARCHAR(15),	
									  @VA1_VAEMLF   VARCHAR(60),	
									  @VA1_VABCOF   VARCHAR(3),
									  @VA1_VAAGFIN  VARCHAR(5),   
									  @VA1_VACTAFN  VARCHAR(12),  
									  @VA1_VACGCFI  VARCHAR(14),
									  @VA1_VEND2     VARCHAR(50),
									  @VA1_TABELA2   VARCHAR(50)

                                     ) AS

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00001  03/02/2016  ALENCAR          GRAVA DB_CLI_RAMATIV = SUBSTRING(@VA1_SATIV1,1,5)
---                                        NAO ATUALIZA O PORTADOR
---                                        SOMENTE INTEGRA CLIENTES COM CODIGO <= 999999 E NAO BLOQUEADOS (A1_MSBLQL <> 1)
---                                        REGRA PARA TRIBUTACAO ICMS: 
---                                        - NAO CONTRIBUINTE = A1_INSCR NULA, OU ISENTO
---                                        - CONTRIBUITE = DEMAIS PESSOAS JURIDICAS  (A1_TIPO = J)
---                                        - CONSUMIDOR FINAL = TODOS CONSIMIDORES FINAL (A1_TIPO = F)
---                                        QUANDO NAO POSSUIR ENDERECO DE COBRANCA COPIAS AS INFORMACOES DO ENDERECO PRINCIPAL
---                                        PASSA A AVALIAR O CODIGO DO CLIENTE PARA DEFINIR SE O CLIENTES DEVE SER ATUALIZADO, POIS O CNPJ ESTA DUPLICADO NO PROTHEUS
---  1.00002  03/02/2016  ALENCAR          GRAVAR A CLIENTE_REPRES COM BASE NA TABELA ZFL
---  1.00003  15/03/2016  ALENCAR          GRAVAR OS CAMPOS  DB_CLI_DATA_CADAS E DB_CLI_ALT_CORP
---                                        GRAVAR A CLASSIFICACAO FISCAL DO CLIENTE  DB_CLIC_CLASFIS   = @VA1_ZZCBU
---  1.00004  29/03/2016  CELENIO          AJUSTADO DB_CLI_RAMATIV PARA DESCONSIRAR OS ESPAÇOS EM BRANCO
---  1.00005  09/05/2016  ALENCAR          PARA ENCONTRAR O CLIENTE, EXECUTA A SEGUINTE REGRA: PRIMEIRO TENTA ENCONTRAR PELO CODIGO, SE NAO ENCONTROU, TENTA PROCURAR PELO CGC, SENDO QUE NO MERCANET O CGC DEVE SER IGUAL AO CODIGO
---                                        ISSO E FEITO POIS O CLIENTE DIGITADO NO MERCANET E ENVIADO PARA A INTERFACE PARA DEPOIS RECEBER O CODIGO NO PROTHEUS
---  1.00005  16/05/2016  ALENCAR          GRAVAR DB_CLI_DATA_FUNDAC = '1900-01-01'
---  1.00006  18/05/2016  ALENCAR          RETIRA A RESTRICAO DO CLIENTE, SEMPRE QUE O CLIENTE ESTIVER DESBLOQUEADO NO PROTHEUS A1_MSBLQL = 2
---  1.00007  19/05/2016  ALENCAR          NOVAMENTE A REGRA MUDOU, NOTAS DE CLIENTES BLOQUEADOS DEVEM SER CARREGADAS
---                                        NAO INTEGRA CLIENTES DO COMERCIO EXTERIOR 
---                                        SE @VA1_MSBLQL= 1 ENTAO CLIENTE DESATIVADO (DB_CLI_SITUACAO = 3) SENAO CLIENTE ATIVO
---  1.00008  28/06/2016  ALENCAR          TRATA O CAMPO A1_MSBLQL COMO STRING
---  1.00009  04/07/2016  ALENCAR          IMPLEMENTACAO DA INTEGRACAO DE REDES
---  1.00010  05/07/2016  ALENCAR          GRAVAR A CLASSIFICACAO COMERCIAL (DB_CLI_CLASCOM) COM A1_ZZCBU
---  1.00010  07/07/2016  ALENCAR          GRAVAR A DATA DE VALIDADE DO SUFRAMA (DB_CLIC_DTVALSUF = @VA1_ZZDTSUF)
---  1.00011  10/09/2016  ALENCAR          QUANDO NAO TIVER REPRES INFORMADO NO PROTHEUS (A1_VEND) NAO IRA ALIMENTAR A CLIENNTE_REPRES
---  1.00012  15/09/2016  ALENCAR          ATUALIZAR TELEFONE COM DDD + NRO
---                                        INTEGRAR ATRASO MEDIO DB_CLIC_ATRASO_MED = A1_METR
---  1.00013  26/09/2016  ALENCAR          PARA CLIENTES REDE GRAVA TAMBEM REGISTRO NA CLIENTE_REPRES COM EMPRESA 101
---  1.00014  11/10/2016  ALENCAR          CONVERSAO NOVA ALIANCA
---                                        GRAVAR DB_CLI_RAMATIV = SUBSTRING(@VA1_VACANAL,1,5)
---  1.00015  28/10/2016  ALENCAR          QUANDO CLIENTE SUFRAMA GRAVAR A DATA DE VALIDADE 31/12/2999
---                                        GRAVAR OPTANTE SIMPLES (DB_CLIC_OPTSIMPLES) COM O CAMPO A1_SIMPNAC
---  1.00016  24/02/2017  ALENCAR          GRAVAR A OBSERVACAO DO CLIENTE COM O CAMPO A1_OBSALI
---  1.00017  13/03/2017  ALENCAR          GRAVAR A CLASSIFICACAO COMERCIAL DB_CLI_CLASCOM = A1_CNAE
---  1.00018  14/06/2017  ALENCAR          GRAVAR DB_CLIC_CLASFIS = SA1.A1_VAREGE
---  1.00019  03/07/2017  SERGIO LUCCHINI  GRAVAR O VALOR DO CAMPO A1_VAOC NO CAMPO DB_CLIC_ORDCOMP. CHAMADO 77668
---  1.00020  10/07/2017  SERGIO LUCCHINI  ALTERADA A REGRA DE ATUALIZACAO DA CONDICAO DE PAGAMENTO DO CLIENTE. CHAMADO 77905
---  1.00021  23/05/2018  SERGIO LUCCHINI  IMPORTAR O CADASTRO DE PROMOTORES DE VENDA. CHAMADO 81267
---  1.00022  10/09/2018  SERGIO LUCCHINI  ALTERACAO NA BUSCA DO REPRESENTANTE. CHAMADO 84157
---  1.00023  18/06/2020  CLAUDIA LIONÇO   ALTERACAO NO A1_VAREGE. GLPI:8084
---  1.00024  31/03/2022  JULIANO SOUZA    INCLUINDO REPRESENTANTE 2
---           07/04/2022  ROBERT KOCH      REMOVIDOS ALGUNS COMENTARIOS E APLICADA EM AMBIENTE DE PRODUCAO.
---
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN

DECLARE @VOBJETO             VARCHAR(15) SELECT @VOBJETO = 'MERCP_SA1010 ';
DECLARE @VDATA               DATETIME;
DECLARE @VCOD_ERRO           FLOAT;
DECLARE @VERRO               VARCHAR(255);
DECLARE @VREPRES             INT;
DECLARE @VREPRES2            INT;
DECLARE @VREPRESAUX          INT;
DECLARE @VEMPRESAAUX         VARCHAR(3);
DECLARE @VCLIENTEAUX         FLOAT;
DECLARE @VDB_CLIC_CONTR_ICMS INT;
DECLARE @VINSERE             INT SELECT @VINSERE =  0;
DECLARE @VCLI_NOVO           INT SELECT @VCLI_NOVO = 0;
DECLARE @VCLI_DELETA         INT SELECT @VCLI_DELETA = 0;
DECLARE @VCTRL_TRG_CLI       INT SELECT @VCTRL_TRG_CLI = 0;
DECLARE @VAUX_CLI_NOVO       INT SELECT @VAUX_CLI_NOVO = 0;
DECLARE @VCLIR_EMPRESA       VARCHAR(3);
DECLARE @VDB_CLI_CODIGO      FLOAT;
DECLARE @VDB_TBREDE_CLIENTE  FLOAT;
DECLARE @VINSERE_REDE        INT;
DECLARE @VZGE_NOME           VARCHAR(40);
DECLARE @VCGCS               VARCHAR(4000);
DECLARE @VDB_CLIC_CLASFIS    VARCHAR(5);

BEGIN TRY

--PRINT('INICIO: ')
--PRINT ('@VA1_COD' + @VA1_COD)
--PRINT('TIPO: '+ CAST(@VA1_TIPO AS VARCHAR))

IF @VA1_CGC     = ' ' OR        -- NAO INTEGRA CLIENTES SEM CNPJ
   @VA1_COD     >= '999999' OR  -- SOMENTE INTEGRA CLIENTES COM CODIGO MENOR QUE 999999
   @VA1_COD     LIKE '%F%' OR
   @VD_E_L_E_T_ <> ' '      -- NAO INTEGRA DELETADOS
BEGIN
   RETURN;
END

SET @VA1_COD = LTRIM(RTRIM(@VA1_COD));
SET @VA1_LOJA = LTRIM(RTRIM(@VA1_LOJA));
--PRINT('CLIENTE: '+ CAST(CAST(@VA1_COD + @VA1_LOJA AS FLOAT) AS VARCHAR))
--PRINT('CGC1: '+ CAST(@VA1_CGC AS VARCHAR))

-- REPRES. 1 ---------------------------------
IF ISNULL(LTRIM(RTRIM(@VA1_VEND)),'')  = '' OR
   ISNULL(LTRIM(RTRIM(@VA1_VEND)),'0') = '0'
BEGIN
   SET @VREPRES = 0;
END
ELSE
BEGIN
   SELECT @VREPRES = DB_TBREP_CODIGO
     FROM DB_TB_REPRES
    WHERE DB_TBREP_CODORIG = @VA1_VEND;
   SET @VCOD_ERRO = @@ERROR;
   IF @VCOD_ERRO > 0
   BEGIN
      SET @VREPRES = 0;
   END
END

-- REPRES. 2 ---------------------------------
IF ISNULL(LTRIM(RTRIM(@VA1_VEND2)),'')  = '' OR
   ISNULL(LTRIM(RTRIM(@VA1_VEND2)),'0') = '0'
BEGIN
   SET @VREPRES2 = 0;
END
ELSE
BEGIN
   SELECT @VREPRES2 = DB_TBREP_CODIGO
     FROM DB_TB_REPRES
    WHERE DB_TBREP_CODORIG = @VA1_VEND2;
   SET @VCOD_ERRO = @@ERROR;
   IF @VCOD_ERRO > 0
   BEGIN
      SET @VREPRES2 = 0;
   END
END

--PRINT('@VREPRES: '+ CAST(@VREPRES AS VARCHAR));

IF (@VEVENTO = 2 OR @VD_E_L_E_T_ <> ' ')
BEGIN

   DELETE FROM DB_CLIENTE       WHERE DB_CLI_CODIGO    = CAST(@VA1_COD AS FLOAT);
   DELETE FROM DB_CLIENTE_COMPL WHERE DB_CLIC_COD      = CAST(@VA1_COD AS FLOAT);
   DELETE FROM DB_CLIENTE_PESS  WHERE DB_CLIP_COD      = CAST(@VA1_COD AS FLOAT);
   DELETE FROM DB_CLIENTE_ENT   WHERE DB_CLIENT_CODIGO = CAST(@VA1_COD AS FLOAT);
   DELETE FROM DB_CLIEOLD       WHERE DB_CLI_CODIGO    = CAST(@VA1_COD AS FLOAT);
   DELETE FROM DB_CLIEOLD_COMPL WHERE DB_CLIC_COD      = CAST(@VA1_COD AS FLOAT);
   DELETE FROM DB_CLIEOLD_PESS  WHERE DB_CLIP_COD      = CAST(@VA1_COD AS FLOAT);

   -- LOOP PARA INSERIR NA DB_CLIENTE_DEL
   -- COM DESATIVA = 0 PARA EXCLUIR NA BASE REPRES - 06/01/2009 ALENCAR
   DECLARE CUR CURSOR
   FOR SELECT DB_CLIR_REPRES FROM DB_CLIENTE_REPRES WHERE DB_CLIR_CLIENTE = CAST(@VA1_COD AS FLOAT)
         OPEN CUR
        FETCH NEXT FROM CUR
         INTO @VREPRESAUX
        WHILE @@FETCH_STATUS = 0
       BEGIN

         SELECT @VINSERE = 1
           FROM DB_CLIENTE_DEL
          WHERE DB_CLIDEL_CLIENTE = CAST(@VA1_COD AS FLOAT)
            AND DB_CLIDEL_REPRES  = @VREPRESAUX;
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VINSERE = 0;
         END
 
         IF @VINSERE = 0
         BEGIN
            INSERT INTO DB_CLIENTE_DEL
              (
               DB_CLIDEL_CLIENTE,
               DB_CLIDEL_REPRES,
               DB_CLIDEL_DATA,
               DB_CLIDEL_DESATIVA
              )
            VALUES
              (
               CAST(@VA1_COD AS FLOAT),
               @VREPRESAUX,
               CAST(GETDATE() AS SMALLDATETIME),
               0
              );
            SET @VCOD_ERRO = @@ERROR;
            IF @VCOD_ERRO > 0
            BEGIN
               SET @VERRO = '0 - ERRO INSERT DB_CLIENTE_DEL:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
            END
         END

        FETCH NEXT FROM CUR
         INTO @VREPRESAUX
       END;
        CLOSE CUR
   DEALLOCATE CUR

   BEGIN
     DELETE FROM DB_CLIENTE_REPRES WHERE DB_CLIR_CLIENTE = CAST(@VA1_COD AS FLOAT);
     SET @VCOD_ERRO = @@ERROR;
     IF @VCOD_ERRO > 0
     BEGIN
        SET @VERRO = '1 - ERRO DELETE DB_CLIENTE_REPRES: ';
        --SET @VERRO = '1 - ERRO DELETE DB_CLIENTE_REPRES: ' + @VA1_COD  + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
     END
   END

END
ELSE
BEGIN

   --PRINT('CLIENTE: '+ CAST(CAST(@VA1_COD AS FLOAT) AS VARCHAR))
   --PRINT('CGC2: '+ CAST(@VA1_CGC AS VARCHAR))

   ----------------------------------------------------------------------------------------------------------------------------
   --  PARA ENCONTRAR O CLIENTE, EXECUTA A SEGUINTE REGRA:
   --  PRIMEIRO TENTA ENCONTRAR PELO CODIGO
   --  SE NAO ENCONTROU, TENTA PROCURAR PELO CGC, SENDO QUE NO MERCANET O CGC DEVE SER IGUAL AO CODIGO
   --  ISSO E FEITO POIS O CLIENTE DIGITADO NO MERCANET E ENVIADO PARA A INTERFACE PARA DEPOIS RECEBER O CODIGO NO PROTHEUS
   --  A PROCEDURE MERCP_ATUALIZA_RETORNO_CLIENTE E RESPONSAVEL POR ALTERAR O CODIGO DO CLIENTE
   ----------------------------------------------------------------------------------------------------------------------------
   SELECT @VINSERE = 1,
          @VDB_CLI_CODIGO = DB_CLI_CODIGO
     FROM DB_CLIENTE
    --WHERE DB_CLI_CGCMF = RTRIM(LTRIM(@VA1_CGC));
    WHERE DB_CLI_CODIGO = CAST(@VA1_COD AS FLOAT);

   IF @VINSERE = 0
   BEGIN
      SELECT @VINSERE = 1,
             @VDB_CLI_CODIGO = DB_CLI_CODIGO
        FROM DB_CLIENTE
       WHERE DB_CLI_CGCMF  = RTRIM(LTRIM(@VA1_CGC))
         AND DB_CLI_CODIGO = CAST(DB_CLI_CGCMF AS FLOAT);
   END;

   IF @VINSERE = 0
   BEGIN
      --PRINT('INSERT: '+ CAST(CAST(@VA1_COD AS FLOAT) AS VARCHAR))
      --PRINT ('@VDB_CLI_CODIGO' + CAST(@VDB_CLI_CODIGO AS VARCHAR))
      --PRINT('CGC3: '+ CAST(@VA1_CGC AS VARCHAR))

      SET @VDB_CLI_CODIGO = @VA1_COD;

      INSERT INTO DB_CLIENTE
        (
         DB_CLI_CODIGO,       -- 1
         DB_CLI_NOME,
         DB_CLI_CGCMF,
         DB_CLI_ENDERECO,
         DB_CLI_BAIRRO,       -- 5
         DB_CLI_CGCTE,
         DB_CLI_CIDADE,
         DB_CLI_ESTADO,
         DB_CLI_CEP,
         DB_CLI_CONTATO,      -- 10
         DB_CLI_TELEFONE,
         DB_CLI_COGNOME,
         DB_CLI_COB_ENDER,
         DB_CLI_COB_BAIRRO,
         DB_CLI_COB_CIDADE,   -- 15
         DB_CLI_COB_ESTADO,
         DB_CLI_COB_CEP,
         DB_CLI_FAX,
         DB_CLI_REPRES,
         DB_CLI_SITUACAO,     -- 20
         --DB_CLI_PORTADOR,
         DB_CLI_TRANSP,
         DB_CLI_LIM_CREDAP,
         DB_CLI_DATA_LIMITE,
         DB_CLI_LPRECO,       --25
         DB_CLI_OBSERV,
         DB_CLI_RAMATIV,
         DB_CLI_TIPO_PESSOA,
         DB_CLI_DATA_CADAS,
         --DB_CLI_ULT_ALTER,    --30
         --DB_CLI_FONE_CEL,
         DB_CLI_CLASCOM,
         --DB_CLI_MOTIVA,
         --DB_CLI_COMUNIC,
         --DB_CLI_CX_POSTAL,    --35
         --DB_CLI_COB_FONE,
         DB_CLI_DATA_ENVIO,
         DB_CLI_SUFRAMA,
         DB_CLI_COB_CGCMF,
         DB_CLI_ALT_CORP,     -- 40
         DB_CLI_DATA_FUNDAC,
         DB_CLI_VINCULO
        )
      VALUES
        (
         CAST(@VA1_COD AS FLOAT),                             -- 1
         SUBSTRING(RTRIM(@VA1_NOME),1,40),
         RTRIM(LTRIM(@VA1_CGC)),
         SUBSTRING(RTRIM(@VA1_END),1,36),
         SUBSTRING(REPLACE(RTRIM(@VA1_BAIRRO),'(',''),1,19),  -- 5
         RTRIM(@VA1_INSCR),
         SUBSTRING(RTRIM(@VA1_MUN),1,30),
         @VA1_EST,
         CAST(REPLACE(@VA1_CEP,' ','') AS INT),
         SUBSTRING(RTRIM(@VA1_CONTATO),1,20),                 -- 10
         SUBSTRING(RTRIM(@VA1_DDD) + ' ' + RTRIM(@VA1_TEL), 1, 15),
         SUBSTRING(RTRIM(@VA1_NREDUZ),1,15),
         CASE SUBSTRING(RTRIM(@VA1_ENDCOB),1,40) WHEN '' THEN SUBSTRING(RTRIM(@VA1_END),1,36) ELSE SUBSTRING(RTRIM(@VA1_ENDCOB),1,40) END,
         CASE SUBSTRING(REPLACE(RTRIM(@VA1_BAIRROC),'(',''),1,25) WHEN '' THEN SUBSTRING(REPLACE(RTRIM(@VA1_BAIRRO),'(',''),1,19) ELSE SUBSTRING(REPLACE(RTRIM(@VA1_BAIRROC),'(',''),1,25) END,
         SUBSTRING(RTRIM(@VA1_MUNC),1,30),                    -- 15
         CASE @VA1_ESTC WHEN '' THEN @VA1_EST ELSE @VA1_ESTC END,
         CASE CAST(REPLACE(REPLACE(@VA1_CEPC,'-',''),' ','') AS INT) WHEN '' THEN CAST(REPLACE(@VA1_CEP,' ','') AS INT) ELSE CAST(REPLACE(REPLACE(@VA1_CEPC,'-',''),' ','') AS INT) END,
         @VA1_FAX,
         @VREPRES, --REPLACE(@VA1_VEND,' ',NULL),
         CASE RTRIM(@VA1_MSBLQL) WHEN '1' THEN 3 ELSE 0 END,  -- 20
         --CAST(REPLACE(REPLACE(@VA1_BCO1,' ',''), 'PA', '') AS INT),
         REPLACE(@VA1_TRANSP,' ',NULL),
         ROUND(@VA1_LC, 2),
         CONVERT(CHAR,LTRIM(@VA1_VENCLC),103),
         @VA1_TABELA,                                         -- 25
         SUBSTRING(RTRIM(@VA1_OBSALI),1,255),
         RTRIM(SUBSTRING(@VA1_VACANAL,1,5)),
         CASE RTRIM(SUBSTRING(@VA1_CGC,12,3)) WHEN '' THEN 1 ELSE 0 END,
         GETDATE(),
         --CONVERT(CHAR,LTRIM(@VA1_DTALTER),103),             --30
         --RTRIM(@VA1_CELULAR),
         @VA1_CNAE,
         --SUBSTR(VA1_MOTIVA,1,1),
         --SUBSTR(VA1_COMUNI,1,1),
         --RTRIM(SUBSTRING(@VA1_CXPOSTA,1,10)),               -- 35
         --RTRIM(@VA1_FONECOB),
         CAST(GETDATE() AS SMALLDATETIME),
         SUBSTRING(@VA1_SUFRAMA,1,12),
         RTRIM(LTRIM(@VA1_CGC)),
         GETDATE(),                                           -- 40
         '1900-01-01',
         CAST(@VA1_COD AS FLOAT)
        );
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VERRO = '2 - ERRO INSERT DB_CLIENTE:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
      END
	  ELSE
	  BEGIN
		  INSERT INTO DB_CLIENTE_ATRIB
			(
				db_clia_codigo,
				db_clia_atrib,
				db_clia_valor
			)
		  VALUES
			(
			 CAST(@VA1_COD AS FLOAT), 
			 '208',
			 @VA1_CONTAT3
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '2 - ERRO INSERT DB_CLIENTE_ATRIB:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END
		END
	BEGIN
		  INSERT INTO DB_CLIENTE_ATRIB
			(
				db_clia_codigo,
				db_clia_atrib,
				db_clia_valor
			)
		  VALUES
			(
			 CAST(@VA1_COD AS FLOAT), 
			 '209',
			 @VA1_TELCOB
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '2 - ERRO INSERT DB_CLIENTE_ATRIB:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END
		END
		BEGIN
		  INSERT INTO DB_CLIENTE_ATRIB
			(
				db_clia_codigo,
				db_clia_atrib,
				db_clia_valor
			)
		  VALUES
			(
			 CAST(@VA1_COD AS FLOAT), 
			 '210',
			 @VA1_VAEMLF
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '2 - ERRO INSERT DB_CLIENTE_ATRIB:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END
		END

		BEGIN
		  INSERT INTO DB_CLIENTE_ATRIB
			(
				db_clia_codigo,
				db_clia_atrib,
				db_clia_valor
			)
		  VALUES
			(
			 CAST(@VA1_COD AS FLOAT), 
			 '212',
			 @VA1_VABCOF
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '2 - ERRO INSERT DB_CLIENTE_ATRIB:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END
		END

		BEGIN
		  INSERT INTO DB_CLIENTE_ATRIB
			(
				db_clia_codigo,
				db_clia_atrib,
				db_clia_valor
			)
		  VALUES
			(
			 CAST(@VA1_COD AS FLOAT), 
			 '213',
			 @VA1_VAAGFIN
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '2 - ERRO INSERT DB_CLIENTE_ATRIB:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END
		END

		BEGIN
		  INSERT INTO DB_CLIENTE_ATRIB
			(
				db_clia_codigo,
				db_clia_atrib,
				db_clia_valor
			)
		  VALUES
			(
			 CAST(@VA1_COD AS FLOAT), 
			 '214',
			 @VA1_VACTAFN
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '2 - ERRO INSERT DB_CLIENTE_ATRIB:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END
		END

		BEGIN
		  INSERT INTO DB_CLIENTE_ATRIB
			(
				db_clia_codigo,
				db_clia_atrib,
				db_clia_valor
			)
		  VALUES
			(
			 CAST(@VA1_COD AS FLOAT), 
			 '215',
			 @VA1_VACGCFI
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '2 - ERRO INSERT DB_CLIENTE_ATRIB:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END
		END

   END
   ELSE
   BEGIN

      --PRINT('UPDATE: '+ CAST(CAST(@VA1_COD AS FLOAT) AS VARCHAR))
      --PRINT('ENDER COB: '+  ISNULL(SUBSTRING(RTRIM(@VA1_ENDCOB),1,40), SUBSTRING(RTRIM(@VA1_END),1,36))  )
      UPDATE DB_CLIENTE
         SET DB_CLI_NOME        = SUBSTRING(RTRIM(@VA1_NOME),1,40),
             DB_CLI_CGCMF       = RTRIM(LTRIM(@VA1_CGC)),
             DB_CLI_ENDERECO    = SUBSTRING(RTRIM(@VA1_END),1,36),
             DB_CLI_BAIRRO      = SUBSTRING(REPLACE(RTRIM(@VA1_BAIRRO),'(',''),1,19),
             DB_CLI_CGCTE       = RTRIM(@VA1_INSCR),
             DB_CLI_CIDADE      = SUBSTRING(RTRIM(@VA1_MUN),1,30),
             DB_CLI_ESTADO      = @VA1_EST,
             DB_CLI_CEP         = CAST(REPLACE(@VA1_CEP,' ','') AS INT),
             DB_CLI_CONTATO     = SUBSTRING(RTRIM(@VA1_CONTATO),1,20),
             DB_CLI_TELEFONE    = SUBSTRING(RTRIM(@VA1_DDD) + ' ' + RTRIM(@VA1_TEL), 1, 15),
             DB_CLI_COGNOME     = SUBSTRING(RTRIM(@VA1_NREDUZ),1,15),
             DB_CLI_COB_ENDER   = CASE SUBSTRING(RTRIM(@VA1_ENDCOB),1,40) WHEN '' THEN SUBSTRING(RTRIM(@VA1_END),1,36) ELSE SUBSTRING(RTRIM(@VA1_ENDCOB),1,40)END,
             DB_CLI_COB_BAIRRO  = CASE SUBSTRING(REPLACE(RTRIM(@VA1_BAIRROC),'(',''),1,25) WHEN '' THEN SUBSTRING(REPLACE(RTRIM(@VA1_BAIRRO),'(',''),1,19) ELSE SUBSTRING(REPLACE(RTRIM(@VA1_BAIRROC),'(',''),1,25) END,
             DB_CLI_COB_CIDADE  = RTRIM(@VA1_MUNC),
             DB_CLI_COB_ESTADO  = CASE @VA1_ESTC WHEN '' THEN @VA1_EST ELSE @VA1_ESTC END,
             DB_CLI_COB_CEP     = CASE CAST(REPLACE(REPLACE(@VA1_CEPC,'-',''),' ','') AS INT) WHEN '' THEN CAST(REPLACE(@VA1_CEP,' ','') AS INT) ELSE CAST(REPLACE(REPLACE(@VA1_CEPC,'-',''),' ','') AS INT) END,
             DB_CLI_FAX         = @VA1_FAX,
             DB_CLI_SITUACAO    = CASE RTRIM(@VA1_MSBLQL) WHEN '1' THEN 3 ELSE 0 END,
             --DB_CLI_PORTADOR    = CAST(REPLACE(REPLACE(@VA1_BCO1,' ',''), 'PA', '') AS INT),
             DB_CLI_TRANSP      = REPLACE(@VA1_TRANSP,' ',NULL),
             DB_CLI_LIM_CREDAP  = ROUND(@VA1_LC, 2),
             DB_CLI_DATA_LIMITE = CONVERT(CHAR,LTRIM(@VA1_VENCLC),103),
             --DB_CLI_LPRECO      = @VA1_TABELA, (DESATIVADO TEMPORARIAMENTE PARA NAO ATUALIZAR A LISTA DE PRECO)
             DB_CLI_OBSERV      = SUBSTRING(RTRIM(@VA1_OBSALI),1,255),
             DB_CLI_RAMATIV     = RTRIM(SUBSTRING(@VA1_VACANAL,1,5)),
             DB_CLI_TIPO_PESSOA = CASE RTRIM(SUBSTRING(@VA1_CGC,12,3)) WHEN '' THEN 1 ELSE 0 END,
             --DB_CLI_DATA_CADAS  = CONVERT(CHAR,@VA1_XDATAEN,103),
             --DB_CLI_ULT_ALTER   = CONVERT(CHAR,@VA1_DTALTER,103),
             --DB_CLI_FONE_CEL    = RTRIM(@VA1_CELULAR),
             DB_CLI_CLASCOM     = @VA1_CNAE,
             --DB_CLI_CX_POSTAL   = RTRIM(SUBSTRING(@VA1_CXPOSTA,1,10)),
             --DB_CLI_COB_FONE    = RTRIM(@VA1_FONECOB),
             DB_CLI_DATA_ENVIO  = ISNULL(DB_CLI_DATA_ENVIO, CAST(GETDATE() AS SMALLDATETIME)),
             DB_CLI_REPRES      = @VREPRES,  -- REPLACE(@VA1_VEND,' ',NULL),
             DB_CLI_SUFRAMA     = SUBSTRING(@VA1_SUFRAMA,1,12),
             DB_CLI_COB_CGCMF   = RTRIM(LTRIM(@VA1_CGC)),
             DB_CLI_ALT_CORP    = GETDATE(),
             DB_CLI_DATA_FUNDAC = '1900-01-01',
             DB_CLI_VINCULO     = CAST(@VA1_COD AS FLOAT)
       WHERE DB_CLI_CODIGO = @VDB_CLI_CODIGO; --CAST(@VA1_COD AS FLOAT);
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VERRO = '3 - ERRO UPDATE DB_CLIENTE:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
      END 
	  ELSE
	  BEGIN
		  UPDATE DB_CLIENTE_ATRIB
			 SET db_clia_valor = @VA1_CONTAT3 
		   WHERE db_clia_codigo = @VDB_CLI_CODIGO AND db_clia_atrib = '208'; 
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '3 - ERRO UPDATE DB_CLIENTE:' + @VA1_COD + ' - 208 - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END  
		END

		BEGIN
		  UPDATE DB_CLIENTE_ATRIB
			 SET db_clia_valor = @VA1_TELCOB 
		   WHERE db_clia_codigo = @VDB_CLI_CODIGO AND db_clia_atrib = '209'; 
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '3 - ERRO UPDATE DB_CLIENTE:' + @VA1_COD + ' - 209 - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END  
		END

		BEGIN
		  UPDATE DB_CLIENTE_ATRIB
			 SET db_clia_valor = @VA1_VAEMLF
		   WHERE db_clia_codigo = @VDB_CLI_CODIGO AND db_clia_atrib = '210'; 
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '3 - ERRO UPDATE DB_CLIENTE:' + @VA1_COD + ' - 210 - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END  
		END

		BEGIN
		  UPDATE DB_CLIENTE_ATRIB
			 SET db_clia_valor = @VA1_VABCOF
		   WHERE db_clia_codigo = @VDB_CLI_CODIGO AND db_clia_atrib = '212'; 
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '3 - ERRO UPDATE DB_CLIENTE:' + @VA1_COD + ' - 212 - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END  
		END

		BEGIN
		  UPDATE DB_CLIENTE_ATRIB
			 SET db_clia_valor = @VA1_VAAGFIN	
		   WHERE db_clia_codigo = @VDB_CLI_CODIGO AND db_clia_atrib = '213'; 
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '3 - ERRO UPDATE DB_CLIENTE:' + @VA1_COD + ' - 213 - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END  
		END

		BEGIN
		  UPDATE DB_CLIENTE_ATRIB
			 SET db_clia_valor = @VA1_VACTAFN	
		   WHERE db_clia_codigo = @VDB_CLI_CODIGO AND db_clia_atrib = '214'; 
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '3 - ERRO UPDATE DB_CLIENTE:' + @VA1_COD + ' - 214 - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END  
		END

		BEGIN
		  UPDATE DB_CLIENTE_ATRIB
			 SET db_clia_valor = @VA1_VACGCFI	
		   WHERE db_clia_codigo = @VDB_CLI_CODIGO AND db_clia_atrib = '215'; 
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '3 - ERRO UPDATE DB_CLIENTE:' + @VA1_COD + ' - 215 - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
		  END  
		END  
   END

   -- LOOP QUE INSERE NA DB_CLIENTE_DEL COM DESATIVA = 1 PARA INATIVAR O CLIENTE
   -- NA BASE REPRES E INATIVA A DB_CLIENTE_REPRES. COM ISSO FICARÁ APENAS 1 REPRESENTANTE
   -- ATIVO PARA O CLIENTE. 06/01/2009 - ALENCAR
   DECLARE CUR CURSOR
   FOR SELECT DB_CLIR_REPRES, DB_CLIR_EMPRESA, DB_CLIR_CLIENTE
         FROM DB_CLIENTE_REPRES
        WHERE DB_CLIR_CLIENTE  = @VDB_CLI_CODIGO  --CAST(@VA1_COD AS FLOAT)
          AND DB_CLIR_REPRES  <> @VREPRES
         OPEN CUR
        FETCH NEXT FROM CUR
         INTO @VREPRESAUX, @VEMPRESAAUX, @VCLIENTEAUX
        WHILE @@FETCH_STATUS = 0
       BEGIN

         SELECT @VINSERE = 1
           FROM DB_CLIENTE_DEL
          WHERE DB_CLIDEL_CLIENTE = @VDB_CLI_CODIGO  --CAST(@VA1_COD AS FLOAT)
            AND DB_CLIDEL_REPRES  = @VREPRESAUX;
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VINSERE = 0;
         END
 
         IF @VINSERE = 0
         BEGIN

            INSERT INTO DB_CLIENTE_DEL
              (
               DB_CLIDEL_CLIENTE,
               DB_CLIDEL_REPRES,
               DB_CLIDEL_DATA,
               DB_CLIDEL_DESATIVA
              )
            VALUES
              (
               @VDB_CLI_CODIGO,  --CAST(@VA1_COD AS FLOAT)
               @VREPRESAUX,
               CAST(GETDATE() AS SMALLDATETIME),
               1
              );
            SET @VCOD_ERRO = @@ERROR;
            IF @VCOD_ERRO > 0
            BEGIN
               SET @VERRO = '4 - ERRO INSERT DB_CLIENTE_DEL:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
            END   

         END;

         UPDATE DB_CLIENTE_REPRES
            SET DB_CLIR_SITUACAO = 3
          WHERE DB_CLIR_CLIENTE = @VDB_CLI_CODIGO --@VCLIENTEAUX
            AND DB_CLIR_REPRES  = @VREPRESAUX
            AND DB_CLIR_EMPRESA = @VEMPRESAAUX;
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '5 - ERRO UPDATE DB_CLIENTE_REPRES:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
         END  
                
        FETCH NEXT FROM CUR
         INTO @VREPRESAUX, @VEMPRESAAUX, @VCLIENTEAUX
       END;
        CLOSE CUR
   DEALLOCATE CUR

   -- DEFINE A EMPRESA DA CLIENTE_REPRES
   SET @VCLIR_EMPRESA = '01';

   IF ISNULL(LTRIM(RTRIM(@VA1_VEND)), '')  <> '' AND
      ISNULL(LTRIM(RTRIM(@VA1_VEND)), '0') <> '0'
   BEGIN

      SET @VINSERE = 0;

      SELECT @VINSERE = 1
        FROM DB_CLIENTE_REPRES
       WHERE DB_CLIR_CLIENTE = @VDB_CLI_CODIGO
         AND DB_CLIR_REPRES  = @VREPRES
         AND DB_CLIR_EMPRESA = @VCLIR_EMPRESA;
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VINSERE = 0;
      END

      IF @VINSERE = 0
      BEGIN

         INSERT INTO DB_CLIENTE_REPRES
           (
            DB_CLIR_CLIENTE,
            DB_CLIR_REPRES,
            DB_CLIR_EMPRESA,
            DB_CLIR_TRANSP,
            DB_CLIR_TIPO_FRETE,
            DB_CLIR_LPRECO,
            DB_CLIR_DESCTO,
            DB_CLIR_PRAZO_MAX,
            DB_CLIR_SITUACAO,
            DB_CLIR_OPERACAO,
            DB_CLIR_COND_PGTO
           )
         VALUES
           (
            @VDB_CLI_CODIGO,
            @VREPRES,
            @VCLIR_EMPRESA,
            CAST(REPLACE(@VA1_TRANSP,' ','') AS INT),
            CASE RTRIM(@VA1_TPFRET) WHEN 'F' THEN 3 ELSE 1 END,
            RTRIM(@VA1_TABELA),
            0,
            60,
            0,
            1,
            LTRIM(RTRIM(@VA1_COND))
           );
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '6 - ERRO INSERT DB_CLIENTE_REPRES:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
         END

      END
      ELSE
      BEGIN

         UPDATE DB_CLIENTE_REPRES
            SET DB_CLIR_TRANSP     = CAST(REPLACE(@VA1_TRANSP,' ','') AS INT),
                DB_CLIR_LPRECO     = RTRIM(@VA1_TABELA),
                DB_CLIR_TIPO_FRETE = CASE RTRIM(@VA1_TPFRET) WHEN 'F' THEN 3 ELSE 1 END,
                DB_CLIR_SITUACAO   = 0,
                DB_CLIR_COND_PGTO  = LTRIM(RTRIM(@VA1_COND))
          WHERE DB_CLIR_CLIENTE = @VDB_CLI_CODIGO
            AND DB_CLIR_REPRES  = @VREPRES
            AND DB_CLIR_EMPRESA = @VCLIR_EMPRESA;
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '7 - ERRO UPDATE DB_CLIENTE_REPRES:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
         END

      END;

   END
   --FIM REPRES. 1

   IF ISNULL(LTRIM(RTRIM(@VA1_VEND2)), '')  <> '' AND
      ISNULL(LTRIM(RTRIM(@VA1_VEND2)), '0') <> '0'
   BEGIN

      SET @VINSERE = 0;

      SELECT @VINSERE = 1
        FROM DB_CLIENTE_REPRES
       WHERE DB_CLIR_CLIENTE = @VDB_CLI_CODIGO
         AND DB_CLIR_REPRES  = @VREPRES2
         AND DB_CLIR_EMPRESA = @VCLIR_EMPRESA;
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VINSERE = 0;
      END

      IF @VINSERE = 0
      BEGIN

         INSERT INTO DB_CLIENTE_REPRES
           (
            DB_CLIR_CLIENTE,
            DB_CLIR_REPRES,
            DB_CLIR_EMPRESA,
            DB_CLIR_TRANSP,
            DB_CLIR_TIPO_FRETE,
            DB_CLIR_LPRECO,
            DB_CLIR_DESCTO,
            DB_CLIR_PRAZO_MAX,
            DB_CLIR_SITUACAO,
            DB_CLIR_OPERACAO,
            DB_CLIR_COND_PGTO
           )
         VALUES
           (
            @VDB_CLI_CODIGO,
            @VREPRES2,
            @VCLIR_EMPRESA,
            CAST(REPLACE(@VA1_TRANSP,' ','') AS INT),
            CASE RTRIM(@VA1_TPFRET) WHEN 'F' THEN 3 ELSE 1 END,
            RTRIM(@VA1_TABELA2),
            0,
            60,
            0,
            1,
            LTRIM(RTRIM(@VA1_COND))
           );
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '6 - ERRO INSERT DB_CLIENTE_REPRES 2:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
         END

      END
      ELSE
      BEGIN

         UPDATE DB_CLIENTE_REPRES
            SET DB_CLIR_TRANSP     = CAST(REPLACE(@VA1_TRANSP,' ','') AS INT),
                DB_CLIR_LPRECO     = RTRIM(@VA1_TABELA2),
                DB_CLIR_TIPO_FRETE = CASE RTRIM(@VA1_TPFRET) WHEN 'F' THEN 3 ELSE 1 END,
                DB_CLIR_SITUACAO   = 0,
                DB_CLIR_COND_PGTO  = LTRIM(RTRIM(@VA1_COND))
          WHERE DB_CLIR_CLIENTE = @VDB_CLI_CODIGO
            AND DB_CLIR_REPRES  = @VREPRES2
            AND DB_CLIR_EMPRESA = @VCLIR_EMPRESA;
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '7 - ERRO UPDATE DB_CLIENTE_REPRES 2:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
         END

      END;

   END
   --FIM REPRES. 2

   -- INSERE O PROMOTOR COMO MAIS UM REPRES DO CLIENTE
   SET @VINSERE = 0;
   IF ISNULL(LTRIM(RTRIM(@VA1_VAPROMO)),'')  <> '' AND
      ISNULL(LTRIM(RTRIM(@VA1_VAPROMO)),'0') <> '0'
   BEGIN

      SELECT @VINSERE = 1
        FROM DB_CLIENTE_REPRES
       WHERE DB_CLIR_CLIENTE = @VDB_CLI_CODIGO
         AND DB_CLIR_REPRES  = LTRIM(RTRIM(@VA1_VAPROMO))
         AND DB_CLIR_EMPRESA = @VCLIR_EMPRESA;
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VINSERE = 0;
      END

      IF @VINSERE = 0
      BEGIN

         INSERT INTO DB_CLIENTE_REPRES
           (
            DB_CLIR_CLIENTE,
            DB_CLIR_REPRES,
            DB_CLIR_EMPRESA,
            DB_CLIR_TRANSP,
            DB_CLIR_TIPO_FRETE,
            DB_CLIR_LPRECO,
            DB_CLIR_DESCTO,
            DB_CLIR_PRAZO_MAX,
            DB_CLIR_SITUACAO,
            DB_CLIR_OPERACAO,
            DB_CLIR_COND_PGTO
           )
         VALUES
           (
            @VDB_CLI_CODIGO,
            LTRIM(RTRIM(@VA1_VAPROMO)),
            @VCLIR_EMPRESA,
            CAST(REPLACE(@VA1_TRANSP,' ','') AS INT),
            CASE RTRIM(@VA1_TPFRET) WHEN 'F' THEN 3 ELSE 1 END,
            RTRIM(@VA1_TABELA),
            0,
            60,
            0,
            1,
            LTRIM(RTRIM(@VA1_COND))
           );
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '8 - ERRO INSERT DB_CLIENTE_REPRES:' + @VA1_VAPROMO + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
         END

      END
      ELSE
      BEGIN

         UPDATE DB_CLIENTE_REPRES
            SET DB_CLIR_TRANSP     = CAST(REPLACE(@VA1_TRANSP,' ','') AS INT),
                DB_CLIR_LPRECO     = RTRIM(@VA1_TABELA),
                DB_CLIR_TIPO_FRETE = CASE RTRIM(@VA1_TPFRET) WHEN 'F' THEN 3 ELSE 1 END,
                DB_CLIR_SITUACAO   = 0,
                DB_CLIR_COND_PGTO  = LTRIM(RTRIM(@VA1_COND))
          WHERE DB_CLIR_CLIENTE = @VDB_CLI_CODIGO
            AND DB_CLIR_REPRES  = LTRIM(RTRIM(@VA1_VAPROMO))
            AND DB_CLIR_EMPRESA = @VCLIR_EMPRESA;
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '9 - ERRO UPDATE DB_CLIENTE_REPRES:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
         END

      END

   END;

   -- DELETA REGISTRO SE ESTIVER INSERINDO OU ALTERANDO NA DB_CLIENTE_DEL
   -- E JA EXISTE REGISTRO PARA A CHAVE CLIENTE + REPRESENTANTE
   DECLARE CUR CURSOR
   FOR SELECT DB_CLIR_REPRES
         FROM DB_CLIENTE_REPRES
        WHERE DB_CLIR_CLIENTE  = @VDB_CLI_CODIGO  --CAST(@VA1_COD AS FLOAT)
          AND DB_CLIR_SITUACAO = 0
         OPEN CUR
        FETCH NEXT FROM CUR
         INTO @VREPRESAUX
        WHILE @@FETCH_STATUS = 0
       BEGIN
         DELETE FROM DB_CLIENTE_DEL
          WHERE DB_CLIDEL_CLIENTE = @VDB_CLI_CODIGO  --CAST(@VA1_COD AS FLOAT)
            AND DB_CLIDEL_REPRES = @VREPRESAUX
            AND ISNULL(DB_CLIDEL_DESATIVA,0) = 0;
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '10 - ERRO DELETE DB_CLIENTE_DEL:' + @VA1_COD  + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
         END   

        FETCH NEXT FROM CUR
         INTO @VREPRESAUX
       END;
        CLOSE CUR
   DEALLOCATE CUR

   -- PARA CLIENTES REDE DEVE INSERIR REGISTRO TAMBEM PARA A EMPRESA 101 - SANCHEZ
   IF RTRIM(SUBSTRING(@VA1_SATIV1,1,5)) = '010' -- REDES
   BEGIN

      SET @VCLIR_EMPRESA = '101' -- SANCHEZ

      IF ISNULL(LTRIM(RTRIM(@VA1_VEND)), '')  <> '' AND
         ISNULL(LTRIM(RTRIM(@VA1_VEND)), '0') <> '0'
      BEGIN

         SET @VINSERE = 0;
         SELECT @VINSERE = 1
           FROM DB_CLIENTE_REPRES
          WHERE DB_CLIR_CLIENTE = @VDB_CLI_CODIGO
            AND DB_CLIR_REPRES  = @VREPRES
            AND DB_CLIR_EMPRESA = @VCLIR_EMPRESA;
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VINSERE = 0;
         END

         IF @VINSERE = 0
         BEGIN

            INSERT INTO DB_CLIENTE_REPRES
              (
               DB_CLIR_CLIENTE,
               DB_CLIR_REPRES,
               DB_CLIR_EMPRESA,
               DB_CLIR_TRANSP,
               DB_CLIR_TIPO_FRETE,
               DB_CLIR_LPRECO,
               DB_CLIR_DESCTO,
               DB_CLIR_PRAZO_MAX,
               DB_CLIR_SITUACAO,
               DB_CLIR_OPERACAO,
               DB_CLIR_COND_PGTO
              )
            VALUES
              (
               @VDB_CLI_CODIGO,
               @VREPRES,
               @VCLIR_EMPRESA,
               CAST(REPLACE(@VA1_TRANSP,' ','') AS INT),
               CASE RTRIM(@VA1_TPFRET) WHEN 'F' THEN 3 ELSE 1 END,
               RTRIM(@VA1_TABELA),
               0,
               60,
               0,
               1,
               LTRIM(RTRIM(@VA1_COND))
              );
            SET @VCOD_ERRO = @@ERROR;
            IF @VCOD_ERRO > 0
            BEGIN
               SET @VERRO = '11 - ERRO INSERT DB_CLIENTE_REPRES:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
            END  

         END 
         ELSE
         BEGIN

            UPDATE DB_CLIENTE_REPRES
               SET DB_CLIR_TRANSP     = CAST(REPLACE(@VA1_TRANSP,' ','') AS INT),
                   DB_CLIR_LPRECO     = RTRIM(@VA1_TABELA),
                   DB_CLIR_TIPO_FRETE = CASE RTRIM(@VA1_TPFRET) WHEN 'F' THEN 3 ELSE 1 END,
                   DB_CLIR_SITUACAO   = 0,
                   DB_CLIR_COND_PGTO  = LTRIM(RTRIM(@VA1_COND))
             WHERE DB_CLIR_CLIENTE = @VDB_CLI_CODIGO
               AND DB_CLIR_REPRES  = @VREPRES
               AND DB_CLIR_EMPRESA = @VCLIR_EMPRESA;
            SET @VCOD_ERRO = @@ERROR;
            IF @VCOD_ERRO > 0
            BEGIN
               SET @VERRO = '12 - ERRO UPDATE DB_CLIENTE_REPRES:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
            END

         END;

      END

      -- INSERE O PROMOTOR COMO MAIS UM REPRES DO CLIENTE TAMBEM PARA A EMPRESA SANCHES
      SET @VINSERE = 0;
      IF ISNULL(LTRIM(RTRIM(@VA1_VAPROMO)),'')  <> '' AND
         ISNULL(LTRIM(RTRIM(@VA1_VAPROMO)),'0') <> '0'
      BEGIN

         SELECT @VINSERE = 1
           FROM DB_CLIENTE_REPRES
          WHERE DB_CLIR_CLIENTE = @VDB_CLI_CODIGO
            AND DB_CLIR_REPRES  = LTRIM(RTRIM(@VA1_VAPROMO))
            AND DB_CLIR_EMPRESA = @VCLIR_EMPRESA;
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VINSERE = 0;
         END

         IF @VINSERE = 0
         BEGIN

            INSERT INTO DB_CLIENTE_REPRES
              (
               DB_CLIR_CLIENTE,
               DB_CLIR_REPRES,
               DB_CLIR_EMPRESA,
               DB_CLIR_TRANSP,
               DB_CLIR_TIPO_FRETE,
               DB_CLIR_LPRECO,
               DB_CLIR_DESCTO,
               DB_CLIR_PRAZO_MAX,
               DB_CLIR_SITUACAO,
               DB_CLIR_OPERACAO,
               DB_CLIR_COND_PGTO
              )
            VALUES
              (
               @VDB_CLI_CODIGO,
               LTRIM(RTRIM(@VA1_VAPROMO)),
               @VCLIR_EMPRESA,
               CAST(REPLACE(@VA1_TRANSP,' ','') AS INT),
               CASE RTRIM(@VA1_TPFRET) WHEN 'F' THEN 3 ELSE 1 END,
               RTRIM(@VA1_TABELA),
               0,
               60,
               0,
               1,
               LTRIM(RTRIM(@VA1_COND))
              );
            SET @VCOD_ERRO = @@ERROR;
            IF @VCOD_ERRO > 0
            BEGIN
               SET @VERRO = '13 - ERRO INSERT DB_CLIENTE_REPRES:' + @VA1_VAPROMO + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
            END

         END
         ELSE
         BEGIN

            UPDATE DB_CLIENTE_REPRES
               SET DB_CLIR_TRANSP     = CAST(REPLACE(@VA1_TRANSP,' ','') AS INT),
                   DB_CLIR_LPRECO     = RTRIM(@VA1_TABELA),
                   DB_CLIR_TIPO_FRETE = CASE RTRIM(@VA1_TPFRET) WHEN 'F' THEN 3 ELSE 1 END,
                   DB_CLIR_SITUACAO   = 0,
                   DB_CLIR_COND_PGTO  = LTRIM(RTRIM(@VA1_COND))
             WHERE DB_CLIR_CLIENTE = @VDB_CLI_CODIGO
               AND DB_CLIR_REPRES  = LTRIM(RTRIM(@VA1_VAPROMO))
               AND DB_CLIR_EMPRESA = @VCLIR_EMPRESA;
            SET @VCOD_ERRO = @@ERROR;
            IF @VCOD_ERRO > 0
            BEGIN
               SET @VERRO = '14 - ERRO UPDATE DB_CLIENTE_REPRES:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
            END

         END

      END;

   END
   -- FIM - PARA CLIENTES REDE DEVE INSERIR REGISTRO TAMBEM PARA A EMPRESA 101 - SANCHEZ

   -- ATUALIZA O COMPLEMENTO
   SET @VAUX_CLI_NOVO = 0;
   SELECT @VAUX_CLI_NOVO = COUNT(*)
     FROM DB_CLIENTE_COMPL
    WHERE DB_CLIC_COD = @VDB_CLI_CODIGO;

   -------------------------------------------------------------------
   --  TRIBUTACAO ICMS (CLIENTE CONTRIBUINTE): 
   --  - NAO CONTRIBUINTE = A1_INSCR NULA, OU ISENTO
   --  - CONTRIBUITE = DEMAIS PESSOAS JURIDICAS  (A1_TIPO = J)
   --  - CONSUMIDOR FINAL = TODOS CONSIMIDORES FINAL (A1_TIPO = F)
   -------------------------------------------------------------------
   IF @VA1_TIPO = 'F' 
   BEGIN
      SET @VDB_CLIC_CONTR_ICMS = 2;
   END
   ELSE IF RTRIM(@VA1_INSCR) IS NULL OR UPPER(RTRIM(@VA1_INSCR)) LIKE '%ISENT%'
   BEGIN
      SET @VDB_CLIC_CONTR_ICMS = 1;
   END
   ELSE
   BEGIN
      SET @VDB_CLIC_CONTR_ICMS = 0;
   END

   IF @VA1_VAREGE = 0 
      SET @VDB_CLIC_CLASFIS = 0
   ELSE SET @VDB_CLIC_CLASFIS = @VA1_VAREGE 

   --IF @VA1_VAREGE = 0 
   --   SET @VDB_CLIC_CLASFIS = ''
   --ELSE SET @VDB_CLIC_CLASFIS = @VA1_VAREGE 

   IF ISNULL(@VAUX_CLI_NOVO,0) = 0 
   BEGIN

      INSERT INTO DB_CLIENTE_COMPL
        (
         DB_CLIC_COD,         -- 1
         DB_CLIC_EMAIL,
         DB_CLIC_SITE,
         DB_CLIC_CONTR_ICMS,
         DB_CLIC_RAMATIVII,   -- 5
         DB_CLIC_CLASFIS,
         DB_CLIC_COB_RAZAO,
         DB_CLIC_DTVALSUF,
         DB_CLIC_ATRASO_MED,
         DB_CLIC_OPTSIMPLES,  -- 10
         DB_CLIC_ORDCOMP
        )
      VALUES
        (
         @VDB_CLI_CODIGO,
         RTRIM(@VA1_EMAIL),
         RTRIM(@VA1_HPAGE),
         ROUND(@VDB_CLIC_CONTR_ICMS,2),
         RTRIM(SUBSTRING(@VA1_SATIV1,1,5)),          -- 5
         @VDB_CLIC_CLASFIS,                          -- 6
         SUBSTRING(RTRIM(@VA1_NOME),1,40),
         CASE @VA1_SUFRAMA WHEN '' THEN NULL ELSE '2999-12-31' END,
         @VA1_METR,
         CASE @VA1_SIMPNAC WHEN 1 THEN 1 ELSE 0 END,  -- 10
         RTRIM(@VA1_VAOC)
        );
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VERRO = '15 - ERRO INSERT DB_CLIENTE_COMPL:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
      END   

   END
   ELSE
   BEGIN

      UPDATE DB_CLIENTE_COMPL
         SET DB_CLIC_COD        = @VDB_CLI_CODIGO,
             DB_CLIC_EMAIL      = RTRIM(@VA1_EMAIL),
             DB_CLIC_SITE       = RTRIM(@VA1_HPAGE),
             DB_CLIC_CLASFIS    = @VDB_CLIC_CLASFIS,
             DB_CLIC_COB_RAZAO  = SUBSTRING(RTRIM(@VA1_NOME),1,40),
             DB_CLIC_RESTRICAO  = NULL,
             DB_CLIC_DTVALSUF   = CASE @VA1_SUFRAMA WHEN '' THEN NULL ELSE '2999-12-31' END,
             DB_CLIC_ATRASO_MED = @VA1_METR,
             DB_CLIC_CONTR_ICMS = ROUND(@VDB_CLIC_CONTR_ICMS,2),
             DB_CLIC_RAMATIVII  = RTRIM(SUBSTRING(@VA1_SATIV1,1,5)),
             DB_CLIC_OPTSIMPLES = CASE @VA1_SIMPNAC WHEN 1 THEN 1 ELSE 0 END,
             DB_CLIC_ORDCOMP    = RTRIM(@VA1_VAOC)
       WHERE DB_CLIC_COD = CAST(@VA1_COD AS FLOAT);
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VERRO = '16 - ERRO UPDATE DB_CLIENTE_COMPL:' + @VA1_COD + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
      END   

   END

END

/**************
            ---------------------------------------------
            --- ATUALIZA A REDE DE CLIENTES
            ---    CADASTRO DE REDES: TABELA ZGE
            ---    CAMPO REDE NO CADASTRO DO CLIENTE: A1_ZZBAND
            ---------------------------------------------
            IF ISNULL(@VA1_ZZBAND, '') <> '' BEGIN

                --- BUSCA A DESCRICAO DA REDE NO CADASTRO DO PROTHEUS
                SELECT @VZGE_NOME = ZGE_NOME 
                  FROM P1180_PRODUCAO..ZGE 
                 WHERE ZGE_COD = @VA1_ZZBAND

                --- VERIFICA SE A REDE JA EXISTE
                SET @VINSERE_REDE = 0
                SELECT @VINSERE_REDE = 1
                     , @VDB_TBREDE_CLIENTE  = DB_TBREDE_CLIENTE
                     , @VCGCS               = ISNULL(RTRIM(DB_TBREDE_CGCS), '') + ISNULL(RTRIM(DB_TBREDE_CGCS2), '')
                  FROM DB_TB_REDE
                 WHERE DB_TBREDE_CODIGO = @VA1_ZZBAND

                 IF @VINSERE_REDE = 0 
                 BEGIN
                    INSERT INTO DB_TB_REDE (DB_TBREDE_CODIGO           -- 1
                                          , DB_TBREDE_DESCR        
                                          , DB_TBREDE_CLIENTE
                                          , DB_TBREDE_CGCS
                                          , DB_TBREDE_CGCS2
                                          )
                                    VALUES (@VA1_ZZBAND                -- 1
                                          , SUBSTRING(@VZGE_NOME, 1, 30)
                                          , @VDB_CLI_CODIGO
                                          , SUBSTRING(RTRIM(LTRIM(@VA1_CGC)), 1, 8)
                                          , ''
                                          ) 
                                            
                 END
                 ELSE
                 BEGIN
                    
PRINT 'ANTES @VCGCS ' + @VCGCS            
PRINT 'TENTANDO ENCONTRAR ' + SUBSTRING(RTRIM(LTRIM(@VA1_CGC)), 1, 8)
                    IF @VCGCS NOT LIKE '%' + SUBSTRING(RTRIM(LTRIM(@VA1_CGC)), 1, 8) + '%'
                        SET @VCGCS = @VCGCS + ',' + SUBSTRING(RTRIM(LTRIM(@VA1_CGC)), 1, 8)

PRINT 'DEPOIS @VCGCS ' + @VCGCS
                    UPDATE DB_TB_REDE 
                       SET DB_TBREDE_DESCR = SUBSTRING(@VZGE_NOME, 1, 30)
                         , DB_TBREDE_CGCS  = SUBSTRING(@VCGCS, 1, 1024)
                         , DB_TBREDE_CGCS2  = SUBSTRING(@VCGCS, 1025, 1024)
                     WHERE DB_TBREDE_CODIGO = @VA1_ZZBAND
                 END

                 --- ATUALIZA O VINCULO DO CLIENTE COM O CODIGO DO CLIENTE MATRIZ DA REDE
                 UPDATE DB_CLIENTE 
                    SET DB_CLI_VINCULO   = @VDB_TBREDE_CLIENTE
                  WHERE DB_CLI_CODIGO = @VDB_CLI_CODIGO;

            END 

            ---------------------------------------------
            --- FIM ATUALIZA A REDE DE CLIENTES
            ---------------------------------------------
************/

IF @VERRO IS NOT NULL
BEGIN
   SET @VDATA = CAST(GETDATE() AS SMALLDATETIME);
   INSERT INTO DBS_ERROS_TRIGGERS
     (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
   VALUES
     (@VERRO, @VDATA, @VOBJETO);
END

END TRY

BEGIN CATCH
  SELECT @VERRO = CAST(ERROR_NUMBER() AS VARCHAR) + ERROR_MESSAGE()

  PRINT @VERRO
--  INSERT INTO DBS_ERROS_TRIGGERS
--    (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
--  VALUES
--    (@VERRO, GETDATE(), @VOBJETO);
END CATCH

END
GO
