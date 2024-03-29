---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	24/05/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_TIMELINE AS
SELECT FUNCIONALIDADE      FUNCIONALIDADE_TIME,
       INTERVALO           INTERVALO_TIME,
	   DESCRICAO_TIMELINE  DESCRICAOTIMELINE_TIME,
	   ICONE               ICONE_TIME,
       INTERVALO_SEGUNDOS  INTERVALOSEGUNDOS_TIME,
	   USU.USUARIO
  FROM DB_MOB_TIMELINE,
       DB_USUARIO USU
 WHERE EXIBIR = 1
   AND USU.GRUPO_USUARIO = DB_MOB_TIMELINE.GRUPO_USUARIO
