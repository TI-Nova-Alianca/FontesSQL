---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	22/11/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PEDIDOAUTOMATICO AS
SELECT CODIGO         CODIGO_PEDAU,
       NOME           NOME_PEDAU,
	   DESCRICAO      DESCRICAO_PEDAU,
	   CONSULTA       CONSULTA_PEDAU,
	   SISTEMA        SISTEMA_PEDAU,
	   DISPONIVEL     DISPONIVEL_PEDAU,
	   CON.USUARIO
  FROM DB_MOB_PED_AUTOMAT, MVA_CONSULTAS CON
 WHERE CONSULTA = CON.CODIGO_CONSU
   AND (SISTEMA IS NULL OR SISTEMA IN (0, 2))
