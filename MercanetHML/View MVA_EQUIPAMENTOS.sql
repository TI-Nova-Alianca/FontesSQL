---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	05/03/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_EQUIPAMENTOS  AS
 SELECT DB_EQUI_CODIGO	      CODIGO_EQUI,
		DB_EQUI_DESCRICAO	  DESCRICAO_EQUI,
		DB_EQUI_PESO	      PESOMAXIMO_EQUI,
		DB_EQUI_PERCMINCARGA  PERCENTUALMINCARGA_EQUI,
		T.USUARIO
   FROM DB_EQUIPAMENTOS,
        MVA_TRANSPEQUIPAMENTOS T
  WHERE DB_EQUI_CODIGO = T.CODIGOEQUIPAMENTO_TRANE
