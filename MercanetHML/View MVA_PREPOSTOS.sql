ALTER VIEW MVA_PREPOSTOS AS
 select db_tb_prt_codigo	codigo_PRT,
		db_tb_prt_repres	repres_PRT,
		db_tb_prt_nome		nome_PRT,
		db_tb_prt_situacao	situacao_PRT,
		db_usuario.usuario
   from DB_TB_PREPOSTO, db_usuario
  where db_tb_prt_repres in (select codigo_repres from MVA_REPRESENTANTES where db_usuario.usuario = MVA_REPRESENTANTES.USUARIO)
