SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[mercp_insere_hash_icms](
										 @PDB_RIEI_CODIGO    varchar(25),	-- 01
										 @VDB_RIEI_SEQ       INT,	-- 02
										 @PDB_RIEI_DTVALINI  DATEtime,			-- 03
										 @PDB_RIEI_DTVALFIN  DATEtime,			-- 04
										 @pdb_riei_empresa   VARCHAR(255),	-- 05
										 @pDb_RieI_UF_Orig   VARCHAR(255),	-- 06
										 @pDb_RieI_UF_Dest   VARCHAR(255),	-- 07
										 @pdb_riei_produto   VARCHAR(255),	-- 08
										 @pdb_riei_tpprod    VARCHAR(255),	-- 09
										 @pdb_riei_marca     VARCHAR(255),	-- 10
										 @pdb_riei_familia   VARCHAR(255),	-- 11
										 @pdb_riei_grupo     VARCHAR(255),	-- 12
										 @pdb_riei_cliente   varchar(255),	-- 13
										 @pdb_riei_ramo      VARCHAR(255),	-- 14
										 @pdb_riei_operacao  VARCHAR(255),	-- 15
										 @pdb_riei_tppessoa  int,	-- 16
										 @pdb_riei_suframa   float,			-- 17
										 @pDb_RieI_ClassPrd  VARCHAR(255),	-- 18
										 @pDB_RIEI_TPVDAPRD  float,			-- 19
										 @pdb_riei_fatur     float,			-- 20
										 @pDb_RieI_ClassFis  VARCHAR(255),	-- 21
										 @pDB_RieI_ClassFCli VARCHAR(255),	-- 22
										 @pdb_riei_cidade    VARCHAR(255),	-- 23
										 @pdb_riei_contrib   VARCHAR(255),	-- 24
										 @pdb_riei_lpreco    VARCHAR(255),	-- 25
										 @pdb_riei_tpped     VARCHAR(255),	-- 26
										 @pDb_RieI_CliCCom   VARCHAR(255),	-- 27
										 @PDB_RIEI_TXICMS    float,			-- 28
										 @PDB_RIEI_BASERED   float,			-- 29
										 @PDB_RIEI_PESO      float,			-- 30
										 @ptipo              VARCHAR(10),	-- 31
										 -----ST
										 @pdb_mpri_calc_subs VARCHAR(50),	-- 32
										 @pdb_mpri_aplic     float,			-- 33
										 @pdb_mpri_precomax  float,			-- 34
										 @pdb_mpri_tpcal     float,			-- 35
										 @pdb_mpri_dctopmc   float,			-- 36
										 @pdb_mpri_descto    float,			-- 37
										 @pDB_MPRI_MRGPRESUM float,			-- 38
										 @putilbasered       float,			-- 39
										 @p_id				 int
                                 ) as

declare  @VOBJETO		  VARCHAR(200) = 'mercp_insere_hash_icms';
declare  @VERRO			  VARCHAR(1000);
declare  @VDATA			  DATEtime = getdate();

declare  @VLISTA_RESTRICAO nvarchar(2000) = '';
declare  @VSQL             nVARCHAR(max) = '';
declare  @vhash            nVARCHAR(200) = '';
declare  @vcodigo_atributo nVARCHAR(25) = '';
declare  @vinsere          float = 1;
declare  @pPF01_SEQ        float;
declare  @PPV04_CONTROLE   float;
declare  @v_count          float;
declare  @vcontador        int;
declare  @vvalor_atributo  VARCHAR(255);
declare  @V_AUX			   int;

declare  @v_from             nVARCHAR(4000) = '';
declare  @v_where            nVARCHAR(4000) = '';
declare  @v_RESTRICAO_SELECT nVARCHAR(4000) = '';
declare  @v_insert_mpv06     nVARCHAR(4000) = '';
declare  @v_seq              int = 0;
declare  @v_ATRIBUTO         nVARCHAR(1000) = '';
declare  @v_id               int;

declare  @V_QUANTIDADE          int;
declare  @V_VALOR_PARTE         nVARCHAR(255);
declare  @V_EXISTE              int;
declare  @v_primeira            bit = 1;
declare  @v_qtde_lista_anterior int;
declare  @vqtde_lst_ATRIBUTO    int;

 declare @vDB_TBCVA_ATRIB    nvarchar(100) ='';
 declare @vDB_TBCVA_VALOR    nvarchar(100) = '';
DECLARE @qtde_lst_ATRIBUTO   int;     
DECLARE @_QUANTIDADE		  int;   
DECLARE @_VALOR_PARTE		  nVARCHAR(255) = '';
DECLARE @_EXISTE			  int;
DECLARE @_primeira			  bit = 1;
DECLARE @_qtde_lista_anterior   int;    
declare @V_AUX2               int;
declare @V_AT02_ORIGEM        int;

  ------------------------------------------------------------
  --- VERSAO   DATA        AUTOR            ALTERACAO
  --- 1.00001  11/02/2012  ALENCAR/TIAGO    DESENVOLVIMENTO - ROTINA QUE GERA HASH PARA A TABELA DB_MRG_PRES_ITEM - CADASTRO DE SUBSTITUICAO TRIBUTARIA
  --- 1.00002  01/12/2016  Alencar          Gravar o hash do atributo com ATP (produto) ou ATC (cliente)
  --- 1.00003  03/12/2018  Alencar          Ajuste no teste da variavel @pdb_riei_cliente
  ------------------------------------------------------------

begin

begin try

  set @VSQL      = 'SELECT pv04_controle FROM MPV04 WHERE 1=1 ';
  set @vcontador = 1;

 set @v_id = @p_id

  if isnull(@pDb_RieI_UF_Dest, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'ESTADO,';
    set @VSQL             = @VSQL +
                          ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                           cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''ESTADO'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pDb_RieI_UF_Dest + '#';
  end

  if isnull(@pdb_riei_ramo, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'RAMO,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''RAMO'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pdb_riei_ramo + '#';
  end

  if isnull(@pdb_riei_cliente, '0') <> '0'
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLIENTE,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                         cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''CLIENTE'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pdb_riei_cliente + '#';
  end

  if isnull(@pdb_riei_lpreco, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'LPRECO,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''LPRECO'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pdb_riei_lpreco + '#';
  end

  if isnull(@pDb_RieI_CliCCom, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASCOMCLI,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) +
                        ' AND pv05_tagfiltro = ''CLASCOMCLI'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pDb_RieI_CliCCom + '#';
  end

  if isnull(@pdb_riei_empresa, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'EMPRESA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''EMPRESA'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pdb_riei_empresa + '#';
  end

  if isnull(@pdb_riei_cidade, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CIDADE,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''CIDADE'')';
	set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + replace(@pdb_riei_cidade, ' ', '') + '#';
  end

  if isnull(@pdb_riei_operacao, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'OPERACAO,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''OPERACAO'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pdb_riei_operacao + '#';
  end 

  if isnull(@pdb_riei_tpped, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPPED,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''TPPED'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pdb_riei_tpped + '#';
  end

  if isnull(@pdb_riei_produto, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'PRODUTO,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''PRODUTO'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pdb_riei_produto + '#';
  end

  if isnull(@pdb_riei_tpprod, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TIPOPROD,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''TIPOPROD'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pdb_riei_tpprod + '#';
  end

  if isnull(@pdb_riei_marca, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'MARCA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''MARCA'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pdb_riei_marca + '#';
  end

  if isnull(@pdb_riei_familia, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'FAMILIA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''FAMILIA'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pdb_riei_familia + '#';
  end

  if isnull(@pDb_RieI_UF_Orig, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'UFEMP,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''UFEMP'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pDb_RieI_UF_Orig + '#';
  end

  if isnull(@pdb_riei_tppessoa, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPPESSOA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''TPPESSOA'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + cast(@pdb_riei_tppessoa as varchar) + '#';
  end

  if isnull(@pdb_riei_suframa, -1) not in (-1, 0)
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'SUFRAMA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''SUFRAMA'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + cast(@pdb_riei_suframa as varchar) + '#';
  end

  if isnull(@pDb_RieI_ClassFis, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASFISPROD,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) +
                        ' AND pv05_tagfiltro = ''CLASFISPROD'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pDb_RieI_ClassFis + '#';
  end

  if isnull(@pDB_RieI_ClassFCli, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASFISCLI,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) +
                        ' AND pv05_tagfiltro = ''CLASFISCLI'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pDB_RieI_ClassFCli + '#';
  end

  if isnull(@pDb_RieI_ClassPrd, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASCOMPROD,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar)+
                        ' AND pv05_tagfiltro = ''CLASCOMPROD'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pDb_RieI_ClassPrd + '#';
  end

  if isnull(@pdb_riei_fatur, -1) <> -1
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPFATUR,';
    set  @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''TPFATUR'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + cast(@pdb_riei_fatur as varchar) + '#';
  end

  if isnull(@pdb_riei_grupo, '') <> ''
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'GRUPOPROD,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''GRUPOPROD'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + @pdb_riei_grupo + '#';
  end

  if isnull(@pDB_RIEI_TPVDAPRD, -1) <> -1
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPVENDA,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''TPVENDA'')';
    set @vcontador        = @vcontador + 1;
    set @vhash            = @vhash + cast(@pDB_RIEI_TPVDAPRD as varchar) + '#';
  end

  if isnull(@pdb_riei_contrib, '') in ('S', 'N')
  begin
    set @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CONTRIBUINTE,';
    set @VSQL             = @VSQL +
                        ' and PV04_CONTROLE IN (select PV05_CONTROLE from mpv05 where PV05_SEQ = ' +
                        cast(@vcontador as varchar) + ' AND pv05_tagfiltro = ''CONTRIBUINTE'')';
    set @vcontador        = @vcontador + 1;
    if @pdb_riei_contrib = 'N'
	begin
      set @vhash = @vhash + '1' + '#';
	end
    else
	begin
      set @vhash = @vhash + '0' + '#';
    end
  end

    set @vhash = substring(@vhash, 1, (len(@vhash) - 1));

  --grava a informacao do hash sem o atributo, escolido uma tabela qualquer
  exec dbo.mercp_insere_mpv06_temp 'CLIENTE', @vhash, @v_id

  --busca se existe algum valor nos atributos

  DECLARE CUR_atributo CURSOR
	FOR select db_riea_atrib, db_riea_valor     
		  from DB_REGICMS_EXC_ATR
		 where db_riea_codigo = @PDB_RIEI_CODIGO
		   AND DB_RIEA_RIEI_SEQ = @VDB_RIEI_SEQ
		   order by db_riea_riei_seq
		OPEN CUR_atributo
	   FETCH NEXT FROM CUR_atributo
		INTO @vDB_TBCVA_ATRIB, @vDB_TBCVA_VALOR
	WHILE @@FETCH_STATUS = 0
	   BEGIN

    	   set @V_AT02_ORIGEM = NULL;

		   SELECT @V_AT02_ORIGEM = AT02_ORIGEM
			 FROM MAT02 
			WHERE AT02_ATRIB   = @vDB_TBCVA_ATRIB
			  AND AT02_TABELA  IN (8) -- Regra ICMS

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
			end

			set @vcontador        = cast(@vcontador as varchar) + 1;
    
			set @v_ATRIBUTO       = @v_ATRIBUTO + @vDB_TBCVA_VALOR + '#'

	FETCH NEXT FROM CUR_atributo
	  INTO  @vDB_TBCVA_ATRIB, @vDB_TBCVA_VALOR
	  END
	  CLOSE CUR_atributo
	DEALLOCATE CUR_atributo

	
  set @V_AUX = 1
  set @V_AUX2 = 1
  set @v_seq = 1


  IF isnull(@v_ATRIBUTO, '') <> ''
  begin
  
    IF charindex(',', @v_ATRIBUTO) <> 0
	begin

		set @qtde_lst_ATRIBUTO = 0;

	    set @qtde_lst_ATRIBUTO = isnull(len(@v_ATRIBUTO) - len(replace(@v_ATRIBUTO, '#', '')), 0)

		while @V_AUX <= @qtde_lst_ATRIBUTO
		begin
		     
			set @V_AUX2 = 1


			select  @_VALOR_PARTE = dbo.mercf_piece (@v_ATRIBUTO, '#', @V_AUX)
      
            set @_QUANTIDADE = isnull(len(@_VALOR_PARTE) - len(replace(@_VALOR_PARTE, ',', '')), 0) + 1

			while @V_AUX2 <= @_QUANTIDADE
			begin        
        
				if @_primeira = 1
				begin
					insert into TEMP_MPV06_ATRIBUT	(id, seq, valor)
											values
													(@v_id, @v_seq, dbo.mercf_piece(@_VALOR_PARTE, ',', @V_AUX2) + '#');
					set @v_seq = @v_seq + 1;
				end
				else
				begin

					SELECT @v_seq = ISNULL(MAX(SEQ), 1) FROM TEMP_MPV06_ATRIBUT;
          
					INSERT into TEMP_MPV06_ATRIBUT  (id, seq, valor)
					(SELECT @v_id, @v_seq + ROW_NUMBER() OVER(ORDER BY ID ), VALOR + dbo.mercf_piece(@_VALOR_PARTE, ',', @V_AUX2) + '#'
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
      
    
      set @v_RESTRICAO_SELECT = @v_RESTRICAO_SELECT + ' + ''#'' + ATRIBUTO.VALOR ';
      set @v_from             = @v_from + ',TEMP_MPV06_ATRIBUT ATRIBUTO';
      set @v_where            = @v_where + ' and ATRIBUTO.ID = ' + cast(@v_id as varchar);

    end
    ELSE
    begin

      set @v_ATRIBUTO = substring(@v_ATRIBUTO, 1, len(@v_ATRIBUTO) - 1);

      exec dbo.MERCP_INSERE_MPV06_TEMP 'ATRIBUT', @v_ATRIBUTO, @v_id

      set @v_RESTRICAO_SELECT = @v_RESTRICAO_SELECT + ' + ''#'' + ATRIBUTO.VALOR ';
      set @v_from             = @v_from + ',TEMP_MPV06_ATRIBUT ATRIBUTO';
      set @v_where            = @v_where + ' and ATRIBUTO.ID = ' + cast(@v_id as varchar);
    
    ENd ----charindex(',', @_ATRIBUTO) <> 0
  
  ENd

  set @vcontador = @vcontador - 1;

  set @VSQL = @VSQL + 'and not exists (select 1 from mpv05 where pv05_seq > ' +
          cast(@vcontador as varchar) + ' and pv05_controle = pv04_controle)';

  --retira ultima virgula
  set @VLISTA_RESTRICAO = substring(@VLISTA_RESTRICAO, 1,   (len(@VLISTA_RESTRICAO) - 1));

  set @vhash            = substring(@vhash, 1, (len(@vhash) - 1));

  create table #temp ( codigo    int);
    set @PPV04_CONTROLE = 0; 

	insert into #temp  exec sp_executeSQL @VSQL 
   

    select @PPV04_CONTROLE = codigo from #temp

	drop table #temp
  --se n existir controle com restricoes definidas insere nas 2 tabelas os registros (capa, itens)
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


  set @VSQL = 'update mpv04 set pv04_peso_imp =  (select isnull(sum(pv07_peso_imp), 0) 
            from mpv07 where pv07_tagfiltro in (''' +
          replace(@VLISTA_RESTRICAO, ',', ''',''') +
          ''' )) where pv04_controle = ' + cast(@PPV04_CONTROLE as varchar)


  set @vinsere = 0;

  if @vinsere = 0
  begin
    --busca proxima sequencia
    select @pPF01_SEQ = isnull(max(PF01_SEQ), 0) + 1
      from mpf01_temp_hash
     where pf01_controle = @PPV04_CONTROLE;

     set @v_insert_mpv06 =
	 'insert into mpf01_temp_hash
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
						pf01_utilbasered 
						) (select ' + 
							cast(@PPV04_CONTROLE as varchar) + ' , ' +
							cast(@pPF01_SEQ as varchar) + ' + ROW_NUMBER() OVER(ORDER BY cliente.id)  , ''' + @PDB_RIEI_CODIGO + ''' , ''' + @ptipo + ''' , cliente.valor ' +
							@v_RESTRICAO_SELECT + ' , ''' + 
							cast(@PDB_RIEI_TXICMS as nvarchar) +	''' , ''' +  
							cast(@PDB_RIEI_BASERED as nvarchar) + ''' , convert(datetime,  ''' +
							convert(nvarchar(30), @PDB_RIEI_DTVALINI, 103) + ''' ,103), convert(datetime, ''' +
							convert(nvarchar(30), @PDB_RIEI_DTVALFIN, 103) + ''', 103) , 
							case  ''' + @pdb_mpri_calc_subs + ''' when ''S'' then 1 when ''N'' then 0 end  , ''' +
							cast(@pdb_mpri_aplic as nvarchar) + ''' , ''' + 
							cast(@pdb_mpri_precomax as nvarchar) +''' , ''' + 
							cast(@pdb_mpri_tpcal as nvarchar) + ''' , ''' +
							cast(@pdb_mpri_dctopmc as  varchar) + ''' , ''' + 
							cast(@pdb_mpri_descto as varchar) +	''' , ''' + 
							cast(@putilbasered as varchar) + ''' 
		from temp_mpv06_cliente cliente ' + @v_from + '
		where cliente.id = ' + cast(@v_id as varchar) + ' ' + @v_where + ' )';

		exec sp_executeSQL @v_insert_mpv06;

    DELETE TEMP_MPV06_CLIENTE WHERE ID = @v_id;
    DELETE TEMP_MPV06_ATRIBUT WHERE ID = @v_id;
    
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

	DELETE TEMP_MPV06_CLIENTE WHERE ID = @v_id;
    DELETE TEMP_MPV06_ATRIBUT WHERE ID = @v_id;
  

end catch
  
end
GO
