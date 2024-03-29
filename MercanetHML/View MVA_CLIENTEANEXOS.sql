ALTER VIEW MVA_CLIENTEANEXOS  AS
select
	   codigo_cliente		cliente_CLIAN,
	   sequencia			sequencia_CLIAN,
	   descricao			descricao_CLIAN,
	   nome_arquivo			nomeArquivo_CLIAN,
	   data_atualizacao		dataAtualizacao_CLIAN,
	   excluido             excluido_CLIAN,
	   1					sincronizacao_CLIAN,
	   getdate()			dataEnvio_CLIAN,
	   CNPJ_CLIEN           cnpj_CLIAN,
	   data_atualizacao     dataalter,
	   usuario
  from DB_CLIENTE_ANEXOS,
       MVA_CLIENTE
 where CODIGO_CLIEN = codigo_cliente
 union all
 select
	   codigo_cliente		cliente_CLIAN,
	   sequencia			sequencia_CLIAN,
	   descricao			descricao_CLIAN,
	   nome_arquivo			nomeArquivo_CLIAN,
	   data_atualizacao		dataAtualizacao_CLIAN,
	   excluido             excluido_CLIAN,
	   1					sincronizacao_CLIAN,
	   getdate()			dataEnvio_CLIAN,
	   ''                   cnpj_CLIAN,
	   data_atualizacao     dataalter,
	   usuario
  from DB_CLIENTE_ANEXOS,
       db_usuario
 where EXCLUIDO = 1
   and not exists (select * from db_cliente where db_cli_codigo = CODIGO_CLIENTE)
