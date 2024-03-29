---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	22/05/2015	TIAGO PRADELLA	CRIACAO
-- 1.0002   22/06/2015  tiago           retorna registro quando cliente deletado
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTESIMAGENS AS
 SELECT CODIGO_CLIENTE     CLIENTE_CLIIMG,
		ORDEM              ORDEM_CLIIMG,
		NOME_ARQUIVO       NOMEIMAGEM_CLIIMG,
		DESCRICAO          DESCRICAO_CLIIMG,
		IMAGEM_PRINCIPAL   IMAGEMPRINCIPAL_CLIIMG,
		DATA_ATUALIZACAO   DATAATUALIZACAO_CLIIMG,
		EXCLUIDO           EXCLUIDO_CLIIMG,
		1                  SINCRONIZACAO_CLIIMG,
		GETDATE()          DATAENVIO_CLIIMG,
		CLI.CNPJ_CLIEN     CNPJ_CLIIMG,
		DATA_ATUALIZACAO   DATAALTER,
		CLI.USUARIO
   FROM DB_CLIENTE_IMAGENS, MVA_CLIENTE CLI
  WHERE CLI.CODIGO_CLIEN = CODIGO_CLIENTE    
  union all
  SELECT CODIGO_CLIENTE     CLIENTE_CLIIMG,
		ORDEM              ORDEM_CLIIMG,
		NOME_ARQUIVO       NOMEIMAGEM_CLIIMG,
		DESCRICAO          DESCRICAO_CLIIMG,
		IMAGEM_PRINCIPAL   IMAGEMPRINCIPAL_CLIIMG,
		DATA_ATUALIZACAO   DATAATUALIZACAO_CLIIMG,
		EXCLUIDO           EXCLUIDO_CLIIMG,
		1                  SINCRONIZACAO_CLIIMG,
		GETDATE()          DATAENVIO_CLIIMG,
		''     CNPJ_CLIIMG,
		DATA_ATUALIZACAO   DATAALTER,
	    usuario
   FROM DB_CLIENTE_IMAGENS, db_usuario
  where EXCLUIDO = 1
    and not exists (select * from db_cliente where db_cli_codigo = CODIGO_CLIENTE)
