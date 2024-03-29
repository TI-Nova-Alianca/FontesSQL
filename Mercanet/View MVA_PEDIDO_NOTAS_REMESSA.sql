---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	08/09/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PEDIDO_NOTAS_REMESSA AS
 select DB_PEDNF_PEDIDO		pedido_NFPR,
		DB_PEDNF_SEQ		sequencia_NFPR,
		DB_PEDNF_NROINI		nroInicialNF_NFPR,
		DB_PEDNF_NROFIN		nroFinalNF_NFPR,
		DB_PEDNF_MODELO		modelo_NFPR,
		DB_PEDNF_SERIE		serie_NFPR,
		MVA_PEDIDOS.usuario,
		MVA_PEDIDOS.dataalter
   from DB_PEDIDO_NF_REM, MVA_PEDIDOS
  where MVA_PEDIDOS.codigo_PEDID = DB_PEDNF_PEDIDO
