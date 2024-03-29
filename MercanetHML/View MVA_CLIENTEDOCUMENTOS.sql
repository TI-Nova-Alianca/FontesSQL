ALTER VIEW MVA_CLIENTEDOCUMENTOS  AS
 select codigo_cliente		codigoCliente_CLIDOC,
		sequencia			sequencia_CLIDOC,
		tipo_documento		tipoDocumento_CLIDOC,
		data_validade		dataValidade_CLIDOC,
		autorizado			autorizado_CLIDOC,
		nome_arquivo		nomeArquivo_CLIDOC,
		observacao			observacao_CLIDOC,
		grp_itens_control	grupoItensControlados_CLIDOC,
		observacao_nf		observacaoNF_CLIDOC,
		excluido			excluido_CLIDOC,
		data_atualizacao	dataAtualizacao_CLIDOC,
		data_autorizacao	dataAutorizacao_CLIDOC,
		usuario_autorizacao	usuarioAutorizacao_CLIDOC,
		getdate()           dataRecebimento_CLIDOC,
		getdate()           dataEnvio_CLIDOC,
		sequencia           sequenciaWeb_CLIDOC,
		DATA_ATUALIZACAO    dataalter,
		usuario
   from db_cliente_documentos
      , MVA_CLIENTE
  where codigo_cliente = CODIGO_CLIEN
