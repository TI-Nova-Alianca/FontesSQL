---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	10/07/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   14/08/2013  tiago           incluido campo mobile
-- 1.0002   22/08/2013  tiago           incluido campo de seguencia
-- 1.0003   30/08/2013  tiago           incluido campo de agencia
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTEREFERENCIAS AS
SELECT 	CLIENTE                 CLIENTE_CLREF,
		ID                      SEQUENCIA_CLREF,        
        TIPO                    TIPO_CLREF,
		REFERENCIA              REFERENCIA_CLREF,
		CIDADE                  CIDADE_CLREF,
		TELEFONE                TELEFONE_CLREF,
		VOLUME_MES_COMPRAS      VOLUMEMENSALCOMPRAS_CLREF,
		PERFIL_PAGAMENTO        PERFILPAGAMENTO_CLREF,
		CREDITO                 CREDITO_CLREF,
		IMPORTANCIA             IMPORTANCIA_CLREF,
		0                       MOBILE_CLREF ,
		AGENCIA                 AGENCIA_CLREF,
		CLI.USUARIO
   FROM DB_CLIENTE_REFERENCIA,
        MVA_CLIENTE CLI
  WHERE CLI.CODIGO_CLIEN = CLIENTE
