---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	16/03/2017	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_AREASABASSOLICINV AS
 select area.GRUPO_USUARIO	grupoUsuario_AREASOL,
		area.ABA			aba_AREASOL,
		area.AREA			area_AREASOL,
		area.COLUNAS		colunas_AREASOL,
		area.ORDEM			ordem_AREASOL,
		usu.usuario
   from DB_MOB_AREAS_ABAS_SOLICINV area, DB_USUARIO USU, DB_GRUPO_USUARIOS GRUPO
  WHERE USU.GRUPO_USUARIO = GRUPO.CODIGO
    AND area.GRUPO_USUARIO = USU.GRUPO_USUARIO
    AND area.ABA IN (SELECT ABA 
                       FROM MVA_ABASSOLICINV ABA2
					  WHERE USU.USUARIO = ABA2.USUARIO)
