---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	14/11/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MOTIVOSREPOSICAO AS
SELECT DB_MOTR_CODIGO     CODIGO_MOTRE,
       DB_MOTR_DESCRICAO  DESCRICAO_MOTRE
  FROM DB_MOTIVO_REPOS
