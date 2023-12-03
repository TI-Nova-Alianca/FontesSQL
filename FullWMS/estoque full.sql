select movtos.*
    , item.descricao
from (select
        --case when m.wms_acertoestoque_id is null
        --    then decode(m.cod_ruasarm_origem, null, 'entrada', 'saida')
        --    else 'ajuste inv.'
        --end as tipo_mov,
        m.wms_tpmovestoque_id,
        decode(m.cod_ruasarm_origem, null, m.codigo_area_origem, m.cod_ruasarm_origem || '-' ||
            m.cod_predio_origem || '-' ||
            m.cod_la_origem ||
            decode(m.cod_subla_origem, null, null, '-'||
            m.cod_subla_origem))
        as origem,
        decode(m.cod_ruasarm_destino, null, m.codigo_area_destino, m.cod_ruasarm_destino || '-' ||
            m.cod_predio_destino || '-' ||
            m.cod_la_destino ||
            decode(m.cod_subla_destino, null, null, '-' ||
            m.cod_subla_destino))
        as destino,
        m.dt_mov,
        m.itelog_item_cod_item,
        a.endereco,
        m.qtd,
        a.qtde_endereco,
        a.qtde_acerto,
        m.usuario,
        a.obs
        ,m.lote
    from wms_mov_estoques_cd m
           left join wms_acerto_estoque_cd a on (a.wms_acertoestoquecd_id = m.wms_acertoestoque_id)
    ) movtos
        left join item on (item.codigo = movtos.itelog_item_cod_item)
--where itelog_item_cod_item = '0328'
where trunc(dt_mov) between TO_DATE('20231127','YYYYMMDD') and TO_DATE('20231127','YYYYMMDD')
--and lote = '13522201'
--and origem = 'AV-1-1'
--and destino = 'AV-1-1'
and endereco = 'AV-1-1'
order by dt_mov

select *
from wms_mov_estoques_cd m
--where itelog_item_cod_item = '0328'
--where trunc(dt_mov) between TO_DATE('20231106','YYYYMMDD') and TO_DATE('20231106','YYYYMMDD')
where trunc(dt_mov) >= TO_DATE('20231105','YYYYMMDD')
and qtd = 0

-- quando endereco origem vazio, foi gerada etiqueta de entrada direto pelo Full

select count (*) from wms_acerto_estoque_cd
where sincronizado != 'S'
and rownum <= 100  -- primeiras 10 linhas
and wms_acertoestoquecd_id in (203508,203509)

select *
from V_ALIANCA_ESTOQUES
where rownum <= 100
and item_cod_item_log = '30720'
--and lote = '1234567890'


select * from wms_estoques_cd
where item_cod_item_log = '0083'
and lote = '13003101'


select * from v_wms_estoques_alianca where cod_item = '0151'

select tipo_rua || '-' || case tipo_rua
        when 1 then 'crossdocking'
        when 2 then 'armazenagem'
        when 9 then 'indisponivel'
        else '' end as descr_tipo_rua
    , wms_ruas_armazenagens.*
from wms_ruas_armazenagens
where rownum <= 100
order by cod_ruasarm

/*
select * from wms_etiquetas
where rownum <= 1000  -- primeiras 10 linhas
and dthr like '%23'
and item_cod_item = '0345' or wms_etiqueta_id in ('2000609298')

select * from wms_etiquetas_itens
where rownum <= 100  -- primeiras 10 linhas
and item_cod_item = '3576'
and etitens_id in ('2000571587', '2000571588', '2000571727', '2000566899')
and trunc(dthr) between TO_DATE('20220901','YYYYMMDD') and TO_DATE('20220912','YYYYMMDD')
order by dthr

select * from wms_lotes
where rownum <= 100  -- primeiras 10 linhas
and item_cod_item = '3576'

select * from pedidos
where rownum <= 100
order by dthr desc
*/

/*
-- Procura por locais com mais de um item:
select endereco_id, count (*)
from wms_estoques_cd
group by endereco_id
having count (*) > 1

select * --sum (qtd)
from wms_estoques_cd
where situacao != 'L'
and item_cod_item_log = '0151'
where rownum <= 100

where endereco_id = 4461

select * from wms_enderecos
where rownum <= 100
--and id = 5761
and endereco_formatado = 'I-56-5'


select * from ger_usuarios
left join ger_usu_grupos
on (ger_usu_grupos.ger_usugrupo_id = ger_usuarios.ger_usugrupo_id)
where upper (nomecompleto) not like '%PESSOA%'

select ger_usuarios.*, ger_usu_grupos.descricao as descricao_grupo
from ger_usuarios
left join ger_usu_grupos
on (ger_usu_grupos.ger_usugrupo_id = ger_usuarios.ger_usugrupo_id)

select * from wms_colaboradores
order by nome

select rownum, tc.prioridade, tc.tarefas_cod_tarefa, t.descr_tarefa
from wms_tarefas_colaboradores tc
    left join wms_tarefas t
    on (t.empr_codemp = tc.empr_codemp
    and t.cod_tarefa  = tc.tarefas_cod_tarefa)
where colab_cod_colab = 24
order by tc.prioridade, tc.tarefas_cod_tarefa

select * from wms_tarefas_cd t
where itelog_item_cod_item = '30616'
and qtd = 92
and lote = '13221101'
   and t.empr_codemp = 1
           and t.centdist_cod_centdist = 1
           and t.tarefas_cod_tarefa in (1, 25)

           and t.dt_fim is null
       
  select * from wms_autorizacoes a
        where a.item_cod_item = '30616'
        and autorizacao in (348107,348775)
        --and a.situacao_wms = '1'
           
  
-- ultimos movimentos de estoque do usuario
select ger_usuarios.nome, ger_usuarios.nomecompleto, wms_acerto_estoque_cd.*
from wms_acerto_estoque_cd
left join ger_usuarios on (ger_usuarios.ger_usuario_id = wms_acerto_estoque_cd.colab_cod_colab)
where rownum <= 1000
and colab_cod_colab = 35
order by dthr desc

select * from wms_logs
where rownum <= 100
and (colab_cod_colab = 35 or usuario like 'GUILHERMET%')
*/





select * from wms_logs
where rownum <= 1000
and item_cod_item = '4553'
and data >= '01/08/23'









select * --placa_nfe, dthr_autorizacao, situacao. decode (dthr_autorizacao, null, '', dthr_autorizacao) as dthr
from wms_autorizacoes_recebimentos
--    left join wms_tarefas_cd
--        on (wms_tarefas_cd.empr_codemp = wms_autorizacoes_recebimentos.empr_codemp
--        and wms_tarefas_cd.centdist_cod_centdist = wms_autorizacoes_recebimentos.centdist_cod_centdist
--        and wms_tarefas_cd.autrec_autrec_id = wms_autorizacoes_recebimentos.autrec_id)
where rownum <= 1000
--and autrec_id = 369908
--and dthr = '18/09/23'
and placa_nfe between 2000654906 and 2000655635
and placa_nfe in (2000655638, 2000655635)


select * from wms_sub_tarefas_cd
where rownum <= 1000
and pal_palete_id = 2000647875

select * from wms_sub_tarefas_cd
where rownum <= 1000
and tarcd_cod_tarefa_cd = 1509787
--and pal_palete_id = 2000647875



