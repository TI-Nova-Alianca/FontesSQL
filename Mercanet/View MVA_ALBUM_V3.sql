
ALTER VIEW  MVA_ALBUM_V3 AS

---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	03/04/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   27/05/215   tiago           alterado where para nao repetir o codigo do album
---------------------------------------------------------------------------------------------------

select distinct a.CODIGO      codigo_ALBUM,
       a.NOME      nome_ALBUM,
       a.EXCLUIDO    excluido_ALBUM,
       a.data_atualizacao  dataalter,
       usuario
  from DB_ALBUM a, mva_albumproduto_v3 b
 where CODIGO = b.album_ALPRO

