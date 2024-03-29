---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	27/05/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRODUTOSPARAPESQUISAS AS
SELECT PROD.CODIGO   CODIGO_PEPROD,
       DESCRICAO     DESCRICAO_PEPROD,
	   USU.USUARIO
  FROM DB_PESQ_PRODUTOS PROD, DB_USUARIO USU
 WHERE PROD.CODIGO IN (SELECT PPROD.PRODUTO_PESAPPRO
                         FROM MVA_PESQUISASAPLICADASPRODU PPROD
						WHERE PPROD.USUARIO = USU.USUARIO)
