SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_HASH_RESTRICAO_VENDA](@P_CODIGO   varchar(25), -- 02
                                             @p_seq_pai  float,
                                             @P_DTVALINI date,
                                             @P_DTVALfin date,
                                             @p_tipo     varchar(2),
                                             @p_id       float                                                       
                                             ) AS

declare @VOBJETO varchar(200) = 'MERCP_HASH_RESTRICAO_VENDA';
declare @VERRO   varchar(1000);
declare @VDATA   DATE = getdate();

declare @VLISTA_RESTRICAO nVARCHAR(2000) = '';
declare @VSQL             nvarchar(4000) = '';
declare @VHASH            varchar(800);
declare @VCODIGO_ATRIBUTO varchar(25);
declare @VINSERE          smallint = 1;
declare @PPF01_SEQ        int;
declare @PPV04_CONTROLE   int;
declare @V_COUNT          int;
declare @VCONTADOR        int;
declare @VVALOR_ATRIBUTO  nvarchar(255) = '';

declare @V_ID               int;
declare @V_FROM             nvarchar(4000) = '';
declare @V_WHERE            nvarchar(4000) = '';
declare @V_RESTRICAO_SELECT nvarchar(4000) = '';
declare @v_insert_mpv06     nvarchar(4000) = '';
declare @V_SEQ              int = 1;
declare @V_ATRIBUTO         nvarchar(1000) = '';
declare @vqtde_lst_ATRIBUTO int;
declare @V_PARCIAL          varchar(512);

declare @V_FINAL			varchar(255);
declare @V_QUANTIDADE		int;
declare @V_VALOR_TESTE		varchar(255);

declare @v_mixvendas		nvarchar(100) = '';
declare @v_DESCTOMAX		nvarchar(100) = '';
declare @v_DESCTOMIN		nvarchar(100) = '';
declare @v_DESCTOMEDIO		nvarchar(100) = '';
declare @v_PERCPARTMAXFIN	nvarchar(100) = '';
declare @v_PERCPARTMINFIN	nvarchar(100) = '';
declare @v_PERCPARTMAXFIS	nvarchar(100) = '';
declare @v_PERCPARTMINFIS	nvarchar(100) = '';
declare @v_VLRMAX			nvarchar(100) = '';
declare @v_VLRMIN			nvarchar(100) = '';
declare @v_QTDEMAX			nvarchar(100) = '';
declare @v_QTDEMIN			nvarchar(100) = '';
declare @v_PRAZOMAX			nvarchar(100) = '';
declare @v_PRAZOMIN			nvarchar(100) = '';
declare @v_FATCONVPROD		nvarchar(100) = '';

declare @vDB_RESR_TAGFILTRO   nvarchar(30) = '';
declare @vdb_resr_valor       nvarchar(1024) = '';
declare @vDB_TBCVA_ATRIB      nvarchar(100) ='';
declare @vDB_TBCVA_VALOR      nvarchar(100) = '';
 
DECLARE @V_VALOR_PARTE		  nVARCHAR(255) = '';
DECLARE @V_EXISTE			  int;
DECLARE @V_PRIMEIRA			  bit = 1;
DECLARE @v_qtde_lista_anterior   int;    
declare @V_AUX2               int;
DECLARE @V_AUX			      int;
declare @v_MENSAGEMERRO       nvarchar(255) = '';
declare @v_MOMENTODIGITACAO   nvarchar(255) = '';

  ------------------------------------------------------------
  --- VERSAO   DATA        AUTOR            ALTERACAO
  --- 1.00001  11/02/2012  ALENCAR/TIAGO    DESENVOLVIMENTO - ROTINA QUE GERA HASH PARA A TABELA DB_MRG_PRES_ITEM - CADASTRO DE SUBSTITUICAO TRIBUTARIA
  ------------------------------------------------------------

BEGIN

begin try

  set @V_ID = @p_id;

  set @VSQL      = 'SELECT PV04_CONTROLE FROM MPV04 WHERE 1=1 ';
  set @VCONTADOR = 1;

  --@vdb_resr_valor


  DECLARE CUR_res CURSOR
		FOR SELECT DB_RESR_TAGFILTRO, ltrim(rtrim(db_resr_valor))
		FROM DB_RESTR_REGRAS
		   WHERE db_resr_valor is not null
             and db_resr_seqpai = @p_seq_pai
             and db_resr_codigo = @P_CODIGO
			ORDER BY CASE
                    WHEN DB_RESR_TAGFILTRO = 'ESTADO'		THEN 1
                    WHEN DB_RESR_TAGFILTRO = 'RAMO'			THEN 2
                    WHEN DB_RESR_TAGFILTRO = 'CLIENTE'		THEN 3
                    WHEN DB_RESR_TAGFILTRO = 'LPRECO'		THEN 4
                    WHEN DB_RESR_TAGFILTRO = 'REPRES'		THEN 5
                    WHEN DB_RESR_TAGFILTRO = 'CLASCOMCLI'	THEN 6
                    WHEN DB_RESR_TAGFILTRO = 'EMPRESA'		THEN 7
                    WHEN DB_RESR_TAGFILTRO = 'REGIAOCOM'	THEN 8
                    WHEN DB_RESR_TAGFILTRO = 'RAMOII'		THEN 9
                    WHEN DB_RESR_TAGFILTRO = 'CIDADE'		THEN 10
                    WHEN DB_RESR_TAGFILTRO = 'OPERACAO'		THEN 11
                    WHEN DB_RESR_TAGFILTRO = 'TPPED'		THEN 12
                    WHEN DB_RESR_TAGFILTRO = 'CONDPGTO'		THEN 13
                    WHEN DB_RESR_TAGFILTRO = 'AREAATU'		THEN 14
                    WHEN DB_RESR_TAGFILTRO = 'PRODUTO'		THEN 15
                    WHEN DB_RESR_TAGFILTRO = 'TIPOPROD'		THEN 16
                    WHEN DB_RESR_TAGFILTRO = 'MARCA'		THEN 17
                    WHEN DB_RESR_TAGFILTRO = 'FAMILIA'		THEN 18
                    WHEN DB_RESR_TAGFILTRO = 'UFEMP'		THEN 19
                    WHEN DB_RESR_TAGFILTRO = 'TPPESSOA'		THEN 20
                    WHEN DB_RESR_TAGFILTRO = 'SUFRAMA'		THEN 21
                    WHEN DB_RESR_TAGFILTRO = 'CLASFISPROD'	THEN 22
                    WHEN DB_RESR_TAGFILTRO = 'CLASFISCLI'	THEN 23
                    WHEN DB_RESR_TAGFILTRO = 'CLASCOMPROD'	THEN 24
                    WHEN DB_RESR_TAGFILTRO = 'TPFATUR'		THEN 25
                    WHEN DB_RESR_TAGFILTRO = 'TIPOFRETE'	THEN 26
                    WHEN DB_RESR_TAGFILTRO = 'OPERLOG'		THEN 27
                    WHEN DB_RESR_TAGFILTRO = 'LABOROL'		THEN 28
                    WHEN DB_RESR_TAGFILTRO = 'CNPJEMPRESA'	THEN 29
                    WHEN DB_RESR_TAGFILTRO = 'EDIAPONTADOR' THEN 30
                    WHEN DB_RESR_TAGFILTRO = 'ORDEMCOMPRA'	THEN 31
                    WHEN DB_RESR_TAGFILTRO = 'EDIFORMAPGTO' THEN 32
                    WHEN DB_RESR_TAGFILTRO = 'EDITPRETORNO' THEN 33
                    WHEN DB_RESR_TAGFILTRO = 'EDITIPOFRE'	THEN 34
                    WHEN DB_RESR_TAGFILTRO = 'CODBARRASPROD' THEN 35
                    WHEN DB_RESR_TAGFILTRO = 'EDIIFORMAPAGTO' THEN 36
                    WHEN DB_RESR_TAGFILTRO = 'EDIIPRZPAGTO' THEN 37
                    WHEN DB_RESR_TAGFILTRO = 'EDIICONDPAGTO' THEN 38
                    WHEN DB_RESR_TAGFILTRO = 'PRODPRAZOESP' THEN 39
                    WHEN DB_RESR_TAGFILTRO = 'VINCULOCLIENTE' THEN 40
                    WHEN DB_RESR_TAGFILTRO = 'REFERPROD'	THEN 41
                    WHEN DB_RESR_TAGFILTRO = 'GRUPOPROD'	THEN 42
                    WHEN DB_RESR_TAGFILTRO = 'TPVENDA'		THEN 43
                    WHEN DB_RESR_TAGFILTRO = 'CONTRIBUINTE' THEN 44
                    when DB_RESR_TAGFILTRO like 'AT%'		THEN 45 + DB_RESR_SEQ
                    END
			OPEN CUR_res
		   FETCH NEXT FROM CUR_res
			INTO @vDB_RESR_TAGFILTRO, @vdb_resr_valor
		WHILE @@FETCH_STATUS = 0
		   BEGIN  

				
    
				 if  isnull(@vDB_RESR_TAGFILTRO, '') = 'ESTADO'
				 begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'ESTADO,';
					sET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
										cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''ESTADO'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--set --@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'ESTADO', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + ' ESTADO.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + ' TEMP_MPV06_ESTADO ESTADO,';
					SET @V_WHERE            = @V_WHERE + ' ESTADO.ID = ' + cast(@V_ID as varchar) + ' AND ';
				
				 end
				 else
				 if isnull(@vDB_RESR_TAGFILTRO, '') = 'RAMO'
				 begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'RAMO,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
										cast(@VCONTADOR as varchar) + ' AND PV05_TAGFILTRO = ''RAMO'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					----@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'RAMO', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + 'RAMO.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_RAMO RAMO ,';
					SET @V_WHERE            = @V_WHERE + ' RAMO.ID = ' + cast(@V_ID as varchar) + ' AND ';
				 end
				 else
				 if isnull(@vDB_RESR_TAGFILTRO, '') = 'CLIENTE'
				 begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLIENTE,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''CLIENTE'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CLIENTE', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' CLIENTE.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + ' TEMP_MPV06_CLIENTE CLIENTE,';
					SET @V_WHERE            = @V_WHERE + ' CLIENTE.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
				  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'LPRECO'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'LPRECO,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''LPRECO'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					 --@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'LPRECO', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' LPRECO.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + ' TEMP_MPV06_LPRECO LPRECO,';
					SET @V_WHERE            = @V_WHERE + ' LPRECO.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
				  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'REPRES'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'REPRES,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''REPRES'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
   
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'REPRES', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' REPRES.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + ' TEMP_MPV06_REPRES REPRES,';
					SET @V_WHERE            = @V_WHERE + ' REPRES.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
				  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'CLASCOMCLI'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASCOMCLI,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''CLASCOMCLI'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CLACCLI', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  'CLASCOMCLI.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_CLACCLI CLASCOMCLI,';
					SET @V_WHERE            = @V_WHERE + ' CLASCOMCLI.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'EMPRESA'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'EMPRESA,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''EMPRESA'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'EMPRESA', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' EMPRESA.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_EMPRESA EMPRESA,';
					SET @V_WHERE            = @V_WHERE + ' EMPRESA.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'REGIAOCOM'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'REGIAOCOM,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''REGIAOCOM'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'REGCOM', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' REGIAOCOM.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_REGCOM REGIAOCOM,';
					SET @V_WHERE            = @V_WHERE + ' REGIAOCOM.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
					
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'RAMOII'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'RAMOII,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''RAMOII'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'RAMOII', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' RAMOII.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_RAMOII RAMOII,';
					SET @V_WHERE            = @V_WHERE + ' RAMOII.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
				  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'CIDADE'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CIDADE,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''CIDADE'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CIDADE', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' CIDADE.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_CIDADE CIDADE,';
					SET @V_WHERE            = @V_WHERE + ' CIDADE.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'OPERACAO'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'OPERACAO,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''OPERACAO'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'OPERACA', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' OPERACAO.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_OPERACA OPERACAO,';
					SET @V_WHERE            = @V_WHERE + 'OPERACAO.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'TPPED'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPPED,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''TPPED'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPPED', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  'TPPED.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TPPED TPPED,';
					SET @V_WHERE            = @V_WHERE + ' TPPED.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'CONDPGTO'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CONDPGTO,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''CONDPGTO'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CPGTOIT', @vdb_resr_valor, @V_ID --- TIAGO, CONFRERIR A VARIAVEL CONDICAO DE PAGAMENTO DA CAPA E DO ITEM 
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  'CPGTOIT.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_CPGTOIT CPGTOIT,';
					SET @V_WHERE            = @V_WHERE + ' CPGTOIT.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'AREAATU'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'AREAATU,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''AREAATU'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'AREAATU', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' AREAATU.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_AREAATU AREAATU,';
					SET @V_WHERE            = @V_WHERE + ' AREAATU.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'PRODUTO'
				  begin	
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'PRODUTO,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''PRODUTO'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'PRODUTO', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' PRODUTO.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + ' TEMP_MPV06_PRODUTO PRODUTO,';
					SET @V_WHERE            = @V_WHERE + ' PRODUTO.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'TIPOPROD'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TIPOPROD,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''TIPOPROD'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPPROD', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' TIPOPROD.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TPPROD TIPOPROD,';
					SET @V_WHERE            = @V_WHERE + ' TIPOPROD.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'MARCA'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'MARCA,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''MARCA'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'MARCA', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' MARCA.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_MARCA MARCA ,';
					SET @V_WHERE            = @V_WHERE + ' MARCA.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
				  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'FAMILIA'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'FAMILIA,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''FAMILIA'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'FAMILIA', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' FAMILIA.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_FAMILIA FAMILIA,';
					SET @V_WHERE            = @V_WHERE + ' FAMILIA.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'UFEMP'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'UFEMP,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''UFEMP'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'UFEMP', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' UFEMP.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_UFEMP UFEMP,';
					SET @V_WHERE            = @V_WHERE + ' UFEMP.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'TPPESSOA'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPPESSOA,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''TPPESSOA'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPPESSO', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  'TPPESSOA.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TPPESSO TPPESSOA,';
					SET @V_WHERE            = @V_WHERE + ' TPPESSOA.ID =  ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'SUFRAMA'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'SUFRAMA,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''SUFRAMA'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'SUFRAMA', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' SUFRAMA.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_SUFRAMA SUFRAMA,';
					SET @V_WHERE            = @V_WHERE + ' SUFRAMA.ID = ' + CAST(@V_ID AS VARCHAR) + ' AND';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'CLASFISPROD'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASFISPROD,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''CLASFISPROD'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CLAFPRO', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' CLASFISPROD.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_CLAFPRO CLASFISPROD,';
					SET @V_WHERE            = @V_WHERE + ' CLASFISPROD.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'CLASFISCLI'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASFISCLI,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''CLASFISCLI'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CLAFCLI', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' CLASFISCLI.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + ' TEMP_MPV06_CLAFCLI CLASFISCLI,';
					SET @V_WHERE            = @V_WHERE + ' CLASFISCLI.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'CLASCOMPROD'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CLASCOMPROD,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''CLASCOMPROD'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CLACPRO', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' CLASCOMPROD.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_CLACPRO CLASCOMPROD,';
					SET @V_WHERE            = @V_WHERE + ' CLASCOMPROD.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, -1) = 'TPFATUR'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPFATUR,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''TPFATUR'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPFATUR', @vdb_resr_valor, @V_ID
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' TPFATUR.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TPFATUR TPFATUR ,';
					SET @V_WHERE            = @V_WHERE + ' TPFATUR.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'TIPOFRETE'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TIPOFRETE,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''TIPOFRETE'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPFRETE', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' TIPOFRETE.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TPFRETE TIPOFRETE,';
					SET @V_WHERE            = @V_WHERE + ' TIPOFRETE.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'OPERLOG'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'OPERLOG,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''OPERLOG'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'OPERLOG', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' OPERLOG.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_OPERLOG OPERLOG,';
					SET @V_WHERE            = @V_WHERE + ' OPERLOG.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'LABOROL'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'LABOROL,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''LABOROL'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'LABOROL', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' LABOROL.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_LABOROL LABOROL,';
					SET @V_WHERE            = @V_WHERE + ' LABOROL.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'CNPJEMPRESA'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CNPJEMPRESA,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''CNPJEMPRESA'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CNPJEMP', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' CNPJEMPRESA.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_CNPJEMP CNPJEMPRESA,';
					SET @V_WHERE            = @V_WHERE + ' CNPJEMPRESA.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'EDIAPONTADOR'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'EDIAPONTADOR,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''EDIAPONTADOR'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'APONTAD', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' EDIAPONTADOR.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_APONTAD EDIAPONTADOR,';
					SET @V_WHERE            = @V_WHERE + ' EDIAPONTADOR.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'ORDEMCOMPRA'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'ORDEMCOMPRA,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''ORDEMCOMPRA'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'OCOMPRA', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' ORDEMCOMPRA.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_OCOMPRA ORDEMCOMPRA,';
					SET @V_WHERE            = @V_WHERE + ' ORDEMCOMPRA.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'EDIFORMAPGTO'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'EDIFORMAPGTO,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''EDIFORMAPGTO'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'FPGTO', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' EDIFORMAPGTO.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_FPGTO EDIFORMAPGTO,';
					SET @V_WHERE            = @V_WHERE + ' EDIFORMAPGTO.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'EDITPRETORNO'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'EDITPRETORNO,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''EDITPRETORNO'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPRETOR', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' EDITPRETORNO.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TPRETOR EDITPRETORNO,';
					SET @V_WHERE            = @V_WHERE + ' EDITPRETORNO.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'EDITIPOFRE'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'EDITIPOFRE,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''EDITIPOFRE'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'EDIFRET', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' EDITIPOFRE.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_EDIFRET EDITIPOFRE,';
					SET @V_WHERE            = @V_WHERE + ' EDITIPOFRE.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
				  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'CODBARRASPROD'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CODBARRASPROD,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''CODBARRASPROD'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'BARRAPR', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' CODBARRASPROD.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_BARRAPR CODBARRASPROD,';
					SET @V_WHERE            = @V_WHERE + ' CODBARRASPROD.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'EDIIFORMAPAGTO'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'EDIIFORMAPAGTO,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''EDIIFORMAPAGTO'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'FPGTOI', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' EDIIFORMAPAGTO.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_FPGTOI EDIIFORMAPAGTO,';
					SET @V_WHERE            = @V_WHERE + ' EDIIFORMAPAGTO.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'EDIIPRZPAGTO'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'EDIIPRZPAGTO,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''EDIIFORMAPAGTO'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'PRZPGTO', @vdb_resr_valor, @V_ID
     
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' EDIIPRZPAGTO.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_PRZPGTO EDIIPRZPAGTO,';
					SET @V_WHERE            = @V_WHERE + ' EDIIPRZPAGTO.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'EDIICONDPAGTO'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'EDIICONDPAGTO,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''EDIICONDPAGTO'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'ECPGTOI', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' EDIICONDPAGTO.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_ECPGTOI EDIICONDPAGTO,';
					SET @V_WHERE            = @V_WHERE + ' EDIICONDPAGTO.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'PRODPRAZOESP'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'PRODPRAZOESP,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''PRODPRAZOESP'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'PRAZOPR', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' PRODPRAZOESP.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_PRAZOPR PRODPRAZOESP,';
					SET @V_WHERE            = @V_WHERE + ' PRODPRAZOESP.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'VINCULOCLIENTE'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'VINCULOCLIENTE,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''VINCULOCLIENTE'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'VINCULO', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' VINCULOCLIENTE.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM +
										  'TEMP_MPV06_VINCULO VINCULOCLIENTE,';
					SET @V_WHERE            = @V_WHERE + ' VINCULOCLIENTE.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'GRUPOPROD'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'GRUPOPROD,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''GRUPOPROD'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'GRUPROD', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  'GRUPOPROD.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_GRUPROD GRUPOPROD,';
					SET @V_WHERE            = @V_WHERE + ' GRUPOPROD.ID = ' + CAST(@V_ID AS VARCHAR) +
										  '  AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'TPVENDA'
				  begin				  
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'TPVENDA,';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									CAST(@VCONTADOR AS VARCHAR) +
										' AND PV05_TAGFILTRO = ''TPVENDA'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					--@VHASH            = @VHASH + @vdb_resr_valor + '#';
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'TPVENDA', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' TPVENDA.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM + 'TEMP_MPV06_TPVENDA TPVENDA, ';
					SET @V_WHERE            = @V_WHERE + ' TPVALOR.ID = ' + CAST(@V_ID AS VARCHAR) +
										     ' AND ';
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'CONTRIBUINTE'
				  begin
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + 'CONTRIBUINTE,';
					SET @VSQL             = @VSQL +
										    ' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									        CAST(@VCONTADOR AS VARCHAR) +
										    ' AND PV05_TAGFILTRO = ''CONTRIBUINTE'')';
					SET @VCONTADOR        = @VCONTADOR + 1;
					IF @vdb_resr_valor = 'N'	
					begin				  
					  EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CONTRIB', '1', @V_ID
					end
					ELSE
					begin					  
					  EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CONTRIB', '0', @V_ID
					end
      
					EXEC DBO.MERCP_INSERE_MPV06_TEMP 'CONTRIB', @vdb_resr_valor, @V_ID
      
					SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT +
										  ' CONTRIBUIENTE.VALOR + ''#'' + ';
					SET @V_FROM             = @V_FROM +
										  'TEMP_MPV06_CONTRIB CONTRIBUINTE,';
					SET @V_WHERE            = @V_WHERE + ' CONTRIBUINTE.ID = ' + CAST(@V_ID AS VARCHAR) +
										  ' AND ';
                  end
				  else 
				  if isnull(@vDB_RESR_TAGFILTRO, '') LIKE 'AT%'
				  begin
					SET @V_ATRIBUTO = @V_ATRIBUTO + @vdb_resr_valor + '#';
      
					SET @VLISTA_RESTRICAO = @VLISTA_RESTRICAO + @vDB_RESR_TAGFILTRO + ',';
					SET @VSQL             = @VSQL +
										' AND PV04_CONTROLE IN (SELECT PV05_CONTROLE FROM MPV05 WHERE PV05_SEQ = ' +
									    CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_TAGFILTRO = ''' +
										@vDB_RESR_TAGFILTRO + ''')';
					SET @VCONTADOR        = @VCONTADOR + 1;

                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'MIXVENDAS'
				  begin
					set @v_mixvendas = @vdb_resr_valor;
				  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'DESCTOMAX'
				  begin
					set @v_DESCTOMAX = @vdb_resr_valor;
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'DESCTOMIN'
				  begin
					set @v_DESCTOMIN = @vdb_resr_valor;
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'DESCTOMEDIO'
				  begin
					set @v_DESCTOMEDIO = @vdb_resr_valor;				
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'PERCPARTMAXFIN'
				  begin
					set @v_PERCPARTMAXFIN = @vdb_resr_valor;
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'PERCPARTMINFIN'
				  begin
					set @v_PERCPARTMINFIN = @vdb_resr_valor;
				  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'PERCPARTMAXFIS'
				  begin
					set @v_PERCPARTMAXFIS = @vdb_resr_valor;
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'PERCPARTMINFIS'
				  begin
					set @v_PERCPARTMINFIS = @vdb_resr_valor;
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'VLRMAX'
				  begin
					set @v_VLRMAX = @vdb_resr_valor;
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'QTDEMAX'
				  begin
					set @v_QTDEMAX = @vdb_resr_valor;
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'QTDEMIN'
				  begin
					set @v_QTDEMIN = @vdb_resr_valor;
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'PRAZOMAX'
				  begin
					set @v_PRAZOMAX = @vdb_resr_valor;
                  end
				  else
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'PRAZOMIN'
				  begin
					set @v_PRAZOMIN = @vdb_resr_valor;
			      end
				  else 
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'VLRMIN'
				  begin
					set @v_VLRMIN = @vdb_resr_valor;
			      end
				  else 
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'FATCONVPROD'
				  begin
					set @v_FATCONVPROD = @vdb_resr_valor;
			      end
				  
				  else 
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'MENSAGEMERRO'
				  begin
					set @v_MENSAGEMERRO = @vdb_resr_valor;
			      end				  
				  
				  else 
				  if isnull(@vDB_RESR_TAGFILTRO, '') = 'MOMENTODIGITACAO'
				  begin
					set @v_MOMENTODIGITACAO = @vdb_resr_valor;
			      end	
				  
				 			  

  
		FETCH NEXT FROM CUR_res
		  INTO @vDB_RESR_TAGFILTRO, @vdb_resr_valor
		  ENd
		  CLOSE CUR_res
		DEALLOCATE CUR_res



 set @V_AUX = 1
  set @V_AUX2 = 1

set @V_SEQ = 1

  --------- inclui da tabela os atributos


  print '@V_ATRIBUTO = ' + @V_ATRIBUTO
 

 IF isnull(@V_ATRIBUTO, '') <> ''
  begin

   --set @V_ATRIBUTO =  substring(@V_ATRIBUTO, 1, (len(@V_ATRIBUTO ) - 1 ))

   print '@V_ATRIBUTO = ' + @V_ATRIBUTO
  
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
    
     
  SET @VCONTADOR = @VCONTADOR - 1;

  SET @VSQL = @VSQL + 'AND NOT EXISTS (SELECT 1 FROM MPV05 WHERE PV05_SEQ > ' +
          CAST(@VCONTADOR AS VARCHAR) + ' AND PV05_CONTROLE = PV04_CONTROLE)';

		  print '@VSQL - ' + @VSQL

  --RETIRA ULTIMA VIRGULA
  if isnull(@VLISTA_RESTRICAO, '') <> ''
	SET @VLISTA_RESTRICAO = SUBSTRING(@VLISTA_RESTRICAO, 1, (LEN(@VLISTA_RESTRICAO) - 1));
  --@VHASH            = SUBSTR(@VHASH, 1, (LENGTH(@VHASH) - 1));

    create table #temp ( codigo    int);
    set @PPV04_CONTROLE = 0; 

	insert into #temp  exec sp_executeSQL @VSQL 

    select @PPV04_CONTROLE = codigo from #temp
	
	drop table #temp

  --SE NAO EXISTIR CONTROLE COM RESTRICOES DEFINIDAS INSERE NAS 2 TABELAS OS REGISTROS (CAPA, ITENS)
    IF @PPV04_CONTROLE = 0 
	begin

		SELECT @PPV04_CONTROLE = isnull(MAX(PV04_CONTROLE), 0) + 1 FROM MPV04;
  
		INSERT INTO MPV04
			(PV04_CONTROLE, PV04_TIPO)
		VALUES
			(@PPV04_CONTROLE, 'I');
  
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
			       from mpv07 where pv07_tagfiltro in (''' +  replace(@VLISTA_RESTRICAO, ',', ''',''') + ''' )) 
				  where pv04_controle = ' + cast(@PPV04_CONTROLE as varchar)

  EXEC sp_executeSQL @VSQL


  --RETIRA O ULTINO AND DA EXPRESSAO
  SET @V_WHERE = SUBSTRING(@V_WHERE, 1, (LEN(@V_WHERE) - 4)) + ')';

  --RETIRA A ULTIMA VIRGURA DO FROM
  SET @V_FROM = SUBSTRING(@V_FROM, 1, (LEN(@V_FROM) - 1));
  
  SET @V_RESTRICAO_SELECT = SUBSTRING(@V_RESTRICAO_SELECT, 1, (LEN(@V_RESTRICAO_SELECT) - 7));
  --SET @V_RESTRICAO_SELECT = @V_RESTRICAO_SELECT + @V_ATRIBUTO;
	SET @V_SEQ = 0;

    SELECT @V_SEQ = isnull(MAX(PV06_SEQ), 0)
      FROM MPV06_TEMP_HASH
     WHERE PV06_controle = @PPV04_CONTROLE;
  
  
  IF isnull(@V_RESTRICAO_SELECT, '') <> ''
  BEGIn
 
    SET @v_insert_mpv06 = 'INSERT INTO MPV06_temp_hash
              (PV06_CONTROLE,
               PV06_SEQ,
               PV06_politica,
               PV06_TIPO,
               PV06_IDENT,
               pv06_data_ini,
               pv06_data_fim,               
               pv06_prazomax,
               pv06_qtdemax,
               pv06_qtdemin,
               pv06_cvi,
               pv06_comis,               
               pv06_pedmin,               
               pv06_descto,
               pv06_aplicacao,
               pv06_grupoemp,
               pv06_tpavaliacao,               
               pv06_mix,
               pv06_desctomax,
               pv06_desctomin,
               pv06_dctomediomin,
               pv06_partmax,              
               pv06_partmaxfis,
               pv06_partic,
               pv06_valmax,
               pv06_valmin,             
               pv06_prazomin,
			   PV06_IDRegra,
               PV06_MsgErro,
               PV06_AVALIACAO,
			   PV06_FATCONV)
              (SELECT ' + cast(@PPV04_CONTROLE as varchar) + ' , 
                      ROW_NUMBER() OVER(ORDER BY ' +   (substring(@V_WHERE, 1, charindex('=', @V_WHERE) - 1))  + ' ) + ' + cast(@V_SEQ as varchar) + ' ,
                      ''' + @P_CODIGO + ''', ''' +
                      @p_tipo + ''',' + 
					  @V_RESTRICAO_SELECT + ' , convert(datetime, ''' +
                      convert(nvarchar(30),@P_DTVALINI, 103) + ''',103) , convert(datetime,''' + 
					  convert(nvarchar(30),@P_DTVALfin,103) + ''', 103) , ''' +
                      replace(replace(ltrim(rtrim(isnull(@v_PRAZOMAX, 0))), '.',''), ',','.') + ''' , ''' + 
					  ltrim(rtrim(isnull(@v_QTDEMAX, 0))) + ''' , ''' +
                      ltrim(rtrim(isnull(@v_QTDEMIN, 0))) + ''' , ' + 
					  '0' + ' , ' + 
					  '0' + ' , ''' +
                      replace(replace(ltrim(rtrim(isnull(@v_PERCPARTMINFIN, 0))), '.',''), ',','.') + ''' , ''' + 
					  '' + ''' , ''' + 
					  '' +  ''' , ''' + 
					  '' + ''' , ' + 
					  '0' + ' , ''' + 
					  replace(replace(ltrim(rtrim(isnull(@v_mixvendas, 0))), '.',''), ',','.') +   ''',''' + 
					  replace(replace(ltrim(rtrim(isnull(@v_DESCTOMAX, 0))), '.',''), ',','.') + ''',''' + 
					  replace(replace(ltrim(rtrim(isnull(@v_DESCTOMIN, 0))), '',''), ',','.') + ''',''' + 
					  replace(replace(ltrim(rtrim(isnull(@v_DESCTOMEDIO, 0))), '.',''), ',','.') + ''',''' +
                      replace(replace(ltrim(rtrim(isnull(@v_PERCPARTMAXFIN, 0))), '.',''), ',','.') + ''',''' + 
					  replace(replace(ltrim(rtrim(isnull(@v_PERCPARTMAXFIS, 0))), '.',''), ',','.') +  ''',''' +
					  replace(replace(ltrim(rtrim(isnull(@v_PERCPARTMINFIS, 0))), '.',''), ',','.') + ''',''' + 
					  replace(replace(ltrim(rtrim(isnull(@v_VLRMAX, 0))), '.',''), ',','.') +  ''',''' +
					  replace(replace(ltrim(rtrim(isnull(@v_VLRMIN, 0))), '.',''), ',','.') + ''',''' +
					  replace(replace(ltrim(rtrim(isnull(@v_PRAZOMIN, 0))), '.',''), ',','.') +     ''',' +
					  cast(@p_seq_pai as varchar) + ', ''' + 
					  isnull(ltrim(rtrim(@v_MENSAGEMERRO)), '') + ''', ''' + 
					  isnull(ltrim(rtrim(@v_MOMENTODIGITACAO)), '') + ''', ''' +
					  isnull(ltrim(rtrim(@v_FATCONVPROD)), 0) +
         ''' FROM ' + @V_FROM + 
          ' WHERE ' + @V_WHERE;
  
  print '@v_insert_mpv06 = ' + @v_insert_mpv06
    exec sp_executeSQL @v_insert_mpv06
      
   DELETE TEMP_MPV06_CONTRIB  WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPVENDA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_GRUPROD WHERE ID = @V_ID;
    DELETE TEMP_MPV06_VINCULO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_PRAZOPR WHERE ID = @V_ID;
    DELETE TEMP_MPV06_ECPGTOI WHERE ID = @V_ID;
    DELETE TEMP_MPV06_PRZPGTO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_FPGTOI WHERE ID = @V_ID;
    DELETE TEMP_MPV06_BARRAPR WHERE ID = @V_ID;
    DELETE TEMP_MPV06_EDIFRET WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPRETOR WHERE ID = @V_ID;
    DELETE TEMP_MPV06_FPGTO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_OCOMPRA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_APONTAD WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CNPJEMP WHERE ID = @V_ID;
    DELETE TEMP_MPV06_LABOROL WHERE ID = @V_ID;
    DELETE TEMP_MPV06_OPERLOG WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPFRETE WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPFATUR WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CLACPRO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CLAFCLI WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CLAFPRO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_SUFRAMA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPPESSO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_UFEMP WHERE ID = @V_ID;
    DELETE TEMP_MPV06_FAMILIA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_MARCA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPPROD WHERE ID = @V_ID;
    DELETE TEMP_MPV06_PRODUTO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_AREAATU WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CPGTOIT WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPPED WHERE ID = @V_ID;
    DELETE TEMP_MPV06_OPERACA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CIDADE WHERE ID = @V_ID;
    DELETE TEMP_MPV06_RAMOII WHERE ID = @V_ID;
    DELETE TEMP_MPV06_REGCOM WHERE ID = @V_ID;
    DELETE TEMP_MPV06_EMPRESA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CLACCLI WHERE ID = @V_ID;
    DELETE TEMP_MPV06_REPRES WHERE ID = @V_ID;
    DELETE TEMP_MPV06_LPRECO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CLIENTE WHERE ID = @V_ID;
    DELETE TEMP_MPV06_RAMO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_ESTADO WHERE ID = @V_ID;
    delete TEMP_MPV06_atribut where id = @V_ID;

	update DB_PARAM_SISTEMA
       set DB_PRMS_VALOR = convert(varchar, getdate() , 103) + ' ' + convert( varchar, getdate(), 108)
     where DB_PRMS_ID = 'SIS_DATAATUPOLITICAS';
  
  END -- FIM IF INSERIR

end try
begin catch
    set @VERRO = 'ERRO: ' + ERROR_MESSAGE()
    INSERT INTO DBS_ERROS_TRIGGERS
      (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
    VALUES
      (@VERRO, @VDATA, @VOBJETO)


	DELETE TEMP_MPV06_CONTRIB WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPVENDA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_GRUPROD WHERE ID = @V_ID;
    DELETE TEMP_MPV06_VINCULO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_PRAZOPR WHERE ID = @V_ID;
    DELETE TEMP_MPV06_ECPGTOI WHERE ID = @V_ID;
    DELETE TEMP_MPV06_PRZPGTO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_FPGTOI WHERE ID = @V_ID;
    DELETE TEMP_MPV06_BARRAPR WHERE ID = @V_ID;
    DELETE TEMP_MPV06_EDIFRET WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPRETOR WHERE ID = @V_ID;
    DELETE TEMP_MPV06_FPGTO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_OCOMPRA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_APONTAD WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CNPJEMP WHERE ID = @V_ID;
    DELETE TEMP_MPV06_LABOROL WHERE ID = @V_ID;
    DELETE TEMP_MPV06_OPERLOG WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPFRETE WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPFATUR WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CLACPRO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CLAFCLI WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CLAFPRO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_SUFRAMA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPPESSO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_UFEMP WHERE ID = @V_ID;
    DELETE TEMP_MPV06_FAMILIA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_MARCA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPPROD WHERE ID = @V_ID;
    DELETE TEMP_MPV06_PRODUTO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_AREAATU WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CPGTOIT WHERE ID = @V_ID;
    DELETE TEMP_MPV06_TPPED WHERE ID = @V_ID;
    DELETE TEMP_MPV06_OPERACA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CIDADE WHERE ID = @V_ID;
    DELETE TEMP_MPV06_RAMOII WHERE ID = @V_ID;
    DELETE TEMP_MPV06_REGCOM WHERE ID = @V_ID;
    DELETE TEMP_MPV06_EMPRESA WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CLACCLI WHERE ID = @V_ID;
    DELETE TEMP_MPV06_REPRES WHERE ID = @V_ID;
    DELETE TEMP_MPV06_LPRECO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_CLIENTE WHERE ID = @V_ID;
    DELETE TEMP_MPV06_RAMO WHERE ID = @V_ID;
    DELETE TEMP_MPV06_ESTADO WHERE ID = @V_ID;
    delete TEMP_MPV06_atribut where id = @V_ID;

end catch

ENd
GO
