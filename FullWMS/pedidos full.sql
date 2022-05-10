/*
select * from pedidos
where num_pedido = '2001049257'
where dthr between TO_DATE('20220101','YYYYMMDD') and TO_DATE('20220110','YYYYMMDD')
WHERE saida_id = 'DAK0104925701'
*/
-- 'DAK' + DAK_FILIAL + DAK_COD + DAK.DAK_SEQCAR AS saida_id
select p.saida_id, l.* from linhas_pedidos l, pedidos p
where p.num_pedido = l.num_pedido
--and rownum <= 100
and p.saida_id = 'DAK0104925701'

