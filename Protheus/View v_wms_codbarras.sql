SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[v_wms_codbarras]
AS
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para integracao de cadastros com o FullWMS.
-- Aparentemente o Full faz a leitura desta view a cada vez que precisa validar um item.

-- Autor: Robert Koch
-- Data:  14/11/2014
-- Historico de alteracoes:
-- 28/05/2018 - Robert - Envia somente tipo PA (para evitar enviar desnecessariamente para o AX 02)
-- 29/03/2019 - Robert - Envia tambem tipo PI
-- 15/10/2019 - Robert - Passa a buscar codigo de barras no campo B1_CODBAR e nao mais do B1_VADUNCX
-- 28/07/2020 - Robert - Validava se o campo B1_VADUNCX estava preenchido. Agora valida o preenchimento do B1_CODBAR.
--

SELECT RTRIM (B1_COD) AS coditem,
       '2' as tipo,
       RTRIM (B1_CODBAR) as codbarras, -- 
	   --RTRIM (B1_VADUNCX) as codbarras,
       1 as qtd,
       1 AS empresa
FROM   SB1010
WHERE  D_E_L_E_T_ = ''
       AND B1_FILIAL = '  '
       AND B1_VAFULLW = 'S'
       --AND B1_VADUNCX != ''
       AND B1_CODBAR != ''
	   AND B1_TIPO in ('PA', 'PI')
GO
