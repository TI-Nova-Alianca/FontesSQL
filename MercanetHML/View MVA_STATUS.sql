ALTER VIEW MVA_STATUS AS
select codigo					codigo_STATUS,
       descricao				descricao_STATUS,
	   db_status.local			local_STATUS,
	   data_inicial				dataInicial_STATUS,
	   data_final				dataFinal_STATUS,
	   apresenta_pedido			apresentaPedido_STATUS,
	   apresenta_tela_status	apresentaTelaStatus_STATUS,
	   BLOQUEIA_COMISSAO		bloqueiaComissao_STATUS 
  from db_status
 where cast(data_final as date) >= cast(getdate() as date)
