ALTER VIEW MVA_LUCRAREGRASBLOQUEIO AS
 select codigo            codigo_RBLOQ,
		sequencia		  sequencia_RBLOQ,
		acao_pedido		  acaoPedido_RBLOQ,
		acao_acumulado	  acaoAcumulado_RBLOQ,
		acao_realizar	  acaoRealizar_RBLOQ
  from db_luc_regrasbloqacao
