---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0001	18/10/2012	TIAGO PRADELLA	TIRADO FILTRO QUE VALIDA SITUACAO DO CLIENTE, DB_CLI_SITUACAO
-- 1.0002   24/10/2012  TIAGO PRADELLA  INCLUIDO O CAMPO 'TEXTORESTRICAO_CLIEN'
-- 1.0003   07/11/02012 TIAGO PRADELLA  INCLUIDO CAMPO DATAULTIMOPEDIDO_CLIEN
-- 1.0004   06/02/2013  TIAGO PRADELLA  INCLUIDO CAMPO OBSERVACOES, ECONOMIA
-- 1.0005   22/02/2013  TIAGO           ISNULL CAMPOS E LATITUDE, LONGITUDE
-- 1.0006   05/03/2013  tiago           incluido campo de data de visita
-- 1.0007   18/04/2013  tiago           incluido campo programa ajuste
-- 1.0008   10/07/2013  tiago			incluido novos campos
-- 1.0009   29/07/2013  tiago           incluido filtro de cliente por estado
-- 1.0010   08/08/2013  tiago           retirado calculo nos campos de latitute
-- 1.0011   13/08/2013  tiago           incuido campo data de envio
-- 1.0012   14/08/2013  tiago           incluido campo mobile
-- 1.0113   08/10/2008  tiago           incluido campo de cor
-- 1.0014   06/02/2014  tiago           incluido campo SINCRONIZACAO_CLIEN
-- 1.0014   28/11/2013  tiago           incluido campo MOTIVOSNAOBLOQUEIA
-- 1.0015   14/02/2014  tigao           incluido campo ORDEM_CLIEN
-- 1.0015   27/02/2014  tiago           incluido campo VALIDADESUFRAMA_CLIENC
-- 1.0016   17/03/2014  tiago           incluido campo data de ultimo faturamento
-- 1.0017   28/03/2014  tiago           passa a buscar esses campos, DB_CLICR_ESPEC, DB_CLICR_AVALCRED, DB_CLICR_CRITCRED da tabela de credito
-- 1.0018   16/04/2014  tiago           incluido o campo DB_CLIC_VALIDCSUBS
-- 1.0019   07/05/2014  tiago           incluido campo: DB_CLIC_AREAATU
-- 1.0020   01/05/2014  tiago           incluido campo DB_CLI_CLASSIT
-- 1.0021   08/08/2014  tiago           incluido campo DATAATUCREDITO_CLIEN
-- 1.0022   02/09/2014  tiago           incluido campo restricao pedido de pronta entrega
-- 1.0023   08/10/2014  tiago           incluido campo inscricao estadual
-- 1.0024   11/11/2014  tiago           incluido campo VERSAODIGITACAO_CLIEN
-- 1.0025   11/11/2014  tiago           incluido campo celular e contato
-- 1.0026   28/11/2014  tiago           incluido campo DB_RESTC_MSG
-- 1.0027   01/12/2014  tiago           incluido campo OPTANTESIMPLES
-- 1.0028   03/08/2015  tiago           incluido campo permite vendor
-- 1.0029   11/01/2016  tiago           validacao para verificar se envia cliente novos
-- 1.0030   20/05/2016  tiago           valida parametro CLIENTESUSUARIO para ver a forma que sera filtrado os clientes a serem enviados
-- 1.0031   13/06/2016  tiago           alterado modo de buscar o campo DATAULTIMAVISITA_CLIEN
-- 1.0032   11/07/2016  tiago			alterado modo de buscar o campo ATRASOMEDIO_CLIEN
-- 1.0033   08/02/2017  tiago           retirado round dos campo DB_CLICR_AVALCRED, DB_CLICR_CRITCRED
-- 1.0034   07/02/2018  Ricardo         incluido campo RESTRICAOACAOORCAMENTO_CLIEN
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTE AS
SELECT    DB_CLI_CODIGO		        CODIGO_CLIEN,
          DB_CLI_NOME		        NOME_CLIEN,
          DB_CLI_ENDERECO			ENDERECO_CLIEN,
          DB_CLI_BAIRRO				BAIRRO_CLIEN,
          DB_CLI_CEP				CEP_CLIEN,
          DB_CLI_CIDADE				CIDADE_CLIEN,
          DB_CLI_ESTADO				ESTADO_CLIEN,
          DB_CLI_PAIS				PAIS_CLIEN,
          DB_CLIC_ENDNRO			NUMEROENDERECO_CLIEN,
          DB_CLI_TELEFONE			TELEFONE_CLIEN,
          DB_CLI_CGCMF				CNPJ_CLIEN,
          DB_CLI_SITUACAO			SITUACAO_CLIEN,
          DB_CLIC_LATITUD			LATITUDE_CLIEN,
          DB_CLIC_LONGITUD			LONGITUDE_CLIEN,
          DB_CLIENTE.DB_CLI_CLASCOM CLASSIFICACAOCOMERCIAL_CLIEN,
          DB_CLI_RAMATIV			RAMOATIVIDADE_CLIEN,
          DB_CLI_REGIAOCOM			REGIAOCOMERCIAL_CLIEN,
          COMP.DB_CLIC_QTDEFEMB QUANTIDADEFORAEMBALAGEM_CLIEN,
          ISNULL (COMP.DB_CLIC_RESTRICAO,0) RESTRICAO_CLIEN,
          ISNULL (
             (SELECT  RESTC.DB_RESTC_ACAO
                FROM DB_RESTRICAO_CLI RESTC
               LEFT JOIN DB_CLIENTE_COMPL ON (RESTC.DB_RESTC_CODIGO = DB_CLIENTE_COMPL.DB_CLIC_RESTRICAO)
			  WHERE DB_CLIENTE_COMPL.DB_CLIC_COD  = DB_CLIENTE.DB_CLI_CODIGO),
             0)
             RESTRICAOACAOPEDIDO_CLIEN,
	      ISNULL (
             (SELECT  RESTC.DB_RESTC_ACAO_PE
                FROM DB_RESTRICAO_CLI RESTC
               LEFT JOIN DB_CLIENTE_COMPL ON (RESTC.DB_RESTC_CODIGO = DB_CLIENTE_COMPL.DB_CLIC_RESTRICAO)
			  WHERE DB_CLIENTE_COMPL.DB_CLIC_COD  = DB_CLIENTE.DB_CLI_CODIGO),
             0)
             RESTRICAOACAOPEDIDOPE_CLIEN,
		  ISNULL (
             (SELECT  RESTC.DB_RESTC_ACAO_ORC
                FROM DB_RESTRICAO_CLI RESTC
               LEFT JOIN DB_CLIENTE_COMPL ON (RESTC.DB_RESTC_CODIGO = DB_CLIENTE_COMPL.DB_CLIC_RESTRICAO)
			  WHERE DB_CLIENTE_COMPL.DB_CLIC_COD  = DB_CLIENTE.DB_CLI_CODIGO),
             0)
             RESTRICAOACAOORCAMENTO_CLIEN,
          DB_CLIENTE.DB_CLI_VINCULO VINCULO_CLIEN,          
		  DB_CLI_DATA_LIMITE		  DATALIMITECREDITO_CLIEN,
		  COMP.DB_CLIC_RAMATIVII  	  RAMOATIVIDADEII_CLIEN,
		  DB_CLI_SUFRAMA	          SUFRAMA_CLIEN,
	      DB_CLI_TIPO_PESSOA		  TIPOPESSOA_CLIEN,
		  COMP. DB_CLIC_CLASFIS	      CLASSIFICACAOFISCAL_CLIEN,
		  COMP.DB_CLIC_CONTR_ICMS	  CONTRIBUINTE_CLIEN,
		  (SELECT MAX(DB_PED_DT_EMISSAO)
             FROM DB_PEDIDO
            WHERE DB_PED_CLIENTE = DB_CLI_CODIGO) DATAULTIMOPEDIDO_CLIEN,
          (SELECT MAX(DB_PED_DT_EMISSAO)
             FROM DB_PEDIDO
            WHERE DB_PED_CLIENTE = DB_CLI_CODIGO
              AND DB_PED_SITUACAO IN (2, 3, 4))                      DATAULTIMACOMPRA_CLIEN,
          (select db_clicr_atraso_med from DB_CLIENTE_CREDITO where db_clicr_codigo = db_cli_codigo) ATRASOMEDIO_CLIEN,
		  CASE  WHEN ISNULL(DB_CLI_ULT_ALTER, 0) > ISNULL(DB_CLI_ALT_CORP, 0)		        
				THEN case when isnull(db_clicr_dataalter, 0) > isnull(DB_CLI_ULT_ALTER , 0) then db_clicr_dataalter else DB_CLI_ULT_ALTER  end
				ELSE (case when isnull(db_clicr_dataalter, 0) > isnull(DB_CLI_ALT_CORP, 0) then db_clicr_dataalter else DB_CLI_ALT_CORP end)
				end DATAALTER,
		  DB_CLIC_GRPITCONT                          ITEMCONTROLADO,
		 case when (select db_prms_valor from db_param_sistema where db_prms_id = 'CRE_AVALIACAOORGANIZACAO') = 1 
		       then (select round(isnull(cred.DB_TITULOS_ATRASO, 0), 2)  
			           from DB_CLIENTE_CREDITO_ORGANIZ cred, MRF3, DB_TB_REPRES 
					  where cred.db_cliente =  DB_CLI_CODIGO 
					    and DB_TBREP_UNIDFV = RF3_UNIDADE_FV  
						AND DB_TBREP_CODIGO = x.CODIGO_ACESSO
						AND DB_ORGANIZACAO = RF3_ORGANIZACAO)
			   else  ROUND(DB_CLIENTE_CREDITO.DB_CLICR_TITATRASO, 2)  end    VALORTITULOSEMATRASO_CLIEN,
		  case when (select db_prms_valor from db_param_sistema where db_prms_id = 'CRE_AVALIACAOORGANIZACAO') = 1 
		       then (select round(isnull(cred.DB_JUROS_ATRASO, 0), 2)  
			           from DB_CLIENTE_CREDITO_ORGANIZ cred, MRF3, DB_TB_REPRES 
					  where cred.db_cliente =  DB_CLI_CODIGO 
					    and DB_TBREP_UNIDFV = RF3_UNIDADE_FV  
						AND DB_TBREP_CODIGO = x.CODIGO_ACESSO
						AND DB_ORGANIZACAO = RF3_ORGANIZACAO)
			   else  ROUND(DB_CLIENTE_CREDITO.DB_CLICR_JURATRASO, 2)  end     VALORJUROSEMATRASO_CLIEN,
		  case when (select db_prms_valor from db_param_sistema where db_prms_id = 'CRE_AVALIACAOORGANIZACAO') = 1 
		       then (select round(isnull(cred.DB_PEDIDOS_ABERTO, 0), 2)  from DB_CLIENTE_CREDITO_ORGANIZ cred, MRF3, DB_TB_REPRES 
					  where cred.db_cliente =  DB_CLI_CODIGO 
					    and DB_TBREP_UNIDFV = RF3_UNIDADE_FV  
						AND DB_TBREP_CODIGO = x.CODIGO_ACESSO
						AND DB_ORGANIZACAO = RF3_ORGANIZACAO)
			   else  ROUND(DB_CLIENTE_CREDITO.DB_CLICR_PEDABERTO, 2)  end    VALORPEDIDOSEMABERTO_CLIEN,
		  case when (select db_prms_valor from db_param_sistema where db_prms_id = 'CRE_AVALIACAOORGANIZACAO') = 1 
		       then (select round(isnull(cred.DB_TITULOS_ABERTO, 0), 2)  from DB_CLIENTE_CREDITO_ORGANIZ cred, MRF3, DB_TB_REPRES 
					  where cred.db_cliente =  DB_CLI_CODIGO 
					    and DB_TBREP_UNIDFV = RF3_UNIDADE_FV  
						AND DB_TBREP_CODIGO = x.CODIGO_ACESSO
						AND DB_ORGANIZACAO = RF3_ORGANIZACAO)
			   else ROUND(DB_CLIENTE_CREDITO.DB_CLICR_TITABERTO, 2)  end     VALORTITULOSEMABERTO_CLIEN,		 		  
		  case when (select db_prms_valor from db_param_sistema where db_prms_id = 'CRE_AVALIACAOORGANIZACAO') = 1 
		       then (select round(isnull(cred.DB_LIMITE_CREDITO, 0), 2)  from DB_CLIENTE_CREDITO_ORGANIZ cred, MRF3, DB_TB_REPRES 
					  where cred.db_cliente =  DB_CLI_CODIGO 
					    and DB_TBREP_UNIDFV = RF3_UNIDADE_FV  
						AND DB_TBREP_CODIGO = x.CODIGO_ACESSO
						AND DB_ORGANIZACAO = RF3_ORGANIZACAO)
			   else ROUND(DB_CLIENTE_CREDITO.DB_CLICR_LIMCREDAP, 2)  end    LIMITECREDITO_CLIEN,
		  case when (select db_prms_valor from db_param_sistema where db_prms_id = 'CRE_AVALIACAOORGANIZACAO') = 1 
		       then (select cred.DB_CLIENTE_ESPECIAL  from DB_CLIENTE_CREDITO_ORGANIZ cred, MRF3, DB_TB_REPRES 
					  where cred.db_cliente =  DB_CLI_CODIGO 
					    and DB_TBREP_UNIDFV = RF3_UNIDADE_FV  
						AND DB_TBREP_CODIGO = x.CODIGO_ACESSO
						AND DB_ORGANIZACAO = RF3_ORGANIZACAO)
			   else DB_CLICR_ESPEC	end								   ESPECIAL_CLIEN,
		   case when (select db_prms_valor from db_param_sistema where db_prms_id = 'CRE_AVALIACAOORGANIZACAO') = 1 
		       then (select isnull(cred.DB_AVALIA_CREDITO, 0)  from DB_CLIENTE_CREDITO_ORGANIZ cred, MRF3, DB_TB_REPRES 
					  where cred.db_cliente =  DB_CLI_CODIGO 
					    and DB_TBREP_UNIDFV = RF3_UNIDADE_FV  
						AND DB_TBREP_CODIGO = x.CODIGO_ACESSO
						AND DB_ORGANIZACAO = RF3_ORGANIZACAO)
			   else  DB_CLICR_AVALCRED  end                        ESPECIALAVALIACREDITO_CLIEN,
		   case when (select db_prms_valor from db_param_sistema where db_prms_id = 'CRE_AVALIACAOORGANIZACAO') = 1 
		        then (select isnull(cred.DB_CRITERIOS_CREDITO, '')  from DB_CLIENTE_CREDITO_ORGANIZ cred, MRF3, DB_TB_REPRES 
					  where cred.db_cliente =  DB_CLI_CODIGO 
					    and DB_TBREP_UNIDFV = RF3_UNIDADE_FV  
						AND DB_TBREP_CODIGO = x.CODIGO_ACESSO
						AND DB_ORGANIZACAO = RF3_ORGANIZACAO)
			    else DB_CLICR_CRITCRED  end                        ESPECIALCRITERIOSCREDITO_CLIEN,
		   case when (select db_prms_valor from db_param_sistema where db_prms_id = 'CRE_AVALIACAOORGANIZACAO') = 1 
		        then (select cred.DB_DT_ULTIMO_FATUR  from DB_CLIENTE_CREDITO_ORGANIZ cred, MRF3, DB_TB_REPRES 
					  where cred.db_cliente =  DB_CLI_CODIGO 
					    and DB_TBREP_UNIDFV = RF3_UNIDADE_FV  
						AND DB_TBREP_CODIGO = x.CODIGO_ACESSO
						AND DB_ORGANIZACAO = RF3_ORGANIZACAO)
			    else DB_CLICR_DTULTFATUR    end        DATAULTIMOFATURAMENTO_CLIEN,
		    CASE WHEN (SELECT DB_PRMS_VALOR FROM DB_PARAM_SISTEMA WHERE DB_PRMS_ID = 'CRE_AVALIACAOORGANIZACAO') = 1 
		        THEN (SELECT CRED.DB_DATAALTER  FROM DB_CLIENTE_CREDITO_ORGANIZ CRED, MRF3, DB_TB_REPRES 
					  WHERE CRED.DB_CLIENTE =  DB_CLI_CODIGO 
					    AND DB_TBREP_UNIDFV = RF3_UNIDADE_FV  
						AND DB_TBREP_CODIGO = X.CODIGO_ACESSO
						AND DB_ORGANIZACAO = RF3_ORGANIZACAO)
			    ELSE DB_CLICR_DATAALTER    END        DATAATUCREDITO_CLIEN,
		  COMP.DB_CLIC_VDASANTEC                     SOMENTEPGTOANTECIPADO_CLIEN,
		  COMP.DB_CLIC_CALCSUBST                     CALCULAST_CLIEN,
		  CASE ISNULL(RTRIM(REST.DB_RESTC_TEXTO), '') WHEN '' THEN REST.DB_RESTC_DESC ELSE REST.DB_RESTC_TEXTO END TEXTORESTRICAO_CLIEN,
		  ISNULL(LTRIM(RTRIM(DB_CLI_OBSERV)), '') + ISNULL(LTRIM(RTRIM(COMP.DB_CLIC_OBSERV2)), '')        OBSERVACOES_CLIEN,
		  DB_CLI_ECONOMIA                             GERAECONOMIA_CLIEN,
		  (SELECT MAX(DB_VIS_DATA)
			 FROM DB_VISITA
			WHERE DB_VIS_CLIENTE = DB_CLI_CODIGO )    DATAULTIMAVISITA_CLIEN ,
		  (SELECT DB_PROGC_CODIGO FROM DB_PROGA_CLIENTES WHERE DB_PROGC_CLIENTE = DB_CLI_CODIGO) PROGRAMAAJUSTE_CLIEN,
		  DB_CLI_COGNOME   NOMEFANTASIA_CLIEN,
		  COMP.DB_CLIC_EMAIL       EMAIL_CLIEN,
		  GETDATE()                  DATAENVIO_CLIEN,
		  0                          MOBILE_CLIEN ,
		  COMP.DB_CLIC_COR               COR_CLIEN,
		  1	                          SINCRONIZACAO_CLIEN,
		  ISNULL (
             (SELECT DB_CLIESP_MOTNBLOQ
                FROM DB_CLIENTE_ESPEC ESP
               WHERE ESP.DB_CLIESP_CODIGO = DB_CLIENTE.DB_CLI_CODIGO                   
                 AND GETDATE() BETWEEN DB_CLIESP_DATA_INI
                                   AND DB_CLIESP_DATA_FIM),
             0)		  MOTIVOSNAOBLOQUEIA_CLIEN,
		  ISNULL((SELECT DB_ORDEM 
		            FROM DB_CLIENTE_ORDENACAO 
				   WHERE DB_CLIENTE = DB_CLI_CODIGO 
				     AND DB_USUARIO = X.CODIGO), '') ORDEM_CLIEN ,
		  COMP.DB_CLIC_DTVALSUF      VALIDADESUFRAMA_CLIEN,  		  
		  COMP.DB_CLIC_VALIDCSUBS    DATANAOCALCULAST_CLIEN,
		  X.USUARIO USUARIO,
		  DB_CLI_CLASSIT             PERFIL_CLIEN,
		  COMP.DB_CLIC_AREAATU       AREAATUACAO_CLIEN,
		  DB_CLI_CGCTE               INSCRICAOESTADUAL_CLIEN,
		  DB_CLI_VERSAODIGI          VERSAODIGITACAO_CLIEN,
		  comp.DB_CLIC_CELULAR       CELULAR_CLIEN,
          DB_CLI_CONTATO             CONTATO_CLIEN,
		  REST.DB_RESTC_MSG          MENSAGEMRESTRICAO_CLIEN,
		  comp.DB_CLIC_OPTSIMPLES         OPTANTESIMPLES_CLIEN,
		  CASE DB_CLI_VENDOR WHEN 'S' THEN 1 ELSE 0 END    permiteVendor_CLIEN,
		  isnull(DB_RESTC_FPGTO, '')  formaPagtoRestricao_CLIEN,
		  DB_CLIC_OPC_FATUR  opcaoFaturamento_CLIEN,
		  DB_CLIC_DISTPONTO       distanciaPonto_CLIEN,
		  DB_CLIC_EMBALAGEM       Embalagem_CLIEN,
		  DB_CLIC_DD_CPGTO		  diasCPGTO_CLIEN,
		  isnull(COMP.DB_CLIC_ORIGEM_CADASTRO, 0) origemCadastro_CLIEN,
		  DB_CLIENTE_USUARIO.DATA_INICIAL   DATAINICIALCARTEIRA_CLIEN,
		  DB_CLIENTE_USUARIO.DATA_FINAL    DATAFINALCARTEIRA_CLIEN,
		  DB_CLIENTE_USUARIO.REPRESENTANTE_PEDIDO REPRESPEDIDO_CLIEN,
		  DB_CLIENTE_USUARIO.SEGUNDO_REPRESENTANTE  SEGUNDOREPRESPEDIDO_CLIEN,
		  DB_CLI_DATA_CADAS          DATACADASTRO_CLIEN,
		  DB_CLIC_NPERMITEDEV		 naoPermiteDevolucoes_CLIEN,
		  DB_CLIC_ACOPERLOG			 aceitaOperLog_CLIEN,
		  DB_CLIC_LSTDISTR           listaDistribuidores_CLIEN,
		  COMP.DB_CLIC_ORDCOMP		 OBRIGATORIOORDEMCOMPRA_CLIEN,
		  COMP.DB_CLIC_VALIDBLOQPRZ  naoValidaBloqueioPrazo_CLIEN,
		  (SELECT DB_CLIESP_DUPL_MIN 
		   FROM DB_CLIENTE_ESPEC 
		   WHERE DB_CLIENTE_ESPEC.DB_CLIESP_CODIGO = DB_CLIENTE.DB_CLI_CODIGO  
		   AND GETDATE() BETWEEN DB_CLIESP_DATA_INI AND DB_CLIESP_DATA_FIM)         especialDuplicataMin_CLIEN,
		  (SELECT DB_CLIESP_VLRMIN_DUPL 
		  FROM DB_CLIENTE_ESPEC 
		  WHERE DB_CLIENTE_ESPEC.DB_CLIESP_CODIGO = DB_CLIENTE.DB_CLI_CODIGO
		  AND GETDATE() BETWEEN DB_CLIESP_DATA_INI AND DB_CLIESP_DATA_FIM)			especialVlrMinDupl_CLIEN
     FROM DB_CLIENTE
	 LEFT JOIN DB_CLIENTE_COMPL COMP ON (DB_CLIENTE.DB_CLI_CODIGO = COMP.DB_CLIC_COD)
	 LEFT JOIN DB_CLIENTE_CREDITO    ON (DB_CLIENTE.DB_CLI_CODIGO = DB_CLICR_CODIGO)
	 LEFT JOIN DB_RESTRICAO_CLI REST ON (REST.DB_RESTC_CODIGO     = COMP.DB_CLIC_RESTRICAO),
	      DB_USUARIO X,
		  DB_CLIENTE_USUARIO
    WHERE DB_CLIENTE_USUARIO.USUARIO = X.USUARIO
	  AND DB_CLIENTE_USUARIO.CLIENTE = DB_CLI_CODIGO
