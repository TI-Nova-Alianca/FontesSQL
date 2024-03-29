---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	20/10/2015	TIAGO PRADELLA	CRIACAO
-- 1.0002   05/04/2016  tiago           incluido campo motivo bonificacao
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_POLITICASBONIPRINCIPAL AS
SELECT PRINCIPAL.POLITICA        POLITICA_POLBONI,
       DESCRICAO                 DESCRICAO_POLBONI,
       PRINCIPAL.DATA_INICIAL    DATAINICIAL_POLBONI,
       PRINCIPAL.DATA_FINAL      DATAFINAL_POLBONI,
	   CONTROLE.PESO             PESO_POLBONI,
	   MOTIVO_BONIFICACAO        motivoBonificacao_POLBONI,
       DESCONSIDERA_FILTRO_PROD  desconsideraFiltroProd_POLBONI,
       DESCONSIDERA_ITEM_BONI    desconsideraItemBoni_POLBONI,
       PRINCIPAL.DATAALTER
  FROM DB_POLBONI_PRINCIPAL PRINCIPAL,       
	   DB_POLITICA_CONTROLE   CONTROLE
 WHERE PRINCIPAL.CONTROLE = CONTROLE.CONTROLE  
   AND PRINCIPAL.DATA_FINAL >= GETDATE()
