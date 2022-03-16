SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[MERCP_INSERE_HASH_ST] (
                                        @PDB_RIEI_CODIGO    varchar(25),  -- 01
                                        @PDB_RIEI_SEQ       int,          -- 02
                                        @PDB_RIEI_DTVALINI  DATE,          -- 03
                                        @PDB_RIEI_DTVALFIN  DATE,          -- 04
                                        @PDB_RIEI_EMPRESA   VARCHAR(512), -- 05
                                        @PDB_RIEI_UF_ORIG   VARCHAR(512), -- 06
                                        @PDB_RIEI_UF_DEST   VARCHAR(512), -- 07
                                        @PDB_RIEI_PRODUTO   VARCHAR(512), -- 08
                                        @PDB_RIEI_TPPROD    VARCHAR(512), -- 09
                                        @PDB_RIEI_MARCA     VARCHAR(512), -- 10
                                        @PDB_RIEI_FAMILIA   VARCHAR(512), -- 11
                                        @PDB_RIEI_GRUPO     VARCHAR(512), -- 12
                                        @PDB_RIEI_CLIENTE   int,          -- 13
                                        @PDB_RIEI_RAMO      VARCHAR(512), -- 14
                                        @PDB_RIEI_OPERACAO  VARCHAR(512), -- 15
                                        @PDB_RIEI_TPPESSOA  VARCHAR(512), -- 16
                                        @PDB_RIEI_SUFRAMA   int,          -- 17
                                        @PDB_RIEI_CLASSPRD  VARCHAR(512), -- 18
                                        @PDB_RIEI_TPVDAPRD  int,          -- 19
                                        @PDB_RIEI_FATUR     int,          -- 20
                                        @PDB_RIEI_CLASSFIS  VARCHAR(512), -- 21
                                        @pDB_RieI_ClassFCli VARCHAR(512), -- 22
                                        @PDB_RIEI_CIDADE    VARCHAR(512), -- 23
                                        @PDB_RIEI_CONTRIB   VARCHAR(512), -- 24
                                        @PDB_RIEI_LPRECO    VARCHAR(512), -- 25
                                        @PDB_RIEI_TPPED     VARCHAR(512), -- 26
                                        @PDB_RIEI_CLICCOM   VARCHAR(512),      -- 27
                                        @PDB_RIEI_TXICMS    int,            -- 28
                                        @PDB_RIEI_BASERED   int,            -- 29
                                        @PDB_RIEI_PESO      int,            -- 30
                                        @ptipo              VARCHAR(512),    -- 31
                                        -----ST
                                        @pdb_mpri_calc_subs VARCHAR(512),    -- 32
                                        @pdb_mpri_aplic     int,            -- 33
                                        @pdb_mpri_precomax  float,            -- 34
                                        @pdb_mpri_tpcal     float,            -- 35
                                        @pdb_mpri_dctopmc   float,            -- 36
                                        @pdb_mpri_descto    float,            -- 37
                                        @pDB_MPRI_MRGPRESUM float,            -- 38
                                        @putilbasered       int,            -- 39
                                        @p_id               int,            -- 40
                                        @p_grupo_it_cont    varchar(5),
                                        @p_DB_MPRI_OPTANTESIMPLES   int,
                                        @p_DB_MPRI_DESCONTO_FISCAL  int
                                        ) as

declare  @VOBJETO VARCHAR(200) = 'MERCP_INSERE_HASH_ST';
declare  @VERRO   VARCHAR(1000);
declare  @VDATA   DATE = getdate();

declare  @VLISTA_RESTRICAO nvarchar(4000) = '';
declare  @VSQL             nVARCHAR(max) = '';
declare  @vhash            VARCHAR(800);
declare  @vcodigo_atributo nVARCHAR(250) = '';
declare  @vinsere          int = 1;
declare  @pPF01_SEQ        int;
declare  @PPV04_CONTROLE   int;
declare  @v_count          int;
declare  @vcontador        int;
declare  @vvalor_atributo  nVARCHAR(512)  = '';

declare  @v_from             nVARCHAR(4000) = '';
declare  @v_where            nVARCHAR(4000) = '';
declare  @V_RESTRICAO_SELECT nVARCHAR(4000) = '';
declare  @v_insert_mpv06     nVARCHAR(4000) = '';
declare  @v_seq              int = 0;
declare  @V_ATRIBUTO         nVARCHAR(1000) = '';
declare  @V_ID               int;

declare  @V_QUANTIDADE          int;
declare  @V_VALOR_PARTE         nVARCHAR(255);
declare  @V_EXISTE              int;
declare  @v_primeira            bit = 1;
declare  @v_qtde_lista_anterior int;
declare  @vqtde_lst_ATRIBUTO    int;

 declare @vDB_TBCVA_ATRIB    nvarchar(100) ='';
 declare @vDB_TBCVA_VALOR    nvarchar(100) = '';
DECLARE @qtde_lst_ATRIBUTO   int;     
DECLARE @_QUANTIDADE          int;   
DECLARE @_VALOR_PARTE          nVARCHAR(255) = '';
DECLARE @_EXISTE              int;
DECLARE @_primeira              bit = 1;
DECLARE @_qtde_lista_anterior   int;    
declare @V_AUX2               int;
declare @V_AUX                  int;
declare @V_AT02_ORIGEM        int;
  ------------------------------------------------------------
  --- VERSAO   DATA        AUTOR            ALTERACAO
  --- 1.00001  11/02/2013  ALENCAR/TIAGO    DESENVOLVIMENTO - ROTINA QUE GERA HASH PARA A TABELA DB_MRG_PRES_ITEM - CADASTRO DE SUBSTITUICAO TRIBUTARIA
  --- 1.00002  31/01/2014  tiago            incluido no hash o campo de grupo de itens contrololados
  --- 1.00003  12/04/2016  tiago            incluido filtro CLIOPTSIMPLES
  --- 1.00004  01/12/2016  Alencar          Gravar o hash do atributo com ATP (produto) ou ATC (cliente)
  --- 1.00005  14/03/2017  Tiago            Grava campo desconto fiscal
  ------------------------------------------------------------

begin

begin try

  set @VSQL      = 'SELECT pv04_controle FROM MPV04 WHERE 1=1 ';
  set @vcontador = 1;

  set @V_ID = @p_id;

  --DBMS_OUTPUT.PUT_LINE('@V_ID = ' + cast(@V_ID as varchar));

  if isnull(@PDB_RIEI_UF_DEST, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'ESTADO,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''ESTADO'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_UF_DEST + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'ESTADO', @PDB_RIEI_UF_DEST, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' ESTADO.VALOR + ''#'' + ';
    set @v_from             = @v_from + ' TEMP_MPV06_ESTADO ESTADO,';
    set @v_where            = @v_where + ' ESTADO.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_RAMO, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'RAMO,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''RAMO'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'RAMO', @PDB_RIEI_RAMO, @V_ID
    --@vhash              = @vhash + @PDB_RIEI_RAMO + '#';
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + 'RAMO.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_RAMO RAMO ,';
    set @v_where            = @v_where + ' RAMO.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_CLIENTE, 0) <> 0
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLIENTE,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''CLIENTE'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_CLIENTE + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'CLIENTE', @PDB_RIEI_CLIENTE, @V_ID
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' CLIENTE.VALOR + ''#'' + ';
    set @v_from             = @v_from + ' TEMP_MPV06_CLIENTE CLIENTE,';
    set @v_where            = @v_where + ' CLIENTE.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_LPRECO, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'LPRECO,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''LPRECO'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_LPRECO + '#';
    exec dbo.MERCP_INSERE_MPV06_TEMP 'LPRECO', @PDB_RIEI_LPRECO, @V_ID
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' LPRECO.VALOR + ''#'' + ';
    set @v_from             = @v_from + ' TEMP_MPV06_LPRECO LPRECO, ';
    set @v_where            = @v_where + ' LPRECO.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_CLICCOM, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASCOMCLI,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) +
                        ' AND pv05_tagfiltro = ''CLASCOMCLI'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_CLICCOM + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP'CLACCLI', @PDB_RIEI_CLICCOM, @V_ID 
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          'CLASCOMCLI.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_CLACCLI CLASCOMCLI,';
    set @v_where            = @v_where + ' CLASCOMCLI.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_EMPRESA, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'EMPRESA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''EMPRESA'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_EMPRESA + '#';
    exec dbo.MERCP_INSERE_MPV06_TEMP 'EMPRESA', @PDB_RIEI_EMPRESA, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' EMPRESA.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_EMPRESA EMPRESA,';
    set @v_where            = @v_where + ' EMPRESA.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_CIDADE, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CIDADE,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''CIDADE'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_CIDADE + '#';
    exec dbo.MERCP_INSERE_MPV06_TEMP 'CIDADE', @PDB_RIEI_CIDADE, @V_ID
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' CIDADE.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_CIDADE CIDADE,';
    set @v_where            = @v_where + ' CIDADE.ID = ' + cast(@V_ID as varchar) + ' AND ';
  end

  if isnull(@PDB_RIEI_OPERACAO, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'OPERACAO,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''OPERACAO'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_OPERACAO + '#';
    exec dbo.MERCP_INSERE_MPV06_TEMP 'OPERACA', @PDB_RIEI_OPERACAO, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' operacao.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_operaca operacao,';
    set @v_where            = @v_where + ' operacao.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_TPPED, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPPED,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''TPPED'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_TPPED + '#';
    exec dbo.MERCP_INSERE_MPV06_TEMP 'TPPED', @PDB_RIEI_TPPED, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + 'TPPED.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_TPPED TPPED,';
    set @v_where            = @v_where + ' TPPED.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_PRODUTO, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'PRODUTO,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''PRODUTO'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_PRODUTO + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'PRODUTO', @PDB_RIEI_PRODUTO, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' PRODUTO.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_PRODUTO PRODUTO,';
    set @v_where            = @v_where + ' PRODUTO.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_TPPROD, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TIPOPROD,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''TIPOPROD'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_TPPROD + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'TPPROD', @PDB_RIEI_TPPROD, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' TIPOPROD.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_TPPROD TIPOPROD,';
    set @v_where            = @v_where + ' TIPOPROD.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_MARCA, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'MARCA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''MARCA'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_MARCA + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'MARCA', @PDB_RIEI_MARCA, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' MARCA.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_MARCA MARCA ,';
    set @v_where            = @v_where + ' MARCA.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_FAMILIA, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'FAMILIA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''FAMILIA'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_FAMILIA + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'FAMILIA', @PDB_RIEI_FAMILIA, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' familia.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_familia familia,';
    set @v_where            = @v_where + ' familia.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_UF_ORIG, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'UFEMP,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''UFEMP'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_UF_ORIG + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'UFEMP', @PDB_RIEI_UF_ORIG, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' UFEMP.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_UFEMP UFEMP,';
    set @v_where            = @v_where + ' UFEMP.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_TPPESSOA, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPPESSOA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''TPPESSOA'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_TPPESSOA + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'TPPESSO', @PDB_RIEI_TPPESSOA, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          'TPPESSOA.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_TPPESSO TPPESSOA,';
    set @v_where            = @v_where + ' TPPESSOA.ID =  ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_SUFRAMA, -1) not in (-1, 0)
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'SUFRAMA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''SUFRAMA'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_SUFRAMA + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'SUFRAMA', @PDB_RIEI_SUFRAMA, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' SUFRAMA.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_SUFRAMA SUFRAMA,';
    set @v_where            = @v_where + ' SUFRAMA.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_CLASSFIS, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASFISPROD,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) +
                        ' AND pv05_tagfiltro = ''CLASFISPROD'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_CLASSFIS + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'CLAFPRO', @PDB_RIEI_CLASSFIS, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' CLASFISPROD.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_CLAFPRO CLASFISPROD,';
    set @v_where            = @v_where + ' CLASFISPROD.ID = ' + cast(@V_ID as varchar) +
                          ' AND ';
  
  end

  if isnull(@pDB_RieI_ClassFCli, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASFISCLI,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) +
                        ' AND pv05_tagfiltro = ''CLASFISCLI'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @pDB_RieI_ClassFCli + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'CLAFCLI', @pDB_RieI_ClassFCli, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' CLASFISCLI.VALOR + ''#'' + ';
    set @v_from             = @v_from + ' TEMP_MPV06_CLAFCLI CLASFISCLI,';
    set @v_where            = @v_where + ' CLASFISCLI.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_CLASSPRD, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASCOMPROD,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) +
                        ' AND pv05_tagfiltro = ''CLASCOMPROD'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_CLASSPRD + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'CLACPRO', @PDB_RIEI_CLASSPRD, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' CLASCOMPROD.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_CLACPRO CLASCOMPROD,';
    set @v_where            = @v_where + ' CLASCOMPROD.ID = ' + cast(@V_ID as varchar) +
                          ' AND ';
  
  end

  if isnull(@PDB_RIEI_FATUR, 0) <> 0
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPFATUR,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''TPFATUR'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_FATUR + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'TPFATUR', @PDB_RIEI_FATUR, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' TPFATUR.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_TPFATUR TPFATUR ,';
    set @v_where            = @v_where + ' TPFATUR.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_GRUPO, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'GRUPOPROD,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''GRUPOPROD'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_GRUPO + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'GRUPROD', @PDB_RIEI_GRUPO, @V_ID
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          'GRUPOPROD.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_GRUPROD GRUPOPROD,';
    set @v_where            = @v_where + ' GRUPOPROD.ID = ' + cast(@V_ID as varchar) + '  AND ';
  
  end

  if isnull(@PDB_RIEI_TPVDAPRD, 0) <> 0
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPVENDA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''TPVENDA'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_TPVDAPRD + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'TPVENDA', @PDB_RIEI_TPVDAPRD, @V_ID
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' TPVENDA.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_TPVENDA TPVENDA, ';
    set @v_where            = @v_where + ' TPVENDA.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end

  if isnull(@PDB_RIEI_CONTRIB, '') not in ('', 'A')
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CONTRIBUINTE,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) +
                        ' AND pv05_tagfiltro = ''CONTRIBUINTE'')';
    set  @vcontador        = cast(@vcontador as varchar) + 1;
    if @PDB_RIEI_CONTRIB = 'N'
    begin
      exec dbo.MERCP_INSERE_MPV06_TEMP 'CONTRIB', '1', @V_ID
    end
    else
    begin      
      exec dbo.MERCP_INSERE_MPV06_TEMP 'CONTRIB', '0', @V_ID
    end
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' CONTRIBUIENTE.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_CONTRIB CONTRIBUINTE,';
    set @v_where            = @v_where + ' CONTRIBUINTE.ID = ' + cast(@V_ID as varchar) +
                          ' AND ';

  
  end
  --DBMS_OUTPUT.PUT_LINE('ANTES ATRIBUTOS');
  --busca se existe algum valor nos atributos




  if isnull(@PDB_RIEI_TPVDAPRD, 0) <> 0
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPVENDA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''TPVENDA'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_TPVDAPRD + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'TPVENDA', @PDB_RIEI_TPVDAPRD, @V_ID
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' TPVENDA.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_TPVENDA TPVENDA, ';
    set @v_where            = @v_where + ' TPVENDA.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end


  if isnull(@p_grupo_it_cont, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'GRPITENSCONTR,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''GRPITENSCONTR'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_TPVDAPRD + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'GRPITENSCONTR', @p_grupo_it_cont, @V_ID
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' GRPITENSCONTR.VALOR + ''#'' + ';
    set @v_from             = @v_from + ' TEMP_MPV06_GRPITENSCONTR GRPITENSCONTR, ';
    set @v_where            = @v_where + ' GRPITENSCONTR.ID = ' + cast(@V_ID as varchar) + ' AND ';

  end

  if isnull(@p_DB_MPRI_OPTANTESIMPLES, 0) <> 0
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLIOPTSIMPLES,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''CLIOPTSIMPLES'')';
    set @vcontador        = cast(@vcontador as varchar) + 1;
    --@vhash            = @vhash + @PDB_RIEI_FATUR + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'CLIOPTSIMPLES', @p_DB_MPRI_OPTANTESIMPLES, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' CLIOPTSIMPLES.VALOR + ''#'' + ';
    set @v_from             = @v_from + 'TEMP_MPV06_CLIOPTSIMPLES CLIOPTSIMPLES ,';
    set @v_where            = @v_where + ' CLIOPTSIMPLES.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  end


    DECLARE CUR_atributo CURSOR
    FOR select db_mpra_atrib, db_mpra_valor
          from db_mrg_pres_atrib
         where db_mpra_codigo = @PDB_RIEI_CODIGO 
		   and DB_MPRA_MPRI_SEQ = @PDB_RIEI_SEQ
         order by  db_mpra_seq
        OPEN CUR_atributo
       FETCH NEXT FROM CUR_atributo
        INTO @vDB_TBCVA_ATRIB, @vDB_TBCVA_VALOR
    WHILE @@FETCH_STATUS = 0
       BEGIN
          
           set @V_AT02_ORIGEM = NULL;

           SELECT @V_AT02_ORIGEM = AT02_ORIGEM
             FROM MAT02 
            WHERE AT02_ATRIB   = @vDB_TBCVA_ATRIB
              AND AT02_TABELA  IN (7) -- Subst. Tributaria

            IF @V_AT02_ORIGEM = 1  -- CLIENTE
            begin
                set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'ATC' + @vDB_TBCVA_ATRIB + ',';
                set @VSQL             = @VSQL +
                                   ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                                    cast(@vcontador as varchar)+ ' AND PV05_TAGFILTRO = ''ATC' +  @vDB_TBCVA_ATRIB + ''')';            
            end
            else
            begin
                set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'ATP' + @vDB_TBCVA_ATRIB + ',';
                set @VSQL             = @VSQL +
                                   ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                                    cast(@vcontador as varchar)+ ' AND PV05_TAGFILTRO = ''ATP' +  @vDB_TBCVA_ATRIB + ''')';
            end;

            set @vcontador        = cast(@vcontador as varchar) + 1;
    
            set @V_ATRIBUTO       = @V_ATRIBUTO + @vDB_TBCVA_VALOR + '#'

    FETCH NEXT FROM CUR_atributo
      INTO  @vDB_TBCVA_ATRIB, @vDB_TBCVA_VALOR
      END
      CLOSE CUR_atributo
    DEALLOCATE CUR_atributo



  --------- inclui da tabela os atributos
  
  set @V_AUX = 1
  set @V_AUX2 = 1
  set @v_seq = 1

  IF isnull(@V_ATRIBUTO, '') <> ''
  begin
  
    IF charindex(',', @V_ATRIBUTO) <> 0
    begin

        set @qtde_lst_ATRIBUTO = 0;

        set @qtde_lst_ATRIBUTO = isnull(len(@V_ATRIBUTO) - len(replace(@V_ATRIBUTO, '#', '')), 0)

        while @V_AUX <= @qtde_lst_ATRIBUTO
        begin
             
            set @V_AUX2 = 1


            select  @_VALOR_PARTE = dbo.mercf_piece (@V_ATRIBUTO, '#', @V_AUX)
      
            set @_QUANTIDADE = isnull(len(@_VALOR_PARTE) - len(replace(@_VALOR_PARTE, ',', '')), 0) + 1

            while @V_AUX2 <= @_QUANTIDADE
            begin        
        
                if @_primeira = 1
                begin
                    insert into TEMP_MPV06_ATRIBUT    (id, seq, valor)
                                            values
                                                    (@V_ID, @v_seq, dbo.mercf_piece(@_VALOR_PARTE, ',', @V_AUX2) + '#');
                    set @v_seq = @v_seq + 1;
                end
                else
                begin

                    SELECT @v_seq = ISNULL(MAX(SEQ), 1) FROM TEMP_MPV06_ATRIBUT;
          
                    INSERT into TEMP_MPV06_ATRIBUT  (id, seq, valor)
                    (SELECT @V_ID, @v_seq + ROW_NUMBER() OVER(ORDER BY ID ), VALOR + dbo.mercf_piece(@_VALOR_PARTE, ',', @V_AUX2) + '#'
                      FROM TEMP_MPV06_ATRIBUT
                     where len(VALOR) - len(REPLACE(VALOR, '#', '')) = (@V_AUX - 1));
                
          
                end

                set @V_AUX2 = @V_AUX2 + 1;

            ENd ------ fim 2º while

        IF @_primeira = 0
          delete from TEMP_MPV06_ATRIBUT  WHERE len(VALOR) - len(REPLACE(VALOR, '#', '')) = @V_AUX - 1;
              
        set @_primeira = 0
        set @V_AUX = @V_AUX + 1;
      ENd --------- fim 1º while
    
      UPDATE TEMP_MPV06_ATRIBUT  SET VALOR = SUBSTRing(VALOR, 1, LEN(VALOR) - 1);
      
    
      set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' ATRIBUTO.VALOR + ''#'' + ';
      set @v_from             = @v_from + 'TEMP_MPV06_ATRIBUT ATRIBUTO,';
      set @v_where            = @v_where + ' ATRIBUTO.ID = ' + cast(@V_ID as varchar) + ' AND ';

    end
    ELSE
    begin

      set @V_ATRIBUTO = substring(@V_ATRIBUTO, 1, len(@V_ATRIBUTO) - 1);

      exec dbo.MERCP_INSERE_MPV06_TEMP 'ATRIBUT', @V_ATRIBUTO, @V_ID

      set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' ATRIBUTO.VALOR + ''#'' + ';
      set @v_from             = @v_from + 'TEMP_MPV06_ATRIBUT ATRIBUTO,';
      set @v_where            = @v_where + ' ATRIBUTO.ID = ' + cast(@V_ID as varchar) + ' AND ';
    
    ENd ----charindex(',', @_ATRIBUTO) <> 0
  
  ENd
  
  set @vcontador = @vcontador - 1;

  set @VSQL = @VSQL + 'and not exists (select 1 from mpv05 where pv05_seq > ' +
          cast(@vcontador as varchar) + ' and pv05_controle = pv04_controle)';

  --retira ultima virgula
  set @VLISTA_RESTRICAO = substring(@VLISTA_RESTRICAO,  1, (len(@VLISTA_RESTRICAO) - 1));

    create table #temp ( codigo    int);
    set @PPV04_CONTROLE = 0; 

    insert into #temp  exec sp_executeSQL @VSQL 
   

    select @PPV04_CONTROLE = codigo from #temp

    drop table #temp

  --se nao existir controle com restricoes definidas insere nas 2 tabelas os registros (capa, itens)
    IF @PPV04_CONTROLE = 0 
      begin

        SELECT @PPV04_CONTROLE = isnull(MAX(PV04_CONTROLE), 0) + 1 FROM MPV04;
  
        INSERT INTO MPV04
          (PV04_CONTROLE, PV04_TIPO)
        VALUES
          (@PPV04_CONTROLE, 'I');
  
        set @V_AUX = 1
    
        while @V_AUX <= @vcontador
        begin

          INSERT INTO MPV05
            (PV05_CONTROLE, PV05_SEQ, PV05_TAGFILTRO)
          VALUES
            (@PPV04_CONTROLE, @V_AUX, dbo.MERCF_PIECE(@VLISTA_RESTRICAO, ',', @V_AUX));

          set @V_AUX = @V_AUX + 1

        end
  
      END --- FIM IF CONTROLE = NULL


      set @VSQL = 'update mpv04 set pv04_peso_imp =  (select nvl(sum(pv07_peso_imp), 0) 
            from mpv07 where pv07_tagfiltro in (''' +
          replace(@VLISTA_RESTRICAO, ',', ''',''') + ''' )) where pv04_controle = ' + cast(@PPV04_CONTROLE as varchar)


  set @v_where = SUBSTRing(@v_where, 1, (LEN(@v_where) - 4)) + ' )';
  --RETIRA A ULTIMA VIRGURA DO FROM
  set @v_from = SUBSTRing(@v_from, 1, (LEN(@v_from) - 1));

  set @V_RESTRICAO_SELECT = SUBSTRing(@V_RESTRICAO_SELECT,  1, (LEN(@V_RESTRICAO_SELECT) - 7));
 
  if @V_RESTRICAO_SELECT is not null
  begin
    --busca proxima sequencia
    set @pPF01_SEQ = 0;
    
      select @pPF01_SEQ =  isnull(max(PF01_SEQ), 0)
        from mpf01_TEMP_HASH
       where pf01_controle = @PPV04_CONTROLE;
      
    set @v_insert_mpv06 = 'Insert into mpf01_TEMP_HASH
                                (PF01_CONTROLE,
                                 PF01_SEQ,
                                 PF01_REGRA,
                                 PF01_TIPO,
                                 PF01_IDENT,
                                 PF01_PERCENTUAL,
                                 PF01_BASERED,
                                 PF01_DATAINI,
                                 PF01_DATAFIN,
                                 pf01_calc,
                                 pf01_aplic,
                                 pf01_prcmax,
                                 pf01_tpcalc,
                                 pf01_dctopmc,
                                 pf01_descto,
                                 pf01_utilbasered,
                                 PF01_DESCONTOFISCAL
                                 )
                                ( SELECT ' +
                                  cast(@PPV04_CONTROLE as varchar) + ',
                                  ROW_NUMBER() OVER(ORDER BY ' +   (substring(@v_where, 1, charindex('=', @v_where) - 1))  + ' ) + ' + cast(@pPF01_SEQ as nvarchar) + ',' +
                                  replace(@PDB_RIEI_CODIGO, ' ', '') + ' , ' + 
                                  '''ST''' + ' , ' +
                                  @V_RESTRICAO_SELECT + ' , ''' +
                                  cast(isnull(@pDB_MPRI_MRGPRESUM, 0) as varchar) +  ''' , ''' + 
                                  cast(isnull(@PDB_RIEI_BASERED, 0) as varchar) + ''' , convert( datetime, '''  +
                                  convert( nvarchar(30), @PDB_RIEI_DTVALINI, 103) + ''', 103) , convert(datetime, ''' + 
                                  convert( nvarchar(30), @PDB_RIEI_DTVALFIN, 103) + ''', 103) , case ''' + 
                                  isnull(@pdb_mpri_calc_subs, 0) +  ''' when ''S'' then 1 when ''N'' then 0 end' +  ' , ''' + 
                                  cast(isnull(@pdb_mpri_aplic, 0) as varchar) + ''' , ''' +
                                  cast(isnull(@pdb_mpri_precomax, 0) as varchar) + ''' , ''' +
                                  cast(isnull(@pdb_mpri_tpcal, 0) as varchar) +  ''' , ''' + 
                                  cast(isnull(@pdb_mpri_dctopmc, 0) as varchar) + ''' , ''' +
                                  cast(isnull(@pdb_mpri_descto, 0) as varchar) + ''' , ''' + 
                                  cast(isnull(@putilbasered, '') as varchar) + ''' , ''' + 
                                  cast(isnull(@p_DB_MPRI_DESCONTO_FISCAL, 0) as varchar) +
                                  ''' FROM ' + @v_from + '' + ' WHERE ' + @v_where;

    exec sp_executeSQL @v_insert_mpv06
   
    delete TEMP_MPV06_CONTRIB where id = @V_ID;
    delete TEMP_MPV06_TPVENDA where id = @V_ID;
    delete TEMP_MPV06_GRUPROD where id = @V_ID;
    delete TEMP_MPV06_TPFATUR where id = @V_ID;
    delete TEMP_MPV06_CLACPRO where id = @V_ID;
    delete TEMP_MPV06_CLAFCLI where id = @V_ID;
    delete TEMP_MPV06_CLAFPRO where id = @V_ID;
    delete TEMP_MPV06_SUFRAMA where id = @V_ID;
    delete TEMP_MPV06_TPPESSO where id = @V_ID;
    delete TEMP_MPV06_UFEMP where id = @V_ID;
    delete TEMP_MPV06_FAMILIA where id = @V_ID;
    delete TEMP_MPV06_MARCA where id = @V_ID;
    delete TEMP_MPV06_TPPROD where id = @V_ID;
    delete TEMP_MPV06_PRODUTO where id = @V_ID;
    delete TEMP_MPV06_TPPED where id = @V_ID;
    delete TEMP_MPV06_OPERACA where id = @V_ID;
    delete TEMP_MPV06_CIDADE where id = @V_ID;
    delete TEMP_MPV06_EMPRESA where id = @V_ID;
    delete TEMP_MPV06_CLACCLI where id = @V_ID;
    delete TEMP_MPV06_LPRECO where id = @V_ID;
    delete TEMP_MPV06_CLIENTE where id = @V_ID;
    delete TEMP_MPV06_RAMO where id = @V_ID;
    delete TEMP_MPV06_ESTADO where id = @V_ID;
    delete TEMP_MPV06_ATRIBUT where id = @V_ID;
    delete TEMP_MPV06_CLIOPTSIMPLES where id = @V_ID;

    update DB_PARAM_SISTEMA
       set DB_PRMS_VALOR = convert(varchar, getdate() , 103) + ' ' + convert( varchar, getdate(), 108)
     where DB_PRMS_ID = 'SIS_DATAATUIMPOSTOS';
  
  end -- fim if inserir

end try
begin catch
    set @VERRO = 'ERRO: REGRA: ' + @PDB_RIEI_CODIGO + ' : ' + ERROR_MESSAGE()
    INSERT INTO DBS_ERROS_TRIGGERS
      (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
    VALUES
      (@VERRO, @VDATA, @VOBJETO);

    delete TEMP_MPV06_CONTRIB where id = @V_ID;
    delete TEMP_MPV06_TPVENDA where id = @V_ID;
    delete TEMP_MPV06_GRUPROD where id = @V_ID;
    delete TEMP_MPV06_TPFATUR where id = @V_ID;
    delete TEMP_MPV06_CLACPRO where id = @V_ID;
    delete TEMP_MPV06_CLAFCLI where id = @V_ID;
    delete TEMP_MPV06_CLAFPRO where id = @V_ID;
    delete TEMP_MPV06_SUFRAMA where id = @V_ID;
    delete TEMP_MPV06_TPPESSO where id = @V_ID;
    delete TEMP_MPV06_UFEMP where id = @V_ID;
    delete TEMP_MPV06_FAMILIA where id = @V_ID;
    delete TEMP_MPV06_MARCA where id = @V_ID;
    delete TEMP_MPV06_TPPROD where id = @V_ID;
    delete TEMP_MPV06_PRODUTO where id = @V_ID;
    delete TEMP_MPV06_TPPED where id = @V_ID;
    delete TEMP_MPV06_OPERACA where id = @V_ID;
    delete TEMP_MPV06_CIDADE where id = @V_ID;
    delete TEMP_MPV06_EMPRESA where id = @V_ID;
    delete TEMP_MPV06_CLACCLI where id = @V_ID;
    delete TEMP_MPV06_LPRECO where id = @V_ID;
    delete TEMP_MPV06_CLIENTE where id = @V_ID;
    delete TEMP_MPV06_RAMO where id = @V_ID;
    delete TEMP_MPV06_ESTADO where id = @V_ID;
    delete TEMP_MPV06_ATRIBUT where id = @V_ID;
    delete TEMP_MPV06_CLIOPTSIMPLES where id = @V_ID;

end catch
  
end
GO
