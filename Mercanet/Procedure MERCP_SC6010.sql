SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SC6010] (@VEVENTO       FLOAT,
                                      @VC6_FILIAL    VARCHAR(2),
                                      @VC6_ITEM      VARCHAR(2),
                                      @VC6_PRODUTO   VARCHAR(15),
                                      @VC6_DESCRI    VARCHAR(40),
                                      @VC6_UM        VARCHAR(2),
                                      @VC6_QTDVEN    FLOAT,
                                      @VC6_PRCVEN    FLOAT,
                                      @VC6_VALOR     FLOAT,
                                      @VC6_PEDCLI    VARCHAR(9),
                                      @VC6_SEGUM     VARCHAR(2),
                                      @VC6_QTDLIB    FLOAT,
                                      @VC6_UNSVEN    FLOAT,
                                      @VC6_QTDLIB2   FLOAT,
                                      @VC6_TES       VARCHAR(3),
                                      @VC6_QTDENT    FLOAT,
                                      @VC6_QTDENT2   FLOAT,
                                      @VC6_LOCAL     VARCHAR(2),
                                      @VC6_CF        VARCHAR(5),
                                      @VC6_CLI       VARCHAR(6),
                                      @VC6_ENTREG    VARCHAR(8),
                                      @VC6_LA        VARCHAR(8),
                                      @VC6_DESCONT   FLOAT,
                                      @VC6_VALDESC   FLOAT,
                                      @VC6_LOJA      VARCHAR(2),
                                      @VC6_DATFAT    VARCHAR(8),
                                      @VC6_NOTA      VARCHAR(9),
                                      @VC6_SERIE     VARCHAR(3),
                                      @VC6_NUM       VARCHAR(6),
                                      @VC6_COMIS1    FLOAT,
                                      @VC6_COMIS2    FLOAT,
                                      @VC6_COMIS3    FLOAT,
                                      @VC6_COMIS4    FLOAT,
                                      @VC6_COMIS5    FLOAT,
                                      @VC6_PRUNIT    FLOAT,
                                      @VC6_BLOQUEI   VARCHAR(2),
                                      @VC6_RESERVA   VARCHAR(6),
                                      @VC6_OP        VARCHAR(2),
                                      @VC6_OK        VARCHAR(2),
                                      @VC6_NFORI     VARCHAR(9),
                                      @VC6_SERIORI   VARCHAR(3),
                                      @VC6_ITEMORI   VARCHAR(4),
                                      @VC6_IPIDEV    FLOAT,
                                      @VC6_IDENTB6   VARCHAR(6),
                                      @VC6_BLQ       VARCHAR(2),
                                      @VC6_PICMRET   FLOAT,
                                      @VC6_CODISS    VARCHAR(9),
                                      @VC6_GRADE     VARCHAR(1),
                                      @VC6_ITEMGRD   VARCHAR(3),
                                      @VC6_LOTECTL   VARCHAR(10),
                                      @VC6_NUMLOTE   VARCHAR(6),
                                      @VC6_DTVALID   VARCHAR(8),
                                      @VC6_NUMORC    VARCHAR(8),
                                      @VC6_CHASSI    VARCHAR(17),
                                      @VC6_OPC       VARCHAR(80),
                                      @VC6_LOCALIZ   VARCHAR(15),
                                      @VC6_NUMSERI   VARCHAR(20),
                                      @VC6_NUMOP     VARCHAR(6),
                                      @VC6_ITEMOP    VARCHAR(2),
                                      @VC6_CLASFIS   VARCHAR(3),
                                      @VC6_QTDRESE   FLOAT,
                                      @VC6_CONTRAT   VARCHAR(6),
                                      @VC6_NUMOS     VARCHAR(10),
                                      @VC6_NUMOSFA   VARCHAR(10),
                                      @VC6_CODFAB    VARCHAR(6),
                                      @VC6_LOJAFA    VARCHAR(2),
                                      @VC6_ITEMCON   VARCHAR(2),
                                      @VC6_TPOP      VARCHAR(1),
                                      @VC6_REVISAO   VARCHAR(3),
                                      @VC6_SERVIC    VARCHAR(3),
                                      @VC6_ENDPAD    VARCHAR(15),
                                      @VC6_TPCONTR   VARCHAR(1),
                                      @VC6_ITCONTR   VARCHAR(2),
                                      @VC6_GEROUPV   VARCHAR(1),
                                      @VC6_PROJPMS   VARCHAR(10),
                                      @VC6_EDTPMS    VARCHAR(12),
                                      @VC6_TASKPMS   VARCHAR(12),
                                      @VC6_TRT       VARCHAR(3),
                                      @VC6_QTDEMP    FLOAT,
                                      @VC6_QTDEMP2   FLOAT,
                                      @VC6_PROJET    VARCHAR(6),
                                      @VC6_ITPROJ    VARCHAR(2),
                                      @VC6_POTENCI   FLOAT,
                                      @VC6_LICITA    VARCHAR(6),
                                      @VC6_REGWMS    VARCHAR(1),
                                      @VC6_NUMCP     VARCHAR(6),
                                      @VC6_NUMSC     VARCHAR(6),
                                      @VC6_ITEMSC    VARCHAR(4),
                                      @VC6_SUGENTR   VARCHAR(8),
                                      @VC6_ITEMED    VARCHAR(3),
                                      @VC6_ABSCINS   FLOAT,
                                      @VC6_ABATISS   FLOAT,
                                      @VC6_ABATMAT   FLOAT,
                                      @VC6_FUNRURA   FLOAT,
                                      @VC6_FETAB     FLOAT,
                                      @VC6_CODROM    VARCHAR(6),
                                      @VC6_PEDCOM    VARCHAR(6),
                                      @VC6_ITPC      VARCHAR(4),
                                      @VC6_FILPED    VARCHAR(2),
                                      --@VC6_PESOL     FLOAT,
                                      --@VC6_PBRUTO    FLOAT,
                                      --@VC6_XQTDIN    FLOAT,
                                      --@VC6_XQTDMA    FLOAT,
                                      @VC6_TPDEDUZ   VARCHAR(1),
                                      @VC6_MOTDED    VARCHAR(1),
                                      @VC6_FORDED    VARCHAR(6),
                                      @VC6_LOJDED    VARCHAR(2),
                                      @VC6_SERDED    VARCHAR(3),
                                      @VC6_NFDED     VARCHAR(9),
                                      @VC6_VLNFD     FLOAT,
                                      @VC6_PCDED     FLOAT,
                                      @VC6_VLDED     FLOAT,
                                      @VC6_ABATINS   FLOAT,
                                      @VC6_CODLAN    VARCHAR(6),
                                      @VD_E_L_E_T_   VARCHAR(1),
                                      @VR_E_C_N_O_   INT,
                                      @VR_E_C_D_E_L_ INT
                                     ) AS

BEGIN

DECLARE @VOBJETO            VARCHAR(15) SELECT @VOBJETO = 'MERCP_SC6010';
DECLARE @VDATA              DATETIME;
DECLARE @VERRO_BANCO        VARCHAR(1000);
DECLARE @VERRO              VARCHAR(1000);
DECLARE @VDB_PEDR_REPRES    FLOAT;
DECLARE @VDB_TBOPS_FAT      VARCHAR(1);
DECLARE @VDB_PEDI_TIPO      VARCHAR(2);
DECLARE @VDB_PEDI_ESTVLR    FLOAT;
DECLARE @VDB_PED_FATUR      FLOAT;
DECLARE @VDB_PED_OPERACAO   VARCHAR(10);
DECLARE @VQTDESOLIC         FLOAT;
DECLARE @VQTDEATEND         FLOAT;
DECLARE @VQTDECANCEL        FLOAT;
DECLARE @VSITUACAO          FLOAT;
DECLARE @VDB_PEDI_SITUACAO  FLOAT;
DECLARE @VQTDE_SOLIC        FLOAT;
DECLARE @VQTDE_ATEND        FLOAT;
DECLARE @VQTDE_CANC         FLOAT;
DECLARE @VPEDSITUACAO_NEW   FLOAT;
DECLARE @VC5_VEND1          VARCHAR(6);
DECLARE @VC5_VEND2          VARCHAR(6);
DECLARE @VC5_VEND3          VARCHAR(6);
DECLARE @VC5_VEND4          VARCHAR(6);
DECLARE @VC5_VEND5          VARCHAR(6);
DECLARE @VRETORNO           FLOAT;
DECLARE @VTOTAL_DESCTO      FLOAT;
DECLARE @VCOMISCALC         FLOAT;
DECLARE @VVALIDAESTOQUE     FLOAT;
DECLARE @V_TEM_ABERTO       FLOAT;
DECLARE @VINSERE            INT SELECT @VINSERE = 0;
DECLARE @VDB_PED_NRO        INT SELECT @VDB_PED_NRO = 0;
DECLARE @VDB_PEDI_SEQUENCIA INT SELECT @VDB_PEDI_SEQUENCIA = 0;
DECLARE @VEMPRESA           VARCHAR(3);
DECLARE @VC5_LOJACLI        VARCHAR(2);
DECLARE @VC5_CLIENTE        VARCHAR(6);
DECLARE @VC5_EMISSAO        VARCHAR(8);
DECLARE @VNRO_NOTA          VARCHAR(10);

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00001  11/11/2010  SERGIO LUCCHINI  DESENVOLVIMENTO
---  1.00002  05/02/2016  ALENCAR          PASSA A INTEGRAR A EMPRESA USANDO A REGRA: EMPRESA + FILIAL, AONDE TABELAS DA SANCHEZ 
---                                        CONSIDERA EMPRESA 1 E FINI EMPRESA 2
---  1.00003  14/03/2016  ALENCAR          NAO INTEGRA PEDIDOS: @VC5_LOJACLI IN ('SU', 'R:', 'A')
---                                                             @VC5_CLIENTE LIKE ('%A%')
---                                                             @VC5_CLIENTE LIKE ('%F%')
---                                                             @VC6_FILIAL NOT IN ('01')
---                                                             @VC5_EMISSAO < '20140101'
---  1.00004  27/04/2016  ALENCAR          REGRA FINI PARA DEFINIR A QUANTIDADE CANCELADA
---  1.00005  22/06/2016  ALENCAR          RETIRADO OS CAMPOS C6_TPESTR E C6_CONTRT
---  1.00006  16/09/2016  ALENCAR          GRAVA A DATA DE ATENDIMENTO (DB_PEDI_ATD_DATA) NULA QUANDO NAO TEM NO PROTHEUS 
---  1.00007  27/09/2016  ALENCAR          NAO ATUALIZAR O DB_PEDI_PRECO_UNIT NO UPDATE
---  1.00008  30/09/2016  ALENCAR          ITENS CANCELADOS GRAVA O CAMPO DB_PEDI_ATD_DATA2 COM A DATA DE EMISSÃO. ESSE CAMPO É UTILIZADO PELO RELATÓRIO DE PEDIDOS CANCELADOS
---  1.00009  24/10/2016  ALENCAR          CONVERSÃO NOVA ALIANÇA
---  1.00010  03/11/2016  ALENCAR          INTEGRA O ATENDIMENTO DO PEDIDO PREVENDO QUE ALGUMAS NOTAS POSSUEM ZEROS A ESQUERDA. EX.: 000112813
---  1.00011  19/06/2017  ALENCAR          VALIDAR QUANDO O C6_NUM POSSUIR LETRAS
---  1.00012  03/07/2017  SERGIO LUCCHINI  ALTERADO A REGRA DE ATUALIZACAO DA QUANTIDADE CANCELADA. CHAMADO 77801
---           02/05/2018  ROBERT           Alterado nome do linked server de acesso ao ERP Protheus.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN TRY

SET @VDB_TBOPS_FAT = 'V';
SELECT @VDB_TBOPS_FAT = DB_TBOPS_FAT
  FROM DB_TB_OPERS
 WHERE DB_TBOPS_COD = LTRIM(RTRIM(@VC6_TES));

IF @VDB_TBOPS_FAT = 'B'
BEGIN
   SET @VDB_PEDI_TIPO = 'B';
   SET @VDB_PEDI_ESTVLR = 0;
END
ELSE
BEGIN
   SET @VDB_PEDI_TIPO = 'V';
   SET @VDB_PEDI_ESTVLR = 1;
END

IF @VDB_TBOPS_FAT = 'S'
BEGIN
   SET @VDB_PED_FATUR = 0;
END

IF @VDB_TBOPS_FAT = 'N'
BEGIN
   SET @VDB_PED_FATUR = 1;
END 

IF @VDB_TBOPS_FAT = 'B'
BEGIN
   SET @VDB_PED_FATUR = 2;
END

IF @VDB_TBOPS_FAT = 'D'
BEGIN
   SET @VDB_PED_FATUR = 3;
END

IF @VDB_TBOPS_FAT = 'T'
BEGIN
   SET @VDB_PED_FATUR = 4;
END

SET @VEMPRESA = SUBSTRING(RTRIM(LTRIM(@VC6_FILIAL)), 1, 2)

SET @VC5_VEND1 = '';
SET @VC5_VEND2 = '';
SET @VC5_VEND3 = '';
SET @VC5_VEND4 = '';
SET @VC5_VEND5 = '';
SELECT @VC5_VEND1   = RTRIM(C5_VEND1),
       @VC5_VEND2   = RTRIM(C5_VEND2),
       @VC5_VEND3   = RTRIM(C5_VEND3),
       @VC5_VEND4   = RTRIM(C5_VEND4),
       @VC5_VEND5   = RTRIM(C5_VEND5),
       @VC5_LOJACLI = C5_LOJACLI,
       @VC5_CLIENTE = C5_CLIENTE,
       @VC5_CLIENTE = C5_CLIENTE,
       @VC5_EMISSAO = C5_EMISSAO
--  FROM "192.168.1.2".protheus.dbo.SC5010
  FROM LKSRV_PROTHEUS.protheus.dbo.SC5010
 WHERE C5_FILIAL  = @VC6_FILIAL
   AND C5_NUM     = @VC6_NUM
   AND D_E_L_E_T_ = ' ';

IF @VC5_LOJACLI IN ('SU', 'R:', 'A') OR
   @VC5_CLIENTE LIKE ('%A%') OR
   @VC5_CLIENTE LIKE ('%F%') OR
   @VC6_FILIAL  NOT IN ('01') OR
   @VC5_EMISSAO < '20140101' OR
   @VC6_NUM     LIKE ('%c%')
BEGIN
   RETURN;
END

SELECT @VDB_PED_NRO = DB_PED_NRO
  FROM DB_PEDIDO
 WHERE DB_PED_NRO_ORIG = @VC6_NUM
   AND DB_PED_EMPRESA  = @VEMPRESA;

IF @VDB_PED_NRO IS NULL OR
   @VDB_PED_NRO = '' OR
   @VDB_PED_NRO = 0
BEGIN
   SET @VDB_PED_NRO = 0;
END;

--PRINT('@VDB_PED_NRO: '+ CAST(@VDB_PED_NRO AS VARCHAR));

IF ISNULL(@VDB_PED_NRO, 0) = 0
BEGIN
   PRINT('NAO ACHOU O PEDIDO');
   RETURN;
END

SET @VVALIDAESTOQUE = 1;

IF @VEVENTO = 2 OR @VD_E_L_E_T_ <> ' '
BEGIN
   UPDATE DB_PEDIDO_PROD
      SET DB_PEDI_SITUACAO = 9,
          DB_PEDI_QTDE_CANC = DB_PEDI_QTDE_SOLIC
    WHERE DB_PEDI_PEDIDO  = @VDB_PED_NRO
      AND DB_PEDI_PRODUTO = LTRIM(RTRIM(@VC6_PRODUTO));
END
ELSE
BEGIN

   SET @VQTDESOLIC  = @VC6_QTDVEN;
   SET @VQTDEATEND  = @VC6_QTDENT;
   SET @VQTDECANCEL = CASE @VC6_BLQ WHEN 'R' THEN @VC6_QTDVEN - @VC6_QTDEMP - @VC6_QTDENT ELSE 0 END;

   IF (@VQTDECANCEL + @VQTDEATEND) > @VQTDESOLIC
   BEGIN
      IF @VQTDECANCEL = 0
      BEGIN
         SET @VQTDESOLIC = @VQTDEATEND;
      END
      ELSE IF @VQTDEATEND = 0
      BEGIN    
         SET @VQTDECANCEL = @VQTDESOLIC;
      END
      ELSE
      BEGIN
         SET @VQTDECANCEL = @VQTDESOLIC - @VQTDEATEND;

         IF @VQTDECANCEL < 0
         BEGIN
            SET @VQTDECANCEL = 0;
            SET @VQTDESOLIC  = @VQTDEATEND;
         END
      END
   END

   --PRINT '@VQTDESOLIC ' + CAST(@VQTDESOLIC AS VARCHAR);
   --PRINT '@VQTDEATEND ' + CAST(@VQTDEATEND AS VARCHAR);
   --PRINT '@VQTDECANCEL ' + CAST(@VQTDECANCEL AS VARCHAR);

   IF @VQTDESOLIC = @VQTDECANCEL
   BEGIN
      SET @VSITUACAO = 9;
   END
   ELSE IF @VQTDEATEND > 0 AND (@VQTDESOLIC - @VQTDECANCEL - @VQTDEATEND) > 0
   BEGIN
      SET @VSITUACAO = 1;
   END
   ELSE IF @VQTDEATEND > 0 AND (@VQTDESOLIC - @VQTDECANCEL - @VQTDEATEND) <= 0
   BEGIN
      SET @VSITUACAO = 2;
   END
   ELSE
   BEGIN
      SET @VSITUACAO = 0;
   END

   --PRINT '@@VSITUACAO ' + CAST(@VSITUACAO AS VARCHAR)

   SELECT @VDB_PEDI_SEQUENCIA = MAX(ISNULL(DB_PEDI_SEQUENCIA,0)) + 1
     FROM DB_PEDIDO_PROD
    WHERE DB_PEDI_PEDIDO = @VDB_PED_NRO;

   IF @VDB_PEDI_SEQUENCIA IS NULL OR
      @VDB_PEDI_SEQUENCIA = 0
   BEGIN
      SET @VDB_PEDI_SEQUENCIA = 1;
   END;

   IF ISNUMERIC(@VC6_NOTA) = 1
      SET @VNRO_NOTA = SUBSTRING(SUBSTRING(CAST(CAST(@VC6_NOTA AS NUMERIC) AS VARCHAR),1,6) + '-' + @VC6_SERIE,1,10);
   ELSE
      SET @VNRO_NOTA = SUBSTRING(SUBSTRING(CAST(@VC6_NOTA AS VARCHAR),1,6) + '-' + @VC6_SERIE,1,10);

   SET @VINSERE = 0;
   SELECT @VINSERE = 1
     FROM DB_PEDIDO_PROD
    WHERE DB_PEDI_PEDIDO  = @VDB_PED_NRO
      AND DB_PEDI_PRODUTO = LTRIM(RTRIM(@VC6_PRODUTO));

   IF @VINSERE = 0
   BEGIN

      INSERT INTO DB_PEDIDO_PROD
        (
         DB_PEDI_PEDIDO,
         DB_PEDI_SEQUENCIA,
         DB_PEDI_PRODUTO,
         DB_PEDI_QTDE_SOLIC,
         DB_PEDI_QTDE_ATEND,
         DB_PEDI_QTDE_CANC,
         DB_PEDI_PRECO_UNIT,
         DB_PEDI_PRECO_LIQ,
         DB_PEDI_DESCTOP,
         DB_PEDI_DESCTO_ICM,
         DB_PEDI_PREV_ENTR,
         DB_PEDI_ATD_DATA,
         DB_PEDI_ATD_QTDE,
         DB_PEDI_ATD_DCTO,
         DB_PEDI_ATD_DATA1,
         DB_PEDI_ATD_QTDE1,
         DB_PEDI_ATD_DCTO1,
         DB_PEDI_ATD_QTDE2,
         DB_PEDI_ATD_DCTO2,
         DB_PEDI_SITUACAO,
         DB_PEDI_IPI,
         DB_PEDI_DCTOPROM,
         DB_PEDI_ECON_VLR,
         DB_PEDI_ECON_CALC,
         DB_PEDI_ECON_DCTO,
         DB_PEDI_PRECO_MIN,
         DB_PEDI_TIPO,
         DB_PEDI_DCTOVDA,
         DB_PEDI_TIPO_PRECO,
         DB_PEDI_ESTVLR,
         DB_PEDI_ACRESCIMO,
         DB_PEDI_LPRECO,
         DB_PEDI_PERC_COMIS,
         DB_PEDI_PRDCFGCAR,
         DB_PEDI_OBSERV,
         DB_PEDI_OPERACAO,
         DB_PEDI_ALMOXARIF,
         DB_PEDI_ATD_DATA2
        )
      VALUES
        (
         @VDB_PED_NRO,                                           --DB_PEDI_PEDIDO
         @VDB_PEDI_SEQUENCIA,                                    --DB_PEDI_SEQUENCIA
         SUBSTRING(LTRIM(RTRIM(@VC6_PRODUTO)),1,16),             --DB_PEDI_PRODUTO
         @VC6_QTDVEN,                                            --DB_PEDI_QTDE_SOLIC
         @VC6_QTDENT,                                            --DB_PEDI_QTDE_ATEND
         @VQTDECANCEL,                                           --DB_PEDI_QTDE_CANC
         @VC6_PRCVEN,                                            --DB_PEDI_PRECO_UNIT
         @VC6_PRCVEN,                                            --DB_PEDI_PRECO_LIQ
         0,  --@VC6_DESCONT,                                     --DB_PEDI_DESCTOP
         0,                                                      --DB_PEDI_DESCTO_ICM
         CONVERT(CHAR,LTRIM(RTRIM(@VC6_ENTREG)),103),            --DB_PEDI_PREV_ENTR
         CASE CONVERT(CHAR,LTRIM(RTRIM(@VC6_DATFAT)),103) WHEN '' THEN NULL ELSE CONVERT(CHAR,LTRIM(RTRIM(@VC6_DATFAT)),103) END,  --DB_PEDI_ATD_DATA
         @VC6_QTDENT,                                            --DB_PEDI_ATD_QTDE
         --SUBSTRING(SUBSTRING(@VC6_NOTA,1,6) + '-' + @VC6_SERIE,1,10),  --DB_PEDI_ATD_DCTO
         --SUBSTRING(SUBSTRING(CAST(CAST(@VC6_NOTA AS NUMERIC) AS VARCHAR),1,6) + '-' + @VC6_SERIE,1,10),  --DB_PEDI_ATD_DCTO
         @VNRO_NOTA,                                             --DB_PEDI_ATD_DCTO
         NULL,                                                   --DB_PEDI_ATD_DATA1
         0,                                                      --DB_PEDI_ATD_QTDE1
         NULL,                                                   --DB_PEDI_ATD_DCTO1
         0,                                                      --DB_PEDI_ATD_QTDE2
         NULL,                                                   --DB_PEDI_ATD_DCTO2
         @VSITUACAO,                                             --DB_PEDI_SITUACAO
         0,                                                      --DB_PEDI_IPI
         NULL,                                                   --DB_PEDI_DCTOPROM
         0,                                                      --DB_PEDI_ECON_VLR
         0,                                                      --DB_PEDI_ECON_CALC
         0,                                                      --DB_PEDI_ECON_DCTO
         0,                                                      --DB_PEDI_PRECO_MIN
         SUBSTRING(LTRIM(RTRIM(@VC6_TES)),1,1),                  --DB_PEDI_TIPO
         NULL,                                                   --DB_PEDI_DCTOVDA
         0,                                                      --DB_PEDI_TIPO_PRECO
         @VDB_PEDI_ESTVLR,                                       --DB_PEDI_ESTVLR
         0,                                                      --DB_PEDI_ACRESCIMO
         NULL,                                                   --DB_PEDI_LPRECO
         @VC6_COMIS1 + @VC6_COMIS2 + @VC6_COMIS3 + @VC6_COMIS4 + @VC6_COMIS5,  -- + @VC6_COMIS6 + @VC6_COMIS7 + @VC6_COMIS8 + @VC6_COMIS9,  --DB_PEDI_PERC_COMIS
         NULL,                                                   --DB_PEDI_PRDCFGCAR
         NULL,                                                   --DB_PEDI_OBSERV
         SUBSTRING(LTRIM(RTRIM(@VC6_TES)),1,10),                 --DB_PEDI_OPERACAO
         SUBSTRING(@VC6_LOCAL,1,2),                              --DB_PEDI_ALMOXARIF
         CASE @VC6_BLQ WHEN 'R' THEN @VC5_EMISSAO ELSE NULL END  --DB_PEDI_ATD_DATA2
        );

   END
   ELSE
   BEGIN

      UPDATE DB_PEDIDO_PROD
         SET DB_PEDI_QTDE_SOLIC = @VC6_QTDVEN,
             DB_PEDI_QTDE_ATEND = @VC6_QTDENT,
             DB_PEDI_QTDE_CANC  = @VQTDECANCEL,
             --DB_PEDI_PRECO_UNIT = @VC6_PRCVEN,
             DB_PEDI_PRECO_LIQ  = @VC6_PRCVEN,
             DB_PEDI_DESCTOP    = 0,
             DB_PEDI_PREV_ENTR  = CONVERT(CHAR,LTRIM(RTRIM(@VC6_ENTREG)),103),
             DB_PEDI_ATD_DATA   = CASE CONVERT(CHAR,LTRIM(RTRIM(@VC6_DATFAT)),103) WHEN '' THEN NULL ELSE CONVERT(CHAR,LTRIM(RTRIM(@VC6_DATFAT)),103) END,
             DB_PEDI_ATD_QTDE   = @VC6_QTDENT,
             --DB_PEDI_ATD_DCTO   = SUBSTRING(SUBSTRING(@VC6_NOTA,1,6) + '-' + @VC6_SERIE,1,10),
             --DB_PEDI_ATD_DCTO   = SUBSTRING(SUBSTRING(CAST(CAST(@VC6_NOTA AS NUMERIC) AS VARCHAR),1,6) + '-' + @VC6_SERIE,1,10),
             DB_PEDI_ATD_DCTO     = @VNRO_NOTA,
             --DB_PEDI_TIPO       = SUBSTRING(LTRIM(RTRIM(@VC6_TES)),1,1),
             DB_PEDI_ESTVLR     = @VDB_PEDI_ESTVLR,
             DB_PEDI_OPERACAO   = SUBSTRING(LTRIM(RTRIM(@VC6_TES)),1,10),
             DB_PEDI_ALMOXARIF  = SUBSTRING(@VC6_LOCAL,1,2),
             DB_PEDI_SITUACAO   = @VSITUACAO,
             DB_PEDI_PERC_COMIS = @VC6_COMIS1 + @VC6_COMIS2 + @VC6_COMIS3 + @VC6_COMIS4 + @VC6_COMIS5,-- + @VC6_COMIS6 + @VC6_COMIS7 + @VC6_COMIS8 + @VC6_COMIS9,
             DB_PEDI_ACRESCIMO  = 0,
             DB_PEDI_ATD_DATA2  = CASE @VC6_BLQ WHEN 'R' THEN @VC5_EMISSAO ELSE NULL END
       WHERE DB_PEDI_PEDIDO  = @VDB_PED_NRO
         AND DB_PEDI_PRODUTO = SUBSTRING(LTRIM(RTRIM(@VC6_PRODUTO)),1,16);

   END  -- IF @VINSERE = 0

   SET @VINSERE = 0;
   SELECT @VINSERE = 1
     FROM DB_PEDIDO_ATEND
    WHERE DB_PEDA_PEDIDO   = @VDB_PED_NRO
      AND DB_PEDA_PED_SEQ  = @VDB_PEDI_SEQUENCIA
      AND DB_PEDA_EMPRESA  = @VEMPRESA
      AND DB_PEDA_NOTA     = @VC6_NOTA
      AND DB_PEDA_SERIE    = @VC6_SERIE
      AND DB_PEDA_NOTA_SEQ = @VDB_PEDI_SEQUENCIA;

   IF @VINSERE = 0
   BEGIN
      INSERT INTO DB_PEDIDO_ATEND
        (
         DB_PEDA_PEDIDO,    -- 01
         DB_PEDA_PED_SEQ,   -- 02
         DB_PEDA_EMPRESA,   -- 03
         DB_PEDA_NOTA,      -- 04
         DB_PEDA_SERIE,     -- 05
         DB_PEDA_NOTA_SEQ,  -- 06
         DB_PEDA_DT_ATEND,  -- 07
         DB_PEDA_QTDE       -- 08
        )
      VALUES
        (
         @VDB_PED_NRO,               -- 01
         @VDB_PEDI_SEQUENCIA,        -- 02
         @VEMPRESA,                  -- 03
         @VC6_NOTA,                  -- 04
         @VC6_SERIE,                 -- 05
         @VDB_PEDI_SEQUENCIA,        -- 06
         LTRIM(RTRIM(@VC6_DATFAT)),  -- 07
         @VC6_QTDENT                 -- 08
        );

   END
   ELSE
   BEGIN

      UPDATE DB_PEDIDO_ATEND
         SET DB_PEDA_DT_ATEND = LTRIM(RTRIM(@VC6_DATFAT)),
             DB_PEDA_QTDE     = @VC6_QTDENT
       WHERE DB_PEDA_PEDIDO   = @VDB_PED_NRO
         AND DB_PEDA_PED_SEQ  = @VDB_PEDI_SEQUENCIA
         AND DB_PEDA_EMPRESA  = @VEMPRESA
         AND DB_PEDA_NOTA     = @VC6_NOTA
         AND DB_PEDA_SERIE    = @VC6_SERIE
         AND DB_PEDA_NOTA_SEQ = @VDB_PEDI_SEQUENCIA;

   END  -- IF @VINSERE = 0

   SET @VTOTAL_DESCTO = ISNULL(@VC6_COMIS1, 0) + ISNULL(@VC6_COMIS2, 0) + ISNULL(@VC6_COMIS3, 0) + ISNULL(@VC6_COMIS4, 0) + ISNULL(@VC6_COMIS5, 0);-- + ISNULL(@VC6_COMIS6, 0) + ISNULL(@VC6_COMIS7, 0) + ISNULL(@VC6_COMIS8, 0) + ISNULL(@VC6_COMIS9, 0);

   IF REPLACE(ISNULL(@VC5_VEND1, 0), '', 0) > 0 
   BEGIN
      IF @VTOTAL_DESCTO > 0
      BEGIN
         SET @VCOMISCALC = (@VC6_COMIS1 * 100) / @VTOTAL_DESCTO;
      END
      ELSE
      BEGIN
         SET @VCOMISCALC = 0;
      END
   END

   IF REPLACE(ISNULL(@VC5_VEND2, 0), '', 0) > 0
   BEGIN
      IF @VTOTAL_DESCTO > 0
      BEGIN
         SET @VCOMISCALC = (@VC6_COMIS2 * 100) / @VTOTAL_DESCTO;
      END
      ELSE
      BEGIN
         SET @VCOMISCALC = 0;
      END
   END

   IF REPLACE(ISNULL(@VC5_VEND3, 0), '', 0) > 0 
   BEGIN
      IF @VTOTAL_DESCTO > 0 
      BEGIN
         SET @VCOMISCALC = (@VC6_COMIS3 * 100) / @VTOTAL_DESCTO;
      END
      ELSE
      BEGIN
         SET @VCOMISCALC = 0;
      END
   END

   IF REPLACE(ISNULL(@VC5_VEND4, 0), '', 0) > 0
   BEGIN
      IF @VTOTAL_DESCTO > 0
      BEGIN
         SET @VCOMISCALC = (@VC6_COMIS4 * 100) / @VTOTAL_DESCTO;
      END
      ELSE
      BEGIN
         SET @VCOMISCALC = 0;
      END
   END

   IF REPLACE(ISNULL(@VC5_VEND5, 0), '', 0) > 0 
   BEGIN
      IF @VTOTAL_DESCTO > 0
      BEGIN
         SET @VCOMISCALC = (@VC6_COMIS5 * 100) / @VTOTAL_DESCTO;
      END
      ELSE
      BEGIN
         SET @VCOMISCALC = 0;
      END
   END

   --ATUALIZA A SITUACAO DO PEDIDO
   SELECT @VQTDE_SOLIC = SUM(DB_PEDI_QTDE_SOLIC),
          @VQTDE_ATEND = SUM(DB_PEDI_QTDE_ATEND),
          @VQTDE_CANC  = SUM(DB_PEDI_QTDE_CANC)
     FROM DB_PEDIDO_PROD
    WHERE DB_PEDI_PEDIDO = @VDB_PED_NRO;

   IF @VQTDE_ATEND = 0 AND (@VQTDE_CANC >= 0 AND @VQTDE_CANC < @VQTDE_SOLIC)
   BEGIN
      SET @VPEDSITUACAO_NEW = 0;
   END
   ELSE IF ROUND(@VQTDE_SOLIC - @VQTDE_CANC, 2) = 0
   BEGIN
      SET @VPEDSITUACAO_NEW = 9;
   END
   ELSE IF ROUND(@VQTDE_SOLIC - @VQTDE_ATEND - @VQTDE_CANC, 2) = 0
   BEGIN
      SET @VPEDSITUACAO_NEW = 4;
   END
   ELSE IF ROUND(@VQTDE_SOLIC - @VQTDE_ATEND - @VQTDE_CANC,2) > 0
   BEGIN
      SET @VPEDSITUACAO_NEW = 2;
   END
   ELSE
   BEGIN
      SET @VPEDSITUACAO_NEW = 99;
   END

   -- ROTINA PARA VERIFICAR SE TODOS OS ITENS ESTAO FATURADOS 
   SET @V_TEM_ABERTO = 0;
   DECLARE CUR CURSOR
   FOR SELECT DB_PEDI_SITUACAO FROM DB_PEDIDO_PROD WHERE DB_PEDI_PEDIDO  = @VDB_PED_NRO
         OPEN CUR
        FETCH NEXT FROM CUR
         INTO @VDB_PEDI_SITUACAO
        WHILE @@FETCH_STATUS = 0
       BEGIN
         IF @VDB_PEDI_SITUACAO <> 2
         BEGIN
            SET @V_TEM_ABERTO  = 1;
         END
        FETCH NEXT FROM CUR
         INTO @VDB_PEDI_SITUACAO
       END;
        CLOSE CUR
   DEALLOCATE CUR

   IF @V_TEM_ABERTO = 0
   BEGIN
      SET @VPEDSITUACAO_NEW = 4;
   END

   -- SE A SITUACAO DO PEDIDO É BLOQUEADA NAO DEVE ATUALIZAR COM A DO MICROSIGA
   -- POREM MANTEM A SITUACAO DO ERP NOS CASOS 2, 4 E 9
   UPDATE DB_PEDIDO
      SET DB_PED_SITUACAO   = @VPEDSITUACAO_NEW,
          DB_PED_FATUR      = @VDB_PED_FATUR,
          DB_PED_DT_PREVENT = CONVERT(CHAR,LTRIM(RTRIM(@VC6_ENTREG)),103)
          --DB_PED_SITCORP    = @VPEDSITUACAO_NEW
    WHERE DB_PED_NRO = @VDB_PED_NRO;

   -- ALTERA A OPERACAO DO PEDIDO QDO FOR VENDA OU QUANDO FOR O PRIMEIRO ITEM
   IF @VDB_PEDI_SEQUENCIA = 1
   BEGIN
      UPDATE DB_PEDIDO
         SET DB_PED_OPERACAO = LTRIM(RTRIM(@VC6_TES))
       WHERE DB_PED_NRO = @VDB_PED_NRO;
   END

END

END TRY

BEGIN CATCH
  SELECT @VERRO = CAST(ERROR_NUMBER() AS VARCHAR) + ERROR_MESSAGE()

  PRINT @VERRO
  INSERT INTO DBS_ERROS_TRIGGERS
    (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
  VALUES
    (@VERRO, GETDATE(), @VOBJETO );
END CATCH

END
GO
