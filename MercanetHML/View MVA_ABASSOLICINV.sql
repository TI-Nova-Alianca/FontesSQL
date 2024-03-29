---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	16/03/2017	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ABASSOLICINV AS
 select aba.grupo_usuario   grupoUsuario_ABASOL,
		aba.aba				aba_ABASOL,
		aba.label			label_ABASOL,
		aba.apresenta_solic apresentaSolic_ABASOL,
		aba.ordem			ordem_ABASOL,
		usu.usuario
   from DB_MOB_ABAS_SOLICINV aba, DB_USUARIO USU, DB_GRUPO_USUARIOS GRUPO 
  WHERE USU.GRUPO_USUARIO = GRUPO.CODIGO
    AND ABA.GRUPO_USUARIO = USU.GRUPO_USUARIO
