ALTER VIEW [dbo].[REL_ECON_CULT] AS

SELECT
	a.CCAplicacaoAssocGrpFamCod as REL_ECON_CULT_GRP_FAM,
	a.CCAplicacaoCulturaId as REL_ECON_CULT_CULTURA_ID,
	c.CCCulturaDesc as REL_ECON_CULT_CULTURA_DESC,
	a.CCAplicacaoInsumoCod as REL_ECON_CULT_INSUMO_COD,
	a.CCAplicacaoInsumoDesc as REL_ECON_CULT_INSUMO_DESC,
	sum(a.CCAplicacaoQtdApli) as REL_ECON_CULT_QTD_APLI,
	d.CCInsumoPrecoUnitario as REL_ECON_CULT_PRECO_UNIT,
	sum(a.CCAplicacaoCusto) as REL_ECON_CULT_CUSTO

FROM CCAplicacao as a
left join CCVariedade as b on (a.CCAplicacaoVariedadeCod = b.CCVariedadeCod)
left join CCCultura as c on (a.CCAplicacaoCulturaId = c.CCCulturaId)
left join CCInsumo as d on (a.CCAplicacaoInsumoCod = d.CCInsumoId)
GROUP BY a.CCAplicacaoAssocGrpFamCod, a.CCAplicacaoCulturaId, c.CCCulturaDesc, a.CCAplicacaoInsumoCod, a.CCAplicacaoInsumoDesc, d.CCInsumoPrecoUnitario 

