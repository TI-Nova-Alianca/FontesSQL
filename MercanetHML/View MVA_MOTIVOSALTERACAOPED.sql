ALTER VIEW MVA_MOTIVOSALTERACAOPED AS
 select CODIGO		codigo_MOTALT,
		DESCRICAO	descricao_MOTALT,
		SITUACAO	situacao_MOTALT
   from DB_MOTIVO_ALTER_PEDIDO
  where SITUACAO = 1
