
---------------------------------------------------------------------------------------------------
-- VERSAO  DATA	       AUTOR	   ALTERACAO
-- 1.0001  14/07/2016  ALENCAR     DESENVOLVIMENTO - criado relacionamento com a MVA_PRODUTOS para enviar apenas 
--                                     registros de produtos que o repres recebe
---------------------------------------------------------------------------------------------------



ALTER VIEW MVA_PRODUTOSOPERACAOREFER_V3 AS
with PRODUTO as (SELECT CODIGO_PRODU PRODUTO, USUARIO
                   FROM MVA_PRODUTOS_V3
                  WHERE MVA_PRODUTOS_V3.USUARIO in ( select top 1 usuario
                                                       from DB_USUARIO_SESSIONID
                                                      where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID)))
                   
SELECT DB_TBOPSR_OPER_REF CODIGOOPERACAO_PROPR,
       DB_TBOPSR_SEQ      SEQUENCIA_PROPR,
       DB_TBOPSR_PRODUTO  PRODUTO_PROPR,
       USU.USUARIO
  FROM DB_TB_OPERS_REFER 
     , DB_USUARIO USU
     , PRODUTO
  where USU.USUARIO       = PRODUTO.USUARIO
    and DB_TBOPSR_PRODUTO = PRODUTO.PRODUTO
    
