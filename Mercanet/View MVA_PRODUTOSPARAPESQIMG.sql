---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	27/05/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRODUTOSPARAPESQIMG AS
SELECT CODIGO_PRODUTO   CODIGOPRODUTO_PEPRODI,
       SEQUENCIA		SEQUENCIA_PEPRODI,
	   cast(SEQUENCIA as varchar) + '.pngm'    IMAGEM_PEPRODI,
	   USU.USUARIO
  FROM DB_PESQ_PRODUTOS_IMG, 
       DB_USUARIO USU
 WHERE CODIGO_PRODUTO IN (SELECT PP.CODIGO_PEPROD
                            FROM MVA_PRODUTOSPARAPESQUISAS PP
						   WHERE USU.USUARIO = PP.USUARIO)
