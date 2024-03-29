---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	01/08/2017	TIAGO PRADELLA	DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CONSULTACANCELAMENTO  AS
 select codigo					codigo_CONCAN,
		nome					nome_CONCAN,
		consulta				consulta_CONCAN,
		coluna_cancelamento		colunaCancelamento_CONCAN,
		coluna_consulta			colunaConsulta_CONCAN,
		isnull(TIPO, 0)			tipo_CONCAN,
		c.usuario
   FROM MVA_CONSULTAS C
      , DB_MOB_CONS_CANCELAMENTO
  WHERE CONSULTA = CODIGO_CONSU
