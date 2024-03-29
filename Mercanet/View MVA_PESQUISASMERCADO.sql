---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	25/06/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PESQUISASMERCADO AS
 SELECT P.CODIGO       CODIGO_PESM,
        DESCRICAO      DESCRICAO_PESM,
        DATAVALINI     VALIDADEINICIAL_PESM,
        DATAVALFIM     VALIDADEFINAL_PESM,
        TIPO_PESQUISA  TIPO_PESM,
        USU.USUARIO
   FROM DB_USUARIO USU,
        DB_PESQUISAMERC P,
        DB_PESQUISAMERCUSUARIOS PU
  WHERE P.CODIGO = PU.CODIGO_PESQUISA
    AND USU.CODIGO = PU.USUARIO
    AND P.DATAVALFIM >= getdate()
