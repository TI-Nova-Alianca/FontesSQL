WITH c
AS
(SELECT DISTINCT
		G.CCAssociadoGrpFamNucleo
	   ,P.CCAssociadoGrpFamCod
	   ,G.CCAssociadoGrpFam
	   ,P.CCPropriedadeCod
	   ,P.CCPropriedadeMun
	   ,P.CCPropriedadeEndereco
	   ,P.CCPropriedadeKMF01
	   ,P.CCPropriedadeKMF03
	   ,P.CCPropriedadeKMF07
	FROM CCPropriedade P
		,CCAssociadoGrpFam G
	WHERE G.CCAssociadoGrpFamCod = P.CCAssociadoGrpFamCod
	AND P.CCPropriedadeCod != 0
)
SELECT CCAssociadoGrpFamNucleo ,CCAssociadoGrpFamCod	   ,CCAssociadoGrpFam	   ,CCPropriedadeCod, CCPropriedadeMun	   ,CCPropriedadeEndereco, '01' as FilialDestino, CCPropriedadeKMF01 as Distancia
FROM c
where CCPropriedadeKMF01 > 0
union all
SELECT CCAssociadoGrpFamNucleo ,CCAssociadoGrpFamCod	   ,CCAssociadoGrpFam	   ,CCPropriedadeCod, CCPropriedadeMun	   ,CCPropriedadeEndereco, '03' as FilialDestino, CCPropriedadeKMF03 as Distancia
FROM c
where CCPropriedadeKMF03 > 0
union all
SELECT CCAssociadoGrpFamNucleo ,CCAssociadoGrpFamCod	   ,CCAssociadoGrpFam	   ,CCPropriedadeCod, CCPropriedadeMun	   ,CCPropriedadeEndereco, '07' as FilialDestino, CCPropriedadeKMF07 as Distancia
FROM c
where CCPropriedadeKMF07 > 0
order by 
		CCAssociadoGrpFamNucleo
	   ,CCAssociadoGrpFamCod
	   ,CCAssociadoGrpFam
	   ,CCPropriedadeCod
	   , FilialDestino
