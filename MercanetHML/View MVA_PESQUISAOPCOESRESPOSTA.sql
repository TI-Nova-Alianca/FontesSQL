---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	26/06/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PESQUISAOPCOESRESPOSTA AS
 SELECT CODIGO_PESQUISA      PESQUISA_PEMO,
        SEQUENCIA_PERGUNTA   SEQUENCIAPERGUNTA_PEMO,
        SEQUENCIA            SEQUENCIA_PEMO,
        RESPOSTA             RESPOSTA_PEMO,
        PP.USUARIO
   FROM DB_PESQUISAMERCOPCRESP PR, MVA_PESQUISAMERCPERGUNTAS PP
  WHERE PP.PESQUISA_PESMP  = PR.CODIGO_PESQUISA
    AND PP.SEQUENCIA_PESMP = PR.SEQUENCIA_PERGUNTA
