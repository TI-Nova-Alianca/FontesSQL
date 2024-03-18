/*
create or replace FUNCTION FNC_ALIANCA_FKARDEX
--(produto in varchar2)
RETURN t_movtos PIPELINED AS
BEGIN
  --PIPE ROW(t_movtos(1, 2));
    select * from wms_parametros
RETURN;
END;
/
*/
--create or replace procedure prc_alianca_kardex(in_produto in varchar2, out_retorno out sys_refcursor) as
create or replace procedure prc_alianca_kardex(out_retorno out sys_refcursor) as
begin
open out_retorno for
          select *
            from wms_mov_estoques_cd
           where rownum <= 10;
           --and itelog_item_cod_item = in_produto;
end prc_alianca_kardex;

select * from TABLE(prc_alianca_kardex())


https://stackoverflow.com/questions/36849917/oracle-stored-procedures-that-return-a-dataset
https://stackoverflow.com/questions/101033/how-to-return-multiple-rows-from-the-stored-procedure-oracle-pl-sql
https://dba.stackexchange.com/questions/68295/how-to-return-a-result-set-from-oracle-procedure
