select case when m.wms_acertoestoque_id is null then decode(m.cod_ruasarm_origem, null, 'entrada', 'saida') else 'ajuste inv.' end
as tipo_mov,
decode(m.cod_ruasarm_origem, null, m.codigo_area_origem, m.cod_ruasarm_origem) || '-' ||
m.cod_predio_origem || '-' ||
m.cod_la_origem ||
decode(m.cod_subla_origem, null, null, '-'||
m.cod_subla_origem) as origem,
decode(m.cod_ruasarm_destino, null, m.codigo_area_destino, m.cod_ruasarm_destino || '-' ||
m.cod_predio_destino || '-' ||
m.cod_la_destino ||
decode(m.cod_subla_destino, null, null, '-' ||
m.cod_subla_destino)) as destino,
m.dt_mov,
m.itelog_item_cod_item,
i.descricao,
m.codigo_area_origem,
a.endereco,
m.qtd,
a.qtde_endereco,
a.qtde_acerto,
m.usuario,
a.obs
, m.*
from wms_mov_estoques_cd m
    left join wms_acerto_estoque_cd a on (a.wms_acertoestoquecd_id = m.wms_acertoestoque_id)
    left join item i on (i.codigo = m.itelog_item_cod_item)
--where trunc(m.dt_mov) >= trunc(sysdate-10)
where trunc(m.dt_mov) between TO_DATE('20220101','YYYYMMDD') and TO_DATE('20220110','YYYYMMDD')
--and rownum <= 10  -- primeiras 10 linhas
order by m.dt_mov

/*
select * from pedidos
where rownum <= 100
order by dthr desc
*/


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
