---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.000   27/04/2015   TIAGO           DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ROTASENTREGA as
 SELECT CODIGO	      CODIGO_RENT,
		DESCRICAO	  DESCRICAO_RENT
   FROM DB_ROTAENTREGA
