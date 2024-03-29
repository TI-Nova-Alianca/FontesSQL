ALTER VIEW MVA_RESERVAESTOQUECLIENTES  AS
 select distinct
        codigo			codigo_RESC,
		data_inicial	dataInicial_RESC,
		data_final		dataFinal_RESC,
		empresa			empresa_RESC,
		rede_cliente	redeCliente_RESC,
		almoxarifado	almoxarifado_RESC,
		rede.usuario
   from db_est_reservacliente
      , MVA_REDECLIENTESESTOQUE rede
  where rede.codigo_RCLIE = rede_cliente    
	and convert( date, data_final) >= cast(getdate() as date)
