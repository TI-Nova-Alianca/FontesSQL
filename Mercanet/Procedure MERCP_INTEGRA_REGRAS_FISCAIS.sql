SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_INTEGRA_REGRAS_FISCAIS] AS

BEGIN

-- Cria sinonimos para os caminhos/nomes das tabelas, de modo que possa ser usada a mesma
-- rotina de integracao, mas acessando o database correto cfe. cada ambiente.
EXEC MERCP_CRIA_SINONIMOS_TABELAS;

DECLARE @VOBJETO          VARCHAR(30) SELECT @VOBJETO = 'MERCP_INTEGRA_REGRAS_FISCAIS';
DECLARE @VERRO            VARCHAR(1000);
DECLARE @VCOD_ERRO        VARCHAR(1000);
DECLARE @VINSERE          NUMERIC SELECT @VINSERE = 0;
DECLARE @VDB_MPRI_CODIGO  INT;
DECLARE @VDB_RIEI_CODIGO  INT;
DECLARE @VDB_MPRI_BASERED FLOAT;
DECLARE @VSEQ_ST          INT;

DECLARE @VB1_POSIPI       VARCHAR(1000);
DECLARE @VF7_MARGEM       VARCHAR(1000);
DECLARE @VF7_EST          VARCHAR(1000);
DECLARE @VF7_TIPOCLI      VARCHAR(1000);
DECLARE @VF7_GRTRIB       VARCHAR(1000);
DECLARE @VF7_GRPCLI       VARCHAR(1000);
DECLARE @VF7_ALIQINT	  VARCHAR(1000);

DECLARE @VCODCLI        VARCHAR(6);
DECLARE @VCODPRO        VARCHAR(16);
DECLARE @VCUSTOPRO      FLOAT;
DECLARE @VMARGEM        FLOAT;
DECLARE @VRAPEL         FLOAT;
DECLARE @VPFRETE        FLOAT;
DECLARE @VPERTOT        FLOAT;
DECLARE @VMARGEM_BLQ    FLOAT;
DECLARE	@VNOMECLI		VARCHAR(50);
DECLARE	@VPRODUTO		VARCHAR(15);
DECLARE @VFATOR_INI     INT;
DECLARE @VFATOR_FIM     INT;
DECLARE @VCODIGO        FLOAT;


-------------------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00000  28/08/2019  SERGIO LUCCHINI  DESENVOLVIMENTO. CHAMADO 87991
---  1.00001  19/09/2019  SERGIO LUCCHINI  ALTERADO O SELECT DE BUSCA DAS REGRAS CONFORME PASSADO PELO CLIENTE
---  1.00002  18/12/2019  ANDRE ALVES      CRIADO PASSO PARA ATUALIZAR TABELA DE EXCECOES DE IMPOSTOS (ICMS)
---  1.00003  19/02/2020  ANDRE ALVES      ADICIONADO TRATAMENTO PARA FATORES DE LUCRATIVIDADE
---  1.00003  23/03/2022  ROBERT KOCH      VERSAO INICIAL USANDO SONONIMOS PARA NOMES DE TABELAS
-------------------------------------------------------------------------------------------------------------------

--BEGIN TRY

-----------------------
   ---- Passo 1 - Cria regras para tela de Substituição Tributária.
-----------------------

SET @VDB_MPRI_CODIGO = 100;

MERGE INTO DB_MRG_PRESUMIDA A
USING (SELECT @VDB_MPRI_CODIGO                 CODIGO,
              'SUBSTITUIÇÃO TRIBUTARIA PADRÃO' DESCR,
              '2016-01-01'                     DATAINI,
              '2099-12-31'                     DATAFIN,
              0                                SITUACAO,
			  1                                UTILBASERED,
              GETDATE()                        DATAALTER) B
   ON (A.DB_MPR_CODIGO = B.CODIGO)
 WHEN MATCHED THEN
      UPDATE SET DB_MPR_SITUACAO    = 0,
                 DB_MPR_UTILBASERED = 1,
                 DB_MPR_DATAALTER   = DATAALTER
 WHEN NOT MATCHED THEN
      INSERT (DB_MPR_CODIGO, DB_MPR_DESCR, DB_MPR_DATAINI, DB_MPR_DATAFIN, DB_MPR_SITUACAO, DB_MPR_UTILBASERED, DB_MPR_DATAALTER)
      VALUES (CODIGO, DESCR, DATAINI, DATAFIN, SITUACAO, 1, DATAALTER);

DELETE FROM DB_MRG_PRES_ITEM WHERE DB_MPRI_CODIGO = @VDB_MPRI_CODIGO;

DECLARE C_REGRAS CURSOR
FOR SELECT DISTINCT SB1.B1_POSIPI, SF7.F7_MARGEM, SF7.F7_EST, SF7.F7_TIPOCLI, SF7.F7_GRTRIB, SF7.F7_GRPCLI
      FROM protheus.dbo.SF7010 AS SF7,
           protheus.dbo.SB1010 AS SB1
     WHERE SB1.D_E_L_E_T_ = ''
       AND SF7.D_E_L_E_T_ = ''
       AND SB1.B1_FILIAL  = ''
       AND SF7.F7_FILIAL  = '01'
       AND SB1.B1_TIPO    = 'PA'
       AND SB1.B1_GRTRIB  = SF7.F7_GRTRIB
       AND SF7.F7_MARGEM  > 0
      OPEN C_REGRAS
     FETCH NEXT FROM C_REGRAS
      INTO @VB1_POSIPI, @VF7_MARGEM, @VF7_EST, @VF7_TIPOCLI, @VF7_GRTRIB, @VF7_GRPCLI
     WHILE @@FETCH_STATUS = 0
    BEGIN

SET @VDB_MPRI_BASERED = 0;
IF @VF7_EST = 'RS' AND @VB1_POSIPI = '22042100'
BEGIN

   SET @VDB_MPRI_BASERED = 100;

END
ELSE IF @VF7_EST = 'RS' AND @VB1_POSIPI IN ('22042211','22042919','22042911','22043000','22041090')
BEGIN

   SET @VDB_MPRI_BASERED = 111.1111;

END

SET @VSEQ_ST = ISNULL(@VSEQ_ST, 0) + 1;

INSERT INTO DB_MRG_PRES_ITEM
  (
   DB_MPRI_CODIGO,          -- 01
   DB_MPRI_SEQ,             -- 02
   DB_MPRI_DTVALINI,        -- 03
   DB_MPRI_DTVALFIN,        -- 04
   DB_MPRI_EMPRESA,         -- 05
   DB_MPRI_UF_ORIG,         -- 06
   DB_MPRI_UF_DEST,         -- 07
   DB_MPRI_BASERED,         -- 08
   DB_MPRI_PESO,            -- 09
   DB_MPRI_CALC_SUBS,       -- 10
   DB_MPRI_MRGPRESUM,       -- 11
   DB_MPRI_TPCALC,          -- 12
   DB_MPRI_APLIC,           -- 13
   DB_MPRI_DESCTO,          -- 14
   DB_MPRI_DCTOPMC,         -- 15
   DB_MPRI_GRPITCONT,       -- 16
   DB_MPRI_LST_PROD,        -- 17
   DB_MPRI_LST_TPPROD,      -- 18
   DB_MPRI_LST_MARCA,       -- 19
   DB_MPRI_LST_FAM,         -- 20
   DB_MPRI_LST_GRUPO,       -- 21
   DB_MPRI_LST_CLAFIS,      -- 22
   DB_MPRI_LST_OPVDA,       -- 23
   DB_MPRI_PRECOMAX,        -- 24
   DB_MPRI_LST_CLIENT,      -- 25
   DB_MPRI_LST_CLCOM,       -- 26
   DB_MPRI_LST_RAMATV,      -- 27
   DB_MPRI_OPTANTESIMPLES,  -- 28
   DB_MPRI_DESCONTO_FISCAL  -- 29
  )
VALUES
  (
   @VDB_MPRI_CODIGO,           -- 01
   @VSEQ_ST,                   -- 02
   '2016-01-01',               -- 03
   '2099-12-31',               -- 04
   '',                         -- 05
   'RS',                       -- 06
   @VF7_EST,                   -- 07
   @VDB_MPRI_BASERED,          -- 08
   643,                        -- 09
   'S',                        -- 10
   @VF7_MARGEM,                -- 11
   0,                          -- 12
   0,                          -- 13
   0,                          -- 14
   0,                          -- 15
   '',                         -- 16
   '',                         -- 17
   '',                         -- 18
   '',                         -- 19
   '',                         -- 20
   '',                         -- 21
   @VB1_POSIPI,                -- 22
   '',                         -- 23
   0,                          -- 24
   '',                         -- 25
   '',                         -- 26
   '',                         -- 27
   CAST(@VF7_GRPCLI AS SMALLINT),  -- 28
   0                           -- 29
  );
 
     FETCH NEXT FROM C_REGRAS
      INTO @VB1_POSIPI, @VF7_MARGEM, @VF7_EST, @VF7_TIPOCLI, @VF7_GRTRIB, @VF7_GRPCLI
    END
     CLOSE C_REGRAS
DEALLOCATE C_REGRAS

-----------------------
   ---- Passo 2 - Cria regras para tela de Exceção de Impostos (ICMS).
-----------------------
/* Desabilitado ateh aprendermos melhor como mapear do Protheus para o Mercanet - GLPI 10064

SET @VDB_RIEI_CODIGO = 100;

MERGE INTO DB_REGICMS_EXC A
USING (SELECT @VDB_RIEI_CODIGO                 CODIGO,
              'REGRA EXCEÇÃO ICMS'			   DESCR,
              '2016-01-01'                     DATAINI,
              '2099-12-31'                     DATAFIN,
              0                                SITUACAO,
			  1                                TIPOIMP,
              GETDATE()                        DATAALTER) B
   ON (A.DB_RIE_CODIGO = B.CODIGO)
 WHEN MATCHED THEN
      UPDATE SET DB_RIE_SITUACAO    = 0,
                 Db_Rie_TipoImp     = 0,
                 DB_RIE_DATAALTER   = DATAALTER
 WHEN NOT MATCHED THEN
      INSERT (DB_RIE_CODIGO, DB_RIE_DESCR, DB_RIE_DATAINI, DB_RIE_DATAFIN, DB_RIE_SITUACAO, Db_Rie_TipoImp, DB_RIE_DATAALTER)
      VALUES (CODIGO, DESCR, DATAINI, DATAFIN, SITUACAO, 0, DATAALTER);

DELETE FROM DB_REGICMS_EXC_IT WHERE DB_RIEI_CODIGO = @VDB_RIEI_CODIGO;

DECLARE C_REGRAS_ICMS CURSOR
--FOR SELECT DISTINCT SB1.B1_POSIPI, SF7.F7_EST, SF7.F7_ALIQINT
FOR SELECT DISTINCT SB1.B1_POSIPI, SF7.F7_EST, SF7.F7_ALIQINT + CASE WHEN SF7.F7_EST = 'RJ' THEN SB1.B1_FECP ELSE 0 END AS F7_ALIQINT  -- GLPI 10064
      FROM protheus.dbo.SF7010 AS SF7,
           protheus.dbo.SB1010 AS SB1
     WHERE SB1.D_E_L_E_T_ = ''
       AND SF7.D_E_L_E_T_ = ''
       AND SB1.B1_FILIAL  = ''
       AND SF7.F7_FILIAL  = '01'
       AND SB1.B1_TIPO    = 'PA'
       AND SB1.B1_GRTRIB  = SF7.F7_GRTRIB
       AND SF7.F7_MARGEM  > 0
      OPEN C_REGRAS_ICMS
     FETCH NEXT FROM C_REGRAS_ICMS
      INTO @VB1_POSIPI, @VF7_EST, @VF7_ALIQINT
     WHILE @@FETCH_STATUS = 0
    BEGIN

SET @VSEQ_ST = ISNULL(@VSEQ_ST, 0) + 1;

INSERT INTO DB_REGICMS_EXC_IT
  (
   DB_RIEI_CODIGO,          -- 01
   DB_RIEI_SEQ,             -- 02
   DB_RIEI_DTVALINI,        -- 03
   DB_RIEI_DTVALFIN,        -- 04
   DB_RIEI_EMPRESA,         -- 05
   DB_RIEI_UF_ORIG,         -- 06
   DB_RIEI_UF_DEST,         -- 07
   DB_RIEI_PRODUTO,         -- 08
   DB_RIEI_TPPROD,          -- 09
   DB_RIEI_MARCA,           -- 10
   DB_RIEI_FAMILIA,         -- 11
   DB_RIEI_GRUPO,           -- 12
   DB_RIEI_CLIENTE,         -- 13
   DB_RIEI_RAMO,            -- 14
   DB_RIEI_OPERACAO,        -- 15
   DB_RIEI_TPPESSOA,        -- 16
   DB_RIEI_SUFRAMA,         -- 17
   DB_RIEI_CLASSPRD,        -- 18
   DB_RIEI_TPVDAPRD,        -- 19
   DB_RIEI_FATUR,           -- 20
   DB_RIEI_CLASSFIS,        -- 21
   DB_RIEI_CIDADE,          -- 22
   DB_RIEI_CONTRIB,         -- 23
   DB_RIEI_LPRECO,          -- 24
   DB_RIEI_TPPED,           -- 25
   DB_RIEI_CLICCOM,         -- 26
   DB_RIEI_TXICMS,          -- 27
   DB_RIEI_BASERED,         -- 28
   DB_RIEI_PESO,            -- 29
   Db_RieI_ClassFCli,       -- 30 
   Db_RieI_CFOP,            -- 31
   Db_RieI_IcmsDscto        -- 32
  )
VALUES
  (
   @VDB_RIEI_CODIGO,           -- 01
   @VSEQ_ST,                   -- 02
   '2016-01-01',               -- 03
   '2099-12-31',               -- 04
   '',                         -- 05
   @VF7_EST,                   -- 06
   @VF7_EST,                   -- 07
   '',						   -- 08
   '',                         -- 09
   '',                         -- 10
   '',						   -- 11
   '',                         -- 12
   0,                          -- 13
   '',                         -- 14
   '',                         -- 15
   '',                         -- 16
   -1,                         -- 17
   '',                         -- 18
   -1,                         -- 19
   -1,                         -- 20
   @VB1_POSIPI,                -- 21
   '',			               -- 22
   'A',                        -- 23
   '',                         -- 24
   '',                         -- 25
   '',                         -- 26
   @VF7_ALIQINT,               -- 27
   '',						   -- 28
   644,                        -- 29
   '',						   -- 30
   '',						   -- 31
   ''						   -- 32
  );
 
     FETCH NEXT FROM C_REGRAS_ICMS
      INTO @VB1_POSIPI, @VF7_EST, @VF7_ALIQINT
    END
     CLOSE C_REGRAS_ICMS
DEALLOCATE C_REGRAS_ICMS

EXECUTE MERCP_INSERE_HASH @VDB_MPRI_CODIGO, 'ST';
--EXECUTE MERCP_INSERE_HASH @VDB_RIEI_CODIGO, 'ST'; - ANALISAR

IF @VERRO IS NOT NULL
BEGIN

   INSERT INTO DBS_ERROS_TRIGGERS
     (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
   VALUES
     (@VERRO, GETDATE(), @VOBJETO);

END
*/
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

--END TRY

--BEGIN CATCH

--SELECT @VERRO = CAST(ERROR_NUMBER() AS VARCHAR) + ERROR_MESSAGE();

--INSERT INTO DBS_ERROS_TRIGGERS
--  (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
--VALUES
--  (@VERRO, GETDATE(), @VOBJETO);

--END CATCH

END
GO
