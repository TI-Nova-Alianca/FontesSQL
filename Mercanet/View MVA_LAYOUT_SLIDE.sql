ALTER VIEW MVA_LAYOUT_SLIDE AS
SELECT LAYOUT.GRUPO_USUARIO    grupoUsuario_LAYOUT,
       LAYOUT.INTERVALO 	   intervalo_LAYOUT,
	   LAYOUT.EXCLUIDO 		   excluido_LAYOUT,
	   LAYOUT.DATA_ATUALIZACAO dataalter,
	   USU.USUARIO
  FROM DB_MOB_LAYOUT_SLIDE  LAYOUT,
	   DB_USUARIO			USU
 WHERE LAYOUT.GRUPO_USUARIO = USU.GRUPO_USUARIO
   AND LAYOUT.EXCLUIDO <> 1
