---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	09/02/2017	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_DASHBOARDS AS
 select DB_DASHBOARD.CODIGO		dashboard_DASH,
		DESCRICAO				descricao_DASH,
		COLUNAS_MOBILE			colunasMobile_DASH,
		usu.usuario
   from DB_DASHBOARD,
        DB_DASHBOARD_USUARIO,
	    db_usuario usu
  where DB_DASHBOARD_USUARIO.USUARIO = usu.CODIGO
    and DB_DASHBOARD_USUARIO.CODIGO = DB_DASHBOARD.CODIGO
union
 select DB_DASHBOARD.CODIGO		dashboard_DASH,
		DESCRICAO		descricao_DASH,
		COLUNAS_MOBILE	colunasMobile_DASH,
		usu.usuario
   from DB_DASHBOARD,
        DB_DASHBOARD_USUARIO,
	    db_usuario usu
  where DB_DASHBOARD_USUARIO.GRUPO_USUARIO = usu.GRUPO_USUARIO
   and DB_DASHBOARD_USUARIO.CODIGO = DB_DASHBOARD.CODIGO
