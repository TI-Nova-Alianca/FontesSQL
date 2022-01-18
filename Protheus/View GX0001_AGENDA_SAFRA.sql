SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Cooperativa Agroindustriala Nova Alianca Ltda
-- View para buscar situacao de associados quanto a previsao de entregar uva na safra.
-- Autor: Guilherme Oliveira
-- Data:  07/12/2012
-- Historico de alteracoes:
-- 08/01/2018 - Robert - Incluido manualmente fornecedor 001369 (producao propria filial Livramento) por nao estar no cadastro de associados.
-- 12/01/2018 - Robert - Incluida coluna AMOSTRA.
-- 13/12/2018 - Robert - Incluida leitura das colunas B1_VAFCUVA, ZZL_COD, ZF_CADCPO, ZF_ENTRCAD
-- 19/12/2018 - Robert - Incluida validacao do campo ZZL_CADVIT.
-- 07/01/2019 - Robert - Liberado fornecedor 012373
-- 08/01/2020 - Guilherme - Chumbado 2019 para consulta retroativa dos cadernos de campo
-- 24/01/2020 - Robert - Incluidos fornecedores 012791/012792
-- 13/11/2020 - Robert - Unido conteudo da view V_VAGENDA_SAFRA
--                     - Atualizado para ler diversos cadastros (grp.familiares/propriedades/parcelas) do NaWeb e nao mais do Protheus.
-- 01/12/2020 - Robert - Separadas colunas GX0001_VITICOLA_CODIGO e GX0001_SIVIBE_CODIGO
--                     - Nao trazia fornecedores nao associados (assumia codigo e loja em branco)
-- 05/01/2020 - Robert - Criada coluna GX0001_TIPO_FORNECEDOR_UVA
-- 18/01/2021 - Robert - Bloqueado associado 005500/02 (GLPI 11491)
--

ALTER view [dbo].[GX0001_AGENDA_SAFRA]
AS

WITH FORNECEDORES AS 
 (SELECT DISTINCT
		 SA2.A2_COD
		,SA2.A2_LOJA
		,SA2.A2_NOME
		,SA2.A2_TEL
		,SA2.A2_VACELUL
		,CASE
			 WHEN EXISTS (SELECT
						 *
					 FROM SZI010 SZI_DESLIG
					 WHERE SZI_DESLIG.D_E_L_E_T_ = ''
					 AND SZI_DESLIG.ZI_ASSOC = SZI_BASE.ZI_ASSOC
					 AND SZI_DESLIG.ZI_LOJASSO = SZI_BASE.ZI_LOJASSO
					 AND SZI_DESLIG.ZI_TM = '09'
					 AND SZI_DESLIG.ZI_DATA >= SZI_BASE.ZI_DATA) THEN 'DESLIGADO DO QUADRO SOCIAL'  -- NAO PODE TER DESASSOCIACAO POSTERIOR A DATA DE ASSOCIACAO.
			 ELSE CASE
						WHEN SA2.A2_MSBLQL = '1' THEN 'CADASTRO FORNECEDOR BLOQUEADO'
					 ELSE CASE
							 WHEN EXISTS (SELECT
										 *
									 FROM SZI010 SZI_INATIV
									 WHERE SZI_INATIV.D_E_L_E_T_ = ''
									 AND SZI_INATIV.ZI_ASSOC = SZI_BASE.ZI_ASSOC
									 AND SZI_INATIV.ZI_LOJASSO = SZI_BASE.ZI_LOJASSO
									 AND SZI_INATIV.ZI_TM = '27') THEN 'BAIXA CAP.SOCIAL POR INATIVIDADE'
							 ELSE CASE
									 WHEN EXISTS (SELECT
												 *
											 FROM SZI010 SZI_MULTA
											 WHERE SZI_MULTA.D_E_L_E_T_ = ''
											 AND SZI_MULTA.ZI_ASSOC = SZI_BASE.ZI_ASSOC
											 AND SZI_MULTA.ZI_LOJASSO = SZI_BASE.ZI_LOJASSO
											 AND SZI_MULTA.ZI_TM = '26'
											 AND SZI_MULTA.ZI_SALDO > 0
											 AND SZI_MULTA.ZI_ASSOC NOT IN ('002378', '004946')  -- ARMANDO E RUDIMAR FORMOLO VAO PAGAR A MULTA EM UVA
										 ) THEN 'MULTA EM ABERTO'
									 ELSE CASE
											 WHEN EXISTS (SELECT
														 *
													 FROM SZI010 SZI_MULTA
														 ,(SELECT
																  OUTROS.ZAK_ASSOC
																 ,OUTROS.ZAK_LOJA
															  FROM ZAK010 OUTROS
															  WHERE OUTROS.D_E_L_E_T_ = ''
															  AND OUTROS.ZAK_FILIAL = '  '
															  AND OUTROS.ZAK_IDZAN IN (SELECT
																	  ZAK_IDZAN
																  FROM ZAK010 ZAK
																  WHERE ZAK.D_E_L_E_T_ = ''
																  AND ZAK.ZAK_FILIAL = '  '
																  AND ZAK.ZAK_ASSOC = SZI_BASE.ZI_ASSOC
																  AND ZAK.ZAK_LOJA = SZI_BASE.ZI_LOJASSO)) MEMBROS_DO_GRUPO
													 WHERE SZI_MULTA.D_E_L_E_T_ = ''
													 AND SZI_MULTA.ZI_ASSOC = MEMBROS_DO_GRUPO.ZAK_ASSOC
													 AND SZI_MULTA.ZI_LOJASSO = MEMBROS_DO_GRUPO.ZAK_LOJA
													 AND SZI_MULTA.ZI_TM = '26'
													 AND SZI_MULTA.ZI_SALDO > 0
													 AND SZI_MULTA.ZI_ASSOC NOT IN ('002378', '004946')  -- ARMANDO E RUDIMAR FORMOLO VAO PAGAR A MULTA EM UVA
												 ) THEN 'MULTA EM ABERTO NO GRUPO FAMILIAR'
											 ELSE ''
										 END
								 END
						 END
				 END
		 END AS RESTRICAO
		 ,'A' as TIPO_FORNECEDOR_UVA  -- 'A' = 'Associado'
	 FROM (SELECT ZI_ASSOC, ZI_LOJASSO, D_E_L_E_T_, ZI_TM, ZI_DATA
		  FROM SZI010
		  ) AS SZI_BASE,
	 SA2010 SA2
	 WHERE SZI_BASE.D_E_L_E_T_ = ''
	 AND SZI_BASE.ZI_TM = '08'  -- ASSOCIAR
	 AND SA2.D_E_L_E_T_ = ''
	 AND SA2.A2_FILIAL = '  '
	 AND SA2.A2_COD = SZI_BASE.ZI_ASSOC
	 AND SA2.A2_LOJA = SZI_BASE.ZI_LOJASSO
     AND NOT (SA2.A2_COD = '005500' AND SA2.A2_LOJA = '02') -- Associado que estamos mudando para novo codigo (GLPI 11491)
	 AND NOT EXISTS (SELECT
			 *
		 FROM SZI010 SZI_ANTERIOR
		 WHERE SZI_ANTERIOR.D_E_L_E_T_ = ''
		 AND SZI_ANTERIOR.ZI_ASSOC = SZI_BASE.ZI_ASSOC
		 AND SZI_ANTERIOR.ZI_LOJASSO = SZI_BASE.ZI_LOJASSO
		 AND SZI_ANTERIOR.ZI_TM = '08'
		 AND SZI_ANTERIOR.ZI_DATA > SZI_BASE.ZI_DATA)  -- PARA NAO PEGAR PERIODOS ANTERIORES EM QUE FOI ASSOCIADO (EX. 003059 SAIU E VOLTOU)

	union all

	-- BUSCA FORNECEDORES DE UVA 'NAO ASSOCIADOS'
	SELECT DISTINCT
		A2_COD
		,A2_LOJA
		,CCAssociadoNome     as A2_NOME
		,CCAssociadoTelefone as A2_TEL
		,CCAssociadoCelular  as A2_VACELUL
		,''                  as RESTRICAO
		,'N'                 as TIPO_FORNECEDOR_UVA  -- 'N' = 'Nao associado'
	FROM LKSRV_NAWEB.naweb.dbo.CCAssociado
		, SA2010 SA2
	where CCAssociadoSituacao = 2  -- 0=Falta mapeamento;1=Associado ativo;2=Nao associado (fornecedor de uva);3=Ex associado
	AND SA2.D_E_L_E_T_ = ''
	AND SA2.A2_FILIAL  = '  '
	AND SA2.A2_CGC     = CCAssociadoCPF


)

SELECT
	CCAI.CCAssocIEGrpFamCod              AS GX0001_GRUPO_CODIGO
	,RTRIM(CCAGF.CCAssociadoGrpFam)      AS GX0001_GRUPO_DESCRICAO
	,FORNECEDORES.A2_COD                 AS GX0001_ASSOCIADO_CODIGO
	,FORNECEDORES.A2_LOJA                AS GX0001_ASSOCIADO_LOJA
	,FORNECEDORES.A2_NOME                AS GX0001_ASSOCIADO_NOME
	,LTRIM(RTRIM(FORNECEDORES.A2_TEL)) + ' / ' + LTRIM(RTRIM(FORNECEDORES.A2_VACELUL)) AS GX0001_ASSOCIADO_TELEFONE
	,FORNECEDORES.RESTRICAO              AS GX0001_ASSOCIADO_RESTRICAO
	,CCP.CCPropriedadeCod                AS GX0001_PROPRIEDADE_CODIGO
	,REPLACE(STR(CCP.CCPropriedadeCod, 5), ' ', '0') AS GX0001_VITICOLA_CODIGO -- DayRibas - Alteração do nome do campo para facilitar entendimento
	,CCP.CCPropriedadeSivibe             AS GX0001_SIVIBE_CODIGO
	,SUBSTRING (REPLACE(STR(CCPropriedadeRecadastro, 4),' ','0'), 1, 8) as GX0001_VITICOLA_RECADASTRO
	,SUBSTRING (REPLACE(STR(CCPropriedadeRecadastro, 4),' ','0') + '1231', 1, 8) as GX0001_VITICOLA_FISICO
	,Parcela.CCVariedadeCod              AS GX0001_PRODUTO_CODIGO
	,Parcela.CCParcelaSistemaSustentacao AS GX0001_SISTEMA_CONDUCAO
	,rtrim (SB1.B1_DESC)                 AS GX0001_PRODUTO_DESCRICAO
	,SB1.B1_VAORGAN                      AS GX0001_TIPO_ORGANICO
	,SB1.B1_VARUVA                       AS GX0001_FINA_COMUM
	,SB1.B1_VAFCUVA                      AS GX0001_FORMA_CLASSIF_VINIFERA
	,SB1.B1_VACOR                        AS GX0001_COR
	,SB1.B1_VATTR                        AS GX0001_TINTOREA
--	,AMOSTRA            AS GX0001_AMOSTRA
--	,CADERNO_CPO        AS GX0001_CADERNO_CPO
--	,CADERNO_ENTREGUE   AS GX0001_CADERNO_ENTREGUE
	,TIPO_FORNECEDOR_UVA                 AS GX0001_TIPO_FORNECEDOR_UVA
FROM 
	FORNECEDORES--, VA_VAGENDA_SAFRA
	JOIN LKSRV_NAWEB.naweb.dbo.CCAssociadoInscricoes CCAI 
		JOIN LKSRV_NAWEB.naweb.dbo.CCAssociadoGrpFam CCAGF
		ON (CCAGF.CCAssociadoGrpFamCod = CCAssocIEGrpFamCod)
		JOIN LKSRV_NAWEB.naweb.dbo.CCPropriedade CCP
			JOIN (select distinct CCPropriedadeCod, CCVariedadeCod, CCParcelaSistemaSustentacao  -- usa distinct por que numa propriedade pode ter mais de uma parcela com a mesma variedade.
					from LKSRV_NAWEB.naweb.dbo.CCParcela Parcela) as Parcela
				JOIN SB1010 SB1
				ON (SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '  ' AND SB1.B1_COD = Parcela.CCVariedadeCod)
			on (Parcela.CCPropriedadeCod = CCP.CCPropriedadeCod)
		ON (CCP.CCPropriedadeCod != 0  -- Cadastro viticola = 0 significa que tem outras colturas
		and CCP.CCAssociadoGrpFamCod = CCAssocIEGrpFamCod)
	ON (CCAI.CCAssociadoCod = A2_COD and CCAI.CCAssociadoLoja = A2_LOJA)
GO
