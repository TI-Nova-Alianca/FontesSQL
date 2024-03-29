---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   05/11/2012  TIAGO PRADELLA  INCLUIDO CAMPO DB_CLIR_OPER_BON
-- 1.0003   08/11/2012  TIAGO PRADELLA  INCLUIDO DATA DE ALTERACAO
-- 1.0004   14/11/2012  TIAGO PRADELLLA INCLUIDO CAMPO COND PAG BONIFICACAO
-- 1.0005   21/11/2012	TIAGO PRADELLA  INCLUIDO CAMPO PORTADOR
-- 1.0006   28/05/2013  tiago           incluido campo de desconto
-- 1.0007   03/09/2013  tiago           incluido campos de CPGTOFIXA, LPRECOFIXA
-- 1.0008   27/11/2013  tiago           incluido campo tipo frete
-- 1.0009   30/09/2014  tiago           incluido ligacao com a mva_cliente ao invez da db_cliente
-- 1.0010   14/05/2015  tiago           retirado campo rota
-- 1.0011   29/07/2015  tiago           incluido campo ramo
-- 1.0012   18/09/2015  tiago	        incluido campo classificacaoComercial_CLCON
-- 1.0013   21/12/2015  tiago           incluido campo listaPrecoBonificacao_CLCON
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTECONFIGURACOES AS
   SELECT  DB_CLIR_CLIENTE				CLIENTE_CLCON,
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
		  DATAALTER,
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
		  DB_CLIR_PREPOSTO				PREPOSTO_CLCON,
          r.USUARIO
     FROM DB_CLIENTE_REPRES, MVA_REPRESENTANTES r, mva_cliente cli
    WHERE DB_CLIR_REPRES = r.CODIGO_REPRES
	  and db_clir_cliente = cli.CODIGO_CLIEN
	  and r.usuario = cli.usuario
