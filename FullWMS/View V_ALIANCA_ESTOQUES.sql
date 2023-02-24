CREATE OR REPLACE FORCE VIEW V_ALIANCA_ESTOQUES
AS 
-- Descricao: View para detalhamento de posicao de estoques no FullWMS
-- Autor....: Robert Koch
-- Data.....: 20/02/2023

-- Historico de alteracoes:
--

  select wms_estoques_cd.empr_codemp
    , wms_estoques_cd.item_cod_item_log
    , wms_estoques_cd.lote
    , wms_estoques_cd.validade
    , wms_predios.ruasarm_cod_ruasarm || '-' || wms_predios.cod_predio || '-' || wms_la.cod_la as posicao
    --, wms_la.status as status_la
    , wms_ruas_armazenagens.tipo_rua || '-' || case wms_ruas_armazenagens.tipo_rua
            when 1 then 'crossdocking'
            when 2 then 'armazenagem'
            when 9 then 'indisponivel'
            else '' end as situacao_rua
    , wms_estoques_cd.situacao || '-' || + case wms_estoques_cd.situacao
            when 'L' then 'liberado'
            when 'B' then 'bloqueado'
            else '' end as situacao_lote
    , wms_estoques_cd.qtd
    , wms_estoques_cd.num_reserva
from wms_estoques_cd
    join wms_la
        join wms_predios
            join wms_ruas_armazenagens
            on (wms_ruas_armazenagens.cod_ruasarm = wms_predios.ruasarm_cod_ruasarm)
        on (wms_predios.predio_id = wms_la.predio_predio_id)
    on (wms_la.empr_codemp = wms_estoques_cd.empr_codemp
    and wms_la.cod_la = wms_estoques_cd.la_cod_la
    and wms_la.predio_predio_id = wms_estoques_cd.predio_predio_id);
