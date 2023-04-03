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
where itelog_item_cod_item = '0246'
and trunc(dt_mov) between TO_DATE('20221117','YYYYMMDD') and TO_DATE('20221130','YYYYMMDD')
and lote = '12902801'
--and origem != 'PROD01'
order by dt_mov

-- quando endereco origem vazio, foi gerada etiqueta de entrada direto pelo Full

select * from wms_mov_estoques_cd
where trunc(dt_mov) in (TO_DATE('20230303','YYYYMMDD'), TO_DATE('20230303','YYYYMMDD'))
and itelog_item_cod_item = '0151'
--and wms_acertoestoque_id is null

select count (*) from wms_acerto_estoque_cd
where sincronizado != 'S'
and rownum <= 100  -- primeiras 10 linhas
and wms_acertoestoquecd_id in (203508,203509)


-- Estoques e situacao do endereco / estoque
select item_cod_item_log, lote, sum (qtd)
from V_ALIANCA_ESTOQUES
where situacao_rua like '9%'
--and item_cod_item_log = '0345'
group by item_cod_item_log, lote

select *
from V_ALIANCA_ESTOQUES
where item_cod_item_log = '0345'



select distinct situacao from wms_estoques_cd

select * from v_wms_estoques_alianca where cod_item = '0151'

select * from wms_predios
where rownum <= 100
and predio_id = 381

select * from wms_la
where rownum <= 100
and status = 'B'

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
where rownum <= 100  -- primeiras 10 linhas
and wms_etiqueta_id in ('2000571587', '2000571588', '2000571727', '2000566899')

select * from wms_etiquetas_itens
where rownum <= 100  -- primeiras 10 linhas
and item_cod_item = '3576'
and etitens_id in ('2000571587', '2000571588', '2000571727', '2000566899')
and trunc(dthr) between TO_DATE('20220901','YYYYMMDD') and TO_DATE('20220912','YYYYMMDD')
order by dthr

select * from wms_autorizacoes_recebimentos
where rownum <= 100  -- primeiras 10 linhas
AND AUTREC_ID IN (336480,336495,336527,336014,334367)

select * from wms_recebimentos_itens
where rownum <= 100  -- primeiras 10 linhas

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
           
          
select * from V_WMS_ESTOQUES_ALIANCA where cod_item = '30316' 
  
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
and item_cod_item = '30242'
and data = '19/08/22'

select * from wms_etiquetas
where rownum <= 100
and palete_id in ('2000556644','2000557981','2000557982','2000558225','2000558268','2000557375')

select * from wms_lotes
where rownum <= 100
and item_cod_item in ('0243','0151')
and lote in ('003','12911601')

select * from wms_autorizacoes_recebimentos
where rownum <= 100
order by dthr_autorizacao desc
