use naweb

select count (*) from TrnNucAcesso
--where TrnNucAcessoUsu = 'andressa.brugnera'
--where TrnNucAcessoPro like '%sa1010%'
order by TrnNucAcessoDat desc

select * from SecUser where SecUserName = 'pedro.toniolo'


-- usuarios sem codigo de pessoa (tenta localizar no Metadados)
select distinct v.SecUserName
	, (select max (TrnNucAcessoDat) from TrnNucAcesso where TrnNucAcessoUsu = v.SecUserName) as ult_acesso
	, META.NOME, META.PESSOA, META.DESCRI_SITUACAO + ' ' + META.DESC_FUNCAO
from VA_VUSUARIOS_X_PERFIS_X_FUNCIONALIDADES v
	left join LKSRV_SIRH.SIRH.dbo.VA_VFUNCIONARIOS META
		on (upper (META.NOME) COLLATE DATABASE_DEFAULT like upper (substring (v.SecUserName, 1, 4)) + '%'
		AND upper (META.NOME) COLLATE DATABASE_DEFAULT like '%' + upper (substring (v.SecUserName, len (v.SecUserName)-2, 3))
		)
where v.SecUserPessoa is null
order by v.SecUserName


-- funcionalidades que o usuario acessa e em quais perfil elas se encontram
select TrnNucAcessoUsu, TrnNucAcessoPro, count (*), max (TrnNucAcessoDat)
	, (select string_agg (SecRoleName + '(' + v.SecRoleDescription + ')', ', ')
		from VA_VUSUARIOS_X_PERFIS_X_FUNCIONALIDADES v
		where v.SecUserName = TrnNucAcesso.TrnNucAcessoUsu
		and v.SecFunctionalityKey = TrnNucAcesso.TrnNucAcessoPro)
from TrnNucAcesso
where TrnNucAcessoPro not in ('WWPBaseObjects.WpnNucEntrar - LOGIN')  -- Telas que todo mundo usa
and TrnNucAcessoUsu like 'deniandra%'
group by TrnNucAcessoUsu, TrnNucAcessoPro
order by count (*) desc

-- acessos de usuarios demitidos (poderia remover esses acessos)
select distinct v.SecUserId, v.SecUserName, v.SecUserPessoa, v.SecRoleId, v.SecRoleDescription
	, (select max (TrnNucAcessoDat) from TrnNucAcesso where TrnNucAcessoUsu = v.SecUserName) as ult_acesso
	,(select DESCRI_SITUACAO + ' ' + DESC_FUNCAO from LKSRV_SIRH.SIRH.dbo.VA_VFUNCIONARIOS META where META.PESSOA = v.SecUserPessoa)
from VA_VUSUARIOS_X_PERFIS_X_FUNCIONALIDADES v
where exists (select * from LKSRV_SIRH.SIRH.dbo.VA_VFUNCIONARIOS META where META.PESSOA = v.SecUserPessoa and META.SITUACAO = 4)
order by v.SecUserName , SecRoleDescription


-- perfis do usuario
SELECT cast (SUR.SecRoleId as varchar (max)) + ' - ' + SR.SecRoleDescription
		FROM LKSRV_NAWEB.naweb.dbo.SecUserRole SUR,
			LKSRV_NAWEB.naweb.dbo.SecRole SR
		WHERE SUR.SecUserId = 87
		AND SR.SecRoleId = SUR.SecRoleId

-- pessoas do perfil
SELECT sur.SecRoleId, sr.SecRoleDescription, sur.SecUserId, su.SecUserName, su.SecUserPessoa
FROM naweb.dbo.SecUserRole sur, naweb.dbo.SecUser su, naweb.dbo.SecRole sr
where su.SecUserId = sur.SecUserId
and sr.SecRoleId = sur.SecRoleId
--and su.SecUserName like 'deise%'
and sur.SecRoleId = 195


-- Funcionalidades que o perfil 1 tem e o perfil 2 nao tem
select distinct v1.SecRoleId, v1.SecRoleName, v1.SecFunctionalityId, v1.SecFunctionalityKey, v1.SecFunctionalityDescription
from VA_VUSUARIOS_X_PERFIS_X_FUNCIONALIDADES v1
where v1.SecRoleId = 161
and not exists (select * from VA_VUSUARIOS_X_PERFIS_X_FUNCIONALIDADES v2
				where v2.SecRoleId = 228
				and v2.SecFunctionalityId = v1.SecFunctionalityId)


-- Funcionalidades habilitadas em mais de um perfil
SELECT pf.SecFunctionalityKey
	, case when exists (select *
						from VA_VPERFIS_X_FUNCIONALIDADES base
						where base.SecFunctionalityKey = pf.SecFunctionalityKey
						and base.SecRoleId = 7)
		then 'S'
		else 'N'
		end as Existe_no_perfil_base
	, count (*) Em_quantos_perfis_consta
	, string_agg (cast (pf.SecRoleId as varchar (max)) + '-' + pf.SecRoleDescription, ', ') Perfis_onde_consta
from VA_VPERFIS_X_FUNCIONALIDADES pf
where pf.SecRoleId != 8 -- administrador
group by pf.SecFunctionalityKey
having count (*) > 1


-- quem estah no grupo de manutencao  --, mas nao no de estoques
select distinct SecUserId, SecUserName, SecUserPessoa, SecRoleName
	,(select DESCRI_SITUACAO + ' ' + DESC_FUNCAO from LKSRV_SIRH.SIRH.dbo.VA_VFUNCIONARIOS META where META.PESSOA = v.SecUserPessoa)
from VA_VUSUARIOS_X_PERFIS_X_FUNCIONALIDADES v
where v.SecRoleId = 130  -- manutecao
--and not exists (select *
--				from VA_VUSUARIOS_X_PERFIS_X_FUNCIONALIDADES v2
--				where v2.SecUserId = v.SecUserId
--				and v2.SecRoleId = 149  -- consultas de estoque
--				)




-- Para transferir estq:
-- EstoqueTransferenciaWW
-- WpnEstTransfEstoque
-- WpnEstLibTransfEstoque
-- WWEstoqueTransferencia_Insert
-- Esta parece que não precisa: WpnEstLibTransfEstoquePrompt

select * from SecFunctionality where SecFunctionalityKey = 'SegurosWW'


select * from VA_VUSUARIOS_X_PERFIS_X_FUNCIONALIDADES v1
where v1.SecUserName = 'dagoberto.puton'
and not exists (select * from VA_VUSUARIOS_X_PERFIS_X_FUNCIONALIDADES v2
				where v2.SecUserName = 'paulo.nunes'
				and v2.SecFunctionalityKey = v1.SecFunctionalityKey)




where lower (v.SecFunctionalityKey) = 'wpnconjuridico'

