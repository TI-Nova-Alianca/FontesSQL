ALTER VIEW MVA_CAMPOS_ETAPA AS
 SELECT CODIGO_FLUXO  FLUXO_ETCAM,
        CODIGO_ETAPA  ETAPA_ETCAM,
        ABA        ABA_ETCAM,
        AREA      AREA_ETCAM,
        CAMPO      CAMPO_ETCAM,
        VISIVEL      VISIVEL_ETCAM,
        EDITAVEL    EDITAVEL_ETCAM,
        OBRIGATORIO    OBRIGATORIO_ETCAM,
		DEPENDENTE		dependente_ETCAM ,
        MVA_TELAS.USUARIO
   FROM DB_FLU_ETA_CAMPOS
      , MVA_TELAS
      , mva_campos campo
      , db_usuario usu
  WHERE DB_FLU_ETA_CAMPOS. CODIGO_FLUXO = MVA_TELAS.FLUXO_TELA
    and campo.usuario = MVA_TELAS.USUARIO
    and fluxo_tela = CODIGO_FLUXO  
    and ABA = aba_camp
    and AREA = area_camp
    and CAMPO = campo_camp
    and codigo_camp = MVA_TELAS.codigo_TELA   
	and usu.usuario = MVA_TELAS.USUARIO
    and (case when etapaPermissao_TELA = 1 then 
                                case when (select 1 from DB_OC_GRUPOS_USUARIOS grupo where grupo.codigo_grupo = grupo_usu_ocorrencia and grupo.usuario = usu.codigo) = 1 then 1 else 0 end
         else 1 end) = 1
  UNION ALL
 SELECT DISTINCT CODIGO_FLUXO  FLUXO_ETCAM,
        CODIGO_ETAPA  ETAPA_ETCAM,
        ABA        ABA_ETCAM,
        AREA      AREA_ETCAM,
        CAMPO      CAMPO_ETCAM,
        VISIVEL      VISIVEL_ETCAM,
        EDITAVEL    EDITAVEL_ETCAM,
        OBRIGATORIO    OBRIGATORIO_ETCAM,
		DEPENDENTE		dependente_ETCAM ,
        MVA_TELAS.USUARIO
   FROM DB_FLU_ETA_CAMPOS
      , MVA_TELAS
      , mva_campos campo
      , db_usuario usu
  WHERE DB_FLU_ETA_CAMPOS. CODIGO_FLUXO = MVA_TELAS.FLUXO_TELA
    and campo.usuario = MVA_TELAS.USUARIO
    and fluxo_tela = CODIGO_FLUXO  
    and ABA = aba_camp
    and AREA = area_camp
    and CAMPO = 'E_ENVIAR_ANEXOS'
    and codigo_camp = MVA_TELAS.codigo_TELA   
	and usu.usuario = MVA_TELAS.USUARIO
    and (case when etapaPermissao_TELA = 1 then 
                                case when (select 1 from DB_OC_GRUPOS_USUARIOS grupo where grupo.codigo_grupo = grupo_usu_ocorrencia and grupo.usuario = usu.codigo) = 1 then 1 else 0 end
         else 1 end) = 1
