---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR   ALTERACAO
-- 1.0001	02/01/2017	TIAGO 	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SOLICITACOESINVESTIMENTO AS
	select NUMERO					numero_SOLINV
		  ,DESCRICAO   				descricao_SOLINV
		  ,DATA_INICIAL				dataInicial_SOLINV
		  ,DATA_FINAL				dataFinal_SOLINV
		  ,SITUACAO					situacao_SOLINV
		  ,TIPO						tipo_SOLINV
		  ,REPRESENTANTE			representante_SOLINV
		  ,CLIENTE					cliente_SOLINV
		  ,SELECIONAR_CLIENTE		selecionarCliente_SOLINV
		  ,VALOR					valor_SOLINV
		  ,OBSERVACAO				observacao_SOLINV
		  ,TIPO_AVALIACAO			tipoAvaliacao_SOLINV
		  ,USUARIO_CRIACAO			usuarioCriacao_SOLINV
		  ,DATA_CRIACAO				dataCriacao_SOLINV
		  ,USUARIO_ALTERACAO		usuarioAlteracao_SOLINV
		  ,DATA_ALTERACAO			dataAlteracao_SOLINV
		  ,indice_desconto			indiceDesconto_SOLINV
		  ,tipo_indice_desconto		tipoIndiceDesconto_SOLINV
		  ,0                        saldo_SOLINV
		  ,cli.usuario
		  ,getdate()                dataEnvio_SOLINV
	 from DB_SOLIC_INVESTIMENTO, MVA_CLIENTE cli
	where SITUACAO = 1
	  and cast(DATA_FINAL as date) >= cast(getdate() as date)
	  and cli.CODIGO_CLIEN = CLIENTE
	  and (PEDIDO = 0 or isnull(PEDIDO, '') = '')
