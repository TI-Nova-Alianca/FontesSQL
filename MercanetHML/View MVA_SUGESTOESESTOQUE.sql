---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SUGESTOESESTOQUE  AS
SELECT DB_ACOMPP_CLIENTE   CLIENTE_SUEST,
       DB_ACOMPP_PROD      PRODUTO_SUEST,
       DB_ACOMPP_ESTOQUE   ESTOQUE_SUEST,
        DB_ACOMPP_PROPOSTA SUGESTAO_SUEST,
       DB_ACOMPP_DATA      DATA_SUEST,
	   USU.USUARIO
  FROM DB_ACOMP_PROD,
       DB_USUARIO    USU
 WHERE DB_ACOMPP_CLIENTE IN (SELECT CODIGO_CLIEN
                               FROM MVA_CLIENTE
							  WHERE USUARIO = USU.USUARIO)
