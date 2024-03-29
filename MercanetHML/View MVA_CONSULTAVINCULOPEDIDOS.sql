---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	22/04/2016	TIAGO PRADELLA	CRIACAO
-- 1.0002   29/04/2016  tiago           filtra pelo tipo 2, mobile
-- 1.0003   24/05/2016  tiago           enviar subconsulta
-- 1.004    21/06/2016  tiago           envia campo tipo e retirado do where
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CONSULTAVINCULOPEDIDOS AS
SELECT CODIGO            CODIGO_VINPED,
       NOME              NOME_VINPED,
	   CONSULTA          CONSULTA_VINPED,
	   SUBCONSULTA       SUBCONSULTA_VINPED,
	   COLUNA_VINCULO    COLUNAVINCULO_VINPED,
	   COLUNA_CONSULTA   COLUNACONSULTA_VINPED,
	   V.TIPO            TIPO_VINPED,
	   V.TIPO_VINCULO    TIPOVINCULO_VINPED,
       USUARIO
  FROM DB_CONS_VINCULO_PEDIDOS V, 
       MVA_CONSULTAS C
 WHERE (C.CODIGO_CONSU = V.CONSULTA or C.CODIGO_CONSU = V.subconsulta)
