SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_HASH_COND_VENDA] (@PEVENTO              FLOAT,          -- 01
                                            @P_CODIGO             VARCHAR(20),    -- 02
                                            @P_SEQ                FLOAT,          -- 03
                                            @P_DTVALINI           DATE,           -- 04
                                            @P_DTVALFIN           DATE,           -- 05
                                            @P_EMPRESA            VARCHAR(1024),  -- 06
                                            @P_UF_ORIG            VARCHAR(512),   -- 07
                                            @P_UF_DEST            VARCHAR(512),   -- 08
                                            @P_PRODUTO            VARCHAR(512),   -- 09
                                            @P_TPPROD             VARCHAR(512),   -- 10
                                            @P_MARCA              VARCHAR(512),   -- 11
                                            @P_FAMILIA            VARCHAR(512),   -- 12
                                            @P_GRUPO              VARCHAR(512),   -- 13
                                            @P_CLIENTE            VARCHAR(512),   -- 14
                                            @P_RAMO               VARCHAR(512),   -- 15
                                            @P_OPERACAO           VARCHAR(512),   -- 16
                                            @P_TPPESSOA           VARCHAR(512),   -- 17
                                            @P_SUFRAMA            FLOAT,          -- 18
                                            @P_CLASSPRD           VARCHAR(512),   -- 19
                                            @P_TPVDAPRD           FLOAT,          -- 20
                                            @P_FATUR              FLOAT,          -- 21
                                            @P_CLASSFIS           VARCHAR(512),   -- 22
                                            @P_CLASSFCLI          VARCHAR(512),   -- 23
                                            @P_CIDADE             VARCHAR(512),   -- 24
                                            @P_CONTRIB            VARCHAR(512),   -- 25
                                            @P_LPRECO             VARCHAR(512),   -- 26
                                            @P_TPPED              VARCHAR(512),   -- 27
                                            @P_CLICCOM            VARCHAR(512),   -- 28
                                            @P_TXICMS             FLOAT,          -- 19
                                            @P_BASERED            FLOAT,          -- 30
                                            @P_PESO               FLOAT,          -- 31
                                            @PTIPO_FRETE          VARCHAR(50),    -- 32
                                            -- COND VENDA
                                            @PDB_TBCV_REPRES      VARCHAR(512),   -- 33
                                            @PDB_TBCV_RAMOII      VARCHAR(512),   -- 34
                                            @PDB_TBCV_CPGTO       VARCHAR(512),   -- 35
                                            @PDB_TBCV_AREAATU     VARCHAR(512),   -- 36
                                            @PDB_TBCV_OPERLOG     VARCHAR(512),   -- 37
                                            @PDB_TBCVP_PRZMED     FLOAT,          -- 38
                                            @PDB_TBCVP_QTDEMAX    FLOAT,          -- 39
                                            @PDB_TBCVP_QTDEMIN    FLOAT,          -- 40
                                            @PDB_TBCVP_CVI        FLOAT,          -- 41
                                            @PDB_TBCVP_COMIS      FLOAT,          -- 42
                                            @PDB_TBCVP_PEDMIN     FLOAT,          -- 43
                                            @PDB_TBCVP_DESCTO     FLOAT,          -- 44
                                            @PDB_TBCV_APLIC_ATU   FLOAT,          -- 45
                                            @PDB_TBCV_GRUPOEMP    FLOAT,          -- 46
                                            @PDB_TBCV_TPAVAL      FLOAT,          -- 47
                                            @PPDB_TBCV_APLIC_OL   FLOAT,          -- 48
                                            @P_LABORATOR          VARCHAR(512),   -- 49
                                            @P_REGCOM             VARCHAR(512),   -- 50
                                            @P_ID                 INT,            -- 51
                                            @PDB_TBCVP_ACRESC     FLOAT,          -- 52
                                            @PDB_TBCV_APLIC_OL    FLOAT,          -- 53
                                            @PDB_TBCV_CLICONTR    FLOAT,          -- 54
                                            @PDB_TBCV_IE          FLOAT,          -- 55
                                            @PDB_TBCV_AVALCLIVD   FLOAT,          -- 56
                                            @PDB_TBCV_SUFRAMA     INT,            -- 57
                                            @PDB_TBCV_APRESCLI    FLOAT,          -- 58
                                            @PDB_TBCVP_DIAINI     INT,            -- 59
                                            @PDB_TBCVP_DIAFIN     INT,            -- 60
                                            @P_CLIREDE            VARCHAR(25),    -- 61
                                            @PDB_TBCV_TIPO        INT,            -- 62
                                            @PDB_TBCV_IND_DESCTO  FLOAT,          -- 63
                                            @PDB_TBCV_DTPEDVAL    FLOAT,          -- 64
                                            @PDB_TBCV_APL_OLCLI   FLOAT,          -- 65
                                            @PDB_TBCV_FORCAVENDAS VARCHAR(255),   -- 66
                                            @PDB_TBCV_FORMAPRECO  FLOAT           -- 67
                                           ) AS

DECLARE @VOBJETO               VARCHAR(200) = 'MERCP_HASH_COND_VENDA';
DECLARE @VERRO                 VARCHAR(1000);
DECLARE @VDATA                 DATE = GETDATE();
DECLARE @VLISTA_RESTRICAO      NVARCHAR(2000) = '';
DECLARE @VSQL                  NVARCHAR(4000)='';
DECLARE @VHASH                 VARCHAR(800)= '';
DECLARE @VCODIGO_ATRIBUTO      VARCHAR(25);
DECLARE @VINSERE               FLOAT = 1;
DECLARE @PPF01_SEQ             FLOAT;
DECLARE @PPV04_CONTROLE        INT;
DECLARE @V_COUNT               INT;
DECLARE @VCONTADOR             INT;
DECLARE @VVALOR_ATRIBUTO       NVARCHAR(255);
DECLARE @V_ID                  INT;
DECLARE @V_FROM                NVARCHAR(4000) = '';
DECLARE @V_WHERE               NVARCHAR(4000) = '';
DECLARE @V_RESTRICAO_SELECT    NVARCHAR(4000) = '';
DECLARE @V_INSERT_MPV06        NVARCHAR(4000);
DECLARE @V_SEQ                 INT;
DECLARE @V_DELETE              VARCHAR(5000);
DECLARE @V_ATRIBUTO            NVARCHAR(1000) = '';
DECLARE @V_AUX                 INT;
DECLARE @VDB_TBCVA_ATRIB       NVARCHAR(100) ='';
DECLARE @VDB_TBCVA_VALOR       NVARCHAR(100) = '';
DECLARE @VQTDE_LST_ATRIBUTO    INT;
DECLARE @V_QUANTIDADE          INT;
DECLARE @V_VALOR_PARTE         NVARCHAR(255) = '';
DECLARE @V_EXISTE              INT;
DECLARE @V_PRIMEIRA            BIT = 1;
DECLARE @V_QTDE_LISTA_ANTERIOR INT;
DECLARE @V_AUX2                INT;
DECLARE @VDB_TBCV_TIPO         VARCHAR(1);
DECLARE @VPV06_APLICBRUTO      INT;
DECLARE @VPV06_PEDMIN          FLOAT = NULL;
DECLARE @VPV06_VALMIN          FLOAT = NULL;
DECLARE @V_AT02_ORIGEM         NUMERIC;

---------------------------------------------------------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR          ALTERACAO
---  1.00001  11/02/2012  ALENCAR/TIAGO  DESENVOLVIMENTO - ROTINA QUE GERA HASH PARA A TABELA DB_MRG_PRES_ITEM - CADASTRO DE SUBSTITUICAO TRIBUTARIA
---  1.00002  18/09/2013  TIAGO          AVALIA CAMPO TIPO DE AVALIACAO PARA GRAVAR OS CAMPOS PV06_PEDMIN, PV06_VALMIN
---  1.00003  26/12/2013  ALENCAR        GRAVA O HASH DO ATRIBUTO COM ATP (PRODUTO) OU ATC (CLIENTE)
---  1.00004  26/02/2016  TIAGO          INCLUIDO CAMPO FORCAVENDA E FORMAPRECO
---------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN

BEGIN TRY

SET @V_ID = @P_ID;
SET @VSQL      = 'SELECT TOP 1 ISNULL(PV04_CONTROLE, 0) AS PV04_CONTROLE FROM MPV04 WHERE 1=1 ';
SET @VCONTADOR = 1;

IF ISNULL(@P_UF_DEST, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'ESTADO,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''ESTADO'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH           = @VHASH + @P_UF_DEST + '#';

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' ESTADO.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + ' TEMP_MPV06_ESTADO ESTADO,';
   SET @V_WHERE            = @V_WHERE + ' ESTADO.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_RAMO, '') <> '' 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'RAMO,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''RAMO'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_RAMO + '#';
  
   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + 'RAMO.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_RAMO RAMO ,';
   SET @V_WHERE            = @V_WHERE + ' RAMO.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_CLIENTE, '') <> ''  AND @P_CLIREDE =  'CLIENTE'
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + @P_CLIREDE + ',';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''' + @P_CLIREDE + ''')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_CLIENTE + '#';
  
   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' CLIENTE.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + ' TEMP_MPV06_CLIENTE CLIENTE,';
   SET @V_WHERE            = @V_WHERE + ' CLIENTE.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_LPRECO, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'LPRECO,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''LPRECO'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_LPRECO + '#';
  
   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' LPRECO.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + ' TEMP_MPV06_LPRECO LPRECO, ';
   SET @V_WHERE            = @V_WHERE + ' LPRECO.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@PDB_TBCV_REPRES, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'REPRES,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''REPRES'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @PDB_TBCV_REPRES + '#';

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' REPRES.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + ' TEMP_MPV06_REPRES REPRES, ';
   SET @V_WHERE            = @V_WHERE + ' REPRES.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_CLICCOM, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASCOMCLI,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''CLASCOMCLI'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   -- SET @VHASH            = @VHASH + @P_CLICCOM + '#';

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + 'CLASCOMCLI.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_CLACCLI CLASCOMCLI,';
   SET @V_WHERE            = @V_WHERE + ' CLASCOMCLI.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_EMPRESA, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'EMPRESA,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''EMPRESA'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_EMPRESA + '#';

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' EMPRESA.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_EMPRESA EMPRESA,';
   SET @V_WHERE            = @V_WHERE + ' EMPRESA.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_REGCOM, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'REGIAOCOM,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''REGIAOCOM'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_REGCOM + '#';
  
   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' REGIAOCOM.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_REGCOM REGIAOCOM,';
   SET @V_WHERE            = @V_WHERE + ' REGIAOCOM.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@PDB_TBCV_RAMOII, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'RAMOII,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''RAMOII'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @PDB_TBCV_RAMOII + '#';
  
   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' RAMOII.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_RAMOII RAMOII,';
   SET @V_WHERE            = @V_WHERE + ' RAMOII.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_CIDADE, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CIDADE,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''CIDADE'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_CIDADE + '#';
  
   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' CIDADE.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_CIDADE CIDADE,';
   SET @V_WHERE            = @V_WHERE + ' CIDADE.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_OPERACAO, '') <> '' 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'OPERACAO,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''OPERACAO'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_OPERACAO + '#';

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' OPERACAO.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_OPERACA OPERACAO,';
   SET @V_WHERE            = @V_WHERE + 'OPERACAO.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_TPPED, '') <> '' 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPPED,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''TPPED'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_TPPED + '#';

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + 'TPPED.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TPPED TPPED,';
   SET @V_WHERE            = @V_WHERE + ' TPPED.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@PDB_TBCV_CPGTO, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CONDPGTO,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''CONDPGTO'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @PDB_TBCV_CPGTO + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CPGTOIT', @PDB_TBCV_CPGTO, @V_ID ; 

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + 'CPGTOIT.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_CPGTOIT CPGTOIT,';
   SET @V_WHERE            = @V_WHERE + ' CPGTOIT.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@PDB_TBCV_AREAATU, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'AREAATU,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''AREAATU'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @PDB_TBCV_AREAATU + '#';
   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' AREAATU.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_AREAATU AREAATU,';
   SET @V_WHERE            = @V_WHERE + ' AREAATU.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_PRODUTO, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'PRODUTO,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''PRODUTO'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_PRODUTO + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'PRODUTO', @P_PRODUTO, @V_ID ;

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' PRODUTO.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_PRODUTO PRODUTO,';
   SET @V_WHERE            = @V_WHERE + ' PRODUTO.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_TPPROD, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TIPOPROD,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''TIPOPROD'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_TPPROD + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPPROD', @P_TPPROD, @V_ID

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' TIPOPROD.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TPPROD TIPOPROD,';
   SET @V_WHERE            = @V_WHERE + ' TIPOPROD.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_MARCA, '') <> '' 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'MARCA,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''MARCA'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_MARCA + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'MARCA', @P_MARCA, @V_ID

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' MARCA.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_MARCA MARCA ,';
   SET @V_WHERE            = @V_WHERE + ' MARCA.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_FAMILIA, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'FAMILIA,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''FAMILIA'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_FAMILIA + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'FAMILIA', @P_FAMILIA, @V_ID;

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' FAMILIA.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_FAMILIA FAMILIA,';
   SET @V_WHERE            = @V_WHERE + ' FAMILIA.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_UF_ORIG, '') <> '' 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'UFEMP,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''UFEMP'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_UF_ORIG + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'UFEMP', @P_UF_ORIG, @V_ID

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' UFEMP.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_UFEMP UFEMP,';
   SET @V_WHERE            = @V_WHERE + ' UFEMP.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_TPPESSOA, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPPESSOA,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''TPPESSOA'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_TPPESSOA + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPPESSO', @P_TPPESSOA, @V_ID
   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + 'TPPESSOA.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TDPESSOA TPPESSOA,';
   SET @V_WHERE            = @V_WHERE + ' TPPESSOA.ID =  ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_SUFRAMA, -1) NOT IN (-1, 0) 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'SUFRAMA,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''SUFRAMA'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_SUFRAMA + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'SUFRAMA', @P_SUFRAMA, @V_ID

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' SUFRAMA.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_SUFRAMA SUFRAMA,';
   SET @V_WHERE            = @V_WHERE + ' SUFRAMA.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND';
END

IF ISNULL(@P_CLASSFIS, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASFISPROD,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''CLASFISPROD'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_CLASSFIS + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CLAFPRO', @P_CLASSFIS, @V_ID

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' CLASFISPROD.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_CLASFISPROD CLASFISPROD,';
   SET @V_WHERE            = @V_WHERE + ' CLASFISPROD.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_CLASSFCLI, '') <> '' 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASFISCLI,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''CLASFISCLI'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_CLASSFCLI + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CLASFISCLI', @P_CLASSFCLI, @V_ID

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' CLASFISCLI.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + ' TEMP_MPV06_CLASFISCLI CLASFISCLI,';
   SET @V_WHERE            = @V_WHERE + ' CLASFISCLI.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_CLASSPRD, '') <> '' 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASCOMPROD,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''CLASCOMPROD'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_CLASSPRD + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CLACPRO', @P_CLASSPRD, @V_ID

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' CLASCOMPROD.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_CLASCOMPROD CLASCOMPROD,';
   SET @V_WHERE            = @V_WHERE + ' CLASCOMPROD.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_FATUR, -1) <> -1 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPFATUR,';
   SET  @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''TPFATUR'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_FATUR + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPFATUR', @P_FATUR, @V_ID

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' TPFATUR.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TPFATUR TPFATUR ,';
   SET @V_WHERE            = @V_WHERE + ' TPFATUR.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@PTIPO_FRETE, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TIPOFRETE,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) +  ' AND PV05_TAGFILTRO = ''TIPOFRETE'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --VHASH            := VHASH || I.DB_RESR_VALOR || '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPFRETE', @PTIPO_FRETE, @V_ID

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' TIPOFRETE.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TPFRETE TIPOFRETE,';
   SET @V_WHERE            = @V_WHERE + ' TIPOFRETE.ID = ' + CAST(@V_ID AS VARCHAR) +  ' AND ';
END

IF ISNULL(@PDB_TBCV_OPERLOG, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'OPERLOG,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''OPERLOG'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @PDB_TBCV_OPERLOG + '#';

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' OPERLOG.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_OPERLOG OPERLOG,';
   SET @V_WHERE            = @V_WHERE + ' OPERLOG.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_LABORATOR, '') <> '' 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'LABOROL,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''LABOROL'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_LABORATOR + '#';

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' LABOROL.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_LABOROL LABOROL,';
   SET @V_WHERE            = @V_WHERE + ' LABOROL.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_GRUPO, '') <> '' 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'GRUPOPROD,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''GRUPOPROD'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_GRUPO + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'GRUPROD', @P_GRUPO, @V_ID

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + 'GRUPOPROD.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_GRUPOPROD GROPOPROD,';
   SET @V_WHERE            = @V_WHERE + ' GRUPOPROD.ID = ' + CAST(@V_ID AS VARCHAR) + '  AND ';
END

IF ISNULL(@P_TPVDAPRD, -1) <> -1 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPVENDA,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''TPVENDA'')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_TPVDAPRD + '#';

   EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPVENDA', @P_TPVDAPRD, @V_ID

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' TPVENDA.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TPVENDA TPVENDA, ';
   SET @V_WHERE            = @V_WHERE + ' TPVALOR.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_CONTRIB, '') NOT IN ('', 'A') 
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CONTRIBUINTE,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''CONTRIBUINTE'')';
   SET @VCONTADOR        = @VCONTADOR + 1;

   IF @P_CONTRIB = 'N'
   BEGIN
      SET @VHASH = @VHASH + 1 + '#';
      EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CONTRIB', '1', @V_ID
   END
   ELSE
   BEGIN
      --SET @VHASH = @VHASH + 0 + '#';
      EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CONTRIB', '0', @V_ID
   END

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' CONTRIBUIENTE.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_CONTRIB CONTRIBUINTE,';
   SET @V_WHERE            = @V_WHERE + ' CONTRIBUINTE.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

IF ISNULL(@P_CLIENTE, '') <> ''  AND (@P_CLIREDE =  'REDE' OR @P_CLIREDE = 'CNPJ')
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + @P_CLIREDE + ',';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''' + @P_CLIREDE + ''')';
   SET @VCONTADOR        = @VCONTADOR + 1;
   --SET @VHASH            = @VHASH + @P_CLIENTE + '#';

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' CLIENTE.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + ' TEMP_MPV06_CLIENTE CLIENTE,';
   SET @V_WHERE            = @V_WHERE + ' CLIENTE.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

--PRINT 'FORCA VENDAS : ' + ISNULL(@PDB_TBCV_FORCAVENDAS, 'NULL')

IF ISNULL(@PDB_TBCV_FORCAVENDAS, '') <> ''
BEGIN
   SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'FORCAVENDAS,';
   SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''FORCAVENDAS'')';
   SET @VCONTADOR        = @VCONTADOR + 1;

   SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' FORCAVENDAS.VALOR + ''#'' + ';
   SET @V_FROM             = @V_FROM + 'TEMP_MPV06_FORCAVENDAS FORCAVENDAS, ';
   SET @V_WHERE            = @V_WHERE + ' FORCAVENDAS.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
END

--BUSCA SE EXISTE ALGUM VALOR NOS ATRIBUTOS
DECLARE CUR_ATRIBUTO CURSOR
FOR SELECT DB_TBCVA_ATRIB, DB_TBCVA_VALOR
      FROM DB_TB_COND_VENDAAT
     WHERE ISNULL(DB_TBCVA_VALOR, '') <> ''
       AND DB_TBCVA_CODIGO = @P_CODIGO
      OPEN CUR_ATRIBUTO
     FETCH NEXT FROM CUR_ATRIBUTO
      INTO @VDB_TBCVA_ATRIB, @VDB_TBCVA_VALOR
     WHILE @@FETCH_STATUS = 0
    BEGIN

      SELECT @V_AT02_ORIGEM = AT02_ORIGEM
        FROM MAT02
       WHERE AT02_ATRIB   = @VDB_TBCVA_ATRIB
         AND AT02_TABELA  IN (2,3)  -- CONDICAO E ITEM CONDICAO

      IF @V_AT02_ORIGEM = 1  -- CLIENTE
      BEGIN
         SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'ATC' + @VDB_TBCVA_ATRIB + ',';
         SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR)+ ' AND PV05_TAGFILTRO = ''ATC' +  @VDB_TBCVA_ATRIB + ''')';
      END
      ELSE
      BEGIN
         SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'ATP' + @VDB_TBCVA_ATRIB + ',';
         SET @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' + CAST(@VCONTADOR AS VARCHAR)+ ' AND PV05_TAGFILTRO = ''ATP' +  @VDB_TBCVA_ATRIB + ''')';
      END

      SET @VCONTADOR  = @VCONTADOR + 1;
      SET @V_ATRIBUTO = @V_ATRIBUTO + @VDB_TBCVA_VALOR + '#'

    FETCH NEXT FROM CUR_ATRIBUTO
      INTO  @VDB_TBCVA_ATRIB, @VDB_TBCVA_VALOR
      END
      CLOSE CUR_ATRIBUTO
DEALLOCATE CUR_ATRIBUTO

SET @VCONTADOR = @VCONTADOR - 1;

SET @VSQL = @VSQL + ' AND PV04_INDDESCTO = ' + CAST( (ISNULL(@PDB_TBCV_IND_DESCTO, 0) + 1) AS VARCHAR);

SET @VSQL = @VSQL + ' AND NOT EXISTS (SELECT 1 FROM MPV05 WHERE PV05_SEQ > ' + CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_CONTROLE = PV04_CONTROLE)';

--RETIRA ULTIMA VIRGULA
SET @VLISTA_RESTRICAO = SUBSTRING(@VLISTA_RESTRICAO,  1, (LEN(@VLISTA_RESTRICAO) - 1));
--SET @VHASH            = SUBSTRING(@VHASH, 1, (LEN(@VHASH) - 1));

CREATE TABLE #TEMP (CODIGO INT);
SET @PPV04_CONTROLE = 0; 

INSERT INTO #TEMP EXEC sp_executeSQL @VSQL

SELECT @PPV04_CONTROLE = CODIGO FROM #TEMP

DROP TABLE #TEMP

--SE NAO EXISTIR CONTROLE COM RESTRICOES DEFINIDAS INSERE NAS 2 TABELAS OS REGISTROS (CAPA, ITENS)
IF @PPV04_CONTROLE = 0
BEGIN
   SELECT @PPV04_CONTROLE = ISNULL(MAX(PV04_CONTROLE), 0) + 1 FROM MPV04;

   IF @PDB_TBCV_TIPO = 1
      SET @VDB_TBCV_TIPO = 'C';
   ELSE
      SET @VDB_TBCV_TIPO = 'I';

   INSERT INTO MPV04
     (PV04_CONTROLE, PV04_TIPO, PV04_INDDESCTO)
   VALUES
     (@PPV04_CONTROLE, @VDB_TBCV_TIPO, (ISNULL(@PDB_TBCV_IND_DESCTO, 0) + 1));

   SET @V_AUX = 1;

   WHILE @V_AUX <= @VCONTADOR
   BEGIN
     INSERT INTO MPV05
       (PV05_CONTROLE, PV05_SEQ, PV05_TAGFILTRO)
     VALUES
       (@PPV04_CONTROLE, @V_AUX, DBO.MERCF_PIECE(@VLISTA_RESTRICAO, ',', @V_AUX));

     SET @V_AUX = @V_AUX + 1;
   END
END  -- FIM IF CONTROLE = NULL

SET @VSQL = 'UPDATE MPV04 SET PV04_PESO =  (SELECT ISNULL(SUM(PV07_PESO), 0)
             FROM MPV07 WHERE PV07_TAGFILTRO IN (''' +
             REPLACE(@VLISTA_RESTRICAO, ',', ''',''') +
             ''' )) WHERE PV04_CONTROLE = ' + CAST(@PPV04_CONTROLE AS VARCHAR)

EXEC sp_executeSQL @VSQL

SET @V_AUX = 1;
SET @V_AUX2 = 1;
SET @V_SEQ = 1;

IF ISNULL(@V_ATRIBUTO, '') <> ''
BEGIN

   IF CHARINDEX(',', @V_ATRIBUTO) <> 0
   BEGIN

      SET @VQTDE_LST_ATRIBUTO = 0;
      SET @VQTDE_LST_ATRIBUTO = ISNULL(LEN(@V_ATRIBUTO) - LEN(REPLACE(@V_ATRIBUTO, '#', '')), 0);

      WHILE @V_AUX <= @VQTDE_LST_ATRIBUTO
      BEGIN
        SET @V_AUX2 = 1;

        SELECT  @V_VALOR_PARTE = DBO.MERCF_PIECE (@V_ATRIBUTO, '#', @V_AUX);

        SET @V_QUANTIDADE = ISNULL(LEN(@V_VALOR_PARTE) - LEN(REPLACE(@V_VALOR_PARTE, ',', '')), 0) + 1;

        WHILE @V_AUX2 <= @V_QUANTIDADE
        BEGIN
          IF @V_PRIMEIRA = 1
          BEGIN
             INSERT INTO TEMP_MPV06_ATRIBUT (ID, SEQ, VALOR)
             VALUES (@V_ID, @V_SEQ, DBO.MERCF_PIECE(@V_VALOR_PARTE, ',', @V_AUX2) + '#');
             SET @V_SEQ = @V_SEQ + 1;
          END
          ELSE
          BEGIN
             SELECT @V_SEQ = ISNULL(MAX(SEQ), 1) FROM TEMP_MPV06_ATRIBUT;

             INSERT INTO TEMP_MPV06_ATRIBUT (ID, SEQ, VALOR)
             (SELECT @V_ID, @V_SEQ + ROW_NUMBER() OVER(ORDER BY ID ), VALOR + DBO.MERCF_PIECE(@V_VALOR_PARTE, ',', @V_AUX2) + '#'
                FROM TEMP_MPV06_ATRIBUT
               WHERE LEN(VALOR) - LEN(REPLACE(VALOR, '#', '')) = (@V_AUX - 1));
          END

          SET @V_AUX2 = @V_AUX2 + 1;

        END  -- FIM 2º WHILE

        IF @V_PRIMEIRA = 0
           DELETE FROM TEMP_MPV06_ATRIBUT  WHERE LEN(VALOR) - LEN(REPLACE(VALOR, '#', '')) = @V_AUX - 1;

           SET @V_PRIMEIRA = 0;
           SET @V_AUX = @V_AUX + 1;
      END -- FIM 1º WHILE

      UPDATE TEMP_MPV06_ATRIBUT  SET VALOR = SUBSTRING(VALOR, 1, LEN(VALOR) - 1);
    
      SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' ATRIBUTO.VALOR + ''#'' + ';
      SET @V_FROM             = @V_FROM + 'TEMP_MPV06_ATRIBUT ATRIBUTO,';
      SET @V_WHERE            = @V_WHERE + ' ATRIBUTO.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';

   END
   ELSE
   BEGIN

      SET @V_ATRIBUTO = SUBSTRING(@V_ATRIBUTO, 1, LEN(@V_ATRIBUTO) - 1);

      EXEC DBO.MERCP_INSERE_MPV06_TEMP 'ATRIBUT', @V_ATRIBUTO, @V_ID

      SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' ATRIBUTO.VALOR + ''#'' + ';
      SET @V_FROM             = @V_FROM + 'TEMP_MPV06_ATRIBUT ATRIBUTO,';
      SET @V_WHERE            = @V_WHERE + ' ATRIBUTO.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';

   END  -- CHARINDEX(',', @V_ATRIBUTO) <> 0
END

--RETIRA O ULTINO AND DA EXPRESSAO
SET @V_WHERE = SUBSTRING(@V_WHERE, 1, (LEN(@V_WHERE) - 4)) + ' )';

--RETIRA A ULTIMA VIRGURA DO FROM
SET @V_FROM = SUBSTRING(@V_FROM, 1, (LEN(@V_FROM) - 1));

SET @V_RESTRICAO_SELECT = SUBSTRING(@V_RESTRICAO_SELECT,  1, (LEN(LTRIM(RTRIM(@V_RESTRICAO_SELECT))) - 7));

--SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ISNULL(@V_ATRIBUTO, '');

SET @V_SEQ = 0;

SELECT @V_SEQ = ISNULL(MAX(PV06_SEQ), 0)
  FROM MPV06_TEMP_HASH
 WHERE PV06_CONTROLE = @PPV04_CONTROLE

SET @VINSERE = 0;

IF ISNULL(@V_RESTRICAO_SELECT, '')  <> ''
BEGIN

   IF @PDB_TBCV_IND_DESCTO = 6 AND @PDB_TBCV_TIPO = 1
      SET @VPV06_APLICBRUTO = 1
   ELSE
      SET @VPV06_APLICBRUTO = 0

   IF @PDB_TBCV_TPAVAL = 0
      SET @VPV06_PEDMIN = @PDB_TBCVP_PEDMIN
   ELSE IF @PDB_TBCV_TPAVAL = 1 OR @PDB_TBCV_TPAVAL = 2
      SET @VPV06_VALMIN = @PDB_TBCVP_PEDMIN;

   SET  @V_INSERT_MPV06 = 'INSERT INTO MPV06_TEMP_HASH
                           (
                            PV06_CONTROLE,
                            PV06_SEQ,
                            PV06_POLITICA,
                            PV06_TIPO,
                            PV06_IDENT,
                            PV06_DATA_INI,
                            PV06_DATA_FIM,
                            PV06_PRAZOMAX,
                            PV06_QTDEMAX,
                            PV06_QTDEMIN,
                            PV06_CVI,
                            PV06_COMIS,
                            PV06_PEDMIN,
                            PV06_DESCTO,
                            PV06_APLICACAO,
                            PV06_GRUPOEMP,
                            PV06_TPAVALIACAO,               
                            PV06_ACRVLR,
                            PV06_APLIC_OL,
                            PV06_CLICONTRIB,
                            PV06_CLIIE,
                            PV06_CLIVENDOR,
                            PV06_CLISUFRAMA,
                            PV06_APRESCLI,
                            PV06_DIAINI,
                            PV06_DIAFIN,
                            PV06_APLICBRUTO,
                            PV06_VALIDADE,
                            PV06_APLIC_OLCLI,
                            PV06_VALMIN,
                            PV06_FORMAPRECO
                           )
                           (
                            SELECT ' + CAST(@PPV04_CONTROLE AS VARCHAR) + ' ,
                            ROW_NUMBER() OVER(ORDER BY ' +   (SUBSTRING(@V_WHERE, 1, CHARINDEX('=', @V_WHERE) - 1))  + ' ) + ' + CAST(@V_SEQ AS NVARCHAR) + ' ,
                            ''' + @P_CODIGO + ''', ' +
                            '''C'',' + 
                            @V_RESTRICAO_SELECT + ' , CONVERT(DATETIME,''' +
                            CONVERT(NVARCHAR(30), @P_DTVALINI, 103) + ''', 103) , CONVERT(DATETIME, ''' + 
                            CONVERT(NVARCHAR(30), @P_DTVALFIN, 103) + ''', 103) , ''' +
                            CAST(ISNULL(@PDB_TBCVP_PRZMED, '')  AS VARCHAR)+ ''' , ''' + 
                            CAST(ISNULL(@PDB_TBCVP_QTDEMAX, '')  AS VARCHAR)+           ''' , ''' +
                            CAST(ISNULL(@PDB_TBCVP_QTDEMIN, '') AS VARCHAR) + ''' , ''' +
                            CAST(ISNULL(@PDB_TBCVP_CVI, '') AS VARCHAR) + ''' , ''' + 
                            CAST(ISNULL(@PDB_TBCVP_COMIS, '')  AS VARCHAR)+ ''' , ''' + 
                            CAST(ISNULL(@VPV06_PEDMIN, '')  AS VARCHAR)+ ''' , ''' +
                            CAST(ISNULL(@PDB_TBCVP_DESCTO, '') AS VARCHAR) + ''' , ''' +
                            CAST(ISNULL(@PDB_TBCV_APLIC_ATU, '')  AS VARCHAR)+ ''' , ''' + 
                            CAST(ISNULL(@PDB_TBCV_GRUPOEMP, '')  AS VARCHAR)+ ''' , ''' +
                            CAST(ISNULL(@PDB_TBCV_TPAVAL, '')  AS VARCHAR)+ ''' , ''' +
                            CAST(ISNULL(@PDB_TBCVP_ACRESC, 0)  AS VARCHAR)+ ''' , ''' +                      
                            CAST(ISNULL(@PDB_TBCV_APLIC_OL, '')  AS VARCHAR)+ ''' , ''' + 
                            CAST(ISNULL(@PDB_TBCV_CLICONTR, '') AS VARCHAR) +   ''' , ''' + 
                            CAST(ISNULL(@PDB_TBCV_IE, '')  AS VARCHAR)+ ''' , ''' +
                            CAST(ISNULL(@PDB_TBCV_AVALCLIVD, '')  AS VARCHAR)+ ''' , ''' +
                            CAST(ISNULL(@PDB_TBCV_SUFRAMA, '')  AS VARCHAR)+               ''' , ''' + 
                            CAST(ISNULL(@PDB_TBCV_APRESCLI, '') AS VARCHAR) + ''' , ''' +
                            CAST(ISNULL(@PDB_TBCVP_DIAINI, '') AS VARCHAR) + ''' , ''' + 
                            CAST(ISNULL(@PDB_TBCVP_DIAFIN, '') AS VARCHAR) +     ''', ''' + 
                            CAST(ISNULL(@VPV06_APLICBRUTO, '') AS VARCHAR) + ''', ''' +
                            CAST(ISNULL(@PDB_TBCV_DTPEDVAL, '') AS VARCHAR) + ''',''' + 
                            CAST(ISNULL(@PDB_TBCV_APL_OLCLI, '') AS VARCHAR) + ''',''' +
                            CAST(ISNULL(@VPV06_VALMIN, '') AS VARCHAR) + ''',''' +
                            CAST(@PDB_TBCV_FORMAPRECO AS VARCHAR) +
                            '''  FROM ' + @V_FROM + '
                            WHERE ' + @V_WHERE;

                            --PRINT '@V_INSERT_MPV06 = ' + @V_INSERT_MPV06

   EXEC sp_executeSQL @V_INSERT_MPV06

   DELETE TEMP_MPV06_PRODUTO WHERE ID = @V_ID;
   DELETE TEMP_MPV06_TPPROD  WHERE ID = @V_ID;
   DELETE TEMP_MPV06_MARCA   WHERE ID = @V_ID;
   DELETE TEMP_MPV06_FAMILIA WHERE ID = @V_ID;
   DELETE TEMP_MPV06_TPPESSO WHERE ID = @V_ID;
   DELETE TEMP_MPV06_SUFRAMA WHERE ID = @V_ID;
   DELETE TEMP_MPV06_CLAFPRO WHERE ID = @V_ID;
   DELETE TEMP_MPV06_CLAFCLI WHERE ID = @V_ID;
   DELETE TEMP_MPV06_CLACPRO WHERE ID = @V_ID;
   DELETE TEMP_MPV06_TPFATUR WHERE ID = @V_ID;
   DELETE TEMP_MPV06_GRUPROD WHERE ID = @V_ID;
   DELETE TEMP_MPV06_TPVENDA WHERE ID = @V_ID;
   DELETE TEMP_MPV06_CONTRIB WHERE ID = @V_ID;
   DELETE TEMP_MPV06_ATRIBUT WHERE ID = @V_ID;
   DELETE TEMP_MPV06_TPFRETE WHERE ID = @V_ID;

   UPDATE DB_PARAM_SISTEMA
      SET DB_PRMS_VALOR = CONVERT(VARCHAR, GETDATE() , 103) + ' ' + CONVERT( VARCHAR, GETDATE(), 108)
    WHERE DB_PRMS_ID = 'SIS_DATAATUPOLITICAS';

END -- FIM IF INSERIR
END TRY

BEGIN CATCH

  SET @VERRO = 'ERRO: POLITICA: ' + @P_CODIGO + ' : ' + ERROR_MESSAGE() + ' LINHA: ' + CAST(ERROR_LINE() AS VARCHAR)
  INSERT INTO DBS_ERROS_TRIGGERS
    (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
  VALUES
    (@VERRO, @VDATA, @VOBJETO);

  DELETE TEMP_MPV06_PRODUTO     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_TPPROD      WHERE ID = @V_ID;
  DELETE TEMP_MPV06_MARCA       WHERE ID = @V_ID;
  DELETE TEMP_MPV06_FAMILIA     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_TPPESSO     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_SUFRAMA     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_CLAFPRO     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_CLAFCLI     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_CLACPRO     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_TPFATUR     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_GRUPROD     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_TPVENDA     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_CONTRIB     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_ATRIBUT     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_EMPRESA     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_REPRES      WHERE ID = @V_ID;
  DELETE TEMP_MPV06_RAMO        WHERE ID = @V_ID;
  DELETE TEMP_MPV06_CLIENTE     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_LPRECO      WHERE ID = @V_ID;
  DELETE TEMP_MPV06_RAMOII      WHERE ID = @V_ID;
  DELETE TEMP_MPV06_OPERACA     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_CIDADE      WHERE ID = @V_ID;
  DELETE TEMP_MPV06_TPPED       WHERE ID = @V_ID;
  DELETE TEMP_MPV06_OPERLOG     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_LABOROL     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_AREAATU     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_UFEMP       WHERE ID = @V_ID;
  DELETE TEMP_MPV06_CLACCLI     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_REGCOM      WHERE ID = @V_ID;
  DELETE TEMP_MPV06_CPGTOIT     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_ATRIBUT     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_TPFRETE     WHERE ID = @V_ID;
  DELETE TEMP_MPV06_FORCAVENDAS WHERE ID = @V_ID;

END CATCH

END
GO
