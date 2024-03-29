
ALTER VIEW [dbo].[REL_ECON_PAR] AS 
SELECT 
	a.CCAplicacaoAssocGrpFamCod AS REL_ECON_PAR_GRPFAMCOD,
	a.CCAplicacaoParcelaCod AS REL_ECON_PAR_PARCELACOD,
	a.CCAplicacaoVariedadeDesc AS REL_ECON_PAR_VARIEDADEDESC,
	a.CCAplicacaoCadernoCampo AS REL_ECON_PAR_CADERNOCAMPO,
	a.CCAplicacaoInsumoDesc AS REL_ECON_PAR_INSUMODESC,
	sum(a.CCAplicacaoQtdApli) AS REL_ECON_PAR_QTDAPLI,
	b.CCInsumoPrecoUnitario AS REL_ECON_PAR_PRECOUNIT,
	sum(a.CCAplicacaoCusto) AS REL_ECON_PAR_VLRTOT,
	count(a.CCAplicacaoInsumoCod) AS REL_ECON_PAR_NUMAPLI,
	ISNULL(b.CCInsumoLimiteAplic, 0) AS REL_ECON_PAR_LIMTAPLI
FROM CCAplicacao as a
left join CCInsumo as b on (a.CCAplicacaoInsumoCod = b.CCInsumoId)
GROUP BY a.CCAplicacaoAssocGrpFamCod, a.CCAplicacaoParcelaCod, a.CCAplicacaoVariedadeDesc, a.CCAplicacaoCadernoCampo, a.CCAplicacaoInsumoDesc, b.CCInsumoPrecoUnitario, b.CCInsumoLimiteAplic

