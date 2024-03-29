ALTER VIEW MVA_AGENDA_OCORRENCIA AS 
with valida_rota as (SELECT isnull(DB_PRMS_VALOR, 0) VALOR FROM DB_PARAM_SISTEMA WHERE DB_PARAM_SISTEMA.DB_PRMS_ID = 'AGENDA_FORMATOVISROTA')
select tela.codigo_TELA		codigo_AGOCO,
	   tela.descricao_TELA	descricao_AGOCO,
	   tela.tipo_TELA		tela_AGOCO,
	   ORDEM_TELA			ordemTela_AGOCO,
	   usu.usuario
  from DB_FILTRO_USUARIO filtro, 
       MVA_TELAS tela,
	   DB_USUARIO usu
 where ID_FILTRO = 'AGENDA_TELASOCUSU'
   and tela.codigo_TELA = VALOR_NUM
   and filtro.CODIGO_USUARIO = usu.CODIGO
   and tela.usuario = usu.USUARIO
   and ((isnull((SELECT VALOR_NUM VALOR FROM DB_FILTRO_GRUPOUSU WHERE DB_FILTRO_GRUPOUSU.ID_FILTRO = 'FORMATOVISROTA' and DB_FILTRO_GRUPOUSU.CODIGO_GRUPO = usu.GRUPO_USUARIO), 0) = 0 and (select valor from valida_rota) = 1)
   or isnull((SELECT VALOR_NUM VALOR FROM DB_FILTRO_GRUPOUSU WHERE DB_FILTRO_GRUPOUSU.ID_FILTRO = 'FORMATOVISROTA' and DB_FILTRO_GRUPOUSU.CODIGO_GRUPO = usu.GRUPO_USUARIO), 0) = 2)
union all
select tela.codigo_TELA		codigo_AGOCO,
	   tela.descricao_TELA	descricao_AGOCO,
	   tela.tipo_TELA		tela_AGOCO,
	   ORDEM_TELA			ordemTela_AGOCO,
	   usu.usuario
  from DB_FILTRO_GRUPOUSU filtro,
       MVA_TELAS tela,
	   DB_USUARIO usu
 where ID_FILTRO = 'AGENDA_TELAOC'
 and tela.codigo_TELA = VALOR_NUM
   and filtro.CODIGO_GRUPO = usu.GRUPO_USUARIO
   and not exists (select 1 from DB_FILTRO_USUARIO filtroUsu where filtroUsu.CODIGO_USUARIO = usu.CODIGO and ID_FILTRO = 'AGENDA_TELASOCUSU')
   and tela.usuario = usu.USUARIO
   and ((isnull((SELECT VALOR_NUM VALOR FROM DB_FILTRO_GRUPOUSU WHERE DB_FILTRO_GRUPOUSU.ID_FILTRO = 'FORMATOVISROTA' and DB_FILTRO_GRUPOUSU.CODIGO_GRUPO = usu.GRUPO_USUARIO), 0) = 0 and (select valor from valida_rota) = 1)
   or isnull((SELECT VALOR_NUM VALOR FROM DB_FILTRO_GRUPOUSU WHERE DB_FILTRO_GRUPOUSU.ID_FILTRO = 'FORMATOVISROTA' and DB_FILTRO_GRUPOUSU.CODIGO_GRUPO = usu.GRUPO_USUARIO), 0) = 2)
