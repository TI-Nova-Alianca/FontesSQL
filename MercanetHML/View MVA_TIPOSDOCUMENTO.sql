ALTER VIEW MVA_TIPOSDOCUMENTO  AS
 select tp.codigo			codigo_TPDOC,
		documento			documento_TPDOC,
		descricao			descricao_TPDOC,
		data_validade		dataValidade_TPDOC,
		anexo				anexo_TPDOC,
		autorizacao			autorizacao_TPDOC,
		obrigatorio			obrigatorio_TPDOC,
		grp_itens_control	grupoItensControlados_TPDOC,
		case when (isnull(grupos_incluir, '') like  cast(grupo_usuario as varchar) + ',%' or  isnull(grupos_incluir, '') like '%,' + cast(grupo_usuario as varchar) + ',%' or  isnull(grupos_incluir, '') like  '%,' + cast(grupo_usuario as varchar) or isnull(grupos_incluir, '') = cast(grupo_usuario as varchar) or isnull(isnull(grupos_incluir, ''), '') = '')
		     then 1
			 else 0 end incluir_TPDOC,
	   case when (isnull(grupos_editar, '') like  cast(grupo_usuario as varchar) + ',%' or  isnull(grupos_editar, '') like '%,' + cast(grupo_usuario as varchar) + ',%' or  isnull(grupos_editar, '') like  '%,' + cast(grupo_usuario as varchar) or isnull(grupos_editar, '') = cast(grupo_usuario as varchar) or isnull(isnull(grupos_editar, ''), '') = '')
		     then 1
			 else 0 end editar_TPDOC,
	   case when (isnull(grupos_autorizar, '') like  cast(grupo_usuario as varchar) + ',%' or  isnull(grupos_autorizar, '') like '%,' + cast(grupo_usuario as varchar) + ',%' or  isnull(grupos_autorizar, '') like  '%,' + cast(grupo_usuario as varchar) or isnull(grupos_autorizar, '') = cast(grupo_usuario as varchar) or isnull(isnull(grupos_autorizar, ''), '') = '')
		     then 1
			 else 0 end autorizar_TPDOC,
		perm_editinclu		permissaoEditIncl_TPDOC,
		usuario
   from db_tipos_documento tp
      , db_usuario
  where SITUACAO = 1
