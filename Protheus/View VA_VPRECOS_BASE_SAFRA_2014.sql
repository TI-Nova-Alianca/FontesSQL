
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar precos base para compra de safra 2013.
-- Autor: Robert Koch
-- Data:  19/05/2014
-- Historico de alteracoes:
-- 28/06/2013 - Robert - Nao verificava o campo ZX5_13SAFR
--

ALTER VIEW [dbo].[VA_VPRECOS_BASE_SAFRA_2014] AS
SELECT Z1_TABELA AS TABELA,
       B1_VARUVA AS FINA_COMUM,
       B1_COD AS PRODUTO,
       B1_DESC AS DESCRICAO,
       Z1_GRAU AS GRAU,
       ROUND (SZ1.Z1_PRCCOM * 1.4, 4) AS CLAS_LIVR_AA, --PRECO_AA,
       ROUND (SZ1.Z1_PRCCOM * 1.2, 4) AS CLAS_LIVR_A,  --PRECO_A,
       SZ1.Z1_PRCCOM AS CLAS_LIVR_B,                   --PRECO_B,
       ROUND (SZ1.Z1_PRCCOM * .8, 4) AS CLAS_LIVR_C,   --PRECO_C,
       ROUND (SZ1.Z1_PRCCOM * .6, 4) AS CLAS_LIVR_D,   --PRECO_D,
       ROUND (SZ1.Z1_PRCCOM * .5, 4) AS CLAS_LIVR_DS,  --PRECO_DS
       0 AS CLAS_SERRA_A,
       0 AS CLAS_SERRA_B,
       0 AS CLAS_SERRA_D
FROM   ZX5010 PRODUTOS,
       SB1010 SB1,
       ZX5010 GRUPOS,
       SZ1010 SZ1
WHERE  GRUPOS.D_E_L_E_T_ = ''
       AND GRUPOS.ZX5_FILIAL = '  '
       AND GRUPOS.ZX5_TABELA = '13'
       AND GRUPOS.ZX5_13SAFR = '2014'
       AND PRODUTOS.D_E_L_E_T_ = ''
       AND PRODUTOS.ZX5_FILIAL = '  '
       AND PRODUTOS.ZX5_TABELA = '14'
       AND PRODUTOS.ZX5_14GRUP = GRUPOS.ZX5_13GRUP
       AND PRODUTOS.ZX5_14SAFR = '2014'
       AND SB1.D_E_L_E_T_ = ''
       AND SB1.B1_FILIAL = '  '
       AND SB1.B1_COD = PRODUTOS.ZX5_14PROD
       AND SZ1.D_E_L_E_T_ = ''
       AND SZ1.Z1_FILIAL = '  '
       AND SZ1.Z1_TABELA = 'BASE14'
       AND SZ1.Z1_CODPRD = GRUPOS.ZX5_13GRUP



