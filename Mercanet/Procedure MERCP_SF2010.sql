SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SF2010] (@VEVENTO       NUMERIC,
                                        @VF2_FILIAL     VARCHAR(20), 
                                        @VF2_DOC        VARCHAR(9), 
                                        @VF2_SERIE      VARCHAR(3), 
                                        @VF2_CLIENTE    VARCHAR(6), 
                                        @VF2_LOJA       VARCHAR(2), 
                                        @VF2_COND       VARCHAR(3), 
                                        @VF2_DUPL       VARCHAR(9), 
                                        @VF2_EMISSAO    VARCHAR(8), 
                                        @VF2_EST        VARCHAR(2), 
                                        @VF2_FRETE      FLOAT, 
                                        @VF2_SEGURO     FLOAT, 
                                        @VF2_ICMFRET    FLOAT, 
                                        @VF2_TIPOCLI    VARCHAR(1), 
                                        @VF2_VALBRUT    FLOAT, 
                                        @VF2_VALINSS    FLOAT, 
                                        @VF2_VALICM     FLOAT, 
                                        @VF2_BASEICM    FLOAT, 
                                        @VF2_VALIPI     FLOAT, 
                                        @VF2_BASEIPI    FLOAT, 
                                        @VF2_VALMERC    FLOAT, 
                                        @VF2_NFORI      VARCHAR(9), 
                                        @VF2_DESCONT    FLOAT, 
                                        @VF2_SERIORI    VARCHAR(3), 
                                        @VF2_TIPO       VARCHAR(1), 
                                        @VF2_ESPECI1    VARCHAR(10), 
                                        @VF2_ESPECI2    VARCHAR(10), 
                                        @VF2_ESPECI3    VARCHAR(10), 
                                        @VF2_ESPECI4    VARCHAR(10), 
                                        @VF2_VOLUME1    FLOAT, 
                                        @VF2_VOLUME2    FLOAT, 
                                        @VF2_VOLUME3    FLOAT, 
                                        @VF2_VOLUME4    FLOAT, 
                                        @VF2_ICMSRET    FLOAT, 
                                        @VF2_PLIQUI     FLOAT, 
                                        @VF2_PBRUTO     FLOAT, 
                                        @VF2_TRANSP     VARCHAR(6), 
                                        @VF2_REDESP     VARCHAR(6), 
                                        @VF2_VEND1      VARCHAR(6), 
                                        @VF2_VEND2      VARCHAR(6), 
                                        @VF2_VEND3      VARCHAR(6), 
                                        @VF2_VEND4      VARCHAR(6), 
                                        @VF2_VEND5      VARCHAR(6), 
                                        @VF2_OK         VARCHAR(4), 
                                        @VF2_FIMP       VARCHAR(1), 
                                        @VF2_DTLANC     VARCHAR(8), 
                                        @VF2_DTREAJ     VARCHAR(8), 
                                        @VF2_REAJUST    VARCHAR(3), 
                                        @VF2_DTBASE0    VARCHAR(8), 
                                        @VF2_FATORB0    FLOAT, 
                                        @VF2_DTBASE1    VARCHAR(8), 
                                        @VF2_FATORB1    FLOAT, 
                                        @VF2_VARIAC     FLOAT, 
                                        @VF2_BASEISS    FLOAT, 
                                        @VF2_VALISS     FLOAT, 
                                        @VF2_VALFAT     FLOAT, 
                                        @VF2_CONTSOC    FLOAT, 
                                        @VF2_BRICMS     FLOAT, 
                                        @VF2_FRETAUT    FLOAT, 
                                        @VF2_ICMAUTO    FLOAT, 
                                        @VF2_DESPESA    FLOAT, 
                                        @VF2_NEXTDOC    VARCHAR(9), 
                                        @VF2_ESPECIE    VARCHAR(5), 
                                        @VF2_PDV        VARCHAR(10), 
                                        @VF2_MAPA       VARCHAR(10), 
                                        @VF2_ECF        VARCHAR(1), 
                                        @VF2_BASIMP1    FLOAT, 
                                        @VF2_PREFIXO    VARCHAR(3), 
                                        @VF2_BASIMP2    FLOAT, 
                                        @VF2_BASIMP3    FLOAT, 
                                        @VF2_BASIMP4    FLOAT, 
                                        @VF2_BASIMP5    FLOAT, 
                                        @VF2_BASIMP6    FLOAT, 
                                        @VF2_VALIMP1    FLOAT, 
                                        @VF2_VALIMP2    FLOAT, 
                                        @VF2_VALIMP3    FLOAT, 
                                        @VF2_VALIMP4    FLOAT, 
                                        @VF2_VALIMP5    FLOAT, 
                                        @VF2_VALIMP6    FLOAT, 
                                        @VF2_ORDPAGO    VARCHAR(6), 
                                        @VF2_NFCUPOM    VARCHAR(9), 
                                        @VF2_HORA       VARCHAR(5), 
                                        @VF2_BASEINS    FLOAT, 
                                        @VF2_LOTE       VARCHAR(20), 
                                        @VF2_MOEDA      FLOAT, 
                                        @VF2_REGIAO     VARCHAR(20), 
                                        @VF2_TXMOEDA    FLOAT, 
                                        @VF2_VALCOFI    FLOAT, 
                                        @VF2_VALCSLL    FLOAT, 
                                        @VF2_VALPIS     FLOAT, 
                                        @VF2_VALIRRF    FLOAT, 
                                        @VF2_CARGA      VARCHAR(20), 
                                        @VF2_SEQCAR     VARCHAR(20), 
                                        @VF2_NEXTSER    VARCHAR(20), 
                                        @VF2_PEDPEND    VARCHAR(20), 
                                        @VF2_DESCCAB    FLOAT, 
                                        @VF2_DTENTR     VARCHAR(20), 
                                        @VF2_FORMUL     VARCHAR(20), 
                                        @VF2_TIPODOC    VARCHAR(20), 
                                        @VF2_NFEACRS    VARCHAR(20), 
                                        @VF2_TIPOREM    VARCHAR(20), 
                                        @VF2_SEQENT     VARCHAR(20), 
                                        @VF2_VEICUL1    VARCHAR(20), 
                                        @VF2_VEICUL2    VARCHAR(20), 
                                        @VF2_VEICUL3    VARCHAR(20), 
                                        @VF2_ICMSDIF    FLOAT, 
                                        @VF2_BASEPS3    FLOAT, 
                                        @VF2_VALPS3     FLOAT, 
                                        @VF2_BASECF3    FLOAT, 
                                        @VF2_VALCF3     FLOAT, 
                                        @VF2_NFELETR    VARCHAR(20), 
                                        @VF2_EMINFE     VARCHAR(20), 
                                        @VF2_HORNFE     VARCHAR(20), 
                                        @VF2_CODNFE     VARCHAR(24), 
                                        @VF2_CREDNFE    FLOAT, 
                                        @VD_E_L_E_T_    VARCHAR(20), 
                                        @VR_E_C_N_O_    FLOAT, 
                                        @VR_E_C_D_E_L_  FLOAT, 
                                        @VF2_VALACRS    FLOAT, 
                                        @VF2_RECISS     VARCHAR(20), 
                                        @VF2_TIPORET    VARCHAR(20), 
                                        @VF2_HAWB       VARCHAR(20), 
                                        @VF2_VLR_FRT    FLOAT, 
                                        @VF2_DTDIGIT    VARCHAR(20)) AS

BEGIN

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---  DATA        AUTOR            ALTERACAO
---  05/02/2016  ALENCAR          PASSA A INTEGRAR A EMPRESA USANDO A REGRA: EMPRESA + FILIAL, AONDE TABELAS DA SANCHEZ 
---                               CONSIDERA EMPRESA 1 E FINI EMPRESA 2
---  15/03/2016  ALENCAR          NAO INTEGRA NOTAS: @VF2_CLIENTE LIKE ('%A%') OR
---                                                  @VF2_CLIENTE LIKE ('%F%') OR
---                                                  @VF2_FILIAL  NOT IN ('01', '02') OR
---                                                  @VF2_TIPO = 'D'
---                               IMPLEMENTADO WITH (NOLOCK)
---  26/04/2016  ALENCAR          RETIRADO TRIM DO CAMPO @VF2_FRETE
---                               NAO INTEGRA NOTAS DO CLIENTE CODIGO BR
---  17/05/2016  ALENCAR          NAO INTEGRA NOTAS DA SERIE ECF, QUE SAO NOTAS EMITIDAS PELA LOJA FINI DO SHOPPING
---                               QUANDO REPRES NULO (@VF2_VEND1) GRAVA 0 NO MERCANET
---                               NAO INTEGRA NOTAS DE CLIENTES QUE ESTIVEREM INATIVOS NO PROTHEUS 
---  18/05/2016  ALENCAR          NAO INTEGRA NOTAS QUE O F2_CHVNFE = ' ' (REGRA UTILIZADA PELO SADIG)
---  19/05/2016  ALENCAR          AO VERIFICAR O CLIENTE, BUSCA SEMPRE COM R_E_C_D_E_L_ = ' '
---                               NOVAMENTE A REGRA MUDOU, NOTAS DE CLIENTES BLOQUEADOS DEVEM SER CARREGADAS
---                               NAO CARREGA NOTAS CLIENTES COMERCIO EXTERIOR
---  05/07/2016  ALENCAR          GRAVAR OS CAMPOS DB_NOTA_PED_MERC, DB_NOTA_PED_ORIG, DB_NOTA_OPERACAO, DB_NOTA_FATUR E DB_NOTA_PEDIDO COM BASE NO PRIMEIRO ITEM
---  25/08/2016  ALENCAR          FILTRO PARA IMPORTAR NOTAS DE TIPOS DIFERENTES DE N, D E ESPACO
---  21/09/2016  ALENCAR          CORRECAO NO SELECT QUE VERIFICA SE O CLIENTE EH COMERCIO EXTERIOR. ADICIONADO AND A1_LOJA  = @VF2_LOJA
---  25/10/2016  ALENCAR          CONVERSAO FINI
---  21/11/2016  ALENCAR          REGRA PARA DEFINIR A CONDICAO DE PAGAMENTO:
---                               SE POSSUIR LETRAS OU FOR MENOR QUE 3 CARACTERES ASSUME A CONDICAO 666
---                               SE FOR CONDICAO 000 ASSUME A 900
---  19/06/2017  ALENCAR          SE TEM ALGUM ITEM DE VENDA O FATUR DA NOTA DEVE SER CONSIDERADO VENDA, DO CONTRARIO MANTEM A REGRA ANTIGA, QUE AVALIA A OPERACAO DO ITEM
---                               ISSO DEVE SER FEITO POIS NA NOVA ALIANCA UMA MESMA NOTA TEM ITENS DE VENDA E BONIFICACAO
---  10/09/2018  SERGIO LUCCHINI  ALTERACAO NA BUSCA DO REPRESENTANTE. CHAMADO 84157
---  27/08/2019  ANDRE            ADICIONADO TRATAMENTO PARA TRANSPORTADORAS COM '/' NO CODIGO
---  23/03/2022  Robert           Versao inicial utilizando sinonimos
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @VOBJETO            VARCHAR(15) SELECT @VOBJETO = 'MERCP_SF2010';
DECLARE @VDATA              DATETIME;
DECLARE @VERRO              VARCHAR(1000);
DECLARE @VCOD_ERRO          VARCHAR(1000);
DECLARE @VINSERE            NUMERIC SELECT @VINSERE = 0;
DECLARE @VDB_PED_NRO        NUMERIC SELECT @VDB_PED_NRO = 0;
DECLARE @VDB_TBREP_CODIGO   NUMERIC;
DECLARE @VEMPRESA           VARCHAR(3);
DECLARE @VDB_PED_ORD_COMPRA VARCHAR(12);
DECLARE @VD2_PEDIDO         VARCHAR(6);
DECLARE @VD2_TES            VARCHAR(3);
DECLARE @VNOTA_FATUR        NUMERIC;
DECLARE @VDB_TBOPS_FAT      VARCHAR(1);
DECLARE @VF2_COND_AUX       VARCHAR(3);
DECLARE @V_TEM_VENDA        NUMERIC;

BEGIN TRY

IF @VF2_CLIENTE LIKE ('%A%') OR
   @VF2_CLIENTE LIKE ('%F%') OR
   @VF2_FILIAL NOT IN ('01') OR
   @VF2_TIPO = 'D' OR
   @VF2_CLIENTE IN ('BR') OR
   @VF2_TRANSP IN ('24/09') OR
   @VF2_SERIE IN ('ECF')
BEGIN
   RETURN;
END

IF (SELECT F2_CHVNFE
	  FROM INTEGRACAO_PROTHEUS_SF2
     WHERE F2_FILIAL  = @VF2_FILIAL
       AND F2_DOC     = @VF2_DOC
       AND F2_SERIE   = @VF2_SERIE
       AND F2_CLIENTE = @VF2_CLIENTE
       AND F2_LOJA    = @VF2_LOJA) = ' '
BEGIN
   RETURN;
END

-- BUSCA INFORMACOES DOS ITENS PARA ALIMENTAR ALGUNS CAMPOS DA NOTA FISCAL
SELECT TOP(1) @VD2_PEDIDO = D2_PEDIDO,
              @VD2_TES    = D2_TES
  FROM INTEGRACAO_PROTHEUS_SD2
 WHERE D2_FILIAL = @VF2_FILIAL
   AND D2_DOC    = @VF2_DOC
   AND D2_SERIE  = @VF2_SERIE;

--PRINT ' DEPOIS'
--PRINT '@VF2_DOC ' + @VF2_DOC

SET @VEMPRESA = SUBSTRING(RTRIM(@VF2_FILIAL), 1, 2);

IF ISNULL(LTRIM(RTRIM(@VF2_VEND1)),'')  <> '' AND
   ISNULL(LTRIM(RTRIM(@VF2_VEND1)),'0') <> '0'
BEGIN

   SELECT @VDB_TBREP_CODIGO = DB_TBREP_CODIGO
     FROM DB_TB_REPRES WITH (NOLOCK)
    WHERE DB_TBREP_CODORIG = LTRIM(RTRIM(@VF2_VEND1));

END
ELSE
BEGIN

   SET @VDB_TBREP_CODIGO = 0;
   SET @VCOD_ERRO = @@ERROR;
   IF @VCOD_ERRO > 0
   BEGIN
      SET @VDB_TBREP_CODIGO = 0;
   END

END

-- DEFINE A CONDICAO DE PAGAMENTO:
-- SE POSSUIR LETRAS OU FOR MENOR QUE 3 CARACTERES ASSUME A CONDICAO 666
-- SE FOR CONDICAO 000 ASSUME A 900
IF ISNUMERIC(@VF2_COND) = 0 OR LEN(RTRIM(LTRIM(@VF2_COND))) <> 3
   SET @VF2_COND_AUX = '666'
ELSE IF @VF2_COND = '000'
   SET @VF2_COND_AUX = '900'
ELSE
   SET @VF2_COND_AUX = @VF2_COND

IF @VEVENTO = 2 OR (@VD_E_L_E_T_ <> ' ')
BEGIN

   DELETE FROM DB_NOTA_FISCAL
    WHERE DB_NOTA_EMPRESA = @VEMPRESA
      AND DB_NOTA_NRO     = CAST(RTRIM(@VF2_DOC) AS INT)
      AND DB_NOTA_SERIE   = REPLACE(RTRIM(@VF2_SERIE), '-', '');

   DELETE FROM DB_NOTA_PROD
    WHERE DB_NOTAP_EMPRESA = @VEMPRESA
      AND DB_NOTAP_NRO     = CAST(RTRIM(@VF2_DOC) AS INT)
      AND DB_NOTAP_SERIE   = REPLACE(RTRIM(@VF2_SERIE), '-', '');

   DELETE FROM DB_NOTA_FRETE
    WHERE DB_NOTAF_EMP   = @VEMPRESA
      AND DB_NOTAF_NRO   = CAST(RTRIM(@VF2_DOC) AS INT)
      AND DB_NOTAF_SERIE = REPLACE(RTRIM(@VF2_SERIE), '-', '');
 
END
ELSE
BEGIN

   SELECT @VDB_PED_NRO = DB_PED_NRO,
          @VDB_PED_ORD_COMPRA = DB_PED_ORD_COMPRA
     FROM DB_PEDIDO
    WHERE DB_PED_NRO_ORIG = @VD2_PEDIDO
      AND DB_PED_EMPRESA  = @VEMPRESA;

   SELECT @VDB_TBOPS_FAT = DB_TBOPS_FAT
     FROM DB_TB_OPERS
    WHERE DB_TBOPS_COD = RTRIM(@VD2_TES);
   SET @VCOD_ERRO = @@ERROR;
   IF @VCOD_ERRO > 0
   BEGIN
      SET @VDB_TBOPS_FAT = 'N';
   END

   SET @V_TEM_VENDA = 0
   SELECT @V_TEM_VENDA = COUNT(1)
	 FROM INTEGRACAO_PROTHEUS_SD2, DB_TB_OPERS
     WHERE D2_FILIAL    = @VF2_FILIAL
       AND D2_DOC       = @VF2_DOC
       AND D2_SERIE     = @VF2_SERIE
       AND DB_TBOPS_COD = D2_TES COLLATE SQL_Latin1_General_CP1_CI_AS
       AND DB_TBOPS_FAT IN ('S', 'N')
       
   -- SE TEM ALGUM ITEM DE VENDA O FATUR DA NOTA DEVE SER CONSIDERADO VENDA, DO CONTRARIO MANTEM A REGRA ANTIGA, QUE AVALIA A OPERACAO DO ITEM
   -- ISSO DEVE SER FEITO POIS NA NOVA ALIANCA UMA MESMA NOTA TEM ITENS DE VENDA E BONIFICACAO
   IF @V_TEM_VENDA >= 1
   BEGIN
      SET @VNOTA_FATUR = 0;
   END
   ELSE 
   BEGIN
      IF @VDB_TBOPS_FAT = 'S' OR @VDB_TBOPS_FAT = 'V'
         SET @VNOTA_FATUR = 0;
      ELSE IF @VDB_TBOPS_FAT = 'N'
         SET @VNOTA_FATUR = 1;
      ELSE IF @VDB_TBOPS_FAT = 'B'
         SET @VNOTA_FATUR = 2;
      ELSE IF @VDB_TBOPS_FAT = 'D'
         SET @VNOTA_FATUR = 3;
      ELSE IF @VDB_TBOPS_FAT = 'T'
         SET @VNOTA_FATUR = 4;
   END

   SELECT @VINSERE = 1
     FROM DB_NOTA_FISCAL WITH (NOLOCK)
    WHERE DB_NOTA_NRO     = CAST(REPLACE(LTRIM(RTRIM(@VF2_DOC)),' ','') AS INT)
      AND DB_NOTA_SERIE   = REPLACE(RTRIM(@VF2_SERIE), '-', '')
      AND DB_NOTA_EMPRESA = @VEMPRESA;
   SET @VCOD_ERRO = @@ERROR;
   IF @VCOD_ERRO > 0
   BEGIN
      SET @VINSERE = 0;
   END

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
         DB_NOTA_MOTCANCEL
        )
      VALUES
        (
         @VEMPRESA,                                                  --DB_NOTA_EMPRESA
         CAST(REPLACE(LTRIM(RTRIM(@VF2_DOC)),' ','') AS INT),        --DB_NOTA_NRO
         REPLACE(RTRIM(@VF2_SERIE), '-', ''),                        --DB_NOTA_SERIE
         CAST(REPLACE(RTRIM(LTRIM(@VF2_CLIENTE)),' ','') AS FLOAT),  --DB_NOTA_CLIENTE
         @VDB_TBREP_CODIGO,                                          --DB_NOTA_REPRES
         RTRIM(@VF2_EMISSAO),                                        --DB_NOTA_DT_EMISSAO
         @VDB_PED_ORD_COMPRA,                                        --DB_NOTA_PEDIDO
         @VD2_PEDIDO,                                                --DB_NOTA_PED_ORIG
         @VF2_VALBRUT,                                               --DB_NOTA_VLR_TOTAL
         @VF2_VALMERC,                                               --DB_NOTA_VLR_PROD
         0,                                                          --DB_NOTA_COMISSAO
         RTRIM(@VD2_TES),                                            --DB_NOTA_OPERACAO
         @VNOTA_FATUR,                                               --DB_NOTA_FATUR
         @VDB_PED_NRO,                                               --DB_NOTA_PED_MERC
         @VF2_COND_AUX,                                              --DB_NOTA_COND_PGTO
         REPLACE(REPLACE(@VF2_TRANSP,' ',''),'/',''),                --DB_NOTA_TRANSP
         REPLACE(@VF2_REDESP,' ',''),                                --DB_NOTA_CODREDESP
         REPLACE(@VF2_REDESP,' ',''),                                --DB_NOTA_REDESP
         @VF2_FRETE,                                                 --DB_NOTA_FRETE
         NULL,                                                       --DB_NOTA_CDV
         NULL,                                                       --DB_NOTA_DT_CHAMADA
         NULL,                                                       --DB_NOTA_HR_CHAMADA
         NULL,                                                       --DB_NOTA_DT_EMB
         NULL,                                                       --DB_NOTA_HR_EMB
         NULL,                                                       --DB_NOTA_MOTDEVOL
         NULL,                                                       --DB_NOTA_OBSERV
         ISNULL(@VF2_PLIQUI,0),                                      --DB_NOTA_PESO_LIQ
         ISNULL(@VF2_PBRUTO,0),                                      --PPDB_NOTA_PESO_BRU
         ISNULL(@VF2_VOLUME1+@VF2_VOLUME2+@VF2_VOLUME3+@VF2_VOLUME4,0),  --DB_NOTA_VOLUMES
         0,                                                          --DB_NOTA_CUBAGEM
         NULL,                                                       --DB_NOTA_DATA_EDI
         0,                                                          --DB_NOTA_CANCEL
         NULL,                                                       --DB_NOTA_ROMANEIO
         NULL,                                                       --DB_NOTA_CFOP
         NULL                                                        --DB_NOTA_MOTCANCEL
        );

   END
   ELSE
   BEGIN

      UPDATE DB_NOTA_FISCAL 
         SET DB_NOTA_CLIENTE    = CAST(REPLACE(RTRIM(LTRIM(@VF2_CLIENTE)),' ','') AS FLOAT),
             DB_NOTA_REPRES     = @VDB_TBREP_CODIGO,
             DB_NOTA_DT_EMISSAO = RTRIM(@VF2_EMISSAO),
             DB_NOTA_VLR_TOTAL  = @VF2_VALBRUT, 
             DB_NOTA_VLR_PROD   = @VF2_VALMERC,
             DB_NOTA_COND_PGTO  = @VF2_COND_AUX,
             DB_NOTA_TRANSP     = REPLACE(@VF2_TRANSP,' ',''),
             DB_NOTA_CODREDESP  = REPLACE(@VF2_REDESP,' ',''),
             DB_NOTA_FRETE      = @VF2_FRETE,
             DB_NOTA_PESO_LIQ   = ISNULL(@VF2_PLIQUI,0),
             DB_NOTA_PESO_BRU   = ISNULL(@VF2_PBRUTO,0),
             DB_NOTA_VOLUMES    = ISNULL(@VF2_VOLUME1+@VF2_VOLUME2+@VF2_VOLUME3+@VF2_VOLUME4,0),
             DB_NOTA_PED_MERC   = @VDB_PED_NRO, 
             DB_NOTA_PED_ORIG   = @VD2_PEDIDO, 
             DB_NOTA_OPERACAO   = RTRIM(@VD2_TES),
             DB_NOTA_FATUR      = @VNOTA_FATUR,
             DB_NOTA_PEDIDO     = @VDB_PED_ORD_COMPRA
       WHERE DB_NOTA_NRO     = CAST(REPLACE(LTRIM(RTRIM(@VF2_DOC)),' ','') AS INT)
         AND DB_NOTA_SERIE   = REPLACE(RTRIM(@VF2_SERIE), '-', '')
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
