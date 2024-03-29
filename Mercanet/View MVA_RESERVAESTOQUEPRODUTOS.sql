ALTER VIEW MVA_RESERVAESTOQUEPRODUTOS  AS
 select CODIGO_RESERVA					codigoReserva_RESP,
		res.PRODUTO						produto_RESP,
		QTDE_RESERVADA - QTDE_VENDIDO	saldoReserva_RESP,
		prd.USUARIO
   from DB_EST_RESERVAPRODUTO res
      , MVA_RESERVAESTOQUECLIENTES rede
	  , DB_PRODUTO_USUARIO  prd
  where prd.USUARIO    = rede.usuario
    and CODIGO_RESERVA = rede.codigo_RESC
	and prd.produto = res.PRODUTO
