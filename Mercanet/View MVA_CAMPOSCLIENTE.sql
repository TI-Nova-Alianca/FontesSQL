ALTER VIEW MVA_CAMPOSCLIENTE  AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/07/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   27/03/2014  tiago           incluido tratativa para o campo TIPOCOMPONENTE_CAMPOCLI
-- 1.0003   03/03/2016  tiago           incluido campo fonte
-- 1.0004   22/03/2016  tiago           incluido campo COR_FONTE e APRESENTACAO_FONTE
---------------------------------------------------------------------------------------------------
SELECT P.GRUPO_USUARIO    GRUPOUSUARIO_CAMPOCLI,
             P.ABA               ABA_CAMPOCLI,
             P.AREA              AREA_CAMPOCLI,
             P.CAMPO                    CAMPO_CAMPOCLI,
             P.COLUNA            COLUNA_CAMPOCLI,
             P.ORDEM                    ORDEM_CAMPOCLI,
             P.LABEL                    LABEL_CAMPOCLI,
             P.OBRIGATORIO OBRIGATORIO_CAMPOCLI,
             P.EDITAVEL          EDITAVEL_CAMPOCLI,
             P.DESTAQUE          DESTAQUE_CAMPOCLI,
             CASE WHEN (P.CAMPO = 'CEP' AND P.TIPO_COMPONENTE = 14 AND ((SELECT 1 
                                                                     FROM DB_USUARIO_MOBILE
                                                                   WHERE SUBSTRING(VERSAO_UTILIZADA, 1, 9) = '2013.10.2'
                                                                      AND DB_USUARIO_MOBILE.CODIGO = USU.CODIGO) = 1 ) ) THEN 5 
                WHEN ((P.CAMPO = 'TELEFONE' OR P.CAMPO = 'FAX') AND (P.TIPO_COMPONENTE = 13) AND ((SELECT 1 
                                                                           FROM DB_USUARIO_MOBILE
                                                                          WHERE SUBSTRING(VERSAO_UTILIZADA, 1, 9) = '2013.10.2'
                                                                            AND DB_USUARIO_MOBILE.CODIGO = USU.CODIGO) = 1 ) ) THEN 3 ELSE P.TIPO_COMPONENTE END      TIPOCOMPONENTE_CAMPOCLI,
             P.TAMANHO               TAMANHO_CAMPOCLI,
			 p.FONTE                 fonte_CAMPOCLI,
			 p.COR_FONTE             corFonte_CAMPOCLI,
			 p.APRESENTACAO_FONTE    apresentacaoFonte_CAMPOCLI,
			 p.CAMPO_WEB             campoWeb_CAMPOCLI,
			 p.CAMPO_MOBILE          campoMobile_CAMPOCLI,
             p.MASCARA               mascara_CAMPOCLI,
             p.PERMITE_NEGATIVO      permiteNegativo_CAMPOCLI,
             USU.USUARIO
   FROM DB_MOB_CAMPOS_CLIENTE P, DB_USUARIO USU,
             MVA_AREASABASCLIENTE  VA
  WHERE P.GRUPO_USUARIO = USU.GRUPO_USUARIO
       AND VA.ABA_AREACLI = P.ABA
       AND VA.AREA_AREACLI = P.AREA
       AND VA.USUARIO = USU.USUARIO
