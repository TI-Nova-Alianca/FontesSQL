---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	06/10/2020	ELTON FERRONATO	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTECONFIGURACOES_REDE AS
   SELECT DB_CLIR_CLIENTE				CLIENTE_CLCON,
          DB_CLIR_EMPRESA				EMPRESA_CLCON,
		  DB_CLIR_REPRES                REPRESENTANTE_CLCON,
          DB_CLIR_COND_PGTO				CONDICAOPAGAMENTO_CLCON,
          DB_CLIR_OPERACAO				OPERACAOVENDA_CLCON,
          DB_CLIR_TRANSP				TRANSPORTADOR_CLCON,
          ISNULL (DB_CLIR_REDESP, 0)	REDESPACHO_CLCON,
          DB_CLIR_TIPO_FRETE			TIPOFRETE_CLCON,
          DB_CLIR_LPRECO				LISTAPRECO_CLCON,
          --ISNULL (DB_CLIR_ROTA, 0)		ROTA_CLCON,
          ISNULL(DB_CLIR_PADRAO,0)		PADRAO_CLCON,
          ISNULL(DB_CLIR_PRAZO_MAX,-1)  PRAZOMEDIOMAXIMO_CLCON,
          DB_CLIR_SITUACAO              SITUACAO_CLCON,		  
		  DB_CLIR_OPER_BON              OPERACAOBONIFICACAO_CLCON,
		  DB_CLIR_CPGTO_BON             CONDICAOPAGAMENTOBONIF_CLCON,
		  DB_CLIR_PORTADOR              PORTADOR_CLCON,
		  DB_CLIR_DESCTO                DESCONTO_CLCON,
		  DB_CLIR_CPGTOFIXA             CPGTOFIXA_CLCON,
		  DB_CLIR_LPRECOFIXA			LISTAPRECOFIXA_CLCON,
		  DB_CLIR_TP_REDESP             TIPOFRETEREDESP_CLCON,
		  DB_CLIR_RAMO                  RAMO_CLCON,
		  DB_CLIR_CLASCOM               classificacaoComercial_CLCON,
		  DB_CLIR_LPRECO_BON            listaPrecoBonificacao_CLCON,
		  DB_CLIR_TPPEDIDO              tipoPedido_CLCON,
		  DB_CLIR_REGRA_PREVISAO		regraPrevisao_CLCON,		  
		  DB_CLIR_NROMAXDIAS1           numeroMaxDias1_CLCON,
		  DB_CLIR_PREPOSTO				PREPOSTO_CLCON
     FROM DB_CLIENTE_REPRES
