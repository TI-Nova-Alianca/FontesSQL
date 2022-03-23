SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_INSERE_PEDIDO_ERP] (@PDB_PED_NRO_NUM NUMERIC,
                                                 @PRETORNO        VARCHAR(255) OUTPUT,
                                                 @PPEDIDO_PAI     NUMERIC
                                                ) AS

BEGIN

DECLARE @VOBJETO               VARCHAR(200) SELECT @VOBJETO = 'MERCP_INSERE_PEDIDO_ERP';
DECLARE @VERRO                 VARCHAR(2000);
DECLARE @VDATA                 DATETIME;
DECLARE @VINSERE               NUMERIC;
DECLARE @VR_E_C_N_O_           NUMERIC;
DECLARE @VR_E_C_D_E_L_         NUMERIC;
DECLARE @VDB_PROD_DESC         VARCHAR(40);
DECLARE @VDB_PROD_UM           VARCHAR(2);
DECLARE @VDB_PROD_SITTRIB      VARCHAR(4);
DECLARE @VSTRINGAUX            VARCHAR(100);
DECLARE @VCOD_ERRO             VARCHAR(1000);
DECLARE @VDB_PED_EMPRESA       VARCHAR(3);
DECLARE @VDB_PED_CLIENTE       NUMERIC;
DECLARE @VLOJA_CLIENTE         VARCHAR(2);  -- Robert, 12/11/2018
DECLARE @VDB_PED_PRZPGTO       VARCHAR(255);
DECLARE @VDB_PED_NRO           VARCHAR(9);
DECLARE @VPEDIDO_PAI           VARCHAR(9);
DECLARE @VDB_PED_TIPO          VARCHAR(3);
DECLARE @VDB_PED_SITUACAO      NUMERIC;
DECLARE @VDB_PED_COND_PGTO     NUMERIC;
DECLARE @VDB_PED_DESCTO        NUMERIC;
DECLARE @VDB_PED_DESCTO2       NUMERIC;
DECLARE @VDB_PED_DESCTO3       NUMERIC;
DECLARE @VDB_PED_DESCTO4       NUMERIC;
DECLARE @VDB_PED_DESCTO5       NUMERIC;
DECLARE @VDB_PED_DESCTO7       NUMERIC;
DECLARE @VDB_PED_PORTADOR      NUMERIC;
DECLARE @VDB_PED_DT_EMISSAO    DATETIME;
DECLARE @VDB_PED_TEXTO         VARCHAR(255);
DECLARE @VDB_PED_OPERACAO      VARCHAR(6);
DECLARE @VDB_PED_COD_TRANSP    FLOAT;
DECLARE @VDB_PED_COMISO        FLOAT;
DECLARE @VDB_PED_ORD_COMPRA    VARCHAR(25);
DECLARE @VDB_PED_TIPO_FRETE    SMALLINT;
DECLARE @VDB_PEDC_FORMA_PGTO   SMALLINT;
DECLARE @VDB_PEDI_OPERACAO     VARCHAR(10);
DECLARE @VDB_PEDI_PRODUTO      VARCHAR(16);
DECLARE @VDB_PEDI_SEQUENCIA    NUMERIC;
DECLARE @VDB_PEDI_QTDE_SOLIC   REAL;
DECLARE @VDB_PEDI_TIPO         VARCHAR(1);
DECLARE @VDB_PEDI_PRECO_LIQ    REAL;
DECLARE @VDB_PEDI_DESCTOP      REAL;
DECLARE @VDB_PEDI_PRECO_UNIT   REAL;
DECLARE @VDB_PEDI_ALMOXARIF    VARCHAR(2);
DECLARE @VDB_PEDI_PREV_ENTR    DATETIME;
DECLARE @VDB_CLI_ESTADO        VARCHAR(8);
DECLARE @VQUEBRA               NUMERIC;
DECLARE @VRETORNO              VARCHAR(255);
DECLARE @VSEQ                  NUMERIC SELECT @VSEQ = 0;
DECLARE @VNPER                 FLOAT SELECT @VNPER = 0.90;
DECLARE @VNPEREMB              FLOAT SELECT @VNPEREMB = 0.15;
DECLARE @VDB_CLI_RAMATIV       VARCHAR(5);
DECLARE @VDB_PED_LISTA_PRECO   VARCHAR(8);
DECLARE @VDB_TBREP_CODORIG     INT;
DECLARE @VDB_PED_NRO_ORIG      VARCHAR(6);
DECLARE @VFILIAL               VARCHAR(2);
DECLARE @VB1_SEGUM             VARCHAR(2);
DECLARE @V_TOTAL_PEDIDO        REAL;
DECLARE @VB1_CONV              FLOAT;
DECLARE @VB1_TIPCONV           VARCHAR(1);
DECLARE @VB1_GRUPO             VARCHAR(4);
DECLARE @VDB_PEDI_PERC_COMIS   REAL;
DECLARE @VZC5_FILA             VARCHAR(10);
DECLARE @VA1_TPFRET            VARCHAR(50);
DECLARE @VDB_TBOPS_FAT         VARCHAR(1);
DECLARE @VLIBERASEMSALDO       INT;
DECLARE @VDB_PEDC_OPC_FATUR    VARCHAR(5);
DECLARE @VDB_PED_OBSERV        VARCHAR(255);
DECLARE @VDB_PEDC_OBSTRANSP    VARCHAR(255);
DECLARE @VZC5_MTDSB1           VARCHAR(2);
DECLARE @VZC5_VLDSB1           FLOAT;
DECLARE @VZC5_HSTDB1           VARCHAR(100);
DECLARE @VZC5_MTDSB2           VARCHAR(2);
DECLARE @VZC5_VLDSB2           FLOAT;
DECLARE @VZC5_HSTDB2           VARCHAR(100);
DECLARE @VZC5_MTDSB3           VARCHAR(2);
DECLARE @VZC5_VLDSB3           FLOAT;
DECLARE @VZC5_HSTDB3           VARCHAR(100);
DECLARE @VZC5_MENNOT           VARCHAR(180);
DECLARE @VZC5_OBS              VARCHAR(150);
DECLARE @VZC5_VAOBSLG          VARCHAR(150);
DECLARE @V_SEQUENCIA           INT;
DECLARE @V_APLICACAO           VARCHAR(1);
DECLARE @V_VALOR               FLOAT;
DECLARE @V_MOTIVO_INVESTIMENTO INT;
DECLARE @V_DB_PEDD_DESCONTO    FLOAT;
DECLARE @V_ZC5_NOMARQ          NVARCHAR(20);
DECLARE @V_ZC5_PEDCLI          NVARCHAR(20);
DECLARE @VB1_LOCPAD            VARCHAR(2);
DECLARE @VPORTADOR             VARCHAR(3);

----------------------------------------------------------------------------------------------------------------------------------------------------------
---  VERSAO  DATA        AUTOR            ALTERACAO
---  1.0000  22/07/2010  SERGIO LUCCHINI  DESENVOLVIMENTO
---  1.0001  15/03/2016  ALENCAR          IMPLEMENTACOES FINI
---                                       ENVIA LOJA DO CLIENTE FIXO 01
---                                       CR_TIPOCLI = A1_TIPO
---  1.0002  27/04/2016  ALENCAR          QUANDO NAO TEM PEDIDO PAI, O CAMPO ZC5_PEDPAI RECEBE O NRO DO PROPRIO PEDIDO
---  1.0003  28/04/2016  ALENCAR          GRAVA O CAMPO ZC5_ELIRES - ELIMINA RESIDUO
---  1.0004  20/06/2016  ALENCAR          ENVIA O % DE COMISSAO DO ITEM (DB_PEDI_PERC_COMIS) PARA O CAMPO ZC6_COMIS1 
---  1.0005  27/06/2016  ALENCAR          CORRIGIDA FORMULA DO ZC6_VALOR
---                                       ENVIA CORRETAMENTE A TRANSPORTADORA PARA O CAMPO ZC5_TRANSP
---  1.0006  04/07/2016  ALENCAR          ATUALIZA CORRETAMENTE A LINHA NO UPDATE
---  1.0007  05/07/2016  ALENCAR          AO VERIFICAR SE DEVE INSERIR O REGISTRO, VERIFICA APENAS O ZC5_PEDMER E ZC6_PEDMER SEM FILIAL
---                                       ARREDONDAR EM 2 CASAS DECIMAIS O TOTAL DO PEDIDO (@V_TOTAL_PEDIDO)
---  1.0008  07/07/2016  ALENCAR          EXPORTAR OS CAMPOS COM VALORES E MOTIVOS DE INVESTIMENTO ZC5_MTDSB1, ZC5_VLDSB1, ZC5_HSTDB1
---                                       ZC5_MTDSB2, ZC5_VLDSB2, ZC5_HSTDB2, ZC5_MTDSB3, ZC5_VLDSB3 E ZC5_HSTDB3
---  1.0009  09/08/2016  ALENCAR          GRAVAR A MENSAGEM DA NOTA (ZC5_MENNOT) = ORDEM DE COMPRA + TEXTO A SER IMPRESSO NA NOTA
---  1.0010  25/08/2016  ALENCAR          GRAVAR OS DESCONTOS E MOTIVOS DE INVESTIMENTOS NA TABELA ZC7010
---                                       ENVIAR OS MOTIVOS DE INVESTIMENTO FORMATADOS COM TAMANHO 2 E ZEROS A ESQUERDA
---                                       GRAVAR O CAMPO ZC5_ZZDSCB = ISNULL(@VZC5_VLDSB1, 0) + ISNULL(@VZC5_VLDSB2, 0) + ISNULL(@VZC5_VLDSB3, 0)
---  1.0011  26/08/2016  ALENCAR          GRAVAR O CAMPO ZC7_SEQUEN FORMATADO COM TAMANHO 2
---  1.0012  09/09/2016  ALENCAR          GRAVAR INFORMACOES DOS PEDIDOS EDI, QUE SERAO UTILIZADOS PARA O RETORNO DA NOTA FISCAL (DB_EDI_PEDIDO_FINI)
---  1.0013  13/09/2016  ALENCAR          PARA PEDIDOS EDI ENVIA A MENSAGEM DA NOTA CFME A LOGISTICA NECESSITA, E JÁ ERA DESSA FORMA NO PROTHEUS
---  1.0014  10/11/2016  ALENCAR          CONVERSÃO NOVA ALIANCA
---                                       GRAVAR O CAMPO ZC6_LOCAL COM SB1010.B1_LOCPAD
---  1.0015  21/11/2016  ALENCAR          ENVIAR A CONDICAO DE PAGAMENTO COM TAMANHO 3 CARACTERES
---  1.0016  22/11/2016  ALENCAR          ENVIAR O PORTADOR (ZC5_BANCO) INFORMADO NA CONDICAO DE PAGAMENTO
---                                       ENVIAR MOTIVO DE BONIFICACAO (DB_PEDC_OPC_FATUR) PARA O CAMPO ZC6_BONIFIC
---  1.0017  09/01/2017  ALENCAR          AJUSTE NO CURSOR CPED_INS
---  1.0018  16/01/2017  ALENCAR          ENVIAR OS CAMPOS TRANSPORTADOR E REPRESENTANTE FORMATADOS COM ZEROS A ESQUERDA COM TAMANHO 3
---  1.0019  14/02/2017  ALENCAR          GRAVAR OS CAMPOS: ZC5_PEDCLI  - ORDEM DE COMPRA
---                                                         ZC5_OBS     - OBSERVACAO DO PEDIDO
---                                                         ZC5_MENNOT  - MENSAGEM DA NOTA
---                                                         ZC5_VAOBSLG - OBSERVACAO LOGISTICA3
---  1.0020  10/07/2017  SERGIO LUCCHINI  ALTERARADA A REGRA DE ENVIO DO TIPO DE FRETE. CHAMADO 77946
---          02/05/2018  ROBERT           Alterado nome do linked server de acesso ao ERP Protheus.
---          12/11/2018  ROBERT           Passa a buscar loja do cliente (@VLOJA_CLIENTE) na tabela SA1010 do ERP com base no CNPJ.
---          23/03/2022  Robert           Versao inicial utilizando sinonimos
---
----------------------------------------------------------------------------------------------------------------------------------------------------------

--PRINT 'MERCP_INSERE_PEDIDO_ERP_010 - P1'

--PRINT '@PDB_PED_NRO_NUM ' + CAST(@PDB_PED_NRO_NUM AS VARCHAR)

BEGIN TRY

BEGIN

DECLARE CPED_INS CURSOR
FOR SELECT DB_PED_EMPRESA,         DB_PED_CLIENTE,    DB_PED_PRZPGTO,     DB_PED_NRO,        DB_PED_TIPO,
           DB_PED_SITUACAO,        DB_PED_COND_PGTO,  DB_PED_DESCTO,      DB_PED_DESCTO2,    DB_PED_DESCTO3,
           DB_PED_DESCTO4,         DB_PED_DESCTO5,    DB_PED_DESCTO7,     DB_PED_PORTADOR,   DB_PED_DT_EMISSAO,
           DB_PED_TEXTO,           DB_PED_OPERACAO,   DB_CLI_ESTADO,      DB_PED_COD_TRANSP, DB_PED_COMISO,
           DB_PEDC_FORMA_PGTO,     DB_CLI_RAMATIV,    DB_PED_LISTA_PRECO, DB_PED_ORD_COMPRA, DB_TBREP_CODORIG,
           DB_PEDC_LIBERASEMSALDO, DB_PEDC_OPC_FATUR, DB_PED_OBSERV,      DB_PEDC_OBSTRANSP, DB_PED_TIPO_FRETE
      FROM DB_PEDIDO,
           DB_PEDIDO_COMPL,
           DB_TB_REPRES,
           DB_CLIENTE
     WHERE DB_PED_NRO      = @PDB_PED_NRO_NUM
       AND DB_PED_NRO      = DB_PEDC_NRO
       AND DB_TBREP_CODIGO = DB_PED_REPRES
       AND DB_CLI_CODIGO   = DB_PED_CLIENTE;
      OPEN CPED_INS
     FETCH NEXT FROM CPED_INS
      INTO @VDB_PED_EMPRESA,     @VDB_PED_CLIENTE,    @VDB_PED_PRZPGTO,     @VDB_PED_NRO,        @VDB_PED_TIPO,
           @VDB_PED_SITUACAO,    @VDB_PED_COND_PGTO,  @VDB_PED_DESCTO,      @VDB_PED_DESCTO2,    @VDB_PED_DESCTO3,
           @VDB_PED_DESCTO4,     @VDB_PED_DESCTO5,    @VDB_PED_DESCTO7,     @VDB_PED_PORTADOR,   @VDB_PED_DT_EMISSAO,
           @VDB_PED_TEXTO,       @VDB_PED_OPERACAO,   @VDB_CLI_ESTADO,      @VDB_PED_COD_TRANSP, @VDB_PED_COMISO,
           @VDB_PEDC_FORMA_PGTO, @VDB_CLI_RAMATIV,    @VDB_PED_LISTA_PRECO, @VDB_PED_ORD_COMPRA, @VDB_TBREP_CODORIG,
           @VLIBERASEMSALDO,     @VDB_PEDC_OPC_FATUR, @VDB_PED_OBSERV,      @VDB_PEDC_OBSTRANSP, @VDB_PED_TIPO_FRETE
     WHILE @@FETCH_STATUS = 0
    BEGIN

      --PRINT 'AQUI 2..'
      --PRINT('@VDB_PED_NRO :' + CAST(@VDB_PED_NRO AS VARCHAR));
      PRINT 'MERCP_INSERE_PEDIDO_ERP_010 - P5'

      --EXECUTE MERCP_RETORNA_PROXIMO_PEDIDO_ERP @VDB_PED_EMPRESA, @VDB_PED_NRO_ORIG OUTPUT

      -- COLOCA O PEDIDO COMO ENVIADO
      UPDATE DB_PEDIDO
         SET DB_PED_DATA_ENVIO = GETDATE(),
             DB_PED_SITCORP    = '01'
             --DB_PED_NRO_ORIG    = @VDB_PED_NRO_ORIG
       WHERE DB_PED_NRO = @PDB_PED_NRO_NUM

      -- ENCONTRA O TOTAL DO PEDIDO
      SELECT @V_TOTAL_PEDIDO = ROUND(SUM(DB_PEDI_QTDE_SOLIC * ROUND(DB_PEDI_PRECO_LIQ, 2)), 2)
        FROM DB_PEDIDO_PROD WITH (NOLOCK),
             DB_PRODUTO     WITH (NOLOCK)
       WHERE DB_PEDI_PEDIDO = @PDB_PED_NRO_NUM
         AND DB_PROD_CODIGO = DB_PEDI_PRODUTO

      SET @VFILIAL = SUBSTRING(@VDB_PED_EMPRESA, 2, 2)
      SET @VDB_PED_NRO = SUBSTRING(RIGHT('00000000' + CONVERT(VARCHAR(8), @PDB_PED_NRO_NUM), 8), 1, 4) + '/' + SUBSTRING(RIGHT('00000000' + CONVERT(VARCHAR(8), @PDB_PED_NRO_NUM), 8), 5, 4);
      SET @VPEDIDO_PAI = SUBSTRING(RIGHT('00000000' + CONVERT(VARCHAR(8), @PPEDIDO_PAI), 8), 1, 4) + '/' + SUBSTRING(RIGHT('00000000' + CONVERT(VARCHAR(8), @PPEDIDO_PAI), 8), 5, 4);

      --PRINT ('@VFILIAL ' + @VFILIAL)

      SELECT @VA1_TPFRET = A1_TPFRET
        FROM INTEGRACAO_PROTHEUS_SA1 WITH (NOLOCK)
       WHERE A1_COD = SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6), CAST(@VDB_PED_CLIENTE AS INT)), 6),1,6);
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VA1_TPFRET = NULL;
      END



	  -- BUSCA A LOJA DO CLIENTE NO ERP. Robert, 12/11/2018
      SELECT @VLOJA_CLIENTE = A1_LOJA
        FROM INTEGRACAO_PROTHEUS_SA1 WITH (NOLOCK)
       WHERE A1_CGC = (SELECT DB_CLI_CGCMF FROM DB_CLIENTE WHERE DB_CLI_CODIGO = @VDB_PED_CLIENTE) COLLATE DATABASE_DEFAULT
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VLOJA_CLIENTE = NULL;
      END




      SET @VDB_TBOPS_FAT = '';
      SELECT @VDB_TBOPS_FAT = DB_TBOPS_FAT
        FROM DB_TB_OPERS WITH (NOLOCK)
      WHERE DB_TBOPS_COD = @VDB_PED_OPERACAO;

      SELECT @VR_E_C_N_O_ = MAX(R_E_C_N_O_)
        FROM ZC5010  WITH (NOLOCK);
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VR_E_C_N_O_ = 1;
      END

      -- ENCONTRA OS VALORES DE BONIFICACAO DOS CONTRATOS DE INVESTIMENTO
      -- MOTIVO 1
      SELECT @VZC5_VLDSB1 = ROUND(VALOR, 2),
             @VZC5_MTDSB1 = SUBSTRING(RIGHT('00' + CONVERT(VARCHAR(2), MOTIVO_INVESTIMENTO), 2), 1, 2),
             @VZC5_HSTDB1 = SUBSTRING(OBSERVACAO, 1, 100) 
        FROM DB_PEDIDO_MOTIVO_INVESTIMENTO 
       WHERE PEDIDO    = @PDB_PED_NRO_NUM
         AND ITEM      = 0 
         AND SEQUENCIA = 1

      -- MOTIVO 2
      SELECT @VZC5_VLDSB2 = ROUND(VALOR, 2),
             @VZC5_MTDSB2 = SUBSTRING(RIGHT('00' + CONVERT(VARCHAR(2), MOTIVO_INVESTIMENTO), 2), 1, 2),
             @VZC5_HSTDB2 = SUBSTRING(OBSERVACAO, 1, 100) 
        FROM DB_PEDIDO_MOTIVO_INVESTIMENTO 
       WHERE PEDIDO    = @PDB_PED_NRO_NUM
         AND ITEM      = 0 
         AND SEQUENCIA = 2

      -- MOTIVO 3
      SELECT @VZC5_VLDSB3 = ROUND(VALOR, 2),
             @VZC5_MTDSB3 = SUBSTRING(RIGHT('00' + CONVERT(VARCHAR(2), MOTIVO_INVESTIMENTO), 2), 1, 2),
             @VZC5_HSTDB3 = SUBSTRING(OBSERVACAO, 1, 100) 
        FROM DB_PEDIDO_MOTIVO_INVESTIMENTO 
       WHERE PEDIDO    = @PDB_PED_NRO_NUM
         AND ITEM      = 0 
         AND SEQUENCIA = 3

      -- RECALCULA O VALOR TOTAL
      SET @V_TOTAL_PEDIDO = @V_TOTAL_PEDIDO - ISNULL(@VZC5_VLDSB1, 0) - ISNULL(@VZC5_VLDSB2, 0)  - ISNULL(@VZC5_VLDSB3, 0) 
      -- FIM - ENCONTRA OS VALORES DE BONIFICACAO DOS CONTRATOS DE INVESTIMENTO

      SELECT @VINSERE = 1
        FROM ZC5010  WITH (NOLOCK)
       WHERE --ZC5_FILIAL  = @VFILIAL AND 
             ZC5_PEDMER   = @VDB_PED_NRO
         AND D_E_L_E_T_ = ' ';
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VINSERE = 0;
      END

      -- GRAVA A MENSAGEM DA NOTA
      SET @V_ZC5_PEDCLI  = SUBSTRING(ISNULL(@VDB_PED_ORD_COMPRA, ''), 1, 20)
      SET @VZC5_OBS      = SUBSTRING(ISNULL(@VDB_PED_OBSERV, ''), 1, 150)
      SET @VZC5_MENNOT   = ISNULL(@VDB_PED_TEXTO, '')
      SET @VZC5_VAOBSLG  = SUBSTRING(ISNULL(@VDB_PEDC_OBSTRANSP, ''), 1, 150)
      SET @V_ZC5_PEDCLI = SUBSTRING(LEFT(@V_ZC5_PEDCLI + '                    ', 20), 1, 20)
      SET @VZC5_OBS = SUBSTRING(LEFT(@VZC5_OBS +
                                               + '                                                           '
                                               + '                                                           '
                                               + '                             ' , 150), 1, 150)
      SET @VZC5_MENNOT = SUBSTRING(LEFT(@VZC5_MENNOT +
                                                     + '                                                           '
                                                     + '                                                           '
                                                     + '                             ' , 150), 1, 150)
      -- ENVIA O PORTADOR QUE ESTA INFORMADO NA CONDICAO DE PAGAMENTO
      SELECT @VPORTADOR = DB_TBPORT_CODORIG
        FROM DB_TB_CPGTO,
             DB_TB_PORT
       WHERE DB_TBPORT_COD = DB_TBPGTO_PORTADOR
         AND DB_TBPGTO_COD = @VDB_PED_COND_PGTO
      -- FIM - GRAVA A MENSAGEM DA NOTA

      --PRINT('VAI ENTRAR NO INSERT 1 - @VINSERE: ' + CAST(ISNULL(@VINSERE,9) AS VARCHAR));
      --PRINT('@VDB_PED_NRO_ORIG ' + @VDB_PED_NRO_ORIG)

      IF ISNULL(@VINSERE,0) = 0
      BEGIN

         SELECT @VZC5_FILA = ISNULL(MAX(ZC5_FILA), 0) + 1 FROM ZC5010;
         --PRINT('ENTROU NO INSERT 1');

         INSERT INTO ZC5010
           (
            ZC5_FILIAL,  -- 01  VARCHAR(2)
            ZC5_CLIENT,  -- 02  VARCHAR(6)
            ZC5_LOJACL,  -- 03  VARCHAR(2)
            ZC5_TRANSP,  -- 04  VARCHAR(6)
            ZC5_CONDPA,  -- 05  VARCHAR(3)
            ZC5_TABELA,  -- 06  VARCHAR(3)
            ZC5_VEND1,   -- 07
            ZC5_BANCO,   -- 08  VARCHAR(3)
            ZC5_EMISSA,  -- 09  VARCHAR(8)
            ZC5_PEDMER,  -- 10
            ZC5_TPFRET,  -- 11  VARCHAR(1)
            ZC5_MENNOT,  -- 12  VARCHAR(120)
            D_E_L_E_T_,  -- 13  VARCHAR(1)
            R_E_C_N_O_,  -- 14  INT
            ZC5_VTOT,    -- 15
            ZC5_FILA,    -- 16
            ZC5_ERRO,    -- 17
            ZC5_STATUS,  -- 18
            ZC5_PROCRT,  -- 20
            ZC5_DTINC,   -- 21
            ZC5_HRINC,   -- 22
            ZC5_TIPVEN,  -- 23
            ZC5_PEDPAI,  -- 24
            ZC5_PEDCLI,  -- 25
            ZC5_OBS,     -- 26
            ZC5_VAOBSLG  -- 27
           )
         VALUES  -- SC5010  -- DB_PEDIDO
           (
            @VFILIAL,                                                   -- 01
            SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6), CAST(@VDB_PED_CLIENTE AS INT)), 6),1,6),   -- 02
            @VLOJA_CLIENTE, --'01',                                                       -- 03
            SUBSTRING(RIGHT('000' + CONVERT(VARCHAR(3), CAST(@VDB_PED_COD_TRANSP AS INT)), 3),1,3),   -- 04
            SUBSTRING(RIGHT('000' + CONVERT(VARCHAR(3), @VDB_PED_COND_PGTO), 3),1,3),                 -- 05
            SUBSTRING(@VDB_PED_LISTA_PRECO,1,3),                                                      -- 06
            SUBSTRING(RIGHT('000' + CONVERT(VARCHAR(3), CAST(@VDB_TBREP_CODORIG AS INT)), 3), 1, 3),  -- 07
            ISNULL(@VPORTADOR, ' '),                                    -- 08
            CONVERT(CHAR,@VDB_PED_DT_EMISSAO,112),                      -- 09
            @VDB_PED_NRO,                                               -- 10
            CASE WHEN @VDB_PED_TIPO_FRETE = 3 THEN 'F' ELSE 'C' END,    -- 11
            @VZC5_MENNOT,                                               -- 12
            ' ',                                                        -- 13
            ISNULL(@VR_E_C_N_O_, 0) + 1,                                -- 14
            ROUND(@V_TOTAL_PEDIDO, 2),                                  -- 15
            RIGHT('0000000000' + CAST(@VZC5_FILA AS VARCHAR(10)), 10),  -- 16
            ' ',                                                        -- 17
            'INS',                                                      -- 18
            ' ',                                                        -- 20
            CONVERT(CHAR,GETDATE(),112),                                -- 21
            CONVERT(CHAR,GETDATE(),108),                                -- 22
            CASE @VDB_TBOPS_FAT WHEN 'B' THEN 'B' ELSE 'V' END,         -- 23
            CASE ISNULL(@PPEDIDO_PAI, 0) WHEN 0 THEN @VDB_PED_NRO ELSE CAST(@VPEDIDO_PAI AS VARCHAR) END,  -- 24
            @V_ZC5_PEDCLI,                                               -- 25 
            @VZC5_OBS,                                                   -- 26 
            @VZC5_VAOBSLG                                                -- 27
           );
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO INSERT SC5010: C5_FILIAL' + @VFILIAL + ' C5_NUM: ' + @VDB_PED_NRO_ORIG + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
         END

      END
      ELSE
      BEGIN

         --PRINT('ENTROU NO UPDATE 1');
         -- DB_PEDIDO  -- DB_PEDIDO_COMPL
         UPDATE ZC5010
            SET ZC5_FILIAL  = @VFILIAL,
                ZC5_CLIENT  = SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6), CAST(@VDB_PED_CLIENTE AS INT)), 6), 1, 6),  -- NAO ALTERAR ESSA MASCARA
                ZC5_LOJACL  = '01', --SUBSTRING(RIGHT('0000000000' + CONVERT(VARCHAR(8), CAST(@VDB_PED_CLIENTE AS INT)), 8), 7, 2),  -- NAO ALTERAR ESSA MASCARA
                ZC5_TRANSP  = SUBSTRING(RIGHT('000' + CONVERT(VARCHAR(3), CAST(@VDB_PED_COD_TRANSP AS INT)), 3),1,3),
                ZC5_CONDPA  = SUBSTRING(RIGHT('000' + CONVERT(VARCHAR(3), @VDB_PED_COND_PGTO), 3),1,3),
                ZC5_TABELA  = SUBSTRING(@VDB_PED_LISTA_PRECO,1,3),
                ZC5_VEND1   = SUBSTRING(RIGHT('000' + CONVERT(VARCHAR(3), CAST(@VDB_TBREP_CODORIG AS INT)), 3), 1, 3),
                ZC5_BANCO   = ISNULL(@VPORTADOR, ' '),
                ZC5_EMISSA  = CONVERT(CHAR,@VDB_PED_DT_EMISSAO,112),
                ZC5_MENNOT  = @VZC5_MENNOT,
                ZC5_TPFRET  = CASE WHEN @VDB_PED_TIPO_FRETE = 3 THEN 'F' ELSE 'C' END,
                ZC5_VTOT    = ROUND(@V_TOTAL_PEDIDO, 2),
                ZC5_ERRO    = ' ',
                ZC5_DTINI   = ' ',
                ZC5_HRINI   = ' ',
                ZC5_DTFIM   = ' ',
                ZC5_HRFIM   = ' ',
                ZC5_NUM     = ' ',
                ZC5_STATUS  = 'INS',
                ZC5_PROCRT  = ' ',
                ZC5_DTINC   = CONVERT(CHAR,GETDATE(),112),
                ZC5_HRINC   = CONVERT(CHAR,GETDATE(),108), 
                ZC5_TIPVEN  = CASE @VDB_TBOPS_FAT WHEN 'B' THEN 'B' ELSE 'V' END,
                ZC5_PEDPAI  = CASE ISNULL(@PPEDIDO_PAI, 0) WHEN 0 THEN @VDB_PED_NRO ELSE CAST(@VPEDIDO_PAI AS VARCHAR) END,
                ZC5_PEDCLI  = @V_ZC5_PEDCLI,
                ZC5_OBS     = @VZC5_OBS,
                ZC5_VAOBSLG = @VZC5_VAOBSLG
          WHERE ZC5_PEDMER = @VDB_PED_NRO
            AND D_E_L_E_T_ = ' ';
			--AND ZC5_FILIAL = @VFILIAL
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '2 - ERRO UPDATE SC5010: C5_FILIAL' + @VFILIAL + ' C5_NUM: ' + @VDB_PED_NRO_ORIG + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
         END

      END

      -- TENTA ELIMINAR TODOS OS ITENS DO PEDIDO NA INTERFACE
      DELETE ZC6010
       WHERE --ZC6_FILIAL  = @VFILIAL AND 
             ZC6_PEDMER  = @VDB_PED_NRO

      DECLARE CPED_PROD CURSOR
      FOR SELECT DB_PEDI_PRODUTO,   DB_PEDI_SEQUENCIA, DB_PEDI_TIPO,       DB_PEDI_QTDE_SOLIC,
                 DB_PEDI_PRECO_LIQ, DB_PEDI_DESCTOP,   DB_PEDI_PRECO_UNIT, DB_PEDI_ALMOXARIF,
                 DB_PEDI_PREV_ENTR, DB_PEDI_OPERACAO,  DB_PEDI_PERC_COMIS
            FROM DB_PEDIDO_PROD, DB_PRODUTO
           WHERE DB_PEDI_PEDIDO = @PDB_PED_NRO_NUM
             AND DB_PROD_CODIGO = DB_PEDI_PRODUTO;
            OPEN CPED_PROD
           FETCH NEXT FROM CPED_PROD
            INTO @VDB_PEDI_PRODUTO,   @VDB_PEDI_SEQUENCIA, @VDB_PEDI_TIPO,       @VDB_PEDI_QTDE_SOLIC,
                 @VDB_PEDI_PRECO_LIQ, @VDB_PEDI_DESCTOP,   @VDB_PEDI_PRECO_UNIT, @VDB_PEDI_ALMOXARIF,
                 @VDB_PEDI_PREV_ENTR, @VDB_PEDI_OPERACAO,  @VDB_PEDI_PERC_COMIS
           WHILE @@FETCH_STATUS = 0
          BEGIN

            --PRINT('CURSOR ITENS: ' + CAST(@VDB_PEDI_PRODUTO AS VARCHAR));

            SELECT @VR_E_C_N_O_ = MAX(R_E_C_N_O_) FROM ZC6010;
            SET @VCOD_ERRO = @@ERROR;
            IF @VCOD_ERRO > 0
            BEGIN
               SET @VR_E_C_N_O_ = 1;
            END

            --PRINT('@VDB_PEDI_PRODUTO: ' + CAST(@VDB_PEDI_PRODUTO AS VARCHAR));
            --PRINT('@VDB_PED_EMPRESA: ' + CAST(@VDB_PED_EMPRESA AS VARCHAR));
            --PRINT('@VDB_PEDI_OPERACAO: ' + CAST(@VDB_PEDI_OPERACAO AS VARCHAR));

            SELECT @VDB_PROD_DESC    = B1_DESC,
                   @VDB_PROD_SITTRIB = LTRIM(RTRIM(B1_ORIGEM)) + LTRIM(RTRIM(F4_SITTRIB)),
                   @VDB_PROD_UM      = B1_UM,
                   @VB1_SEGUM        = B1_SEGUM,
                   @VB1_CONV            = B1_CONV, 
                   @VB1_TIPCONV      = B1_TIPCONV,
                   @VB1_GRUPO        = B1_GRUPO,
                   @VB1_LOCPAD       = B1_LOCPAD
              FROM INTEGRACAO_PROTHEUS_SB1 SB1,
                   INTEGRACAO_PROTHEUS_SF4 SF4
             WHERE B1_COD            = LEFT(@VDB_PEDI_PRODUTO + '               ' , 15)
               AND F4_FILIAL         = '  '
               AND SF4.D_E_L_E_T_ = ' '
               AND F4_CODIGO         = @VDB_PEDI_OPERACAO
               AND SB1.D_E_L_E_T_ = ' ';
            SET @VCOD_ERRO = @@ERROR;
            IF @VCOD_ERRO > 0
            BEGIN
               SET @VDB_PROD_DESC = NULL;
               SET @VDB_PROD_UM   = LEFT(@VDB_PROD_UM + '  ' , 2);
            END

            SET @VINSERE = 0;
            SET @VSEQ    = @VSEQ + 1;

            SELECT @VINSERE = 1
              FROM ZC6010
             WHERE --ZC6_FILIAL = @VFILIAL AND 
                   ZC6_PEDMER = @VDB_PED_NRO
               AND ZC6_PRODUT = LEFT(@VDB_PEDI_PRODUTO + '               ' , 15)
               AND D_E_L_E_T_ = ' ';
            SET @VCOD_ERRO = @@ERROR;
            IF @VCOD_ERRO > 0
            BEGIN
               SET @VINSERE = 0;
            END

            IF @VINSERE = 0
            BEGIN

               --PRINT('INSERT 2');

               INSERT INTO ZC6010
                 (
                  ZC6_FILIAL,     -- 01 2
                  ZC6_PRODUT,     -- 02 15
                  ZC6_QTDVEN,     -- 03 FLOAT
                  ZC6_VLR_BRUTO,  -- 04 FLOAT
                  ZC6_VLR_LIQ,    -- 05 FLOAT  
                  ZC6_VALOR,      -- 06 FLOAT
                  ZC6_TES,        -- 07 3
                  ZC6_LOCAL,      -- 08 2
                  ZC6_CLI,        -- 09 6
                  ZC6_ENTREG,     -- 10 8
                  ZC6_LOJA,       -- 11
                  D_E_L_E_T_,     -- 12 1
                  R_E_C_N_O_,     -- 13 INT
                  ZC6_PEDMER,     -- 14
                  ZC6_ITPMER,     -- 15
                  ZC6_PEDPAI,     -- 16
                  ZC6_COMIS1,     -- 17
                  ZC6_BONIFIC     -- 18
                 )
               VALUES
                 (
                  @VFILIAL, --@VDB_PED_EMPRESA,                          -- 01
                  LEFT(@VDB_PEDI_PRODUTO + '               ' , 15),      -- 02
                  ROUND(ISNULL(@VDB_PEDI_QTDE_SOLIC,0), 2),              -- 03
                  ROUND(ISNULL(@VDB_PEDI_PRECO_UNIT,0), 2),              -- 04
                  ROUND(ISNULL(@VDB_PEDI_PRECO_LIQ,0), 2),               -- 05
                  ISNULL(ROUND(@VDB_PEDI_QTDE_SOLIC, 2) * ROUND(@VDB_PEDI_PRECO_LIQ, 2) ,0),  -- 06
                  LEFT(ISNULL(@VDB_PEDI_OPERACAO, @VDB_PED_OPERACAO) + '   ' , 3),  -- 07
                  ISNULL(@VB1_LOCPAD, '01'),                             -- 08
                  SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6), CAST(@VDB_PED_CLIENTE AS INT)), 6),1,6),  -- 09
                  SUBSTRING(CONVERT(CHAR,@VDB_PEDI_PREV_ENTR,112),1,8),  -- 10
                  '01',                                                  -- 11
                  ' ',                                                   -- 12
                  ISNULL(@VR_E_C_N_O_, 0) + 1,                           -- 13
                  @VDB_PED_NRO,                                          -- 14
                  RIGHT('00' + CAST(@VDB_PEDI_SEQUENCIA AS VARCHAR), 2), -- 15
                  CASE ISNULL(@PPEDIDO_PAI, 0) WHEN 0 THEN @VDB_PED_NRO ELSE CAST(@VPEDIDO_PAI AS VARCHAR) END,  -- 16
                  ROUND(ISNULL(@VDB_PEDI_PERC_COMIS,0), 2),              -- 17
                  CASE @VDB_PEDI_TIPO WHEN 'B' THEN SUBSTRING(@VDB_PEDC_OPC_FATUR, 1, 3) ELSE '   ' END  -- 18
                 );
               SET @VCOD_ERRO = @@ERROR;
               IF @VCOD_ERRO > 0
               BEGIN
                  SET @VERRO = '4 - ERRO INSERT ZC6010: C6_FILIAL' + @VFILIAL + ' C6_NUM: ' + @VDB_PED_NRO_ORIG + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
               END

               --PRINT('PASSOU INSERT 2');

            END
            ELSE
            BEGIN

               UPDATE ZC6010
                  SET ZC6_FILIAL    = @VFILIAL,
                      ZC6_QTDVEN    = ISNULL(@VDB_PEDI_QTDE_SOLIC, 0),
                      ZC6_VLR_BRUTO = ISNULL(@VDB_PEDI_PRECO_UNIT, 0),
                      ZC6_VLR_LIQ   = ISNULL(@VDB_PEDI_PRECO_LIQ, 0),
                      ZC6_VALOR     = ISNULL(ROUND(@VDB_PEDI_QTDE_SOLIC, 2) * ROUND(@VDB_PEDI_PRECO_LIQ, 2) ,0),
                      ZC6_TES       = LEFT(ISNULL(@VDB_PEDI_OPERACAO, @VDB_PED_OPERACAO) + '   ' , 3),
                      ZC6_LOCAL     = '01',   -- SUBSTRING(@VDB_PEDI_ALMOXARIF,1,2),  FIXO PARA FINI
                      ZC6_CLI       = SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(8), CAST(@VDB_PED_CLIENTE AS INT)), 8),1,6),  -- NAO ALTERAR ESSA MASCARA
                      ZC6_ENTREG    = CONVERT(CHAR,@VDB_PEDI_PREV_ENTR,112),
                      ZC6_LOJA      = '01', --SUBSTRING(RIGHT('00' + CONVERT(VARCHAR(8), CAST(@VDB_PED_CLIENTE AS INT)), 8),7,2),  -- NAO ALTERAR ESSA MASCARA
                      D_E_L_E_T_    = ' ',
                      ZC6_PEDPAI    = CASE ISNULL(@PPEDIDO_PAI, 0) WHEN 0 THEN @VDB_PED_NRO ELSE CAST(@VPEDIDO_PAI AS VARCHAR) END,
                      ZC6_COMIS1    = ROUND(ISNULL(@VDB_PEDI_PERC_COMIS,0), 2),
                      ZC6_BONIFIC   = CASE @VDB_PEDI_TIPO WHEN 'B' THEN SUBSTRING(@VDB_PEDC_OPC_FATUR, 1, 3) ELSE '   ' END
                WHERE --ZC6_FILIAL = @VFILIAL AND
                      ZC6_PEDMER = @VDB_PED_NRO
                  AND ZC6_PRODUT = LEFT(@VDB_PEDI_PRODUTO + '               ' , 15)
                  AND D_E_L_E_T_ = ' ';
               SET @VCOD_ERRO = @@ERROR;
               IF @VCOD_ERRO > 0
               BEGIN
                  SET @VERRO = '5 - ERRO UPDATE ZC6010: C6_FILIAL' + @VFILIAL + ' C6_NUM: ' + @VDB_PED_NRO_ORIG + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
               END

            END

           FETCH NEXT FROM CPED_PROD
            INTO @VDB_PEDI_PRODUTO,   @VDB_PEDI_SEQUENCIA, @VDB_PEDI_TIPO,       @VDB_PEDI_QTDE_SOLIC,
                 @VDB_PEDI_PRECO_LIQ, @VDB_PEDI_DESCTOP,   @VDB_PEDI_PRECO_UNIT, @VDB_PEDI_ALMOXARIF,
                 @VDB_PEDI_PREV_ENTR, @VDB_PEDI_OPERACAO,  @VDB_PEDI_PERC_COMIS
          END;
           CLOSE CPED_PROD
      DEALLOCATE CPED_PROD


     FETCH NEXT FROM CPED_INS
      INTO @VDB_PED_EMPRESA,     @VDB_PED_CLIENTE,    @VDB_PED_PRZPGTO,     @VDB_PED_NRO,        @VDB_PED_TIPO,
           @VDB_PED_SITUACAO,    @VDB_PED_COND_PGTO,  @VDB_PED_DESCTO,      @VDB_PED_DESCTO2,    @VDB_PED_DESCTO3,
           @VDB_PED_DESCTO4,     @VDB_PED_DESCTO5,    @VDB_PED_DESCTO7,     @VDB_PED_PORTADOR,   @VDB_PED_DT_EMISSAO,
           @VDB_PED_TEXTO,       @VDB_PED_OPERACAO,   @VDB_CLI_ESTADO,      @VDB_PED_COD_TRANSP, @VDB_PED_COMISO,
           @VDB_PEDC_FORMA_PGTO, @VDB_CLI_RAMATIV,    @VDB_PED_LISTA_PRECO, @VDB_PED_ORD_COMPRA, @VDB_TBREP_CODORIG,
           @VLIBERASEMSALDO,     @VDB_PEDC_OPC_FATUR, @VDB_PED_OBSERV,      @VDB_PEDC_OBSTRANSP, @VDB_PED_TIPO_FRETE
    END;
     CLOSE CPED_INS
DEALLOCATE CPED_INS

END  -- IF @VQUEBRA = 2

IF ISNULL(@VERRO, '') <> ''
BEGIN

   --PRINT('@VERRO: ' + @VERRO);

   SET @PRETORNO = CAST(@VERRO AS VARCHAR)

   -- EM CASO DE ERRO APAGA O NRO ORIGINAL E A DATA DE ENVIO
   UPDATE DB_PEDIDO
      SET DB_PED_DATA_ENVIO = NULL,
          DB_PED_NRO_ORIG   = NULL
    WHERE DB_PED_NRO = @PDB_PED_NRO_NUM;

   SET @VDATA = GETDATE();
   INSERT INTO DBS_ERROS_TRIGGERS
     (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
   VALUES
     (@VERRO, @VDATA, @VOBJETO);

END
ELSE
BEGIN

   SET @PRETORNO = 'OK'

END

END TRY

BEGIN CATCH
  SELECT @VERRO = CAST(ERROR_NUMBER() AS VARCHAR) + ERROR_MESSAGE()

  -- EM CASO DE ERRO APAGA O NRO ORIGINAL E A DATA DE ENVIO
  UPDATE DB_PEDIDO
     SET DB_PED_DATA_ENVIO = NULL,
         DB_PED_NRO_ORIG   = NULL
   WHERE DB_PED_NRO = @PDB_PED_NRO_NUM;

  INSERT INTO DBS_ERROS_TRIGGERS
    (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
  VALUES
    (@VERRO, GETDATE(), @VOBJETO );
END CATCH

END
GO
