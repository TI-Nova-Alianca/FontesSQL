SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SF1010] (@VEVENTO       FLOAT,
                                     @VF1_FILIAL    VARCHAR(2),
                                     @VF1_DOC       VARCHAR(9),
                                     @VF1_SERIE     VARCHAR(3),
                                     @VF1_FORNECE   VARCHAR(6),
                                     @VF1_LOJA      VARCHAR(2),
                                     @VF1_COND      VARCHAR(3),
                                     @VF1_DUPL      VARCHAR(9),
                                     @VF1_EMISSAO   VARCHAR(8),
                                     @VF1_EST       VARCHAR(2),
                                     @VF1_FRETE     FLOAT,
                                     @VF1_DESPESA   FLOAT,
                                     @VF1_BASEICM   FLOAT,
                                     @VF1_VALICM    FLOAT,
                                     @VF1_BASEIPI   FLOAT,
                                     @VF1_VALIPI    FLOAT,
                                     @VF1_VALMERC   FLOAT,
                                     @VF1_VALBRUT   FLOAT,
                                     @VF1_TIPO      VARCHAR(1),
                                     @VF1_DESCONT   FLOAT,
                                     @VF1_DTDIGIT   VARCHAR(8),
                                     @VF1_CPROVA    VARCHAR(14),
                                     @VF1_BRICMS    FLOAT,
                                     @VF1_ICMSRET   FLOAT,
                                     @VF1_BASEFD    FLOAT,
                                     @VF1_DTLANC    VARCHAR(8),
                                     @VF1_OK        VARCHAR(2),
                                     @VF1_ORIGLAN   VARCHAR(2),
                                     @VF1_TX        VARCHAR(1),
                                     @VF1_CONTSOC   FLOAT,
                                     @VF1_IRRF      FLOAT,
                                     @VF1_FORMUL    VARCHAR(1),
                                     @VF1_NFORIG    VARCHAR(9),
                                     @VF1_SERORIG   VARCHAR(3),
                                     @VF1_ESPECIE   VARCHAR(5),
                                     @VF1_IMPORT    VARCHAR(1),
                                     @VF1_II        FLOAT,
                                     @VF1_REMITO    VARCHAR(6),
                                     @VF1_BASIMP2   FLOAT,
                                     @VF1_BASIMP3   FLOAT,
                                     @VF1_BASIMP4   FLOAT,
                                     @VF1_BASIMP5   FLOAT,
                                     @VF1_BASIMP6   FLOAT,
                                     @VF1_VALIMP1   FLOAT,
                                     @VF1_VALIMP2   FLOAT,
                                     @VF1_VALIMP3   FLOAT,
                                     @VF1_VALIMP4   FLOAT,
                                     @VF1_VALIMP5   FLOAT,
                                     @VF1_VALIMP6   FLOAT,
                                     @VF1_ORDPAGO   VARCHAR(6),
                                     @VF1_HORA      VARCHAR(5),
                                     @VF1_INSS      FLOAT,
                                     @VF1_ISS       FLOAT,
                                     @VF1_BASIMP1   FLOAT,
                                     @VF1_HAWB      VARCHAR(17),
                                     @VF1_TIPO_NF   VARCHAR(1),
                                     @VF1_IPI       FLOAT,
                                     @VF1_ICMS      FLOAT,
                                     @VF1_PESOL     FLOAT,
                                     @VF1_FOB_R     FLOAT,
                                     @VF1_SEGURO    FLOAT,
                                     @VF1_CIF       FLOAT,
                                     @VF1_MOEDA     FLOAT,
                                     @VF1_PREFIXO   VARCHAR(3),
                                     @VF1_STATUS    VARCHAR(1),
                                     @VF1_VALEMB    FLOAT,
                                     @VF1_RECBMTO   VARCHAR(8),
                                     @VF1_APROV     VARCHAR(6),
                                     @VF1_CTR_NFC   VARCHAR(9),
                                     @VF1_TXMOEDA   FLOAT,
                                     @VF1_PEDVEND   VARCHAR(6),
                                     @VF1_TIPODOC   VARCHAR(2),
                                     @VF1_TIPOREM   VARCHAR(1),
                                     @VF1_GNR       VARCHAR(6),
                                     @VF1_VALPIS    FLOAT,
                                     @VF1_VALCOFI   FLOAT,
                                     @VF1_VALCSLL   FLOAT,
                                     @VF1_BASEPS3   FLOAT,
                                     @VF1_VALPS3    FLOAT,
                                     @VF1_BASECF3   FLOAT,
                                     @VF1_VALCF3    FLOAT,
                                     @VF1_NFELETR   VARCHAR(9),
                                     @VF1_EMINFE    VARCHAR(8),
                                     @VF1_HORNFE    VARCHAR(8),
                                     @VF1_CODNFE    VARCHAR(24),
                                     @VF1_CREDNFE   FLOAT,
                                     @VF1_VNAGREG   FLOAT,
                                     @VF1_NUMRPS    VARCHAR(12),
                                     @VF1_VALIRF    FLOAT,
                                     @VF1_NUMMOV    VARCHAR(2),
                                     @VF1_RECISS    VARCHAR(1),
                                     @VF1_FILORIG   VARCHAR(2),
                                     @VF1_NUMRA     VARCHAR(6),
                                     @VF1_BASEINS   FLOAT,
                                     @VF1_DOCFOL    VARCHAR(6),
                                     @VF1_VERBAFO   VARCHAR(3),
                                     @VF1_VALFDS    FLOAT,
                                     @VF1_CHVNFE    VARCHAR(44),
                                     @VF1_ESTCRED   FLOAT,
                                     @VF1_FIMP      VARCHAR(10),
                                     @VF1_TPFRETE   VARCHAR(1),
                                     @VF1_TPNFEXP   VARCHAR(1),
                                     @VF1_NODIA     VARCHAR(10),
                                     @VF1_DIACTB    VARCHAR(2),
                                     @VF1_TRANSP    VARCHAR(6),
                                     @VF1_PLIQUI    FLOAT,
                                     @VF1_PBRUTO    FLOAT,
                                     @VF1_ESPECI1   VARCHAR(10),
                                     @VF1_VOLUME1   FLOAT,
                                     @VF1_ESPECI2   VARCHAR(10),
                                     @VF1_VOLUME2   FLOAT,
                                     @VF1_ESPECI3   VARCHAR(10),
                                     @VF1_VOLUME3   FLOAT,
                                     @VF1_ESPECI4   VARCHAR(10),
                                     @VF1_VOLUME4   FLOAT,
                                     @VF1_VALFAB    FLOAT,
                                     @VF1_VALFAC    FLOAT,
                                     @VF1_VALFET    FLOAT,
                                     @VF1_PLACA     VARCHAR(8),
                                     @VD_E_L_E_T_   VARCHAR(1),
                                     @VR_E_C_N_O_   INT,
                                     @VR_E_C_D_E_L_ INT
                                    ) AS

BEGIN

---------------------------------------------------------------------------------------------------------------------------------
--   DATA        AUTOR            ALTERACAO
---  05/02/2016  ALENCAR          PASSA A INTEGRAR A EMPRESA USANDO A REGRA: EMPRESA + FILIAL, AONDE TABELAS DA SANCHEZ
---                               CONSIDERA EMPRESA 1 E FINI EMPRESA 2
---  15/03/2016  ALENCAR          NAO INTEGRA NOTAS: @VF1_FORNECE LIKE ('%A%') OR
---                                                  @VF1_FORNECE LIKE ('%F%') OR
---                                                  @VF1_FILIAL NOT IN ('01')
---                               IMPLEMENTADO WITH (NOLOCK)
---  17/05/2016  ALENCAR          NAO INTEGRA NOTAS DA SERIE ECF, QUE SAO NOTAS EMITIDAS PELA LOJA FINI DO SHOPPING
---                               NAO INTEGRA NOTAS DE CLIENTES QUE ESTIVEREM INATIVOS NO PROTHEUS
---  19/05/2016  ALENCAR          AO VERIFICAR O CLIENTE, BUSCA SEMPRE COM R_E_C_D_E_L_ = ' '
---                               NOVAMENTE A REGRA MUDOU, NOTAS DE CLIENTES BLOQUEADOS DEVEM SER CARREGADAS
---                               NAO CARREGA NOTAS DE CLIENTES COMERCIO EXTERIOR
---  11/09/2016  ALENCAR          USANDO A NOVA REGRA PARA DEFINIR O NRO E SERIE DAS NOTAS FISCAIS
---  21/09/2016  ALENCAR          CORRECAO NO SELECT QUE VERIFICA SE O CLIENTE EH COMERCIO EXTERIOR. ADICIONADO AND A1_LOJA  = @VF2_LOJA
---  26/10/2016  ALENCAR          CONVERSAO NOVA ALIANCA
---  21/11/2016  ALENCAR          REGRA PARA DEFINIR A CONDICAO DE PAGAMENTO:
---                               SE POSSUIR LETRAS OU FOR MENOR QUE 3 CARACTERES ASSUME A CONDICAO 666
---                               SE FOR CONDICAO 000 ASSUME A 900
---  03/09/2018  ALENCAR          TRATAR A VARIAVEL @VSERIE COM TAMANHO 3 (83573)
---  10/09/2018  SERGIO LUCCHINI  ALTERACAO NA BUSCA DO REPRESENTANTE, DB_CLIR_REPRES <> 0. CHAMADO 84157
---  28/09/2018  ALENCAR          AO BUSCAR O REPRESENTANTE NA CLIENTExREPRES BUSCA SEMPRE O REPRES ATIVO (84511)
---  26/02/2019  ROBERT (aLIANCA) BUSCA REPRESENTANTE NO FINANCEIRO (PROTHEUS) QUANDO NOTA DE DEVOLUCAO.

---------------------------------------------------------------------------------------------------------------------------------

DECLARE @VOBJETO      VARCHAR(15) SELECT @VOBJETO = 'MERCP_SF1010';
DECLARE @VDATA        DATETIME;
DECLARE @VERRO        VARCHAR(1000);
DECLARE @VSERIE       VARCHAR(3);
DECLARE @VREPRES      NUMERIC;
DECLARE @VEMPRESA     VARCHAR(3);
DECLARE @VF1_COND_AUX VARCHAR(3);
DECLARE @VINSERE      NUMERIC SELECT @VINSERE = 0;

BEGIN TRY

IF @VF1_FORNECE LIKE ('%A%') OR
   @VF1_FORNECE LIKE ('%F%') OR
   @VF1_FILIAL  NOT IN ('01') OR
   @VF1_SERIE       IN ('ECF')
BEGIN
   RETURN;
END

SET @VEMPRESA = SUBSTRING(RTRIM(LTRIM(@VF1_FILIAL)), 1, 2);

IF @VF1_TIPO = 'D' AND @VF1_DTDIGIT <> '        '
BEGIN

   -- ENCONTRA A SERIE
   -- PARA BUSCAR A SERIE DA NOTA USAR A EMPRESA, NRO, FATUR, CLIENTE E SERIE
   SELECT TOP 1 @VSERIE = DB_NOTA_SERIE
     FROM DB_NOTA_FISCAL
    WHERE DB_NOTA_EMPRESA = @VEMPRESA
      AND DB_NOTA_NRO     = CAST(RTRIM(@VF1_DOC) AS INT)
      --AND DB_NOTA_FATUR   = 3  -- ELIAS chamado 86225
      AND DB_NOTA_CLIENTE = CAST(REPLACE(LTRIM(RTRIM(@VF1_FORNECE)),' ','') AS INT)
      AND DB_NOTA_SERIE   LIKE 'D%';

   -- CASO NAO ENCONTRE REGISTRO BUSCAR A MAIOR SERIE EXISTENTE PARA A EMPRESA, NRO, FATUR E SERIE
   IF @VSERIE IS NULL
   BEGIN

      SELECT @VSERIE = MAX(DB_NOTA_SERIE)
        FROM DB_NOTA_FISCAL
       WHERE DB_NOTA_EMPRESA = @VEMPRESA
         AND DB_NOTA_NRO     = CAST(RTRIM(@VF1_DOC) AS INT)
         --AND DB_NOTA_FATUR   = 3 -- ELIAS chamado 86225
         AND DB_NOTA_SERIE   LIKE 'D%';

      -- SE NAO ENCONTRAR, SETAR FIXO SERIE D01
      IF @VSERIE IS NULL
      BEGIN
         SET @VSERIE = 'D01';
      END
      ELSE  -- SENAO, INCREMENTAR A SERIE
      BEGIN
         SET @VSERIE = 'D0' + CAST(CAST(SUBSTRING(@VSERIE, 3, 1) AS FLOAT) + 1 AS VARCHAR);
      END
   END
   -- FIM ENCONTRA A SERIE

   -- DEFINE A CONDICAO DE PAGAMENTO:
   -- SE POSSUIR LETRAS OU FOR MENOR QUE 3 CARACTERES ASSUME A CONDICAO 666
   -- SE FOR CONDICAO 000 ASSUME A 900
   IF ISNUMERIC(@VF1_COND) = 0 OR
      LEN(RTRIM(LTRIM(@VF1_COND))) <> 3
      SET @VF1_COND_AUX = '666';
   ELSE IF @VF1_COND = '000'
      SET @VF1_COND_AUX = '900';
   ELSE 
      SET @VF1_COND_AUX = @VF1_COND;

   --PRINT('VDB_NOTA_CARGA: '+ CAST(@VDB_NOTA_CARGA AS VARCHAR))

   -- Inicio alteracao Robert 26/02/2019
   /*-- Busca representante atual do cliente
   SELECT TOP 1 @VREPRES = DB_CLIR_REPRES
     FROM DB_CLIENTE_REPRES WITH (NOLOCK)
    WHERE DB_CLIR_CLIENTE  = CAST(REPLACE(RTRIM(LTRIM(@VF1_FORNECE)),' ','') AS FLOAT)
      AND DB_CLIR_EMPRESA  = @VEMPRESA
      AND DB_CLIR_REPRES  <> 0
	  AND DB_CLIR_SITUACAO = 0; -- Buscar sempre situacao ativa
	*/
  
   -- Busca representante no titulo gerado pela devolucao (para ficar consistente com o exporta dados do Protheus)
   SELECT TOP 1 @VREPRES = E1_VEND1
     FROM LKSRV_PROTHEUS.protheus.dbo.SE1010
    WHERE D_E_L_E_T_ = ''
	  AND E1_FILIAL  = @VF1_FILIAL
	  AND E1_NUM     = @VF1_DOC
	  AND E1_PREFIXO = @VF1_SERIE
	  AND E1_CLIENTE = @VF1_FORNECE
	  AND E1_LOJA    = @VF1_LOJA

   -- BUSCA CODIGO DO PROTHEUS NO MERCANET
   SELECT TOP 1 @VREPRES = DB_TBREP_CODIGO
	 FROM DB_TB_REPRES
   WHERE DB_TBREP_CODORIG = @VREPRES

	  -- Fim alteracao Robert 26/02/2019


   IF @VEVENTO = 2 OR (@VD_E_L_E_T_ <> ' ')
   BEGIN

      DELETE FROM DB_NOTA_FISCAL
       WHERE DB_NOTA_EMPRESA = @VEMPRESA
         AND DB_NOTA_NRO     = CAST(RTRIM(@VF1_DOC) AS INT)
         AND DB_NOTA_SERIE   = @VSERIE;

      DELETE FROM DB_NOTA_PROD
       WHERE DB_NOTAP_EMPRESA = @VEMPRESA
         AND DB_NOTAP_NRO     = CAST(RTRIM(@VF1_DOC) AS INT)
         AND DB_NOTAP_SERIE   = @VSERIE;

      DELETE FROM DB_NOTA_FRETE
       WHERE DB_NOTAF_EMP   = @VEMPRESA
         AND DB_NOTAF_NRO   = CAST(RTRIM(@VF1_DOC) AS INT)
         AND DB_NOTAF_SERIE = @VSERIE;

   END
   ELSE
   BEGIN

      --PRINT 'NRO NOTA ' + @VF1_DOC
      --PRINT 'SERIE ' + @VSERIE

      SET @VINSERE = 0;
      SELECT TOP 1 @VINSERE = 1
        FROM DB_NOTA_FISCAL
       WHERE DB_NOTA_NRO     = CAST(RTRIM(@VF1_DOC) AS INT)
         AND DB_NOTA_SERIE   = @VSERIE
         AND DB_NOTA_EMPRESA = @VEMPRESA;

      IF @VINSERE = 0
      BEGIN

         INSERT INTO DB_NOTA_FISCAL
           (
            DB_NOTA_EMPRESA,
            DB_NOTA_NRO,
            DB_NOTA_SERIE,
            DB_NOTA_CLIENTE,
            DB_NOTA_REPRES,
            DB_NOTA_DT_EMISSAO,
            DB_NOTA_PEDIDO,
            DB_NOTA_PED_ORIG,
            DB_NOTA_VLR_TOTAL,
            DB_NOTA_VLR_PROD,
            DB_NOTA_COMISSAO,
            DB_NOTA_OPERACAO,
            DB_NOTA_FATUR,
            DB_NOTA_PED_MERC,
            DB_NOTA_COND_PGTO,
            DB_NOTA_TRANSP,
            DB_NOTA_CODREDESP,
            DB_NOTA_REDESP,
            DB_NOTA_FRETE,
            DB_NOTA_CDV,
            DB_NOTA_DT_CHAMADA,
            DB_NOTA_HR_CHAMADA,
            DB_NOTA_DT_EMB,
            DB_NOTA_HR_EMB,
            DB_NOTA_MOTDEVOL,
            DB_NOTA_OBSERV,
            DB_NOTA_PESO_LIQ,
            DB_NOTA_PESO_BRU,
            DB_NOTA_VOLUMES,
            DB_NOTA_CUBAGEM,
            DB_NOTA_DATA_EDI,
            DB_NOTA_CANCEL,
            DB_NOTA_ROMANEIO,
            DB_NOTA_CFOP,
            DB_NOTA_MOTCANCEL,
            DB_NOTA_CARGA
           )
         VALUES
           (
            @VEMPRESA,                     --DB_NOTA_EMPRESA,
            CAST(RTRIM(@VF1_DOC) AS INT),  --DB_NOTA_NRO,
            @VSERIE,                       --DB_NOTA_SERIE,
            CAST(REPLACE(LTRIM(RTRIM(@VF1_FORNECE)),' ','') AS INT),  --DB_NOTA_CLIENTE,
            @VREPRES,                      --DB_NOTA_REPRES,
            RTRIM(@VF1_DTDIGIT),           --DB_NOTA_DT_EMISSAO,
            NULL,                          --DB_NOTA_PEDIDO,
            NULL,                          --DB_NOTA_PED_ORIG,
            @VF1_VALBRUT * -1,             --DB_NOTA_VLR_TOTAL,
            @VF1_VALMERC * -1,             --DB_NOTA_VLR_PROD,
            0,                             --DB_NOTA_COMISSAO,
            NULL,                          --DB_NOTA_OPERACAO,
            3,                             --DB_NOTA_FATUR,
            NULL,                          --DB_NOTA_PED_MERC,
            @VF1_COND_AUX,                 --DB_NOTA_COND_PGTO,
            NULL,                          --DB_NOTA_TRANSP,
            NULL,                          --DB_NOTA_CODREDESP,
            NULL,                          --DB_NOTA_REDESP,
            1,                             --DB_NOTA_FRETE,
            NULL,                          --DB_NOTA_CDV,
            NULL,                          --DB_NOTA_DT_CHAMADA,
            NULL,                          --DB_NOTA_HR_CHAMADA,
            NULL,                          --DB_NOTA_DT_EMB,
            NULL,                          --DB_NOTA_HR_EMB,
            NULL,                          --DB_NOTA_MOTDEVOL,
            NULL,                          --DB_NOTA_OBSERV,
            0,                             --DB_NOTA_PESO_LIQ,
            0,                             --PPDB_NOTA_PESO_BRU,
            0,                             --DB_NOTA_VOLUMES,
            0,                             --DB_NOTA_CUBAGEM,
            NULL,                          --DB_NOTA_DATA_EDI,
            0,                             --DB_NOTA_CANCEL,
            NULL,                          --DB_NOTA_ROMANEIO,
            NULL,                          --DB_NOTA_CFOP,
            NULL,                          --DB_NOTA_MOTCANCEL,
            ''                             --DB_NOTA_CARGA,
           );

      END
      ELSE
      BEGIN

         UPDATE DB_NOTA_FISCAL
            SET DB_NOTA_CLIENTE    = CAST(REPLACE(LTRIM(RTRIM(@VF1_FORNECE)),' ','') AS INT),
                DB_NOTA_REPRES     = @VREPRES,
                DB_NOTA_DT_EMISSAO = RTRIM(@VF1_DTDIGIT),
                DB_NOTA_VLR_TOTAL  = @VF1_VALBRUT * -1,
                DB_NOTA_VLR_PROD   = @VF1_VALMERC * -1,
                DB_NOTA_COND_PGTO  = @VF1_COND_AUX
          WHERE DB_NOTA_NRO     = CAST(RTRIM(@VF1_DOC) AS INT)
            AND DB_NOTA_SERIE   = @VSERIE
            AND DB_NOTA_EMPRESA = @VEMPRESA;

      END

   END

   IF @VERRO IS NOT NULL
   BEGIN
      SET @VDATA = GETDATE();
      INSERT INTO DBS_ERROS_TRIGGERS
        (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
      VALUES
        (@VERRO, @VDATA, @VOBJETO);
   END

END

END TRY

BEGIN CATCH
  SELECT @VERRO = CAST(ERROR_NUMBER() AS VARCHAR) + ERROR_MESSAGE()

  INSERT INTO DBS_ERROS_TRIGGERS
    (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
  VALUES
    (@VERRO, GETDATE(), @VOBJETO);
END CATCH

END
GO
