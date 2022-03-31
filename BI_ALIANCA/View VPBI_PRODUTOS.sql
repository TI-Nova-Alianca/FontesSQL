SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- View para o PowerBI ler dados dos demais sistemas
-- Data: 13/10/2021
-- Autor: Robert Koch
--
-- Historico de alteracoes:
-- 31/03/2022 - Robert - Incluidos novos campos
--

ALTER VIEW [dbo].[VPBI_PRODUTOS]  -- PRODUTOS
AS 
SELECT B1_COD
	, B1_DESC
	, B1_TIPO
	, B1_CODLIN  -- VINCULADO A VPBI_LINHAS_COMERCIAIS
	, B1_GRPEMB  -- VINCULADO A VPBI_GRUPOS_EMBALAGENS
	, B1_VAMARCM -- VINCULADO A VPBI_MARCAS_COMERCIAIS
	, B1_VALINEN -- VINCULADO A VPBI_LINHAS_ENVASE
    , B1_UM
FROM protheus.dbo.SB1010
WHERE D_E_L_E_T_ = ''
AND B1_FILIAL = '  '
GO
