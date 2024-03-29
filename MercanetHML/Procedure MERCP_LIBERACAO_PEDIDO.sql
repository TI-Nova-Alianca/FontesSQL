ALTER PROCEDURE MERCP_LIBERACAO_PEDIDO(
												@P_NRO		INT,		   -- NRO PEDIDO
											    @P_EXCLUI	INT,		   -- 0-NAO / 1-SIM  
											    @P_USUARIO  VARCHAR(100),
												@P_ACAO		INT,  -- 1 LIBEROU / 2 - ENCAMINHAR PARA SUPERIOR / 4 - REJEITAR
                                                @P_CODIGOJUSTIFICATIVA       VARCHAR(100) = NULL,
                                                @P_OBSERVACAOJUSTIFICATIVA   VARCHAR(1024) = NULL,
                                                @P_REPRESJUSTIFICATIVA       INT = NULL,
												@P_STATUSPEDIDO              INT,
                                                @P_MOTIVOREQUERJUSTIFICATIVA VARCHAR(10) OUT,    -- MOTIVOS QUE ESTAO SENDO LIBERADOS E QUE EXIGEM JUSTIFICATIVA
												@P_ERROLIMVERBA              VARCHAR(400) OUT,
												@P_RECALCULAMOTBLOQP         INT = 0,
                                                @P_DATAS_CALCULADAS          VARCHAR(100) = '',
												@P_RETORNARALCADA			 varchar(100) = ''
												) AS
BEGIN
DECLARE @VDATA						DATETIME;
DECLARE @VERRO						VARCHAR(1000) = '';
DECLARE @VOBJETO		            VARCHAR(200) = 'MERCP_LIBERACAO_PEDIDO';
DECLARE @V_PASSO					VARCHAR(1000);
DECLARE @V_PED_CLIENTE				FLOAT;
DECLARE @V_CLI_CGCMF				VARCHAR(19);
DECLARE @V_CLI_VINCULO              FLOAT;
DECLARE @V_TOTAL_PEDIDOS_EM_ABERTO  FLOAT;
DECLARE @V_TOTAL_COBRANCA_CLIENTE   FLOAT;
DECLARE @V_TOTAL_LIMITE_DISP        FLOAT;
DECLARE @V_PARAM_AN_CRED            FLOAT;
DECLARE @V_CLI_DIASAMAIS            FLOAT  = 0;
DECLARE @V_MOTIVOS                  VARCHAR(15);
DECLARE @V_PARAM_TPDOC_AVAL         VARCHAR(50);
DECLARE @V_DIAS                     FLOAT;
DECLARE @V_DATA                     DATE;
DECLARE @V_CLIATRS                  FLOAT;
DECLARE @V_CLICRED                  FLOAT;
DECLARE @V_TOTAL_LIMITE_EXC         FLOAT;
DECLARE @V_PERMI                    VARCHAR(30);
DECLARE @V_CFE_VLR                  VARCHAR(30);
DECLARE @V_FLG_LIB_MOTIVO_A_ALCADA         FLOAT;
DECLARE @V_FLG_LIB_MOTIVO_A_PGTO	INT;
DECLARE @V_PED_COND_PGTO            FLOAT;
DECLARE @V_FLG                      FLOAT;
DECLARE @V_VLR_MAXATRS              FLOAT;
DECLARE @V_VLR_MAX                  FLOAT;
DECLARE @V_CLILIM                   FLOAT;
DECLARE @V_VLR_MAXLIM               FLOAT;
DECLARE @V_LIB_VLREXCLIM            FLOAT;
DECLARE @V_LIB_DIVTOTMAX            FLOAT;
DECLARE @V_LIB_DIVLIMMAX            FLOAT;
DECLARE @V_PRM_APLDESCTO            FLOAT;
DECLARE @V_PED_TOT                  FLOAT;
DECLARE @V_BON_TOT                  FLOAT;
DECLARE @V_BRUTO                    FLOAT;
DECLARE @V_ECON                     FLOAT;
DECLARE @V_PED_DCTOEXC              FLOAT;
DECLARE @V_PED_DCTO                 FLOAT;
DECLARE @V_VLR_PED                  FLOAT;
DECLARE @V_LIB_DCTMAX               FLOAT;
DECLARE @V_CPGTO_PRZTOT             FLOAT;
DECLARE @V_LIB_PRZMED_MAX           FLOAT;
DECLARE @V_LIB_PRZTOT_MAX           FLOAT;
DECLARE @V_CPGTO_PRZMED             FLOAT;
DECLARE @V_TBOPS_FAT                VARCHAR(1);
DECLARE @V_LIB_BONMAX               FLOAT
      , @V_LIB_BONMAX_VLR           FLOAT;
DECLARE @V_BON_PERC                 FLOAT;
DECLARE @V_PARAM_AVALCONCEITOLUCR   FLOAT;
DECLARE @V_LUCRATIVIDADE            FLOAT;
DECLARE @V_USU_PERCMINIMO_LUCR      FLOAT;
DECLARE @V_LIBERA_PEDIDO            FLOAT;
DECLARE @V_LIB_LIMITEEXCEDIDO       FLOAT;
DECLARE @V_LIBMOTS                  VARCHAR(30)  = '';
DECLARE @V_BLQS                     VARCHAR(30)  = '';
DECLARE @V_BLQS_AUX					VARCHAR(30)	 = '';
DECLARE @V_LIBTOT                   FLOAT;
DECLARE @V_USUS                     VARCHAR(255);
DECLARE @V_DATAS                    VARCHAR(255);
DECLARE @V_HORAS                    VARCHAR(255);
DECLARE @V_GRUPO_LIB                FLOAT;
DECLARE @V_BLOQUEIOS                VARCHAR(30)='';
DECLARE @V_BLOQUEIOS_AUX			VARCHAR(30)='';
DECLARE @V_SITUACAO_CORPORATIVO     VARCHAR(10);
DECLARE @V_UPDATE_SITUACAO          FLOAT;
DECLARE @V_UPDATE_DTULTLIBERACAO    DATE;
DECLARE @V_LIBPARC                  FLOAT = 1;
DECLARE @V_CLI_RAMATIV              VARCHAR(5);
DECLARE @V_PED_EMPRESA              VARCHAR(3);
DECLARE @V_PED_TIPO                 VARCHAR(10);
DECLARE @V_CLI_CLASCOM              VARCHAR(15);
DECLARE @V_PED_SITCORP              VARCHAR(6);
DECLARE @V_CLI_REGIAOCOM            VARCHAR(8);
DECLARE @V_PED_OPERACAO             VARCHAR(6);
DECLARE @V_ALCP_CODIGO              VARCHAR(5);
DECLARE @V_ALCP_CODIGO_TEMP			VARCHAR(5);
DECLARE @V_ALCP_GRPALCADA           VARCHAR(12);
DECLARE @V_ULTIMO_USUARIO           VARCHAR(30);
DECLARE @V_ALCP_CODIGO_ANTERIOR     VARCHAR(5);
DECLARE @V_ALCP_GRPALCADA_ANTERIOR  VARCHAR(12)
      , @V_ALCP_GRPLIB_ANTERIOR     INT
	  , @V_ALCP_NIVLIB_ANTERIOR     INT;
DECLARE @V_PEDAL_SEQ                SMALLINT;
DECLARE @V_EXISTE                   INT;
DECLARE @V_MOTNLIBERADO             VARCHAR(30);
DECLARE @V_ACHOU_OUTROMOTIVO        VARCHAR(30);
DECLARE @V_PARAM_MOTIVSLIBER        VARCHAR(15);
DECLARE @V_PED_REPRES               VARCHAR(9);
DECLARE @V_PED_MOTIVO_BLOQ          VARCHAR(15);
DECLARE @V_CODIGO_USUARIO           VARCHAR(40);
DECLARE @V_PED_SITUACAO_ATUAL       FLOAT;
DECLARE @V_ALCADA_OK                FLOAT;
DECLARE @V_ALCADA_ATUAL             VARCHAR(5);
DECLARE @V_PERMITE_ENCAMINHAR       FLOAT;
DECLARE @V_ULTIMO_GRUPO             SMALLINT;
DECLARE @V_GRUPO_ATUAL              SMALLINT;
DECLARE @V_PARAM_CRIT_CRED          VARCHAR(10)
DECLARE @V_AUX						INT;
DECLARE @V_AUX2						INT;
DECLARE @V_PED_LIB_MOTS				VARCHAR(100);
DECLARE @VDB_PRM_JUST_LIBPAR        VARCHAR(20);
DECLARE @VDB_PRM_JUST_LIBTOT        VARCHAR(20);
DECLARE @V_PODE_LIBERAR             INT;
DECLARE @V_PEDAL_MOTLIBPAR	        VARCHAR(20);
DECLARE @V_DESCRICAO                VARCHAR(100);
DECLARE @V_PROGRAMA                 VARCHAR(20);
DECLARE @V_PERMITE_LOG              BIT = 0;
DECLARE @V_SESSAO                   INT;
DECLARE @V_PARAM_VALOR              INT;
DECLARE @V_REGISTRA_ACOES           INT;
DECLARE @VDB_PRM_ATIVLOGUTIL        INT;
DECLARE @VSU1_ATIVLOGUTIL           INT;
DECLARE @V_PED_WEB                  INT;
DECLARE @V_PARAM_VAL_VALIDA         INT;
DECLARE @V_DB_CLI_ESTADO            VARCHAR(10);
DECLARE @V_DB_PED_EMPRESA			VARCHAR(3);
DECLARE @V_DB_PED_REPRES			VARCHAR(10);
DECLARE @V_DB_TBREP_UNIDFV			VARCHAR(3);
DECLARE @V_DB_PED_DT_EMISSAO		DATETIME;
DECLARE @V_DB_CLI_CODIGO			FLOAT;
DECLARE @V_DB_PED_MOTIVO_BLOQ		VARCHAR(15);
DECLARE @V_DB_PED_MOTIVO_BLOQ_ALL	CHAR(15);
DECLARE @V_DB_PED_OPERACAO			VARCHAR(6);
DECLARE @V_SEM_SALDO				BIT = 0;
DECLARE @V_VALOR_TOTAL				FLOAT;
DECLARE @V_RESTRICAO				VARCHAR(20);
DECLARE @V_FLAG						BIT;
DECLARE @V_DB_PROD_CODIGO			VARCHAR(16);
DECLARE @V_DB_PROD_TPPROD			VARCHAR(4);
DECLARE @V_DB_PEDI_OPERACAO			VARCHAR(10)
DECLARE @V_DB_PEDI_PRECO_LIQ		REAL;
DECLARE @V_DB_PEDI_QTDE_SOLIC		REAL;
DECLARE @V_DB_PEDI_QTDE_CANC		REAL;
DECLARE @V_DB_PEDI_SEQUENCIA		INT;
DECLARE @V_DB_RESBR_EMPRESA			VARCHAR(3);
DECLARE @V_DB_RESBR_REPRES			INT;
DECLARE @V_DB_RESBR_CLIENTE			FLOAT;
DECLARE @V_DB_RESBR_UNIDFV			VARCHAR(3);
DECLARE @V_DB_RESBR_TPPROD			VARCHAR(4);
DECLARE @V_DB_RESBR_OPER			VARCHAR(10);
DECLARE @V_DB_RESBR_EXCETO			SMALLINT;
DECLARE @V_DB_RESB_VLVERBA			FLOAT
DECLARE @V_DB_RESB_VLRUTISVN		FLOAT;
DECLARE @V_DB_RESB_CODIGO			VARCHAR(5);
DECLARE @V_DB_RESB_VUTIVERBA        FLOAT;
DECLARE @V_SAI                      BIT = 0;
DECLARE @V_SITUACAO					INT;
DECLARE @V_INTEGRA_PEDIDO			INT;
DECLARE @VDB_PED_DESCTO				FLOAT;
DECLARE @VDB_PED_DESCTO2			FLOAT;
DECLARE @VDB_PED_DESCTO3			FLOAT;
DECLARE @VDB_PED_DESCTO4			FLOAT;
DECLARE @VDB_PED_DESCTO5			FLOAT;
DECLARE @VDB_PED_DESCTO6			FLOAT;
DECLARE @VDB_PED_DESCTO7			FLOAT;
DECLARE @VDB_PEDI_DESCTOP           FLOAT;
DECLARE @VDB_ALCP_INDTOTDCTO        VARCHAR(10);
DECLARE @VDB_ALCP_TOTDCTO           FLOAT;
DECLARE @V_DESCTO_TOTAL             FLOAT;
DECLARE @V_ENV_WORKFLOW             INTEGER = 0;
DECLARE @VRETORNO                   VARCHAR(1000);
DECLARE @VDB_ALCP_ECONOMIA          FLOAT;
DECLARE @V_PARAM_VALDESCONTOEXCEDIDO INT;
DECLARE @VPEDIDO_TOTAL_ITEM         FLOAT;
DECLARE @VECONOMIA_ITEM             FLOAT;      
DECLARE @VDB_ALCP_DESCTOMEDIO       FLOAT;
DECLARE @V_DESCONTO_ITEM            FLOAT;
DECLARE @V_VALOR_TEMP               FLOAT;
DECLARE @VDB_PEDI_PRECO_UNIT        FLOAT;
DECLARE @VDB_PEDI_QTDE_SOLIC        INT;
DECLARE @VDB_PEDI_QTDE_CANC         INT;
DECLARE @VPED_REGRAPERCENTUALECO    INT;
DECLARE @V_VALOR_BRUTO_ITEM         FLOAT;
DECLARE @V_POL_BONIMOTIVOBRIG_LIB    INT;
DECLARE @V_POL_INDDESCCABMOTDESOBRIG_LIB   VARCHAR(50);
DECLARE @V_VALIDA_DESCONTO           INT;
DECLARE @V_POL_INDDESCTOITMOTDESOBRIG_LIB  VARCHAR(50);  
DECLARE @V_POL_DESCTOINVEST_LIB      INT;
DECLARE @V_MOTIVO_INVESTIMENTO        INT;
DECLARE @V_TEMP_COUNT                INT;
DECLARE @V_AVALIACAOLIMCREDITO      INT;
DECLARE @V_MOTNLIBERADOSALVARPEDIDO VARCHAR(30);
DECLARE @V_DB_CLIR_PRAZO_MAX          FLOAT;
DECLARE @V_LIB_PRZMEDEXCCLI           FLOAT;
DECLARE @V_VALOR_LIQ_TOTAL_DESCONTOS  FLOAT
      , @V_VALOR_BRU_TOTAL            FLOAT
	  , @V_DESCONTO_MEDIO_PEDIDO      FLOAT;
DECLARE @V_SOLICITACAO_BLOQUEADA      INT;
DECLARE @V_VERIFICA_MOTIVO_BLOQ78     INT;
DECLARE @V_JSON						  VARCHAR(MAX);
DECLARE @V_URL						  VARCHAR(150);
DECLARE @VPOINTER					  INT;
DECLARE @VRESPONSETEXT				  VARCHAR(8000);
DECLARE @VSTATUS					  INT;
DECLARE @VSTATUSTEXT				  VARCHAR(200);
DECLARE @UNWRAPPEDXML				  NVARCHAR(4000);
DECLARE @V_ALCP_AVALIADESCONTO        SMALLINT;
DECLARE @V_ITEM_DSCTO_0               FLOAT;
DECLARE @V_ITEM_DSCTO_1               FLOAT;
DECLARE @V_ITEM_DSCTO_2               FLOAT;
DECLARE @V_ITEM_DSCTO_3               FLOAT;
DECLARE @V_ITEM_DSCTO_4               FLOAT;
DECLARE @V_ITEM_DSCTO_5               FLOAT
      , @V_ITEM_DSCTO_6               FLOAT
	  , @V_ITEM_DSCTO_7               FLOAT
	  , @V_ITEM_DSCTO_8               FLOAT
	  , @V_ITEM_DSCTO_9               FLOAT
	  , @V_ITEM_DSCTO_10              FLOAT
DECLARE @V_PED_DSCTO				FLOAT;
DECLARE @V_PED_DSCTO2			    FLOAT;
DECLARE @V_PED_DSCTO3			    FLOAT;
DECLARE @V_PED_DSCTO4			    FLOAT;
DECLARE @V_PED_DSCTO5			    FLOAT;
DECLARE @V_PED_DSCTO6			    FLOAT;
DECLARE @V_PED_DSCTO7			    FLOAT;
DECLARE @V_ALCP_INDICEDESCITEM        VARCHAR(50);
DECLARE @V_ALCP_REGRAEXCDESCONTO      FLOAT;
DECLARE @V_DESCTO_ITEM_REGRA          FLOAT;
DECLARE @V_ALCP_TIPOAVALIADESCONTO    SMALLINT;
DECLARE @V_LIB_DCTMAX_ITEM            FLOAT;
DECLARE @V_PED_DCTO_ITEM              FLOAT;
DECLARE @V_CODIGO_PRODUTO			  VARCHAR(16);
DECLARE @V_TIPO						  VARCHAR(4);
DECLARE @V_MARCA					  VARCHAR(4);
DECLARE @V_FAMILIA					  VARCHAR(8);
DECLARE @V_GRUPO					  VARCHAR(8);
DECLARE @V_SEQ_ITEM                   INT;
DECLARE @VDB_PEDD_DESCONTO            FLOAT;
DECLARE @VDB_PEDD_INDDESCTO           INT;
DECLARE @V_PRECO_POLITICA             FLOAT;
DECLARE @V_PRECO_APLICADO             FLOAT;
DECLARE @V_PRECO_BRUTO_UNIT           FLOAT;
DECLARE @V_QUANTIDADE_ITEM_ECON       FLOAT;
DECLARE @VPED_NRODESCTOITEM           INT;
DECLARE @V_STATUS_PED                 INT;
DECLARE @V_STATUS_PED_ATUAL           INT;
DECLARE @V_STATUS_VALIDO              INT;
DECLARE @V_PERCENTUAL_MAXIMO_REDUCAO  FLOAT;
DECLARE @V_TIPO_AGRUPAMENTO           INT;
DECLARE @V_FATURAMENTO_LIQUIDO		  FLOAT;
DECLARE @V_VALOR_IMPOSTOS			  FLOAT;
DECLARE @V_VALOR_FRETE				  FLOAT;
DECLARE @V_PESO_BRUTO				  FLOAT;
DECLARE @V_AGRUPAMENTO				  VARCHAR(50);
DECLARE @V_VALOR_AGRUPAMENTO_MINIMO   VARCHAR(50);
DECLARE @VDB_PEDM_AGRUPAMENTO		  VARCHAR(100);
DECLARE @VDB_PEDM_VALOR_AGRUPAMENTO   VARCHAR(100);
DECLARE @V_COUNT_AGRUPAMENTOS		  INT;
DECLARE @V_NUMERO_AGRUPAMENTOS		  INT;
DECLARE @V_TOTAL_AGRUPAMENTO          FLOAT;
DECLARE @V_SEQ_DOC                    INT;
DECLARE @V_EXISTE_DOC_BLOQ			  INT;
DECLARE @DB_ALCP_LSTTIPODOC           VARCHAR(1052);
DECLARE @V_LIB_BLOQXDEBITOCONTA       INT
      , @V_DB_PEDC_CONTAINV_SUP       FLOAT
	  , @V_VALOR_LANCAMENTO           FLOAT
DECLARE @V_SEQ_LANCAMENTOS            BIGINT
DECLARE @V_ACRESCIMO_PEDIDO           FLOAT;
DECLARE @V_ACRESCIMO_PEDIDO_POL       FLOAT;
DECLARE @V_ACRESCIMO_ITEM             FLOAT;
DECLARE @V_DB_PEDD_TPDESC             FLOAT;
DECLARE @V_DB_PEDI_ACRESCIMO          FLOAT;
DECLARE @V_DB_PED_LISTA_PRECO		  VARCHAR(50);
DECLARE @V_INDICE_DESCTO_FINANCEIRO   INT;
DECLARE @V_PRECO_APLICADO_TOTAL       FLOAT;
DECLARE @V_PRECO_TOTAL_POLITICA       FLOAT;
DECLARE @V_ECONOMIA_ITEM              FLOAT;
DECLARE @V_SEQ_ITEM_BLOQ_K            INT;
DECLARE @V_DESCONTO_APLICADO          FLOAT;
DECLARE @V_DESCONTO_CALCULADO         FLOAT;
DECLARE @V_VALOR_BASE                 FLOAT;
DECLARE @V_PRECO_LIQUIDO_K            FLOAT;
DECLARE @V_PRECO_BRUTO_K              FLOAT;
DECLARE @V_QUANTIDADE_K               INT;
DECLARE @V_BASE_DESCTO_FINANCEIRO     INT;
DECLARE @V_PRECO_COM_IMPOSTOS_K       FLOAT;
DECLARE @V_VALOR_INIT_DESC_FINAN      FLOAT;   
DECLARE @VDB_ALCP_DCTOMAXVERBA		  FLOAT;
DECLARE @VDB_ALCP_VLRMAXTPPED         FLOAT;
DECLARE @VLIB_GRAVAJUSTIFICATIVAPED   INT;
DECLARE @V_TEMP_MOT_LIB_TOT           VARCHAR(30);
DECLARE @V_CLI_AREAATU				  VARCHAR(12);
DECLARE @V_USUARIO_PARA_LOG           VARCHAR(50)
DECLARE @V_COMPLEMENTO_LOG            VARCHAR(800)
DECLARE @V_DB_ALCP_DCTOMAXJUSTIF     FLOAT;
DECLARE @V_DESCONTO_PED_ITEM         FLOAT; -- VARIAVEL QUE EH ARMAZENADA PARA VALIDAR SE DEVE EXIGIR JUSTIFICATIVA PARA O BLOQUEIO "D"
DECLARE @V_EXIGE_JUSTIFICATIVA_MOT_D INT;
DECLARE @V_PED_RECALCULAMOTBLOQP     INT;
DECLARE @V_DATA3					 DATE;
DECLARE @VDB_PED_DT_PREVENT			 DATE;
DECLARE @VDB_PED_DT_PRODUC			 DATE;
DECLARE @VDB_PEDC_PREV_FAT           DATE;
DECLARE @V_PERCMINIMO_LUCR_ITEM      FLOAT;
DECLARE @V_FORMA_AVALIA_LUCRA		 INT;
DECLARE @V_VALIDA_BLOQ_93			 INT;
DECLARE @V_LIMPA_BLOQ_L_ITENS       INT; -- PARA LIMPAR O CAMPO DB_PEDI_BLOQLUC , CASO NENHUM ITENS FIQUE BLOQUEADO POR L
DECLARE @V_LIMPA_BLOQ_L_PEDIDO      INT;
DECLARE @VDB_PEDC_BLOQLUC            INT; -- CAMPO QUE DIZ SE O PEDIDO ESTA BLOQUEDO POR LUCRATIVIDADE
DECLARE @V_GRAVALOG                  INT;
DECLARE @VDB_ALCP_DIASAMAIS          INT;
DECLARE @VDB_PEDC_DD_CPGTO			 INT;
DECLARE @DB_ALCP_REJEITA			 INT;
DECLARE @V_MENSAGEM_REJEICAO         VARCHAR(4000);
DECLARE @VDB_ALCP_VLR_MAX_DESCPROM   FLOAT;
DECLARE @V_VALIDA_BLOQ_D_99          INT;
DECLARE @V_PED_DESCTO_VLR		     FLOAT;
DECLARE @V_CODIGO_NOTIFICACAO        INT;
DECLARE @V_USUARIO_NOTI				 INT;
DECLARE @V_USUARIO_SERVICO			 INT;
DECLARE @V_DB_CLI_NOME				 VARCHAR(1000);
DECLARE @V_OBS_TEMP					 VARCHAR(4000);
DECLARE @V_BON_INVESTIMENTO			 FLOAT;
DECLARE @V_PED_INDICEDESCCABINVEST   VARCHAR(200);
DECLARE @V_MENSAGEM_AUX_REJEICAO	VARCHAR(200);
DECLARE @V_SEQ_ALCADA_PROJETADA		INT;
DECLARE @V_ALCADAS_PRIORITARIAS		  VARCHAR(250) = '';
DECLARE @V_COUNT_ALCADA				  INT;
DECLARE @V_EXISTE_ALCADA			  INT;
DECLARE @V_ALCADA_TEMP_PRI			  VARCHAR(50);
DECLARE @V_ALCADA_E_PRIORITARIA		  INT;
DECLARE @V_GRUPO_ALCADA				  VARCHAR(12);
DECLARE @V_GRUPO_LIBERACAO			  INT;
DECLARE @V_PERMITE_LIBERA_PRIORITARIA INT;
DECLARE @VDB_ALCP_LIBPRIORITARIA	  INT;
DECLARE @VDB_ALCP_GRUPOLIB			  INT; 
DECLARE @VDB_ALCP_GRPALCADA			  VARCHAR(12);
DECLARE @VMOTIVOS_NAO_RECALCULA       VARCHAR(50);
DECLARE @VCOUNT_BLOQ				  INT;
DECLARE @VMOTIVO_BLOQ				  VARCHAR(10);
DECLARE @VMOTIVOS_BLOQ_LIB_NOVO       VARCHAR(50);
DECLARE @V_PEDAL_ITEMLIB_D_TODOS	  VARCHAR(1024);
DECLARE @V_PEDAL_ITEMLIB_D_ATUAL	  VARCHAR(1024);
DECLARE @SEQS_ITEM					  VARCHAR(4000)
DECLARE @V_BLO_ITEM_D				  INT;
DECLARE @V_VALIDA_DATA_LISTA_PRECO    INT;
DECLARE @V_LISTA_FORA_VALIDADE_PRODS  VARCHAR(4000);
DECLARE @V_PRODUTO					  VARCHAR(100);
DECLARE @V_MENSAGEM_ERRO			  VARCHAR(4000)
DECLARE @V_DB_PRECO_DATA_INI		  DATETIME  
DECLARE @V_DB_PRECO_DATA_FIN		  DATETIME
DECLARE @V_ITEM_TEM_DESCONTOS		  INT;
DECLARE @V_ALCP_ITEMSEMDESC			  INT;
DECLARE @VDB_PEDI_ECON_VLR			  FLOAT;
DECLARE @VLIB_GRAVAMSGPEDIDO		  INTEGER;
DECLARE @V_PEDIDO_COM_LIBERACOES      INT;
DECLARE @V_LIB_MOTIVOREJEITALISTA     INT;
DECLARE @V_REJEITA_LISTA_PRECO		  INT;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR          ALTERACAO
---  1.00001  11/05/2012  TIAGO          ROTINA UTILIZADA PARA LIBERAC?O DE PEDIDOS PELO MERCANET WEB NOVO 
---  1.00002  04/10/2012  ALENCAR        Ajuste no encaminhar para superior
---  1.00003  20/11/2012  ALENCAR        Ajuste no begin - end correto
---  1.00004  28/11/2012  ALENCAR		 Definicao da variavel @V_PED_CLIENTE como float
---                                      Utiliza RTRIM no testes das variaveis not null 
---                                      Ajustes gerais - testes Riclan
---  1.00005  29/11/2012  ALENCAR        Gravar os motivos de liberacao corretamente e enviar para a proxima alcada
---  1.00006  30/11/2012  ALENCAR        Ajustes gerais
---  1.00007  03/12/2012  ALENCAR        Alterações nos campos de parametros com Ueslei 
---                                      Gravar os campos DB_PED_LIB_MOTS, DB_PED_LIB_USUS, DB_PED_LIB_DATAS corretamente para manter a funcionalidade no Server
---										 Grava o campo DB_PED_LIB_MOTS corretamente
---  1.00008  04/12/2012  ALENCAR        Busca a alcada de liberacao conforme a alcada que o pedido esta bloqueado no momento, tratativa feita
---                                      para os casos de clientes que possuem mais de uma alcada em grupos diferentes
---                                      		  and db_alcp_codigo = V_ALCADA_ATUAL     
---  1.00005  11/12/2012  ALENCAR        Passa a gravar os campos de justificativa para os motivos que exigem
---  1.00009  13/12/2012  ALENCAR        Grava o campo DB_PEDAL_MOTLIBPAR na DB_PEDIDO_ALCADA
---                                      Quando encaminha para superior deve gravar o campo DB_PEDAL_MOTLIBPAR
---  1.00010  13/03/2013  tiago          gravacao de logs
---  1.00011  03/04/2013  tiago          incluido lef join na db_cliente_compl
---  1.00012  16/04/2013  tiago          validacao de limite de verda
---  1.00013  27/05/2013  Alencar        Valida o campo DB_ALCP_OPCREP corretamente quando opção para excluir representantes
---  1.00014  13/06/2013  Tiago          se pedido for igual a 0(bloqueado) nao executa procedure
---  1.00015  11/09/2013  Tiago          bloqueia D, verifica percentual de desconto maximo que usuario pode liberar
---  1.00016  25/09/2013  Sergio Lucchini  Incluido workflow de Pedido a Ser Liberado - Próxima Alçada e Pedido Liberado Total, codigos 18 e 19. Chamado 60316
---  1.00017  01/10/2013  Alencar        Ao chamar a rotina de workflow passa o usuário correto, cfme o parâmetro p_usuario
---  1.00018  21/10/2013  Cristofer      Consistencia dos pedidos de orçamento para não ser considerado pelas Alçadas.
---  1.00019  17/04/2014  Tiago          Alterado if do desconto por 'D', no percentual de desconto maximo
---  1.00020  08/08/2014  Tiago          ajustado calculo do desconto excedido e economia no motivo 'D'
---- 1.00021  25/11/2014  tiago          ajustes no calculo do bloqueio 'D'
---- 1.00022  27/11/2014  tiago          Validação de maior desconto excedido de item
---- 1.00023  05/12/2014  tiago          ajustes no cursor que busca os motivos ja liberados
---- 1.00024  06/07/2015  tiago          retirado update que libera pedido caso nao encontre nehuma alcada, tanto na insercao do pedido quanto no encaminhar, tarefa TFS 14217
---- 1.00025  01/03/2016  tiago          ajuste na liberacao do pedido quando tem algum motivo que nao o bloqueia
---- 1.00026  02/03/2016  tiago          nao grava codigo e observacao da justificativa quando ela e passada por parametro e o motivo nao exija
---- 1.00027  21/03/2016  tiago          incluido validacao para desconto medio
---- 1.00028  29/03/2016  tiago          ajuste motivo D, passando a avaliar parametro PED_REGRAPERCENTUALECO para realizar o calculo
---- 1.00029  09/09/2016  tiago          passa a verificar parametro para buscar limite de credito do cliente
---- 1.00028  19/05/2016  TIAGO          valida no bloquei D, F os motivos de investimentos
---- 1.00029  14/07/2016  SERGIO LUCCHINI  GRAVAR ZERO NO CAMPO DB_PEDC_CODINTEGR DA TABELA DB_PEDIDO_COMPL SEMPRE QUE O PEDIDO FOR LIBERADO. CHAMADO 73093.
---- 1.00030  06/07/2016  ALENCAR        Utiliza em toda a procedure as variáveis com o nome exato que elas foram definidas. Isso deve ser feito para compilar
----                                     corretamente em bancos Case Sensitive.
----                                     Alteracoes para solicitação de investimento Fini - Quando bloqueio por D que exige motivo de investimento e o pedido não tem motivo de investimento,
----                                     deve devolver msg pelo @P_ERROLIMVERBA e sair da rotina sem atualizar o registro na DB_PEDIDO_ALCADA
---- 1.00031  15/08/2016  TIAGO          avalia Prazo Médio Máximo Excedido do Cliente no motivo C
---- 1.00032  05/01/2017  Alencar        Avalia corretamente o parâmetro Desconto Medio do pedido (DB_ALCP_DESCTOMEDIO), sendo que deve avaliar considerando a media 
----                                        de descontos do pedido (estava considerando item a item e não o pedido inteiro)
---- 1.00033  10/11/2017  Alencar        Gravar o campo DB_PEDC_DTULTLIB com a data do momento da liberacao
---- 1.00034  24/01/2018  Alencar        Acrescentado mais 5 descontos de itens
----                                     Encontrar corretamente os descontos da politica na capa    
---- 1.00035  29/01/2018  Alencar        No Motivo D-Descontos, avaliar o parâmetro Desconto Unico (PED_NRODESCTOITEM)
---- 1.00036  30/01/2018  Alencar        Não existe o indice desconto 0 na DB_PED_DESCONTO, por isso, o trecho que alimentava a @v_item_dscto_0 foi removido
----                                     Correção na leitura da DB_PEDIDO_DESCONTO
---- 1.00037  26/06/2018  Alencar, Jaime e Patricia Sempre que a alcada estiver definida para avaliar por excedido do item, está sendo avaliado o parâmetro da economia
----									            Nestes casos, sempre que este parametro for 0-cascata(cobre Liquido) ou 3-excedido(sobre liquido) deve fazer o mesmo calculo
---- 1.00038  29/08/2018  Alencar        ALTERACAO NO TESTE DO MOTIVO DE BLOQUEIO POR 'D' e 'F' NO SELECT DE BUSCA DAS ALCADAS, CFME ALTERACAO FEITA POR JAIME NA BAGE
---- 1.00039  11/09/2018  Alencar        Ao percorrer a estrutura da alçada foi retirado o teste Z.DB_EREG_SEQ = 1
---- 1.00040  10/01/2018  Alencar        PROJETO CANAL DIRETO:
----                                         Quando zera as alcadas deve eliminar os lancamentos de debito do pedido (85733)
----                                         Quando libera motivo X grava lancamento de debito na conta de investimento
---- 1.00041  11/01/2019  Alencar        Tratar a liberação de pedidos bloqueados por F considerando o valor do pedido, além do percentual
---- 1.00042  29/01/2019  Alencar        PROJETO CANAL DIRETO: Ajustes conforme validacao da equipe de testes, bloqueio X
----                                     Quando nao tem conta de investimento nao deve permitir liberar por X
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
BEGIN TRANSACTION
	SET @V_GRAVALOG = 0
	SELECT @V_GRAVALOG = DB_PRMS_VALOR
	  FROM DB_PARAM_SISTEMA
	 WHERE DB_PRMS_ID = 'MERCP_GRAVALOG'
	 IF @V_GRAVALOG = 1
	 BEGIN
		INSERT INTO DBS_ERROS_TRIGGERS
		(DBS_ERROS_OBJETO, DBS_ERROS_DATA, DBS_ERROS_ERRO)
		VALUES
		('MERCP_LIBERCAO_PEDIDO_LOG', GETDATE(), 'Pedido: ' + CAST(@P_NRO AS VARCHAR) + ' - Usu: ' + ISNULL(@P_USUARIO, 'null') + ' - acao: ' + CAST(@P_ACAO AS VARCHAR) + ' - exclui: ' + CAST(@P_EXCLUI AS VARCHAR) + ' - Inicia liberacao')
	 END
  SELECT @V_SITUACAO = DB_PED_SITUACAO
    FROM DB_PEDIDO
   WHERE DB_PED_NRO = @P_NRO; 
  IF @V_SITUACAO = 0
  BEGIN  
	IF @V_GRAVALOG = 1
	 BEGIN
		  INSERT INTO DBS_ERROS_TRIGGERS
		  (DBS_ERROS_OBJETO, DBS_ERROS_DATA, DBS_ERROS_ERRO)
		  VALUES
		  ('MERCP_LIBERCAO_PEDIDO_LOG', GETDATE(), 'Pedido: ' + CAST(@P_NRO AS VARCHAR) + ' - Usu: ' + ISNULL(@P_USUARIO, 'null') + ' - acao: ' + CAST(@P_ACAO AS VARCHAR) + ' - exclui: ' + CAST(@P_EXCLUI AS VARCHAR) + ' - Sai procedure situacao = 0');
		  COMMIT;
		  RETURN;
	 END
    ROLLBACK;
    RETURN;
  END
  -- NAO INTEGRA PEDIDO QUE NAO IRA PARA O CORPORATIVO
  SELECT @V_INTEGRA_PEDIDO = DB_TBTPE_NEXPCORP
    FROM DB_PEDIDO 
   INNER JOIN DB_TB_TPPEDIDO ON DB_TBTPE_CODIGO   = DB_PED_TIPO                   
                            AND DB_TBTPE_NEXPCORP = 1
   WHERE DB_PED_NRO = @P_NRO; 
  IF @V_INTEGRA_PEDIDO <> 0
  BEGIN
	DELETE FROM DB_PEDIDO_ALCADA WHERE DB_PEDAL_PEDIDO = @P_NRO;
	IF @V_GRAVALOG = 1
	BEGIN
		 INSERT INTO DBS_ERROS_TRIGGERS
		  (DBS_ERROS_OBJETO, DBS_ERROS_DATA, DBS_ERROS_ERRO)
		  VALUES
		  ('MERCP_LIBERCAO_PEDIDO_LOG', GETDATE(), 'Pedido: ' + CAST(@P_NRO AS VARCHAR) + ' - Usu: ' + ISNULL(@P_USUARIO, 'null') + ' - acao: ' + CAST(@P_ACAO AS VARCHAR) + ' - exclui: ' + CAST(@P_EXCLUI AS VARCHAR) + ' - Sai procedure v_integra_pedido = 1');
  		  COMMIT;
	END
    RETURN;
  END
  SELECT @V_PROGRAMA = PROGRAM_NAME FROM SYS.DM_EXEC_SESSIONS WHERE SESSION_ID = @@SPID
  IF (SUBSTRING(@V_PROGRAMA,CHARINDEX('Internet',@V_PROGRAMA), LEN('Internet'))) = 'Internet'
  BEGIN
    SET @V_PROGRAMA = '[MercanetWEB]';
    SET @V_PED_WEB = 1;
      SELECT @V_PARAM_VALOR = DB_PRMS_VALOR         
        FROM DB_PARAM_SISTEMA
       WHERE DB_PRMS_ID = 'REGISTRA_ACOES';
	   IF @V_PARAM_VALOR = 1
		  SET @V_PERMITE_LOG = 1
	   ELSE IF @V_PARAM_VALOR = 2
	   BEGIN
			SELECT @V_REGISTRA_ACOES = REGISTRA_ACOES
				FROM DB_USUARIO
				WHERE USUARIO = @P_USUARIO; 
			IF @V_REGISTRA_ACOES = 1
			  SET @V_PERMITE_LOG = 1;
	   END
  END 
  ELSE
  BEGIN
    SET @V_PROGRAMA = '[Server]';
	SELECT @VDB_PRM_ATIVLOGUTIL = DB_PRM_ATIVLOGUTIL  FROM DB_PARAMETRO
	IF @VDB_PRM_ATIVLOGUTIL = 1
		SET @V_PERMITE_LOG = 1;
	ELSE IF @VDB_PRM_ATIVLOGUTIL = 2
	BEGIN
		SELECT @VSU1_ATIVLOGUTIL = SU1_ATIVLOGUTIL FROM MSU1 WHERE SU1_USUARIO = @P_USUARIO
		IF @VSU1_ATIVLOGUTIL = 1
			SET @V_PERMITE_LOG = 1;
	END
  END
   SET @V_PARAM_VAL_VALIDA = 0
    SELECT @V_PARAM_VAL_VALIDA = ISNULL(DB_PRMS_VALOR, 0)      
      FROM DB_PARAM_SISTEMA
     WHERE DB_PRMS_ID = 'PED_VALIDARESTRICAOBONI';    
	SET @V_PED_RECALCULAMOTBLOQP = 0
	 SELECT @V_PED_RECALCULAMOTBLOQP = ISNULL(DB_PRMS_VALOR, 0)    
      FROM DB_PARAM_SISTEMA
     WHERE DB_PRMS_ID = 'PED_RECALCULAMOTBLOQP';
    SELECT @V_PERMITE_LIBERA_PRIORITARIA = MAX(DB_PRMS_VALOR)      
      FROM DB_PARAM_SISTEMA 
     WHERE DB_PRMS_ID = 'LIB_LIBPRIORITARIA'; 
	SET @VLIB_GRAVAMSGPEDIDO = 0;
	 SELECT @VLIB_GRAVAMSGPEDIDO = DB_PRMS_VALOR
      FROM DB_PARAM_SISTEMA 
     WHERE DB_PRMS_ID = 'LIB_GRAVAMSGPEDIDO';	 
  BEGIN TRY
	SET @V_VALIDA_DATA_LISTA_PRECO = 0
      SELECT @V_VALIDA_DATA_LISTA_PRECO = DB_PRMS_VALOR
        FROM DB_PARAM_SISTEMA 
	   WHERE DB_PRMS_ID = 'LIB_VALIDALISTA'
	   SET @V_REJEITA_LISTA_PRECO = 0
	   IF @V_VALIDA_DATA_LISTA_PRECO = 1 AND ISNULL(@P_USUARIO, '') <> ''   --- aaaaaaaaaaaaaaaa
	   BEGIN
			SET @V_LISTA_FORA_VALIDADE_PRODS = ''
			SET @V_MENSAGEM_ERRO = ''
			SELECT @V_DB_PED_LISTA_PRECO = DB_PED_LISTA_PRECO
			  FROM DB_PEDIDO
			 WHERE DB_PED_NRO = @P_NRO
			--01	Avaliar a data de validade na lista de preço;
			SELECT @V_LISTA_FORA_VALIDADE_PRODS = DB_PRECO_CODIGO,
				   @V_DB_PRECO_DATA_INI = DB_PRECO_DATA_INI,
				   @V_DB_PRECO_DATA_FIN = DB_PRECO_DATA_FIN
			  FROM DB_PRECO 
			 WHERE DB_PRECO_CODIGO = @V_DB_PED_LISTA_PRECO
			   AND NOT (CAST(DB_PRECO_DATA_FIN AS DATE) >= CAST(GETDATE() AS DATE)
			   AND CAST(DB_PRECO_DATA_INI AS DATE) <= CAST(GETDATE() AS DATE))
			-- SE CONTUIA SEM VALOR, EH PQ A LISTA ESTA FORA DA DATA DE VALIDADE
			IF @V_LISTA_FORA_VALIDADE_PRODS <> ''
			BEGIN
				SET @V_MENSAGEM_ERRO = 'Rejeitado automaticamente porque a lista de preço (' + @V_LISTA_FORA_VALIDADE_PRODS + ') está fora da data de validade (' + FORMAT (@V_DB_PRECO_DATA_INI, 'dd/MM/yyyy')  + ' - ' + FORMAT (@V_DB_PRECO_DATA_FIN, 'dd/MM/yyyy') +').'
			END		
			ELSE
			BEGIN
			    --02	Avaliar a data de validade do preço do produto;
				DECLARE CUR_PED_ITEM_LISTA_PRECO CURSOR
				 FOR SELECT DB_PEDI_PRODUTO
					   FROM DB_PEDIDO_PROD, DB_PRECO_PROD
					  WHERE DB_PEDI_PEDIDO = @P_NRO 	
						AND DB_PRECOP_PRODUTO = DB_PEDI_PRODUTO
						AND DB_PRECOP_CODIGO = @V_DB_PED_LISTA_PRECO
						AND NOT (CAST(DB_PRECOP_DTVALF AS DATE) >= CAST(GETDATE() AS DATE)
						AND CAST(DB_PRECOP_DTVALI  AS DATE) <= CAST(GETDATE() AS DATE))
						AND DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_CANC - DB_PEDI_QTDE_ATEND > 0
				OPEN CUR_PED_ITEM_LISTA_PRECO
				FETCH NEXT FROM CUR_PED_ITEM_LISTA_PRECO
				INTO @V_PRODUTO
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @V_LISTA_FORA_VALIDADE_PRODS = @V_LISTA_FORA_VALIDADE_PRODS + @V_PRODUTO + ', '
				FETCH NEXT FROM CUR_PED_ITEM_LISTA_PRECO
				INTO @V_PRODUTO
				END
				CLOSE CUR_PED_ITEM_LISTA_PRECO
				DEALLOCATE CUR_PED_ITEM_LISTA_PRECO	
				IF @V_LISTA_FORA_VALIDADE_PRODS <> ''
				BEGIN
					SET @V_MENSAGEM_ERRO = 'Rejeitado automaticamente devido à validade dos produtos na lista de preço (' + @V_DB_PED_LISTA_PRECO + '): ' + SUBSTRING(@V_LISTA_FORA_VALIDADE_PRODS, 1, len(@V_LISTA_FORA_VALIDADE_PRODS) - 1) + '.'
				END
			END
			--03 – Avaliar se o produto existe na lista de preço:
			IF @V_MENSAGEM_ERRO  = ''
			BEGIN
				DECLARE CUR_PED_ITEM_LISTA_PRECO CURSOR
				 FOR SELECT DB_PEDI_PRODUTO
				       FROM DB_PEDIDO_PROD
					  WHERE DB_PEDI_PEDIDO = @P_NRO
					    AND DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_CANC - DB_PEDI_QTDE_ATEND > 0
					    AND NOT EXISTS (SELECT 1 FROM DB_PRECO_PROD WHERE DB_PRECOP_CODIGO = @V_DB_PED_LISTA_PRECO AND DB_PRECOP_PRODUTO = DB_PEDI_PRODUTO)				 
				OPEN CUR_PED_ITEM_LISTA_PRECO
				FETCH NEXT FROM CUR_PED_ITEM_LISTA_PRECO
				INTO @V_PRODUTO
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @V_LISTA_FORA_VALIDADE_PRODS = @V_LISTA_FORA_VALIDADE_PRODS + @V_PRODUTO + ', '
				FETCH NEXT FROM CUR_PED_ITEM_LISTA_PRECO
				INTO @V_PRODUTO
				END
				CLOSE CUR_PED_ITEM_LISTA_PRECO
				DEALLOCATE CUR_PED_ITEM_LISTA_PRECO	
				IF @V_LISTA_FORA_VALIDADE_PRODS <> ''
				BEGIN
					SET @V_MENSAGEM_ERRO = 'Rejeitado automaticamente porque os produtos não existem na lista de preço (' + @V_DB_PED_LISTA_PRECO + '): ' + SUBSTRING(@V_LISTA_FORA_VALIDADE_PRODS, 1, len(@V_LISTA_FORA_VALIDADE_PRODS) - 1) + '.'
				END
			END
			--04 – Avaliar se o produto está ativo na lista de preço:
			IF @V_MENSAGEM_ERRO  = ''
			BEGIN
				DECLARE CUR_PED_ITEM_LISTA_PRECO CURSOR
				 FOR SELECT DB_PEDI_PRODUTO
					   FROM DB_PEDIDO_PROD, DB_PRECO_PROD
					  WHERE DB_PEDI_PEDIDO = @P_NRO 	
						AND DB_PRECOP_PRODUTO = DB_PEDI_PRODUTO
						AND DB_PRECOP_CODIGO = @V_DB_PED_LISTA_PRECO	
						AND DB_PRECOP_SITUACAO <> 'A'
						AND DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_CANC - DB_PEDI_QTDE_ATEND > 0
				OPEN CUR_PED_ITEM_LISTA_PRECO
				FETCH NEXT FROM CUR_PED_ITEM_LISTA_PRECO
				INTO @V_PRODUTO
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @V_LISTA_FORA_VALIDADE_PRODS = @V_LISTA_FORA_VALIDADE_PRODS + @V_PRODUTO + ', '
				FETCH NEXT FROM CUR_PED_ITEM_LISTA_PRECO
				INTO @V_PRODUTO
				END
				CLOSE CUR_PED_ITEM_LISTA_PRECO
				DEALLOCATE CUR_PED_ITEM_LISTA_PRECO	
				IF @V_LISTA_FORA_VALIDADE_PRODS <> ''
				BEGIN
					SET @V_MENSAGEM_ERRO = 'Rejeitado automaticamente porque os produtos não estão ativos na lista de preço (' + @V_DB_PED_LISTA_PRECO + '): ' + SUBSTRING(@V_LISTA_FORA_VALIDADE_PRODS, 1, len(@V_LISTA_FORA_VALIDADE_PRODS) - 1) + '.'
				END
			END
			IF @V_MENSAGEM_ERRO <> ''
			BEGIN
				SET @V_PEDIDO_COM_LIBERACOES = 0
				SELECT @V_PEDIDO_COM_LIBERACOES = COUNT(1)
				 FROM DB_PEDIDO_ALCADA
				WHERE DB_PEDAL_PEDIDO = @P_NRO
				SELECT @V_PED_REPRES = DB_PED_REPRES
				  FROM DB_PEDIDO WHERE DB_PED_NRO = @P_NRO
				SET @V_LIB_MOTIVOREJEITALISTA = 0;
				 SELECT @V_LIB_MOTIVOREJEITALISTA = DB_PRMS_VALOR
				  FROM DB_PARAM_SISTEMA 
				 WHERE DB_PRMS_ID = 'LIB_MOTIVOREJEITALISTA'; 					 
				IF ISNULL(@V_LIB_MOTIVOREJEITALISTA, 0) = 0
				BEGIN
					SET @V_MENSAGEM_ERRO = @V_MENSAGEM_ERRO + ' O Motivo de Rejeição não está configurado no parâmetro geral.'
				END
				ELSE IF @V_PEDIDO_COM_LIBERACOES > 1
				BEGIN
					SET @V_MENSAGEM_ERRO = @V_MENSAGEM_ERRO + ' O processo de liberação será reiniciado.'
				END
				SET @P_CODIGOJUSTIFICATIVA = @V_LIB_MOTIVOREJEITALISTA
				SET @P_ERROLIMVERBA = @V_MENSAGEM_ERRO
				INSERT INTO DB_MENSAGEM (
											DB_MSG_REPRES,
											DB_MSG_SEQUENCIA,
											DB_MSG_DATA,
											DB_MSG_USU_ENVIO,
											DB_MSG_USU_RECEB,
											DB_MSG_MOTIVO,
											DB_MSG_PEDIDO,
											DB_MSG_CLIENTE,
											DB_MSG_TIPO,
											DB_MSG_TEXTO,
											DB_MSG_VISTO,
											DB_MSG_MOTIVO_REJEICAO,
											DB_MSG_ALCADA_REJEICAO)
									VALUES (@V_PED_REPRES,
											(SELECT ISNULL(MAX(DB_MSG_SEQUENCIA), 0) + 1 FROM DB_MENSAGEM WHERE DB_MSG_REPRES = @V_PED_REPRES),
											GETDATE(),
											@P_USUARIO,
											'',
											'',
											@P_NRO,
											0,
											6,
											@V_MENSAGEM_ERRO,
											0,
											@V_LIB_MOTIVOREJEITALISTA,
											(SELECT TOP 1 DB_PEDAL_ALCADA FROM DB_PEDIDO_ALCADA	 WHERE DB_PEDAL_PEDIDO = @P_NRO AND DB_PEDAL_STATUS IN (0,9)))											
				SET @P_ACAO = 4
				SET @V_REJEITA_LISTA_PRECO = 1
			END	
	   END
    --------------------- REJEIÇÃO DE PEDIDOS ----------------------------------------------------
	  IF @P_ACAO = 4 OR @P_ACAO = 6
	  BEGIN
	    IF ISNULL(@P_USUARIO, '') = ''
		BEGIN
			INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES ('USUÁRIO NÃO INFORMADO', GETDATE(), @VOBJETO);
			COMMIT;
			RETURN;
		END
		BEGIN
			SELECT @V_CODIGO_USUARIO = CODIGO 
			FROM DB_USUARIO
			WHERE USUARIO = @P_USUARIO;
			IF ISNULL(@V_CODIGO_USUARIO, '') = ''
			BEGIN
				SET @VDATA = GETDATE();
				SET @VERRO = 'PEDIDO ' + CAST(@P_NRO AS VARCHAR) + ' NÃO FOI POSSIVEL ENCONTRAR USUARIO DE LIBERACAO: ' + @P_USUARIO + ' ';
				INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, @VDATA, @VOBJETO);
				COMMIT;
				RETURN;
			END
	    END
		IF ISNULL(@P_USUARIO, '') <> ''
		BEGIN
			IF @V_PERMITE_LIBERA_PRIORITARIA = 1
			BEGIN
				SET @V_ALCADA_OK = 0
				SELECT TOP 1 @V_ALCADA_ATUAL = DB_PEDAL_ALCADA , 
					   @V_ALCADA_OK = 1, 
					   @V_ALCADA_E_PRIORITARIA = CASE WHEN DB_PEDAL_STATUS = 9 THEN 1 ELSE 0 END 					
				  FROM DB_PEDIDO_ALCADA
				 WHERE DB_PEDAL_PEDIDO = @P_NRO
				  AND DB_PEDAL_STATUS IN (0,9)
				  AND EXISTS( SELECT 1
									FROM DB_ALCADA_USUARIO, DB_ALCADA_PED
								WHERE DB_ALCU_ALCADA = DB_PEDAL_ALCADA
									AND DB_ALCP_CODIGO = DB_ALCU_ALCADA
									AND DB_ALCU_USUARIO = @V_CODIGO_USUARIO
									AND DB_ALCP_REJEITA <> 0)
					ORDER BY DB_PEDAL_STATUS DESC;
				SELECT @V_ALCADA_OK = 1,
						@DB_ALCP_REJEITA = DB_ALCP_REJEITA
				  FROM DB_ALCADA_USUARIO, DB_ALCADA_PED
				 WHERE DB_ALCU_ALCADA = @V_ALCADA_ATUAL
				   AND DB_ALCU_USUARIO = @V_CODIGO_USUARIO
				   AND DB_ALCP_CODIGO = DB_ALCU_ALCADA
				   AND DB_ALCP_REJEITA <> 0;
			END
			ELSE
			BEGIN			
				SELECT @V_ALCADA_ATUAL = DB_PEDAL_ALCADA
				  FROM DB_PEDIDO_ALCADA
				 WHERE DB_PEDAL_PEDIDO = @P_NRO
				   AND DB_PEDAL_STATUS = 0;
				IF ISNULL(@V_ALCADA_ATUAL, '') <> ''
				BEGIN
					SET @V_ALCADA_OK = 0	
					SELECT @V_ALCADA_OK = 1,
						   @DB_ALCP_REJEITA = DB_ALCP_REJEITA
					  FROM DB_ALCADA_USUARIO, DB_ALCADA_PED
					 WHERE DB_ALCU_ALCADA = @V_ALCADA_ATUAL
					   AND DB_ALCU_USUARIO = @V_CODIGO_USUARIO
					   AND DB_ALCP_CODIGO = DB_ALCU_ALCADA
					   AND DB_ALCP_REJEITA <> 0;			
				END
			END
		END
		ELSE
		BEGIN
				SET @V_ALCADA_OK = 0;
		END  --FIM  @P_USUARIO IS NOT NULL
		IF @V_REJEITA_LISTA_PRECO = 1
			SET @V_ALCADA_OK = 1
		IF @V_ALCADA_OK  <> 1 
		BEGIN
			SET @VDATA = GETDATE();
			SET @VERRO = 'PEDIDO ' + CONVERT(VARCHAR, @P_NRO) + ' ESTA TENTANTO SER REJEITADO POR UM USUARIO QUE NAO PERTENCE A ALCADA ATUAL, OU A ALÇADA NÃO PERTIME REJEIÇÃO. USUARIO ' +  @P_USUARIO + ' ALCADA ATIUAL ' + @V_ALCADA_ATUAL;
			INSERT INTO DBS_ERROS_TRIGGERS(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, @VDATA, @VOBJETO);
			IF @V_GRAVALOG = 1
			BEGIN
				INSERT INTO DBS_ERROS_TRIGGERS
				(DBS_ERROS_OBJETO, DBS_ERROS_DATA, DBS_ERROS_ERRO)
				VALUES
				('MERCP_LIBERCAO_PEDIDO_LOG', GETDATE(), 'Pedido: ' + CAST(@P_NRO AS VARCHAR) + ' - Usu: ' + ISNULL(@P_USUARIO, 'null') + ' - acao: ' + CAST(@P_ACAO AS VARCHAR) + ' - exclui: ' + CAST(@P_EXCLUI AS VARCHAR)
				+ ' - Sai procedure: esta tentando ser rejeitado por um usuario que nao pertencente a alcada atual, ou a alçada não pertime rejeição. Usuario:');
			END
			COMMIT;
			RETURN;
		END
		IF @V_ALCADA_OK = 1
		BEGIN		 
            SELECT @V_STATUS_PED_ATUAL = DB_PEDC_STATUSPED,
                   @V_PED_REPRES = DB_PED_REPRES,
                   @V_PED_CLIENTE = DB_PED_CLIENTE,
                   @V_PED_EMPRESA = DB_PED_EMPRESA              
              FROM DB_PEDIDO
                 , DB_PEDIDO_COMPL
             WHERE DB_PED_NRO = DB_PEDC_NRO
               AND DB_PED_NRO = @P_NRO;
			   IF @V_REJEITA_LISTA_PRECO = 1
				SET @V_STATUS_PED_ATUAL = 0
			  SET @V_MENSAGEM_AUX_REJEICAO = ''
              IF @P_ACAO = 6 AND ISNULL(@P_RETORNARALCADA, '') <> '' 
			  BEGIN
				SELECT @V_MENSAGEM_AUX_REJEICAO = isnull(' Retornado para alçada: ' + DB_ALCP_DESCRICAO, '')
				  FROM DB_ALCADA_PED
				 WHERE DB_ALCP_CODIGO = @P_RETORNARALCADA
			  END
			  IF ISNULL(@P_OBSERVACAOJUSTIFICATIVA, '') <> '' AND LEN(@P_OBSERVACAOJUSTIFICATIVA) > 0
				SET @V_MENSAGEM_AUX_REJEICAO = '.' + @V_MENSAGEM_AUX_REJEICAO      
			  IF @V_REJEITA_LISTA_PRECO <> 1
			  BEGIN
				  INSERT INTO DB_MENSAGEM (
										  DB_MSG_REPRES,
										  DB_MSG_SEQUENCIA,
										  DB_MSG_DATA,
										  DB_MSG_USU_ENVIO,
										  DB_MSG_PEDIDO,
										  DB_MSG_TEXTO,
										  DB_MSG_MOTIVO_REJEICAO,
										  DB_MSG_ALCADA_REJEICAO 
										  )
								  VALUES (
										  @V_PED_REPRES,
										  ISNULL((SELECT MAX(DB_MSG_SEQUENCIA) FROM DB_MENSAGEM WHERE DB_MSG_REPRES = @V_PED_REPRES), 0) + 1, 
										  GETDATE(),
										  @P_USUARIO,
										  @P_NRO,
										  'Pedido rejeitado. Motivo: '
										   + ISNULL((SELECT DESCRICAO FROM DB_MOTIVO_REJEICAO WHERE CODIGO = @P_CODIGOJUSTIFICATIVA), '')
										   + '. ' + @P_OBSERVACAOJUSTIFICATIVA +
										   @V_MENSAGEM_AUX_REJEICAO +
										   '. Novo status do pedido: ' +
										   ISNULL((SELECT DESCRICAO FROM DB_STATUS WHERE CODIGO = @P_STATUSPEDIDO), '[SEM STATUS]') +
										   '. Status anterior: '  +
										   ISNULL((SELECT DESCRICAO FROM DB_STATUS WHERE CODIGO = @V_STATUS_PED_ATUAL), '[SEM STATUS]'),
										  @P_CODIGOJUSTIFICATIVA ,
										  @V_ALCADA_ATUAL
										  );
			  END
			  ---ATUALIZA O STATUS DO PEDIDO
			  IF @V_REJEITA_LISTA_PRECO = 1
			  BEGIN
				UPDATE DB_PEDIDO_COMPL
				   SET DB_PEDC_DATA_ALTERWEB = GETDATE()
			     WHERE DB_PEDC_NRO = @P_NRO;
			  END
			  ELSE
			  BEGIN
				UPDATE DB_PEDIDO_COMPL
				 SET DB_PEDC_STATUSPED     = @P_STATUSPEDIDO,
				     DB_PEDC_DATA_ALTERWEB = GETDATE()
			   WHERE DB_PEDC_NRO = @P_NRO;
			  END
			  UPDATE DB_PEDIDO
                 SET DB_PED_DATA_ENVIO = NULL
               WHERE DB_PED_NRO = @P_NRO;
			   IF @DB_ALCP_REJEITA = 2  -- DEVE BLOQUEAR O PEDIDO POR (O) OBSERVACAO
			   BEGIN
					SET @V_MENSAGEM_REJEICAO = 'Motivo de rejeição: '
									   + ISNULL((SELECT DESCRICAO FROM DB_MOTIVO_REJEICAO WHERE CODIGO = @P_CODIGOJUSTIFICATIVA), '')
									   + '. ' + ISNULL(@P_OBSERVACAOJUSTIFICATIVA, '')
					SELECT @V_OBS_TEMP = LTRIM(RTRIM(ISNULL(DB_PED_OBSERV, '') + ISNULL(DB_PEDC_OBSERV, '')))
					  FROM DB_PEDIDO, DB_PEDIDO_COMPL
					 WHERE DB_PED_NRO = DB_PEDC_NRO
					   AND DB_PED_NRO = @P_NRO
					IF ISNULL(@V_OBS_TEMP, '') = ''
					BEGIN
						SET @V_OBS_TEMP = @V_MENSAGEM_REJEICAO
					END
					ELSE
					BEGIN
						SET @V_OBS_TEMP = @V_OBS_TEMP + ' #' + @V_MENSAGEM_REJEICAO
					END
					UPDATE DB_PEDIDO
					   SET DB_PED_OBSERV = SUBSTRING(@V_OBS_TEMP, 0, 255),
					       DB_PED_MOTIVO_BLOQ = SUBSTRING(DB_PED_MOTIVO_BLOQ, 1, 10) + 'O' + SUBSTRING(DB_PED_MOTIVO_BLOQ, 12, 15) 
					 WHERE DB_PED_NRO = @P_NRO					 
					IF LEN(@V_OBS_TEMP) > 255
					BEGIN
						UPDATE DB_PEDIDO_COMPL
						   SET DB_PEDC_OBSERV = SUBSTRING(@V_OBS_TEMP, 255, 1024)
						 WHERE DB_PEDC_NRO = @P_NRO
					END
					UPDATE DB_PEDIDO_MOTBLOQ SET DB_PEDM_IDBLOQ = DB_PEDM_IDBLOQ + ';42' 
					 WHERE DB_PEDM_PEDIDO = @P_NRO 
					   AND DB_PEDM_IDBLOQ NOT LIKE '%42%'					   
			   END
			  ---REALIZADO COMMIT ANTES DE CHAMAR O WORKFLOW, POIS É PRECISO FAZER UM SELECT NESSA TABELA PARA BUSCAR O CODIGO DO MOTIVO DE REJEIÇÃO                                  
			  COMMIT;   			  
			 SET @V_DESCRICAO = @V_PROGRAMA +
							    ' Rejeitou pedido. Pedido nro: ' +
							    CAST(@P_NRO AS VARCHAR); 								  
			 IF (@V_PERMITE_LOG = 1) AND (ISNULL(@P_USUARIO, '') <> '')
			 BEGIN
				IF @V_PED_WEB = 1
				BEGIN
					INSERT INTO MSL1
						(SL1_DATA, -- DATA ATUAL
						SL1_USUARIO, --= USUÁRIO DA LIBERAÇÃO
						SL1_MENU, --= 0
						SL1_ITEM_MENUWEB, --= "LIBERAÇÃO DE PEDIDOS"
						SL1_ACAO, --= 4
						SL1_DESCRICAO)
					VALUES
						(GETDATE(), @P_USUARIO, 0, 'Liberação de pedidos', 4, @V_DESCRICAO);
				END
				ELSE
				BEGIN
					INSERT INTO MSL1
						(SL1_DATA, -- DATA ATUAL
						SL1_USUARIO, --= USUÁRIO DA LIBERAÇÃO
						SL1_MENU, --= 0
						SL1_MENUITEM, --= "LIBERAÇÃO DE PEDIDOS"
						SL1_ACAO, --= 4
						SL1_DESCRICAO)
					VALUES
						(GETDATE(), @P_USUARIO, 0, 'Liberação de pedidos', 4, @V_DESCRICAO);
				END
			 END 
			 --CHAMA NOVAMENTE A LIBERAÇÃO PARA QUE ENCONTRE NOVAMENTE UM ALÇADA PARA O PEDIDO.
			 IF @P_ACAO = 6 AND ISNULL(@P_RETORNARALCADA, '') <> '' 
			 BEGIN
				--- BUSCA QUAL EH A SEQUENCIA DA ALCADA DESEJADA
				SELECT @V_SEQ_ALCADA_PROJETADA = DB_PEDAL_SEQ
				  FROM DB_PEDIDO_ALCADA
				 WHERE DB_PEDAL_PEDIDO = @P_NRO
				   AND DB_PEDAL_ALCADA = @P_RETORNARALCADA
				IF @V_SEQ_ALCADA_PROJETADA > 0
				BEGIN
					--DELETE TODOS OS REGISTRO QUE VEM DEPOIS DA ALCADA DESEJADA
					DELETE DB_PEDIDO_ALCADA
					 WHERE DB_PEDAL_PEDIDO = @P_NRO
					   AND DB_PEDAL_SEQ > @V_SEQ_ALCADA_PROJETADA
					--ATUALIZA VALORES PARA A ALCADA DESEJADA
					UPDATE DB_PEDIDO_ALCADA
		    		   SET DB_PEDAL_USULIB = NULL
		    			  ,DB_PEDAL_DATALIB = NULL 
		    			  ,DB_PEDAL_MOTLIB = NULL
		    			  ,DB_PEDAL_ACAO = NULL
		    			  ,DB_PEDAL_STATUS = 0
		    			  ,DB_PEDAL_JUSTIF = NULL
		    			  ,DB_PEDAL_JUSTOBS = NULL
		    			  ,DB_PEDAL_JREPRES = NULL
		    			  ,DB_PEDAL_MOTLIBPAR = NULL
						  ,DB_PEDAL_ITEMLIB   = NULL
					 WHERE DB_PEDAL_PEDIDO = @P_NRO
		    		   AND DB_PEDAL_ALCADA = @P_RETORNARALCADA
			    END
			 END
			 ELSE
			 BEGIN
			   BEGIN
				EXEC DBO.MERCP_LIBERACAO_PEDIDO @P_NRO,
												1,  -- P_EXCLUI
												NULL,   --USUARIO
												1, --P_ACAO
												NULL, --P_CODIGOJUSTIFICATIVA
												NULL, --P_OBSERVACAOJUSTIFICATIVA
												NULL, --P_REPRESJUSTIFICATIVA
												0,
												@VRETORNO ,
												@VRETORNO --P_STATUSPEDIDO           
			   END
			 END
			BEGIN          
			EXEC DBO.MERCP_WORKFLOW 140,
									@V_PED_CLIENTE,
									@P_NRO,
									@V_PED_EMPRESA,
									NULL,
									NULL,
									NULL,
									NULL,
									@P_USUARIO,
									VRETORNO
			END
		  END
		  RETURN
	  END
SET @VDATA = GETDATE();
--CQMP_DEBUG(0, 'PEDIDO: ' || P_NRO  || ' P_EXCLUI ' || P_EXCLUI || ' P_USUARIO ' || ' P_ACAO ' || P_ACAO);
--COMMIT;
--- ANTES DE GRAVAR OS DADOS DE LIBERAÇÃO DO PEDIDO DEVE AVALIAR SE O MOTIVO LIBERADO EXIGE JUSTIFICATIVA. NOS CASOS EM QUE EXIGE DEVE RECEBER A JUSTIFICATIVA POR PARAMETRO.
    SET @P_MOTIVOREQUERJUSTIFICATIVA = ''
	SET @V_DESCONTO_PED_ITEM = 0
	IF ISNULL(@P_USUARIO, '') <> ''
		BEGIN
			SELECT @V_CODIGO_USUARIO = CODIGO 
			FROM DB_USUARIO
			WHERE USUARIO = @P_USUARIO;			
			IF ISNULL(@V_CODIGO_USUARIO, '') = ''
				BEGIN
					SET @VDATA = GETDATE();
					SET @VERRO = 'PEDIDO ' + CONVERT(VARCHAR, @P_NRO) + ' NÃO FOI POSSIVEL ENCONTRAR USUARIO DE LIBERACAO: ' + @P_USUARIO + ' ';
					INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, @VDATA, @VOBJETO);
					--COMMIT;
				END
	    END	  	  
	  SET @V_PASSO = '0';
	  SELECT @VMOTIVOS_NAO_RECALCULA = DB_PRMS_VALOR
		FROM DB_PARAM_SISTEMA WHERE DB_PRMS_ID = 'MOT_NAORECALCULALIB'
		SELECT @V_PED_SITCORP = DB_PED_SITCORP FROM DB_PEDIDO WHERE DB_PED_NRO = @P_NRO
		IF ISNULL(@V_PED_SITCORP, '') = ''
		BEGIN
			SET @VMOTIVOS_NAO_RECALCULA = ''
		END
	   -- EXCLUI TODOS OS REGISTROS DA DB_PEDIDO_ALCADA PARA O PEDIDO
	   IF @P_EXCLUI = 1
			BEGIN
				DELETE DB_PEDIDO_ALCADA
				 WHERE DB_PEDAL_PEDIDO = @P_NRO;
				IF ISNULL(@VMOTIVOS_NAO_RECALCULA, '') = ''				
				BEGIN					
					UPDATE DB_PEDIDO
					   SET DB_PED_LIB_MOTS     = ''
						 , DB_PED_LIB_USUS     = ''
						 , DB_PED_LIB_DATAS	   = ''
					 WHERE DB_PED_NRO = @P_NRO;
					UPDATE DB_PEDIDO_COMPL
					   SET DB_PEDC_LIB_HORAS  = ''
					 WHERE DB_PEDC_NRO  = @P_NRO;
			    END;
				BEGIN TRY
                    --- PROJETO CANAL DIRETO - QUANDO ZERA AS ALCADAS DEVE ELIMINAR OS LANCAMENTOS DE DEBITO DO PEDIDO (85733)
                    DELETE FROM DB_CC_LANCAMENTOS
                     WHERE DB_CC_LANCAMENTOS.PEDIDO = @P_NRO
                       AND EXISTS (SELECT 1
                                    FROM DB_CC_CONTA_CORRENTE        CC
                                       , DB_CI_CONTA_INVESTIMENTO    CI
                                   WHERE DB_CC_LANCAMENTOS.CONTA_CORRENTE      = CC.CONTA_CORRENTE
                                     AND CC.CONTA_INVESTIMENTO    = CI.CODIGO
                                     AND CI.TIPO = 1)
				END TRY
				BEGIN CATCH
		            SET @VDATA = GETDATE();
		            SET @VERRO = 'PEDIDO :' + CONVERT(VARCHAR, @P_NRO) + ' nao foi possivel elimnar lancamentos de debito do pedido. ' + ERROR_MESSAGE();
		            INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, @VDATA, @VOBJETO);
				END CATCH
			END
			--PRINT  'PASSO 1'
		SET @V_PASSO = '1';
		SET @V_PED_CLIENTE = NULL;
--	BEGIN
         SELECT 
                @V_PED_CLIENTE			= DB_PED_CLIENTE
			  , @V_MOTIVOS				= REPLACE(DB_PED_MOTIVO_BLOQ, ' ', '') 
              , @V_PED_MOTIVO_BLOQ		= REPLACE(DB_PED_MOTIVO_BLOQ, ' ', '')
			  , @V_DB_PED_MOTIVO_BLOQ_ALL = DB_PED_MOTIVO_BLOQ
              , @V_CLI_CGCMF			= DB_CLI_CGCMF
              , @V_CLI_VINCULO			= DB_CLI_VINCULO
              , @V_CLI_DIASAMAIS		= DB_CLIC_DD_CPGTO
              , @V_PED_COND_PGTO		= DB_PED_COND_PGTO
              , @V_CLILIM				= DB_CLI_LIM_CREDAP
              , @V_PRM_APLDESCTO		= DB_TBEMP_APLDCTO
              , @V_TBOPS_FAT			= DB_TBOPS_FAT
              , @V_LUCRATIVIDADE		= DB_PEDC_PERC_MLUCR
              , @V_BLQS					= DB_PED_LIB_MOTS
              , @V_USUS					= DB_PED_LIB_USUS
              , @V_DATAS				= DB_PED_LIB_DATAS
              , @V_HORAS				= DB_PEDC_LIB_HORAS
              , @V_BLOQUEIOS			= DB_PED_LIB_MOTS
              , @V_SITUACAO_CORPORATIVO = DB_PED_SITCORP
              , @V_UPDATE_SITUACAO		= DB_PED_SITUACAO
              , @V_UPDATE_DTULTLIBERACAO = DB_PEDC_DTULTLIB
              , @V_CLI_RAMATIV			= DB_CLI_RAMATIV
              , @V_PED_EMPRESA			= DB_PED_EMPRESA
              , @V_PED_TIPO				= DB_PED_TIPO
              , @V_CLI_CLASCOM			= DB_CLI_CLASCOM
              , @V_PED_SITCORP			= DB_PED_SITCORP
              , @V_CLI_REGIAOCOM		= DB_CLI_REGIAOCOM
              , @V_PED_OPERACAO			= DB_PED_OPERACAO
              , @V_ULTIMO_USUARIO		= DB_PED_LIB_USUS --SUBSTRING(DB_PED_LIB_USUS, (CHARINDEX(';', DB_PED_LIB_USUS, -2) + 1), (LEN(DB_PED_LIB_USUS) - CHARINDEX(';',DB_PED_LIB_USUS , -2) - 1))
              , @V_PED_REPRES			= DB_PED_REPRES
              , @V_PED_SITUACAO_ATUAL   = DB_PED_SITUACAO
			  , @V_PED_LIB_MOTS			= DB_PED_LIB_MOTS
			  , @V_STATUS_PED_ATUAL     = DB_PEDC_STATUSPED			  
			  , @V_DB_PEDC_CONTAINV_SUP = DB_PEDC_CONTAINV_SUP
			  , @V_DB_PED_LISTA_PRECO   = DB_PED_LISTA_PRECO
			  , @V_CLI_AREAATU          = DB_CLIC_AREAATU
			  , @VDB_PED_DT_PREVENT		= DB_PED_DT_PREVENT
			  , @VDB_PED_DT_PRODUC		= DB_PED_DT_PRODUC
			  , @VDB_PEDC_PREV_FAT		= DB_PEDC_PREV_FAT
			  , @V_DB_PED_DT_EMISSAO    = DB_PED_DT_EMISSAO
			  , @VDB_PEDC_BLOQLUC       = DB_PEDC_BLOQLUC
			  , @VDB_PEDC_DD_CPGTO		= DB_PEDC_DD_CPGTO
			  , @V_DB_TBREP_UNIDFV      = db_TBREP_UNIDFV 
			  , @V_PED_DESCTO_VLR       = DB_PED_DESCTO_VLR
			  , @V_DB_CLI_NOME          = DB_CLI_NOME
           FROM DB_TB_EMPRESA, DB_PEDIDO, DB_PEDIDO_COMPL, DB_TB_OPERS,DB_TB_REPRES, DB_CLIENTE
		   LEFT JOIN DB_CLIENTE_COMPL ON DB_CLI_CODIGO   = DB_CLIC_COD
          WHERE DB_PED_NRO      = @P_NRO
            AND DB_TBEMP_CODIGO = DB_PED_EMPRESA
            AND DB_PED_NRO      = DB_PEDC_NRO
            AND DB_PED_CLIENTE  = DB_CLI_CODIGO            
			AND DB_PED_REPRES = DB_TBREP_CODIGO
            AND DB_PED_OPERACAO = DB_TBOPS_COD;
--	 END -- FIM BEGIN INSERT
--PRINT '3'
	 --SELECT DB_CLIC_DD_CPGTO FROM DB_CLIENTE_COMPL
	 SET @V_BLQS = '';
	 SET @V_BLOQUEIOS = '';	
	 IF ISNULL(@VMOTIVOS_NAO_RECALCULA, '') <> '' AND @P_EXCLUI = 1
	 BEGIN
		---BUSCAR OS MOTIVOS JA LIBERADOS
		SET @VCOUNT_BLOQ = 1
		SET @VMOTIVOS_BLOQ_LIB_NOVO = ''
		WHILE @VCOUNT_BLOQ < LEN(@VMOTIVOS_NAO_RECALCULA)
		BEGIN		
			SET @VMOTIVO_BLOQ =  SUBSTRING(@VMOTIVOS_NAO_RECALCULA, @VCOUNT_BLOQ, 1)						 
			IF CHARINDEX(@VMOTIVO_BLOQ, @V_PED_LIB_MOTS) > 0
			BEGIN
				SET @VMOTIVOS_BLOQ_LIB_NOVO = @VMOTIVOS_BLOQ_LIB_NOVO + @VMOTIVO_BLOQ					
			END
			SET @VCOUNT_BLOQ = @VCOUNT_BLOQ + 1;
		END
		IF @VMOTIVOS_BLOQ_LIB_NOVO <> ''
		BEGIN
			---INSERIR MENSAGEM
			INSERT INTO DB_MENSAGEM (
										DB_MSG_REPRES,
										DB_MSG_SEQUENCIA,
										DB_MSG_DATA,
										DB_MSG_USU_ENVIO,
										DB_MSG_PEDIDO,
										DB_MSG_TEXTO)
								VALUES (
										@V_PED_REPRES,
										ISNULL((SELECT MAX(DB_MSG_SEQUENCIA) FROM DB_MENSAGEM WHERE DB_MSG_REPRES = @V_PED_REPRES), 0) + 1, 
										GETDATE(),
										@P_USUARIO,
										@P_NRO,
										'Os motivos de bloqueio ' +  @VMOTIVOS_BLOQ_LIB_NOVO + ' já foram liberados e não estão configurados para reiniciar o processo de liberação'
										);     
		END
		SET @V_BLQS = @VMOTIVOS_BLOQ_LIB_NOVO
		SET @V_BLOQUEIOS = @VMOTIVOS_BLOQ_LIB_NOVO
		SET @V_PED_LIB_MOTS = @VMOTIVOS_BLOQ_LIB_NOVO
	 END	 
	 --PRINT @P_NRO
	 SET @VLIB_GRAVAJUSTIFICATIVAPED = 0
	 SELECT @VLIB_GRAVAJUSTIFICATIVAPED =	DB_PRMS_VALOR     		                           
	   FROM DB_PARAM_SISTEMA
	  WHERE DB_PARAM_SISTEMA.DB_PRMS_ID = 'LIB_GRAVAJUSTIFICATIVAPED'
	 DECLARE C_BLOQ_LIB CURSOR
	 FOR SELECT DB_PEDAL_MOTLIB, DB_PEDAL_MOTLIB
		   FROM DB_PEDIDO_ALCADA
		   WHERE DB_PEDAL_PEDIDO = @P_NRO
	 OPEN C_BLOQ_LIB
	 FETCH NEXT FROM C_BLOQ_LIB
	 INTO @V_BLQS_AUX, @V_BLOQUEIOS_AUX	
	 WHILE @@FETCH_STATUS = 0
	 BEGIN
		SET @V_BLQS = ISNULL(@V_BLQS, '') + ISNULL(@V_BLQS_AUX, '')
		SET @V_BLOQUEIOS = ISNULL(@V_BLOQUEIOS, '') + ISNULL(@V_BLOQUEIOS_AUX, '')
	 FETCH NEXT FROM C_BLOQ_LIB
	 INTO @V_BLQS_AUX, @V_BLOQUEIOS_AUX
	 END
	 CLOSE C_BLOQ_LIB
	 DEALLOCATE C_BLOQ_LIB
		--PRINT @V_BLOQUEIOS
		--PRINT  @V_BLQS
	IF @V_UPDATE_SITUACAO <> 1
	BEGIN
		SET @VDATA = GETDATE();
		SET @VERRO = 'PEDIDO ' + CONVERT(VARCHAR, @P_NRO) + ' JA ENCONTRA-SE LIBERADO. USUARIO ' + @P_USUARIO;
		INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, @VDATA, @VOBJETO);
		--COMMIT;
	END;-- FIM  @V_PED_SITCORP <> 1
	-- SE RECEBEU USUARIO DEVE VALIDAR SE O REGISTRO DA DB_PEDIDO_ALCADA ESTA NA SUA ALCADA
    -- ISSO DEVE SER FEITO POIS 2 USUARIOS DA MESMA ALCADA PODEM TENTAR LIBERAR O MESMO PEDIDO NO MESMO INSTANTE
	IF ISNULL(@P_USUARIO, '') <> ''
	BEGIN
	   IF @V_PERMITE_LIBERA_PRIORITARIA = 1
       BEGIN
		   SET @V_ALCADA_OK = 0
           SELECT TOP 1
				  @V_ALCADA_ATUAL = DB_PEDAL_ALCADA,
				  @V_ALCADA_OK = 1, 
				  @V_ALCADA_E_PRIORITARIA = CASE WHEN DB_PEDAL_STATUS = 9 THEN 1 ELSE 0 END 
              FROM DB_PEDIDO_ALCADA
             WHERE DB_PEDAL_PEDIDO = @P_NRO
               AND DB_PEDAL_STATUS in (0,9)
               and exists( SELECT 1
                             FROM DB_ALCADA_USUARIO
                            WHERE DB_ALCU_ALCADA = DB_PEDAL_ALCADA
                              AND DB_ALCU_USUARIO = @V_CODIGO_USUARIO)              
              order by DB_PEDAL_STATUS desc;
       END
       ELSE    
	   BEGIN
			SELECT @V_ALCADA_ATUAL = DB_PEDAL_ALCADA
			  FROM DB_PEDIDO_ALCADA
			 WHERE DB_PEDAL_PEDIDO = @P_NRO
			   AND DB_PEDAL_STATUS = 0;
			IF ISNULL(@V_ALCADA_ATUAL, '') <> ''
			BEGIN
				SET @V_ALCADA_OK = 0
				SELECT @V_ALCADA_OK = 1
				  FROM DB_ALCADA_USUARIO
			  	 WHERE DB_ALCU_ALCADA = @V_ALCADA_ATUAL
				   AND DB_ALCU_USUARIO = @V_CODIGO_USUARIO			
			END
		END
	END
	ELSE
	BEGIN
			SET @V_ALCADA_OK = 1;
	END  --FIM  @P_USUARIO IS NOT NULL
	IF @V_ALCADA_OK  <> 1 
	BEGIN
		SET @VDATA = GETDATE();
		SET @VERRO = 'PEDIDO ' + CONVERT(VARCHAR, @P_NRO) + ' ESTA TENTANTO SER LIBERADOO POR UM USUARIO QUE NAO PERTENCE A ALCADA ATUAL. USUARIO ' +  @P_USUARIO + ' ALCADA ATIUAL ' + @V_ALCADA_ATUAL;
		INSERT INTO DBS_ERROS_TRIGGERS(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, @VDATA, @VOBJETO);
		--COMMIT;
	END -- FIM @V_ALCADA_OK  <> 1 
	IF ISNULL(@V_PED_CLIENTE, '') <> ''
	 -- SOMENTE EXECUTA O PROCESSO SE O PEDIDO AINDA ESTA BLOQUEADO 
		AND @V_PED_SITUACAO_ATUAL = 1 AND @V_ALCADA_OK = 1	  -- SOMENTE SE ESTA NA ALCADA DO USUARIO QUE ESTA LIBERANDO
	BEGIN
			SET @V_PASSO = 2;
			--- P_ACAO = 2 - ENCAMINHOU PARA SUPERIOR. NESSE CASO DEVE BUSCAR A PRÓXIMA ALCADA
			IF @P_ACAO = 2
				BEGIN
					SET @V_ULTIMO_USUARIO = @P_USUARIO;
				END
	BEGIN
			SET @V_PED_TOT = 0;
			SET @V_BON_TOT = 0;
			SELECT @V_PED_TOT = SUM(DB_PEDI_QTDE_SOLIC * DB_PEDI_PRECO_LIQ),
				   @V_BRUTO =   SUM(DB_PEDI_QTDE_SOLIC * DB_PEDI_PRECO_UNIT),
				   @V_ECON =    SUM(DB_PEDI_QTDE_SOLIC * DB_PEDI_ECON_VLR)
			 FROM DB_PEDIDO_PROD,   DB_PRODUTO
			WHERE DB_PEDI_PEDIDO =  @P_NRO
			  AND DB_PEDI_PRODUTO = DB_PROD_CODIGO
			  AND DB_PEDI_TIPO NOT IN ('B', 'T');
			SELECT @V_BON_TOT = SUM(DB_PEDI_QTDE_SOLIC * DB_PEDI_PRECO_LIQ)
			  FROM DB_PEDIDO_PROD, DB_PRODUTO
			 WHERE DB_PEDI_PEDIDO = @P_NRO
			   AND DB_PEDI_PRODUTO = DB_PROD_CODIGO
			   AND DB_PEDI_TIPO IN ('B');
	END
		SET @V_PASSO = 3;
	BEGIN
		SET @V_PARAM_AN_CRED = 0;
		SELECT @V_PARAM_AN_CRED				= ISNULL(DB_PRM_AN_CRED, 0),
			   @V_PARAM_TPDOC_AVAL		    = DB_PRM_TPDOC_AVAL,
			   @V_DIAS						= (DB_PRM_DD_CREDITO * - 1),
			   @V_DATA						= DB_PRM_DATA_POSCR,
			   @V_PARAM_AVALCONCEITOLUCR	= ISNULL(DB_PRM_AVCONCLUCR, 0),
			   @V_PARAM_MOTIVSLIBER			= DB_PRM_MOT_SLIBER,
			   @V_PARAM_CRIT_CRED			= DB_PRM_CRIT_CRED,
			   @VDB_PRM_JUST_LIBPAR		    = DB_PRM_JUST_LIBPAR,     
			   @VDB_PRM_JUST_LIBTOT	        = DB_PRM_JUST_LIBTOT
	      FROM DB_PARAMETRO P, DB_PARAMETRO1 P1
	     WHERE P.DB_PRM_CHAVE = P1.DB_PRM1_CHAVE;
	END -- FIM BEGIN SELECT
		SET @V_PASSO = 4;
	BEGIN
		IF @V_PRM_APLDESCTO = 0
			BEGIN
				IF @V_PED_TOT > 0
					SET @V_PED_DCTOEXC = @V_ECON * 100 / @V_PED_TOT;
			ELSE
				IF @V_BRUTO > 0
					SET @V_PED_DCTOEXC = @V_ECON * 100 / @V_BRUTO;
			END
			SET @V_PED_DCTO = @V_PED_DCTOEXC;
			SET @V_VLR_PED = @V_PED_TOT;
			SET @V_BON_INVESTIMENTO = 0			
			SET @V_VALIDA_BLOQ_D_99 = 0
			-- SE O PEDIDO ESTIVER BLOQUEIO ADO POR 98 BLOQ F, ENTAO SOMA O VALOR DE INVESTIMENTO AO TOTAL DE BONIFICACAO
			SELECT @V_VALIDA_BLOQ_D_99 = 1
				FROM DB_PEDIDO_MOTBLOQ 
			WHERE DB_PEDM_PEDIDO = @P_NRO
				AND ISNULL(DB_PEDM_IDBLOQ, '') <> ''	
				AND ';' + DB_PEDM_IDBLOQ + ';'  LIKE '%;98;%'
			SET @V_BON_INVESTIMENTO = 0
			IF @V_VALIDA_BLOQ_D_99 = 1
			BEGIN
				SET @V_PED_INDICEDESCCABINVEST = ''
				SELECT @V_PED_INDICEDESCCABINVEST = ISNULL(DB_PRMS_VALOR, '')
					FROM DB_PARAM_SISTEMA
					WHERE DB_PARAM_SISTEMA.DB_PRMS_ID = 'PED_INDICEDESCCABINVEST';					
				SELECT @V_BON_INVESTIMENTO = SUM(QUANTIDADE * VALOR)
					FROM DB_PEDIDO_DESCONTOINVEST, DB_PEDIDO_PROD
					WHERE PEDIDO = DB_PEDI_PEDIDO
					AND DB_PEDI_PEDIDO = @P_NRO
					AND APLICACAO = 'C'
					AND ITEM = DB_PEDI_SEQUENCIA
					AND ',' + @V_PED_INDICEDESCCABINVEST + ',' LIKE '%,' + CAST(INDICE_DESCONTO AS VARCHAR) + ',%'
				SET @V_VALIDA_BLOQ_D_99 = 0
			END
			IF @V_PED_TOT > 0
				SET @V_BON_PERC = ((isnull(@V_BON_TOT, 0) + isnull(@V_BON_INVESTIMENTO, 0)) * 100) / @V_PED_TOT;
			ELSE
				SET @V_BON_PERC = 0;
	END
		SET @V_PASSO = 5;
	BEGIN
		SELECT @V_PERMI =				DB_ALCP_MOTBLOQ,
			   @V_CFE_VLR =				DB_ALCP_MOTCFEVLR,
			   @V_FLG_LIB_MOTIVO_A_ALCADA =	DB_ALCP_LIBCPGTO,
		       @V_VLR_MAX =				DB_ALCP_VLRMAXLIB,
		       @V_VLR_MAXATRS =			DB_ALCP_LIMATRPGTO,
			   @V_LIB_DIVTOTMAX =		DB_ALCP_DIVTOTMAX,
			   @V_LIB_VLREXCLIM =		DB_ALCP_VLRCREDEXC,
               @V_VLR_MAXLIM =			DB_ALCP_LIMCREDEX,   -- DB_ALCP_PERCREDEXC, ALTERADO COM UESLEI EM 03/11 (ALENCAR)
			   @V_LIB_DIVLIMMAX =		DB_ALCP_DIVLIMMAX,
			   @V_LIB_DCTMAX =			DB_ALCP_DCTMAXEXC,
			   @V_LIB_PRZMED_MAX =		DB_ALCP_PRZMEDMAX,
			   @V_LIB_PRZTOT_MAX =		DB_ALCP_PRZTOTMAX,
			   @V_LIB_BONMAX =		    DB_ALCP_PERCBONMAX,
			   @V_LIB_BONMAX_VLR =      ISNULL(DB_ALCP_VLRMAXBON, 0),
			   @V_USU_PERCMINIMO_LUCR = DB_ALCP_PERCMINLUC,
               @V_LIBERA_PEDIDO =		DB_ALCP_TIPOVLRLIB,
			   @V_LIB_LIMITEEXCEDIDO =  DB_ALCP_LEXCVMAX, -- DB_ALCP_LIMCREDEX, ALTERADO COM UESLEI EM 03/11 (ALENCAR)
			   @V_GRUPO_LIB =			DB_ALCP_GRUPOLIB,
			   @VDB_ALCP_INDTOTDCTO   = DB_ALCP_INDTOTDCTO,
			   @VDB_ALCP_TOTDCTO  	  = DB_ALCP_TOTDCTO,
			   @VDB_ALCP_ECONOMIA     = DB_ALCP_ECONOMIA,
			   @VDB_ALCP_DESCTOMEDIO  = DB_ALCP_DESCTOMEDIO,
			   @V_LIB_PRZMEDEXCCLI    = DB_ALCP_PRZMEDEXCCLI,
			   @V_ALCP_AVALIADESCONTO = DB_ALCP_AVALIADESCONTO,
			   @V_ALCP_TIPOAVALIADESCONTO  = DB_ALCP_TIPOAVALIADESCONTO,
			   @V_ALCP_REGRAEXCDESCONTO  = DB_ALCP_REGRAEXCDESCONTO,
			   @V_ALCP_INDICEDESCITEM   =  DB_ALCP_INDICEDESCITEM,
			   @V_PERCENTUAL_MAXIMO_REDUCAO = DB_ALCP_PMENORPMTON ,
			   @DB_ALCP_LSTTIPODOC	    = DB_ALCP_LSTTIPODOC,
			   @VDB_ALCP_DCTOMAXVERBA   = DB_ALCP_DCTOMAXVERBA,
			   @VDB_ALCP_VLRMAXTPPED    = ISNULL(DB_ALCP_VLRMAXTPPED, 0),
			   @V_DB_ALCP_DCTOMAXJUSTIF = DB_ALCP_DCTMAXJUSTIF,
			   @V_PERCMINIMO_LUCR_ITEM  = DB_ALCP_PERCMINLUCIT,
			   @V_FORMA_AVALIA_LUCRA    = ISNULL(DB_ALCP_AVALIALUC, 0),
			   @VDB_ALCP_DIASAMAIS      = ISNULL(DB_ALCP_DIASAMAIS, 0),
			   @VDB_ALCP_VLR_MAX_DESCPROM = ISNULL(DB_ALCP_VLRMAXDESCPROM, 0),
			   @V_ALCP_ITEMSEMDESC		  = ISNULL(DB_ALCP_ITEMSEMDESC, 0)
		FROM DB_ALCADA_PED, DB_ALCADA_USUARIO
		WHERE DB_ALCP_CODIGO = DB_ALCU_ALCADA
		  AND DB_ALCP_CODIGO = @V_ALCADA_ATUAL     -- BUSCA A ALCADA DO USUARIO CFME A ALCADA QUE O PEDIDO ESTÁ NO MOMENTO, ISSO DEVE SER FEITO PARA OS CASOS EM QUE 1 USUARIO TEM VARIAS ALCADAS COM GRUPOS DIFERENTES
		  AND DB_ALCU_USUARIO = @V_CODIGO_USUARIO; -- USUARIO
	END
	--- VERIFICA SE A CONDIÇÃO DE PGTO NAO BLOQUEIA PEDIDO -> FL_LIBERA_MOTIVO_A
	IF ISNULL(@V_ALCP_REGRAEXCDESCONTO, 0) = 0
		SET @V_ALCP_REGRAEXCDESCONTO = 0
	BEGIN
		SET @V_FLG_LIB_MOTIVO_A_PGTO = 0;
		SELECT @V_FLG_LIB_MOTIVO_A_PGTO = ISNULL(DB_TBPGTO_BLOQPED, 0)
		  FROM DB_TB_CPGTO
		 WHERE DB_TBPGTO_COD = @V_PED_COND_PGTO;
	END
	SET @V_PASSO = 6;-----------------------------------------------------------------------------------------------
	---- acao 5 valida bloqueio A do deps
	IF @P_ACAO = 5 BEGIN	
		SELECT @V_PEDAL_SEQ = MAX(DB_PEDAL_SEQ)
			FROM DB_PEDIDO_ALCADA
			WHERE DB_PEDAL_PEDIDO = @P_NRO;
		SET @V_ALCP_GRPALCADA_ANTERIOR = NULL;
		SET @V_ALCP_CODIGO_ANTERIOR = NULL;
		SET @V_ALCP_GRPLIB_ANTERIOR = NULL;
		SET @V_ALCP_NIVLIB_ANTERIOR = NULL;
		--SETA ALÇADA ANTERIOR PEGANDO O ÚLTIMO REGISTRO DE LIBERAÇÃO
		SELECT  @V_ALCP_GRPALCADA_ANTERIOR = DB_ALCP_GRPALCADA,
				@V_ALCP_CODIGO_ANTERIOR = DB_ALCP_CODIGO,
				@V_ALCP_GRPLIB_ANTERIOR = DB_ALCP_GRUPOLIB,
				@V_ALCP_NIVLIB_ANTERIOR = DB_ALCP_NIVELLIB
			FROM DB_ALCADA_PED A, DB_PEDIDO_ALCADA B
		WHERE DB_ALCP_CODIGO = DB_PEDAL_ALCADA
			AND DB_PEDAL_PEDIDO = @P_NRO
			AND DB_PEDAL_SEQ = (SELECT MAX(DB_PEDAL_SEQ) FROM DB_PEDIDO_ALCADA WHERE DB_PEDAL_PEDIDO = @P_NRO)
			DECLARE C CURSOR
			FOR SELECT DB_ALCP_CODIGO
				  FROM DB_ALCADA_PED
				 WHERE DB_ALCP_CODIGO IN (
							SELECT DB_ALCP_CODIGO
							  FROM DB_ALCADA_PED
							 WHERE DBO.MERCF_VALIDA_LISTA(@V_CLI_RAMATIV,	 DB_ALCP_LSTRAMO,   0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_PED_EMPRESA,	 DB_ALCP_LSTEMP,    0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_PED_TIPO,		 DB_ALCP_LSTTIPO,   0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_CLASCOM,	 DB_ALCP_LSTCLASS,  0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_PED_SITCORP,	 DB_ALCP_LSTSITCORP,0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_REGIAOCOM,  DB_ALCP_LSTREGCOM, 0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_PED_OPERACAO,	 DB_ALCP_LSTOPER,   0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_STATUS_PED_ATUAL, DB_ALCP_LSTSTATUS,   0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_DB_PED_LISTA_PRECO, DB_ALCP_LSTLISTAPRECO,   0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_AREAATU,	 DB_ALCP_LSTAREAATU,   0, ',') > 0
							   -- DB_ALCP_OPCREP = OPÇÃO REPRESENTANTE ( 0 - PERMITIR TODOS / 1 - SOMENTE ALGUNS / 2 - EXCETO ALGUNS )
							   AND CASE WHEN ISNULL(DB_ALCP_OPCREP, 0) = 0 AND 0 = 0
										THEN 1
										WHEN ISNULL(DB_ALCP_OPCREP, 0) = 1 AND DBO.MERCF_VALIDA_LISTA(@V_PED_REPRES, DB_ALCP_LSTREP, 0, ',') > 0
										THEN 1
										WHEN ISNULL(DB_ALCP_OPCREP, 0) = 2 AND DBO.MERCF_VALIDA_LISTA(@V_PED_REPRES, DB_ALCP_LSTREP, 1, ',') > 0
										THEN 1
										ELSE 0
										END = 1
							   AND ((@V_PED_REPRES IN (SELECT Z.DB_EREG_REPRES
														FROM DB_ESTRUT_VENDA X, 
															 DB_ESTRUT_VENDA Y, 
															 DB_ESTRUT_REGRA Z, 
															 DB_ESTRUT_REGRA Z1, 
															 DB_ALCADA_ESTRUT AL
													   WHERE X.DB_EVDA_ESTRUTURA  = Y.DB_EVDA_ESTRUTURA																				
												 		 AND Y.DB_EVDA_CODIGO     LIKE (X.DB_EVDA_CODIGO + '%')
														 AND X.DB_EVDA_ESTRUTURA  = Z.DB_EREG_ESTRUTURA
														 AND Y.DB_EVDA_ID         = Z.DB_EREG_ID
														 AND X.DB_EVDA_ESTRUTURA  = Z1.DB_EREG_ESTRUTURA
														 AND X.DB_EVDA_ID         = Z1.DB_EREG_ID
														 --AND Z.DB_EREG_SEQ        = 1
														 AND AL.DB_ALCE_ESTRUTURA = Z1.DB_EREG_ESTRUTURA
														 AND DB_ALCP_CODIGO       = AL.DB_ALCE_ALCADA
														 AND AL.DB_ALCE_ID        =  Z1.DB_EREG_ID ))  OR ((SELECT TOP(1) DB_ALCE_ALCADA
																											  FROM DB_ALCADA_ESTRUT
																											 WHERE DB_ALCP_CODIGO = DB_ALCE_ALCADA) IS NULL))
                                    AND (EXISTS (SELECT 1
                                                   FROM DB_PEDIDO, DB_PEDIDO_PROD, DB_PRODUTO
                                                  WHERE DB_PEDI_PEDIDO     = @P_NRO
                                                    AND DB_PEDI_PEDIDO     = DB_PED_NRO
                                                    AND DB_PROD_CODIGO     = DB_PEDI_PRODUTO
                                                    AND ( ((DB_PED_MOTIVO_BLOQ LIKE '%D%' AND (NOT DB_ALCP_MOTBLOQ LIKE '%D%' OR (DB_ALCP_MOTBLOQ LIKE '%D%' AND DB_PEDI_ECON_VLR < 0)))
                                                         OR DB_PED_MOTIVO_BLOQ NOT LIKE '%D%')
                                                       OR ((DB_PED_MOTIVO_BLOQ LIKE '%F%' AND (NOT DB_ALCP_MOTBLOQ LIKE '%F%' OR (DB_ALCP_MOTBLOQ LIKE '%F%' AND (DB_PEDI_TIPO = 'B' OR DB_PED_FATUR = 2))))
                                                         OR DB_PED_MOTIVO_BLOQ NOT LIKE '%F%')
														 )
                                                    AND DB_ALCP_LSTTPPROD LIKE '%' + DB_PROD_TPPROD + '%')
                                                OR ISNULL(DB_ALCP_LSTTPPROD,'') = '')
									 AND (EXISTS(
												SELECT DOCUMENTO
												  FROM DB_PEDIDO_DOC_BLOQ
												 WHERE PEDIDO = @P_NRO
												   AND ISNULL(DATA_LIBERACAO, '') = ''
												   AND (ISNULL(DB_ALCP_LSTTIPODOC , '') LIKE  CAST(CAST(DOCUMENTO  AS VARCHAR) AS VARCHAR) + ',%' OR  ISNULL(DB_ALCP_LSTTIPODOC , '') LIKE '%,' + CAST(CAST(DOCUMENTO  AS VARCHAR) AS VARCHAR) + ',%' OR  ISNULL(DB_ALCP_LSTTIPODOC , '') LIKE  '%,' + CAST(CAST(DOCUMENTO  AS VARCHAR) AS VARCHAR) 
														OR ISNULL(DB_ALCP_LSTTIPODOC , '') = CAST(CAST(DOCUMENTO  AS VARCHAR) AS VARCHAR) OR ISNULL(ISNULL(DB_ALCP_LSTTIPODOC , ''), '') = ''))  
														OR ISNULL(DB_ALCP_LSTTIPODOC, '')  = ''
														OR (SELECT TOP 1 1 FROM DB_PEDIDO_DOC_BLOQ WHERE PEDIDO = @P_NRO AND ISNULL(DATA_LIBERACAO, '') = '') IS NULL)
										AND (CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,1,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,2,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,3,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,4,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,5,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,6,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,7,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,8,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,9,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,10,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,11,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,12,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,13,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,14,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,15,1), DB_ALCP_MOTBLOQ) > 0)  
				 AND ( DB_ALCP_GRPALCADA = @V_ALCP_GRPALCADA_ANTERIOR OR ISNULL(@V_ALCP_GRPALCADA_ANTERIOR, '') = '') ---- SE JA FOI LIBERADO POR ALGUEM DEVE SEGUIR NA MESMA ALCADA
				 AND (((DB_ALCP_GRUPOLIB = @V_ALCP_GRPLIB_ANTERIOR AND DB_ALCP_NIVELLIB > @V_ALCP_NIVLIB_ANTERIOR)
				 	 OR (DB_ALCP_GRUPOLIB > @V_ALCP_GRPLIB_ANTERIOR)) 
					 OR ISNULL(@V_ALCP_CODIGO_ANTERIOR, '') = '')
								AND DB_ALCP_CODIGO NOT IN ( SELECT DB_ALCP_CODIGO   --- NAO DEVE SER IGUALAO ULTIMO NIVEL LIBERADEO
															  FROM DB_ALCADA_PED A, DB_PEDIDO_ALCADA B
															  WHERE DB_ALCP_CODIGO = DB_PEDAL_ALCADA
																AND DB_PEDAL_PEDIDO = @P_NRO)
										AND DB_ALCP_TIPO = 0
										)
								ORDER BY DB_ALCP_GRPALCADA, DB_ALCP_GRUPOLIB, DB_ALCP_NIVELLIB
		OPEN C
		FETCH NEXT FROM C
		INTO @V_ALCP_CODIGO_TEMP
		BEGIN
			IF @V_ALCP_CODIGO IS NULL
				SET @V_ALCP_CODIGO = @V_ALCP_CODIGO_TEMP;
		END
		FETCH NEXT FROM C
		INTO @V_ALCP_CODIGO_TEMP
		CLOSE C
		DEALLOCATE C
       IF ISNULL(@V_ALCP_CODIGO, '') <> '' 
	   BEGIN
           INSERT INTO DB_PEDIDO_ALCADA
                (DB_PEDAL_PEDIDO,
                DB_PEDAL_SEQ,
                DB_PEDAL_ALCADA,
                DB_PEDAL_STATUS)
            VALUES
                (@P_NRO, ISNULL(@V_PEDAL_SEQ, 0) + 1, @V_ALCP_CODIGO, 0);
			UPDATE DB_PEDIDO_ALCADA 
              SET DB_PEDAL_STATUS = 2
            WHERE DB_PEDAL_PEDIDO = @P_NRO
              AND DB_PEDAL_SEQ = @V_PEDAL_SEQ; 
			---- CRIA NOTIFICACAOPARA ENVIAR PARA USUARIOS DA ALCADA
			SET @V_CODIGO_NOTIFICACAO = 0
			SET @V_USUARIO_SERVICO = 0			
			DECLARE C_USUARIO_ALCADA CURSOR
			FOR SELECT USU.CODIGO
				  FROM DB_PERM_NOTIFICACAO_SISTEMA NOTI, DB_ALCADA_USUARIO ALCADA, DB_USUARIO USU
				WHERE NOTIFICACAO = 3
				AND ALCADA.DB_ALCU_ALCADA = @V_ALCP_CODIGO
				AND ALCADA.DB_ALCU_USUARIO = USU.CODIGO
				AND ((ISNULL(NOTI.USUARIO, '') = '' AND NOTI.GRUPO_USUARIO = USU.GRUPO_USUARIO) OR NOTI.USUARIO = USU.USUARIO)
			OPEN C_USUARIO_ALCADA
			FETCH NEXT FROM C_USUARIO_ALCADA
			INTO @V_USUARIO_NOTI	
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @V_CODIGO_NOTIFICACAO = 0
				BEGIN
					SELECT @V_CODIGO_NOTIFICACAO = ISNULL(MAX(CODIGO), 0) FROM DB_NOTIFICACAO
					SELECT TOP 1 @V_USUARIO_SERVICO = CODIGO FROM DB_USUARIO WHERE TIPO_ACESSO = 3	  
				END
				SET @V_CODIGO_NOTIFICACAO = @V_CODIGO_NOTIFICACAO + 1
				INSERT INTO DB_NOTIFICACAO 
				    (CODIGO, USUARIO_ENVIO, USUARIO_DESTINATARIO, MENSAGEM, DATA_ENVIO, TIPO_NOTIFICACAO)
				VALUES
				    (@V_CODIGO_NOTIFICACAO,
					 @V_USUARIO_SERVICO,
					 @V_USUARIO_NOTI,
					 'O pedido ' + CAST(@P_NRO AS VARCHAR) + ' do cliente ' + @V_DB_CLI_NOME + ' está aguardando a sua liberação.',
					 null,
					 3)
			FETCH NEXT FROM C_USUARIO_ALCADA
			INTO @V_USUARIO_NOTI
			END
			CLOSE C_USUARIO_ALCADA
			DEALLOCATE C_USUARIO_ALCADA
       END
       COMMIT; 
       RETURN;
    END
	-- BUSCA AS SEQUENCIAS DOS ITENS JA LIBERADOS
	SET @V_PEDAL_ITEMLIB_D_TODOS = ''
	DECLARE CUR_SEQ_ITEM_JA_LIBERADOS CURSOR
	FOR SELECT DB_PEDAL_ITEMLIB FROM DB_PEDIDO_ALCADA WHERE DB_PEDAL_PEDIDO = @P_NRO
	OPEN CUR_SEQ_ITEM_JA_LIBERADOS
	FETCH NEXT FROM CUR_SEQ_ITEM_JA_LIBERADOS
	INTO @SEQS_ITEM
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF ISNULL(@SEQS_ITEM, '') <> ''
		 SET @V_PEDAL_ITEMLIB_D_TODOS = @V_PEDAL_ITEMLIB_D_TODOS + @SEQS_ITEM									
	FETCH NEXT FROM CUR_SEQ_ITEM_JA_LIBERADOS
	INTO @SEQS_ITEM
	END
	CLOSE CUR_SEQ_ITEM_JA_LIBERADOS
	DEALLOCATE CUR_SEQ_ITEM_JA_LIBERADOS
	PRINT 'SEQS JA LIBERADOS DO FOR ' + ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, 'NULL')
	 --- SE RECEBEU USUARIO POR PARÂMETRO E ACAO LIBERAR DEVE TENTAR LIBERAR O PEDIDO
	 IF ISNULL(@P_USUARIO, '') <> '' AND @P_ACAO = 1
	 BEGIN
		SET @V_PASSO = 7;
		SET @V_TOTAL_PEDIDOS_EM_ABERTO = 0;
--PRINT '@V_PARAM_AN_CRED' + CONVERT(VARCHAR, @V_PARAM_AN_CRED)
--PRINT '@V_PED_CLIENTE' + CONVERT(VARCHAR, @V_PED_CLIENTE)
--PRINT '@@V_CLI_CGCMF' + CONVERT(VARCHAR, @V_CLI_CGCMF)
--PRINT '@@@V_CLI_VINCULO' + CONVERT(VARCHAR, @V_CLI_VINCULO)
		BEGIN --ROTINA FL_TOTAL_PEDIDOS_EM_ABERTO
			IF CHARINDEX('G', @V_PARAM_CRIT_CRED) > 0 OR @V_PARAM_CRIT_CRED IS NULL
				SELECT @V_TOTAL_PEDIDOS_EM_ABERTO = SUM((DB_PEDI_PRECO_LIQ * DB_PEDI_ESTVLR *
                             (DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_ATEND)) +
                             ((DB_PEDI_PRECO_LIQ * DB_PEDI_ESTVLR *
                             (DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_ATEND) * DB_PEDI_IPI / 100)) +
                             ((DB_PEDI_ESTVLR * (DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_ATEND) * ISNULL(DB_PEDI_VLRIPI, 0))))
				 FROM DB_PEDIDO LEFT JOIN DB_TB_CPGTO on DB_TBPGTO_COD = DB_PED_COND_PGTO, DB_PEDIDO_PROD, DB_CLIENTE
				WHERE DB_PEDIDO.DB_PED_NRO =		 DB_PEDIDO_PROD.DB_PEDI_PEDIDO
				  AND DB_PEDIDO.DB_PED_CLIENTE =	 DB_CLIENTE.DB_CLI_CODIGO
				  AND DB_PEDIDO.DB_PED_FATUR =		 0
				  AND DB_PEDIDO.DB_PED_SITUACAO <	 3
				  AND DB_PEDIDO_PROD.DB_PEDI_SITUACAO < 2
				  AND ISNULL(DB_TBPGTO_NAOLIMCREDUTILIZADO, 0) <> 1
				  AND CASE
						WHEN @V_PARAM_AN_CRED = 0 AND DB_CLI_CODIGO = @V_PED_CLIENTE
						THEN  1
						WHEN @V_PARAM_AN_CRED = 1 AND SUBSTRING(DB_CLI_CGCMF, 1, 8) = SUBSTRING(@V_CLI_CGCMF, 1, 8)
						THEN 1
						WHEN @V_PARAM_AN_CRED = 2 AND DB_CLI_VINCULO = @V_CLI_VINCULO
						THEN 1
						ELSE 0
					END = 1
			ELSE
				SET @V_TOTAL_PEDIDOS_EM_ABERTO = 0;
		END
-- ROTINA FL_TOTAL_COBRANCA_CLIENTE
		SET @V_TOTAL_COBRANCA_CLIENTE = 0;
		BEGIN
			SELECT @V_TOTAL_COBRANCA_CLIENTE = SUM((CR01_SALDO * CR01_DC) + CR01_VLJURO)
			  FROM MCR01  left join db_nota_fiscal on CR01_EMPRESA = db_nota_empresa and CR01_NFNRO = db_nota_nro and CR01_NFSER = DB_NOTA_SERIE left join DB_TB_CPGTO on DB_TBPGTO_COD = DB_NOTA_COND_PGTO, DB_CLIENTE
			 WHERE CR01_CLIENTE = DB_CLI_CODIGO
			   AND CR01_SALDO > 0
			   and isnull(DB_TBPGTO_NAOLIMCREDUTILIZADO, 0) <> 1
			   AND CASE WHEN @V_PARAM_AN_CRED = 0 AND DB_CLI_CODIGO = @V_PED_CLIENTE
						THEN 1
						WHEN @V_PARAM_AN_CRED = 1 AND SUBSTRING(DB_CLI_CGCMF, 1,8) = SUBSTRING(@V_CLI_CGCMF,1,8)
						THEN 1
						WHEN @V_PARAM_AN_CRED = 2 AND DB_CLI_VINCULO = @V_CLI_VINCULO
						THEN 1
						ELSE 0
				    END = 1;
		END
		SET @V_PASSO = 8;
		-- ROTINA FL_VERIFICA_LIMITE_DISPONIVEL
		SET @V_TOTAL_LIMITE_DISP = 0;
	 SELECT @V_AVALIACAOLIMCREDITO = DB_PRMS_VALOR    
     FROM DB_PARAM_SISTEMA
    WHERE DB_PARAM_SISTEMA.DB_PRMS_ID = 'CRE_AVALIACAOLIMCREDITO';
    IF @V_AVALIACAOLIMCREDITO = 1
    BEGIN
	    SET @V_TOTAL_LIMITE_DISP = @V_CLILIM
    END
    ELSE
	BEGIN
		SELECT @V_TOTAL_LIMITE_DISP = SUM(DB_CLI_LIM_CREDAP)
		  FROM DB_CLIENTE
		 WHERE DB_CLI_DATA_LIMITE > GETDATE() --CONVERT(VARCHAR, GETDATE(), 103)
		   AND CASE WHEN @V_PARAM_AN_CRED = 0 AND DB_CLI_CODIGO = @V_PED_CLIENTE
					THEN 1
					WHEN @V_PARAM_AN_CRED = 1 AND SUBSTRING(DB_CLI_CGCMF, 1, 8) = SUBSTRING(@V_CLI_CGCMF, 1, 8)
					THEN 1
					WHEN @V_PARAM_AN_CRED = 2 AND DB_CLI_VINCULO = @V_CLI_VINCULO
					THEN 1
					ELSE 0
               END = 1
		  GROUP BY DB_CLI_DATA_LIMITE
	END
	-----
    ----  NA LINHA 10157 EXISTE A ROTINA FL_ALCADA. FALTA CONVERTER
    -----
	SET @V_PASSO = 9;
  BEGIN
	IF CHARINDEX('A', @V_MOTIVOS) > 0
		SELECT @V_CLIATRS =   SUM((CR01_SALDO * CR01_DC) + CR01_VLJURO)
		  FROM MCR01, DB_CLIENTE
		 WHERE CR01_CLIENTE = DB_CLI_CODIGO
		   AND CR01_DTVCTO <  DATEADD(DAY, @V_DIAS, @V_DATA)
		   AND CR01_SALDO >   0
		   AND DBO.MERCF_VALIDA_LISTA (CR01_TIPODOC, @V_PARAM_TPDOC_AVAL, 0, '') > 0
		   AND CASE WHEN @V_PARAM_AN_CRED = 0 AND DB_CLI_CODIGO = @V_PED_CLIENTE
					THEN 1
					WHEN @V_PARAM_AN_CRED = 1 AND SUBSTRING(DB_CLI_CGCMF, 1, 8) = SUBSTRING(@V_CLI_CGCMF, 1, 8)
					THEN 1
					WHEN @V_PARAM_AN_CRED = 2 AND DB_CLI_VINCULO = @V_CLI_VINCULO
					THEN 1
					ELSE 0
              END = 1
--PRINT 'ISNULL(@V_TOTAL_PEDIDOS_EM_ABERTO, 0) ' + CONVERT(VARCHAR, ISNULL(@V_TOTAL_PEDIDOS_EM_ABERTO, 0))
--PRINT 'ISNULL(@V_TOTAL_COBRANCA_CLIENTE, 0) ' + CONVERT(VARCHAR, ISNULL(@V_TOTAL_COBRANCA_CLIENTE, 0))
		SET @V_CLICRED = ISNULL(@V_TOTAL_PEDIDOS_EM_ABERTO, 0) + ISNULL(@V_TOTAL_COBRANCA_CLIENTE, 0);
        SET @V_TOTAL_LIMITE_EXC = ISNULL(@V_CLICRED, 0) - ISNULL(@V_TOTAL_LIMITE_DISP, 0);
  END
	  SET @V_PASSO = 10;
	  SET @V_AUX = 0;	  
	WHILE @V_AUX < LEN(@V_MOTIVOS) -------------------------------------------------------
	  BEGIN
--PRINT 'ENTROU NOS MOTIVOS ' + SUBSTRING(@V_MOTIVOS,@V_AUX, 1)
--PRINT 'TEM PERMISSAO ' + @V_PERMI
        SET @V_AUX = @V_AUX + 1;
		IF CHARINDEX(SUBSTRING(@V_MOTIVOS,@V_AUX, 1), @V_PERMI) > 0
		BEGIN
--PRINT 'P1 '
			IF CHARINDEX(SUBSTRING(@V_MOTIVOS,@V_AUX, 1), @V_CFE_VLR) > 0
			BEGIN
--PRINT 'P2 '
				SET @V_FLG = 0;
				SET @V_PASSO = 11;
				---------------------
                --- MOTIVO A 
                ---------------------
--PRINT  '1-@V_FLG_LIB_MOTIVO_A_ALCADA ' + CONVERT(VARCHAR, @V_FLG_LIB_MOTIVO_A_ALCADA)
--PRINT  '2-@V_CLIATRS ' + CONVERT(VARCHAR, @V_CLIATRS)
--PRINT  '3-@V_VLR_MAXATRS ' + CONVERT(VARCHAR, @V_VLR_MAXATRS)
--PRINT  '4-@V_CLICRED ' + CONVERT(VARCHAR, @V_CLICRED)
--PRINT  '5-@V_CLILIM ' + CONVERT(VARCHAR, @V_CLILIM)
--PRINT  '6-@V_VLR_MAXLIM ' + CONVERT(VARCHAR, @V_VLR_MAXLIM)
--PRINT  '7-@V_LIB_VLREXCLIM ' + CONVERT(VARCHAR, @V_LIB_VLREXCLIM)
--PRINT  '8-@V_TOTAL_LIMITE_EXC ' + CONVERT(VARCHAR, @V_TOTAL_LIMITE_EXC)
--PRINT  '9-@V_LIB_VLREXCLIM ' + CONVERT(VARCHAR, @V_LIB_VLREXCLIM)
				 IF SUBSTRING(@V_MOTIVOS, @V_AUX, 1) = 'A'
				   BEGIN
                       IF @V_CLIATRS > @V_VLR_MAXATRS AND @V_VLR_MAXATRS > 0
                          SET @V_FLG = 1;                       
					   IF NOT (@V_TOTAL_LIMITE_DISP = 0 AND @V_VLR_MAXLIM >= 100)
					   BEGIN
						   IF @V_CLICRED > (@V_TOTAL_LIMITE_DISP + (@V_TOTAL_LIMITE_DISP * @V_VLR_MAXLIM / 100)) AND @V_VLR_MAXLIM > 0
							  SET @V_FLG = 1;
					   END 
                       IF ISNULL(@V_LIB_VLREXCLIM, 0) < ISNULL(@V_TOTAL_LIMITE_EXC, 0) AND ISNULL(@V_LIB_VLREXCLIM, 0) > 0
                          SET @V_FLG = 1;
                       IF  (@V_CLICRED > ISNULL(@V_LIB_DIVTOTMAX, 0) AND ISNULL(@V_LIB_DIVTOTMAX, 0) > 0 AND ISNULL(@V_LIB_DIVLIMMAX, 0) = 0)
                          OR (@V_CLICRED > (ISNULL(@V_LIB_DIVLIMMAX, 0) + ISNULL(@V_TOTAL_LIMITE_DISP, 0)) AND ISNULL(@V_LIB_DIVLIMMAX, 0) > 0 AND ISNULL(@V_LIB_DIVTOTMAX, 0) = 0)
                          SET @V_FLG = 1;
                       IF ISNULL(@V_LIB_DIVTOTMAX, 0) > 0 AND ISNULL(@V_LIB_DIVLIMMAX, 0) > 0
                          IF @V_CLICRED > ISNULL(@V_LIB_DIVTOTMAX, 0) AND @V_CLICRED > (ISNULL(@V_LIB_DIVLIMMAX, 0) + ISNULL(@V_TOTAL_LIMITE_DISP, 0))
                             SET @V_FLG = 1;
					END --FIM MOTIVO A
				SET @V_PASSO = 12;
--PRINT 'P3 PASSOU COM  @V_FLG ' + CONVERT(VARCHAR, @V_FLG)
				---------------------
                --- MOTIVO C---------
                --------------------- 
				SET @V_CPGTO_PRZTOT = 0;
				IF SUBSTRING(@V_MOTIVOS, @V_AUX, 1) = 'C'
					BEGIN
						SELECT @V_CPGTO_PRZMED = DB_TBPGTO_PRZMED,
							   @V_CPGTO_PRZTOT = (CASE  WHEN DB_TBPGTO_DIAS12 > DB_TBPGTO_DIAS11 THEN DB_TBPGTO_DIAS12
														WHEN DB_TBPGTO_DIAS11 > DB_TBPGTO_DIAS10 THEN DB_TBPGTO_DIAS11
														WHEN DB_TBPGTO_DIAS10 > DB_TBPGTO_DIAS9  THEN DB_TBPGTO_DIAS10
														WHEN DB_TBPGTO_DIAS9  > DB_TBPGTO_DIAS8  THEN DB_TBPGTO_DIAS9
														WHEN DB_TBPGTO_DIAS8  > DB_TBPGTO_DIAS7  THEN DB_TBPGTO_DIAS8
														WHEN DB_TBPGTO_DIAS7  > DB_TBPGTO_DIAS6  THEN DB_TBPGTO_DIAS7
														WHEN DB_TBPGTO_DIAS6  > DB_TBPGTO_DIAS5  THEN DB_TBPGTO_DIAS6
														WHEN DB_TBPGTO_DIAS5  > DB_TBPGTO_DIAS4  THEN DB_TBPGTO_DIAS5
														WHEN DB_TBPGTO_DIAS4  > DB_TBPGTO_DIAS3  THEN DB_TBPGTO_DIAS4
														WHEN DB_TBPGTO_DIAS3  > DB_TBPGTO_DIAS2  THEN DB_TBPGTO_DIAS3
														WHEN DB_TBPGTO_DIAS2  > DB_TBPGTO_DIAS1  THEN DB_TBPGTO_DIAS2
														ELSE DB_TBPGTO_DIAS1 END)
						FROM DB_TB_CPGTO
						WHERE DB_TBPGTO_COD = @V_PED_COND_PGTO;					
						--VALIDA PRAZO MÉDIO MÁXIMO ( SE FOR IGUAL A ZERO NÃO VALIDA )
						IF ISNULL(@V_LIB_PRZMED_MAX, 0) > 0
						   IF ISNULL(@V_CPGTO_PRZMED, 0) > ISNULL(@V_LIB_PRZMED_MAX, 0)
					   		  SET @V_FLG = 1;
						--VALIDA PRAZO TOTAL MÁXIMO ( SE FOR IGUAL A ZERO NÃO VALIDA )
						IF ISNULL(@V_LIB_PRZTOT_MAX, 0) > 0 AND @V_FLG = 0
							IF ISNULL(@V_CPGTO_PRZTOT, 0) > ISNULL(@V_LIB_PRZTOT_MAX, 0)
								SET @V_FLG = 1;
						IF @V_FLG = 0
						BEGIN 
							SELECT @V_DB_CLIR_PRAZO_MAX = DB_CLIR_PRAZO_MAX
							FROM DB_CLIENTE_REPRES
							WHERE DB_CLIR_CLIENTE = @V_PED_CLIENTE
								AND DB_CLIR_REPRES = @V_PED_REPRES
								AND DB_CLIR_EMPRESA = @V_PED_EMPRESA;
							-- VALIDA PRAZO MEDIO DA CLIENTE REPRES
							IF ISNULL(@V_LIB_PRZMEDEXCCLI, 0) > 0
							  IF (ISNULL(@V_CPGTO_PRZMED, 0) - ISNULL(@V_DB_CLIR_PRAZO_MAX, 0)) > ISNULL(@V_LIB_PRZMEDEXCCLI, 0)
								SET @V_FLG = 1;
						END
						IF @VDB_ALCP_DIASAMAIS > 0 AND @VDB_PEDC_DD_CPGTO > @VDB_ALCP_DIASAMAIS
						BEGIN						
							SET @V_FLG = 1;							
						END
					END -- FIM MOTIVO C
					SET @V_PASSO = 13;
					---------------------
					--- MOTIVO D
					---------------------
					IF SUBSTRING(@V_MOTIVOS, @V_AUX, 1) = 'D'
					BEGIN
					   SET @V_VALIDA_BLOQ_D_99 = 0
					   SELECT @V_VALIDA_BLOQ_D_99 = 1
						 FROM DB_PEDIDO_MOTBLOQ 
						WHERE DB_PEDM_PEDIDO = @P_NRO
						  AND ISNULL(DB_PEDM_IDBLOQ, '') <> ''	
						  AND ';' + DB_PEDM_IDBLOQ + ';'  LIKE '%;99;%'
					   IF @V_VALIDA_BLOQ_D_99 = 1 AND @VDB_ALCP_VLR_MAX_DESCPROM > 0 AND @V_PED_TOT > 0 
					   BEGIN  
						  IF ROUND(@V_PED_DESCTO_VLR * 100 / @V_PED_TOT, 2) > @VDB_ALCP_VLR_MAX_DESCPROM 
							SET @V_FLG = 1;
					   END
					   --- BUSCAR PARAMETRO DESCONTO UNICO
					   SET @VPED_NRODESCTOITEM = 0
					   SELECT @VPED_NRODESCTOITEM = ISNULL(DB_PRMS_VALOR, 0)								
						 FROM DB_PARAM_SISTEMA
						WHERE DB_PRMS_ID = 'PED_NRODESCTOITEM';
					  ----- AVALIA O BLOQUEIO POR ITEM
					   IF @V_ALCP_AVALIADESCONTO = 1
                       BEGIN
						  IF @V_ALCP_TIPOAVALIADESCONTO = 0 
                          BEGIN
							   SET @VPED_REGRAPERCENTUALECO = 0;
								SELECT @VPED_REGRAPERCENTUALECO = ISNULL(DB_PRMS_VALOR, 0)								
								 FROM DB_PARAM_SISTEMA
								WHERE DB_PRMS_ID = 'PED_REGRAPERCENTUALECO';
								SELECT @VDB_PED_DESCTO	  = CASE WHEN CHARINDEX('1', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO END,
										@VDB_PED_DESCTO2  = CASE WHEN CHARINDEX('2', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO2 END,
										@VDB_PED_DESCTO3  = CASE WHEN CHARINDEX('3', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO3 END,
										@VDB_PED_DESCTO4  = CASE WHEN CHARINDEX('4', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO4 END,
										@VDB_PED_DESCTO5  = CASE WHEN CHARINDEX('5', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO5 END,
										@VDB_PED_DESCTO6  = CASE WHEN CHARINDEX('6', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO6 END,
										@VDB_PED_DESCTO7  = CASE WHEN CHARINDEX('7', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO7 END,
										@V_ACRESCIMO_PEDIDO = ISNULL(DB_PED_ACRESCIMO, 0)
								   FROM DB_PEDIDO
								  WHERE DB_PED_NRO = @P_NRO
								DECLARE CUR_PED_DESCTOS CURSOR
									FOR SELECT DB_PEDD_DCTOPOL, DB_PEDD_INDDESCTO, DB_PEDD_TPDESC
														FROM DB_PEDIDO_DESCONTO
														WHERE DB_PEDD_NRO = @P_NRO 
														  AND DB_PEDD_SEQIT = 0
								OPEN CUR_PED_DESCTOS
								FETCH NEXT FROM CUR_PED_DESCTOS
								INTO @VDB_PEDD_DESCONTO, @VDB_PEDD_INDDESCTO, @V_DB_PEDD_TPDESC
								WHILE @@FETCH_STATUS = 0
								BEGIN
									IF @V_DB_PEDD_TPDESC = 0
									BEGIN
										IF @VDB_PEDD_INDDESCTO = 1 AND CHARINDEX('1', ISNULL(@VDB_ALCP_INDTOTDCTO, ' ')) = 0
											SET @V_PED_DSCTO = @VDB_PEDD_DESCONTO
										IF @VDB_PEDD_INDDESCTO = 2 AND CHARINDEX('2', ISNULL(@VDB_ALCP_INDTOTDCTO, ' ')) = 0
											SET @V_PED_DSCTO2 = @VDB_PEDD_DESCONTO
										IF @VDB_PEDD_INDDESCTO = 3 AND CHARINDEX('3', ISNULL(@VDB_ALCP_INDTOTDCTO, ' ')) = 0
											SET @V_PED_DSCTO3 = @VDB_PEDD_DESCONTO
										IF @VDB_PEDD_INDDESCTO = 4 AND CHARINDEX('4', ISNULL(@VDB_ALCP_INDTOTDCTO, ' ')) = 0
											SET @V_PED_DSCTO4 = @VDB_PEDD_DESCONTO
										IF @VDB_PEDD_INDDESCTO = 5 AND CHARINDEX('5', ISNULL(@VDB_ALCP_INDTOTDCTO, ' ')) = 0
											SET @V_PED_DSCTO5 = @VDB_PEDD_DESCONTO
										IF @VDB_PEDD_INDDESCTO = 6 AND CHARINDEX('6', ISNULL(@VDB_ALCP_INDTOTDCTO, ' ')) = 0
											SET @V_PED_DSCTO6 = @VDB_PEDD_DESCONTO
										IF @VDB_PEDD_INDDESCTO = 7 AND CHARINDEX('7', ISNULL(@VDB_ALCP_INDTOTDCTO, ' ')) = 0
											SET @V_PED_DSCTO7 = @VDB_PEDD_DESCONTO
									END
									ELSE IF @V_DB_PEDD_TPDESC = 1
									BEGIN									
										SET @V_ACRESCIMO_PEDIDO_POL = @VDB_PEDD_DESCONTO
									END
								FETCH NEXT FROM CUR_PED_DESCTOS
								INTO @VDB_PEDD_DESCONTO, @VDB_PEDD_INDDESCTO, @V_DB_PEDD_TPDESC
								END
								CLOSE CUR_PED_DESCTOS
								DEALLOCATE CUR_PED_DESCTOS
								DECLARE CUR_PED_PROD CURSOR
								FOR SELECT DB_PEDI_QTDE_SOLIC * DB_PEDI_PRECO_LIQ,										    
										   DB_PEDI_QTDE_SOLIC * DB_PEDI_ECON_VLR,
										   DB_PEDI_QTDE_SOLIC * DB_PEDI_PRECO_UNIT,
										   DB_PROD_MARCA, DB_PROD_TPPROD, DB_PROD_FAMILIA, DB_PROD_CODIGO, DB_PROD_GRUPO,
										   DB_PEDI_PRECO_UNIT,
										   DB_PEDI_SEQUENCIA,
										   DB_PEDI_QTDE_SOLIC,
										   DB_PEDI_DESCTOP,
										   DB_PEDI_ACRESCIMO,										    
										   DB_PEDI_ECON_VLR	
									  FROM DB_PEDIDO_PROD,   DB_PRODUTO
							  		 WHERE DB_PEDI_PEDIDO =  @P_NRO
									   AND DB_PEDI_PRODUTO = DB_PROD_CODIGO
									   AND DB_PEDI_TIPO NOT IN ('B', 'T');
								OPEN CUR_PED_PROD
								FETCH NEXT FROM CUR_PED_PROD
								INTO  @VPEDIDO_TOTAL_ITEM, @VECONOMIA_ITEM, @V_VALOR_BRUTO_ITEM, @V_MARCA, @V_TIPO, @V_FAMILIA, @V_CODIGO_PRODUTO, @V_GRUPO, @V_PRECO_BRUTO_UNIT, @V_SEQ_ITEM, @V_QUANTIDADE_ITEM_ECON, @VDB_PEDI_DESCTOP, @V_DB_PEDI_ACRESCIMO, @VDB_PEDI_ECON_VLR	
								WHILE @@FETCH_STATUS = 0
								BEGIN								
									SET @V_BLO_ITEM_D = 0;
									-- SE NAO VALIDA ITENS SEM DESCONTO, VERIFICA SE ITEM OSSUI DESCONTO, CASO NAO TIVER, NAO DEVE PASSAR PELAS VALIDACOES
									IF @V_ALCP_ITEMSEMDESC = 1 AND @V_ALCP_REGRAEXCDESCONTO <> 0
									BEGIN									
										SET @V_ITEM_TEM_DESCONTOS = 0
										SELECT TOP 1 @V_ITEM_TEM_DESCONTOS = 1 
											FROM DB_PEDIDO_DESCONTO
											WHERE DB_PEDD_NRO = @P_NRO 
											AND DB_PEDD_SEQIT = @V_SEQ_ITEM
											AND DB_PEDD_DESCONTO > 0
											AND @VDB_PEDI_ECON_VLR < 0
										IF @V_ITEM_TEM_DESCONTOS = 0
										BEGIN	
											IF ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, '') = '' OR NOT ',' + ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, '') + ',' LIKE + '%,' + CAST(@V_SEQ_ITEM AS VARCHAR) + ',%'
											BEGIN
												SET @V_PEDAL_ITEMLIB_D_ATUAL = ISNULL(@V_PEDAL_ITEMLIB_D_ATUAL, '') + CAST(@V_SEQ_ITEM AS VARCHAR) + ','
												SET @V_PEDAL_ITEMLIB_D_TODOS = ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, '') + CAST(@V_SEQ_ITEM AS VARCHAR) + ','
											END
										END
									END
									IF CHARINDEX(',' + CAST( @V_SEQ_ITEM AS VARCHAR) + ',', ',' + @V_PEDAL_ITEMLIB_D_TODOS + ',') = 0
									BEGIN										
										SET @V_ITEM_DSCTO_0 = 0;
										SET @V_ITEM_DSCTO_1 = 0;
										SET @V_ITEM_DSCTO_2 = 0;
										SET @V_ITEM_DSCTO_3 = 0;
										SET @V_ITEM_DSCTO_4 = 0;
										SET @V_ITEM_DSCTO_5 = 0;
										SET @V_ITEM_DSCTO_6 = 0;
										SET @V_ITEM_DSCTO_7 = 0;
										SET @V_ITEM_DSCTO_8 = 0;
										SET @V_ITEM_DSCTO_9 = 0;
										SET @V_ITEM_DSCTO_10 = 0;
										SET @V_ACRESCIMO_ITEM = 0;
										IF @VPED_NRODESCTOITEM = 1
										BEGIN
											--- DESCONTO UNICO - DESCONTO ESTA GRAVADO NO DB_PEDI_DESCTOP
											SET @V_ITEM_DSCTO_0 = @VDB_PEDI_DESCTOP
											SET @V_ACRESCIMO_ITEM = @V_DB_PEDI_ACRESCIMO
										END
										ELSE
										BEGIN
										--- DESCONTOS MULTIPLOS
											DECLARE CUR_PED_ITEM_DESCTO1 CURSOR
											 FOR SELECT DB_PEDD_DESCONTO, DB_PEDD_INDDESCTO, DB_PEDD_TPDESC
																   FROM DB_PEDIDO_DESCONTO
																  WHERE DB_PEDD_NRO = @P_NRO 
																	AND DB_PEDD_SEQIT = @V_SEQ_ITEM 
											OPEN CUR_PED_ITEM_DESCTO1
											FETCH NEXT FROM CUR_PED_ITEM_DESCTO1
											INTO @VDB_PEDD_DESCONTO, @VDB_PEDD_INDDESCTO, @V_DB_PEDD_TPDESC
											WHILE @@FETCH_STATUS = 0
											BEGIN
												SET @V_ITEM_DSCTO_0 = 0;
												IF @V_DB_PEDD_TPDESC = 0
												BEGIN
													IF @VDB_PEDD_INDDESCTO = 1 AND CHARINDEX('1', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_1 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 2 AND CHARINDEX('2', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_2 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 3 AND CHARINDEX('3', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_3 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 4 AND CHARINDEX('4', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_4 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 5 AND CHARINDEX('5', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_5 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 6 AND CHARINDEX('6', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_6 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 7 AND CHARINDEX('7', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_7 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 8 AND CHARINDEX('8', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_8 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 9 AND CHARINDEX('9', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_9 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 10 AND CHARINDEX('10', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_10 = @VDB_PEDD_DESCONTO
												END
												ELSE IF @V_DB_PEDD_TPDESC = 1
												BEGIN
													SET @V_ACRESCIMO_ITEM = @VDB_PEDD_DESCONTO
												END
											FETCH NEXT FROM CUR_PED_ITEM_DESCTO1
											INTO @VDB_PEDD_DESCONTO, @VDB_PEDD_INDDESCTO, @V_DB_PEDD_TPDESC
											END
											CLOSE CUR_PED_ITEM_DESCTO1
											DEALLOCATE CUR_PED_ITEM_DESCTO1
										END   -- --- DESCONTOS MULTIPLOS
										SELECT @V_DESCTO_TOTAL = DBO.MERCF_RET_DESCTO_CASCATA_2(  @VDB_PED_DESCTO,
																								@VDB_PED_DESCTO2,	
																								@VDB_PED_DESCTO3,	
																								@VDB_PED_DESCTO4,	
																								@VDB_PED_DESCTO5,	
																								@VDB_PED_DESCTO6,	
																								@VDB_PED_DESCTO7,	
																								@V_ITEM_DSCTO_0,
																								@V_ITEM_DSCTO_1,
																								@V_ITEM_DSCTO_2,
																								@V_ITEM_DSCTO_3,
																								@V_ITEM_DSCTO_4,
																								@V_ITEM_DSCTO_5,
																								@V_ITEM_DSCTO_6,
																								@V_ITEM_DSCTO_7,
																								@V_ITEM_DSCTO_8,
																								@V_ITEM_DSCTO_9,
																								@V_ITEM_DSCTO_10,
																								@V_ACRESCIMO_PEDIDO,
																								0 )
										SET @V_PRECO_APLICADO = @V_PRECO_BRUTO_UNIT - ((@V_PRECO_BRUTO_UNIT * @V_DESCTO_TOTAL ) / 100)										
										SET @V_PRECO_APLICADO = @V_PRECO_APLICADO + ((@V_PRECO_APLICADO * @V_ACRESCIMO_ITEM ) / 100)
										SET @VPEDIDO_TOTAL_ITEM = 0;
										SET @VPEDIDO_TOTAL_ITEM = @V_PRECO_APLICADO * @V_QUANTIDADE_ITEM_ECON;							
										SET @V_ITEM_DSCTO_0 = 0;
										SET @V_ITEM_DSCTO_1 = 0;
										SET @V_ITEM_DSCTO_2 = 0;
										SET @V_ITEM_DSCTO_3 = 0;
										SET @V_ITEM_DSCTO_4 = 0;
										SET @V_ITEM_DSCTO_5 = 0;
										SET @V_ITEM_DSCTO_6 = 0;
										SET @V_ITEM_DSCTO_7 = 0;
										SET @V_ITEM_DSCTO_8 = 0;
										SET @V_ITEM_DSCTO_9 = 0;
										SET @V_ITEM_DSCTO_10 = 0;
										SET @V_DESCTO_ITEM_REGRA = NULL;
										SET @V_ACRESCIMO_ITEM = 0;
										IF @VPED_NRODESCTOITEM = 1
										BEGIN
										--- DESCONTO UNICO - POLITICAS ESTAO GRAVADAS NOS INDICES 1, 2 E 3
											DECLARE CUR_PED_ITEM_DESCTO2 CURSOR
											 FOR SELECT DB_PEDD_DCTOPOL, DB_PEDD_INDDESCTO, DB_PEDD_TPDESC
												   FROM DB_PEDIDO_DESCONTO
												  WHERE DB_PEDD_NRO = @P_NRO 
													AND DB_PEDD_SEQIT = @V_SEQ_ITEM
													AND DB_PEDD_INDDESCTO IN (1, 2, 3)
											OPEN CUR_PED_ITEM_DESCTO2
											FETCH NEXT FROM CUR_PED_ITEM_DESCTO2
											INTO @VDB_PEDD_DESCONTO, @VDB_PEDD_INDDESCTO, @V_DB_PEDD_TPDESC
											WHILE @@FETCH_STATUS = 0
											BEGIN
												IF @V_DB_PEDD_TPDESC = 0
												BEGIN
													IF @VDB_PEDD_INDDESCTO = 1 AND CHARINDEX('1', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_1 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 2 AND CHARINDEX('2', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_2 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 3 AND CHARINDEX('3', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													   SET @V_ITEM_DSCTO_3 = @VDB_PEDD_DESCONTO
												END
												ELSE IF @V_DB_PEDD_TPDESC = 1
												BEGIN
													SET @V_ACRESCIMO_ITEM = @VDB_PEDD_DESCONTO
												END
											FETCH NEXT FROM CUR_PED_ITEM_DESCTO2
											INTO @VDB_PEDD_DESCONTO, @VDB_PEDD_INDDESCTO, @V_DB_PEDD_TPDESC
											END
											CLOSE CUR_PED_ITEM_DESCTO2
											DEALLOCATE CUR_PED_ITEM_DESCTO2
										END
										ELSE
										BEGIN
										--- DESCONTOS MULTIPLOS
											DECLARE CUR_PED_ITEM_DESCTO2 CURSOR
											 FOR SELECT DB_PEDD_DCTOPOL, DB_PEDD_INDDESCTO, DB_PEDD_TPDESC
												   FROM DB_PEDIDO_DESCONTO
												  WHERE DB_PEDD_NRO = @P_NRO 
													AND DB_PEDD_SEQIT = @V_SEQ_ITEM
											OPEN CUR_PED_ITEM_DESCTO2
											FETCH NEXT FROM CUR_PED_ITEM_DESCTO2
											INTO @VDB_PEDD_DESCONTO, @VDB_PEDD_INDDESCTO, @V_DB_PEDD_TPDESC
											WHILE @@FETCH_STATUS = 0
											BEGIN
												SET @V_ITEM_DSCTO_0 = 0;
												IF @V_DB_PEDD_TPDESC = 0
												BEGIN
													IF @VDB_PEDD_INDDESCTO = 1 AND CHARINDEX('1', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_1 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 2 AND CHARINDEX('2', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_2 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 3 AND CHARINDEX('3', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_3 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 4 AND CHARINDEX('4', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_4 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 5 AND CHARINDEX('5', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_5 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 6 AND CHARINDEX('6', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_6 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 7 AND CHARINDEX('7', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_7 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 8 AND CHARINDEX('8', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_8 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 9 AND CHARINDEX('9', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_9 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 10 AND CHARINDEX('10', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_10 = @VDB_PEDD_DESCONTO
												END
												ELSE IF @V_DB_PEDD_TPDESC = 1
												BEGIN
													SET @V_ACRESCIMO_ITEM = @VDB_PEDD_DESCONTO
												END
											FETCH NEXT FROM CUR_PED_ITEM_DESCTO2
											INTO @VDB_PEDD_DESCONTO, @VDB_PEDD_INDDESCTO, @V_DB_PEDD_TPDESC
											END
											CLOSE CUR_PED_ITEM_DESCTO2
											DEALLOCATE CUR_PED_ITEM_DESCTO2
										END  -- DESCONTOS MULTIPLOS
										SELECT @V_DESCTO_TOTAL = DBO.MERCF_RET_DESCTO_CASCATA_2(  @V_PED_DSCTO,
																								@V_PED_DSCTO2,	
																								@V_PED_DSCTO3,	
																								@V_PED_DSCTO4,	
																								@V_PED_DSCTO5,	
																								@V_PED_DSCTO6,	
																								@V_PED_DSCTO7,	
																								@V_ITEM_DSCTO_0,
																								@V_ITEM_DSCTO_1,
																								@V_ITEM_DSCTO_2,
																								@V_ITEM_DSCTO_3,
																								@V_ITEM_DSCTO_4,
																								@V_ITEM_DSCTO_5,
																								@V_ITEM_DSCTO_6,
																								@V_ITEM_DSCTO_7,
																								@V_ITEM_DSCTO_8,
																								@V_ITEM_DSCTO_9,
																								@V_ITEM_DSCTO_10,
																								@V_ACRESCIMO_PEDIDO_POL,
																								0)
										SET @V_PRECO_POLITICA = @V_PRECO_BRUTO_UNIT - ((@V_PRECO_BRUTO_UNIT * @V_DESCTO_TOTAL ) / 100)
										SET @V_PRECO_POLITICA = @V_PRECO_POLITICA + ((@V_PRECO_POLITICA * @V_ACRESCIMO_ITEM ) / 100)
										SET @VECONOMIA_ITEM = (@V_PRECO_APLICADO - @V_PRECO_POLITICA) * @V_QUANTIDADE_ITEM_ECON
										SET @V_DESCTO_ITEM_REGRA = NULL;  
										IF @V_ALCP_REGRAEXCDESCONTO <> 0
										BEGIN
										   SET @V_DESCTO_ITEM_REGRA = NULL;
										   SELECT TOP 1 @V_DESCTO_ITEM_REGRA = PROD.DESCONTO											 
											 FROM DB_REGRASDESCLIBERACAO CAPA
												, DB_REGRASDESCLIB_PRODUTOS PROD
											WHERE CAPA.CODIGO = PROD.CODIGO
											  AND CAPA.CODIGO = @V_ALCP_REGRAEXCDESCONTO
											  AND CAST(GETDATE() AS DATE) BETWEEN CAST(CAPA.DATA_INICIAL AS DATE)  AND CAST(CAPA.DATA_FINAL AS DATE)
											   AND CAST(GETDATE() AS DATE) BETWEEN CAST(ISNULL(PROD.DTVAL_INICIAL, CAPA.DATA_INICIAL) AS DATE)  AND CAST(ISNULL(PROD.DTVAL_FINAL, CAPA.DATA_FINAL) AS DATE)
											  AND DBO.MERCF_VALIDA_LISTA(@V_CODIGO_PRODUTO, PRODUTO, 0, ',') = 1   
											  AND DBO.MERCF_VALIDA_LISTA(@V_TIPO, TIPO, 0, ',') = 1
											  AND DBO.MERCF_VALIDA_LISTA(@V_MARCA, MARCA, 0, ',') = 1
											  AND DBO.MERCF_VALIDA_LISTA(@V_FAMILIA, FAMILIA, 0, ',') = 1
											  AND DBO.MERCF_VALIDA_LISTA(@V_GRUPO, GRUPO, 0, ',') = 1		
											  AND (PROD.UNIDFV  IS NULL OR PROD.UNIDFV = ''  OR  PROD.UNIDFV = @V_DB_TBREP_UNIDFV)     
											  AND (ISNULL(PROD.CLIENTE, 0) = 0 OR PROD.CLIENTE = @V_PED_CLIENTE)
											ORDER BY PESO DESC;
										 END										 
										  IF ISNULL(@V_DESCTO_ITEM_REGRA, '') = '' 
											 SET @V_LIB_DCTMAX_ITEM = @V_LIB_DCTMAX;
										  ELSE
											 SET @V_LIB_DCTMAX_ITEM = @V_DESCTO_ITEM_REGRA;
										--- 26-06-18-ALENCAR, JAIME E PATRICIA
										--- SEMPRE QUE A ALCADA ESTIVER DEFINIDA PARA AVALIAR POR EXCEDIDO DO ITEM, ESTÁ SENDO AVALIADO O PARÂMETRO DA ECONOMIA
										--- NESTES CASOS, SEMPRE QUE ESTE PARAMETRO FOR 0-CASCATA(COBRE LIQUIDO) OU 3-EXCEDIDO(SOBRE LIQUIDO) DEVE FAZER O MESMO CALCULO
										IF (@V_ALCP_REGRAEXCDESCONTO <> 0 and ISNULL(@V_DESCTO_ITEM_REGRA, 0) > 0) OR @V_ALCP_REGRAEXCDESCONTO = 0
										BEGIN
											IF @VPED_REGRAPERCENTUALECO IN (0, 3)
											BEGIN
												SET @V_DESCONTO_PED_ITEM = ((@VECONOMIA_ITEM * 100) / (@VPEDIDO_TOTAL_ITEM - @VECONOMIA_ITEM)) * (-1)
												IF @V_DESCONTO_PED_ITEM > @V_DB_ALCP_DCTOMAXJUSTIF
													SET @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
												IF ROUND(@V_DESCONTO_PED_ITEM, 2) > ROUND(@V_LIB_DCTMAX_ITEM, 2)
												BEGIN
													SET @V_FLG = 1;
													SET @V_BLO_ITEM_D = 1;
													if @V_ALCP_REGRAEXCDESCONTO = 0
														BREAK;
												END
											END
											ELSE
											BEGIN
												SET @V_DESCONTO_PED_ITEM = ((@VECONOMIA_ITEM * 100) / (@V_VALOR_BRUTO_ITEM)) * (-1)
												IF @V_DESCONTO_PED_ITEM > @V_DB_ALCP_DCTOMAXJUSTIF
													SET @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
												IF ROUND(@V_DESCONTO_PED_ITEM, 2) > ROUND(@V_LIB_DCTMAX_ITEM, 2)
												BEGIN
													SET @V_FLG = 1;													
													SET @V_BLO_ITEM_D = 1;
													if @V_ALCP_REGRAEXCDESCONTO = 0
														BREAK;
												END
											END
											if @V_BLO_ITEM_D = 0 and @V_ALCP_REGRAEXCDESCONTO <> 0
											begin
												SET @V_PEDAL_ITEMLIB_D_ATUAL = ISNULL(@V_PEDAL_ITEMLIB_D_ATUAL, '') + CAST(@V_SEQ_ITEM AS VARCHAR) + ','
												SET @V_PEDAL_ITEMLIB_D_TODOS = ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, '') + CAST(@V_SEQ_ITEM AS VARCHAR) + ','												
											end
										END
										ELSE
										BEGIN
										   SET @V_FLG = 1;											
										   SET @V_BLO_ITEM_D = 1;										   
										END
									END
								FETCH NEXT FROM CUR_PED_PROD
								INTO @VPEDIDO_TOTAL_ITEM, @VECONOMIA_ITEM, @V_VALOR_BRUTO_ITEM, @V_MARCA, @V_TIPO, @V_FAMILIA, @V_CODIGO_PRODUTO, @V_GRUPO, @V_PRECO_BRUTO_UNIT, @V_SEQ_ITEM, @V_QUANTIDADE_ITEM_ECON, @VDB_PEDI_DESCTOP, @V_DB_PEDI_ACRESCIMO, @VDB_PEDI_ECON_VLR	
								END
								CLOSE CUR_PED_PROD
								DEALLOCATE CUR_PED_PROD                          
                          END
						  ELSE IF @V_ALCP_TIPOAVALIADESCONTO = 1 
                          BEGIN
							  ---  DESCONTO TOTAL DO ITEM
							SET @VDB_PED_DESCTO = 0
							SET @VDB_PED_DESCTO2 = 0
							SET @VDB_PED_DESCTO3 = 0
							SET @VDB_PED_DESCTO4 = 0
							SET @VDB_PED_DESCTO5 = 0
							SET @VDB_PED_DESCTO6 = 0
							SET @VDB_PED_DESCTO7 = 0
							SET @V_ACRESCIMO_PEDIDO = 0
							SELECT @VDB_PED_DESCTO	  = CASE WHEN CHARINDEX('1', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO END,
									@VDB_PED_DESCTO2  = CASE WHEN CHARINDEX('2', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO2 END,
									@VDB_PED_DESCTO3  = CASE WHEN CHARINDEX('3', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO3 END,
									@VDB_PED_DESCTO4  = CASE WHEN CHARINDEX('4', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO4 END,
									@VDB_PED_DESCTO5  = CASE WHEN CHARINDEX('5', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO5 END,
									@VDB_PED_DESCTO6  = CASE WHEN CHARINDEX('6', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO6 END,
									@VDB_PED_DESCTO7  = CASE WHEN CHARINDEX('7', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO7 END,
									@V_ACRESCIMO_PEDIDO = ISNULL(DB_PED_ACRESCIMO, 0)
							   FROM DB_PEDIDO
							  WHERE DB_PED_NRO = @P_NRO
						    DECLARE CUR_PED_PROD CURSOR
							FOR SELECT DB_PEDI_DESCTOP, DB_PEDI_SEQUENCIA, DB_PROD_MARCA, DB_PROD_TPPROD, DB_PROD_FAMILIA, DB_PROD_CODIGO, DB_PROD_GRUPO, DB_PEDI_ACRESCIMO, DB_PEDI_ECON_VLR
								  FROM DB_PEDIDO_PROD, DB_PRODUTO
								 WHERE DB_PEDI_PEDIDO = @P_NRO
								   AND DB_PEDI_PRODUTO = DB_PROD_CODIGO
								   AND DB_PEDI_TIPO NOT IN ('B', 'T')
								OPEN CUR_PED_PROD
								FETCH NEXT FROM CUR_PED_PROD
								INTO @VDB_PEDI_DESCTOP, @V_SEQ_ITEM, @V_MARCA, @V_TIPO, @V_FAMILIA, @V_CODIGO_PRODUTO, @V_GRUPO, @V_DB_PEDI_ACRESCIMO, @VDB_PEDI_ECON_VLR
							WHILE @@FETCH_STATUS = 0
								BEGIN
									-- SE NAO VALIDA ITENS SEM DESCONTO, VERIFICA SE ITEM OSSUI DESCONTO, CASO NAO TIVER, NAO DEVE PASSAR PELAS VALIDACOES
									IF @V_ALCP_ITEMSEMDESC = 1 AND @V_ALCP_REGRAEXCDESCONTO <> 0
									BEGIN									
										SET @V_ITEM_TEM_DESCONTOS = 0
										SELECT TOP 1 @V_ITEM_TEM_DESCONTOS = 1 
											FROM DB_PEDIDO_DESCONTO
											WHERE DB_PEDD_NRO = @P_NRO 
											AND DB_PEDD_SEQIT = @V_SEQ_ITEM
											AND DB_PEDD_DESCONTO > 0
											AND @VDB_PEDI_ECON_VLR < 0
										IF @V_ITEM_TEM_DESCONTOS = 0
										BEGIN											
											IF ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, '') = '' OR NOT ',' + ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, '') + ',' LIKE + '%,' + CAST(@V_SEQ_ITEM AS VARCHAR) + ',%'
											BEGIN
												SET @V_PEDAL_ITEMLIB_D_ATUAL = ISNULL(@V_PEDAL_ITEMLIB_D_ATUAL, '') + CAST(@V_SEQ_ITEM AS VARCHAR) + ','
												SET @V_PEDAL_ITEMLIB_D_TODOS = ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, '') + CAST(@V_SEQ_ITEM AS VARCHAR) + ','
											END
										END
									END
									IF (@V_ALCP_REGRAEXCDESCONTO <> 0 and ISNULL(@V_DESCTO_ITEM_REGRA, 0) > 0) OR @V_ALCP_REGRAEXCDESCONTO = 0
									BEGIN
										SET @V_ITEM_DSCTO_0 = 0;
										SET @V_ITEM_DSCTO_1 = 0;
										SET @V_ITEM_DSCTO_2 = 0;
										SET @V_ITEM_DSCTO_3 = 0;
										SET @V_ITEM_DSCTO_4 = 0;
										SET @V_ITEM_DSCTO_5 = 0;
										SET @V_ITEM_DSCTO_6 = 0;
										SET @V_ITEM_DSCTO_7 = 0;
										SET @V_ITEM_DSCTO_8 = 0;
										SET @V_ITEM_DSCTO_9 = 0;
										SET @V_ITEM_DSCTO_10 = 0;
										SET @V_DESCTO_ITEM_REGRA = NULL;
										SET @V_ACRESCIMO_ITEM = 0
										IF @VPED_NRODESCTOITEM = 1
										BEGIN
											--- DESCONTO UNICO - DESCONTO ESTA GRAVADO NO DB_PEDI_DESCTOP
											SET @V_ITEM_DSCTO_0 = @VDB_PEDI_DESCTOP
											SET @V_ACRESCIMO_ITEM = @V_DB_PEDI_ACRESCIMO;
										END
										ELSE
										BEGIN
										--- DESCONTOS MULTIPLOS
											DECLARE CUR_PED_ITEM_DESCTO CURSOR
											 FOR SELECT DB_PEDD_DESCONTO, DB_PEDD_INDDESCTO, DB_PEDD_TPDESC
												  FROM DB_PEDIDO_DESCONTO
												 WHERE DB_PEDD_NRO = @P_NRO 
													AND DB_PEDD_SEQIT = @V_SEQ_ITEM 
											OPEN CUR_PED_ITEM_DESCTO
											FETCH NEXT FROM CUR_PED_ITEM_DESCTO
											INTO @VDB_PEDD_DESCONTO, @VDB_PEDD_INDDESCTO, @V_DB_PEDD_TPDESC
											WHILE @@FETCH_STATUS = 0
											BEGIN
												SET @V_ITEM_DSCTO_0 = 0;
												IF @V_DB_PEDD_TPDESC = 0
												BEGIN
													IF @VDB_PEDD_INDDESCTO = 1 AND CHARINDEX('1', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_1 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 2 AND CHARINDEX('2', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_2 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 3 AND CHARINDEX('3', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_3 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 4 AND CHARINDEX('4', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_4 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 5 AND CHARINDEX('5', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_5 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 6 AND CHARINDEX('6', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_6 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 7 AND CHARINDEX('7', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_7 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 8 AND CHARINDEX('8', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_8 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 9 AND CHARINDEX('9', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_9 = @VDB_PEDD_DESCONTO
													IF @VDB_PEDD_INDDESCTO = 10 AND CHARINDEX('10', ISNULL(@V_ALCP_INDICEDESCITEM, ' ')) = 0
													  SET @V_ITEM_DSCTO_10 = @VDB_PEDD_DESCONTO
												END IF @V_DB_PEDD_TPDESC = 1
												BEGIN
													SET @V_ACRESCIMO_ITEM = @VDB_PEDD_DESCONTO
												END
											FETCH NEXT FROM CUR_PED_ITEM_DESCTO
											INTO @VDB_PEDD_DESCONTO, @VDB_PEDD_INDDESCTO, @V_DB_PEDD_TPDESC
											END
											CLOSE CUR_PED_ITEM_DESCTO
											DEALLOCATE CUR_PED_ITEM_DESCTO
										END --- DESCONTOS MULTIPLOS
										SELECT @V_DESCTO_TOTAL = DBO.MERCF_RET_DESCTO_CASCATA_2(  @VDB_PED_DESCTO,
																								@VDB_PED_DESCTO2,	
																								@VDB_PED_DESCTO3,	
																								@VDB_PED_DESCTO4,	
																								@VDB_PED_DESCTO5,	
																								@VDB_PED_DESCTO6,	
																								@VDB_PED_DESCTO7,	
																								@V_ITEM_DSCTO_0,
																								@V_ITEM_DSCTO_1,
																								@V_ITEM_DSCTO_2,
																								@V_ITEM_DSCTO_3,
																								@V_ITEM_DSCTO_4,
																								@V_ITEM_DSCTO_5,
																								@V_ITEM_DSCTO_6,
																								@V_ITEM_DSCTO_7,
																								@V_ITEM_DSCTO_8,
																								@V_ITEM_DSCTO_9,
																								@V_ITEM_DSCTO_10,
																								@V_ACRESCIMO_PEDIDO,
																								@V_ACRESCIMO_ITEM)
										IF @V_ALCP_REGRAEXCDESCONTO <> 0
										BEGIN
											SET @V_DESCTO_ITEM_REGRA = NULL;
											SELECT TOP 1 @V_DESCTO_ITEM_REGRA = PROD.DESCONTO											 
											FROM DB_REGRASDESCLIBERACAO CAPA
												, DB_REGRASDESCLIB_PRODUTOS PROD
											WHERE CAPA.CODIGO = PROD.CODIGO
												AND CAPA.CODIGO = @V_ALCP_REGRAEXCDESCONTO
												AND CAST(GETDATE() AS DATE) BETWEEN CAST(CAPA.DATA_INICIAL AS DATE)  AND CAST(CAPA.DATA_FINAL AS DATE)
											   AND CAST(GETDATE() AS DATE) BETWEEN CAST(ISNULL(PROD.DTVAL_INICIAL, CAPA.DATA_INICIAL) AS DATE)  AND CAST(ISNULL(PROD.DTVAL_FINAL, CAPA.DATA_FINAL) AS DATE)
												AND DBO.MERCF_VALIDA_LISTA(@V_CODIGO_PRODUTO, PRODUTO, 0, ',') = 1   
												AND DBO.MERCF_VALIDA_LISTA(@V_TIPO, TIPO, 0, ',') = 1
												AND DBO.MERCF_VALIDA_LISTA(@V_MARCA, MARCA, 0, ',') = 1
												AND DBO.MERCF_VALIDA_LISTA(@V_FAMILIA, FAMILIA, 0, ',') = 1
												AND DBO.MERCF_VALIDA_LISTA(@V_GRUPO, GRUPO, 0, ',') = 1		
												AND (PROD.UNIDFV  IS NULL OR PROD.UNIDFV = ''  OR  PROD.UNIDFV = @V_DB_TBREP_UNIDFV)     
												AND (ISNULL(PROD.CLIENTE, 0) = 0 OR PROD.CLIENTE = @V_PED_CLIENTE)
												ORDER BY PESO DESC;
										 END
										SET @V_DESCONTO_PED_ITEM = @V_DESCTO_TOTAL
										IF @V_DESCONTO_PED_ITEM > @V_DB_ALCP_DCTOMAXJUSTIF
											SET @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
										IF @V_DESCTO_ITEM_REGRA IS NOT NULL 
										BEGIN
											  IF (@V_DESCTO_TOTAL > @V_DESCTO_ITEM_REGRA)
											  BEGIN
												SET @V_FLG = 1;
												SET @V_BLO_ITEM_D = 1;
												if @V_ALCP_REGRAEXCDESCONTO = 0
													BREAK;                  
											  END
										END
										ELSE                 
										BEGIN
											  IF (@V_DESCTO_TOTAL > @VDB_ALCP_TOTDCTO)
											  BEGIN
												SET @V_FLG = 1;
												BREAK;                  
											  END;
										END
										IF @V_BLO_ITEM_D = 0 AND @V_ALCP_REGRAEXCDESCONTO <> 0
										BEGIN
											SET @V_PEDAL_ITEMLIB_D_ATUAL = ISNULL(@V_PEDAL_ITEMLIB_D_ATUAL, '') + CAST(@V_SEQ_ITEM AS VARCHAR) + ','
											SET @V_PEDAL_ITEMLIB_D_TODOS = ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, '') + CAST(@V_SEQ_ITEM AS VARCHAR) + ','												
										END
									END
							FETCH NEXT FROM CUR_PED_PROD
								INTO  @VDB_PEDI_DESCTOP, @V_SEQ_ITEM, @V_MARCA, @V_TIPO, @V_FAMILIA, @V_CODIGO_PRODUTO, @V_GRUPO, @V_DB_PEDI_ACRESCIMO, @VDB_PEDI_ECON_VLR
								END
								CLOSE CUR_PED_PROD
							DEALLOCATE CUR_PED_PROD                  
                          END
						  ELSE IF @V_ALCP_TIPOAVALIADESCONTO = 2
						  BEGIN                 
								DECLARE CUR_PED_PROD CURSOR
								FOR SELECT DB_PEDI_QTDE_SOLIC * DB_PEDI_PRECO_LIQ,										    
										   DB_PEDI_QTDE_SOLIC * DB_PEDI_ECON_VLR,
										   DB_PEDI_QTDE_SOLIC * DB_PEDI_PRECO_UNIT,
										   DB_PROD_MARCA, DB_PROD_TPPROD, DB_PROD_FAMILIA, DB_PROD_CODIGO, DB_PROD_GRUPO
									  FROM DB_PEDIDO_PROD,   DB_PRODUTO
							  		 WHERE DB_PEDI_PEDIDO =  @P_NRO
									   AND DB_PEDI_PRODUTO = DB_PROD_CODIGO
									   AND DB_PEDI_TIPO NOT IN ('B', 'T');
								OPEN CUR_PED_PROD
								FETCH NEXT FROM CUR_PED_PROD
								INTO  @VPEDIDO_TOTAL_ITEM, @VECONOMIA_ITEM, @V_VALOR_BRUTO_ITEM, @V_MARCA, @V_TIPO, @V_FAMILIA, @V_CODIGO_PRODUTO, @V_GRUPO
								WHILE @@FETCH_STATUS = 0
								BEGIN		
									-- SE NAO VALIDA ITENS SEM DESCONTO, VERIFICA SE ITEM OSSUI DESCONTO, CASO NAO TIVER, NAO DEVE PASSAR PELAS VALIDACOES
									IF @V_ALCP_ITEMSEMDESC = 1 AND @V_ALCP_REGRAEXCDESCONTO <> 0
									BEGIN									
										SET @V_ITEM_TEM_DESCONTOS = 0
										SELECT TOP 1 @V_ITEM_TEM_DESCONTOS = 1 
											FROM DB_PEDIDO_DESCONTO
											WHERE DB_PEDD_NRO = @P_NRO 
											AND DB_PEDD_SEQIT = @V_SEQ_ITEM
										IF @V_ITEM_TEM_DESCONTOS = 0
										BEGIN											
											IF ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, '') = '' OR NOT ',' + ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, '') + ',' LIKE + '%,' + CAST(@V_SEQ_ITEM AS VARCHAR) + ',%'
											BEGIN
												SET @V_PEDAL_ITEMLIB_D_ATUAL = ISNULL(@V_PEDAL_ITEMLIB_D_ATUAL, '') + CAST(@V_SEQ_ITEM AS VARCHAR) + ','
												SET @V_PEDAL_ITEMLIB_D_TODOS = ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, '') + CAST(@V_SEQ_ITEM AS VARCHAR) + ','
											END
										END
									END
									IF (@V_ALCP_REGRAEXCDESCONTO <> 0 and ISNULL(@V_DESCTO_ITEM_REGRA, 0) > 0) OR @V_ALCP_REGRAEXCDESCONTO = 0
									BEGIN
										SET @V_DESCTO_ITEM_REGRA = NULL;  
										IF @V_ALCP_REGRAEXCDESCONTO <> 0
										BEGIN
											SET @V_DESCTO_ITEM_REGRA = NULL;
											SELECT @V_DESCTO_ITEM_REGRA = PROD.DESCONTO											 
											  FROM DB_REGRASDESCLIBERACAO CAPA
												 , DB_REGRASDESCLIB_PRODUTOS PROD
											 WHERE CAPA.CODIGO = PROD.CODIGO
											   AND CAPA.CODIGO = @V_ALCP_REGRAEXCDESCONTO
											   AND CAST(GETDATE() AS DATE) BETWEEN CAST(CAPA.DATA_INICIAL AS DATE)  AND CAST(CAPA.DATA_FINAL AS DATE)
											   AND CAST(GETDATE() AS DATE) BETWEEN CAST(ISNULL(PROD.DTVAL_INICIAL, CAPA.DATA_INICIAL) AS DATE)  AND CAST(ISNULL(PROD.DTVAL_FINAL, CAPA.DATA_FINAL) AS DATE)
											   AND DBO.MERCF_VALIDA_LISTA(@V_CODIGO_PRODUTO, PRODUTO, 0, ',') = 1   
											   AND DBO.MERCF_VALIDA_LISTA(@V_TIPO, TIPO, 0, ',') = 1
											   AND DBO.MERCF_VALIDA_LISTA(@V_MARCA, MARCA, 0, ',') = 1
											   AND DBO.MERCF_VALIDA_LISTA(@V_FAMILIA, FAMILIA, 0, ',') = 1
											   AND DBO.MERCF_VALIDA_LISTA(@V_GRUPO, GRUPO, 0, ',') = 1		
											   AND (PROD.UNIDFV  IS NULL OR PROD.UNIDFV = ''  OR  PROD.UNIDFV = @V_DB_TBREP_UNIDFV)     
											   AND (ISNULL(PROD.CLIENTE, 0) = 0 OR PROD.CLIENTE = @V_PED_CLIENTE)
											 ORDER BY PESO DESC;							  
										END
										IF @V_PRM_APLDESCTO = 0
										BEGIN
										   IF  @VPEDIDO_TOTAL_ITEM > 0
											  SET @V_PED_DCTO_ITEM = @VECONOMIA_ITEM * 100 / @VPEDIDO_TOTAL_ITEM;									  
										END
								 		ELSE
										BEGIN
										   IF @V_VALOR_BRUTO_ITEM > 0
											  SET @V_PED_DCTO_ITEM = @VECONOMIA_ITEM * 100 / @V_VALOR_BRUTO_ITEM;									 
										END
										SET @V_DESCONTO_PED_ITEM = @V_PED_DCTO_ITEM * (-1)
										IF @V_DESCONTO_PED_ITEM > @V_DB_ALCP_DCTOMAXJUSTIF
											SET @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
										IF ISNULL(@V_DESCTO_ITEM_REGRA, '') <> ''
										BEGIN
											IF @V_PED_DCTO_ITEM > @V_DESCTO_ITEM_REGRA 
											BEGIN
											  SET @V_FLG = 1;	
											  SET @V_BLO_ITEM_D = 1;
											  if @V_ALCP_REGRAEXCDESCONTO = 0
												BREAK;                
											END
										END
										ELSE                          
										BEGIN
											IF @V_PED_DCTO_ITEM > @VDB_ALCP_ECONOMIA
											BEGIN
											  SET @V_FLG = 1;										  
											  BREAK;
											END
										END
										IF @V_BLO_ITEM_D = 0 AND @V_ALCP_REGRAEXCDESCONTO <> 0
										BEGIN
											SET @V_PEDAL_ITEMLIB_D_ATUAL = ISNULL(@V_PEDAL_ITEMLIB_D_ATUAL, '') + CAST(@V_SEQ_ITEM AS VARCHAR) + ','
											SET @V_PEDAL_ITEMLIB_D_TODOS = ISNULL(@V_PEDAL_ITEMLIB_D_TODOS, '') + CAST(@V_SEQ_ITEM AS VARCHAR) + ','												
										END
									END
								FETCH NEXT FROM CUR_PED_PROD
								INTO @VPEDIDO_TOTAL_ITEM, @VECONOMIA_ITEM, @V_VALOR_BRUTO_ITEM, @V_MARCA, @V_TIPO, @V_FAMILIA, @V_CODIGO_PRODUTO, @V_GRUPO
								END
								CLOSE CUR_PED_PROD
								DEALLOCATE CUR_PED_PROD
								END
                       END
					   ELSE
					   BEGIN
							  IF ISNULL(@VDB_ALCP_TOTDCTO, 0) > 0
							  BEGIN
									SET @VDB_PED_DESCTO = 0
									SET @VDB_PED_DESCTO2 = 0
									SET @VDB_PED_DESCTO3 = 0
									SET @VDB_PED_DESCTO4 = 0
									SET @VDB_PED_DESCTO5 = 0
									SET @VDB_PED_DESCTO6 = 0
									SET @VDB_PED_DESCTO7 = 0
								   SELECT @VDB_PED_DESCTO	 = CASE WHEN CHARINDEX('1', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO END,
										  @VDB_PED_DESCTO2	 = CASE WHEN CHARINDEX('2', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO2 END,
										  @VDB_PED_DESCTO3	 = CASE WHEN CHARINDEX('3', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO3 END,
										  @VDB_PED_DESCTO4	 = CASE WHEN CHARINDEX('4', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO4 END,
										  @VDB_PED_DESCTO5	 = CASE WHEN CHARINDEX('5', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO5 END,
										  @VDB_PED_DESCTO6	 = CASE WHEN CHARINDEX('6', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO6 END,
										  @VDB_PED_DESCTO7	 = CASE WHEN CHARINDEX('7', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO7 END							  
									 FROM DB_PEDIDO
									WHERE DB_PED_NRO = @P_NRO
								DECLARE CUR_PED_PROD CURSOR
								 FOR SELECT DB_PEDI_DESCTOP
									   FROM DB_PEDIDO_PROD
									   WHERE DB_PEDI_PEDIDO = @P_NRO
										OPEN CUR_PED_PROD
									   FETCH NEXT FROM CUR_PED_PROD
										INTO @VDB_PEDI_DESCTOP
									WHILE @@FETCH_STATUS = 0
									   BEGIN
										   SELECT @V_DESCTO_TOTAL = DBO.MERCF_RET_DESCTO_CASCATA_2( @VDB_PED_DESCTO,
																									 @VDB_PED_DESCTO2,	
																									 @VDB_PED_DESCTO3,	
																									 @VDB_PED_DESCTO4,	
																									 @VDB_PED_DESCTO5,	
																									 @VDB_PED_DESCTO6,	
																									 @VDB_PED_DESCTO7,	
																									 @VDB_PEDI_DESCTOP,
																									 0,
																									 0,
																									 0,
																									 0,
																									 0,
																									 0,
																									 0,
																									 0,
																									 0,
																									 0,0,0)
											SET @V_DESCONTO_PED_ITEM = @V_DESCTO_TOTAL
											IF @V_DESCONTO_PED_ITEM > @V_DB_ALCP_DCTOMAXJUSTIF
												SET @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
											IF  (@V_DESCTO_TOTAL > @VDB_ALCP_TOTDCTO)
											BEGIN
												SET @V_FLG = 1
												BREAK
											END
									FETCH NEXT FROM CUR_PED_PROD
									  INTO  @VDB_PEDI_DESCTOP
									  END
									  CLOSE CUR_PED_PROD
									DEALLOCATE CUR_PED_PROD
							  END
							  ELSE
							  BEGIN
								IF @VDB_ALCP_ECONOMIA > 0 
								BEGIN
									SET @V_DESCONTO_PED_ITEM = (@V_PED_DCTO * (-1))									
									IF @V_DESCONTO_PED_ITEM > @V_DB_ALCP_DCTOMAXJUSTIF
										SET @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
									IF @V_DESCONTO_PED_ITEM > @VDB_ALCP_ECONOMIA
										SET @V_FLG = 1;
								END;
								IF 	@V_LIB_DCTMAX > 0
								BEGIN
									SET @V_PARAM_VALDESCONTOEXCEDIDO = 0;
									SELECT @V_PARAM_VALDESCONTOEXCEDIDO = ISNULL(DB_PRMS_VALOR, 0)                            
									  FROM DB_PARAM_SISTEMA
									 WHERE DB_PRMS_ID = 'LIB_VALDESCONTOEXCEDIDO';
									 SELECT @VPED_REGRAPERCENTUALECO = ISNULL(DB_PRMS_VALOR, 0)                            
									  FROM DB_PARAM_SISTEMA
									 WHERE DB_PRMS_ID = 'PED_REGRAPERCENTUALECO';
									 IF @V_PARAM_VALDESCONTOEXCEDIDO = 0
									 BEGIN
										IF @VPED_REGRAPERCENTUALECO = 0
										BEGIN
											SET @V_DESCONTO_PED_ITEM = ((@V_ECON * 100) / (@V_PED_TOT - @V_ECON)) * (-1)
											IF @V_DESCONTO_PED_ITEM > @V_DB_ALCP_DCTOMAXJUSTIF
												SET @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
											IF @V_DESCONTO_PED_ITEM > @V_LIB_DCTMAX
												SET @V_FLG = 1;
										END
										ELSE
										BEGIN
											SET @V_DESCONTO_PED_ITEM = ((@V_ECON * 100) / (@V_BRUTO)) * (-1)
											IF @V_DESCONTO_PED_ITEM > @V_DB_ALCP_DCTOMAXJUSTIF
												SET @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
											IF @V_DESCONTO_PED_ITEM > @V_LIB_DCTMAX
												SET @V_FLG = 1;
										END
									 END
									 ELSE IF @V_PARAM_VALDESCONTOEXCEDIDO = 1
									 BEGIN
										 DECLARE CUR_PED_PROD CURSOR
										 FOR SELECT DB_PEDI_QTDE_SOLIC * DB_PEDI_PRECO_LIQ,										    
													DB_PEDI_QTDE_SOLIC * DB_PEDI_ECON_VLR,
													DB_PEDI_QTDE_SOLIC * DB_PEDI_PRECO_UNIT
											   FROM DB_PEDIDO_PROD,   DB_PRODUTO
											  WHERE DB_PEDI_PEDIDO =  @P_NRO
												AND DB_PEDI_PRODUTO = DB_PROD_CODIGO
												AND DB_PEDI_TIPO NOT IN ('B', 'T');
												OPEN CUR_PED_PROD
											   FETCH NEXT FROM CUR_PED_PROD
												INTO  @VPEDIDO_TOTAL_ITEM, @VECONOMIA_ITEM, @V_VALOR_BRUTO_ITEM
											WHILE @@FETCH_STATUS = 0
											   BEGIN
												 IF @VPED_REGRAPERCENTUALECO = 0
												  BEGIN
													  SET @V_DESCONTO_PED_ITEM = ((@VECONOMIA_ITEM * 100) / (@VPEDIDO_TOTAL_ITEM - @VECONOMIA_ITEM)) * (-1)
													  IF @V_DESCONTO_PED_ITEM > @V_DB_ALCP_DCTOMAXJUSTIF
														SET @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
													  IF @V_DESCONTO_PED_ITEM > @V_LIB_DCTMAX
													  BEGIN
														SET @V_FLG = 1;
														BREAK;
													  END
												  END
												  ELSE
												  BEGIN
													  SET @V_DESCONTO_PED_ITEM = ((@VECONOMIA_ITEM * 100) / (@V_VALOR_BRUTO_ITEM)) * (-1)
													  IF @V_DESCONTO_PED_ITEM > @V_DB_ALCP_DCTOMAXJUSTIF
														SET @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
													  IF @V_DESCONTO_PED_ITEM > @V_LIB_DCTMAX
													  BEGIN
														SET @V_FLG = 1;
														BREAK;
													  END
												  END
											FETCH NEXT FROM CUR_PED_PROD
											  INTO @VPEDIDO_TOTAL_ITEM, @VECONOMIA_ITEM, @V_VALOR_BRUTO_ITEM
											  END
											  CLOSE CUR_PED_PROD
											DEALLOCATE CUR_PED_PROD
									 END
								END;
								IF @VDB_ALCP_DESCTOMEDIO > 0 
								BEGIN
									SET @VDB_PED_DESCTO = 0
										SET @VDB_PED_DESCTO2 = 0
										SET @VDB_PED_DESCTO3 = 0
										SET @VDB_PED_DESCTO4 = 0
										SET @VDB_PED_DESCTO5 = 0
										SET @VDB_PED_DESCTO6 = 0
										SET @VDB_PED_DESCTO7 = 0
										SELECT @VDB_PED_DESCTO	 = CASE WHEN CHARINDEX('1', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO END,
												@VDB_PED_DESCTO2	 = CASE WHEN CHARINDEX('2', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO2 END,
												@VDB_PED_DESCTO3	 = CASE WHEN CHARINDEX('3', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO3 END,
												@VDB_PED_DESCTO4	 = CASE WHEN CHARINDEX('4', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO4 END,
												@VDB_PED_DESCTO5	 = CASE WHEN CHARINDEX('5', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO5 END,
												@VDB_PED_DESCTO6	 = CASE WHEN CHARINDEX('6', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO6 END,
												@VDB_PED_DESCTO7	 = CASE WHEN CHARINDEX('7', @VDB_ALCP_INDTOTDCTO) > 0 THEN 0 ELSE DB_PED_DESCTO7 END							  
											FROM DB_PEDIDO
										WHERE DB_PED_NRO     = @P_NRO
									 SET @V_VALOR_LIQ_TOTAL_DESCONTOS = 0;
									 SET @V_VALOR_BRU_TOTAL           = 0;
									DECLARE CUR_PED_PROD2 CURSOR
										FOR SELECT DB_PEDI_DESCTOP, DB_PEDI_PRECO_UNIT, DB_PEDI_QTDE_SOLIC, DB_PEDI_QTDE_CANC
											FROM DB_PEDIDO_PROD
											WHERE DB_PEDI_PEDIDO = @P_NRO
											OPEN CUR_PED_PROD2
											FETCH NEXT FROM CUR_PED_PROD2
											INTO @VDB_PEDI_DESCTOP, @VDB_PEDI_PRECO_UNIT, @VDB_PEDI_QTDE_SOLIC, @VDB_PEDI_QTDE_CANC
										WHILE @@FETCH_STATUS = 0
											BEGIN
												SELECT @V_DESCTO_TOTAL = DBO.MERCF_RET_DESCTO_CASCATA_2( @VDB_PED_DESCTO,
																											@VDB_PED_DESCTO2,	
																											@VDB_PED_DESCTO3,	
																											@VDB_PED_DESCTO4,	
																											@VDB_PED_DESCTO5,	
																											@VDB_PED_DESCTO6,	
																											@VDB_PED_DESCTO7,	
																											@VDB_PEDI_DESCTOP,
																											0,
																											0,
																											0,
																											0,
																											0,
																											0,
																											0,
																											0,
																											0,
																											0,0,0)
									 SET @V_VALOR_TEMP = (@VDB_PEDI_PRECO_UNIT * (@VDB_PEDI_QTDE_SOLIC - @VDB_PEDI_QTDE_CANC)) - 
														 ((@VDB_PEDI_PRECO_UNIT * (@VDB_PEDI_QTDE_SOLIC - @VDB_PEDI_QTDE_CANC) * @V_DESCTO_TOTAL) / 100);
									 SET @V_VALOR_LIQ_TOTAL_DESCONTOS = @V_VALOR_LIQ_TOTAL_DESCONTOS + @V_VALOR_TEMP;
									 SET @V_VALOR_BRU_TOTAL           = @V_VALOR_BRU_TOTAL + (@VDB_PEDI_PRECO_UNIT * (@VDB_PEDI_QTDE_SOLIC - @VDB_PEDI_QTDE_CANC));
									 SET @V_DESCONTO_ITEM = 100 - ((@V_VALOR_TEMP / (@VDB_PEDI_PRECO_UNIT * (@VDB_PEDI_QTDE_SOLIC - @VDB_PEDI_QTDE_CANC))) * 100);
								  FETCH NEXT FROM CUR_PED_PROD2
									INTO @VDB_PEDI_DESCTOP, @VDB_PEDI_PRECO_UNIT, @VDB_PEDI_QTDE_SOLIC, @VDB_PEDI_QTDE_CANC
									END
									CLOSE CUR_PED_PROD2
								  DEALLOCATE CUR_PED_PROD2
									  SET @V_DESCONTO_MEDIO_PEDIDO = (1 - (@V_VALOR_LIQ_TOTAL_DESCONTOS / @V_VALOR_BRU_TOTAL)) * 100;
									  SET @V_DESCONTO_PED_ITEM = @V_DESCONTO_ITEM
									  IF @V_DESCONTO_PED_ITEM > @V_DB_ALCP_DCTOMAXJUSTIF
											SET @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
									  IF (  @V_DESCONTO_ITEM  >  @VDB_ALCP_DESCTOMEDIO) 
									  BEGIN                         
										SET @V_FLG = 1;  
										BREAK;                  
									  END;
								END
							  END
					  END
					  SELECT @V_POL_INDDESCCABMOTDESOBRIG_LIB = ISNULL(DB_PRMS_VALOR, '')
						FROM DB_PARAM_SISTEMA
						WHERE DB_PRMS_ID = 'POL_INDDESCCABMOTDESOBRIG_LIB';
					  IF ISNULL(@V_POL_INDDESCCABMOTDESOBRIG_LIB, '') <> ''
                      BEGIN
						   SET @V_VALIDA_DESCONTO = 0;
						   SET @V_TEMP_COUNT = 1
						   WHILE (@V_TEMP_COUNT <= LEN(@V_POL_INDDESCCABMOTDESOBRIG_LIB))
						   BEGIN
							    SELECT TOP 1 @V_VALIDA_DESCONTO = 1
								  FROM DB_PEDIDO_MOTIVO_INVESTIMENTO
							 	 WHERE PEDIDO = @P_NRO
								   AND APLICACAO = 'C'									
								   AND (INDICE_DESCONTO = DBO.MERCF_PIECE(@V_POL_INDDESCCABMOTDESOBRIG_LIB, ',', @V_TEMP_COUNT)
								            AND DBO.MERCF_PIECE(@V_POL_INDDESCCABMOTDESOBRIG_LIB, ',', @V_TEMP_COUNT) <> '')   -- ALENCAR - MOTIVOS DE INVESTIMENTO ADICIONEI O AND
								   AND ISNULL(MOTIVO_INVESTIMENTO, 0) = 0
							   IF @V_VALIDA_DESCONTO = 1
							   BEGIN
								  ----- ALENCAR - MOTIVOS DE INVESTIMENTO
						          SET @P_ERROLIMVERBA = 'Obrigatório informar solicitação de investimento nos descontos da capa para liberar o pedido.';
						          SET @V_SAI = 1
								  SET @V_FLG = 1;
								  BREAK;
							   END							   
							   SET @V_TEMP_COUNT = @V_TEMP_COUNT + 1;
						   END
						   SET @V_SOLICITACAO_BLOQUEADA = 0;
						   SELECT TOP 1 @V_SOLICITACAO_BLOQUEADA = 1
							 FROM DB_PEDIDO_MOTIVO_INVESTIMENTO, DB_SOLIC_INVESTIMENTO
							WHERE DB_PEDIDO_MOTIVO_INVESTIMENTO.PEDIDO = @P_NRO
							  AND DB_PEDIDO_MOTIVO_INVESTIMENTO.SOLICITACAO_INVESTIMENTO = DB_SOLIC_INVESTIMENTO.NUMERO
							  AND DB_SOLIC_INVESTIMENTO.SITUACAO = 0								  
						   IF @V_SOLICITACAO_BLOQUEADA = 1
						   BEGIN
							  SET @P_ERROLIMVERBA = 'Não pode ser liberado porque está vinculado a solicitações de investimento bloqueadas.';
							  SET @V_SAI = 1
							  SET @V_FLG = 1;
							  BREAK;
						   END
				      END					  
					  SELECT @V_POL_INDDESCTOITMOTDESOBRIG_LIB = ISNULL(DB_PRMS_VALOR, 0)
					   FROM DB_PARAM_SISTEMA
					  WHERE DB_PRMS_ID = 'POL_INDDESCTOITMOTDESOBRIG_LIB';
					  IF ISNULL(@V_POL_INDDESCTOITMOTDESOBRIG_LIB, '') <> ''
					  BEGIN
					    SET @V_TEMP_COUNT = 1;
					    WHILE (@V_TEMP_COUNT <= LEN(@V_POL_INDDESCTOITMOTDESOBRIG_LIB))
						BEGIN
						      SELECT TOP 1 @V_VALIDA_DESCONTO = 1
								FROM DB_PEDIDO_MOTIVO_INVESTIMENTO
							   WHERE PEDIDO = @P_NRO
								 AND (ITEM < 1000 AND ITEM <> 0)
								 AND APLICACAO = 'I'
							 	 AND (INDICE_DESCONTO = DBO.MERCF_PIECE(@V_POL_INDDESCTOITMOTDESOBRIG_LIB, ',', @V_TEMP_COUNT)
								         AND DBO.MERCF_PIECE(@V_POL_INDDESCTOITMOTDESOBRIG_LIB, ',', @V_TEMP_COUNT) <> '')   -- ALENCAR - MOTIVOS DE INVESTIMENTO ADICIONEI O AND
								 AND ISNULL(MOTIVO_INVESTIMENTO, 0)  = 0;
							  IF  @V_VALIDA_DESCONTO = 1
							  BEGIN		
							      --- ALENCAR -- MOTIVOS DE INVESTIMENTO
						         SET @P_ERROLIMVERBA = 'Obrigatório informar solicitação de investimento nos descontos dos itens para liberar o pedido.';
						         SET @V_SAI = 1
								 SET @V_FLG = 1;
								 BREAK
							  END  
							  SET @V_TEMP_COUNT = @V_TEMP_COUNT + 1;
						END
						SET @V_SOLICITACAO_BLOQUEADA = 0;
						   SELECT TOP 1 @V_SOLICITACAO_BLOQUEADA = 1
							 FROM DB_PEDIDO_MOTIVO_INVESTIMENTO, DB_SOLIC_INVESTIMENTO
							WHERE DB_PEDIDO_MOTIVO_INVESTIMENTO.PEDIDO = @P_NRO
							  AND DB_PEDIDO_MOTIVO_INVESTIMENTO.SOLICITACAO_INVESTIMENTO = DB_SOLIC_INVESTIMENTO.NUMERO
							  AND DB_SOLIC_INVESTIMENTO.SITUACAO = 0								  
						   IF @V_SOLICITACAO_BLOQUEADA = 1
						   BEGIN
							  SET @P_ERROLIMVERBA = 'Não pode ser liberado porque está vinculado a solicitações de investimento bloqueadas.';
							  SET @V_SAI = 1
							  SET @V_FLG = 1;
							  BREAK;
						   END
					  END
					  SELECT @V_POL_DESCTOINVEST_LIB = ISNULL(DB_PRMS_VALOR, 0)						
						FROM DB_PARAM_SISTEMA
					   WHERE DB_PRMS_ID = 'POL_DESCTOINVEST_LIB';					    
					   IF @V_POL_DESCTOINVEST_LIB = 1
					   BEGIN
						   SET @V_VALIDA_DESCONTO = 0;
						   SELECT TOP 1 @V_VALIDA_DESCONTO = 1
							 FROM DB_PEDIDO_MOTIVO_INVESTIMENTO
						 	WHERE PEDIDO = @P_NRO
							   AND ITEM = 0
							  AND ISNULL(SOLICITACAO_INVESTIMENTO, 0) = 0		   
						   IF @V_VALIDA_DESCONTO = 1
						   BEGIN
						       --- ALENCAR -- MOTIVOS DE INVESTIMENTO
						      SET @P_ERROLIMVERBA = 'Obrigatório informar solicitação de investimento nos descontos de investimento liberar o pedido.
';
					          SET @V_SAI = 1
							  SET @V_FLG = 1;
							  BREAK
						   END    
						   SET @V_SOLICITACAO_BLOQUEADA = 0;
						   SELECT TOP 1 @V_SOLICITACAO_BLOQUEADA = 1
							 FROM DB_PEDIDO_MOTIVO_INVESTIMENTO, DB_SOLIC_INVESTIMENTO
							WHERE DB_PEDIDO_MOTIVO_INVESTIMENTO.PEDIDO = @P_NRO
							  AND DB_PEDIDO_MOTIVO_INVESTIMENTO.SOLICITACAO_INVESTIMENTO = DB_SOLIC_INVESTIMENTO.NUMERO
							  AND DB_SOLIC_INVESTIMENTO.SITUACAO = 0								  
						   IF @V_SOLICITACAO_BLOQUEADA = 1
						   BEGIN
							  SET @P_ERROLIMVERBA = 'Não pode ser liberado porque está vinculado a solicitações de investimento bloqueadas.';
							  SET @V_SAI = 1
							  SET @V_FLG = 1;
							  BREAK;
						   END
					   END
					END
					SET @V_PASSO = 14;					
					--- ALENCAR -- MOTIVOS DE INVESTIMENTO
					IF @V_SAI = 1
					BEGIN
						ROLLBACK
						RETURN			
					END					
					---------------------
					--- MOTIVO F
					---------------------
					IF SUBSTRING(@V_MOTIVOS, @V_AUX, 1) = 'F'
					BEGIN
						--PRINT  '@V_TBOPS_FAT ' + @V_TBOPS_FAT
						--PRINT  '@@V_LIB_BONMAX ' + CONVERT(VARCHAR, @V_LIB_BONMAX)
						--PRINT  '@@@V_BON_PERC ' + CONVERT(VARCHAR, @V_BON_PERC)
						IF @V_TBOPS_FAT = 'B'	
							BEGIN		
								IF (ISNULL(@V_LIB_BONMAX, 0) <> 999.99 AND ISNULL(@V_LIB_BONMAX, 0) > 0)
								  OR (@V_BON_TOT > @V_LIB_BONMAX_VLR AND @V_LIB_BONMAX_VLR > 0)  --- 85851
									SET @V_FLG = 1;	
							END		
						ELSE
							IF (@V_BON_PERC > @V_LIB_BONMAX AND @V_LIB_BONMAX > 0)
							  OR (@V_BON_TOT > @V_LIB_BONMAX_VLR AND @V_LIB_BONMAX_VLR > 0)  --- 85851
								SET @V_FLG = 1;
						SELECT @V_POL_BONIMOTIVOBRIG_LIB = ISNULL(DB_PRMS_VALOR, 0)							  
						 FROM DB_PARAM_SISTEMA
						WHERE DB_PRMS_ID = 'POL_BONIMOTIVOBRIG_LIB';
						  IF @V_POL_BONIMOTIVOBRIG_LIB = 1 
						  BEGIN					
							SET @V_MOTIVO_INVESTIMENTO = 0
						   SELECT TOP 1 @V_MOTIVO_INVESTIMENTO = 1
							  FROM DB_PEDIDO_MOTIVO_INVESTIMENTO  MOTINV
							     , DB_PEDIDO_PROD                 PEDPROD
							 WHERE MOTINV.PEDIDO = @P_NRO
							   AND ISNULL(MOTINV.MOTIVO_INVESTIMENTO, 0) = 0
							   AND MOTINV.PEDIDO   = PEDPROD.DB_PEDI_PEDIDO
							   AND MOTINV.ITEM     = PEDPROD.DB_PEDI_SEQUENCIA
							   AND DB_PEDI_TIPO    = 'B'
							IF @V_MOTIVO_INVESTIMENTO = 1
							BEGIN
							    --- ALENCAR -- MOTIVOS DE INVESTIMENTO
						        SET @P_ERROLIMVERBA = 'Obrigatório informar solicitação de investimento nos itens de bonificação liberar o pedido.';
					            SET @V_SAI = 1
								SET @V_FLG = 1;									
							END	
							ELSE
							BEGIN
							   SET @V_SOLICITACAO_BLOQUEADA = 0;
							   SELECT TOP 1 @V_SOLICITACAO_BLOQUEADA = 1
								 FROM DB_PEDIDO_MOTIVO_INVESTIMENTO, DB_SOLIC_INVESTIMENTO
								WHERE DB_PEDIDO_MOTIVO_INVESTIMENTO.PEDIDO = @P_NRO
								  AND DB_PEDIDO_MOTIVO_INVESTIMENTO.SOLICITACAO_INVESTIMENTO = DB_SOLIC_INVESTIMENTO.NUMERO
								  AND DB_SOLIC_INVESTIMENTO.SITUACAO = 0								  
							   IF @V_SOLICITACAO_BLOQUEADA = 1
							   BEGIN
								  SET @P_ERROLIMVERBA = 'Não pode ser liberado porque está vinculado a solicitações de investimento bloqueadas.';
								  SET @V_SAI = 1
								  SET @V_FLG = 1;								  
							   END
							END              
						  END
						  SET @V_VERIFICA_MOTIVO_BLOQ78 = 0;
						  SELECT @V_VERIFICA_MOTIVO_BLOQ78 = 1 
						    FROM DB_PEDIDO_MOTBLOQ 
						   WHERE DB_PEDM_PEDIDO = @P_NRO 
						     AND DBO.MERCF_VALIDA_LISTA(78, REPLACE(DB_PEDM_IDBLOQ, ';', ','), 0, ',') = 1
							 AND ISNULL(DB_PEDM_IDBLOQ, '') <> '';
							-- PRINT '@V_VERIFICA_MOTIVO_BLOQ78: ' + CAST(@V_VERIFICA_MOTIVO_BLOQ78 AS VARCHAR)
						  IF @V_VERIFICA_MOTIVO_BLOQ78 = 1
						  BEGIN
							SET @V_URL = ''
							SELECT @V_URL = 'http:' + SUBSTRING(DB_PRMS_VALOR,  CHARINDEX('//', DB_PRMS_VALOR), LEN(DB_PRMS_VALOR)) + '/Services/WSCalculos.svc/SaldoVerbaBonificacao'
						      FROM DB_PARAM_SISTEMA 
						     WHERE DB_PRMS_ID = 'SIS_ENDERECOMERCANETWEB';
							SET @V_JSON = '"{ PEDIDO : ';
							SET @V_JSON = @V_JSON + '' + CAST(@P_NRO AS VARCHAR) + '';   
							SET @V_JSON = @V_JSON + ' } " ';
							--PRINT 'JSON :' + @V_JSON;
							--PRINT '@V_URL: ' + @V_URL
							EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @VPOINTER OUTPUT
							EXEC sp_OAMethod @VPOINTER, 'open', NULL, 'POST', @V_URL
							EXEC sp_OAMethod @VPOINTER, 'setRequestHeader', null, 'Content-Type', 'application/json'	
							EXEC sp_OAMethod @VPOINTER, 'send', null, @V_JSON
							EXEC sp_OAMethod @VPOINTER, 'responseText' , @VRESPONSETEXT OUTPUT
							EXEC sp_OAMethod @VPOINTER, 'Status', @VSTATUS OUTPUT
							EXEC sp_OAMethod @VPOINTER, 'StatusText', @VSTATUSTEXT OUTPUT
							EXEC sp_OADestroy @VPOINTER
							--SELECT @VSTATUS, @VSTATUSTEXT, @VRESPONSETEXT
							--SELECT @UNWRAPPEDXML
							--PRINT 'STATUS: ' + ISNULL( @VSTATUSTEXT, 'NULL')
							--PRINT '@VRESPONSETEXT: ' + ISNULL( @VRESPONSETEXT, 'NULL')
							--PRINT '@VSTATUS: ' + CAST(@VSTATUS AS VARCHAR)
							IF @VSTATUS = 200
							BEGIN
								SET @VRESPONSETEXT = REPLACE(@VRESPONSETEXT, '"', '')								
								IF ISNULL(DBO.MERCF_PIECE(@VRESPONSETEXT, '|', 1), '')  <> ''
								BEGIN								
									SET @P_ERROLIMVERBA = DBO.MERCF_PIECE(@VRESPONSETEXT, '|', 1)
									SET @V_SAI = 1
									ROLLBACK
									RETURN	
								END
								ELSE
								BEGIN
									UPDATE DB_PEDIDO_PROD
									   SET DB_PEDI_VISAO = DBO.MERCF_PIECE(@VRESPONSETEXT, '|', 2),
									       DB_PEDI_PERIODO = DBO.MERCF_PIECE(@VRESPONSETEXT, '|', 3)
									 WHERE DB_PEDI_PEDIDO = @P_NRO
									   AND DB_PEDI_TIPO = 'B'
								END
							END
						  END
					END
					SET @V_PASSO = 15;
--PRINT  'PASSOU DA BONI COM FLAG ' + CONVERT(VARCHAR, @V_FLG)
					--- ALENCAR -- MOTIVOS DE INVESTIMENTO
					IF @V_SAI = 1
					BEGIN
						ROLLBACK
						RETURN			
					END
					---------------------
					--- MOTIVO L 
					---------------------
					IF SUBSTRING(@V_MOTIVOS, @V_AUX,1) = 'L'
					BEGIN					
						IF @V_FORMA_AVALIA_LUCRA = 1
						BEGIN
							SET @V_VALIDA_BLOQ_93 = 0
							SELECT TOP 1 @V_VALIDA_BLOQ_93 = 1
									FROM DB_PEDIDO_MOTBLOQ 
									WHERE DB_PEDM_PEDIDO = @P_NRO
									AND DBO.MERCF_VALIDA_LISTA(93, REPLACE(DB_PEDM_IDBLOQ, ';', ','), 0, ',') = 1
									AND ISNULL(DB_PEDM_IDBLOQ, '') <> ''									
							IF @V_VALIDA_BLOQ_93 = 1
							BEGIN
								SET @V_VALIDA_BLOQ_93 = 0
								SELECT TOP 1 @V_VALIDA_BLOQ_93 = 1
									FROM DB_PEDIDO_PROD
									WHERE DB_PEDI_PEDIDO = @P_NRO
										AND ISNULL(DB_PEDI_BLOQLUC, 0) = 1
										AND DB_PEDI_PERC_MLUCR < @V_PERCMINIMO_LUCR_ITEM											
								SET @V_LIMPA_BLOQ_L_ITENS = 1
								IF @V_VALIDA_BLOQ_93 = 1
								BEGIN										
									SET @V_FLG = 1;
									SET @V_LIMPA_BLOQ_L_ITENS = 0									
								END
								ELSE
								BEGIN ---VALIDR SE O PEDIDO TEM O BLOQUEIO -L- QUE NÃO FOI LIBERADO, NESSE CASO DEVE MANTER O BLOQUEI -L- PARA QUE UMA PROXIMA ALÇADA LIBERA-LO
									IF @VDB_PEDC_BLOQLUC = 1
										SET @V_FLG = 1;
								END
							END
							ELSE
							BEGIN
								IF @VDB_PEDC_BLOQLUC = 1
									SET @V_FLG = 1;							
							END
						END
						ELSE
						BEGIN
							SET @V_LIMPA_BLOQ_L_PEDIDO = 1
							IF @V_LUCRATIVIDADE < @V_USU_PERCMINIMO_LUCR
							BEGIN
								SET @V_FLG = 1;
								SET @V_LIMPA_BLOQ_L_PEDIDO = 0								
							END
							ELSE
							BEGIN
								SET @V_VALIDA_BLOQ_93 = 0
								SELECT TOP 1 @V_VALIDA_BLOQ_93 = 1
									FROM DB_PEDIDO_PROD
									WHERE DB_PEDI_PEDIDO = @P_NRO
										AND ISNULL(DB_PEDI_BLOQLUC, 0) = 1
								IF @V_VALIDA_BLOQ_93 = 1
								BEGIN
									SET @V_FLG = 1;									
								END 
							END
						END
					   --- SE LIBEROU O BLOQUEIO L POR PEDIDO, LIMPA O CAMPO DE BLOQUEIO
					   IF @V_LIMPA_BLOQ_L_PEDIDO = 1
					   BEGIN
							UPDATE DB_PEDIDO_COMPL
							   SET DB_PEDC_BLOQLUC = 0
							 WHERE DB_PEDC_NRO = @P_NRO
					   END
					   --- SE LIBEROU O BLOQUEIO L POR ITENS, LIMPA O CAMPO DE BLOQUEIO
					   IF @V_LIMPA_BLOQ_L_ITENS = 1
					   BEGIN
						  UPDATE DB_PEDIDO_PROD
							 SET DB_PEDI_BLOQLUC = 0
						   WHERE DB_PEDI_PEDIDO = @P_NRO
					   END
					END
					-- FIM MOTIVO L
					---------------------------------------------------------------
					SET @V_PASSO = '16';
					---------------------
					--- MOTIVO V
					---------------------
					IF SUBSTRING(@V_MOTIVOS, @V_AUX,1) = 'V'
					BEGIN 
						SET @V_TIPO_AGRUPAMENTO = 0;
						--- BUSCA O TIPO DE AGRUPAMENTO
						----1 = PRODUTO; 2 = TIPO; 3 = MARCA; 4 = FAMÍLIA
						SELECT TOP 1 @V_TIPO_AGRUPAMENTO = TIPO_AGRUPAMENTO
						  FROM DB_BLOQ_V_AGRUPAMENTO						 
						SELECT TOP 1 @VDB_PEDM_AGRUPAMENTO		  = DB_PEDM_AGRUPAMENTO , 
									 @VDB_PEDM_VALOR_AGRUPAMENTO  = DB_PEDM_VALOR_AGRUPAMENTO 
						  FROM DB_PEDIDO_MOTBLOQ
						 WHERE DB_PEDM_PEDIDO = @P_NRO
						   AND DB_PEDM_IDBLOQ LIKE '%83%'
						SET @V_COUNT_AGRUPAMENTOS = 1;
						SET @V_NUMERO_AGRUPAMENTOS = 0;
						IF ISNULL(@VDB_PEDM_AGRUPAMENTO, '') <> ''
							SET @V_NUMERO_AGRUPAMENTOS = (LEN(@VDB_PEDM_AGRUPAMENTO) - LEN(REPLACE(@VDB_PEDM_AGRUPAMENTO,';',''))) + 1					
						WHILE(@V_COUNT_AGRUPAMENTOS <= @V_NUMERO_AGRUPAMENTOS)
						BEGIN
						    SET @V_AGRUPAMENTO = DBO.MERCF_PIECE(@VDB_PEDM_AGRUPAMENTO, ';', @V_COUNT_AGRUPAMENTOS)
							SET @V_VALOR_AGRUPAMENTO_MINIMO = DBO.MERCF_PIECE(@VDB_PEDM_VALOR_AGRUPAMENTO, ';', @V_COUNT_AGRUPAMENTOS)														
							SELECT @V_TOTAL_AGRUPAMENTO = ISNULL(SUM(VALORES.PRECO)/ SUM(VALORES.PESO), 0)
							  FROM(
									SELECT ((((DB_PEDI_PRECO_LIQ -			
												((DB_PEDI_PRECO_LIQ * (DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_CANC) *
												(CASE WHEN DB_PROD_NTRIBPISC = 0 
												THEN 		
													ISNULL((SELECT TOP 1 DB_TBOPSP_PERC
													   FROM DB_TB_OPERS_PERC
													  WHERE DB_TBOPSP_COD = DB_PEDI_OPERACAO
														AND DB_TBOPSP_IMPOSTO = 2
														AND (( DB_TBOPSP_DT_INI <= DB_PED_DT_EMISSAO AND DB_TBOPSP_DT_FIN >= DB_PED_DT_EMISSAO) 
														 OR (ISNULL(DB_TBOPSP_DT_INI, '') = '' OR ISNULL(DB_TBOPSP_DT_FIN, '') = ''))), 0)
												ELSE 0 END   / 100)) +
												(DB_PEDI_PRECO_LIQ * (DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_CANC) *
											   (CASE WHEN DB_PROD_NTRIBPISC = 0 
												THEN 		
													ISNULL((SELECT TOP 1 DB_TBOPSP_PERC
													   FROM DB_TB_OPERS_PERC
													  WHERE DB_TBOPSP_COD = DB_PEDI_OPERACAO
														AND DB_TBOPSP_IMPOSTO = 1
														AND (( DB_TBOPSP_DT_INI <= DB_PED_DT_EMISSAO AND DB_TBOPSP_DT_FIN >= DB_PED_DT_EMISSAO) 
														 OR (ISNULL(DB_TBOPSP_DT_INI, '') = '' OR ISNULL(DB_TBOPSP_DT_FIN, '') = ''))), 0)
												ELSE 0 END  / 100)) +
												(DB_PEDI_PRECO_LIQ * (DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_CANC) *
												(CASE WHEN (DB_PEDI_ICMSDSCTO = 1 OR (ISNULL((SELECT DB_TBOPS_TRIB_ICMS FROM DB_TB_OPERS WHERE DB_TBOPS_COD = '4'), 1) = 1))
												  THEN 0
												  ELSE DB_PEDI_ICMSDEST END  / 100)) ) / (DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_CANC)
												 - (DB_PEDI_VLR_FRETIT - DB_PEDIDO_PROD.DB_PEDI_VLR_DESCARGA))	/ DB_PROD_PESO_BRU)  * 1000) * (DB_PROD_PESO_BRU * (DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_CANC)) )  PRECO,
												(DB_PROD_PESO_BRU * (DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_CANC))   PESO
									  FROM DB_PEDIDO, DB_PEDIDO_PROD, DB_PRODUTO
									 WHERE DB_PEDI_PRODUTO = DB_PROD_CODIGO
									   AND DB_PED_NRO = DB_PEDI_PEDIDO
									   AND DB_PEDI_PEDIDO = @P_NRO									   
									   AND (CASE @V_TIPO_AGRUPAMENTO
									            WHEN 1
													THEN CASE WHEN DB_PROD_CODIGO = @V_AGRUPAMENTO THEN 1 ELSE 0 END
												WHEN 2
													THEN CASE WHEN DB_PROD_TPPROD = @V_AGRUPAMENTO THEN 1 ELSE 0 END
												WHEN 3
													THEN CASE WHEN DB_PROD_MARCA = @V_AGRUPAMENTO THEN 1 ELSE 0 END
												WHEN 4
													THEN CASE WHEN DB_PROD_FAMILIA = @V_AGRUPAMENTO THEN 1 ELSE 0 END
												ELSE 0  
										   END) = 1
									)AS VALORES
							--SE O AGRUPAMENTO FOSSE FAMÍLIA A COM VALOR MÍNIMO DE R$ 4.000,00 E O PREÇO MÉDIO TONELADA DOS ITENS DA FAMÍLIA A NO PEDIDO FICOU EM R$ 3.500,00.
							--CÁLCULO: 100 - (3500 / 4000 *100) = 12,5
							IF (100 - (( @V_TOTAL_AGRUPAMENTO / CAST(REPLACE(@V_VALOR_AGRUPAMENTO_MINIMO, ',', '.') AS REAL)) * 100 )) > @V_PERCENTUAL_MAXIMO_REDUCAO
							BEGIN
								SET @V_FLG = 1								
								BREAK
							END		
							SET @V_COUNT_AGRUPAMENTOS = @V_COUNT_AGRUPAMENTOS + 1						
						END
					END					
					----------------------------------------------FIM MOTIVO V
					---------------------
					--- MOTIVO X - PROJETO CANAL DIRETO
					---      ESSE BLOCO VALIDA SE EXISTE CONTA DE INVESTIMENTO ASSOCIADA AO PEDIDO. SE NÃO EXISTE NAO PERMITE LIBERAR
					---------------------
					IF SUBSTRING(@V_MOTIVOS, @V_AUX,1) = 'X'
					BEGIN
						SELECT @V_LIB_BLOQXDEBITOCONTA = MAX(DB_PRMS_VALOR)
							FROM DB_PARAM_SISTEMA 
							WHERE DB_PRMS_ID = 'LIB_BLOQXDEBITOCONTA';
						IF @V_LIB_BLOQXDEBITOCONTA = 1
						BEGIN
							--- QUANDO O PEDIDO NAO TEM CONTA DE INVESTIMENTO DO GERENTE NAO DEVE LIBERA-LO
							IF ISNULL(@V_DB_PEDC_CONTAINV_SUP, 0) = 0
							BEGIN
							    SET @P_ERROLIMVERBA = 'Obrigatório informar conta de investimento para liberar pelo motivo X.';
								SET @V_FLG = 1;
								ROLLBACK
							    RETURN		
							END
						END
					END -- IF SUBSTRING(@V_MOTIVOS, @V_AUX,1) = 'L'
					---- MOTIVO X - PROJETO CANAL DIRETO
					IF SUBSTRING(@V_MOTIVOS, @V_AUX,1) = 'K'
					BEGIN				
						SET @V_INDICE_DESCTO_FINANCEIRO = 0
						SELECT @V_INDICE_DESCTO_FINANCEIRO = DB_PRMS_VALOR
						 FROM DB_PARAM_SISTEMA
						WHERE DB_PRMS_ID = 'PED_INDDCTOFINANC'
						IF @V_INDICE_DESCTO_FINANCEIRO <> 0 AND @VDB_ALCP_DCTOMAXVERBA > 0
						BEGIN
							DECLARE CUR_PED_ITENS_BLOQ_K CURSOR
								FOR SELECT DB_PEDI_SEQUENCIA, 
										   DB_PEDI_PRECO_UNIT, 
										   DB_PEDI_PRECO_LIQ, 
										DB_PEDI_QTDE_SOLIC - DB_PEDI_QTDE_CANC,
										round((DB_PEDI_PRECO_LIQ * DB_PEDI_ESTVLR ) +
											((DB_PEDI_PRECO_LIQ * DB_PEDI_ESTVLR * isnull(DB_PEDI_IPI, 0) / 100)) +
											((DB_PEDI_ESTVLR * 
											ISNULL(DB_PEDIDO_PROD.DB_PEDI_VLRIPI * DB_PEDI_ESTVLR, 0))) + isnull(DB_PEDI_VLR_SUBST * DB_PEDI_ESTVLR, 0), 2) 
										FROM DB_PEDIDO_PROD
										WHERE DB_PEDI_PEDIDO = @P_NRO 
										  and DB_PEDI_BLOQVERBA = 1
							OPEN CUR_PED_ITENS_BLOQ_K
							FETCH NEXT FROM CUR_PED_ITENS_BLOQ_K
							INTO @V_SEQ_ITEM_BLOQ_K, @V_PRECO_BRUTO_K, @V_PRECO_LIQUIDO_K, @V_QUANTIDADE_K, @V_PRECO_COM_IMPOSTOS_K
							WHILE @@FETCH_STATUS = 0
							BEGIN
								SELECT @V_DESCONTO_CALCULADO	 = DB_PEDD_DCTOPOL, 
									   @V_DESCONTO_APLICADO		 = DB_PEDD_DESCONTO,
									   @V_BASE_DESCTO_FINANCEIRO = ISNULL(DB_PEDD_BASEDESCTOFINANC, 0),
									   @V_VALOR_INIT_DESC_FINAN  = DB_PEDD_VALOR_UNITARIO
								 FROM DB_PEDIDO_DESCONTO
								WHERE DB_PEDD_NRO = @P_NRO 
								  AND DB_PEDD_TPDESC  = 0
								  AND DB_PEDD_SEQIT = @V_SEQ_ITEM_BLOQ_K
								  AND DB_PEDD_INDDESCTO = @V_INDICE_DESCTO_FINANCEIRO						
								IF @V_DESCONTO_CALCULADO <> 0 OR @V_DESCONTO_APLICADO <> 0
								BEGIN
									IF @V_BASE_DESCTO_FINANCEIRO = 0
										SET @V_VALOR_BASE = @V_PRECO_LIQUIDO_K;
									ELSE IF @V_BASE_DESCTO_FINANCEIRO = 1
										SET @V_VALOR_BASE = @V_PRECO_COM_IMPOSTOS_K;
									ELSE IF @V_BASE_DESCTO_FINANCEIRO = 2
										SET @V_VALOR_BASE = @V_PRECO_BRUTO_K;
									SET @V_PRECO_APLICADO_TOTAL = (@V_PRECO_BRUTO_K - @V_VALOR_INIT_DESC_FINAN) * @V_QUANTIDADE_K
									SET @V_PRECO_TOTAL_POLITICA = ( @V_PRECO_BRUTO_K - ((@V_VALOR_BASE * @V_DESCONTO_CALCULADO) / 100 )) * @V_QUANTIDADE_K
									SET @V_ECONOMIA_ITEM = @V_PRECO_APLICADO_TOTAL - @V_PRECO_TOTAL_POLITICA
									IF ((@V_ECONOMIA_ITEM * 100) / (@V_PRECO_APLICADO_TOTAL - @V_ECONOMIA_ITEM)) * (-1)  > @VDB_ALCP_DCTOMAXVERBA
									BEGIN
										SET @V_FLG = 1;									
										BREAK;
									END
								END		
							FETCH NEXT FROM CUR_PED_ITENS_BLOQ_K
							INTO @V_SEQ_ITEM_BLOQ_K, @V_PRECO_BRUTO_K, @V_PRECO_LIQUIDO_K, @V_QUANTIDADE_K, @V_PRECO_COM_IMPOSTOS_K
							END
							CLOSE CUR_PED_ITENS_BLOQ_K
							DEALLOCATE CUR_PED_ITENS_BLOQ_K
						END
					END
					IF SUBSTRING(@V_MOTIVOS, @V_AUX,1) = 'T'
					BEGIN
						IF @VDB_ALCP_VLRMAXTPPED > 0 AND @V_PED_TOT > @VDB_ALCP_VLRMAXTPPED 
						BEGIN
							SET @V_FLG = 1;
						END
					END
					IF (SUBSTRING(@V_MOTIVOS, @V_AUX, 1) = 'A' AND NOT  ( @V_FLG_LIB_MOTIVO_A_ALCADA = 1 AND @V_FLG_LIB_MOTIVO_A_PGTO = 1) ) OR SUBSTRING(@V_MOTIVOS, @V_AUX, 1) <> 'A'
					BEGIN
						IF @V_LIBERA_PEDIDO = 0  --PEDIDO
							BEGIN
								IF (@V_VLR_PED > @V_VLR_MAX) AND NOT (@V_FLG = 0 AND @V_LIB_LIMITEEXCEDIDO = 1)
									 SET @V_FLG = 1;
								ELSE IF (@V_VLR_PED < @V_VLR_MAX) AND (@V_LIB_LIMITEEXCEDIDO = 1)
									 SET @V_FLG = 1;
							END
						IF @V_LIBERA_PEDIDO = 1  --PEDIDOS EM ABERTO
							BEGIN
								IF @V_TOTAL_PEDIDOS_EM_ABERTO > @V_VLR_MAX
									SET @V_FLG = 1;
							END		
						IF @V_LIBERA_PEDIDO = 2  --COBRANÇAS
							BEGIN
								IF @V_TOTAL_COBRANCA_CLIENTE > @V_VLR_MAX
									SET @V_FLG = 1;
							END
						IF @V_LIBERA_PEDIDO = 3  --PEDIDOS EM ABERTO + COBRANÇAS
							BEGIN
								IF (@V_TOTAL_PEDIDOS_EM_ABERTO + @V_TOTAL_COBRANCA_CLIENTE) > @V_VLR_MAX
									 SET @V_FLG = 1;
							END
					END	-- END NOT SUBSTRING(@V_MOTIVOS @V_AUX,1) = 'A'			
					SET @V_PASSO = '17';
					IF @V_FLG = 0		  
						SET @V_LIBMOTS = @V_LIBMOTS + SUBSTRING(@V_MOTIVOS, @V_AUX, 1);
			END
		    ELSE -- AA
			BEGIN			
				IF SUBSTRING(@V_MOTIVOS, @V_AUX, 1) = 'E' 
				BEGIN				
					DECLARE CUR_DOC CURSOR
					FOR SELECT SEQUENCIA
						  FROM DB_PEDIDO_DOC_BLOQ
						 WHERE PEDIDO = @P_NRO
						   AND ISNULL(DATA_LIBERACAO, '') = ''
						   AND (ISNULL(@DB_ALCP_LSTTIPODOC , '') LIKE  CAST(DOCUMENTO  AS VARCHAR)  + ',%' 
								OR ISNULL(@DB_ALCP_LSTTIPODOC , '') LIKE '%,' + CAST(DOCUMENTO AS VARCHAR) + ',%' 
								OR ISNULL(@DB_ALCP_LSTTIPODOC , '') LIKE  '%,' + CAST(DOCUMENTO  AS VARCHAR) 
								OR ISNULL(@DB_ALCP_LSTTIPODOC , '') = CAST(DOCUMENTO  AS VARCHAR) 
								OR ISNULL(@DB_ALCP_LSTTIPODOC , '') = '')
					OPEN CUR_DOC
					FETCH NEXT FROM CUR_DOC
					INTO @V_SEQ_DOC
					WHILE @@FETCH_STATUS = 0
					BEGIN
						UPDATE DB_PEDIDO_DOC_BLOQ
						   SET USUARIO_LIBERACAO = @P_USUARIO,
							   DATA_LIBERACAO    = GETDATE()
						  WHERE PEDIDO = @P_NRO
							AND SEQUENCIA = @V_SEQ_DOC;						
					FETCH NEXT FROM CUR_DOC
					INTO @V_SEQ_DOC
					END
					CLOSE CUR_DOC
					DEALLOCATE CUR_DOC
					 SET @V_EXISTE_DOC_BLOQ = 0;
					 SELECT TOP 1 @V_EXISTE_DOC_BLOQ = 1
						  FROM DB_PEDIDO_DOC_BLOQ
						 WHERE PEDIDO = @P_NRO
						   AND ISNULL(DATA_LIBERACAO, '') = '';
					--- VERIFICAR SE TODOS OS REGISTROS BLOQUEADOS DE DOCUMENTOS FORAM REALMENTE LIBERADOS
					--- SE FORAM, DEVE INCLUIR O MOTIVO COMO LIBERADO
					IF @V_EXISTE_DOC_BLOQ = 1
					BEGIN					
						SET @V_FLG = 1;
					END
					ELSE
					BEGIN
						SET @V_LIBMOTS = @V_LIBMOTS + SUBSTRING(@V_MOTIVOS, @V_AUX, 1);
					END
					---------------------
					--- MOTIVO X - PROJETO CANAL DIRETO
					---      ESSE BLOCO VALIDA SE EXISTE CONTA DE INVESTIMENTO ASSOCIADA AO PEDIDO. SE NÃO EXISTE NAO PERMITE LIBERAR
					---------------------					
					IF SUBSTRING(@V_MOTIVOS, @V_AUX,1) = 'X'
					BEGIN
						SELECT @V_LIB_BLOQXDEBITOCONTA = MAX(DB_PRMS_VALOR)
							FROM DB_PARAM_SISTEMA 
							WHERE DB_PRMS_ID = 'LIB_BLOQXDEBITOCONTA';
						IF @V_LIB_BLOQXDEBITOCONTA = 1
						BEGIN
							--- QUANDO O PEDIDO NAO TEM CONTA DE INVESTIMENTO DO GERENTE NAO DEVE LIBERA-LO
							IF ISNULL(@V_DB_PEDC_CONTAINV_SUP, 0) = 0
							BEGIN
							    SET @P_ERROLIMVERBA = 'Obrigatório informar conta de investimento para liberar pelo motivo X.';				
								SET @V_FLG = 1;
								ROLLBACK
							    RETURN		
							END
							ELSE
							BEGIN
								SET @V_LIBMOTS = @V_LIBMOTS + SUBSTRING(@V_MOTIVOS, @V_AUX, 1);
							END
						END
					END -- IF SUBSTRING(@V_MOTIVOS, @V_AUX,1) = 'L'
					---- MOTIVO X - PROJETO CANAL DIRETO
				END
				ELSE
				BEGIN
					SET @V_PASSO = '18';
					SET @V_LIBMOTS = @V_LIBMOTS + SUBSTRING(@V_MOTIVOS, @V_AUX, 1);
				END
			END  --- V_CFE_VLR, SUBSTR(WL_MOTIVOS, I, 1)) > 0 
            ---------------------
            --- MOTIVO X - PROJETO CANAL DIRETO
            ---      ESSE BLOCO INSERE LANCAMENTO DE DEBITO NA CONTA DE INVESTIMENTO
            ---------------------
            IF SUBSTRING(@V_MOTIVOS, @V_AUX,1) = 'X'
			BEGIN
                SELECT @V_LIB_BLOQXDEBITOCONTA = MAX(DB_PRMS_VALOR)
                    FROM DB_PARAM_SISTEMA 
                    WHERE DB_PRMS_ID = 'LIB_BLOQXDEBITOCONTA';
			    IF @V_LIB_BLOQXDEBITOCONTA = 1
				BEGIN
                    --- QUANDO O PEDIDO NAO TEM CONTA DE INVESTIMENTO DO GERENTE NAO DEVE LIBERA-LO
                    IF ISNULL(@V_DB_PEDC_CONTAINV_SUP, 0) = 0
					BEGIN
					    SET @P_ERROLIMVERBA = 'Obrigatório informar conta de investimento para liberar pelo motivo X.';
                        SET @V_FLG = 1;
						ROLLBACK
						RETURN		
					END
                    ELSE
					BEGIN
							SELECT @V_VALOR_LANCAMENTO = SUM(VALORES.VALOR_LANCAMENTO)
								FROM (
										SELECT CASE WHEN    PEDMOT_IT.ITEM > 0 
														AND PEDMOT_IT.ITEM < 1000 
														AND PED.DB_PED_FATUR <> 2  --- BONI
													THEN	ROUND(PEDMOT_IT.VALOR * (PEDPROD.DB_PEDI_QTDE_SOLIC - PEDPROD.DB_PEDI_QTDE_CANC), 2)
													WHEN (  PEDMOT_IT.ITEM > 1000 
														AND PEDMOT_IT.ITEM < 2000) 
														OR (PED.DB_PED_FATUR = 2)
													THEN	ROUND(PEDMOT_IT.VALOR * PEDMOT_IT.QUANTIDADE, 2) 
													WHEN PEDMOT_IT.APLICACAO = 'V'
													THEN ROUND(PEDMOT_IT.VALOR, 2)
												END    VALOR_LANCAMENTO
											FROM DB_PEDIDO                      PED          WITH (NOLOCK)
												, DB_PEDIDO_PROD                 PEDPROD      WITH (NOLOCK)
												, DB_PEDIDO_MOTIVO_INVESTIMENTO  PEDMOT_IT    WITH (NOLOCK)
											-- , DB_PEDIDO_DESCONTO             PEDDESC_IT    WITH (NOLOCK)
												, DB_MOTIVO_INVEST_DESCTO        MOTDESC
											WHERE PED.DB_PED_NRO                = @P_NRO
											AND PED.DB_PED_NRO                = PEDPROD.DB_PEDI_PEDIDO
											AND PEDPROD.DB_PEDI_SEQUENCIA     = PEDMOT_IT.ITEM
											AND PED.DB_PED_NRO                = PEDMOT_IT.PEDIDO
											AND PEDMOT_IT.MOTIVO_INVESTIMENTO =  MOTDESC.CODIGO
										--								   AND PEDDESC_IT.DB_PEDD_NRO   = PEDMOT_IT.PEDIDO
										--								   AND PEDDESC_IT.DB_PEDD_SEQIT = PEDMOT_IT.ITEM
										--								   AND PEDDESC_IT.DB_PEDD_INDDESCTO = PEDMOT_IT.INDICE_DESCONTO
											AND ISNULL(MOTDESC.BLOQUEIA_PEDIDO, 0) = 1
											AND PEDMOT_IT.APLICACAO           NOT IN ('V')
											AND PEDPROD.DB_PEDI_SITUACAO     <> 9
									UNION ALL
									SELECT ROUND(PEDMOT_CAB.VALOR, 2)   VALOR_LANCAMENTO
										FROM DB_PEDIDO                      PED            WITH (NOLOCK)
											, DB_PEDIDO_MOTIVO_INVESTIMENTO  PEDMOT_CAB     WITH (NOLOCK)
											--, DB_PEDIDO_DESCONTO             PEDDESC_CAB    WITH (NOLOCK) 
											, DB_MOTIVO_INVEST_DESCTO        MOTDESC        WITH (NOLOCK)
										WHERE PED.DB_PED_NRO                = @P_NRO
										AND PEDMOT_CAB.PEDIDO             = PED.DB_PED_NRO 
										AND PEDMOT_CAB.APLICACAO          = 'V'
										--AND PEDDESC_CAB.DB_PEDD_NRO       = PEDMOT_CAB.PEDIDO
										--AND PEDDESC_CAB.DB_PEDD_SEQIT     = 0
										--AND PEDDESC_CAB.DB_PEDD_INDDESCTO = PEDMOT_CAB.INDICE_DESCONTO  
										AND PEDMOT_CAB.MOTIVO_INVESTIMENTO =  MOTDESC.CODIGO
										AND ISNULL(MOTDESC.BLOQUEIA_PEDIDO, 0) = 1
										)   AS VALORES;
						EXEC DBO.MERCP_BUSCA_SEQUENCIA_SQL 'SEQ_DB_CC_LANCAMENTOS', @V_SEQ_LANCAMENTOS OUT
                        INSERT INTO DB_CC_LANCAMENTOS (CODIGO
                                            , TIPO
                                            , DATA_LANCAMENTO
                                            , DATA_VIGENCIA
                                            , VALOR
                                            , CONTA_CORRENTE
                                            , CLIENTE
                                            , REPRESENTANTE
                                            , DESCRICAO
                                            , PEDIDO
                                            , OCORRENCIA
                                            , DATA_REGISTRO
                                            , USUARIO_REGISTRO
											, CONTRATO
											, SEQUENCIA_DOCUMENTO)
                                        VALUES (@V_SEQ_LANCAMENTOS      -- CODIGO
                                            , 2              -- TIPO  - 2-DEBITO
                                            , GETDATE()      -- DATA_LANCAMENTO
                                            , GETDATE()      -- DATA_VIGENCIA
                                            , ISNULL(@V_VALOR_LANCAMENTO, 0)  * -1          -- VALOR
                                            , CAST(@V_DB_PEDC_CONTAINV_SUP AS VARCHAR) + '-1'     -- CONTA_CORRENTE
                                            , @V_PED_CLIENTE      -- CLIENTE
                                            , @V_PED_REPRES       -- REPRESENTANTE
                                            , 'Investimento liberado por ' + @P_USUARIO + ' para pedido ' + cast(@P_NRO as varchar)
                                            , @P_NRO         -- PEDIDO
                                            , 0              -- OCORRENCIA
                                            , GETDATE()      -- DATA_REGISTRO
                                            , @P_USUARIO     -- USUARIO_REGISTRO
											, 0              -- CONTRATO
											, 0              -- SEQUENCIA_DOCUMENTO
                                            );
                    END; -- ELSE NVL(V_DB_PEDC_CONTAINV_SUP, 0) = 0
				END; -- IF @V_LIB_BLOQXDEBITOCONTA = 1
			END; -- IF SUBSTRING(@V_MOTIVOS, @V_AUX,1) = 'L'
			---- MOTIVO X - PROJETO CANAL DIRETO				
			SET @V_PASSO = '19';			
        END --- V_PERMI, SUBSTR(V_MOTIVOS, I, 1)) > 0
END -- FIM WHILE
	--- ALENCAR -- MOTIVOS DE INVESTIMENTO
	IF @V_SAI = 1
	BEGIN
		ROLLBACK
		RETURN			
	END
--PRINT '-----------@V_PARAM_VAL_VALIDA = ' +  CAST(@V_PARAM_VAL_VALIDA AS VARCHAR)
--PRINT '------------@V_MOTIVOS' + @V_MOTIVOS
		   -- NÃO SERA MAIS REALIZADO ESSA VALIDAÇÃO - TAREFA TFS: 23270
--			IF @V_PARAM_VAL_VALIDA = 1 AND CHARINDEX('F', @V_MOTIVOS) <> 0
--			BEGIN
--			--PRINT 'ENTROU BONI------------------------------------------------------------------------'
--				SET @V_DB_CLI_ESTADO      = '';
--				SET @V_DB_PED_EMPRESA     = '';
--				SET @V_DB_PED_REPRES      = '';
--				SET @V_DB_TBREP_UNIDFV    = '';
--				SET @V_DB_PED_DT_EMISSAO  = '';
--				SET @V_DB_CLI_CODIGO      = 0;
--				SET @V_DB_PED_MOTIVO_BLOQ = '';
--				SET @V_DB_PED_OPERACAO    = '';
--				SELECT @V_DB_CLI_CODIGO      = DB_CLI_CODIGO,
--					   @V_DB_CLI_ESTADO      = DB_CLI_ESTADO,
--					   @V_DB_PED_EMPRESA     = DB_PED_EMPRESA,
--					   @V_DB_PED_REPRES      = DB_PED_REPRES,
--					   @V_DB_TBREP_UNIDFV    = DB_TBREP_UNIDFV,
--					   @V_DB_PED_MOTIVO_BLOQ = DB_PED_MOTIVO_BLOQ,
--					   @V_DB_PED_DT_EMISSAO  = DB_PED_DT_EMISSAO,
--					   @V_DB_PED_OPERACAO    = DB_PED_OPERACAO						
--				  FROM DB_PEDIDO, DB_CLIENTE, DB_TB_REPRES
--				 WHERE DB_PED_NRO = @P_NRO
--				   AND DB_PED_CLIENTE = DB_CLI_CODIGO
--				   AND DB_PED_REPRES = DB_TBREP_CODIGO;
----PRINT 'CURSOR 1'
--				DECLARE CUR_ITENS CURSOR
--				FOR SELECT DB_PROD_CODIGO,      DB_PROD_TPPROD,     DB_PEDI_OPERACAO,	   DB_PEDI_PRECO_LIQ,
--						   DB_PEDI_QTDE_SOLIC,  DB_PEDI_QTDE_CANC,  DB_PEDI_SEQUENCIA
--					  FROM DB_PEDIDO_PROD, DB_PRODUTO, DB_PEDIDO
--					 WHERE DB_PEDI_PEDIDO = @P_NRO
--					   AND DB_PEDI_PEDIDO = DB_PED_NRO
--					   AND (DB_PEDI_TIPO = 'B' OR DB_PED_FATUR = 2)
--					   AND DB_PEDI_PRODUTO = DB_PROD_CODIGO
--					OPEN CUR_ITENS
--				   FETCH NEXT FROM CUR_ITENS
--					INTO @V_DB_PROD_CODIGO,      @V_DB_PROD_TPPROD,     @V_DB_PEDI_OPERACAO,	   @V_DB_PEDI_PRECO_LIQ,
--						 @V_DB_PEDI_QTDE_SOLIC,  @V_DB_PEDI_QTDE_CANC,  @V_DB_PEDI_SEQUENCIA
--				WHILE @@FETCH_STATUS = 0
--				   BEGIN
--					  SET @V_SEM_SALDO = 0;
--					  SET @V_VALOR_TOTAL = ISNULL(@V_DB_PEDI_PRECO_LIQ, 0) * (ISNULL(@V_DB_PEDI_QTDE_SOLIC, 0) - ISNULL(@V_DB_PEDI_QTDE_CANC, 0));
--					  IF ISNULL(@V_DB_PEDI_OPERACAO, '') = ''
--					  BEGIN
--						SET @V_DB_PEDI_OPERACAO = @V_DB_PED_OPERACAO;
--					  END
--					  SET @V_RESTRICAO = '';
--					  DECLARE CUR_BONI CURSOR
--					  FOR SELECT DB_RESBR_EMPRESA,  DB_RESBR_REPRES,   DB_RESBR_CLIENTE,   DB_RESBR_UNIDFV,     DB_RESBR_TPPROD, 
--					             DB_RESBR_OPER,     DB_RESBR_EXCETO,   DB_RESB_VLVERBA,    DB_RESB_VLRUTISVN,   DB_RESB_CODIGO,
--								 DB_RESB_VUTIVERBA
--							FROM DB_RESTR_BONIF, DB_RESTR_BONIF_REG
--						  WHERE DB_RESB_CODIGO = DB_RESBR_CODIGO
--							AND DB_RESB_DATAINI <= @V_DB_PED_DT_EMISSAO
--							AND DB_RESB_DATAFIN >= @V_DB_PED_DT_EMISSAO
--							AND (DB_RESB_TIPO = 1)
--							ORDER BY DB_RESBR_PESO DESC
--						OPEN CUR_BONI
--						FETCH NEXT FROM CUR_BONI
--						INTO @V_DB_RESBR_EMPRESA,  @V_DB_RESBR_REPRES,   @V_DB_RESBR_CLIENTE,   @V_DB_RESBR_UNIDFV,     @V_DB_RESBR_TPPROD, 
--					         @V_DB_RESBR_OPER,     @V_DB_RESBR_EXCETO,   @V_DB_RESB_VLVERBA,    @V_DB_RESB_VLRUTISVN,   @V_DB_RESB_CODIGO,
--							 @V_DB_RESB_VUTIVERBA
--					   WHILE @@FETCH_STATUS = 0
--						BEGIN
--							SET @V_FLAG = 1;
--							SET @V_FLAG = DBO.MERCF_VERIFICA_IGUALDADE_FILTROS(@V_DB_RESBR_EMPRESA,
--																			   @V_DB_PED_EMPRESA,
--																			   @V_DB_RESBR_EXCETO,
--																			   @V_FLAG);
--							SET @V_FLAG = DBO.MERCF_VERIFICA_IGUALDADE_FILTROS(@V_DB_RESBR_REPRES,
--																			   @V_DB_PED_REPRES,
--																			   @V_DB_RESBR_EXCETO,
--																			   @V_FLAG);
--							SET @V_FLAG = DBO.MERCF_VERIFICA_IGUALDADE_FILTROS(@V_DB_RESBR_CLIENTE,
--																			   @V_DB_CLI_CODIGO,
--																			   @V_DB_RESBR_EXCETO,
--																			   @V_FLAG);
--							SET @V_FLAG = DBO.MERCF_VERIFICA_IGUALDADE_FILTROS(@V_DB_RESBR_UNIDFV,
--																			   @V_DB_TBREP_UNIDFV,
--																			   @V_DB_RESBR_EXCETO,
--																			   @V_FLAG);
--							SET @V_FLAG = DBO.MERCF_VERIFICA_IGUALDADE_FILTROS(@V_DB_RESBR_TPPROD,
--																			   @V_DB_PROD_TPPROD,
--																			   @V_DB_RESBR_EXCETO,
--																			   @V_FLAG);																	
--							SET @V_FLAG = DBO.MERCF_VERIFICA_IGUALDADE_FILTROS(@V_DB_RESBR_OPER,
--																			   @V_DB_PED_OPERACAO,
--																			   @V_DB_RESBR_EXCETO,
--																			   @V_FLAG);
--							IF @V_FLAG = 1
--							BEGIN
--								  IF (ISNULL(@V_DB_RESB_VLVERBA, 0) - (ISNULL(@V_DB_RESB_VUTIVERBA, 0) + ISNULL(@V_DB_RESB_VLRUTISVN, 0) + ISNULL(@V_VALOR_TOTAL, 0))) < 0
--								  BEGIN
--									  SET @V_SEM_SALDO = 1;
--								  END
--								  ELSE
--								  BEGIN
--									 UPDATE DB_RESTR_BONIF
--									    SET DB_RESB_VUTIVERBA = ISNULL(DB_RESB_VUTIVERBA, 2) + @V_VALOR_TOTAL
--									  WHERE DB_RESB_CODIGO = @V_DB_RESB_CODIGO;
--									 SET @V_RESTRICAO = @V_DB_RESB_CODIGO;
--								  END
--								  BREAK;            
--							END         
--					  FETCH NEXT FROM CUR_BONI
--						INTO @V_DB_RESBR_EMPRESA,  @V_DB_RESBR_REPRES,   @V_DB_RESBR_CLIENTE,   @V_DB_RESBR_UNIDFV,     @V_DB_RESBR_TPPROD, 
--					         @V_DB_RESBR_OPER,     @V_DB_RESBR_EXCETO,   @V_DB_RESB_VLVERBA,    @V_DB_RESB_VLRUTISVN,   @V_DB_RESB_CODIGO,
--							 @V_DB_RESB_VUTIVERBA
--						END
--						CLOSE CUR_BONI
--					DEALLOCATE CUR_BONI
--					--PRINT 'FIM CURSOR 1'
--					  IF ISNULL(@V_RESTRICAO, '') <> ''
--					  BEGIN
--						UPDATE DB_PEDIDO_PROD
--						   SET DB_PEDI_RESTRBONIF = @V_RESTRICAO
--						 WHERE DB_PEDI_SEQUENCIA = @V_DB_PEDI_SEQUENCIA
--						   AND DB_PEDI_PEDIDO = @P_NRO;
--					  END
--					  IF @V_SEM_SALDO = 1
--					  BEGIN
--						--PRINT 'ENTROU ROLLBACK'
--						SET @P_ERROLIMVERBA = 'LIMITE DE VERBA ULTRAPASSADO, CASO NECESSITE FAZER ESTA LIBERAÇÃO AUMENTE A VERBA!';
--						SET @V_SAI = 1
--					  END
--				FETCH NEXT FROM CUR_ITENS
--				  INTO @V_DB_PROD_CODIGO,      @V_DB_PROD_TPPROD,     @V_DB_PEDI_OPERACAO,	   @V_DB_PEDI_PRECO_LIQ,
--					   @V_DB_PEDI_QTDE_SOLIC,  @V_DB_PEDI_QTDE_CANC,  @V_DB_PEDI_SEQUENCIA
--				  END
--				  CLOSE CUR_ITENS
--				DEALLOCATE CUR_ITENS     
--					-- PRINT 'FIM CURSOR 2' 
--			END-- FIM IF PARAMETRO VALIDO
		IF @V_SAI = 1
		BEGIN
			ROLLBACK			
			RETURN			
		END		
		SET @V_MOTIVOS = @V_LIBMOTS;
		SET @V_LIBMOTS = '';
		SET @V_PASSO = '20';
		SET @V_AUX = 0;
		IF ISNULL(@V_MOTIVOS, '') <> ''
			WHILE @V_AUX < LEN(@V_MOTIVOS)
				BEGIN
					SET @V_AUX = @V_AUX + 1;
					IF CHARINDEX(SUBSTRING(@V_MOTIVOS, @V_AUX, 1), ISNULL(@V_BLQS,' ')) = 0
						SET @V_LIBMOTS = @V_LIBMOTS + SUBSTRING(@V_MOTIVOS, @V_AUX, 1);
				END -- FIM WHILE
		IF @P_RECALCULAMOTBLOQP = 1 AND CHARINDEX('A', @V_LIBMOTS) > 0
		BEGIN
			IF CHARINDEX('P', @V_LIBMOTS) = 0
				SET @V_LIBMOTS = @V_LIBMOTS + 'P'			
			INSERT INTO DB_PEDIDO_LOG (DB_PEDL_NRO, 
										DB_PEDL_SEQ, 
										DB_PEDL_DATA , 
										DB_PEDL_LOG )
								VALUES(
										@P_NRO,
										(SELECT ISNULL(MAX(DB_PEDL_SEQ), 0) + 1 FROM DB_PEDIDO_LOG WHERE DB_PEDL_NRO = @P_NRO),
										GETDATE(),
										SUBSTRING('Pedido ' + CAST(@P_NRO AS VARCHAR) + ' foi liberado pelo motivo P (ID 92), mesmo com datas inválidas. Data de emissão: ' + CONVERT(VARCHAR(10), @V_DB_PED_DT_EMISSAO, 103) + '. Previsão de entrega ' + CONVERT(VARCHAR(10), @VDB_PEDC_PREV_FAT, 103) + '. Usuário que liberou: ' + @P_USUARIO + '. Data de liberação: ' + (CONVERT(VARCHAR(10), GETDATE(), 103) + ' '  + CONVERT(VARCHAR(8), GETDATE(), 14)) +'.', 1, 255)
										)
		END
		ELSE-- VALIDA DATA FORA DO LIMITE
		IF @P_RECALCULAMOTBLOQP = 0 AND @V_PED_RECALCULAMOTBLOQP = 1 AND CHARINDEX('A', @V_LIBMOTS) > 0
		BEGIN
			SELECT @V_DATA3 = CONVERT(DATE, DBO.MERCF_PIECE(@P_DATAS_CALCULADAS, ';', 3), 103)
			--SE MAIOR BLOQUEIA POR P
			IF CONVERT(DATE, @V_DATA3, 103) > CONVERT(DATE, @VDB_PEDC_PREV_FAT, 103)
			BEGIN			
				UPDATE DB_PEDIDO SET DB_PED_MOTIVO_BLOQ = SUBSTRING(@V_DB_PED_MOTIVO_BLOQ_ALL, 1, 12) + 'P' + SUBSTRING(@V_DB_PED_MOTIVO_BLOQ_ALL, 14, 15) WHERE DB_PED_NRO = @P_NRO
				UPDATE DB_PEDIDO_MOTBLOQ SET DB_PEDM_IDBLOQ = DB_PEDM_IDBLOQ + ';92' WHERE DB_PEDM_PEDIDO = @P_NRO
				INSERT INTO DB_PEDIDO_LOG (DB_PEDL_NRO, 
										   DB_PEDL_SEQ, 
										   DB_PEDL_DATA , 
										   DB_PEDL_LOG )
								    VALUES(
										   @P_NRO,
										   (SELECT ISNULL(MAX(DB_PEDL_SEQ), 0) + 1 FROM DB_PEDIDO_LOG WHERE DB_PEDL_NRO = @P_NRO),
										   GETDATE(),
										   SUBSTRING('Pedido ' + CAST(@P_NRO AS VARCHAR) + ' foi bloqueado pelo motivo P (ID 92), porque possui datas inválidas. Aguarda avaliação das datas para liberação. Data do bloqueio: ' + (CONVERT(VARCHAR(10), GETDATE(), 103) + ' '  + CONVERT(VARCHAR(8), GETDATE(), 14)) + '. Data de emissão: ' + CONVERT(VARCHAR(10), @V_DB_PED_DT_EMISSAO, 103) + '. Previsão de entrega ' + CONVERT(VARCHAR(10), @VDB_PEDC_PREV_FAT, 103) + '.', 1, 255)
									      )
				COMMIT
				RETURN
			END
		END
		SET @V_PASSO = '21';
		SET @V_MOTIVOS = @V_PED_MOTIVO_BLOQ;
		SET @V_LIBTOT =  0;
		SET @V_AUX =     0;
		IF ISNULL(@V_MOTIVOS, '') <> ''
			WHILE @V_AUX < LEN(@V_MOTIVOS)
				BEGIN
				    SET @V_AUX = @V_AUX + 1;
					IF CHARINDEX(SUBSTRING(@V_MOTIVOS, @V_AUX, 1), (ISNULL(@V_BLQS, ' ') + ISNULL(@V_LIBMOTS,' '))) = 0 
						SET @V_LIBTOT = 1;
				END --FIM DO WHILE
		SET @V_PASSO = '22';
		SET @V_USUS = ISNULL(@V_USUS, '') + @P_USUARIO + '!' + CONVERT(VARCHAR, @V_GRUPO_LIB) + ';';
		SET @V_PASSO = '22.1';
		--V_HORAS = FL_RETORNA_HORAS_LIBERACAO(WL_PEDIDO, WL_DATAS);   ATENCAO: IMPLEMENTAR A ROTINA FL_RETORNA_HORAS_LIBERACAO. COLOQUEI APENAS A ATRIBUICAO A VARIAVEL NO SELECT, VER SEESTA CORRETO
		SET @V_DATAS = ISNULL(@V_DATAS, '') + CONVERT(VARCHAR, GETDATE(), 103) + ';';
		SET @V_PASSO = '22.2';
		SET @V_HORAS = ISNULL(@V_HORAS, '') + CONVERT(VARCHAR, GETDATE(), 108) + ';';
		SET @V_PASSO = '22.3';
		SET @V_BLQS = ISNULL(@V_BLQS, '') + ISNULL(@V_LIBMOTS, '') + ';';
		SET @V_PASSO = '23';
		IF @V_LIBPARC = 1
		BEGIN
			SET @V_MOTNLIBERADO = '';
		-- VERIFICA OS MOTIVOS QUE AINDA NÃO FORAM LIBERADOS
		SET @V_AUX = 0;
--PRINT  'A - @V_MOTIVOS ' + @V_MOTIVOS
--PRINT  'A - @V_BLQS ' + @V_BLQS
--PRINT  'A - @V_LIBMOTS ' + @V_LIBMOTS
		IF ISNULL(@V_MOTIVOS, '') <> ''
                WHILE @V_AUX < LEN(@V_MOTIVOS)
				  BEGIN
                    SET @V_AUX = @V_AUX + 1;
					IF CHARINDEX(SUBSTRING(@V_MOTIVOS, @V_AUX, 1), (ISNULL(@V_BLQS, '') + ISNULL(@V_LIBMOTS, ''))) = 0
                        SET @V_MOTNLIBERADO = @V_MOTNLIBERADO + SUBSTRING(@V_MOTIVOS, @V_AUX, 1);
                  END
            SET @V_ACHOU_OUTROMOTIVO = 1;
	   IF @V_GRAVALOG = 1
	   BEGIN
		 INSERT INTO DBS_ERROS_TRIGGERS
		  (DBS_ERROS_OBJETO, DBS_ERROS_DATA, DBS_ERROS_ERRO)
		  VALUES
		  ('MERCP_LIBERCAO_PEDIDO_LOG', GETDATE(), 'Pedido: ' + CAST(@P_NRO AS VARCHAR) + ' - Usu: ' + ISNULL(@P_USUARIO, 'null') + ' - acao: ' + CAST(@P_ACAO AS VARCHAR) + ' - exclui: ' + CAST(@P_EXCLUI AS VARCHAR) + ' V_MotNLiberado - ' + isnull(@V_MOTNLIBERADO, 'null'));
	   END
--PRINT  'A - @@V_MOTNLIBERADO ' + @V_MOTNLIBERADO
		/***** PASSEI A FAZER ESSA VALIDACAO NO INICIO ****/
		SET @V_AUX = 0;
		IF ISNULL(@V_MOTNLIBERADO, '') <> ''
		BEGIN
			WHILE @V_AUX < LEN(@V_MOTNLIBERADO)
				BEGIN
				    SET @V_AUX = @V_AUX + 1;
					IF RTRIM(LTRIM(SUBSTRING(@V_MOTNLIBERADO, @V_AUX, 1))) IS NOT NULL	
						IF CHARINDEX(SUBSTRING(@V_MOTNLIBERADO, @V_AUX, 1), ISNULL(@V_PARAM_MOTIVSLIBER, ' ')) = 0
							SET @V_ACHOU_OUTROMOTIVO = 0;
			    END
		--CASO TENHA ENCONTRADO SOMENTE OS MOTIVOS CFE PARAMETRO - LIBERA TOTAL
		IF NOT @V_ACHOU_OUTROMOTIVO = 0
			SET @V_LIBTOT = 0;
		END -- FIM @V_MOTNLIBERADO IS NOT NULL
	END -- FIM  @V_LIBPARC = 1
	SET @V_PASSO = '24';
	SET  @V_PASSO = '25';
	-- LINHA 10480 
    --IF WC_TAB.TAB <> 3 THEN
    --IF 3 <> 3 THEN
----PRINT  '@V_LIBTOT ' + CONVERT(VARCHAR, @V_LIBTOT)
----PRINT  '@V_LIBPARC ' + CONVERT(VARCHAR, @V_LIBPARC)
        IF (@V_LIBTOT = 0 AND @V_LIBPARC = 1)
            SET @V_UPDATE_SITUACAO = 0;
		SET @V_BLOQUEIOS = @V_BLQS;
		SET @V_PED_LIB_MOTS = ISNULL(@V_PED_LIB_MOTS, '') + @V_LIBMOTS + ';' 
      --ELSE
      --    NULL;
      ---IIF(RIGHT(WL_BLOQUEIOS, 1) <> ";", ";", "") & WL_SITUACAO_CORPORATIVO ATENCAO, CONVERTES
      --END IF;
	  SET @V_PASSO = '26';
----PRINT  'UPDATA SITUACAO ' + CONVERT(VARCHAR, @V_UPDATE_SITUACAO)
----PRINT  'UPDATA SITUACAO - @V_BLOQUEIOS ' + @V_BLOQUEIOS
----PRINT  'UPDATA SITUACAO - @V_BLQS ' + @V_BLQS
----PRINT  'UPDATA SITUACAO - @V_USUS ' + @V_USUS
----PRINT  'UPDATA SITUACAO - @V_DATAS ' + @V_DATAS
----PRINT  'UPDATA SITUACAO - @V_PED_LIB_MOTS ' + @V_PED_LIB_MOTS
	SET @V_PASSO = '27';
	IF @V_ALCADA_E_PRIORITARIA = 1 AND ISNULL(@V_ALCADA_ATUAL, '') <> ''
	BEGIN
      select @V_PEDAL_SEQ = DB_PEDAL_SEQ        
        from db_pedido_alcada
       where db_pedal_pedido = @P_NRO
         AND DB_PEDAL_ALCADA = @V_ALCADA_ATUAL;
	END
    ELSE  
	BEGIN
		SELECT @V_PEDAL_SEQ = MAX(DB_PEDAL_SEQ)
		FROM DB_PEDIDO_ALCADA
		WHERE DB_PEDAL_PEDIDO = @P_NRO;
	END
	SET @V_PASSO = '28';
		  --- NA LIBERACAO PARCIAL (CIENTE) DEVE GRAVAR O CAMPO DB_PEDAL_MOTLIBPAR
		SET @V_AUX = 0
		IF ISNULL(@V_PERMI, '') <> ''
		BEGIN
			WHILE @V_AUX < LEN(@V_PERMI)
				BEGIN
					SET @V_AUX = @V_AUX + 1;
					--- DEVE GRAVAR OS MOTIVOS PARCIAIS CFME O QUE O USUARIO TEM PERMISSAO E NAO CONSEGUIU LIBERAR
					IF  CHARINDEX(SUBSTRING(@V_PERMI, @V_AUX, 1), ISNULL(@V_MOTIVOS, ' ')) > 0
					  AND CHARINDEX(SUBSTRING(@V_PERMI, @V_AUX, 1), ISNULL(@V_LIBMOTS, ' ')) = 0
					  AND CHARINDEX(SUBSTRING(@V_PERMI, @V_AUX, 1), ISNULL(@V_PED_LIB_MOTS, ' ')) = 0
						SET @V_PEDAL_MOTLIBPAR = ISNULL(@V_PEDAL_MOTLIBPAR, '') + SUBSTRING(@V_PERMI, @V_AUX, 1);
				END
		END
          IF ISNULL(@V_LIBMOTS, '')  <> '' -- LIBERADO TOTAL
		  BEGIN
--PRINT 'LIBERA TOTAL '
		      SET @V_AUX = 0
              IF ISNULL(@VDB_PRM_JUST_LIBTOT, '') <> ''
			  BEGIN
			      WHILE @V_AUX < LEN(@VDB_PRM_JUST_LIBTOT)
				  BEGIN
					SET @V_AUX = @V_AUX + 1;
					IF RTRIM(LTRIM(SUBSTRING(@VDB_PRM_JUST_LIBTOT, @V_AUX, 1))) IS NOT NULL	
					IF CHARINDEX(SUBSTRING(@VDB_PRM_JUST_LIBTOT, @V_AUX, 1), ISNULL(@V_LIBMOTS, ' ')) > 0
						SET @P_MOTIVOREQUERJUSTIFICATIVA = @P_MOTIVOREQUERJUSTIFICATIVA + SUBSTRING(@VDB_PRM_JUST_LIBTOT, @V_AUX, 1);
				  END
              END
		  END
		  IF CHARINDEX('D', @VDB_PRM_JUST_LIBTOT) > 0 AND CHARINDEX('D', @V_LIBMOTS) > 0
		  BEGIN
			IF CHARINDEX('D', @P_MOTIVOREQUERJUSTIFICATIVA) = 0
				SET @P_MOTIVOREQUERJUSTIFICATIVA = ISNULL(@P_MOTIVOREQUERJUSTIFICATIVA, '') + 'D'
		  END
		  ELSE
		  BEGIN
				IF @V_DB_ALCP_DCTOMAXJUSTIF > 0 AND CHARINDEX('D', @V_LIBMOTS) > 0
				BEGIN
					IF @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
					BEGIN
						IF CHARINDEX('D', @P_MOTIVOREQUERJUSTIFICATIVA) = 0
							SET @P_MOTIVOREQUERJUSTIFICATIVA = ISNULL(@P_MOTIVOREQUERJUSTIFICATIVA, '') + 'D'
					END
				END
		  END
		  --ELSE -- LIBERADO PARCIAL (CIENTE - QDO POSSUI ALCADA POR VALOR E USUARIO NAO PODE LIBERAR TODO MOTIVO )
          IF ISNULL(@V_PEDAL_MOTLIBPAR, '') <> ''
		  BEGIN
		      SET @V_AUX = 0			 
              IF ISNULL(@VDB_PRM_JUST_LIBPAR, '') <> ''
			  BEGIN
			      WHILE @V_AUX < LEN(@V_MOTIVOS)
				  BEGIN
                        SET @V_AUX = @V_AUX + 1;
						IF CHARINDEX(SUBSTRING(@V_MOTIVOS, @V_AUX, 1), ISNULL(@VDB_PRM_JUST_LIBPAR, ' ')) > 0   BEGIN
							SET @V_AUX2 = 0
							WHILE @V_AUX2 <  LEN(@V_PERMI) 
							BEGIN
							   SET @V_AUX2 = @V_AUX2 + 1 
								IF CHARINDEX(SUBSTRING(@V_PERMI, @V_AUX2, 1), ISNULL(@VDB_PRM_JUST_LIBPAR, ' ')) > 0 AND SUBSTRING(@V_PERMI, @V_AUX2, 1) = SUBSTRING(@V_MOTIVOS, @V_AUX, 1)
									SET @P_MOTIVOREQUERJUSTIFICATIVA = @P_MOTIVOREQUERJUSTIFICATIVA +    
										   SUBSTRING(@VDB_PRM_JUST_LIBPAR,     CHARINDEX(SUBSTRING(@V_PERMI, @V_AUX2, 1), ISNULL(@VDB_PRM_JUST_LIBPAR, ' '))  , 1);
							END
						END
                  END				 
              END
		  END		
			IF CHARINDEX('D', @VDB_PRM_JUST_LIBPAR) > 0 AND CHARINDEX(@V_PERMI, 'D') > 0 AND CHARINDEX('D', @V_MOTIVOS) > 0
			BEGIN
			IF CHARINDEX('D', @P_MOTIVOREQUERJUSTIFICATIVA) = 0
				SET @P_MOTIVOREQUERJUSTIFICATIVA = ISNULL(@P_MOTIVOREQUERJUSTIFICATIVA, '') + 'D'
			END
			ELSE
			BEGIN
			  IF @V_DB_ALCP_DCTOMAXJUSTIF > 0 AND CHARINDEX('D', @V_MOTIVOS) > 0 AND CHARINDEX('D', @V_PERMI) > 0
			  BEGIN
				IF @V_EXIGE_JUSTIFICATIVA_MOT_D = 1
				BEGIN
					IF CHARINDEX('D', @P_MOTIVOREQUERJUSTIFICATIVA) = 0					
						SET @P_MOTIVOREQUERJUSTIFICATIVA = ISNULL(@P_MOTIVOREQUERJUSTIFICATIVA, '') + 'D'					
				END
			END
		END		
--- AQUI
--PRINT '-----------------------------------'
--PRINT '222@@V_LIBMOTS ' + @V_LIBMOTS
--PRINT '222@V_MOTIVOS ' + @V_MOTIVOS
--PRINT '222@VDB_PRM_JUST_LIBPAR ' + @VDB_PRM_JUST_LIBPAR
--PRINT '222@V_PERMI ' + @V_PERMI
--PRINT '222@_PED_LIB_MOTS ' + @V_PED_LIB_MOTS
--PRINT '222@V_MOTNLIBERADO ' + @V_MOTNLIBERADO
--PRINT 'REQUER'
--PRINT '@P_MOTIVOREQUERJUSTIFICATIVA ' + @P_MOTIVOREQUERJUSTIFICATIVA
--PRINT '@P_CODIGOJUSTIFICATIVA ' + @P_CODIGOJUSTIFICATIVA
--PRINT '@V_PEDAL_MOTLIBPAR ' + @V_PEDAL_MOTLIBPAR
--PRINT '-----------------------------------'
          SET @V_PODE_LIBERAR = 0
		  IF  ISNULL(@P_MOTIVOREQUERJUSTIFICATIVA, '') = ''
		  BEGIN
              SET @V_PODE_LIBERAR = 1
			  SET @P_CODIGOJUSTIFICATIVA = NULL;
              SET @P_OBSERVACAOJUSTIFICATIVA = NULL;
		  END
          ELSE IF ISNULL(@P_MOTIVOREQUERJUSTIFICATIVA, '') <> '' AND  ISNULL(@P_CODIGOJUSTIFICATIVA, '') <> ''
              SET @V_PODE_LIBERAR = 1
          --- FIM DO TESTE QUE AVALIA SE OS MOTIVOS DE LIBERACAO EXIGEM JUSTIFICATIVA 
--PRINT 'P4 @V_PODE_LIBERAR ' + CONVERT(VARCHAR, @V_PODE_LIBERAR)
          --- SE O MOTIVO REQUER JUSTIFICATIVA MAS NAO RECEBEU A JUSTIFICATIVA POR PARAMETRO NAO DEVE LIBERAR O PEDIDO, DEVE APENAS DEVOLVER OS MOTIVOS QUE EXIGEM JUSTIFICATIVA POR PARAMETRO           
          IF @V_PODE_LIBERAR = 1 
		  BEGIN
			   IF @P_EXCLUI = 0
			   BEGIN
				  UPDATE DB_PEDIDO
					 SET DB_PED_LIB_MOTS = @V_PED_LIB_MOTS --@V_BLOQUEIOS
					   , DB_PED_LIB_USUS = @V_USUS
					   , DB_PED_LIB_DATAS = @V_DATAS
					   , DB_PED_DATA_ALTER = GETDATE()
					   , DB_PED_SITUACAO = @V_UPDATE_SITUACAO
				   WHERE DB_PED_NRO = @P_NRO;  
				  UPDATE DB_PEDIDO_COMPL
					 SET DB_PEDC_AVALIADO   = 0
					   , DB_PEDC_DEV_PEDREP = 0 
					   , DB_PEDC_LIB_HORAS  = @V_HORAS
					   , DB_PEDC_DTULTLIB   = GETDATE() --@V_UPDATE_DTULTLIBERACAO
				   WHERE DB_PEDC_NRO  = @P_NRO;
			   END			   
				--- SE FOI LIBERADO TOTAL DEVE ATUALIZAR O REGISTRO NA DB_PEDIDO_ALCADA COM USUARIO E MOTIVOS
				IF (@V_LIBTOT = 0 AND @V_LIBPARC = 1)
				BEGIN
					UPDATE DB_PEDIDO_ALCADA
						SET DB_PEDAL_USULIB  = @V_CODIGO_USUARIO --P_USUARIO
						, DB_PEDAL_MOTLIB  = @V_LIBMOTS --V_BLOQUEIOS
						, DB_PEDAL_DATALIB = GETDATE()
						, DB_PEDAL_ACAO    = @P_ACAO
						, DB_PEDAL_STATUS  = 1  
                        , DB_PEDAL_JUSTIF  = @P_CODIGOJUSTIFICATIVA
                        , DB_PEDAL_JUSTOBS = @P_OBSERVACAOJUSTIFICATIVA
                        , DB_PEDAL_JREPRES = @P_REPRESJUSTIFICATIVA
						, DB_PEDAL_MOTLIBPAR = @V_PEDAL_MOTLIBPAR
						, DB_PEDAL_ITEMLIB   = @V_PEDAL_ITEMLIB_D_ATUAL
					WHERE DB_PEDAL_PEDIDO =  @P_NRO
						AND DB_PEDAL_SEQ    =  @V_PEDAL_SEQ;
				IF @VLIB_GRAVAMSGPEDIDO = 1
				BEGIN				
					INSERT INTO DB_MENSAGEM(DB_MSG_REPRES,
											DB_MSG_SEQUENCIA,
											DB_MSG_DATA,
											DB_MSG_USU_ENVIO,
											DB_MSG_USU_RECEB,
											DB_MSG_MOTIVO,
											DB_MSG_PEDIDO,
											DB_MSG_CLIENTE,
											DB_MSG_TIPO,
											DB_MSG_TEXTO,
											DB_MSG_VISTO,
											DB_MSG_ALCADA 
) 
									VALUES(
											@V_PED_REPRES,
											(SELECT ISNULL(MAX(DB_MSG_SEQUENCIA), 0) + 1 FROM DB_MENSAGEM  WHERE DB_MSG_REPRES = @V_PED_REPRES),
											GETDATE(),
											@P_USUARIO,
											'',
											0,
											@P_NRO,
											0,
											0,
											'Pedido liberado. Alçada ' + @V_ALCADA_ATUAL + '. Motivo ' +  @V_LIBMOTS  + isnull(@V_PEDAL_MOTLIBPAR, '') + '.',
											0,
											@V_ALCADA_ATUAL
										)
				END
				---QUANDO LIBERA TOTAL, DEVE DELETE OS REGISTROS COM STATUS 9, QUE SAO OS PRIORITARIOS E 0 PARA MANTER COMPATIBILIDADE COM CONSULTAS DE LIBERACAO          
				IF @V_PERMITE_LIBERA_PRIORITARIA = 1 
				BEGIN
					DELETE DB_PEDIDO_ALCADA
					 WHERE DB_PEDAL_PEDIDO = @P_NRO
					   AND DB_PEDAL_STATUS in (0,9);
				END
				IF ISNULL(@P_OBSERVACAOJUSTIFICATIVA, '') = ''
                    SET @V_DESCRICAO = @V_PROGRAMA + ' Liberou pedido total. Pedido nro: ' + CAST(@P_NRO AS VARCHAR);
                ELSE
				BEGIN
                    SET @V_DESCRICAO = @V_PROGRAMA + ' Liberou pedido total com justificativa. Pedido nro: ' + CAST(@P_NRO AS VARCHAR);
					IF @VLIB_GRAVAJUSTIFICATIVAPED = 1
					BEGIN
							SET @V_TEMP_MOT_LIB_TOT = ''
							IF ISNULL(@V_LIBMOTS, '') <> ''
								SET @V_TEMP_MOT_LIB_TOT = @V_LIBMOTS
							ELSE
								SET @V_TEMP_MOT_LIB_TOT = @V_PEDAL_MOTLIBPAR
							INSERT INTO DB_MENSAGEM (DB_MSG_TEXTO,
													 DB_MSG_REPRES,
													 DB_MSG_SEQUENCIA,
													 DB_MSG_DATA,
													 DB_MSG_USU_ENVIO,
													 DB_MSG_MOTIVO,
					 								 DB_MSG_PEDIDO,
													 DB_MSG_TIPO) 
										     VALUES(
													'Motivo ' + ISNULL(@V_TEMP_MOT_LIB_TOT, '') + ': ' + isnull(@P_OBSERVACAOJUSTIFICATIVA, ''),
													@V_PED_REPRES,
													(SELECT ISNULL(MAX(DB_MSG_SEQUENCIA), 0) + 1 FROM DB_MENSAGEM  WHERE DB_MSG_REPRES = @V_PED_REPRES),
													GETDATE(),
													@P_USUARIO,
													1,
													@P_NRO,
													5
													)
					END
				END
                SET @V_ENV_WORKFLOW = 19;
				--- BUSCA STATUS DA ALÇADA
					SET @V_STATUS_PED = 0;
					   SELECT @V_STATUS_PED = DB_ALCP_STATUS_LT
						 FROM DB_ALCADA_PED, DB_STATUS
						WHERE DB_ALCP_CODIGO = (SELECT DB_PEDAL_ALCADA FROM DB_PEDIDO_ALCADA  WHERE DB_PEDAL_PEDIDO = @P_NRO AND DB_PEDAL_SEQ = @V_PEDAL_SEQ )
						  AND DB_ALCP_STATUS_LT = DB_STATUS.CODIGO
						  AND GETDATE() BETWEEN DATA_INICIAL AND DATA_FINAL;				
					--- SOMENTE ATUALIZA SE O STATUS FOR DIFERENTE DE NULL E ZERO            
					IF @V_STATUS_PED <> 0 AND ISNULL(@V_STATUS_PED, '') <> ''
					BEGIN
					   --- SE HOUVER ALTERAÇÃO DE STATUS, DEVE GRAVAR UMA MENSAGEM
						IF @V_STATUS_PED <> @V_STATUS_PED_ATUAL
						BEGIN
						   INSERT INTO DB_MENSAGEM (
													DB_MSG_REPRES,
													DB_MSG_SEQUENCIA,
													DB_MSG_DATA,
													DB_MSG_USU_ENVIO,
													DB_MSG_PEDIDO,
													DB_MSG_TEXTO)
											VALUES (
													@V_PED_REPRES,
													ISNULL((SELECT MAX(DB_MSG_SEQUENCIA) FROM DB_MENSAGEM WHERE DB_MSG_REPRES = @V_PED_REPRES), 0) + 1, 
													GETDATE(),
													@P_USUARIO,
													@P_NRO,
													'Liberação de pedido: novo status do pedido: ' +
													ISNULL((SELECT DESCRICAO FROM DB_STATUS WHERE CODIGO = @V_STATUS_PED), '[SEM STATUS]') +
													'. Status anterior: '  +
													ISNULL((SELECT DESCRICAO FROM DB_STATUS WHERE CODIGO = @V_STATUS_PED_ATUAL), '[SEM STATUS]')
													);                                            
						END  
						 ---ATUALIZA O STATUS DO PEDIDO
						UPDATE DB_PEDIDO_COMPL
						   SET DB_PEDC_STATUSPED = @V_STATUS_PED
						 WHERE DB_PEDC_NRO = @P_NRO;                 
					END
					ELSE
					BEGIN
						--CASO A ALÇADA NÃO TENHA UM STATUS INFORMADO OU NÃO SEJA MAIS VÁLIDO
						--VERIFICAR SE O STATUS ATUAL DO PEDIDO AINDA É VALIDO, CASO NÃO SEJA SETAR ZERO
						IF @V_STATUS_PED_ATUAL <> 0 AND ISNULL(@V_STATUS_PED_ATUAL, '') <> ''
						BEGIN
							SET @V_STATUS_VALIDO = 0;
							SELECT @V_STATUS_VALIDO = 1
							  FROM DB_STATUS
							 WHERE DB_STATUS.CODIGO = @V_STATUS_PED_ATUAL
							   AND CAST(GETDATE() AS DATE) BETWEEN DATA_INICIAL AND DATA_FINAL;
							IF @V_STATUS_VALIDO = 0
							BEGIN
								UPDATE DB_PEDIDO_COMPL
								   SET DB_PEDC_STATUSPED = 0
								 WHERE DB_PEDC_NRO = @P_NRO;  
							END
						 END
					END
				END
				ELSE
				BEGIN
				--- QUANDO NÃO FOI LIBERADO TOTAL, DEVE ATUALIZAR COM USUARIO E CRIAR UM NOVO REGISTRO
					UPDATE DB_PEDIDO_ALCADA
						SET DB_PEDAL_USULIB  = @V_CODIGO_USUARIO  --P_USUARIO
						, DB_PEDAL_DATALIB = GETDATE()
						, DB_PEDAL_MOTLIB  = @V_LIBMOTS --V_BLOQUEIOS
						, DB_PEDAL_ACAO    = @P_ACAO
						, DB_PEDAL_STATUS  = 2
                        , DB_PEDAL_JUSTIF  = @P_CODIGOJUSTIFICATIVA
                        , DB_PEDAL_JUSTOBS = @P_OBSERVACAOJUSTIFICATIVA
                        , DB_PEDAL_JREPRES = @P_REPRESJUSTIFICATIVA
						, DB_PEDAL_MOTLIBPAR = @V_PEDAL_MOTLIBPAR
						, DB_PEDAL_ITEMLIB   = @V_PEDAL_ITEMLIB_D_ATUAL
					WHERE DB_PEDAL_PEDIDO =  @P_NRO
						AND DB_PEDAL_SEQ    =  @V_PEDAL_SEQ;		
				IF @VLIB_GRAVAMSGPEDIDO = 1
				BEGIN				
					INSERT INTO DB_MENSAGEM(DB_MSG_REPRES,
											DB_MSG_SEQUENCIA,
											DB_MSG_DATA,
											DB_MSG_USU_ENVIO,
											DB_MSG_USU_RECEB,
											DB_MSG_MOTIVO,
											DB_MSG_PEDIDO,
											DB_MSG_CLIENTE,
											DB_MSG_TIPO,
											DB_MSG_TEXTO,
											DB_MSG_VISTO,
											DB_MSG_ALCADA 
) 
									VALUES(
											@V_PED_REPRES,
											(SELECT ISNULL(MAX(DB_MSG_SEQUENCIA), 0) + 1 FROM DB_MENSAGEM  WHERE DB_MSG_REPRES = @V_PED_REPRES),
											GETDATE(),
											@P_USUARIO,
											'',
											0,
											@P_NRO,
											0,
											0,
											'Pedido liberado parcial. Alçada ' + @V_ALCADA_ATUAL + '. Motivo ' +   @V_LIBMOTS  + isnull(@V_PEDAL_MOTLIBPAR, '') + '.',
											0,
											@V_ALCADA_ATUAL
										)
				END
			IF ISNULL(@P_OBSERVACAOJUSTIFICATIVA, '') = ''			
                SET @V_DESCRICAO = @V_PROGRAMA + ' Liberou pedido parcial. Pedido nro: ' + CAST(@P_NRO AS VARCHAR)			
            ELSE
			BEGIN
                SET @V_DESCRICAO = @V_PROGRAMA + ' Liberou pedido parcial com justificativa. Pedido nro: ' +  CAST(@P_NRO AS VARCHAR)
				IF @VLIB_GRAVAJUSTIFICATIVAPED = 1
				BEGIN
				   INSERT INTO DB_MENSAGEM (DB_MSG_TEXTO,
											DB_MSG_REPRES,
											DB_MSG_SEQUENCIA,
											DB_MSG_DATA,
											DB_MSG_USU_ENVIO,
											DB_MSG_MOTIVO,
					 						DB_MSG_PEDIDO,
											DB_MSG_TIPO) 
										VALUES(
											'Motivo ' + ISNULL(@V_PEDAL_MOTLIBPAR, '') + ': ' + isnull(@P_OBSERVACAOJUSTIFICATIVA, ''),
											@V_PED_REPRES,
											(SELECT ISNULL(MAX(DB_MSG_SEQUENCIA), 0) + 1 FROM DB_MENSAGEM  WHERE DB_MSG_REPRES = @V_PED_REPRES),
											GETDATE(),
											@P_USUARIO,
											1,
											@P_NRO,
											5
											)
				END
			END
		--- BUSCA O GRUPO DE ALCADA QUE O PEDIDO ESTÁ SENDO LIBERADO 
			BEGIN -- PROCEDURE 'P_SETA_ALCADA_ANTERIOR'
				SET @V_ALCP_GRPALCADA_ANTERIOR = NULL;
				SET @V_ALCP_CODIGO_ANTERIOR = NULL;
				SET @V_ALCP_GRPLIB_ANTERIOR = NULL;
				SET @V_ALCP_NIVLIB_ANTERIOR = NULL;
				--SETA ALÇADA ANTERIOR PEGANDO O ÚLTIMO REGISTRO DE LIBERAÇÃO
				SELECT  @V_ALCP_GRPALCADA_ANTERIOR = DB_ALCP_GRPALCADA,
						@V_ALCP_CODIGO_ANTERIOR = DB_ALCP_CODIGO,
						@V_ALCP_GRPLIB_ANTERIOR = DB_ALCP_GRUPOLIB,
						@V_ALCP_NIVLIB_ANTERIOR = DB_ALCP_NIVELLIB
				FROM DB_ALCADA_PED A, DB_PEDIDO_ALCADA B
				WHERE DB_ALCP_CODIGO = DB_PEDAL_ALCADA
					  AND DB_PEDAL_PEDIDO = @P_NRO
					  AND DB_PEDAL_SEQ = (SELECT MAX(DB_PEDAL_SEQ) FROM DB_PEDIDO_ALCADA WHERE DB_PEDAL_PEDIDO = @P_NRO)
			END
			  SET @V_PASSO = '30';
				-- V_ALCP_CODIGO  := F_RETORNA_ALCADA (V_MOTNLIBERADO);  AQUI A FUNÇÃO
			--PRINT  '@V_MOTIVOS ' + @V_MOTIVOS
			--PRINT  '@V_MOTNLIBERADO ' + @V_MOTNLIBERADO
			--PRINT  '@V_LIBMOTS ' + @V_LIBMOTS
			 SET @V_GRUPO_ALCADA = null;
			 SET @V_GRUPO_LIBERACAO = NULL;
			 IF @V_PERMITE_LIBERA_PRIORITARIA = 1 
			 BEGIN
				IF @V_ALCADA_E_PRIORITARIA = 1 
				BEGIN
					DELETE FROM DB_PEDIDO_ALCADA
					WHERE DB_PEDAL_PEDIDO = @P_NRO
					  AND DB_PEDAL_STATUS = 0;
					DELETE FROM DB_PEDIDO_ALCADA
					 WHERE DB_PEDAL_PEDIDO = @P_NRO
					   AND DB_PEDAL_STATUS = 9
					   AND DB_PEDAL_ALCADA <> @V_ALCADA_ATUAL;                  
					SELECT @V_PEDAL_SEQ = MAX(DB_PEDAL_SEQ)
					  FROM DB_PEDIDO_ALCADA
					 WHERE DB_PEDAL_PEDIDO = @P_NRO;
                END           
				ELSE
				BEGIN
				   DELETE FROM DB_PEDIDO_ALCADA
					WHERE DB_PEDAL_PEDIDO = @P_NRO
					  AND DB_PEDAL_STATUS = 9;
				END
			  END				 
				BEGIN
					DECLARE C	CURSOR
					FOR SELECT DB_ALCP_CODIGO, DB_ALCP_LIBPRIORITARIA, DB_ALCP_GRUPOLIB, DB_ALCP_GRPALCADA
						  FROM DB_ALCADA_PED
						 WHERE DB_ALCP_CODIGO IN (
									SELECT DB_ALCP_CODIGO
									  FROM DB_ALCADA_PED
									 WHERE DBO.MERCF_VALIDA_LISTA(@V_CLI_RAMATIV,	 DB_ALCP_LSTRAMO,   0, ',') > 0
									   AND DBO.MERCF_VALIDA_LISTA(@V_PED_EMPRESA,	 DB_ALCP_LSTEMP,    0, ',') > 0
									   AND DBO.MERCF_VALIDA_LISTA(@V_PED_TIPO,		 DB_ALCP_LSTTIPO,   0, ',') > 0
									   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_CLASCOM,	 DB_ALCP_LSTCLASS,  0, ',') > 0
									   AND DBO.MERCF_VALIDA_LISTA(@V_PED_SITCORP,	 DB_ALCP_LSTSITCORP,0, ',') > 0
									   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_REGIAOCOM,  DB_ALCP_LSTREGCOM, 0, ',') > 0
									   AND DBO.MERCF_VALIDA_LISTA(@V_PED_OPERACAO,	 DB_ALCP_LSTOPER,   0, ',') > 0
									   AND DBO.MERCF_VALIDA_LISTA(@V_STATUS_PED_ATUAL, DB_ALCP_LSTSTATUS,   0, ',') > 0
									   AND DBO.MERCF_VALIDA_LISTA(@V_DB_PED_LISTA_PRECO, DB_ALCP_LSTLISTAPRECO,   0, ',') > 0
									   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_AREAATU,	 DB_ALCP_LSTAREAATU,   0, ',') > 0
									   -- DB_ALCP_OPCREP = OPÇÃO REPRESENTANTE ( 0 - PERMITIR TODOS / 1 - SOMENTE ALGUNS / 2 - EXCETO ALGUNS )
									   AND CASE WHEN ISNULL(DB_ALCP_OPCREP, 0) = 0 AND 0 = 0
												THEN 1
												WHEN ISNULL(DB_ALCP_OPCREP, 0) = 1 AND DBO.MERCF_VALIDA_LISTA(@V_PED_REPRES, DB_ALCP_LSTREP, 0, ',') > 0
												THEN 1
												WHEN ISNULL(DB_ALCP_OPCREP, 0) = 2 AND DBO.MERCF_VALIDA_LISTA(@V_PED_REPRES, DB_ALCP_LSTREP, 1, ',') > 0
												THEN 1
												ELSE 0
												END = 1 
										AND ((@V_PED_REPRES IN (SELECT Z.DB_EREG_REPRES
																 FROM DB_ESTRUT_VENDA X, 
																	  DB_ESTRUT_VENDA Y, 
																	  DB_ESTRUT_REGRA Z, 
																	  DB_ESTRUT_REGRA Z1, 
																	  DB_ALCADA_ESTRUT AL
																WHERE X.DB_EVDA_ESTRUTURA  = Y.DB_EVDA_ESTRUTURA																				
																  AND Y.DB_EVDA_CODIGO     LIKE (X.DB_EVDA_CODIGO + '%')
																  AND X.DB_EVDA_ESTRUTURA  = Z.DB_EREG_ESTRUTURA
																  AND Y.DB_EVDA_ID         = Z.DB_EREG_ID
																  AND X.DB_EVDA_ESTRUTURA  = Z1.DB_EREG_ESTRUTURA
																  AND X.DB_EVDA_ID         = Z1.DB_EREG_ID
																  --AND Z.DB_EREG_SEQ        = 1
																  AND AL.DB_ALCE_ESTRUTURA = Z1.DB_EREG_ESTRUTURA
																  AND DB_ALCP_CODIGO       = AL.DB_ALCE_ALCADA
																  AND AL.DB_ALCE_ID        =  Z1.DB_EREG_ID ) )    OR ((SELECT TOP(1) DB_ALCE_ALCADA
																												  FROM DB_ALCADA_ESTRUT
																												 WHERE DB_ALCP_CODIGO = DB_ALCE_ALCADA) IS NULL))
/*											-- VALIDA A LISTA DE TIPOS DE PRODUTOS
											AND (EXISTS (SELECT 1
														   FROM DB_PEDIDO_PROD, DB_PRODUTO
														  WHERE DB_PEDI_PEDIDO = @P_NRO
															AND DB_PROD_CODIGO = DB_PEDI_PRODUTO
															AND DBO.MERCF_VALIDA_LISTA(DB_PROD_TPPROD, DB_ALCP_LSTTPPROD, 0, ',') > 0)
														OR DB_ALCP_LSTTPPROD IS NULL)*/
											-- VALIDA A LISTA DE TIPOS DE PRODUTOS
											AND (EXISTS (SELECT 1
														   FROM DB_PEDIDO, DB_PEDIDO_PROD, DB_PRODUTO
														  WHERE DB_PEDI_PEDIDO     = @P_NRO
															AND DB_PEDI_PEDIDO     = DB_PED_NRO
															AND DB_PROD_CODIGO     = DB_PEDI_PRODUTO
															AND ( ((DB_PED_MOTIVO_BLOQ LIKE '%D%' AND (NOT DB_ALCP_MOTBLOQ LIKE '%D%' OR (DB_ALCP_MOTBLOQ LIKE '%D%' AND DB_PEDI_ECON_VLR < 0)))
															     OR DB_PED_MOTIVO_BLOQ NOT LIKE '%D%')
															   OR ((DB_PED_MOTIVO_BLOQ LIKE '%F%' AND (NOT DB_ALCP_MOTBLOQ LIKE '%F%' OR (DB_ALCP_MOTBLOQ LIKE '%F%' AND (DB_PEDI_TIPO = 'B' OR DB_PED_FATUR = 2))))
															     OR DB_PED_MOTIVO_BLOQ NOT LIKE '%F%')
																 )
															AND DB_ALCP_LSTTPPROD LIKE '%' + DB_PROD_TPPROD + '%')
														OR ISNULL(DB_ALCP_LSTTPPROD,'') = '')
											AND (EXISTS (SELECT 1
													FROM DB_PEDIDO, DB_PEDIDO_PROD, DB_PRODUTO, DB_TB_REPRES
													WHERE DB_PEDI_PEDIDO     = @P_NRO
													AND DB_PEDI_PEDIDO     = DB_PED_NRO
													AND DB_PROD_CODIGO     = DB_PEDI_PRODUTO
													AND DB_PED_REPRES = DB_TBREP_CODIGO
													AND DB_PED_MOTIVO_BLOQ LIKE '%D%' 
													AND @V_MOTNLIBERADO LIKE '%D%'
													AND DB_ALCP_REGRAEXCDESCONTO > 0
													AND DB_ALCP_ITEMSEMDESC = 1
													and DB_ALCP_AVALIADESCONTO = 1
													AND EXISTS (SELECT 1 FROM DB_PEDIDO_DESCONTO WHERE DB_PEDD_NRO = DB_PED_NRO AND DB_PEDD_SEQIT = DB_PEDI_SEQUENCIA and DB_PEDD_DESCONTO > 0)		
													and DB_PEDI_ECON_VLR < 0
													AND DB_PEDI_TIPO NOT IN ('B', 'T')
													AND ( NOT EXISTS (SELECT 1 FROM DB_PEDIDO_ALCADA WHERE DB_PEDAL_PEDIDO = @P_NRO AND ',' + DB_PEDAL_ITEMLIB LIKE  '%,' + CAST(DB_PEDI_SEQUENCIA AS VARCHAR) + ',%'))
													AND EXISTS(
																SELECT TOP 1 1										 
																	FROM DB_REGRASDESCLIBERACAO CAPA
																		, DB_REGRASDESCLIB_PRODUTOS PROD
																	WHERE CAPA.CODIGO = PROD.CODIGO
																		AND CAPA.CODIGO = DB_ALCP_REGRAEXCDESCONTO
																		AND CAST(GETDATE() AS DATE) BETWEEN CAST(CAPA.DATA_INICIAL AS DATE)  AND CAST(CAPA.DATA_FINAL AS DATE)
																	   AND CAST(GETDATE() AS DATE) BETWEEN CAST(ISNULL(PROD.DTVAL_INICIAL, CAPA.DATA_INICIAL) AS DATE)  AND CAST(ISNULL(PROD.DTVAL_FINAL, CAPA.DATA_FINAL) AS DATE)
																		AND DBO.MERCF_VALIDA_LISTA(DB_PROD_CODIGO, PRODUTO, 0, ',') = 1   
																		AND DBO.MERCF_VALIDA_LISTA(DB_PROD_TPPROD, TIPO, 0, ',') = 1
																		AND DBO.MERCF_VALIDA_LISTA(DB_PROD_MARCA, MARCA, 0, ',') = 1
																		AND DBO.MERCF_VALIDA_LISTA(DB_PROD_FAMILIA , FAMILIA, 0, ',') = 1
																		AND DBO.MERCF_VALIDA_LISTA(DB_PROD_GRUPO , GRUPO, 0, ',') = 1		
																		AND (PROD.UNIDFV  IS NULL OR PROD.UNIDFV = ''  OR  PROD.UNIDFV = DB_TBREP_UNIDFV)     
																		AND (ISNULL(PROD.CLIENTE, 0) = 0 OR PROD.CLIENTE = DB_PED_CLIENTE) )
														)
														OR (isnull(DB_ALCP_ITEMSEMDESC, 0) = 0 or DB_ALCP_AVALIADESCONTO <> 1 OR @V_MOTNLIBERADO NOT LIKE '%D%')													
													)
										    AND (EXISTS(
												SELECT DOCUMENTO
												  FROM DB_PEDIDO_DOC_BLOQ
												 WHERE PEDIDO = @P_NRO
												   AND ISNULL(DATA_LIBERACAO, '') = ''
												   AND (ISNULL(DB_ALCP_LSTTIPODOC , '') LIKE  CAST(CAST(DOCUMENTO  AS VARCHAR) AS VARCHAR) + ',%' OR  ISNULL(DB_ALCP_LSTTIPODOC , '') LIKE '%,' + CAST(CAST(DOCUMENTO  AS VARCHAR) AS VARCHAR) + ',%' OR  ISNULL(DB_ALCP_LSTTIPODOC , '') LIKE  '%,' + CAST(CAST(DOCUMENTO  AS VARCHAR) AS VARCHAR) 
														OR ISNULL(DB_ALCP_LSTTIPODOC , '') = CAST(CAST(DOCUMENTO  AS VARCHAR) AS VARCHAR) OR ISNULL(ISNULL(DB_ALCP_LSTTIPODOC , ''), '') = ''))  
														OR ISNULL(DB_ALCP_LSTTIPODOC, '')  = '' 
														OR (SELECT TOP 1 1 FROM DB_PEDIDO_DOC_BLOQ WHERE PEDIDO = @P_NRO AND ISNULL(DATA_LIBERACAO, '') = '') IS NULL)
												AND (CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,1,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,2,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,3,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,4,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,5,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,6,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,7,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,8,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,9,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,10,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,11,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,12,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,13,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,14,1), DB_ALCP_MOTBLOQ) > 0
												 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADO,15,1), DB_ALCP_MOTBLOQ) > 0)
						 AND ( DB_ALCP_GRPALCADA = @V_ALCP_GRPALCADA_ANTERIOR OR ISNULL(@V_ALCP_GRPALCADA_ANTERIOR, '') = '') ---- SE JA FOI LIBERADO POR ALGUEM DEVE SEGUIR NA MESMA ALCADA
						 AND (((DB_ALCP_GRUPOLIB = @V_ALCP_GRPLIB_ANTERIOR AND DB_ALCP_NIVELLIB > @V_ALCP_NIVLIB_ANTERIOR)
                              OR (DB_ALCP_GRUPOLIB > @V_ALCP_GRPLIB_ANTERIOR)) 
                              OR ISNULL(@V_ALCP_CODIGO_ANTERIOR, '') = '')
										AND DB_ALCP_CODIGO NOT IN ( SELECT DB_ALCP_CODIGO   --- NAO DEVE SER IGUALAO ULTIMO NIVEL LIBERADEO
																	  FROM DB_ALCADA_PED A, DB_PEDIDO_ALCADA B
																	  WHERE DB_ALCP_CODIGO = DB_PEDAL_ALCADA
																		AND DB_PEDAL_PEDIDO = @P_NRO)
													AND DB_ALCP_TIPO = 0
												)
										ORDER BY DB_ALCP_GRPALCADA, DB_ALCP_GRUPOLIB, DB_ALCP_NIVELLIB
--PRINT '@V_CLI_RAMATIV '     +  ISNULL(@V_CLI_RAMATIV, 'NULO')
--PRINT '@V_PED_EMPRESA '		+  ISNULL(@V_PED_EMPRESA, 'NULO')
--PRINT '@V_PED_TIPO '		+  ISNULL(@V_PED_TIPO, 'NULO')
--PRINT '@V_CLI_CLASCOM '		+  ISNULL(@V_CLI_CLASCOM, 'NULO')
--PRINT '@V_PED_SITCORP '		+  ISNULL(@V_PED_SITCORP, 'NULO')
--PRINT '@V_CLI_REGIAOCOM '	+  ISNULL(@V_CLI_REGIAOCOM, 'NULO')
--PRINT '@V_PED_OPERACAO '	+  ISNULL(@V_PED_OPERACAO, 'NULO')
--PRINT '@V_PED_REPRES '		+  ISNULL(@V_PED_REPRES, 'NULO')
--PRINT '@V_MOTNLIBERADO '	+  ISNULL(@V_MOTNLIBERADO, 'NULO')
--PRINT '@V_ALCP_GRPALCADA_ANTERIOR ' +  ISNULL(@V_ALCP_GRPALCADA_ANTERIOR , 'NULO')
--PRINT 'ALCADA = ' + @V_ALCP_CODIGO_TEMP
						  OPEN C
						  FETCH NEXT FROM C
						  INTO @V_ALCP_CODIGO_TEMP, @VDB_ALCP_LIBPRIORITARIA, @VDB_ALCP_GRUPOLIB, @VDB_ALCP_GRPALCADA
						  WHILE @@FETCH_STATUS = 0
						  BEGIN
							IF @V_ALCP_CODIGO IS NULL
							BEGIN
								SET @V_ALCP_CODIGO = @V_ALCP_CODIGO_TEMP;
								SET @V_GRUPO_ALCADA = @VDB_ALCP_GRPALCADA;
								SET @V_GRUPO_LIBERACAO = @VDB_ALCP_GRUPOLIB;
							END
							ELSE
							BEGIN
								 --- AQUI DEVE VALIDAR AS ALÇADAS QUE SÃO PRIORITARIASPARA O MESNMO GRUPO DE ALCADA E LIBERACAO
								IF @V_PERMITE_LIBERA_PRIORITARIA = 1
								BEGIN
									IF @VDB_ALCP_LIBPRIORITARIA = 1 AND @V_GRUPO_ALCADA = @VDB_ALCP_GRPALCADA AND @V_GRUPO_LIBERACAO = @VDB_ALCP_GRUPOLIB
									BEGIN
										IF ISNULL(@V_ALCADAS_PRIORITARIAS, '') = '' OR LEN(@V_ALCADAS_PRIORITARIAS) = 0 
											SET @V_ALCADAS_PRIORITARIAS = @V_ALCP_CODIGO_TEMP + ';'
										ELSE
											SET @V_ALCADAS_PRIORITARIAS = @V_ALCADAS_PRIORITARIAS + @V_ALCP_CODIGO_TEMP + ';'
									END
								END
							END
						  FETCH NEXT FROM C
						  INTO @V_ALCP_CODIGO_TEMP, @VDB_ALCP_LIBPRIORITARIA, @VDB_ALCP_GRUPOLIB, @VDB_ALCP_GRPALCADA
						  END						  
				END
						  CLOSE C
						  DEALLOCATE C
				 --- SE ENCONTROU PROXIMA ALCADA DEVE INSERIR REGISTRO NA DB_PEDIDO_ALCADA, DO CONTRARIO DEVE LIBERAR O PEDIDO, POIS SIGNIFICA QUE NÃO TEM MAIS ALCADA CONFIGURADA 
				 IF ISNULL(@V_ALCP_CODIGO, '') <> ''
				 BEGIN
				    SET @V_EXISTE_ALCADA = 0;
					IF @V_PERMITE_LIBERA_PRIORITARIA = 1 AND LEN(@V_ALCADAS_PRIORITARIAS) > 0
					BEGIN
						SET @V_COUNT_ALCADA = 1;
						WHILE @V_COUNT_ALCADA <= (LEN(@V_ALCADAS_PRIORITARIAS) - LEN(REPLACE(@V_ALCADAS_PRIORITARIAS, ';', '')))
						BEGIN
							SET @V_ALCADA_TEMP_PRI = DBO.MERCF_PIECE(@V_ALCADAS_PRIORITARIAS, ';', @V_COUNT_ALCADA);
							-- verifica se ja existe registro para o pedido nas alçadas encontradas						
							SELECT @V_EXISTE_ALCADA = 1
							  FROM DB_PEDIDO_ALCADA
							 WHERE DB_PEDAL_PEDIDO = @P_NRO
							   AND DB_PEDAL_ALCADA = @V_ALCADA_TEMP_PRI;						
							--- SE NAO EXISTE INSERE UM REGISTRO PARA A ALCADA PRIORITARIA
							IF @V_EXISTE_ALCADA = 0
							BEGIN
								SET @V_PEDAL_SEQ = ISNULL(@V_PEDAL_SEQ, 0) + 1;
								INSERT INTO DB_PEDIDO_ALCADA(DB_PEDAL_PEDIDO, DB_PEDAL_SEQ, DB_PEDAL_ALCADA, DB_PEDAL_STATUS)
									VALUES (
									@P_NRO, 
									@V_PEDAL_SEQ, 
									@V_ALCADA_TEMP_PRI,
									9);	
							END
							SET @V_COUNT_ALCADA = @V_COUNT_ALCADA + 1;
						END
						---SEMPRE DEVE VALIDAR SE EXISTE JA UMA ALCADA INSERIDA, PQ PODE SER QUE UMA PRIORIRTARIA DE MESMO CODIGO JA ESTEJA NA TABELA						
						SELECT @V_EXISTE_ALCADA = 1
						  FROM DB_PEDIDO_ALCADA
						 WHERE DB_PEDAL_PEDIDO = @P_NRO
						   AND DB_PEDAL_ALCADA = @V_ALCP_CODIGO;
					END
					IF @V_EXISTE_ALCADA = 0 
					BEGIN
						INSERT INTO DB_PEDIDO_ALCADA(DB_PEDAL_PEDIDO, DB_PEDAL_SEQ, DB_PEDAL_ALCADA, DB_PEDAL_STATUS)
						VALUES
						(@P_NRO, CONVERT(NUMERIC(30),ISNULL(@V_PEDAL_SEQ, 0) + 1), @V_ALCP_CODIGO, 0);					
					END
					---- CRIA NOTIFICACAOPARA ENVIAR PARA USUARIOS DA ALCADA
					SET @V_CODIGO_NOTIFICACAO = 0
					SET @V_USUARIO_SERVICO = 0
					DECLARE C_USUARIO_ALCADA CURSOR
					FOR SELECT USU.CODIGO
							FROM DB_PERM_NOTIFICACAO_SISTEMA NOTI, DB_ALCADA_USUARIO ALCADA, DB_USUARIO USU
						WHERE NOTIFICACAO = 3
						AND ((ALCADA.DB_ALCU_ALCADA = @V_ALCP_CODIGO) OR (LEN(@V_ALCADAS_PRIORITARIAS) > 0 AND ';' + @V_ALCADAS_PRIORITARIAS + ';' LIKE '%;' + ALCADA.DB_ALCU_ALCADA + ';%'))
						AND ALCADA.DB_ALCU_USUARIO = USU.CODIGO
						AND ((ISNULL(NOTI.USUARIO, '') = '' AND NOTI.GRUPO_USUARIO = USU.GRUPO_USUARIO) OR NOTI.USUARIO = USU.USUARIO)
					OPEN C_USUARIO_ALCADA
					FETCH NEXT FROM C_USUARIO_ALCADA
					INTO @V_USUARIO_NOTI	
					WHILE @@FETCH_STATUS = 0
					BEGIN
						IF @V_CODIGO_NOTIFICACAO = 0
						BEGIN
							SELECT @V_CODIGO_NOTIFICACAO = ISNULL(MAX(CODIGO), 0) FROM DB_NOTIFICACAO
							SELECT TOP 1 @V_USUARIO_SERVICO = CODIGO FROM DB_USUARIO WHERE TIPO_ACESSO = 3	  
						END
						SET @V_CODIGO_NOTIFICACAO = @V_CODIGO_NOTIFICACAO + 1
						INSERT INTO DB_NOTIFICACAO 
							(CODIGO, USUARIO_ENVIO, USUARIO_DESTINATARIO, MENSAGEM, DATA_ENVIO, TIPO_NOTIFICACAO)
						VALUES
							(@V_CODIGO_NOTIFICACAO,
								@V_USUARIO_SERVICO,
								@V_USUARIO_NOTI,
								'O pedido ' + CAST(@P_NRO AS VARCHAR) + ' do cliente ' + @V_DB_CLI_NOME + ' está aguardando a sua liberação.',
								null,
								3)
					FETCH NEXT FROM C_USUARIO_ALCADA
					INTO @V_USUARIO_NOTI
					END
					CLOSE C_USUARIO_ALCADA
					DEALLOCATE C_USUARIO_ALCADA
					--IF ISNULL(@P_USUARIO, '') <> ''
						SET @V_ENV_WORKFLOW = 18;
					--- BUSCA STATUS DA ALÇADA
					SET @V_STATUS_PED = 0;
						SELECT @V_STATUS_PED = DB_ALCP_STATUS_ALCADA
							FROM DB_ALCADA_PED, DB_STATUS
						WHERE DB_ALCP_CODIGO = @V_ALCP_CODIGO
							AND DB_ALCP_STATUS_ALCADA = DB_STATUS.CODIGO
							AND GETDATE() BETWEEN DATA_INICIAL AND DATA_FINAL;				
					--- SOMENTE ATUALIZA SE O STATUS FOR DIFERENTE DE NULL E ZERO            
					IF @V_STATUS_PED <> 0 AND ISNULL(@V_STATUS_PED, '') <> ''
					BEGIN
						--- SE HOUVER ALTERAÇÃO DE STATUS, DEVE GRAVAR UMA MENSAGEM
						IF @V_STATUS_PED <> @V_STATUS_PED_ATUAL
						BEGIN
							INSERT INTO DB_MENSAGEM (
													DB_MSG_REPRES,
													DB_MSG_SEQUENCIA,
													DB_MSG_DATA,
													DB_MSG_USU_ENVIO,
													DB_MSG_PEDIDO,
													DB_MSG_TEXTO)
											VALUES (
													@V_PED_REPRES,
													ISNULL((SELECT MAX(DB_MSG_SEQUENCIA) FROM DB_MENSAGEM WHERE DB_MSG_REPRES = @V_PED_REPRES), 0) + 1, 
													GETDATE(),
													@P_USUARIO,
													@P_NRO,
													'Liberação de pedido: novo status do pedido: ' +
													ISNULL((SELECT DESCRICAO FROM DB_STATUS WHERE CODIGO = @V_STATUS_PED), '[SEM STATUS]') +
													'. Status anterior: '  +
													ISNULL((SELECT DESCRICAO FROM DB_STATUS WHERE CODIGO = @V_STATUS_PED_ATUAL), '[SEM STATUS]')
													);                                            
						END  
							---ATUALIZA O STATUS DO PEDIDO
						UPDATE DB_PEDIDO_COMPL
							SET DB_PEDC_STATUSPED = @V_STATUS_PED
							WHERE DB_PEDC_NRO = @P_NRO;                 
					END
					ELSE
					BEGIN
						--CASO A ALÇADA NÃO TENHA UM STATUS INFORMADO OU NÃO SEJA MAIS VÁLIDO
						--VERIFICAR SE O STATUS ATUAL DO PEDIDO AINDA É VALIDO, CASO NÃO SEJA SETAR ZERO
						IF @V_STATUS_PED_ATUAL <> 0 AND ISNULL(@V_STATUS_PED_ATUAL, '') <> ''
						BEGIN
							SET @V_STATUS_VALIDO = 0;
							SELECT @V_STATUS_VALIDO = 1
								FROM DB_STATUS
								WHERE DB_STATUS.CODIGO = @V_STATUS_PED_ATUAL
								AND CAST(GETDATE() AS DATE) BETWEEN DATA_INICIAL AND DATA_FINAL;
							IF @V_STATUS_VALIDO = 0
							BEGIN
								UPDATE DB_PEDIDO_COMPL
									SET DB_PEDC_STATUSPED = 0
									WHERE DB_PEDC_NRO = @P_NRO;  
							END
						END
					END
				END							 
				--ELSE
				--BEGIN
					--UPDATE DB_PEDIDO
					--   SET DB_PED_SITUACAO = 0
					-- WHERE DB_PED_NRO = @P_NRO;
					--UPDATE DB_PEDIDO_ALCADA
					--   SET DB_PEDAL_STATUS = 1
					-- WHERE DB_PEDAL_PEDIDO = @P_NRO
					--		AND DB_PEDAL_SEQ = @V_PEDAL_SEQ;
					--IF ISNULL(@P_OBSERVACAOJUSTIFICATIVA, '') = '' 
					--   SET @V_DESCRICAO = @V_PROGRAMA + ' LIBEROU PEDIDO PARCIAL. PEDIDO NRO: ' + CAST(@P_NRO AS VARCHAR);
					--ELSE
					--   SET @V_DESCRICAO = @V_PROGRAMA + ' LIBEROU PEDIDO PARCIAL COM JUSTIFICATIVA. PEDIDO NRO: ' + CAST(@P_NRO AS VARCHAR);
                --    SET @V_ENV_WORKFLOW = 19;
				--END-----
			  END -- FIM (@V_LIBTOT = 0 AND @V_LIBPARC = 1)
			END  ---P_USUARIO IS NOT NULL AND P_ACAO = 1
       END -- P_MOTIVOREQUERJUSTIFICATIVA
ELSE -- P_USUARIO IS NOT NULL AND P_ACAO = 1
	BEGIN
	 -- SE RECEBEU USUARIO POR PARAMETRO DEVE ENCONTRAR QUAL EH A ALCADA QUE IRÁ LIBERAR O PEDIDO 
     -- ATENCAO, SOMENTE DEVE ENTRAR NESSA PARTE QUANDO NAO FOI INFORMADO P_USUARIO OU QUANDO FOI INFORMADO MAS ACAO = ENCAMINHOU PARA SUPERIOR
	 SET @V_PASSO = '29';
	 --- BUSCA O GRUPO DE ALCADA QUE O PEDIDO ESTÁ SENDO LIBERADO 
	 BEGIN -- PROCEDURE 'P_SETA_ALCADA_ANTERIOR'
		SET @V_ALCP_GRPALCADA_ANTERIOR = NULL;
		SET @V_ALCP_CODIGO_ANTERIOR = NULL;
		SET @V_ALCP_GRPLIB_ANTERIOR = NULL;
		SET @V_ALCP_NIVLIB_ANTERIOR = NULL;
		--SETA ALÇADA ANTERIOR PEGANDO O ÚLTIMO REGISTRO DE LIBERAÇÃO
		SELECT  @V_ALCP_GRPALCADA_ANTERIOR = DB_ALCP_GRPALCADA,
				@V_ALCP_CODIGO_ANTERIOR = DB_ALCP_CODIGO,
				@V_ALCP_GRPLIB_ANTERIOR = DB_ALCP_GRUPOLIB,
				@V_ALCP_NIVLIB_ANTERIOR = DB_ALCP_NIVELLIB
		FROM DB_ALCADA_PED A, DB_PEDIDO_ALCADA B
		WHERE DB_ALCP_CODIGO = DB_PEDAL_ALCADA
				AND DB_PEDAL_PEDIDO = @P_NRO
				AND DB_PEDAL_SEQ = (SELECT MAX(DB_PEDAL_SEQ) FROM DB_PEDIDO_ALCADA WHERE DB_PEDAL_PEDIDO = @P_NRO)				
	END
	SET @V_PASSO = 30;	
	SET @V_AUX = 0
	SET @V_MOTNLIBERADO = ''
	IF ISNULL(@V_MOTIVOS, '') <> ''
	BEGIN
		IF ISNULL(@V_BLOQUEIOS, '') = ''
			SET @V_MOTNLIBERADO = @V_MOTIVOS;            
		WHILE @V_AUX < LEN(@V_MOTIVOS)
		BEGIN
			SET @V_AUX = @V_AUX + 1;
			IF CHARINDEX(SUBSTRING(@V_MOTIVOS, @V_AUX, 1), (@V_BLOQUEIOS)) = 0
				SET @V_MOTNLIBERADO = @V_MOTNLIBERADO + SUBSTRING(@V_MOTIVOS, @V_AUX, 1);
		END
	END
	--PRINT '1@V_BLOQUEIOS = ' + @V_BLOQUEIOS
	--PRINT '1@V_MOTNLIBERADO = '  + @V_MOTNLIBERADO
	SET @V_AUX = 0;
	IF ISNULL(@V_MOTNLIBERADO, '') <> ''
	    SET @V_ACHOU_OUTROMOTIVO = 0
		BEGIN
			WHILE @V_AUX < LEN(@V_MOTNLIBERADO)
				BEGIN
				    SET @V_AUX = @V_AUX + 1;
					IF RTRIM(LTRIM(SUBSTRING(@V_MOTNLIBERADO, @V_AUX, 1))) IS NOT NULL	
						IF CHARINDEX(SUBSTRING(@V_MOTNLIBERADO, @V_AUX, 1), ISNULL(@V_PARAM_MOTIVSLIBER, ' ')) = 0
							SET @V_ACHOU_OUTROMOTIVO = 1;
			    END
	END -- FIM @V_MOTNLIBERADO IS NOT NULL
	--PRINT '@V_MOTNLIBERADO: ' + @V_MOTNLIBERADO
	--PRINT '@V_PARAM_MOTIVSLIBER: ' + @V_PARAM_MOTIVSLIBER
	--PRINT '@V_ACHOU_OUTROMOTIVO: ' + CAST(@V_ACHOU_OUTROMOTIVO AS VARCHAR)
	IF @V_ACHOU_OUTROMOTIVO = 0
	BEGIN
		INSERT INTO DB_PEDIDO_ALCADA
                      (DB_PEDAL_PEDIDO,
                       DB_PEDAL_SEQ,                  
                       DB_PEDAL_STATUS,
                       DB_PEDAL_MOTLIB,
                       DB_PEDAL_DATALIB)
            VALUES
                      (@P_NRO, 1, 1, @V_MOTNLIBERADO, GETDATE());   
	     ---QUANDO LIBERA TOTAL, DEVE ATUALIZAR OS REGISTROS COM STATUS 9, QUE SAO OS PRIORITARIOS
          IF @V_PERMITE_LIBERA_PRIORITARIA = 1
		  BEGIN
            DELETE DB_PEDIDO_ALCADA
             WHERE DB_PEDAL_PEDIDO = @P_NRO
               AND DB_PEDAL_STATUS IN (0,9);
          END
            UPDATE DB_PEDIDO
               SET DB_PED_SITUACAO = 0
             WHERE DB_PED_NRO = @P_NRO;
            UPDATE DB_PEDIDO_COMPL
               SET DB_PEDC_CODINTEGR = 0
             WHERE DB_PEDC_NRO = @P_NRO;
        IF ISNULL(@P_OBSERVACAOJUSTIFICATIVA, '') = ''
            SET @V_DESCRICAO = @V_PROGRAMA + ' Liberou pedido total. Pedido nro: ' + CAST(@P_NRO AS VARCHAR);
        ELSE
		BEGIN
            SET @V_DESCRICAO = @V_PROGRAMA + ' Liberou pedido total com justificativa. Pedido nro: ' + CAST(@P_NRO AS VARCHAR);
			IF @VLIB_GRAVAJUSTIFICATIVAPED = 1
			BEGIN
				INSERT INTO DB_MENSAGEM (DB_MSG_TEXTO,
										DB_MSG_REPRES,
										DB_MSG_SEQUENCIA,
										DB_MSG_DATA,
										DB_MSG_USU_ENVIO,
										DB_MSG_MOTIVO,
					 					DB_MSG_PEDIDO,
										DB_MSG_TIPO) 
									VALUES(
										'Motivo ' + ISNULL(@V_MOTNLIBERADO, '') + ': ' + isnull(@P_OBSERVACAOJUSTIFICATIVA, ''),
										@V_PED_REPRES,
										(SELECT ISNULL(MAX(DB_MSG_SEQUENCIA), 0) + 1 FROM DB_MENSAGEM  WHERE DB_MSG_REPRES = @V_PED_REPRES),
										GETDATE(),
										@P_USUARIO,
										1,
										@P_NRO,
										5
										)
			END
		END
        SET @V_ENV_WORKFLOW = 19;
	END 
	ELSE
	BEGIN
		-- VERIFICA OS MOTIVOS QUE AINDA NÃO FORAM LIBERADOS
		SET @V_AUX = 0;
		PRINT 'ELSE'
		PRINT '1@V_MOTIVOS = ' + ISNULL(@V_MOTIVOS, 'NULL')
		PRINT '1@V_MOTNLIBERADO = ' + ISNULL(@V_MOTNLIBERADO, 'NULL')
		SET @V_MOTNLIBERADOSALVARPEDIDO = '';
		SET @V_AUX = 0;
		   --RETIRA OS MOTIVOS QUE NAO PRECISAM DE LIBERACAO
       IF ISNULL(@V_PARAM_MOTIVSLIBER, '') <> ''
	   BEGIN         
		  WHILE @V_AUX < LEN(@V_MOTNLIBERADO)
		  BEGIN
		  SET @V_AUX = @V_AUX + 1;            
           IF CHARINDEX(SUBSTRING(@V_MOTNLIBERADO, @V_AUX, 1), (@V_PARAM_MOTIVSLIBER)) = 0    -- ADICIONA OS MOTIVOS QUE DEVEM SER LIBERADOS		         
              SET @V_MOTNLIBERADOSALVARPEDIDO  = @V_MOTNLIBERADOSALVARPEDIDO + SUBSTRING(@V_MOTNLIBERADO, @V_AUX, 1);       
          END
	   END
       ELSE
	   BEGIN
         SET @V_MOTNLIBERADOSALVARPEDIDO = @V_MOTNLIBERADO;
       END
	   IF @V_PERMITE_LIBERA_PRIORITARIA = 1
	   BEGIN
          IF @V_ALCADA_E_PRIORITARIA = 1
		  BEGIN
              DELETE FROM DB_PEDIDO_ALCADA
              WHERE DB_PEDAL_PEDIDO = @P_NRO
                AND DB_PEDAL_STATUS = 0;
              DELETE FROM DB_PEDIDO_ALCADA
               WHERE DB_PEDAL_PEDIDO = @P_NRO
                 AND DB_PEDAL_STATUS = 9
                 AND DB_PEDAL_ALCADA <> @V_ALCADA_ATUAL;
              SELECT @V_PEDAL_SEQ = MAX(DB_PEDAL_SEQ)
			    FROM DB_PEDIDO_ALCADA
			   WHERE DB_PEDAL_PEDIDO = @P_NRO;  
          END            
          ELSE          
		  BEGIN
             DELETE FROM DB_PEDIDO_ALCADA
              WHERE DB_PEDAL_PEDIDO = @P_NRO
                AND DB_PEDAL_STATUS = 9;
          END
        END
		 BEGIN
			DECLARE C CURSOR
			FOR SELECT DB_ALCP_CODIGO, DB_ALCP_LIBPRIORITARIA, DB_ALCP_GRUPOLIB, DB_ALCP_GRPALCADA
				  FROM DB_ALCADA_PED
				 WHERE DB_ALCP_CODIGO IN (
							SELECT DB_ALCP_CODIGO
							  FROM DB_ALCADA_PED
							 WHERE DBO.MERCF_VALIDA_LISTA(@V_CLI_RAMATIV,	 DB_ALCP_LSTRAMO,   0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_PED_EMPRESA,	 DB_ALCP_LSTEMP,    0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_PED_TIPO,		 DB_ALCP_LSTTIPO,   0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_CLASCOM,	 DB_ALCP_LSTCLASS,  0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_PED_SITCORP,	 DB_ALCP_LSTSITCORP,0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_REGIAOCOM,  DB_ALCP_LSTREGCOM, 0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_PED_OPERACAO,	 DB_ALCP_LSTOPER,   0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_STATUS_PED_ATUAL, DB_ALCP_LSTSTATUS,   0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_DB_PED_LISTA_PRECO, DB_ALCP_LSTLISTAPRECO,   0, ',') > 0
							   AND DBO.MERCF_VALIDA_LISTA(@V_CLI_AREAATU,	 DB_ALCP_LSTAREAATU,   0, ',') > 0
							   -- DB_ALCP_OPCREP = OPÇÃO REPRESENTANTE ( 0 - PERMITIR TODOS / 1 - SOMENTE ALGUNS / 2 - EXCETO ALGUNS )
							   AND CASE WHEN ISNULL(DB_ALCP_OPCREP, 0) = 0 AND 0 = 0
										THEN 1
										WHEN ISNULL(DB_ALCP_OPCREP, 0) = 1 AND DBO.MERCF_VALIDA_LISTA(@V_PED_REPRES, DB_ALCP_LSTREP, 0, ',') > 0
										THEN 1
										WHEN ISNULL(DB_ALCP_OPCREP, 0) = 2 AND DBO.MERCF_VALIDA_LISTA(@V_PED_REPRES, DB_ALCP_LSTREP, 1, ',') > 0
										THEN 1
										ELSE 0
										END = 1
							   AND ((@V_PED_REPRES IN (SELECT Z.DB_EREG_REPRES
														FROM DB_ESTRUT_VENDA X, 
															 DB_ESTRUT_VENDA Y, 
															 DB_ESTRUT_REGRA Z, 
															 DB_ESTRUT_REGRA Z1, 
															 DB_ALCADA_ESTRUT AL
													   WHERE X.DB_EVDA_ESTRUTURA  = Y.DB_EVDA_ESTRUTURA																				
												 		 AND Y.DB_EVDA_CODIGO     LIKE (X.DB_EVDA_CODIGO + '%')
														 AND X.DB_EVDA_ESTRUTURA  = Z.DB_EREG_ESTRUTURA
														 AND Y.DB_EVDA_ID         = Z.DB_EREG_ID
														 AND X.DB_EVDA_ESTRUTURA  = Z1.DB_EREG_ESTRUTURA
														 AND X.DB_EVDA_ID         = Z1.DB_EREG_ID
														 --AND Z.DB_EREG_SEQ        = 1
														 AND AL.DB_ALCE_ESTRUTURA = Z1.DB_EREG_ESTRUTURA
														 AND DB_ALCP_CODIGO       = AL.DB_ALCE_ALCADA
														 AND AL.DB_ALCE_ID        =  Z1.DB_EREG_ID ))  OR ((SELECT TOP(1) DB_ALCE_ALCADA
																											  FROM DB_ALCADA_ESTRUT
																											 WHERE DB_ALCP_CODIGO = DB_ALCE_ALCADA) IS NULL))
									-- VALIDA A LISTA DE TIPOS DE PRODUTOS
									/*AND (EXISTS (SELECT 1
												   FROM DB_PEDIDO_PROD, DB_PRODUTO
												  WHERE DB_PEDI_PEDIDO = @P_NRO
													AND DB_PROD_CODIGO = DB_PEDI_PRODUTO
													AND DBO.MERCF_VALIDA_LISTA(DB_PROD_TPPROD, DB_ALCP_LSTTPPROD, 0, ',') > 0)
												OR DB_ALCP_LSTTPPROD IS NULL)*/
								    -- VALIDA A LISTA DE TIPOS DE PRODUTOS
                                    AND (EXISTS (SELECT 1
                                                   FROM DB_PEDIDO, DB_PEDIDO_PROD, DB_PRODUTO
                                                  WHERE DB_PEDI_PEDIDO     = @P_NRO
                                                    AND DB_PEDI_PEDIDO     = DB_PED_NRO
                                                    AND DB_PROD_CODIGO     = DB_PEDI_PRODUTO
                                                    AND ( ((DB_PED_MOTIVO_BLOQ LIKE '%D%' AND (NOT DB_ALCP_MOTBLOQ LIKE '%D%' OR (DB_ALCP_MOTBLOQ LIKE '%D%' AND DB_PEDI_ECON_VLR < 0)))
                                                         OR DB_PED_MOTIVO_BLOQ NOT LIKE '%D%')
                                                       OR ((DB_PED_MOTIVO_BLOQ LIKE '%F%' AND (NOT DB_ALCP_MOTBLOQ LIKE '%F%' OR (DB_ALCP_MOTBLOQ LIKE '%F%' AND (DB_PEDI_TIPO = 'B' OR DB_PED_FATUR = 2))))
                                                         OR DB_PED_MOTIVO_BLOQ NOT LIKE '%F%')
														 )
                                                    AND DB_ALCP_LSTTPPROD LIKE '%' + DB_PROD_TPPROD + '%')
                                                OR ISNULL(DB_ALCP_LSTTPPROD,'') = '')
									 AND (EXISTS (SELECT 1
													FROM DB_PEDIDO, DB_PEDIDO_PROD, DB_PRODUTO, DB_TB_REPRES
													WHERE DB_PEDI_PEDIDO     = @P_NRO
													AND DB_PEDI_PEDIDO     = DB_PED_NRO
													AND DB_PROD_CODIGO     = DB_PEDI_PRODUTO
													AND DB_PED_REPRES = DB_TBREP_CODIGO
													AND DB_PED_MOTIVO_BLOQ LIKE '%D%' 
													AND DB_ALCP_REGRAEXCDESCONTO > 0
													AND DB_ALCP_ITEMSEMDESC = 1
													and DB_ALCP_AVALIADESCONTO = 1
													AND EXISTS (SELECT 1 FROM DB_PEDIDO_DESCONTO WHERE DB_PEDD_NRO = DB_PED_NRO AND DB_PEDD_SEQIT = DB_PEDI_SEQUENCIA and DB_PEDD_DESCONTO > 0)		
													and DB_PEDI_ECON_VLR < 0
													AND DB_PEDI_TIPO NOT IN ('B', 'T')
													AND EXISTS(
																SELECT TOP 1 1										 
																	FROM DB_REGRASDESCLIBERACAO CAPA
																		, DB_REGRASDESCLIB_PRODUTOS PROD
																	WHERE CAPA.CODIGO = PROD.CODIGO
																		AND CAPA.CODIGO = DB_ALCP_REGRAEXCDESCONTO
																		AND CAST(GETDATE() AS DATE) BETWEEN CAST(CAPA.DATA_INICIAL AS DATE)  AND CAST(CAPA.DATA_FINAL AS DATE)
																	   AND CAST(GETDATE() AS DATE) BETWEEN CAST(ISNULL(PROD.DTVAL_INICIAL, CAPA.DATA_INICIAL) AS DATE)  AND CAST(ISNULL(PROD.DTVAL_FINAL, CAPA.DATA_FINAL) AS DATE)
																		AND DBO.MERCF_VALIDA_LISTA(DB_PROD_CODIGO, PRODUTO, 0, ',') = 1   
																		AND DBO.MERCF_VALIDA_LISTA(DB_PROD_TPPROD, TIPO, 0, ',') = 1
																		AND DBO.MERCF_VALIDA_LISTA(DB_PROD_MARCA, MARCA, 0, ',') = 1
																		AND DBO.MERCF_VALIDA_LISTA(DB_PROD_FAMILIA , FAMILIA, 0, ',') = 1
																		AND DBO.MERCF_VALIDA_LISTA(DB_PROD_GRUPO , GRUPO, 0, ',') = 1		
																		AND (PROD.UNIDFV  IS NULL OR PROD.UNIDFV = ''  OR  PROD.UNIDFV = DB_TBREP_UNIDFV)     
																		AND (ISNULL(PROD.CLIENTE, 0) = 0 OR PROD.CLIENTE = DB_PED_CLIENTE) )
														)
														OR (isnull(DB_ALCP_ITEMSEMDESC, 0) = 0 or DB_ALCP_AVALIADESCONTO <> 1)
													)
									 AND (EXISTS(
												SELECT DOCUMENTO
												  FROM DB_PEDIDO_DOC_BLOQ
												 WHERE PEDIDO = @P_NRO
												   AND ISNULL(DATA_LIBERACAO, '') = ''
												   AND (ISNULL(DB_ALCP_LSTTIPODOC , '') LIKE  CAST(CAST(DOCUMENTO  AS VARCHAR) AS VARCHAR) + ',%' OR  ISNULL(DB_ALCP_LSTTIPODOC , '') LIKE '%,' + CAST(CAST(DOCUMENTO  AS VARCHAR) AS VARCHAR) + ',%' OR  ISNULL(DB_ALCP_LSTTIPODOC , '') LIKE  '%,' + CAST(CAST(DOCUMENTO  AS VARCHAR) AS VARCHAR) 
														OR ISNULL(DB_ALCP_LSTTIPODOC , '') = CAST(CAST(DOCUMENTO  AS VARCHAR) AS VARCHAR) OR ISNULL(ISNULL(DB_ALCP_LSTTIPODOC , ''), '') = ''))  
														OR ISNULL(DB_ALCP_LSTTIPODOC, '')  = ''
														OR (SELECT TOP 1 1 FROM DB_PEDIDO_DOC_BLOQ WHERE PEDIDO = @P_NRO AND ISNULL(DATA_LIBERACAO, '') = '') IS NULL)
										AND (CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,1,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,2,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,3,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,4,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,5,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,6,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,7,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,8,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,9,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,10,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,11,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,12,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,13,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,14,1), DB_ALCP_MOTBLOQ) > 0
										 OR  CHARINDEX(SUBSTRING(@V_MOTNLIBERADOSALVARPEDIDO,15,1), DB_ALCP_MOTBLOQ) > 0)  
				 AND ( DB_ALCP_GRPALCADA = @V_ALCP_GRPALCADA_ANTERIOR OR ISNULL(@V_ALCP_GRPALCADA_ANTERIOR, '') = '') ---- SE JA FOI LIBERADO POR ALGUEM DEVE SEGUIR NA MESMA ALCADA
				 AND (((DB_ALCP_GRUPOLIB = @V_ALCP_GRPLIB_ANTERIOR AND DB_ALCP_NIVELLIB > @V_ALCP_NIVLIB_ANTERIOR)
				 	 OR (DB_ALCP_GRUPOLIB > @V_ALCP_GRPLIB_ANTERIOR)) 
					 OR ISNULL(@V_ALCP_CODIGO_ANTERIOR, '') = '')
								AND DB_ALCP_CODIGO NOT IN ( SELECT DB_ALCP_CODIGO   --- NAO DEVE SER IGUALAO ULTIMO NIVEL LIBERADEO
															  FROM DB_ALCADA_PED A, DB_PEDIDO_ALCADA B
															  WHERE DB_ALCP_CODIGO = DB_PEDAL_ALCADA
																AND DB_PEDAL_PEDIDO = @P_NRO)
										AND DB_ALCP_TIPO = 0
										)
								ORDER BY DB_ALCP_GRPALCADA, DB_ALCP_GRUPOLIB, DB_ALCP_NIVELLIB
								--PRINT 'PARTE 22222222'
								--PRINT '@V_CLI_RAMATIV '     +  ISNULL(@V_CLI_RAMATIV, 'NULO')
	--PRINT '@V_PED_EMPRESA '		+  ISNULL(@V_PED_EMPRESA, 'NULO')
	--PRINT '@V_PED_TIPO '		+  ISNULL(@V_PED_TIPO, 'NULO')
	--PRINT '@V_CLI_CLASCOM '		+  ISNULL(@V_CLI_CLASCOM, 'NULO')
	--PRINT '@V_PED_SITCORP '		+  ISNULL(@V_PED_SITCORP, 'NULO')
	--PRINT '@V_CLI_REGIAOCOM '	+  ISNULL(@V_CLI_REGIAOCOM, 'NULO')
	--PRINT '@V_PED_OPERACAO '	+  ISNULL(@V_PED_OPERACAO, 'NULO')
	--PRINT '@V_PED_REPRES '		+  ISNULL(@V_PED_REPRES, 'NULO')
	--PRINT '@@V_MOTIVOS '	+  ISNULL(@V_MOTIVOS, 'NULO')
	--PRINT '@V_ALCP_GRPALCADA_ANTERIOR ' +  ISNULL(@V_ALCP_GRPALCADA_ANTERIOR , 'NULO')
					OPEN C
					FETCH NEXT FROM C
					INTO @V_ALCP_CODIGO_TEMP, @VDB_ALCP_LIBPRIORITARIA, @VDB_ALCP_GRUPOLIB, @VDB_ALCP_GRPALCADA
					WHILE @@FETCH_STATUS = 0
					BEGIN
						IF @V_ALCP_CODIGO IS NULL
						BEGIN
							SET @V_ALCP_CODIGO = @V_ALCP_CODIGO_TEMP;
							SET @V_GRUPO_ALCADA = @VDB_ALCP_GRPALCADA;
							SET @V_GRUPO_LIBERACAO = @VDB_ALCP_GRUPOLIB;
						END
						ELSE
						BEGIN
								--- AQUI DEVE VALIDAR AS ALÇADAS QUE SÃO PRIORITARIASPARA O MESNMO GRUPO DE ALCADA E LIBERACAO
							IF @V_PERMITE_LIBERA_PRIORITARIA = 1
							BEGIN
								IF @VDB_ALCP_LIBPRIORITARIA = 1 AND @V_GRUPO_ALCADA = @VDB_ALCP_GRPALCADA AND @V_GRUPO_LIBERACAO = @VDB_ALCP_GRUPOLIB
								BEGIN
									IF ISNULL(@V_ALCADAS_PRIORITARIAS, '') = '' OR LEN(@V_ALCADAS_PRIORITARIAS) = 0 
										SET @V_ALCADAS_PRIORITARIAS = @V_ALCP_CODIGO_TEMP + ';'
									ELSE
										SET @V_ALCADAS_PRIORITARIAS = @V_ALCADAS_PRIORITARIAS + @V_ALCP_CODIGO_TEMP + ';'
								END
							END
						END
					FETCH NEXT FROM C
					INTO @V_ALCP_CODIGO_TEMP, @VDB_ALCP_LIBPRIORITARIA, @VDB_ALCP_GRUPOLIB, @VDB_ALCP_GRPALCADA
					END			
		END
			CLOSE C
			DEALLOCATE C
	-- QUANDO ENCAMINHA PARA SUPERIOR DEVE AVALIAR SE IRA MUDAR O GRUPO. QUANDO MUDA O GRUPO NAO DEVE
		 -- PERMITIR ENCAMINHAR PARA SUPERIOR.
		 IF @V_GRAVALOG = 1
	     BEGIN
			 IF ISNULL(@V_ALCP_CODIGO, '') = '' 
			 BEGIN          
				INSERT INTO DBS_ERROS_TRIGGERS
      			  (DBS_ERROS_OBJETO, DBS_ERROS_DATA, DBS_ERROS_ERRO)
				  VALUES
				  ('MERCP_LIBERCAO_PEDIDO_LOG', GETDATE(), 'Pedido: ' + CAST(@P_NRO AS VARCHAR) + ' - Usu: ' + ISNULL(@P_USUARIO, 'null') + ' - acao: ' + CAST(@P_ACAO AS VARCHAR) + ' - exclui: ' + CAST(@P_EXCLUI AS VARCHAR) + ' Nao encontrou alcada valida');
			 END
			 else                    
			 BEGIN
				 INSERT INTO DBS_ERROS_TRIGGERS
      			 (DBS_ERROS_OBJETO, DBS_ERROS_DATA, DBS_ERROS_ERRO)
				 VALUES
				 ('MERCP_LIBERCAO_PEDIDO_LOG', GETDATE(), 'Pedido: ' + CAST(@P_NRO AS VARCHAR) + ' - Usu: ' + ISNULL(@P_USUARIO, 'null') + ' - acao: ' + CAST(@P_ACAO AS VARCHAR) + ' - exclui: ' + CAST(@P_EXCLUI AS VARCHAR)
             		+ ' Busca alcada - ' + ISNULL(@V_MOTNLIBERADO, 'null') + ' - alcada: ' + @V_ALCP_CODIGO);
			END
		END
		IF @P_ACAO = 2 -- BUSCA O ULTIMO GRUPO QUE LIBEROU
				BEGIN
					  SET @V_ULTIMO_GRUPO = NULL;
					  SET @V_GRUPO_ATUAL = NULL;
					SELECT @V_ULTIMO_GRUPO = MAX(DB_ALCP_GRUPOLIB)
					  FROM DB_ALCADA_PED A, DB_PEDIDO_ALCADA B
					 WHERE DB_ALCP_CODIGO = DB_PEDAL_ALCADA
					   AND DB_PEDAL_PEDIDO = @P_NRO;
					--BUSCA O PROXIMO GRUPO
					SELECT @V_GRUPO_ATUAL = DB_ALCP_GRUPOLIB
					  FROM DB_ALCADA_PED
					 WHERE DB_ALCP_CODIGO = @V_ALCP_CODIGO
	--PRINT '@V_ALCP_CODIGO ' + CONVERT(VARCHAR,  @V_ALCP_CODIGO)
	--PRINT '@V_ULTIMO_GRUPO ' + CONVERT(VARCHAR,  @V_ULTIMO_GRUPO)
	--PRINT '@V_GRUPO_ATUAL ' + CONVERT(VARCHAR, @V_GRUPO_ATUAL)
			IF ISNULL(@V_ULTIMO_GRUPO, '') <> ISNULL(@V_GRUPO_ATUAL, '')
			BEGIN
				SET @V_PERMITE_ENCAMINHAR = 1;
				SET @VERRO = 'PEDIDO '+ CONVERT(VARCHAR, @P_NRO) + ' - NAO FOI POSSIVEL ENCAMINHAR PARA SUPERIOR, POIS USUARIO: ' + @P_USUARIO + ' E O ULTIMO DA HIERARQUIA.';
				INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, GETDATE(), @VOBJETO);
				--COMMIT;
			END
			ELSE  
			BEGIN 
				SET @V_PERMITE_ENCAMINHAR = 0; 
			END
			END 
		ELSE
			BEGIN 
				SET @V_PERMITE_ENCAMINHAR = 0;  
			END  -- FIM @P_ACAO = 2
		IF @V_PERMITE_ENCAMINHAR = 0
			BEGIN
				SET @V_PASSO = '31';
				--POR FIM INSERE O PEDIDO NA DB_PEDIDO_ALCADA
				BEGIN
					SET @V_EXISTE = 0;
					SELECT @V_EXISTE = 1
					  FROM DB_PEDIDO_ALCADA
					 WHERE DB_PEDAL_PEDIDO = @P_NRO
				END
				--- GRAVA OS CAMPOS NECESSÁRIOS PARA O SERVER 
				IF @P_EXCLUI = 0
				BEGIN
					UPDATE DB_PEDIDO
						SET DB_PED_LIB_MOTS = ISNULL(DB_PED_LIB_MOTS, '') + ';'
							, DB_PED_LIB_USUS = ISNULL(DB_PED_LIB_USUS, '') + @P_USUARIO + '!' + CONVERT(VARCHAR, @V_GRUPO_LIB) + ';'
							, DB_PED_LIB_DATAS = ISNULL(DB_PED_LIB_DATAS, '') + CONVERT(VARCHAR, GETDATE(), 103) + ';'
							, DB_PED_DATA_ALTER = GETDATE()
						WHERE DB_PED_NRO = @P_NRO;
					UPDATE DB_PEDIDO_COMPL
						SET DB_PEDC_LIB_HORAS  = ISNULL(DB_PEDC_LIB_HORAS, '') + CONVERT(VARCHAR, GETDATE(), 108) + ';'
						  , DB_PEDC_DTULTLIB   = GETDATE()
						WHERE DB_PEDC_NRO  = @P_NRO;
				END
	PRINT 'NA FASE FINAL' 
	PRINT '@V_MOTIVOS ' + @V_MOTIVOS
	PRINT'@V_MOTNLIBERADO ' + @V_MOTNLIBERADO
	PRINT '@V_BLOQUEIOS ' + @V_BLOQUEIOS
	PRINT '@V_PERMI ' + @V_PERMI
	--AQUI
				-- QUANDO ENCAMINHA PARA SUPERIOR DEVE GRAVAR O CAMPO DB_PEDAL_MOTLIBPAR
				SET @V_AUX = 0
				IF ISNULL(@V_PERMI, '') <> ''
				BEGIN
					WHILE @V_AUX < LEN(@V_PERMI)
						BEGIN
							SET @V_AUX = @V_AUX + 1;
							IF  CHARINDEX(SUBSTRING(@V_PERMI, @V_AUX, 1), ISNULL(@V_MOTIVOS, ' ')) > 0
							SET @V_PEDAL_MOTLIBPAR = ISNULL(@V_PEDAL_MOTLIBPAR, '') + SUBSTRING(@V_PERMI, @V_AUX, 1);
						END
				END 
	--PRINT '@@V_PEDAL_MOTLIBPAR ' + @V_PEDAL_MOTLIBPAR
				IF ISNULL(@V_EXISTE, 0) = 0 ----- SE ENCONTROU PROXIMA ALCADA DEVE ISNERIR REGISTRO NA DB_PEDIDO_ALCADA, DO CONTRARIO DEVE LIBERAR O PEDIDO, POIS SIGNIFICA QUE NAO TEM MAIS ALCADA CONFIGURADA 
					BEGIN
						IF ISNULL(@V_ALCP_CODIGO, '') <> ''
						BEGIN						
							IF @V_PERMITE_LIBERA_PRIORITARIA = 1 AND LEN(@V_ALCADAS_PRIORITARIAS) > 0
							BEGIN
								SET @V_COUNT_ALCADA = 1;
								WHILE @V_COUNT_ALCADA <= (LEN(@V_ALCADAS_PRIORITARIAS) - LEN(REPLACE(@V_ALCADAS_PRIORITARIAS, ';', '')))
								BEGIN
									SET @V_PEDAL_SEQ = ISNULL(@V_PEDAL_SEQ, 0) + 1;
									INSERT INTO DB_PEDIDO_ALCADA(DB_PEDAL_PEDIDO, DB_PEDAL_SEQ, DB_PEDAL_ALCADA, DB_PEDAL_STATUS)
									     VALUES (
												@P_NRO, 
												@V_PEDAL_SEQ, 
												(DBO.MERCF_PIECE(@V_ALCADAS_PRIORITARIAS, ';', @V_COUNT_ALCADA)),
												9);	
									SET @V_COUNT_ALCADA = @V_COUNT_ALCADA + 1;
								END
							END
							INSERT INTO DB_PEDIDO_ALCADA(DB_PEDAL_PEDIDO, DB_PEDAL_SEQ, DB_PEDAL_ALCADA, DB_PEDAL_STATUS)
							VALUES (@P_NRO, ISNULL(@V_PEDAL_SEQ, 0) + 1, @V_ALCP_CODIGO, 0);
							---- CRIA NOTIFICACAOPARA ENVIAR PARA USUARIOS DA ALCADA
							SET @V_CODIGO_NOTIFICACAO = 0
							SET @V_USUARIO_SERVICO = 0
							DECLARE C_USUARIO_ALCADA CURSOR
							FOR SELECT USU.CODIGO
									FROM DB_PERM_NOTIFICACAO_SISTEMA NOTI, DB_ALCADA_USUARIO ALCADA, DB_USUARIO USU
								WHERE NOTIFICACAO = 3
								AND ((ALCADA.DB_ALCU_ALCADA = @V_ALCP_CODIGO) OR (LEN(@V_ALCADAS_PRIORITARIAS) > 0 AND ';' + @V_ALCADAS_PRIORITARIAS + ';' LIKE '%;' + ALCADA.DB_ALCU_ALCADA + ';%'))
								AND ALCADA.DB_ALCU_USUARIO = USU.CODIGO
								AND ((ISNULL(NOTI.USUARIO, '') = '' AND NOTI.GRUPO_USUARIO = USU.GRUPO_USUARIO) OR NOTI.USUARIO = USU.USUARIO)
							OPEN C_USUARIO_ALCADA
							FETCH NEXT FROM C_USUARIO_ALCADA
							INTO @V_USUARIO_NOTI	
							WHILE @@FETCH_STATUS = 0
							BEGIN
								IF @V_CODIGO_NOTIFICACAO = 0
								BEGIN
									SELECT @V_CODIGO_NOTIFICACAO = ISNULL(MAX(CODIGO), 0) FROM DB_NOTIFICACAO
									SELECT TOP 1 @V_USUARIO_SERVICO = CODIGO FROM DB_USUARIO WHERE TIPO_ACESSO = 3	  
								END
								SET @V_CODIGO_NOTIFICACAO = @V_CODIGO_NOTIFICACAO + 1
								INSERT INTO DB_NOTIFICACAO 
									(CODIGO, USUARIO_ENVIO, USUARIO_DESTINATARIO, MENSAGEM, DATA_ENVIO, TIPO_NOTIFICACAO)
								VALUES
									(@V_CODIGO_NOTIFICACAO,
										@V_USUARIO_SERVICO,
										@V_USUARIO_NOTI,
										'O pedido ' + CAST(@P_NRO AS VARCHAR) + ' do cliente ' + @V_DB_CLI_NOME + ' está aguardando a sua liberação.',
										null,
										3) -- tipo livera pedido
							FETCH NEXT FROM C_USUARIO_ALCADA
							INTO @V_USUARIO_NOTI
							END
							CLOSE C_USUARIO_ALCADA
							DEALLOCATE C_USUARIO_ALCADA
							--IF ISNULL(@P_USUARIO, '') <> ''
								SET @V_ENV_WORKFLOW = 18;
							--- BUSCA STATUS DA ALÇADA
							SET @V_STATUS_PED = 0;
								SELECT @V_STATUS_PED = DB_ALCP_STATUS_ALCADA
									FROM DB_ALCADA_PED, DB_STATUS
								WHERE DB_ALCP_CODIGO = @V_ALCP_CODIGO
									AND DB_ALCP_STATUS_ALCADA = DB_STATUS.CODIGO
									AND GETDATE() BETWEEN DATA_INICIAL AND DATA_FINAL;				
							--- SOMENTE ATUALIZA SE O STATUS FOR DIFERENTE DE NULL E ZERO            
							IF @V_STATUS_PED <> 0 AND ISNULL(@V_STATUS_PED, '') <> ''
							BEGIN
								--- SE HOUVER ALTERAÇÃO DE STATUS, DEVE GRAVAR UMA MENSAGEM
								IF @V_STATUS_PED <> @V_STATUS_PED_ATUAL
								BEGIN
									INSERT INTO DB_MENSAGEM (
															DB_MSG_REPRES,
															DB_MSG_SEQUENCIA,
															DB_MSG_DATA,
															DB_MSG_USU_ENVIO,
															DB_MSG_PEDIDO,
															DB_MSG_TEXTO)
													VALUES (
															@V_PED_REPRES,
															ISNULL((SELECT MAX(DB_MSG_SEQUENCIA) FROM DB_MENSAGEM WHERE DB_MSG_REPRES = @V_PED_REPRES), 0) + 1, 
															GETDATE(),
															@P_USUARIO,
															@P_NRO,
															'Liberação de pedido: novo status do pedido: ' +
															ISNULL((SELECT DESCRICAO FROM DB_STATUS WHERE CODIGO = @V_STATUS_PED), '[SEM STATUS]') +
															'. Status anterior: '  +
															ISNULL((SELECT DESCRICAO FROM DB_STATUS WHERE CODIGO = @V_STATUS_PED_ATUAL), '[SEM STATUS]')
															);                                            
								END  
									---ATUALIZA O STATUS DO PEDIDO
								UPDATE DB_PEDIDO_COMPL
									SET DB_PEDC_STATUSPED = @V_STATUS_PED
									WHERE DB_PEDC_NRO = @P_NRO;                 
							END
							ELSE
							BEGIN
								--CASO A ALÇADA NÃO TENHA UM STATUS INFORMADO OU NÃO SEJA MAIS VÁLIDO
								--VERIFICAR SE O STATUS ATUAL DO PEDIDO AINDA É VALIDO, CASO NÃO SEJA SETAR ZERO
								IF @V_STATUS_PED_ATUAL <> 0 AND ISNULL(@V_STATUS_PED_ATUAL, '') <> ''
								BEGIN
									SET @V_STATUS_VALIDO = 0;
									SELECT @V_STATUS_VALIDO = 1
										FROM DB_STATUS
										WHERE DB_STATUS.CODIGO = @V_STATUS_PED_ATUAL
										AND CAST(GETDATE() AS DATE) BETWEEN DATA_INICIAL AND DATA_FINAL;
									IF @V_STATUS_VALIDO = 0
									BEGIN
										UPDATE DB_PEDIDO_COMPL
											SET DB_PEDC_STATUSPED = 0
											WHERE DB_PEDC_NRO = @P_NRO;  
									END
								END
							END
						END 
						--ELSE
						--BEGIN
								--UPDATE DB_PEDIDO
								--   SET DB_PED_SITUACAO = 0
								-- WHERE DB_PED_NRO = @P_NRO;
						 --  SET @V_ENV_WORKFLOW = 19;
						--END
					END
				ELSE
					BEGIN
						IF @V_ALCADA_E_PRIORITARIA = 1 AND ISNULL(@V_ALCADA_ATUAL, '') <> ''
						BEGIN
						  SELECT @V_PEDAL_SEQ = DB_PEDAL_SEQ        
							FROM DB_PEDIDO_ALCADA
						   WHERE DB_PEDAL_PEDIDO = @P_NRO
							 AND DB_PEDAL_ALCADA = @V_ALCADA_ATUAL;
						END
						ELSE 
						BEGIN
							SELECT @V_PEDAL_SEQ = MAX(DB_PEDAL_SEQ)
							  FROM DB_PEDIDO_ALCADA
							 WHERE DB_PEDAL_PEDIDO = @P_NRO;
						END
						--- QUANDO NÃO FOI LIBERADO TOTAL, DEVE ATUALIZAR COM USUARIO E CRIAR UM NOVO REGISTRO
						UPDATE DB_PEDIDO_ALCADA
							SET DB_PEDAL_USULIB   = @V_CODIGO_USUARIO  --P_USUARIO
								, DB_PEDAL_DATALIB  = GETDATE()
								, DB_PEDAL_ACAO     = @P_ACAO
			  					, DB_PEDAL_STATUS   = 2
								, DB_PEDAL_JUSTIF  = @P_CODIGOJUSTIFICATIVA
								, DB_PEDAL_JUSTOBS = @P_OBSERVACAOJUSTIFICATIVA
								, DB_PEDAL_JREPRES = @P_REPRESJUSTIFICATIVA
								, DB_PEDAL_MOTLIBPAR = @V_PEDAL_MOTLIBPAR
								, DB_PEDAL_ITEMLIB   = @V_PEDAL_ITEMLIB_D_ATUAL
							WHERE DB_PEDAL_PEDIDO   = @P_NRO
							AND DB_PEDAL_SEQ      = @V_PEDAL_SEQ;
						IF @P_ACAO = 2
						BEGIN
							SET @V_EXISTE_ALCADA = 0;
							IF @V_PERMITE_LIBERA_PRIORITARIA = 1 AND LEN(@V_ALCADAS_PRIORITARIAS) > 0
							BEGIN
							  SET @V_COUNT_ALCADA = 1;
							  WHILE @V_COUNT_ALCADA <= (LEN(@V_ALCADAS_PRIORITARIAS) - LEN(REPLACE(@V_ALCADAS_PRIORITARIAS, ';', '')))
							  BEGIN
								SET @V_ALCADA_TEMP_PRI = DBO.MERCF_PIECE(@V_ALCADAS_PRIORITARIAS, ';', @V_COUNT_ALCADA);
								-- verifica se ja existe registro para o pedido nas alçadas encontradas								
								SELECT @V_EXISTE_ALCADA = 1
								  FROM DB_PEDIDO_ALCADA
							 	 WHERE DB_PEDAL_PEDIDO = @P_NRO
								   AND DB_PEDAL_ALCADA = @V_ALCADA_TEMP_PRI;								
								--- SE NAO EXISTE INSERE UM REGISTRO PARA A ALCADA PRIORITARIA
								IF @V_EXISTE_ALCADA = 0
								BEGIN
								  SET @V_PEDAL_SEQ = ISNULL(@V_PEDAL_SEQ, 0) + 1;
								  INSERT INTO DB_PEDIDO_ALCADA(DB_PEDAL_PEDIDO, DB_PEDAL_SEQ, DB_PEDAL_ALCADA, DB_PEDAL_STATUS)
									  VALUES (
										@P_NRO, 
										@V_PEDAL_SEQ, 
										@V_ALCADA_TEMP_PRI,
										9);	
								END
								SET @V_COUNT_ALCADA = @V_COUNT_ALCADA + 1;
							  END
							  ---SEMPRE DEVE VALIDAR SE EXISTE JA UMA ALCADA INSERIDA, PQ PODE SER QUE UMA PRIORIRTARIA DE MESMO CODIGO JA ESTEJA NA TABELA
							  SET @V_EXISTE_ALCADA = 0;
							  SELECT @V_EXISTE_ALCADA = 1
								FROM DB_PEDIDO_ALCADA
							   WHERE DB_PEDAL_PEDIDO = @P_NRO
								 AND DB_PEDAL_ALCADA = @V_ALCP_CODIGO;							  
							END
							IF @V_EXISTE_ALCADA = 0
							BEGIN
							   INSERT INTO DB_PEDIDO_ALCADA(DB_PEDAL_PEDIDO, DB_PEDAL_SEQ, DB_PEDAL_ALCADA, DB_PEDAL_STATUS)
							   VALUES (@P_NRO, ISNULL(@V_PEDAL_SEQ, 0) + 1, @V_ALCP_CODIGO, 0);
							END
						   ---- CRIA NOTIFICACAOPARA ENVIAR PARA USUARIOS DA ALCADA
							SET @V_CODIGO_NOTIFICACAO = 0
							SET @V_USUARIO_SERVICO = 0
							DECLARE C_USUARIO_ALCADA CURSOR
							FOR SELECT USU.CODIGO
									FROM DB_PERM_NOTIFICACAO_SISTEMA NOTI, DB_ALCADA_USUARIO ALCADA, DB_USUARIO USU
								WHERE NOTIFICACAO = 3
								AND ((ALCADA.DB_ALCU_ALCADA = @V_ALCP_CODIGO) OR (LEN(@V_ALCADAS_PRIORITARIAS) > 0 AND ';' + @V_ALCADAS_PRIORITARIAS + ';' LIKE '%;' + ALCADA.DB_ALCU_ALCADA + ';%'))
								AND ALCADA.DB_ALCU_USUARIO = USU.CODIGO
								AND ((ISNULL(NOTI.USUARIO, '') = '' AND NOTI.GRUPO_USUARIO = USU.GRUPO_USUARIO) OR NOTI.USUARIO = USU.USUARIO)
							OPEN C_USUARIO_ALCADA
							FETCH NEXT FROM C_USUARIO_ALCADA
							INTO @V_USUARIO_NOTI	
							WHILE @@FETCH_STATUS = 0
							BEGIN
								IF @V_CODIGO_NOTIFICACAO = 0
								BEGIN
									SELECT @V_CODIGO_NOTIFICACAO = ISNULL(MAX(CODIGO), 0) FROM DB_NOTIFICACAO
									SELECT TOP 1 @V_USUARIO_SERVICO = CODIGO FROM DB_USUARIO WHERE TIPO_ACESSO = 3	  
								END
								SET @V_CODIGO_NOTIFICACAO = @V_CODIGO_NOTIFICACAO + 1
								INSERT INTO DB_NOTIFICACAO 
									(CODIGO, USUARIO_ENVIO, USUARIO_DESTINATARIO, MENSAGEM, DATA_ENVIO, TIPO_NOTIFICACAO)
								VALUES
									(@V_CODIGO_NOTIFICACAO,
										@V_USUARIO_SERVICO,
										@V_USUARIO_NOTI,
										'O pedido ' + CAST(@P_NRO AS VARCHAR) + ' do cliente ' + @V_DB_CLI_NOME + ' está aguardando a sua liberação.',
										null, 
										3)
							FETCH NEXT FROM C_USUARIO_ALCADA
							INTO @V_USUARIO_NOTI
							END
							CLOSE C_USUARIO_ALCADA
							DEALLOCATE C_USUARIO_ALCADA
						   IF @VLIB_GRAVAJUSTIFICATIVAPED = 1 AND ISNULL(@P_OBSERVACAOJUSTIFICATIVA, '') <> ''
							BEGIN
								INSERT INTO DB_MENSAGEM (DB_MSG_TEXTO,
														DB_MSG_REPRES,
														DB_MSG_SEQUENCIA,
														DB_MSG_DATA,
														DB_MSG_USU_ENVIO,
														DB_MSG_MOTIVO,
					 									DB_MSG_PEDIDO,
														DB_MSG_TIPO) 
													VALUES(
														'Motivo ' + ISNULL(@V_PEDAL_MOTLIBPAR, '') + ': ' + @P_OBSERVACAOJUSTIFICATIVA,
														@V_PED_REPRES,
														(SELECT ISNULL(MAX(DB_MSG_SEQUENCIA), 0) + 1 FROM DB_MENSAGEM  WHERE DB_MSG_REPRES = @V_PED_REPRES),
														GETDATE(),
														@P_USUARIO,
														1,
														@P_NRO,
														5
														)
							END
						   --IF ISNULL(@P_USUARIO, '') <> ''
							  SET @V_ENV_WORKFLOW = 18;
						 --- BUSCA STATUS DA ALÇADA
							SET @V_STATUS_PED = 0;
								SELECT @V_STATUS_PED = DB_ALCP_STATUS_ALCADA
									FROM DB_ALCADA_PED, DB_STATUS
								WHERE DB_ALCP_CODIGO = @V_ALCP_CODIGO
									AND DB_ALCP_STATUS_ALCADA = DB_STATUS.CODIGO
									AND GETDATE() BETWEEN DATA_INICIAL AND DATA_FINAL;				
							--- SOMENTE ATUALIZA SE O STATUS FOR DIFERENTE DE NULL E ZERO            
							IF @V_STATUS_PED <> 0 AND ISNULL(@V_STATUS_PED, '') <> ''
							BEGIN
								--- SE HOUVER ALTERAÇÃO DE STATUS, DEVE GRAVAR UMA MENSAGEM
								IF @V_STATUS_PED <> @V_STATUS_PED_ATUAL
								BEGIN
									INSERT INTO DB_MENSAGEM (
															DB_MSG_REPRES,
															DB_MSG_SEQUENCIA,
															DB_MSG_DATA,
															DB_MSG_USU_ENVIO,
															DB_MSG_PEDIDO,
															DB_MSG_TEXTO)
													VALUES (
															@V_PED_REPRES,
															ISNULL((SELECT MAX(DB_MSG_SEQUENCIA) FROM DB_MENSAGEM WHERE DB_MSG_REPRES = @V_PED_REPRES), 0) + 1, 
															GETDATE(),
															@P_USUARIO,
															@P_NRO,
															'Liberação de pedido: novo status do pedido: ' +
															ISNULL((SELECT DESCRICAO FROM DB_STATUS WHERE CODIGO = @V_STATUS_PED), '[SEM STATUS]') +
															'. Status anterior: '  +
															ISNULL((SELECT DESCRICAO FROM DB_STATUS WHERE CODIGO = @V_STATUS_PED_ATUAL), '[SEM STATUS]')
															);                                            
								END  
									---ATUALIZA O STATUS DO PEDIDO
								UPDATE DB_PEDIDO_COMPL
									SET DB_PEDC_STATUSPED = @V_STATUS_PED
									WHERE DB_PEDC_NRO = @P_NRO;                 
							END
							ELSE
							BEGIN
								--CASO A ALÇADA NÃO TENHA UM STATUS INFORMADO OU NÃO SEJA MAIS VÁLIDO
								--VERIFICAR SE O STATUS ATUAL DO PEDIDO AINDA É VALIDO, CASO NÃO SEJA SETAR ZERO
								IF @V_STATUS_PED_ATUAL <> 0 AND ISNULL(@V_STATUS_PED_ATUAL, '') <> ''
								BEGIN
									SET @V_STATUS_VALIDO = 0;
									SELECT @V_STATUS_VALIDO = 1
										FROM DB_STATUS
										WHERE DB_STATUS.CODIGO = @V_STATUS_PED_ATUAL
										AND CAST(GETDATE() AS DATE) BETWEEN DATA_INICIAL AND DATA_FINAL;
									IF @V_STATUS_VALIDO = 0
									BEGIN
										UPDATE DB_PEDIDO_COMPL
											SET DB_PEDC_STATUSPED = 0
											WHERE DB_PEDC_NRO = @P_NRO;  
									END
								END
							END
						 END
						 SET @V_DESCRICAO = @V_PROGRAMA + ' ENCAMINHOU PEDIDO PARA SUPERIOR. PEDIDO NRO: ' + CAST(@P_NRO AS VARCHAR);
					END
				SET @V_PASSO = 32;	
			 END --FIM - @V_PERMITE_ENCAMINHAR = 0
		 END   -- IF QUANDO TEM MOTIVOS QUE NAO PRECISAM SER BLOQUEADOS     
	  END -- @VDB_PED_CLIENTE IS NULL
	END -- @V_PED_CLIENTE IS NOT NULL
	IF (@V_PERMITE_LOG = 1)--- AND (ISNULL(@P_USUARIO, '') <> '')
	BEGIN
	    IF ISNULL(@P_USUARIO, '') = ''
		BEGIN
			SET @V_USUARIO_PARA_LOG = 'SEM USUÁRIO'
		END
		ELSE
		BEGIN
			SET @V_USUARIO_PARA_LOG = @P_USUARIO
		END		
		SET @V_COMPLEMENTO_LOG = SUBSTRING(' (' + CAST( @P_NRO AS VARCHAR)
									+ '-' + CAST( @P_EXCLUI AS VARCHAR)
									+ '-' + @V_USUARIO_PARA_LOG
									+ '-' + CAST( @P_ACAO AS VARCHAR)
									+ '-' + ISNULL(@P_CODIGOJUSTIFICATIVA, 'NULL')
									+ '-' + ISNULL(@P_OBSERVACAOJUSTIFICATIVA, 'NULL')
									+ '-' + CAST( ISNULL(@P_REPRESJUSTIFICATIVA, 0) AS VARCHAR) + ')', 1, 800)
		IF @V_PED_WEB = 1
		BEGIN
			INSERT INTO MSL1
			  (SL1_DATA, -- DATA ATUAL
			   SL1_USUARIO, --= USUÁRIO DA LIBERAÇÃO
			   SL1_MENU, --= 0
			   SL1_ITEM_MENUWEB, --= "LIBERAÇÃO DE PEDIDOS"
			   SL1_ACAO, --= 4
			   SL1_DESCRICAO)
			VALUES
			  (GETDATE(), @V_USUARIO_PARA_LOG, 0, 'Liberação de pedidos', 4, isnull(@V_DESCRICAO, '')  + '  ' + RTRIM(LTRIM(@V_COMPLEMENTO_LOG)));
		END
		ELSE
		BEGIN
			INSERT INTO MSL1
			  (SL1_DATA, -- DATA ATUAL
			   SL1_USUARIO, --= USUÁRIO DA LIBERAÇÃO
			   SL1_MENU, --= 0
			   SL1_MENUITEM, --= "LIBERAÇÃO DE PEDIDOS"
			   SL1_ACAO, --= 4
			   SL1_DESCRICAO)
			VALUES
			  (GETDATE(), @V_USUARIO_PARA_LOG, 0, 'Liberação de pedidos', 4, isnull(@V_DESCRICAO, '')  + '  ' + RTRIM(LTRIM(@V_COMPLEMENTO_LOG)));
		END
    END
  ------------------------------------------------------------------------------------
  ---  GERA WORKFLOW DE PEDIDOS LIBERADOS TOTAL OU ENVIADOS PARA A PROXIMA ALCADA
  ------------------------------------------------------------------------------------
  IF @V_ENV_WORKFLOW > 0
  BEGIN
     SET @V_PASSO = '33';
     EXEC MERCP_WORKFLOW @V_ENV_WORKFLOW,
                         @V_PED_CLIENTE,
                         @P_NRO,
                         @V_PED_EMPRESA,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         @P_USUARIO,
                         @VRETORNO;
  END
  COMMIT
	END TRY
	BEGIN CATCH
	    ROLLBACK
		SET @VDATA = GETDATE();
		SET @VERRO = 'ERRO AO LIBERAR O PEDIDO :' + CONVERT(VARCHAR, @P_NRO) + ' -PASSO:' + ISNULL(@V_PASSO, '') + ' ' + ERROR_MESSAGE();
		INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, @VDATA, @VOBJETO);
    --COMMIT;
	END CATCH
END -- FIM PROGRAMA
