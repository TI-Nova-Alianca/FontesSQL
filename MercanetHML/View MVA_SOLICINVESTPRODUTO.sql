---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR   ALTERACAO
-- 1.0001	02/01/2017	TIAGO 	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SOLICINVESTPRODUTO AS
select SOLIC_INVESTIMENTO	solicitacao_SIPROD
	  ,SEQUENCIA			sequencia_SIPROD
	  ,PRODUTO				produto_SIPROD
	  ,TIPO					tipo_SIPROD
	  ,MARCA				marca_SIPROD
	  ,FAMILIA				familia_SIPROD
	  ,GRUPO				grupo_SIPROD
	  ,MVA_SOLICITACOESINVESTIMENTO.usuario
  from DB_SOLIC_INVESTIMENTO_PROD, 
       MVA_SOLICITACOESINVESTIMENTO
 where numero_SOLINV = SOLIC_INVESTIMENTO
