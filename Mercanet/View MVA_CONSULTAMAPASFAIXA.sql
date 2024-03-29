---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	19/04/2017	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CONSULTAMAPASFAIXA AS
 select Consulta		consulta_FXMAP,
		Sequencia		sequencia_FXMAP,
		Tipo			tipo_FXMAP,
		Coluna			coluna_FXMAP,
		Operador		operador_FXMAP,
		Valor_inicial	valorInicial_FXMAP,
		Valor_final		valorFinal_FXMAP,
		Cor				cor_FXMAP,
		legenda			legenda_FXMAP,
		Valor	        Valor_FXMAP,
		usuario
   from DB_CONS_MAPA_FAIXAS, mva_consultas
  where consulta = mva_consultas.CODIGO_CONSU
