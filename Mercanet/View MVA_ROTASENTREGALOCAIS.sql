---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.000   27/04/2015   TIAGO           DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ROTASENTREGALOCAIS as
 SELECT CODIGO_ROTA	  CODIGOROTA_RENTL,
		CIDADE	      CIDADE_RENTL
   FROM DB_ROTAENTLOCAIS
