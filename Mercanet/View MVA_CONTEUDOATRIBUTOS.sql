---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	19/05/2015	TIAGO PRADELLA	CRIACAO
-- 1.0001   20/04/2017  tiago           retirado relacionamento com os atributos, porque esta duplicando registros
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CONTEUDOATRIBUTOS AS
SELECT AT03_ATRIB     ATRIBUTO_CATRI,
       AT03_CODIGO    CODIGO_CATRI,
	   AT03_DESCRICAO DESCRICAO_CATRI
  FROM MAT03
 where MAT03.AT03_SITUACAO = 0
