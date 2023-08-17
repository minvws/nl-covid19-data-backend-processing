CREATE   PROC dbo.SP_RECALC_VARIANT_CASES_SET
     @lastDateMasterDataVars datetime
 AS
 BEGIN 
 
 with 
 T as
 (
 	select
 		da.ID,
 		da.VARIANT_CODE,
 		da.VARIANT_CASES,
 		vb.Is_subvariant_of,
 		isnull(vb.Shows_on_vws_dashboard, cast(0 as bit)) as Shows_on_vws_dashboard
 	from
 		##VARIANT_CASES_SET da --SELECTION FROM [VWSINTER].[RIVM_MUTATIONS] (SELECTION FROM MAX DATE_INSERTED AND EACH DISTINCT DATE_OF_STATISTICS_WEEK_START )
 		left join (SELECT * FROM VWSSTATIC.MASTERDATA_VARIANTS WHERE DATE_LAST_INSERTED = @lastDateMasterDataVars) as vb on da.VARIANT_CODE = vb.Variant_code
 ),
 -- Fill in level for each node in tree
 U as 
 (
 	select T.*, cast(1 as int) as [Level]
 	from T
 	where Is_subvariant_of is null or Is_subvariant_of = ''
 
 	union all
 	
 	select T.*, [Level] + 1 as [Level]
 	from U join T on U.VARIANT_CODE = T.Is_subvariant_of
 )
 select *,
 	cast(null as int) as VarCases,
 	cast(0 as int) as Shown
 into #Result
 from U;
 
 declare @level int;
 select @level = max([Level]) from #Result;
 
 -- Tree traversal from leafs to root,
 -- one level each time through the loop
 -- Amount cases is summed up to each parent
 -- if parent is not visible, its number of cases is skipped 
 --else parent amount - child amount = real parent amount
 while @level > 0
 begin
 	with T as
 	(
 		select
 			P.VARIANT_CODE, 
 			case P.Shows_on_vws_dashboard
 				when 1 then P.VARIANT_CASES - sum(isnull(C.Shown,0))
 				else null
 			end as VarCases,
 			case
 				when P.Shows_on_vws_dashboard = 1 then P.VARIANT_CASES
 				else sum(case C.Shows_on_vws_dashboard
 							when 1 then C.VARIANT_CASES
 							else isnull(C.Shown, 0)
 						end)
 			end as Shown
 		from -- P:Parent, C:Child
 			#Result as P
 			left join #Result as C on P.VARIANT_CODE = C.Is_subvariant_of
 		where 
 			P.[Level] = @level
 		group by
 			P.VARIANT_CODE, P.VARIANT_CASES, P.Shows_on_vws_dashboard
 	)
 	update P
 		set 
 			VarCases =	T.VarCases,
 			Shown = T.Shown
 	from
 		#Result as P
 		join T on P.VARIANT_CODE = T.VARIANT_CODE;
 
 	set @level -= 1;
 end
 
 select
 	ID, VARIANT_CODE, VARIANT_CASES, Is_subvariant_of, Shows_on_vws_dashboard, VarCases, Shown
 from #Result
 --returns correct number of cases for each variant and child variants
 
 END