---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	10/07/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
CREATE  VIEW  MVA_GRUPOSSUBSTTRIBUTARIA AS
SELECT DB_MPR_CODIGO	CODIGO_GRUST,
       DB_MPR_DESCR	DESCRICAO_GRUST
  FROM DB_MRG_PRESUMIDA
 WHERE DB_MPR_SITUACAO = 0
   AND DB_MPR_DATAINI <= GETDATE()
   AND DB_MPR_DATAFIN >= GETDATE()
