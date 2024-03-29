---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   02/09/2014	TIAGO PRADELLA	   CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CAMPOSPEDIDOPE AS
 SELECT P.GRUPO_USUARIO		GRUPOUSUARIO_CAMPOPE,
        P.ABA				ABA_CAMPOPE,
        P.AREA				AREA_CAMPOPE,
        P.CAMPO				CAMPO_CAMPOPE,
        P.COLUNA			COLUNA_CAMPOPE,
        P.ORDEM				ORDEM_CAMPOPE,
        P.LABEL				LABEL_CAMPOPE,
        P.OBRIGATORIO		OBRIGATORIO_CAMPOPE,
        P.EDITAVEL			EDITAVEL_CAMPOPE,
        P.DESTAQUE			DESTAQUE_CAMPOPE,
        p.TIPO_COMPONENTE	tipoComponente_CAMPOPE,
        P.TAMANHO			TAMANHO_CAMPOPE,
        USU.USUARIO
   FROM DB_MOB_CAMPOS_PEDIDO_PE P,
        DB_USUARIO USU,
        DB_GRUPO_USUARIOS GRUPO,
        MVA_AREASABASPEDIDOPE VA
  WHERE USU.GRUPO_USUARIO = GRUPO.CODIGO
    AND P.GRUPO_USUARIO   = USU.GRUPO_USUARIO
    AND VA.ABA_AREAPE  = P.ABA
    AND VA.AREA_AREAPE = P.AREA
    AND va.usuario        = usu.usuario;
