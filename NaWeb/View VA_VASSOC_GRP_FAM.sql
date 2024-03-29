ALTER VIEW [dbo].[VA_VASSOC_GRP_FAM]
AS

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar o(s) grupo(s) familiar(es) relacionado(s) aos associados (GLPI 8804)
-- Autor: Robert Koch
-- Data:  25/02/2021
-- Historico de alteracoes:
-- 11/08/2021 - Robert - View movida do database do Protheus para o database do NaWeb (para poder distinguir base de produção X teste) - GLPI 10673
--

SELECT
	CCAssociadoCod
   ,CCAssociadoLoja
   ,CCAssociadoGrpFamCod
   ,CCAssociadoGrpFam
   ,CCAssociadoGrpFamNucleo
   ,CCAssociadoGrpFamSubNucleo
FROM CCAssociadoGrpFam CCAGF
	,CCAssociadoInscricoes CCAI
WHERE CCAGF.CCAssociadoGrpFamCod = CCAI.CCAssocIEGrpFamCod

