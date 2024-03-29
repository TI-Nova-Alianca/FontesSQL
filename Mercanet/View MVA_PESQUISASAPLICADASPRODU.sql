---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	27/05/2016	TIAGO PRADELLA	CRIACAO
-- 1.0002   06/09/2016  tiago           incluido campo ordem
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PESQUISASAPLICADASPRODU AS
SELECT PROD.CODIGO   CODPESQUISAAPLICADA_PESAPPRO,
       PRODUTO       PRODUTO_PESAPPRO,
	   ORDEM         ORDEM_PESAPPRO,
	   USU.USUARIO
  FROM DB_PESQ_APLICADAS_PRODUTOS PROD, DB_USUARIO USU
 WHERE PROD.CODIGO IN (SELECT P.CODIGO_PESAPLI
                         FROM MVA_PESQUISASAPLICADAS P
				        WHERE USU.USUARIO = P.USUARIO)
