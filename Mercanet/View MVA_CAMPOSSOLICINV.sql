---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	16/03/2017	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CAMPOSSOLICINV AS
 select campo.GRUPO_USUARIO			grupoUsuario_CAMSOL,
		campo.ABA					aba_CAMSOL,
		campo.AREA					area_CAMSOL,
		campo.CAMPO					campo_CAMSOL,
		campo.coluna				coluna_CAMSOL,
		campo.ORDEM					ordem_CAMSOL,
		campo.LABEL					label_CAMSOL,
		campo.EXIBIR_OBRIGATORIO	obrigatorio_CAMSOL,
		campo.EXIBIR_EDITAVEL		editavel_CAMSOL,
		campo.EXIBIR_DESTAQUE		destaque_CAMSOL,
		campo.TIPO_COMPONENTE		tipoComponente_CAMSOL,
		campo.TAMANHO				tamanho_CAMSOL,
		campo.COR_FONTE				corFonte_CAMSOL,
		campo.COR_FUNDO				corFundo_CAMSOL,
		area.usuario
   from DB_MOB_CAMPOS_SOLICINV campo,
        MVA_AREASABASSOLICINV  area,
	    db_usuario usu
  WHERE campo.GRUPO_USUARIO = USU.GRUPO_USUARIO
    AND area.aba_AREASOL  = campo.ABA
    AND area.area_AREASOL = campo.AREA
    AND area.USUARIO      = USU.USUARIO
