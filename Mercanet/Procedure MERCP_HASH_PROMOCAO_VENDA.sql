SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_HASH_PROMOCAO_VENDA] (@PEVENTO     INT, -- 01
											@P_CODIGO    varchar(20), -- 02
											@P_SEQ       INT, -- 03
											@P_DTVALINI  DATE, -- 04
											@P_DTVALFIN  DATE, -- 05
											@P_EMPRESA   VARCHAR(1024), -- 06
											@P_UF_ORIG   VARCHAR(1024), -- 07
											@P_UF_DEST   VARCHAR(1024), -- 08
											@P_PRODUTO   VARCHAR(1024), -- 09
											@P_TPPROD    VARCHAR(1024), -- 10
											@P_MARCA     VARCHAR(1024), -- 11
											@P_FAMILIA   VARCHAR(1024), -- 12
											@P_GRUPO     VARCHAR(1024), -- 13
											@P_CLIENTE   varchar(1024), -- 14
											@P_RAMO      VARCHAR(1024), -- 15
											@P_OPERACAO  VARCHAR(1024), -- 16
											@P_TPPESSOA  VARCHAR(1024), -- 17
											@P_SUFRAMA   INT, -- 18
											@P_CLASSPRD  VARCHAR(1024), -- 19
											@P_TPVDAPRD  varchar(1024), -- 20
											@P_FATUR     INT, -- 21
											@P_CLASSFIS  VARCHAR(1024), -- 22
											@P_CLASSFCLI VARCHAR(1024), -- 23
											@P_CIDADE    VARCHAR(1024), -- 24
											@P_CONTRIB   VARCHAR(1024), -- 25
											@P_LPRECO    VARCHAR(1024), -- 26
											@P_TPPED     VARCHAR(1024), -- 27
											@P_CLICCOM   VARCHAR(1024), -- 28
											@P_TXICMS    INT, -- 29
											@P_BASERED   INT, -- 30
											@P_PESO      INT, -- 31
											@PTIPO_frete VARCHAR(1024), -- 32 tipo frete
                                    
											------- promocao
                                    
											@PDB_TBCV_REPRES   VARCHAR(1024), --33
											@PDB_TBCV_RAMOII   VARCHAR(1024), --34   
											@PDB_TBCV_CPGTO    VARCHAR(1024), --35                              
											@PDB_TBCV_AREAATU  VARCHAR(1024), --36
											@PDB_TBCV_OPERLOG  VARCHAR(1024), --37                                 
											@pdb_tbcvp_qtdemax INT, --38
											@pdb_tbcvp_qtdemin INT, --39                                
											@pdb_tbcvp_pedmin  INT, --40
											@pDB_TBPRM_RVALPDV INT, --41   
											@p_regcom          VARCHAR(1024), --42
											@p_laborator       VARCHAR(1024), --43                 
											@p_referp          VARCHAR(1024), --44
                                    
											@pdb_tbprmd_pcomix   INT, --45
											@PDB_TBPRM_LSTMIXV   VARCHAR(1024), --46
											@pdb_tbprmd_precoliq INT, --47
											@pdb_tbprmd_bonif    FLOAT, --48
											@pDB_TBPRM_bonqtd    FLOAT, --49
											@pdb_tbprmd_boisnullr   FLOAT, --50
											@pdb_tbprmd_partic   FLOAT, --51
											@pdb_tbprmd_partmix  FLOAT, --52
											@pDB_TBPRM_acrvlr    FLOAT, --53
											@pdb_tbprmd_valmin   FLOAT, --54
											@pdb_tbprmd_valmax   FLOAT, --55
											@pDB_TBPRM_aplic_aut INT, --56
											@pdb_tbprmd_diaini   INT, --57
											@pdb_tbprmd_diafin   INT, --58                             
											@pDB_TBPRM_aprescli  FLOAT, --59
											@pDB_TBPRM_diasmais  INT, --60
											@pdb_tbprmd_desconto FLOAT, --61
											@pDB_TBPRM_aplic_ol  INT, --62
											@pDB_TBPRM_mixvda    FLOAT, --63
											@p_id                INT,
											@pDB_TBPRM_prodprm   varchar(1024),
											@pdb_tbprm_ind_dcto	 int,
											@pDB_TBPRM_DCTQTDMUL int,
											@pDB_TBPRM_PPARTIC   int,
											@pDB_TBPRM_CLICONTR  int,
											@pDB_TBPRM_DTPEDVAL  int,
											@pDB_TBPRM_APL_OLCli int,
											@pdb_tbprm_tipo      int,
											@pDB_TBPRM_PRODFORA   nvarchar(1024),
											@pDb_TbPrm_ForcaVendas nvarchar(255)
                                    
											) AS

  declare @VOBJETO VARCHAR(200) = 'MERCP_HASH_PROMOCAO_VENDA';
  declare @VERRO   VARCHAR(1000);
  declare @VDATA   DATE = getdate();
 
  declare @VLISTA_RESTRICAO nVARCHAR(2000) = '';
  declare @VSQL             nVARCHAR(4000);
  declare @VHASH            VARCHAR(200);
  declare @VCODIGO_ATRIBUTO nVARCHAR(25);
  declare @VINSERE          INT = 1;
  declare @PPF01_SEQ        INT;
  declare @PPV04_CONTROLE   INT;
  declare @V_COUNT          INT;
  declare @VCONTADOR        INT;
  declare @VVALOR_ATRIBUTO  nVARCHAR(255);
  declare @v_produto_temp   VARCHAR(1024) = '';

  declare @V_FROM             nVARCHAR(4000) = '';
  declare @V_WHERE            nVARCHAR(4000) = '';
  declare @V_RESTRICAO_SELECT nVARCHAR(4000) = '';
  declare @v_insert_mpv06     nVARCHAR(4000) = '';
  declare @V_SEQ              INT;
  declare @v_delete           VARCHAR(5000);
  declare @V_ATRIBUTO         nVARCHAR(1000) = '';
  declare @V_ID               INT;
  declare @V_AUX			  int;
  declare @vdb_tbprma_atrib   nvarchar(50);
  declare @vdb_tbprma_valor   nvarchar(50);
  DECLARE @vqtde_lst_ATRIBUTO   int;     
DECLARE @V_QUANTIDADE		  int;   
DECLARE @V_VALOR_PARTE		  nVARCHAR(255) = '';
DECLARE @V_EXISTE			  int;
DECLARE @V_PRIMEIRA			  bit = 1;
DECLARE @v_qtde_lista_anterior   int;    
declare @V_AUX2               int;
declare @v_grava_prod		  varchar(1024);
declare @v_cod_mix            int;
declare @v_sql_mix            nvarchar(1024) = '';
declare @V_AT02_ORIGEM	      numeric;
declare @v_mix_produto_fora_promocao   varchar(8) = '';

  ------------------------------------------------------------
  --- VERSAO   DATA        AUTOR            ALTERACAO
  --- 1.00001  11/02/2012  ALENCAR/TIAGO    DESENVOLVIMENTO - ROTINA QUE GERA HASH PARA A TABELA DB_MRG_PRES_ITEM - CADASTRO DE SUBSTITUICAO TRIBUTARIA
  --- 1.00002  23/08/2013  TIAGO            SE EXISTE MIX CADASTRADO UPDATA OS CAMPOS DE DATA
  --- 1.00003  26/12/2013  Alencar          Grava o hash do atributo com ATP (produto) ou ATC (cliente)
  --- 1.0004   04/09/2014  tiago            grava mix para produtos fora da promocao
  --- 1.0005   26/02/2016  tiago            incluido novo campo forcavendas
  --- 1.0007   20/06/2016  tiago            passa a gravar em branco caso campo v_mix_produto_fora_promocao nao encontre um codigo  
  ------------------------------------------------------------
  set nocount on
BEGIn

begin try



  set @VSQL      = 'SELECT PV04_CONTROLE FROM MPV04 WHERE 1=1 ';
  set @VCONTADOR = 1;

  set @V_ID = @p_id;

  IF isnull(@P_UF_DEST, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'ESTADO,';
    set @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                            cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''ESTADO'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_UF_DEST + '#';
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' ESTADO.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + ' TEMP_MPV06_ESTADO ESTADO,';
    set @V_WHERE            = @V_WHERE + ' ESTADO.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  END

  IF isnull(@P_RAMO, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'RAMO,';
    set @VSQL             = @VSQL +
                            ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                            cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''RAMO'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_RAMO + '#';
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + 'RAMO.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_RAMO RAMO ,';
    set @V_WHERE            = @V_WHERE + ' RAMO.ID = ' + cast(@V_ID as varchar) + ' AND ';
  END

  IF isnull(@P_CLIENTE, '') <> ''
  begin
    set @VLISTA_RESTRICAO   = @VLISTA_RESTRICAO + 'CLIENTE,';
    set @VSQL               = @VSQL +
                             ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                             cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''CLIENTE'')';
    set @VCONTADOR          = @VCONTADOR + 1;
    --set @VHASH              = @VHASH + @P_CLIENTE + '#';
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' CLIENTE.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + ' TEMP_MPV06_CLIENTE CLIENTE,';
    set @V_WHERE            = @V_WHERE + ' CLIENTE.ID = ' + cast(@V_ID as varchar) + ' AND ';
  END

  IF isnull(@P_LPRECO, '') <> '' 
  begin
    set @VLISTA_RESTRICAO   = @VLISTA_RESTRICAO + 'LPRECO,';
    set @VSQL               = @VSQL +
                             ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                              cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''LPRECO'')';
    set @VCONTADOR          = @VCONTADOR + 1; 
    --set @VHASH              = @VHASH + @P_LPRECO + '#';
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +   ' LPRECO.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + ' TEMP_MPV06_LPRECO LPRECO, ';
    set @V_WHERE            = @V_WHERE + ' LPRECO.ID = ' + cast(@V_ID as varchar) + ' AND ';
  END

  IF isnull(@PDB_TBCV_REPRES, '') <> '' 
  begin
    set @VLISTA_RESTRICAO   = @VLISTA_RESTRICAO + 'REPRES,';
    set @VSQL               = @VSQL +
                              ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                              cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''REPRES'')';
    set @VCONTADOR          = @VCONTADOR + 1;
    --set @VHASH              = @VHASH + @PDB_TBCV_REPRES + '#';
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' REPRES.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + ' TEMP_MPV06_REPRES REPRES, ';
    set @V_WHERE            = @V_WHERE + ' REPRES.ID = ' + cast(@V_ID as varchar) + ' AND ';
  END

  IF isnull(@P_CLICCOM, '') <> ''
  begin 
    set @VLISTA_RESTRICAO   = @VLISTA_RESTRICAO + 'CLASCOMCLI,';
    set @VSQL               = @VSQL +
                              ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                              cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''CLASCOMCLI'')';
    set @VCONTADOR          = @VCONTADOR + 1;
    --set @VHASH              = @VHASH + @P_CLICCOM + '#';
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + 'CLASCOMCLI.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_CLACCLI CLASCOMCLI,';
    set @V_WHERE            = @V_WHERE + ' CLASCOMCLI.ID = ' + cast(@V_ID as varchar) + ' AND ';
  END

  IF isnull(@P_EMPRESA, '') <> '' 
  begin
    set @VLISTA_RESTRICAO   = @VLISTA_RESTRICAO + 'EMPRESA,';
    set @VSQL               = @VSQL +
                              ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                               cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''EMPRESA'')';
    set @VCONTADOR          = @VCONTADOR + 1;
    --set @VHASH              = @VHASH + @P_EMPRESA + '#';
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' EMPRESA.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_EMPRESA EMPRESA,';
    set @V_WHERE            = @V_WHERE + ' EMPRESA.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  END

  IF isnull(@p_regcom, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'REGIAOCOM,';
    set @VSQL             = @VSQL +
                            ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                            cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''REGIAOCOM'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @p_regcom + '#';
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' REGIAOCOM.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_REGCOM REGIAOCOM,';
    set @V_WHERE            = @V_WHERE + ' REGIAOCOM.ID = ' + cast(@V_ID as varchar) + ' AND ';
  END

  IF isnull(@PDB_TBCV_RAMOII, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'RAMOII,';
    set @VSQL             = @VSQL +
                            ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                            cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''RAMOII'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @PDB_TBCV_RAMOII + '#';
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' RAMOII.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_RAMOII RAMOII,';
    set @V_WHERE            = @V_WHERE + ' RAMOII.ID = ' + cast(@V_ID as varchar) + ' AND ';
  END

  IF isnull(@P_CIDADE, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CIDADE,';
    set @VSQL             = @VSQL +
                            ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                            cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''CIDADE'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_CIDADE + '#';

    exec dbo.MERCP_INSERE_MPV06_TEMP 'CIDADE', @P_CIDADE, @V_ID

    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' CIDADE.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_CIDADE CIDADE,';
    set @V_WHERE            = @V_WHERE + ' CIDADE.ID = ' + cast(@V_ID as varchar)+ ' AND ';
  
  END

  IF isnull(@P_OPERACAO, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'OPERACAO,';
    set @VSQL             = @VSQL +
                           ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                           cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''OPERACAO'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_OPERACAO + '#';
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' OPERACAO.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_OPERACA OPERACAO,';
    set @V_WHERE            = @V_WHERE + 'OPERACAO.ID = ' + cast(@V_ID as varchar) + ' AND ';
  END

  IF isnull(@P_TPPED, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPPED,';
    set @VSQL             = @VSQL +
                            ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                            cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''TPPED'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_TPPED + '#';
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + 'TPPED.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_TPPED TPPED,';
    set @V_WHERE            = @V_WHERE + ' TPPED.ID = ' + cast(@V_ID as varchar) + ' AND ';
  END

  /*     IF isnull(@PDB_TBCV_CPGTO, '') <> '' 
   @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CONDPGTO,';
   @VSQL             = @VSQL +
                       ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                       @VCONTADOR + ' AND PV05_TAGFILTRO = ''CONDPGTO'')';
   @VCONTADOR        = @VCONTADOR + 1;
   @VHASH            = @VHASH + @PDB_TBCV_CPGTO + '#';
  END
   */
  IF isnull(@PDB_TBCV_AREAATU, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'AREAATU,';
    set @VSQL             = @VSQL +
                            ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                            cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''AREAATU'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @PDB_TBCV_AREAATU + '#';
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' AREAATU.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_AREAATU AREAATU,';
    set @V_WHERE            = @V_WHERE + ' AREAATU.ID = ' + cast(@V_ID as varchar) + ' AND ';
  END

  -- se o campo pDB_TBPRM_RVALPDV = 1
  -- pv06_produto recebe o valor do produto do grid, o hash so é gerado com o produto se o campo DB_TBPRM_prodprm tiver valor
  -- se o campo pDB_TBPRM_RVALPDV = 0
  -- gera o hash com o produto do grid
 
  IF (isnull(@P_PRODUTO, '') <> '' or isnull(@pDB_TBPRM_prodprm, '') <> '') and @pdb_tbprm_tipo = 1
  begin

 
	if @pDB_TBPRM_RVALPDV = 0
	begin

		if isnull(@P_PRODUTO, '') <> ''
		begin

			set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'PRODUTO,';
			set @VSQL             = @VSQL +
								   ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''PRODUTO'')';
			set @VCONTADOR        = @VCONTADOR + 1;
			--set @VHASH            = @VHASH + @P_PRODUTO + '#';
  
			exec dbo.MERCP_INSERE_MPV06_TEMP 'PRODUTO', @P_PRODUTO, @V_ID
			set  @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' PRODUTO.VALOR + ''#'' + ';
			set @V_FROM             = @V_FROM + 'TEMP_MPV06_PRODUTO PRODUTO,';
			set @V_WHERE            = @V_WHERE + ' PRODUTO.ID = ' + casT(@V_ID as varchar) + ' AND ';
		end
		else
		if isnull(@pDB_TBPRM_prodprm, '') <> ''
		begin

			set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'PRODUTO,';
			set @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
								     cast(@VCONTADOR as varchar) +	' AND PV05_TAGFILTRO = ''PRODUTO'')';
			set @VCONTADOR        = @VCONTADOR + 1;
			--VHASH            := VHASH || P_PRODUTO || '#';
      
			exec dbo.MERCP_INSERE_MPV06_TEMP 'PRODUTO', @pDB_TBPRM_prodprm, @V_ID

			set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' PRODUTO.VALOR + ''#'' + ';
			set @V_FROM             = @V_FROM + 'TEMP_MPV06_PRODUTO PRODUTO,';
			set @V_WHERE            = @V_WHERE + ' PRODUTO.ID = ' + cast(@V_ID as varchar) + ' AND ';


		end

	


	end
	else
	if @pDB_TBPRM_RVALPDV = 1
	begin

		  set @v_grava_prod = @P_PRODUTO;
    
		  if isnull(@pDB_TBPRM_prodprm, '') <> ''
		  begin
			set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'PRODUTO,';
			set @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
								     cast(@VCONTADOR as varchar) +	' AND PV05_TAGFILTRO = ''PRODUTO'')';
			set @VCONTADOR        = @VCONTADOR + 1;
			--VHASH            := VHASH || P_PRODUTO || '#';
      
			exec dbo.MERCP_INSERE_MPV06_TEMP 'PRODUTO', @pDB_TBPRM_prodprm, @V_ID

			set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' PRODUTO.VALOR + ''#'' + ';
			set @V_FROM             = @V_FROM + 'TEMP_MPV06_PRODUTO PRODUTO,';
			set @V_WHERE            = @V_WHERE + ' PRODUTO.ID = ' + cast(@V_ID as varchar) + ' AND ';
      
		  end

	end

  ENd
  else
  begin

	if isnull(@PDB_TBPRM_LSTMIXV, '') <> '' or @PDB_TBPRM_LSTMIXV <> 0
    begin
      
      set @v_cod_mix = @PDB_TBPRM_LSTMIXV;

	    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'PRODUTO,';
		set @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									cast(@VCONTADOR as varchar) +	' AND PV05_TAGFILTRO = ''PRODUTO'')';
		set @VCONTADOR        = @VCONTADOR + 1;
		--VHASH            := VHASH || P_PRODUTO || '#';
      
		exec dbo.MERCP_INSERE_MPV06_TEMP 'PRODUTO', @pDB_TBPRM_prodprm, @V_ID

		set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' PRODUTO.VALOR + ''#'' + ';
		set @V_FROM             = @V_FROM + 'TEMP_MPV06_PRODUTO PRODUTO,';
		set @V_WHERE            = @V_WHERE + ' PRODUTO.ID = ' + cast(@V_ID as varchar) + ' AND ';



    end
    else
    begin
      --se for uma lista de produtos grava o mix do produto
      if charindex(',', @P_PRODUTO) <> 0
      begin
        set @V_COUNT = len(@P_PRODUTO) - len(replace(@P_PRODUTO, ',', '')) + 1;
      
        --- busca todos os mixes da lista de produtos e que possuem somente os itens da lista, ou seja, 
        --- busca um mix completo com todos os produtos e somente eles.
        
         
        set @v_sql_mix = 
		     'select a.db_tbmvp_codigo 
                from db_tb_mix_vendap  a
              where a.db_tbmvp_produto in (''' +
                    replace(replace(@P_PRODUTO, ' ', ''), ',', ''',''') + ''')
				 and DB_TBMV_LIVRE = 4
                 and (select count(1)
                        from db_tb_mix_vendap  b
                       where b.db_tbmvp_codigo = a.db_tbmvp_codigo) = ' +
                     cast(@V_COUNT as nvarchar) + '
              group by a.db_tbmvp_codigo
              having count(1) = ' + cast(@V_COUNT as nvarchar);
		

	  create table #temp ( codigo    int);
      set @v_cod_mix = 0; 
	 
	  insert into #temp  exec sp_executeSQL @v_sql_mix 

      select @v_cod_mix = codigo from #temp

	  drop table #temp
	
        -- se mix = 0 nao encontrou nenhum mix para os produtos passados, cria um novo mix
        if @v_cod_mix = 0
        begin

          select @v_cod_mix = isnull(max(cast(DB_TBMV_CODIGO as int)), 0) + 1
            from db_tb_mix_venda;

          insert into db_tb_mix_venda
            (DB_TBMV_CODIGO,
             DB_TBMV_DESCR,
             DB_TBMV_DTVI,
             DB_TBMV_DTVF,
             DB_TBMV_NROITENS,             
             DB_TBMV_TIPO,
             DB_TBMV_LIVRE,
             DB_TBMV_QTDEMIN,
             DB_TBMV_QTDEMAX,
             DB_TBMV_VLRMIN,
             DB_TBMV_MULTIP,
             DB_TBMV_ESPEC,
             DB_TBMV_DESCTOMAX,
             DB_TBMV_PERCBONIF,
             DB_TBMV_AVALBONIF,
             DB_TBMV_VALDESCTO,
             DB_TBMV_PESO,
             DB_TBMV_APLICA_AUT,
             DB_TBMV_POLREP,
             DB_TBMV_TFRETE)
          values
            (@v_cod_mix,
             'Mix de Vendas',
             CONVERT(DATETIME, '01-01-2000', 103),--@P_DTVALINI,
             CONVERT(DATETIME, '31-12-2099', 103),--@P_DTVALFIN,
             1,
             0,
             4,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0);
        
		  set @V_AUX = 1

		  while @V_AUX <= @V_COUNT
		  begin
                    
            insert into db_tb_mix_vendap
              (DB_TBMVP_CODIGO,
               DB_TBMVP_SEQ,
               DB_TBMVP_PRODUTO,
               DB_TBMVP_QTDEMIN,
               DB_TBMVP_QTDEMAX,
               DB_TBMVP_QTDEVDA,
               DB_TBMVP_QTDEBNF,
               DB_TBMVP_CPGTO,
               DB_TBMVP_TIPO,
               DB_TBMVP_SUBPROD,
               DB_TBMVP_DCTOVDA,
               DB_TBMVP_DCTOBONIF,
               DB_TBMVP_LPRECO,
               DB_TBMVP_NROITENS)
            values
              (@v_cod_mix,
               @V_AUX,
               dbo.mercf_piece(@P_PRODUTO, ',', @V_AUX),
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0);
          
			set @V_AUX = @V_AUX + 1

          end -- fim do laço
        
        end
		else
		begin

			update db_tb_mix_venda
			   set DB_TBMV_DTVI = CONVERT(DATETIME, '01-01-2000', 103),--@P_DTVALINI, 
				   DB_TBMV_DTVF = CONVERT(DATETIME, '31-12-2099', 103)--@P_DTVALFIN
			 where DB_TBMV_CODIGO = @v_cod_mix;
			 
		end

		set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'PRODUTO,';
		set @VSQL             = @VSQL + ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
								    cast(@VCONTADOR as varchar) +	' AND PV05_TAGFILTRO = ''PRODUTO'')';
		set @VCONTADOR        = @VCONTADOR + 1;
		--VHASH            := VHASH || P_PRODUTO || '#';
      
		exec dbo.MERCP_INSERE_MPV06_TEMP 'PRODUTO', @P_PRODUTO, @V_ID

		set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' PRODUTO.VALOR + ''#'' + ';
		set @V_FROM             = @V_FROM + 'TEMP_MPV06_PRODUTO PRODUTO,';
		set @V_WHERE            = @V_WHERE + ' PRODUTO.ID = ' + cast(@V_ID as varchar) + ' AND ';

        
      end
      else
	  begin
        -- se nao tem lista para o produto
		if isnull(@P_PRODUTO, '') <> ''
		begin
			set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'PRODUTO,';
			set @VSQL             = @VSQL +
								   ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''PRODUTO'')';
			set @VCONTADOR        = @VCONTADOR + 1;
			--set @VHASH            = @VHASH + @P_PRODUTO + '#';
  
			exec dbo.MERCP_INSERE_MPV06_TEMP 'PRODUTO', @P_PRODUTO, @V_ID
			set  @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' PRODUTO.VALOR + ''#'' + ';
			set @V_FROM             = @V_FROM + 'TEMP_MPV06_PRODUTO PRODUTO,';
			set @V_WHERE            = @V_WHERE + ' PRODUTO.ID = ' + casT(@V_ID as varchar) + ' AND ';
		end
	
      
      end
    
    end --- fim do pdb_tbprm_lstmixv is not null

	
	

  end




  IF isnull(@P_TPPROD, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TIPOPROD,';
    set @VSQL             = @VSQL +
                            ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                            cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''TIPOPROD'')';
    set  @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_TPPROD + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'TPPROD', @P_TPPROD, @V_ID

    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' TIPOPROD.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_TPPROD TIPOPROD,';
    set @V_WHERE            = @V_WHERE + ' TIPOPROD.ID = ' + cast(@V_ID as varchar) + ' AND ';
  END

  IF isnull(@P_MARCA, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'MARCA,';
    set @VSQL             = @VSQL +
                            ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                            cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''MARCA'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_MARCA + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'MARCA', @P_MARCA, @V_ID

    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' MARCA.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_MARCA MARCA ,';
    set @V_WHERE            = @V_WHERE + ' MARCA.ID = ' + cast(@V_ID as varchar) + ' AND ';
  END

  IF isnull(@P_FAMILIA, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'FAMILIA,';
    set @VSQL             = @VSQL +
                        ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                        cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''FAMILIA'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_FAMILIA + '#';
    exec dbo.MERCP_INSERE_MPV06_TEMP 'FAMILIA', @P_FAMILIA, @V_ID

    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' FAMILIA.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_FAMILIA FAMILIA,';
    set @V_WHERE            = @V_WHERE + ' FAMILIA.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  END

  IF isnull(@P_UF_ORIG, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'UFEMP,';
    set @VSQL             = @VSQL +
                            ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                            cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''UFEMP'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_UF_ORIG + '#';
    exec dbo.MERCP_INSERE_MPV06_TEMP 'UFEMP', @P_UF_ORIG, @V_ID

    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' UFEMP.VALOR + ''#'' + ';
	set @V_FROM             = @V_FROM + 'TEMP_MPV06_UFEMP UFEMP,';
    set @V_WHERE            = @V_WHERE + ' UFEMP.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  END

  IF isnull(@P_TPPESSOA, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPPESSOA,';
    set @VSQL             = @VSQL +
                            ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                            cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''TPPESSOA'')';
    set  @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_TPPESSOA + '#';
    exec dbo.MERCP_INSERE_MPV06_TEMP 'TPPESSO', @P_TPPESSOA, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          'TPPESSOA.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_TDPESSOA TPPESSOA,';
    set @V_WHERE            = @V_WHERE + ' TPPESSOA.ID =  ' + cast(@V_ID as varchar) + ' AND ';
  
  END

  IF isnull(@P_SUFRAMA, -1) NOT IN (-1, 0) 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'SUFRAMA,';
    set  @VSQL             = @VSQL +
                             ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                             cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''SUFRAMA'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_SUFRAMA + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'SUFRAMA', @P_SUFRAMA, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' SUFRAMA.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_SUFRAMA SUFRAMA,';
    set @V_WHERE            = @V_WHERE + ' SUFRAMA.ID = ' + cast(@V_ID as varchar) + ' AND';
  END

  IF isnull(@P_CLASSFIS, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASFISPROD,';
    set @VSQL             = @VSQL +
                        ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                          cast(@VCONTADOR as varchar) +
                        ' AND PV05_TAGFILTRO = ''CLASFISPROD'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_CLASSFIS + '#';
    exec dbo.MERCP_INSERE_MPV06_TEMP 'CLAFPRO', @P_CLASSFIS, @V_ID

    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' CLASFISPROD.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_CLASFISPROD CLASFISPROD,';
    set @V_WHERE            = @V_WHERE + ' CLASFISPROD.ID = ' + cast(@V_ID as varchar) + ' and';
  
  END

  IF isnull(@P_CLASSFCLI, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASFISCLI,';
    set @VSQL             = @VSQL +
                        ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                        cast(@VCONTADOR as varchar) +
                        ' AND PV05_TAGFILTRO = ''CLASFISCLI'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_CLASSFCLI + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'CLASFISCLI', @P_CLASSFCLI, @V_ID
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' CLASFISCLI.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + ' TEMP_MPV06_CLASFISCLI CLASFISCLI,';
    set @V_WHERE            = @V_WHERE + ' CLASFISCLI.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  END

  IF isnull(@P_CLASSPRD, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASCOMPROD,';
    set @VSQL             = @VSQL +
                        ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                        cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''CLASCOMPROD'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_CLASSPRD + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'CLACPRO', @P_CLASSPRD, @V_ID

    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' CLASCOMPROD.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_CLASCOMPROD CLASCOMPROD,';
    set @V_WHERE            = @V_WHERE + ' CLASCOMPROD.ID = ' + cast(@V_ID as varchar) + ' and';
  
  END

  IF isnull(@P_FATUR, -1) <> -1 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPFATUR,';
    set @VSQL             = @VSQL +
                        ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                        cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''TPFATUR'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_FATUR + '#';
    exec dbo.MERCP_INSERE_MPV06_TEMP 'TPFATUR', @P_FATUR, @V_ID

    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' TPFATUR.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_TPFATUR TPFATUR ,';
    set @V_WHERE            = @V_WHERE + ' TPFATUR.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  END

  IF isnull(@PTIPO_frete, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TIPOFRETE,';
    set @VSQL             = @VSQL +
                        ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                        cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''TIPOFRETE'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @PTIPO_frete + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'TPFRETE', @PTIPO_frete, @V_ID

    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' TIPOFRETE.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_TPFRETE TIPOFRETE ,';
    set @V_WHERE            = @V_WHERE + ' TIPOFRETE.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  END

  IF isnull(@PDB_TBCV_OPERLOG, '') <> '' 
  begin
    set @VLISTA_RESTRICAO   = @VLISTA_RESTRICAO + 'OPERLOG,';
    set @VSQL               = @VSQL +
                          ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                          cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''OPERLOG'')';
    set @VCONTADOR          = @VCONTADOR + 1;
    --set @VHASH              = @VHASH + @PDB_TBCV_OPERLOG + '#';
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' OPERLOG.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_OPERLOG OPERLOG,';
    set @V_WHERE            = @V_WHERE + ' OPERLOG.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  END

  IF isnull(@p_laborator, '') <> '' 
  begin
    set @VLISTA_RESTRICAO   = @VLISTA_RESTRICAO + 'LABOROL,';
    set @VSQL               = @VSQL +
                          ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                          cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''LABOROL'')';
    set @VCONTADOR          = @VCONTADOR + 1;
    --set @VHASH              = @VHASH + @p_laborator + '#';
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' LABOROL.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_LABOROL LABOROL,';
    set @V_WHERE            = @V_WHERE + ' LABOROL.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  END

  IF isnull(@p_referp, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'REFERPROD,';
    set @VSQL             = @VSQL +
                        ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                        cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''REFERPROD'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @p_referp + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'REFERPR', @p_referp, @V_ID
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' REFERPROD.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_REFERPR REFERPROD, ';
    set @V_WHERE            = @V_WHERE + ' REFERPROD.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  END

  IF isnull(@P_GRUPO, '') <> '' 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'GRUPOPROD,';
    set @VSQL             = @VSQL +
                        ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                        cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''GRUPOPROD'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_GRUPO + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'GRUPROD', @P_GRUPO, @V_ID
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          'GRUPROD.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_GRUPROD GRUPROD,';
    set @V_WHERE            = @V_WHERE + ' GRUPROD.ID = ' + cast(@V_ID as varchar) + '  AND ';
  
  END

  IF isnull(@P_TPVDAPRD, -1) <> -1 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPVENDA,';
    set @VSQL             = @VSQL +
                        ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                        cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''TPVENDA'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    --set @VHASH            = @VHASH + @P_TPVDAPRD + '#';
  
    exec dbo.MERCP_INSERE_MPV06_TEMP 'TPVENDA', @P_TPVDAPRD, @V_ID
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' TPVENDA.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_TPVENDA TPVENDA, ';
    set @V_WHERE            = @V_WHERE + ' TPVALOR.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  END

  IF isnull(@P_CONTRIB, '') NOT IN ('', 'A') 
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CONTRIBUINTE,';
    set @VSQL             = @VSQL +
                        ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                        cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''CONTRIBUINTE'')';
    set @VCONTADOR        = @VCONTADOR + 1;
    IF @P_CONTRIB = 'N'      
      exec dbo.MERCP_INSERE_MPV06_TEMP 'CONTRIB', '0', @V_ID
    ELSE    
      exec dbo.MERCP_INSERE_MPV06_TEMP 'CONTRIB', '0', @V_ID
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' CONTRIBUIENTE.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_CONTRIB CONTRIBUINTE,';
    set @V_WHERE            = @V_WHERE + ' CONTRIBUINTE.ID = ' + cast(@V_ID as varchar) + ' and';
  
  END




   IF isnull(@pDb_TbPrm_ForcaVendas, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'FORCAVENDAS,';
    set @VSQL             = @VSQL +
                        ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
                        cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''FORCAVENDAS'')';
    set @VCONTADOR        = @VCONTADOR + 1;
   
  
    set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
                          ' FORCAVENDAS.VALOR + ''#'' + ';
    set @V_FROM             = @V_FROM + 'TEMP_MPV06_FORCAVENDAS FORCAVENDAS, ';
    set @V_WHERE            = @V_WHERE + ' FORCAVENDAS.ID = ' + cast(@V_ID as varchar) + ' AND ';
  
  END


	  if  isnull(@pDB_TBPRM_PRODFORA, '') <> ''
	  begin
	
		set @V_COUNT = len(@pDB_TBPRM_PRODFORA) - len(replace(@pDB_TBPRM_PRODFORA, ',', '')) + 1;

		
		print '@pDB_TBPRM_PRODFORA ; ' + @pDB_TBPRM_PRODFORA
		set @v_sql_mix = 
					 'select a.db_tbmvp_codigo 
						from db_tb_mix_vendap  a
					  where a.db_tbmvp_produto in (''' +
							 replace(replace(@pDB_TBPRM_PRODFORA, ' ', ''), ',', ''',''') + ''')
						 and DB_TBMV_LIVRE = 4
						 and (select count(1)
								from db_tb_mix_vendap  b
							   where b.db_tbmvp_codigo = a.db_tbmvp_codigo) = ' +
							 cast(@V_COUNT as nvarchar) + '
					  group by a.db_tbmvp_codigo
					  having count(1) = ' + cast(@V_COUNT as nvarchar);
      
					print 'v_sql_mix fora promocao... = ' + @v_sql_mix

				  create table #temp_PROD ( codigo    int);
				  set @v_mix_produto_fora_promocao = '0'; 

				  insert into #temp_PROD  exec sp_executeSQL @v_sql_mix 
   
				  select @v_mix_produto_fora_promocao = codigo from #temp_PROD

				  drop table #temp_PROD
        -- se mix = 0 nao encontrou nenhum mix para os produtos passados, cria um novo mix
        if @v_mix_produto_fora_promocao = '0'
        begin


			  select @v_mix_produto_fora_promocao = isnull(max(cast(DB_TBMV_CODIGO as int)), 0) + 1
				from db_tb_mix_venda;

			  insert into db_tb_mix_venda
				(DB_TBMV_CODIGO,
				 DB_TBMV_DESCR,
				 DB_TBMV_DTVI,
				 DB_TBMV_DTVF,
				 DB_TBMV_NROITENS,             
				 DB_TBMV_TIPO,
				 DB_TBMV_LIVRE,
				 DB_TBMV_QTDEMIN,
				 DB_TBMV_QTDEMAX,
				 DB_TBMV_VLRMIN,
				 DB_TBMV_MULTIP,
				 DB_TBMV_ESPEC,
				 DB_TBMV_DESCTOMAX,
				 DB_TBMV_PERCBONIF,
				 DB_TBMV_AVALBONIF,
				 DB_TBMV_VALDESCTO,
				 DB_TBMV_PESO,
				 DB_TBMV_APLICA_AUT,
				 DB_TBMV_POLREP,
				 DB_TBMV_TFRETE)
			  values
				(@v_mix_produto_fora_promocao,
				 'Fora da Promoção',
				 CONVERT(DATETIME, '01-01-2000', 103),--@P_DTVALINI,
                 CONVERT(DATETIME, '31-12-2099', 103),--@P_DTVALFIN,
				 1,
				 0,
				 4,
				 0,
				 0,
				 0,
				 0,
				 0,
				 0,
				 0,
				 0,
				 0,
				 0,
				 0,
				 0,
				 0);
        
			  set @V_AUX = 1

			  while @V_AUX <= @V_COUNT
			  begin
                    
				insert into db_tb_mix_vendap
				  (DB_TBMVP_CODIGO,
				   DB_TBMVP_SEQ,
				   DB_TBMVP_PRODUTO,
				   DB_TBMVP_QTDEMIN,
				   DB_TBMVP_QTDEMAX,
				   DB_TBMVP_QTDEVDA,
				   DB_TBMVP_QTDEBNF,
				   DB_TBMVP_CPGTO,
				   DB_TBMVP_TIPO,
				   DB_TBMVP_SUBPROD,
				   DB_TBMVP_DCTOVDA,
				   DB_TBMVP_DCTOBONIF,
				   DB_TBMVP_LPRECO,
				   DB_TBMVP_NROITENS)
				values
				  (@v_mix_produto_fora_promocao,
				   @V_AUX,
				   dbo.mercf_piece(@pDB_TBPRM_PRODFORA, ',', @V_AUX),
				   0,
				   0,
				   0,
				   0,
				   0,
				   0,
				   0,
				   0,
				   0,
				   0,
				   0);
          
				set @V_AUX = @V_AUX + 1

			  end -- fim do laço
        
			end
			else
			begin

				update db_tb_mix_venda
				   set DB_TBMV_DTVI = @P_DTVALINI, 
					   DB_TBMV_DTVF = @P_DTVALFIN
				 where DB_TBMV_CODIGO = @v_mix_produto_fora_promocao;
			 
			end

		end
		
  --BUSCA SE EXISTE ALGUM VALOR NOS ATRIBUTOS

  
  DECLARE CUR_atributo CURSOR
	FOR SELECT db_tbprma_atrib, db_tbprma_valor
          FROM db_tb_promocao_atr
         WHERE isnull(db_tbprma_valor, '') <> ''
           AND db_tbprma_codigo = @P_CODIGO	    
		OPEN CUR_atributo
	   FETCH NEXT FROM CUR_atributo
		INTO @vdb_tbprma_atrib, @vdb_tbprma_valor
	WHILE @@FETCH_STATUS = 0
	   BEGIN

		    SELECT @V_AT02_ORIGEM = AT02_ORIGEM 
              FROM MAT02 
             WHERE AT02_ATRIB   = @vdb_tbprma_atrib
              AND AT02_TABELA  IN (2,3) -- Condicao e Item condicao

		    IF @V_AT02_ORIGEM = 1 -- CLIENTE
			begin		  
		        set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'ATC' + @vdb_tbprma_atrib + ',';
			
			    set @VSQL             = @VSQL +
				   				   ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
					 		    	cast(@VCONTADOR as varchar)+ ' AND PV05_TAGFILTRO = ''ATC' +  @vdb_tbprma_atrib + ''')';
			end
			else
		    begin
		        set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'ATP' + @vdb_tbprma_atrib + ',';
			
			    set @VSQL             = @VSQL +
				   				   ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
					 		    	cast(@VCONTADOR as varchar)+ ' AND PV05_TAGFILTRO = ''ATP' +  @vdb_tbprma_atrib + ''')';
			end
			
			set @VCONTADOR        = @VCONTADOR + 1;
    
			set @V_ATRIBUTO       = @V_ATRIBUTO + @vdb_tbprma_valor + '#'

	FETCH NEXT FROM CUR_atributo
	  INTO  @vdb_tbprma_atrib, @vdb_tbprma_valor
	  END
	  CLOSE CUR_atributo
	DEALLOCATE CUR_atributo


  set @VCONTADOR = @VCONTADOR - 1;

  --VALIDA O INDICE DE DESCONTO
  set @VSQL = @VSQL + ' AND PV04_INDDESCTO = ' + cast((isnull(@pdb_tbprm_ind_dcto, 0)) as varchar);

  set @VSQL = @VSQL + ' AND NOT EXISTS (SELECT 1 FROM MPV05 WHERE PV05_SEQ > ' +
              cast(@VCONTADOR as varchar) + ' AND PV05_CONTROLE = PV04_CONTROLE)';

  --RETIRA ULTIMA VIRGULA

  set @VLISTA_RESTRICAO = SUBSTRing(@VLISTA_RESTRICAO, 1,  (LEN(@VLISTA_RESTRICAO) - 1));
  

  create table #temp2 ( codigo    int);
    set @PPV04_CONTROLE = 0; 

	insert into #temp2  exec sp_executeSQL @VSQL 
   
    select @PPV04_CONTROLE = codigo from #temp2

	drop table #temp2

  --SE NAO EXISTIR CONTROLE COM RESTRICOES DEFINIDAS INSERE NAS 2 TABELAS OS REGISTROS (CAPA, ITENS)
  IF @PPV04_CONTROLE = 0 
  begiN

    SELECT @PPV04_CONTROLE = isnull(MAX(PV04_CONTROLE), 0) + 1 FROM MPV04;
  
    INSERT INTO MPV04
      (PV04_CONTROLE, PV04_TIPO, pv04_inddescto)
    VALUES
      (@PPV04_CONTROLE, 'I', isnull(@pdb_tbprm_ind_dcto, 0));
  
    set @V_AUX = 1
	
	while @V_AUX <= @VCONTADOR
	begin

	  INSERT INTO MPV05
        (PV05_CONTROLE, PV05_SEQ, PV05_TAGFILTRO)
      VALUES
        (@PPV04_CONTROLE, @V_AUX, dbo.MERCF_PIECE(@VLISTA_RESTRICAO, ',', @V_AUX));
		
	  set @V_AUX = @V_AUX + 1

	end
  
  END --- FIM IF CONTROLE = NULL

   set @VSQL = 'update mpv04 set pv04_peso =  (select isnull(sum(pv07_peso), 0) 
                  from mpv07 where pv07_tagfiltro in (''' + replace(@VLISTA_RESTRICAO, ',', ''',''') +
                    ''' )) where pv04_controle = ' + cast(@PPV04_CONTROLE as varchar);

					print '@VSQL = ' + @VSQL

  exec sp_executeSQL @VSQL

  set @V_AUX = 1
  set @V_AUX2 = 1
  set @V_SEQ = 1


  print '@V_ATRIBUTO = ' + @V_ATRIBUTO

  IF isnull(@V_ATRIBUTO, '') <> ''
  begin
  
    IF charindex(',', @V_ATRIBUTO) <> 0
	begin

		set @vqtde_lst_ATRIBUTO = 0;

	    set @vqtde_lst_ATRIBUTO = isnull(len(@V_ATRIBUTO) - len(replace(@V_ATRIBUTO, '#', '')), 0)

		while @V_AUX <= @vqtde_lst_ATRIBUTO
		begin
		     
			set @V_AUX2 = 1


			select  @V_VALOR_PARTE = dbo.mercf_piece (@V_ATRIBUTO, '#', @V_AUX)
      
            set @V_QUANTIDADE = isnull(len(@V_VALOR_PARTE) - len(replace(@V_VALOR_PARTE, ',', '')), 0) + 1

			while @V_AUX2 <= @V_QUANTIDADE
			begin        
        
				if @V_PRIMEIRA = 1
				begin
					insert into TEMP_MPV06_ATRIBUT	(id, seq, valor)
											values
													(@V_ID, @V_SEQ, dbo.mercf_piece(@V_VALOR_PARTE, ',', @V_AUX2) + '#');
					set @V_SEQ = @V_SEQ + 1;
				end
				else
				begin

					SELECT @V_SEQ = ISNULL(MAX(SEQ), 1) FROM TEMP_MPV06_ATRIBUT;
          
					INSERT into TEMP_MPV06_ATRIBUT  (id, seq, valor)
					(SELECT @V_ID, @V_SEQ + ROW_NUMBER() OVER(ORDER BY ID ), VALOR + dbo.mercf_piece(@V_VALOR_PARTE, ',', @V_AUX2) + '#'
					  FROM TEMP_MPV06_ATRIBUT
					 where len(VALOR) - len(REPLACE(VALOR, '#', '')) = (@V_AUX - 1));
				
          
				end

				set @V_AUX2 = @V_AUX2 + 1;

			ENd ------ fim 2º while

        IF @V_PRIMEIRA = 0
          delete from TEMP_MPV06_ATRIBUT  WHERE len(VALOR) - len(REPLACE(VALOR, '#', '')) = @V_AUX - 1;
              
        set @V_PRIMEIRA = 0
		set @V_AUX = @V_AUX + 1;
      ENd --------- fim 1º while
    
      UPDATE TEMP_MPV06_ATRIBUT  SET VALOR = SUBSTRing(VALOR, 1, LEN(VALOR) - 1);
      
    
      set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' ATRIBUTO.VALOR + ''#'' + ';
      set @V_FROM             = @V_FROM + 'TEMP_MPV06_ATRIBUT ATRIBUTO,';
      set @V_WHERE            = @V_WHERE + ' ATRIBUTO.ID = ' + cast(@V_ID as varchar) + ' AND ';

    end
    ELSE
    begin

      set @V_ATRIBUTO = substring(@V_ATRIBUTO, 1, len(@V_ATRIBUTO) - 1);

      exec dbo.MERCP_INSERE_MPV06_TEMP 'ATRIBUT', @V_ATRIBUTO, @V_ID

      set @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' ATRIBUTO.VALOR + ''#'' + ';
      set @V_FROM             = @V_FROM + 'TEMP_MPV06_ATRIBUT ATRIBUTO,';
      set @V_WHERE            = @V_WHERE + ' ATRIBUTO.ID = ' + cast(@V_ID as varchar) + ' AND ';
    
    ENd ----charindex(',', @V_ATRIBUTO) <> 0
  
  ENd

  
  --RETIRA O ULTINO AND DA EXPRESSAO
  set @V_WHERE = SUBSTRing(@V_WHERE, 1, (LEN(@V_WHERE) - 4)) + ' )';

  --RETIRA A ULTIMA VIRGURA DO FROM
  set @V_FROM = SUBSTRing(@V_FROM, 1, (LEN(@V_FROM) - 1));

  set @V_RESTRICAO_SELECT = SUBSTRing(@V_RESTRICAO_SELECT,  1, (LEN(@V_RESTRICAO_SELECT) - 7));

  print '@V_RESTRICAO_SELECT ' + @V_RESTRICAO_SELECT


  set @VINSERE = 0

  IF @VINSERE = 0 
  begiN
    --BUSCA PROXIMA SEQUENCIA             
  print 'antes inserir'
      set @PPF01_SEQ = 0;

      SELECT @PPF01_SEQ = isnull(MAX(PV06_SEQ), 0)
        FROM MPV06_TEMP_HASH
       WHERE PV06_CONTROLE = @PPV04_CONTROLE;


    set @v_insert_mpv06 = 'INSERT INTO MPV06_temp_hash
                  (PV06_CONTROLE,
                   PV06_SEQ,
                   PV06_politica,
                   PV06_TIPO,
                   PV06_IDENT,
                   pv06_data_ini,
                   pv06_data_fim,
                   pv06_qtdemax, 
                   pv06_qtdemin, 
                   pv06_pedmin,  
                   pv06_produto,
                   pv06_comis,
                   pv06_mix,
                   pv06_precoliq,
                   pv06_bonif,
                   pv06_bonqtd,
                   pv06_bonvlr,
                   pv06_partic,
                   pv06_partmax,
                   pv06_acrvlr,
                   pv06_valmin,
                   pv06_valmax,
                   pv06_aplicacao,
                   pv06_diaini,
                   pv06_diafin,                                                              
                   pv06_aprescli,
                   pv06_diasamais,
                   pv06_descto,
                   pv06_aplic_ol,
                   pv06_valmix,
				   PV06_QTDEMULT,
                   PV06_PARTSOBRE,
                   PV06_CLICONTRIB,
                   PV06_CLIIE,
                   PV06_CLIVENDOR,
                   PV06_CLISUFRAMA,
                   PV06_VALIDADE,
                   PV06_APLIC_OLCLI,
				   PV06_MIXEXCECAO
				   )                
                  ( SELECT ' + cast(@PPV04_CONTROLE as nvarchar) + ',' +
                      cast(@PPF01_SEQ as nvarchar) + '+ ROW_NUMBER() OVER(ORDER BY ' +   (substring(@V_WHERE, 1, charindex('=', @V_WHERE) - 1))  + ' ) , ''' + 
					  cast(@P_CODIGO as nvarchar) + ''',' + '
                     ''P'' , ' + 
					 @V_RESTRICAO_SELECT +
                      ',convert(datetime, ''' + 
					  convert(nvarchar(30), @P_DTVALINI, 103) + ''', 103) ,convert(datetime, ''' + 
					  convert(nvarchar(30), @P_DTVALFIN, 103) + ''' ,103) ,''' + 
					  cast(@pdb_tbcvp_qtdemax as nvarchar) + ''',''' +
                      cast(@pdb_tbcvp_qtdemin as  nvarchar) + ''',''' +
					  cast(@pdb_tbcvp_pedmin as nvarchar) + ''',''' +
                      isnull(@v_grava_prod, '') + ''',''' + 
					  cast(@pdb_tbprmd_pcomix as nvarchar) + ''',''' +
                      cast(isnull(@v_cod_mix, '') as nvarchar) + ''',''' + 
					  cast(@pdb_tbprmd_precoliq as nvarchar) + ''',''' +
                      cast(@pdb_tbprmd_bonif as nvarchar) + ''',''' + 
					  cast(@pDB_TBPRM_bonqtd as nvarchar) + ''',''' +
                      cast(@pdb_tbprmd_boisnullr as nvarchar) + ''',''' + 
					  cast(@pdb_tbprmd_partic as nvarchar) + ''',''' +
                      cast(@pdb_tbprmd_partmix as nvarchar) + ''',''' +
					  cast(@pDB_TBPRM_acrvlr as nvarchar) + ''',''' +
                      cast(@pdb_tbprmd_valmin as nvarchar) + ''',''' + 
					  cast(@pdb_tbprmd_valmax as nvarchar) + ''',''' +
                      cast(@pDB_TBPRM_aplic_aut as nvarchar) + ''',''' + 
					  cast(@pdb_tbprmd_diaini as nvarchar) + ''',''' +
                      cast(@pdb_tbprmd_diafin as nvarchar) + ''',''' + 
					  cast(@pDB_TBPRM_aprescli as nvarchar) + ''',''' +
                      cast(@pDB_TBPRM_diasmais as nvarchar) + ''', ''' + 
					  cast(@pdb_tbprmd_desconto as nvarchar) + ''' ,''' + 
					  cast(@pDB_TBPRM_aplic_ol as nvarchar) + ''',''' +
                      cast(@pDB_TBPRM_mixvda as nvarchar) + ''',  ''' + 
					  cast(@pDB_TBPRM_DCTQTDMUL as nvarchar)  +  ''',''' + 
					  cast(@pDB_TBPRM_PPARTIC as nvarchar) + ''', ''' +
                      cast(@pDB_TBPRM_CLICONTR as nvarchar) + ''',' + 
					  '0' + ',' + 
					  '0' + ', ' + 
					  '0' +  ' , ''' + 
					  cast(@pDB_TBPRM_DTPEDVAL as nvarchar) + ''', ''' +
                      cast(@pDB_TBPRM_APL_OLCli as nvarchar) + ''' , ''' +
					  isnull(@v_mix_produto_fora_promocao, '') + 
					  ''' FROM ' + @V_FROM +
                      ' WHERE ' + @V_WHERE

  print '@v_insert_mpv06 = ' + @v_insert_mpv06

    EXEC sp_executeSQL @v_insert_mpv06
    
  
	  select * from TEMP_MPV06_PRODUTO
	  select * from TEMP_MPV06_RAMOII
	  select * from TEMP_MPV06_EMPRESA


    DELETE TEMP_MPV06_PRODUTO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPPROD WHERE ID = @V_ID;
    DELETE TEMP_MPV06_MARCA WHERE ID = @V_ID;
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
    DELETE TEMP_MPV06_CIDADE WHERE ID = @V_ID;
  
    DELETE TEMP_MPV06_TPFRETE WHERE ID = @V_ID;
    DELETE TEMP_MPV06_REFERPR WHERE ID = @V_ID;
	delete TEMP_MPV06_ATRIBUT where id = @V_ID;

	update DB_PARAM_SISTEMA
       set DB_PRMS_VALOR = convert(varchar, getdate() , 103) + ' ' + convert( varchar, getdate(), 108)
     where DB_PRMS_ID = 'SIS_DATAATUPOLITICAS';
   
  
  end
end try

begin catch


    set @VERRO = 'ERRO: ' + ERROR_MESSAGE() + ' - LINHA: ' + cast(ERROR_LINE() as varchar)
    INSERT INTO DBS_ERROS_TRIGGERS
      (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
    VALUES
      (@VERRO, @VDATA, @VOBJETO);



	DELETE TEMP_MPV06_PRODUTO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPPROD WHERE ID = @V_ID;
    DELETE TEMP_MPV06_MARCA WHERE ID = @V_ID;
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
    DELETE TEMP_MPV06_CIDADE WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPFRETE WHERE ID = @V_ID;
    DELETE TEMP_MPV06_REFERPR WHERE ID = @V_ID;
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
    delete TEMP_MPV06_atribut where id = @V_ID;
	delete TEMP_MPV06_FORCAVENDAS where id = @V_ID;

end catch  
ENd
GO
