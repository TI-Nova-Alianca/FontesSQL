ALTER VIEW MVA_AGENDA AS
with valida_rota as (SELECT isnull(DB_PRMS_VALOR, 0) VALOR FROM DB_PARAM_SISTEMA WHERE DB_PARAM_SISTEMA.DB_PRMS_ID = 'AGENDA_FORMATOVISROTA')
 select DB_AG_AGENDA.CODIGO			codigo_AGE,
		CODIGO_CONFIG	codigoConfig_AGE,
		DESCRICAO		descricao_AGE,
		SITUACAO		situacao_AGE,
		getdate()		dataEnvio_AGE,
		0				sincronizacao_AGE,
		agusu.USUARIO
   from DB_AG_AGENDA, DB_AG_USUARIOS agusu, DB_USUARIO usu
  where agusu.CODIGO_AGENDAMENTO = DB_AG_AGENDA.CODIGO
	and usu.USUARIO = agusu.USUARIO
    and cast(getdate() as date) between cast(agusu.DATA_INICIO as date) and cast(isnull(agusu.DATA_FINAL, getdate() + 1) as date)
    and isnull(agusu.EXCLUIDO, 0) = 0
	and ((isnull((SELECT VALOR_NUM VALOR FROM DB_FILTRO_GRUPOUSU WHERE DB_FILTRO_GRUPOUSU.ID_FILTRO = 'FORMATOVISROTA' and DB_FILTRO_GRUPOUSU.CODIGO_GRUPO = usu.GRUPO_USUARIO), 0) = 0 and (select valor from valida_rota) = 1)
	or isnull((SELECT VALOR_NUM VALOR FROM DB_FILTRO_GRUPOUSU WHERE DB_FILTRO_GRUPOUSU.ID_FILTRO = 'FORMATOVISROTA' and DB_FILTRO_GRUPOUSU.CODIGO_GRUPO = usu.GRUPO_USUARIO), 0) = 2)
