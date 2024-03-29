---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		  AUTOR			     ALTERACAO
-- 1.0001	06/02/2012	  TIAGO PRADELLA	 CRIACAO
-- 1.0002    06/06/2016   tiago              incluido campo LOCALVALIDA
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ITENSNAOINCLUIDOS AS 
SELECT CONSULTA CONSULTA_ININC ,
       COLUNA COLUNA_ININC, 
       MENSAGEM MENSAGEM_ININC,
	   LOCALVALIDA localValidacao_ININC,
	   con.usuario	   
 FROM DB_MOB_ITENSNAOINC, MVA_CONSULTAS con
where CONSULTA = con.CODIGO_CONSU
