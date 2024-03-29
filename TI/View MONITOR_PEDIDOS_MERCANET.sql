
-- Cooperativa Agroindustrial Nova Alianca Ltda
-- View auxiliar para monitoramento de pedidos feitos no Mercanet e depois importados no Protheus
-- Autor: Robert Koch
-- Data:  01/09/2021
-- Historico de alteracoes:
-- 28/12/2022 - Robert - Apenas esta obs, para ver como grava LastModifiesDate.
--

ALTER VIEW [dbo].[MONITOR_PEDIDOS_MERCANET]
AS
    SELECT ZC5_PEDMER AS NUM_PED_MERCANET
        ,ZC5_PEDCLI AS NUM_PED_CLIENTE
        ,ZC5_NUM AS NUM_PED_PROTHEUS
        ,ZC5_CLIENT AS CLIENTE
        ,ZC5_LOJACL AS LOJA
        ,ZC5_VEND1 AS REPRES
        ,ZC5_STATUS + '-' + CASE ZC5_STATUS
            WHEN 'INS'
                THEN CASE WHEN ZC5_DTINI = '' AND ZC5_HRINI = ''
                    THEN 'AGUARDANDO LEITURA PELO PROTHEUS'
                    ELSE 'IMPORTACAO INICIADA PELO PROTHEUS'
                END
            WHEN 'PRO' THEN 'ACEITO PELO PROTHEUS'
            WHEN 'ERR' THEN 'NAO ACEITO PELO PROTHEUS'
            WHEN 'CAN' THEN 'IMPORT.P/PROTHEUS CANCELADA MANUALMENTE'
        END AS STATUS
        ,ZC5_ERRO AS MSG_PROTHEUS
        ,CAST (ZC5_DTINC + ' ' + ZC5_HRINC AS DATETIME) DTHR_INCL_MERCANET
        ,CAST (CASE ZC5_DTINI WHEN '' THEN NULL ELSE ZC5_DTINI END + ' ' + CASE ZC5_HRINI WHEN '' THEN NULL ELSE ZC5_HRINI END AS DATETIME) DTRH_INI_IMPORT_PROTHEUS
        ,CAST (CASE ZC5_DTFIM WHEN '' THEN NULL ELSE ZC5_DTFIM END + ' ' + CASE ZC5_HRFIM WHEN '' THEN NULL ELSE ZC5_HRFIM END AS DATETIME) DTRH_FIM_IMPORT_PROTHEUS
    FROM MercanetPRD.dbo.ZC5010

