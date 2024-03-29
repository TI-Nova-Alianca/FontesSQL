---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	25/06/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PESQUISAMERCPERGUNTAS AS
 SELECT CODIGO_PESQUISA	         PESQUISA_PESMP,
        SEQUENCIA	             SEQUENCIA_PESMP,
        PERGUNTA	             PERGUNTA_PESMP,
        TIPO_RESPOSTA	         TIPORESPOSTA_PESMP,
        OBRIGA_RESP	             OBRIGATORIO_PESMP,
        TAMANHO_RESP	         TAMANHORESPOSTA_PESMP,
        NRODECIMAIS	             NUMERODECIMAIS_PESMP,
        JUSTIFICATIVA	         JUSTIFICATIVA_PESMP,
        PERGUNTA_JUSTIFICATIVA	 PERGUNTAJUSTIFICATIVA_PESMP,
        P.USUARIO
   FROM DB_PESQUISAMERCPERG, MVA_PESQUISASMERCADO P
  WHERE CODIGO_PESQUISA = CODIGO_PESM
