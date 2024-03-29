---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	08/05/2014	TIAGO PRADELLA	CRIACAO
-- 1.0001   19/05/2014  tiago			trunc na data de precisao
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTESPEDIDOS as
select DB_PED_CLIENTE      cliente_CLIPED,		
	   DB_PED_NRO          pedido_CLIPED,	
	   cast(DB_PED_DT_PREVENT as date)   dataPrevisao_CLIPED,
	   DB_PED_ENT_ENDER    localEntrega_CLIPED,
	   (SELECT distinct	COALESCE(
								(SELECT distinct  db_pedi_tipo  db_pedi_tipo
								   FROM db_pedido_prod AS O
								  WHERE O.db_pedi_pedido  = C.db_pedi_pedido								  
								    FOR XML PATH(''), TYPE).value('.[1]', 'VARCHAR(MAX)'), '') AS Produtos
		  FROM DB_PEDIDO_PROD AS C
		 where db_pedi_pedido = db_ped_nro)   tipo_CLIPED,
	   mva_cliente.USUARIO  usuario
  from DB_PEDIDO, mva_cliente
 where codigo_clien = db_ped_cliente
   and DB_PED_DT_PREVENT >= getdate()
