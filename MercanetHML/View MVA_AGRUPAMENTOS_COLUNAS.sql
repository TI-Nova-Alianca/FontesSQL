---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	19/09/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_AGRUPAMENTOS_COLUNAS AS
SELECT CONSULTA				CONSULTA_AGRUP,
       SEQUENCIA			SEQUENCIA_AGRUP,
	   NOME_AGRUPAMENTO		NOMEAGRUPMENTO_AGRUP,
	   COLUNAS				COLUNAS_AGRUP,
	   MVA_CONSULTAS.USUARIO
  FROM DB_CONS_AGRUPAMENTOS, MVA_CONSULTAS
 WHERE CONSULTA = MVA_CONSULTAS.CODIGO_CONSU
