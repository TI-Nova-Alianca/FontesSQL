ALTER VIEW MVA_DISTRIBUIDORES AS
 select EM01_CODIGO	    codigo_DISTR,
		DB_TBREP_NOME	nome_DISTR,
		EM01_PEDMINIMO  pedidoMinimo_DISTR,
		DB_TBREP_UF     estado_DISTR,
		usu.usuario
   from MEM01, db_tb_repres, db_usuario usu
  where em01_codigo = db_tbrep_codigo
    and exists (select * from MVA_REPRESENTANTES repres where repres.usuario = usu.usuario and charindex (',' + cast(EM01_CODIGO as varchar) + ',', ',' + listaDistribuidores_REPRES  + ',') > 0 )
	union 
	select EM01_CODIGO	    codigo_DISTR,
		DB_TBREP_NOME	nome_DISTR,
		EM01_PEDMINIMO  pedidoMinimo_DISTR,
		DB_TBREP_UF     estado_DISTR,
		usu.usuario
   from MEM01, db_tb_repres, db_usuario usu
  where em01_codigo = db_tbrep_codigo
    and exists (select 1 from MVA_REPRESENTANTES repres where repres.usuario = usu.usuario and isnull(listaDistribuidores_REPRES, '') = '')
