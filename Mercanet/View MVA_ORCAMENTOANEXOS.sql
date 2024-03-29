ALTER VIEW MVA_ORCAMENTOANEXOS AS
 select ORCAMENTO			orcamento_ORCAN,
		SEQUENCIA			sequencia_ORCAN,
		DESCRICAO			descricao_ORCAN,
		NOME_ARQUIVO		nomeArquivo_ORCAN,
		DATA_ATUALIZACAO	dataAtualizacao_ORCAN,
		EXCLUIDO			excluido_ORCAN,
		o.dataalter,
		o.usuario
   from db_orcamento_anexos
      , MVA_ORCAMENTOS o
  where ORCAMENTO = o.numero_ORC
