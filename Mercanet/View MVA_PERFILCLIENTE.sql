---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	10/07/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   07/05/2014  tiago           incluido campo DB_TBPFC_CONDPGTOS e retirado relacionamento com a mva_cliente
-- 1.0002   12/05/2014  tiago           alterado alias do campo DB_TBPFC_CONDPGTOS
---------------------------------------------------------------------------------------------------
ALTER VIEW  MVA_PERFILCLIENTE AS
SELECT DB_TBPFC_CODIGO	  CODIGO_PERCLI,
       DB_TBPFC_DESCR	  DESCRICAO_PERCLI,
	   DB_TBPFC_CONDPGTOS CONDICAOPAGAMENTO
  FROM DB_TB_PERFIL_CLI
