ALTER VIEW MVA_MOTREJEICAOLIBER AS
select codigo codigo_MOTREJ,
       descricao descricao_MOTREJ,
       observacao observacao_MOTREJ
  from db_motivo_rejeicao
