---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	24/11/2014	TIAGO PRADELLA	CRIACAO
-- 1.0002   17/04/2015  tiago           converte para varchar o campo instrucao
-- 1.0003   22/02/2015  tiago           alterado where do campo usuario
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_INSTRUCOES AS
 SELECT  ID              ID_INSTRU,
         INSTRUCAO       INSTRUCAO_INSTRU,
         ACAO            ACAO_INSTRU,
         DATA_INSTRUCAO  DATAINSTRUCAO_INSTRU ,
         USU.USUARIO
    FROM DB_SIS_MOB_INSTRUCAO INS, DB_USUARIO USU
   WHERE INS.USUARIO = usu.USUARIO
      AND (INS.TRANSMITIDO = 0 OR INS.TRANSMITIDO IS NULL)
   UNION ALL
  SELECT ID              ID_INSTRU,
         INSTRUCAO       INSTRUCAO_INSTRU,
         ACAO            ACAO_INSTRU,
         DATA_INSTRUCAO  DATAINSTRUCAO_INSTRU ,
         USU.USUARIO
    FROM DB_SIS_MOB_INSTRUCAO INS, DB_USUARIO USU
   WHERE INS.USUARIO IS NULL
     AND (INS.TRANSMITIDO = 0 OR INS.TRANSMITIDO IS NULL)
