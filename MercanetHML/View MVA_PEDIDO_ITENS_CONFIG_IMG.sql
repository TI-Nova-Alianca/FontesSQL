ALTER VIEW  MVA_PEDIDO_ITENS_CONFIG_IMG AS
SELECT IMG.PEDIDO                pedido_PEDITCI,
	   IMG.SEQUENCIA        	 sequencia_PEDITCI,
	   IMG.CODIGO_IMG            codigoImg_PEDITCI,
	   IMG.DESCRICAO_IMG         descricao_PEDITCI,
	   PED.dataalter			 dataalter,
	   PED.usuario        		 usuario
  FROM DB_PEDIDO_ITEM_CONFIG_IMG IMG,
	   MVA_PEDIDOS PED
 WHERE IMG.PEDIDO = PED.codigo_PEDID
