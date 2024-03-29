

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar pedidos aptos a serem usados em cargas do modulo OMS
-- Autor: Robert Koch
-- Data:  27/05/2014
-- Historico de alteracoes:
--

ALTER VIEW [dbo].[VA_VPEDIDOS_PARA_CARGA] AS 

SELECT DISTINCT C9_FILIAL,
       C9_PEDIDO
FROM   SC9010 SC9
WHERE  SC9.D_E_L_E_T_ = ''
       AND SC9.C9_NFISCAL = ''
       AND NOT EXISTS (
               SELECT *
               FROM   VA_FPEDIDO_OK_PARA_EMBARQUE(SC9.C9_FILIAL, SC9.C9_PEDIDO, 'OMS')
               WHERE  AVISOS != ''
                      OR  ERROS != ''
           )

