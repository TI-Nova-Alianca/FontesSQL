ALTER VIEW MVA_ORCAMENTOOBRAS AS
 select ORCAMENTO			orcamento_OOBRA,
		OBRA				obra_OOBRA,
		LINHA_CONCORRENTE	linhaConcorrente_OOBRA,
		MVA_ORCAMENTOS.dataalter,
		MVA_ORCAMENTOS.usuario
   from db_orcamento_obra, MVA_ORCAMENTOS
  where MVA_ORCAMENTOS.numero_ORC = ORCAMENTO
