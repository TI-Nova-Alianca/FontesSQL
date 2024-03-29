

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar precos base para compra de diferentes safras.
-- Como as politicas variam muito de uma safra para outra, optei por criar
-- uma view para cada safra, e criar esta view juntando as demais.
-- Autor: Robert Koch
-- Data:  28/06/2013
-- Historico de alteracoes:
-- 19/05/2014 - Robert - Tratamentos para incluir safra 2014.
--

ALTER VIEW [dbo].[VA_VPRECOS_BASE_SAFRAS] AS
SELECT '2012' AS SAFRA,
       TABELA,
       FINA_COMUM,
       PRODUTO,
       DESCRICAO,
       GRAU,
       CLAS_LIVR_AA, --PRECO_AA,
       CLAS_LIVR_A,  --PRECO_A,
       CLAS_LIVR_B,  --PRECO_B,
       CLAS_LIVR_C,  --PRECO_C,
       CLAS_LIVR_D,  --PRECO_D,
       CLAS_LIVR_DS, --PRECO_DS
       CLAS_SERRA_A,
       CLAS_SERRA_B,
       CLAS_SERRA_D
FROM   dbo.VA_VPRECOS_BASE_SAFRA_2012
UNION ALL
SELECT '2013' AS SAFRA,
       TABELA,
       FINA_COMUM,
       PRODUTO,
       DESCRICAO,
       GRAU,
       CLAS_LIVR_AA, --PRECO_AA,
       CLAS_LIVR_A,  --PRECO_A,
       CLAS_LIVR_B,  --PRECO_B,
       CLAS_LIVR_C,  --PRECO_C,
       CLAS_LIVR_D,  --PRECO_D,
       CLAS_LIVR_DS, --PRECO_DS
       CLAS_SERRA_A,
       CLAS_SERRA_B,
       CLAS_SERRA_D
FROM   dbo.VA_VPRECOS_BASE_SAFRA_2013
UNION ALL
SELECT '2014' AS SAFRA,
       TABELA,
       FINA_COMUM,
       PRODUTO,
       DESCRICAO,
       GRAU,
       CLAS_LIVR_AA, --PRECO_AA,
       CLAS_LIVR_A,  --PRECO_A,
       CLAS_LIVR_B,  --PRECO_B,
       CLAS_LIVR_C,  --PRECO_C,
       CLAS_LIVR_D,  --PRECO_D,
       CLAS_LIVR_DS, --PRECO_DS
       CLAS_SERRA_A,
       CLAS_SERRA_B,
       CLAS_SERRA_D
FROM   dbo.VA_VPRECOS_BASE_SAFRA_2014
UNION ALL
SELECT '2015' AS SAFRA,
       TABELA,
       FINA_COMUM,
       PRODUTO,
       DESCRICAO,
       GRAU,
       CLAS_LIVR_AA, --PRECO_AA,
       CLAS_LIVR_A,  --PRECO_A,
       CLAS_LIVR_B,  --PRECO_B,
       CLAS_LIVR_C,  --PRECO_C,
       CLAS_LIVR_D,  --PRECO_D,
       CLAS_LIVR_DS, --PRECO_DS
       CLAS_SERRA_A,
       CLAS_SERRA_B,
       CLAS_SERRA_D
FROM   dbo.VA_VPRECOS_BASE_SAFRA_2015


