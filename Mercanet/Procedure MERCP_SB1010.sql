USE [MercanetPRD]
GO

/****** Object:  StoredProcedure [dbo].[MERCP_SB1010]    Script Date: 10/05/2022 13:24:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[MERCP_SB1010](@VEVENTO      FLOAT,
                                    @VB1_FILIAL     VARCHAR(50),
                                    @VB1_COD        VARCHAR(50),
                                    @VB1_DESC       VARCHAR(50),
                                    @VB1_TIPO       VARCHAR(50),
                                    @VB1_UM         VARCHAR(50),
                                    @VB1_LOCPAD     VARCHAR(50),
                                    @VB1_GRUPO      VARCHAR(50),
                                    @VB1_TAB_IPI    VARCHAR(50),
                                    @VB1_ORIGEM     VARCHAR(50),
                                    @VB1_CLASFIS    VARCHAR(50),
                                    @VB1_CONTA      VARCHAR(50),
                                    @VB1_CC         VARCHAR(50),
                                    @VB1_TE         VARCHAR(50),
                                    @VB1_TS         VARCHAR(50),
                                    @VB1_PROC       VARCHAR(50),
                                    @VB1_IPI        FLOAT,
                                    @VB1_PICM       FLOAT,
                                    @VB1_LE         FLOAT,
                                    @VB1_LM         FLOAT,
                                    @VB1_IRRF       VARCHAR(50),
                                    @VB1_POSIPI     VARCHAR(50),
                                    @VB1_EX_NCM     VARCHAR(50),
                                    @VB1_EX_NBM     VARCHAR(50),
                                    @VB1_ALIQISS    FLOAT,
                                    @VB1_CODISS     VARCHAR(50),
                                    @VB1_PICMRET    FLOAT,
                                    @VB1_PICMENT    FLOAT,
                                    @VB1_IMPZFRC    VARCHAR(50),
                                    @VB1_BITMAP     VARCHAR(50),
                                    @VB1_SEGUM      VARCHAR(50),
                                    @VB1_CONV       FLOAT,
                                    @VB1_TIPCONV    VARCHAR(50),
                                    @VB1_ALTER      VARCHAR(50),
                                    @VB1_INSS       VARCHAR(50),
                                    @VB1_QE         FLOAT,
                                    @VB1_PRV1       FLOAT,
                                    @VB1_EMIN       FLOAT,
                                    @VB1_CUSTD      FLOAT,
                                    @VB1_UPRC       FLOAT,
                                    @VB1_UCOM       VARCHAR(50),
                                    @VB1_PESO       FLOAT,
                                    @VB1_ESTSEG     FLOAT,
                                    @VB1_ESTFOR     VARCHAR(50),
                                    @VB1_FORPRZ     VARCHAR(50),
                                    @VB1_PE         FLOAT,
                                    @VB1_TIPE       VARCHAR(50),
                                    @VB1_TOLER      FLOAT,
                                    @VB1_FAMILIA    VARCHAR(50),
                                    @VB1_LOJPROC    VARCHAR(50),
                                    @VB1_QB         FLOAT,
                                    @VB1_APROPRI    VARCHAR(50),
                                    @VB1_FANTASM    VARCHAR(50),
                                    @VB1_TIPODEC    VARCHAR(50),
                                    @VB1_DATREF     VARCHAR(50),
                                    @VB1_RASTRO     VARCHAR(50),
                                    @VB1_UREV       VARCHAR(50),
                                    @VB1_FORAEST    VARCHAR(50),
                                    @VB1_COMIS      FLOAT,
                                    @VB1_MONO       VARCHAR(50),
                                    @VB1_MRP        VARCHAR(50),
                                    @VB1_PERINV     FLOAT,
                                    @VB1_DTREFP1    VARCHAR(50),
                                    @VB1_GRTRIB     VARCHAR(50),
                                    @VB1_NOTAMIN    FLOAT,
                                    @VB1_PRVALID    FLOAT,
                                    @VB1_NUMCOP     FLOAT,
                                    @VB1_CONTSOC    VARCHAR(50),
                                    @VB1_CONINI     VARCHAR(50),
                                    @VB1_CODBAR     VARCHAR(50),
                                    @VB1_GRADE      VARCHAR(50),
                                    @VB1_FORMLOT    VARCHAR(50),
                                    @VB1_LOCALIZ    VARCHAR(50),
                                    @VB1_OPERPAD    VARCHAR(50),
                                    @VB1_CONTRAT    VARCHAR(50),
                                    @VB1_DESC_P     VARCHAR(50),
                                    @VB1_FPCOD      VARCHAR(50),
                                    @VB1_DESC_I     VARCHAR(50),
                                    @VB1_VLREFUS    FLOAT,
                                    @VB1_DESC_GI    VARCHAR(50),
                                    @VB1_IMPORT     VARCHAR(50),
                                    @VB1_ANUENTE    VARCHAR(50),
                                    @VB1_OPC        VARCHAR(80),
                                    @VB1_CODOBS     VARCHAR(50),
                                    @VB1_FABRIC     VARCHAR(50),
                                    @VB1_SITPROD    VARCHAR(50),
                                    @VB1_MODELO     VARCHAR(50),
                                    @VB1_SETOR      VARCHAR(50),
                                    @VB1_BALANCA    VARCHAR(50),
                                    @VB1_TECLA      VARCHAR(50),
                                    @VB1_PRODPAI    VARCHAR(50),
                                    @VB1_CODEMB     VARCHAR(50),
                                    @VB1_SOLICIT    VARCHAR(50),
                                    @VB1_GRUPCOM    VARCHAR(50),
                                    @VB1_ALADI      VARCHAR(50),
                                    @VB1_CONTCQP    FLOAT,
                                    @VB1_REVATU     VARCHAR(50),
                                    @VB1_ESPECIF    VARCHAR(80),
                                    @VB1_NALNCCA    VARCHAR(50),
                                    @VB1_NUMCQPR    FLOAT,
                                    @VB1_NALSH      VARCHAR(50),
                                    @VB1_MAT_PRI    VARCHAR(50),
                                    @VB1_TIPOCQ     VARCHAR(50),
                                    @VB1_MIDIA      VARCHAR(50),
                                    @VB1_VLR_IPI    FLOAT,
                                    @VB1_QTMIDIA    FLOAT,
                                    @VB1_PIS        VARCHAR(50),
                                    @VB1_PPIS       FLOAT,
                                    @VB1_COFINS     VARCHAR(50),
                                    @VB1_PCOFINS    FLOAT,
                                    @VB1_CSLL       VARCHAR(50),
                                    @VB1_PCSLL      FLOAT,
                                    @VB1_REDPIS     FLOAT,
                                    @VB1_CODITE     VARCHAR(50),
                                    @VB1_DATASUB    VARCHAR(50),
                                    @VB1_REDCOF     FLOAT,
                                    @VB1_ESPECIE    FLOAT,
                                    @VB1_CLASSVE    VARCHAR(50),
                                    @VB1_ENVOBR     VARCHAR(50),
                                    @VB1_FLAGSUG    VARCHAR(50),
                                    @VB1_GRUDES     VARCHAR(50),
                                    @VB1_ITEMCC     VARCHAR(50),
                                    @VB1_MCUSTD     VARCHAR(50),
                                    @VB1_MTBF       FLOAT,
                                    @VB1_MTTR       FLOAT,
                                    @VB1_REDINSS    FLOAT,
                                    @VB1_REDIRRF    FLOAT,
                                    @VB1_QTDSER     FLOAT,
                                    @VB1_SERIE      VARCHAR(50),
                                    @VB1_FAIXAS     FLOAT,
                                    @VB1_NROPAG     FLOAT,
                                    @VB1_ISBN       VARCHAR(50),
                                    @VB1_TITORIG    VARCHAR(50),
                                    @VB1_LINGUA     VARCHAR(50),
                                    @VB1_EDICAO     VARCHAR(50),
                                    @VB1_OBSISBN    VARCHAR(50),
                                    @VB1_CLVL       VARCHAR(50),
                                    @VB1_ATIVO      VARCHAR(50),
                                    @VB1_PESBRU     FLOAT,
                                    @VB1_TIPCAR     VARCHAR(50),
                                    @VB1_VLR_ICM    FLOAT,
                                    @VB1_CORPRI     VARCHAR(50),
                                    @VB1_CORSEC     VARCHAR(50),
                                    @VB1_NICONE     VARCHAR(50),
                                    @VB1_ATRIB1     VARCHAR(50),
                                    @VB1_ATRIB2     VARCHAR(50),
                                    @VB1_ATRIB3     VARCHAR(50),
                                    @VB1_REGSEQ     VARCHAR(50),
                                    @VB1_VLRSELO    FLOAT,
                                    @VB1_CODNOR     VARCHAR(50),
                                    @VB1_UCALSTD    VARCHAR(50),
                                    @VB1_CPOTENC    VARCHAR(50),
                                    @VB1_POTENCI    FLOAT,
                                    @VB1_REQUIS     VARCHAR(50),
                                    @VB1_QTDACUM    FLOAT,
                                    @VB1_QTDINIC    FLOAT,
                                    @VB1_CNAE       VARCHAR(50),
                                    @VB1_FRETISS    VARCHAR(50),
                                    @VB1_CALCFET    VARCHAR(50),
                                    @VD_E_L_E_T_    VARCHAR(50),
                                    @VR_E_C_N_O_    FLOAT,
                                    @VR_E_C_D_E_L_  FLOAT,
                                    @VB1_MSBLQL     VARCHAR(50),
                                    @VB1_AGREGCU    VARCHAR(50),
                                    @VB1_QUADPRO    VARCHAR(50),
                                    @VB1_EMAX       FLOAT,
                                    @VB1_FRACPER    FLOAT,
                                    @VB1_INT_ICM    FLOAT,
                                    @VB1_SELO       VARCHAR(50),
                                    @VB1_LOTVEN     FLOAT,
                                    @VB1_OK         VARCHAR(50),
                                    @VB1_USAFEFO    VARCHAR(50),
                                    @VB1_UMOEC      FLOAT,
                                    @VB1_UVLRC      FLOAT,
                                    @VB1_GCCUSTO    VARCHAR(50),
                                    @VB1_CCCUSTO    VARCHAR(50),
                                    @VB1_CLASSE     VARCHAR(50),
                                    @VB1_PAUTFET    FLOAT,
                                    @VB1_RETOPER    VARCHAR(50),
                                    @VB1_CRDEST     FLOAT,
                                    @VB1_LITROS     FLOAT,
                                    @VB1_VAMARCM    VARCHAR(6), 
                                    @VB1_CLINF      VARCHAR(6),
                                    @VB1_CODLIN     VARCHAR(6),
                                    @VB1_VAEANUN    VARCHAR(15), 
                                    @VB1_VADUNCX    VARCHAR(15),
                                    --@VB1_P_BRT      FLOAT,
                                    @VB1_VAPLLAS    FLOAT,
                                    @VB1_VAPLCAM    FLOAT,
									@VB1_QTDEMB     FLOAT
                                    ) AS

---------------------------------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00000  05/02/2016  ALENCAR          GRAVAR TIPO, MARCA, FAMILIA E GRUPO DO PRODUTO
---  1.00001  15/03/2016  ALENCAR          GRAVAR O CAMPO DB_PROD_PERM_BONIF = 1 NA INCLUSAO
---  1.00002  16/03/2016  ALENCAR          NAO INTEGRAR PRODUTOS CFME GRUPO DE ESTOQUE DEFINIDOS PELA FINI (@VB1_GRUPO)
---  1.00003  28/03/2016  CELENIO          DB_PROD_CLASFIS RECEBE (@VB1_POSIPI) NCM DO PRODUTO
---  1.00004  20/06/2016  ALENCAR          GRAVAR DB_PROD_QTDE_EMB = 1
---                                               DB_PROD_FCEST    = 1
---                                               DB_PROD_FCEST1   = 1
---                                        GRAVAR O CAMPO SITUACAO CFME SB1020.B1_ZFORLIN
---  1.00005  29/06/2016  ALENCAR          PASSA A ATUALIZAR AS EMBALAGENS DOS PRODUTOS B1_CODBAR = DUN14 E B1_EAN13 = EAN13
---  1.00006  23/08/2016  ALENCAR          LIMITA A EMBALAGEM EM 14 POSICOES
---  1.00007                               UTILIZA RTRIM NA INTEGRACAO DA MARCA - DB_PROD_MARCA = RTRIM(@VB1_XGRPDEV)
---  1.00008  24/08/2016  ALENCAR          SOMENTE INTEGRA PRODUTOS QUE ESTIEREM COM O CAMPO VENDAVEL = S
---                                        DEFINE A SITUACAO DO PRODUTO AVALIANDO OS CAMPOS B1_ZFORLIN E B1_MSBLQL
---  1.00009  28/09/2016  ALENCAR          QUANDO O CAMPO @VB1_GRUPO FOR NULO NAO DEVE INTEGRAR O PRODUTO
---  1.00010  11/10/2016  ALENCAR          CONVERSAO NOVA ALIANCA
---  1.00011  31/10/2016  ALENCAR          GRAVAR FCEST1 = B1_LITROS
---                                        HIERARQUIA PRODUTOS: TIPO    = MARCA (B1_VAMARCM)
---                                                             MARCA   = LINHAS DE ENFASE (B1_CLINF)
---                                                             FAMILIA = GRUPO (B1_GRUPO)
---                                                             GRUPO   = LINHA COMERCIAL (B1_CODLIN)
---  1.00012  21/11/2016  ALENCAR          GRAVAR DB_PROD_COD_BARRA = B1_VAEANUN (EAN13)
---                                        ATRIBUTO 100 = B1_VADUNCX (DUN14)
---  1.00013  14/02/2017  ALENCAR          GRAVAR O ATRIBUTO 200 - RAPEL COM VALOR 1 PARA TODOS OS PRODUTOS
---  1.00014  13/03/2017  ALENCAR          GRAVAR O PESO BRUTO COM O VALOR DO B1_P_BRT
---  1.00015  04/07/2017  SERGIO LUCCHINI  GRAVAR O CAMPO DB_PROD_QTDEMBCOMP. CHAMADO 77104
---  1.00016  28/04/2020  ANDRE			   GRAVAR O CAMPO DB_PROD_FCEST2 COM B1_QTDEMB.
---  1.00017  10/05/2020  CLAUDIA          ALTERADO O PESO BRUTO PARA  B1_PESBRU. GLPI: 11822
---------------------------------------------------------------------------------------------------------------------------------

BEGIN

DECLARE @VOBJETO           VARCHAR(15) SELECT @VOBJETO = 'MERCP_SB1010 ';
DECLARE @VDATA             DATETIME;
DECLARE @VCOD_ERRO         VARCHAR(1000);
DECLARE @VERRO             VARCHAR(255);
DECLARE @VDB_PROD_TGRADE   FLOAT;
DECLARE @VDB_PROD_SEXADO   FLOAT;
DECLARE @VINSERE           FLOAT SELECT @VINSERE = 0;
DECLARE @VBM_VENDE         VARCHAR(1);
DECLARE @VDB_PROD_SITUACAO VARCHAR(1);

BEGIN TRY

PRINT '@VB1_COD ' + @VB1_COD

SET @VDB_PROD_SEXADO = 0;
SET @VDB_PROD_TGRADE = 0;

IF @VD_E_L_E_T_ = ' '
BEGIN

   -- DEFINE A SITUACAO DO PRODUTO
   IF @VB1_MSBLQL = '1'  -- PRODUTO BLOQUEADO
      SET @VDB_PROD_SITUACAO = 'I'
   ELSE
      SET @VDB_PROD_SITUACAO = 'A'

   SELECT @VINSERE = 1
     FROM DB_PRODUTO
    WHERE DB_PROD_CODIGO = RTRIM(@VB1_COD);
   SET @VCOD_ERRO = @@ERROR;
   IF @VCOD_ERRO > 0
   BEGIN
      SET @VINSERE = 0;
   END

   IF @VINSERE = 0
   BEGIN

      INSERT INTO DB_PRODUTO
        (
         DB_PROD_CODIGO,      -- 1
         DB_PROD_DESCRICAO,
         DB_PROD_UNID_MEDID,
         DB_PROD_GRUPO,
         DB_PROD_IPI,         -- 5
         DB_PROD_QTDE_EMB,
         DB_PROD_FAMILIA,
         DB_PROD_SITUACAO,
         DB_PROD_PESO_BRU,
         DB_PROD_PESO_LIQ,    -- 10
         DB_PROD_VOLUME,
         DB_PROD_CLASSIF,
         DB_PROD_VINCULO,
         DB_PROD_VINCFATOR,
         DB_PROD_TPVENDA,     -- 15
         DB_PROD_COD_BARRA,
         DB_PROD_FCEST,
         DB_PROD_FCEST1,
         DB_PROD_CLASFIS,
         DB_PROD_MARCA,       -- 20
         DB_PROD_TPPROD,
         DB_PROD_TRIB_ICM,
         DB_PROD_ULT_ALTER,
         DB_PROD_CESTOQUE,
         DB_PROD_COMPL,       -- 25
         DB_PROD_ALT_CORP,
         --DB_PROD_REFER,
         DB_PROD_TGRADE,
         --DB_PROD_PRECO,
         --DB_PROD_PRIOR_BX,  -- 30
         DB_PROD_SEXADO,
         --DB_PROD_FCEST1,
         DB_PROD_PERM_BONIF,
         DB_PROD_QTDEMBCOMP,
		 DB_PROD_CUSTO,		  -- 35
		 DB_PROD_FCEST2
        )
      VALUES
        (
         RTRIM(@VB1_COD),                       -- 1
         SUBSTRING(RTRIM(@VB1_DESC),1,50),
         SUBSTRING(RTRIM(@VB1_UM),1,2),
         SUBSTRING(RTRIM(@VB1_CODLIN), 1, 8),
         @VB1_IPI,                              -- 5
         1,
         SUBSTRING(RTRIM(@VB1_GRUPO), 1, 8),
         @VDB_PROD_SITUACAO,
         --@VB1_P_BRT,
		 @VB1_PESBRU,
         @VB1_PESO,                             -- 10
         0,
         '',
         RTRIM(@VB1_COD),
         1,
         0,                                     -- 15
         SUBSTRING(RTRIM(@VB1_VAEANUN),1,14),
         1,
         @VB1_LITROS,
         RTRIM(@VB1_POSIPI),
         SUBSTRING(RTRIM(@VB1_CLINF), 1, 4),    -- 20
         SUBSTRING(RTRIM(@VB1_VAMARCM), 1, 4),
         0,
         @VB1_UREV,
         0,
         '',                                    -- 25
         GETDATE(),
         --RTRIM(@VB1_CODMERC),
         @VDB_PROD_TGRADE,
         --@VB1_PLSCLG,
         --@VB1_PRIORBX,                        -- 30
         @VDB_PROD_SEXADO,
         --@VB1_X_QTDMA,
         1,
         @VB1_VAPLLAS * @VB1_VAPLCAM,
		 @VB1_CUSTD,							-- 35
		 @VB1_QTDEMB
        );
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VERRO = '1 - ERRO INSERT DB_PRODUTO:' + @VB1_COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
      END

   END
   ELSE
   BEGIN

      UPDATE DB_PRODUTO
         SET DB_PROD_DESCRICAO  = RTRIM(@VB1_DESC),
             DB_PROD_UNID_MEDID = RTRIM(@VB1_UM),
             DB_PROD_FCEST      = 1,
             DB_PROD_FCEST1     = @VB1_LITROS,
             DB_PROD_QTDE_EMB   = 1,
             DB_PROD_IPI        = @VB1_IPI,
             DB_PROD_TPPROD     = SUBSTRING(RTRIM(@VB1_VAMARCM), 1, 4),
             DB_PROD_MARCA      = SUBSTRING(RTRIM(@VB1_CLINF), 1, 4),
             DB_PROD_FAMILIA    = SUBSTRING(RTRIM(@VB1_GRUPO), 1, 8),
             DB_PROD_GRUPO      = SUBSTRING(RTRIM(@VB1_CODLIN), 1, 8),
             DB_PROD_SITUACAO   = @VDB_PROD_SITUACAO,
             --DB_PROD_PESO_BRU   = @VB1_P_BRT,
			 DB_PROD_PESO_BRU   = @VB1_PESBRU,
             DB_PROD_PESO_LIQ   = @VB1_PESO,
             DB_PROD_COD_BARRA  = SUBSTRING(RTRIM(@VB1_VAEANUN),1,14),
             DB_PROD_CLASFIS    = RTRIM(@VB1_POSIPI),
             DB_PROD_ULT_ALTER  = @VB1_UREV,
             DB_PROD_ALT_CORP   = GETDATE(),
             DB_PROD_TGRADE     = @VDB_PROD_TGRADE,
             --DB_PROD_PRECO      = @VB1_PLSCLG,
             --DB_PROD_PRIOR_BX   = @VB1_PRIORBX,
             DB_PROD_SEXADO     = @VDB_PROD_SEXADO,
             DB_PROD_TPVENDA    = 0,
             DB_PROD_QTDEMBCOMP = @VB1_VAPLLAS * @VB1_VAPLCAM,
			 DB_PROD_CUSTO		= @VB1_CUSTD,
			 DB_PROD_FCEST2     = @VB1_QTDEMB
       WHERE DB_PROD_CODIGO = RTRIM(@VB1_COD);
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VERRO = '1 - ERRO UPDATE DB_PRODUTO:' + @VB1_COD + ' - ERRO BANCO: ' + @VCOD_ERRO;
      END  

   END

   -- ATUALIZA O ATRIBUTO 100 - DUN14 DA CAIXA (@VB1_VADUNCX)
   MERGE INTO DB_PRODUTO_ATRIB AS TARGET
   USING (SELECT RTRIM(@VB1_COD) B1_COD,
                 100             ATRIBUTO,
                 SUBSTRING(RTRIM(@VB1_VADUNCX), 1, 14) DUN_CAIXA
         ) AS SOURCE
      ON (DB_PRODA_CODIGO = B1_COD AND
          DB_PRODA_ATRIB  = ATRIBUTO)
   WHEN MATCHED THEN
        UPDATE SET DB_PRODA_VALOR      = DUN_CAIXA,
                   DB_PRODA_DATA_ALTER = GETDATE()
   WHEN NOT MATCHED THEN
        INSERT
          (
           DB_PRODA_CODIGO,
           DB_PRODA_ATRIB,
           DB_PRODA_VALOR,
           DB_PRODA_DATA_ALTER
          )
        VALUES
          (
           B1_COD,
           ATRIBUTO,
           DUN_CAIXA,
           GETDATE()
          );

   -- ATUALIZA O ATRIBUTO 200 - RAPEL COM VALOR 1
   MERGE INTO DB_PRODUTO_ATRIB AS TARGET
   USING (SELECT RTRIM(@VB1_COD) B1_COD,
                 200 ATRIBUTO,
                 1   DUN_CAIXA
         ) AS SOURCE
      ON (DB_PRODA_CODIGO = B1_COD AND
          DB_PRODA_ATRIB  = ATRIBUTO)
   WHEN MATCHED THEN 
        UPDATE SET DB_PRODA_VALOR      = DUN_CAIXA,
                   DB_PRODA_DATA_ALTER = GETDATE()
   WHEN NOT MATCHED THEN
        INSERT
          (
           DB_PRODA_CODIGO,
           DB_PRODA_ATRIB,
           DB_PRODA_VALOR,
           DB_PRODA_DATA_ALTER
          )
        VALUES
          (
           B1_COD,
           ATRIBUTO,
           DUN_CAIXA,
           GETDATE()
          );

END
ELSE
BEGIN

   DELETE FROM DB_PRODUTO WHERE DB_PROD_CODIGO = RTRIM(@VB1_COD);

END

END TRY

BEGIN CATCH
  SELECT @VERRO = CAST(ERROR_NUMBER() AS VARCHAR) + ERROR_MESSAGE()

  PRINT @VERRO

  INSERT INTO DBS_ERROS_TRIGGERS
    (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
  VALUES
    (@VERRO, GETDATE(), @VOBJETO);
END CATCH

END
GO


