ALTER VIEW MVA_ROTACLIENTES_AGENDA AS
with valida_rota as (SELECT ISNULL(DB_PRMS_VALOR, 0) VALOR FROM DB_PARAM_SISTEMA WHERE DB_PARAM_SISTEMA.DB_PRMS_ID = 'AGENDA_FORMATOVISROTA')
 select ROTA				codigoAgenda_RCLIAG,
		sequencia			sequencia_RCLIAG,
		CODIGO_ATIVIDADE	codigoAtiv_RCLIAG,
		DATA				dataInicial_RCLIAG,
		DATA_FINAL			dataFinal_RCLIAG,
		titulo				titulo_RCLIAG,
		observacao			observacao_RCLIAG,
		CLIENTE				cliente_RCLIAG,
		DIA_INTEIRO			diaInteiro_RCLIAG,
		EXCLUIDO			excluido_RCLIAG,
		DATA_ATUALIZACAO	dataAtualizacao_RCLIAG,
		getdate()				dataEnvio_RCLIAG,
		ag.USUARIO
   from DB_ROTAS_CLIENTES rota, MVA_AGENDA ag, db_usuario usu
  where rota.ROTA = ag.codigo_AGE
	and usu.USUARIO = ag.USUARIO
	and (exists (select 1 
	               from mva_cliente 
				  where ag.usuario = mva_cliente.USUARIO 
				    and MVA_CLIENTE.CODIGO_CLIEN = rota.CLIENTE) 
				or rota.CLIENTE = 0)
	and ((isnull((SELECT VALOR_NUM VALOR FROM DB_FILTRO_GRUPOUSU WHERE DB_FILTRO_GRUPOUSU.ID_FILTRO = 'FORMATOVISROTA' and DB_FILTRO_GRUPOUSU.CODIGO_GRUPO = usu.GRUPO_USUARIO), 0) = 0 and (select valor from valida_rota) = 1)
	or isnull((SELECT VALOR_NUM VALOR FROM DB_FILTRO_GRUPOUSU WHERE DB_FILTRO_GRUPOUSU.ID_FILTRO = 'FORMATOVISROTA' and DB_FILTRO_GRUPOUSU.CODIGO_GRUPO = usu.GRUPO_USUARIO), 0) = 2)
