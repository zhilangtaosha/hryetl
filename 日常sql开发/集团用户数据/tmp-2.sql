WITH TMP_USER AS (
select
t1.HRYID hryid
,t0.phone STAFF_PHONE
,t1.AUTHENT_STATUS_NAME VER_STATE
,t1.kjtid
,t1.CTIME created_time
from bidim.obj_staff_phone t0
inner join BIDATA.DIM_USER_HRY_USERS  t1
on t0.phone=t1.HRY_ACCT or t0.phone=t1.MOBILE
where t1.CTIME < to_date('20170501','yyyymmdd')
)

--select
--sum(T."被推荐人P2P投资金额") P2P投资金额,
--sum(T."被推荐人基金投资金额") 基金投资金额,
--sum(T."被推荐人总投资金额") 总投资金额
--from (
select 
T1.hryid 海融易id,
T1.sjhm 办公手机号码,
T1.PROMOTED_ID 被推荐人海融易id,
T4.MOBILE 被推荐人手机号,
to_char(T4.reg_time,'yyyymmdd hh24:mi:ss') 被推荐人注册时间,
decode(T4.AUTHENT_STATUS,'TG','Y','N') 认证状态,
T2.P2P_ORDER_COUNT 被推荐人P2P投资次数,
T2.P2P_INVEST_AMT 被推荐人P2P投资金额,
T3.fund_order_count 被推荐人基金投资次数,
T3.fund_invest_amount 被推荐人基金投资金额,
T3.fund_order_count+T2.P2P_ORDER_COUNT 被推荐人总投资次数,
T3.fund_invest_amount+T2.P2P_INVEST_AMT 被推荐人总投资金额
from (
select 
t0.HRYID,
t0.STAFF_PHONE SJHM,
t1.PROMOTED_ID
from TMP_USER t0
inner join bidata.S_PROMO_PROMOTION_RELATION t1
on t0.HRYID=t1.PROMOTER_ID
where t0.created_time <to_date('20170501','yyyymmdd')
) T1
left join (
select 
t0.F03 hryid,
count(t0.F01) p2p_order_count,
sum(t0.F05) p2p_invest_amt
from bidata.S_S62_T6250 t0
where t0.F06 < to_date('20170501','yyyymmdd') 
and t0.F07='F'
group by t0.F03 ) T2
on T1.PROMOTED_ID=T2.hryid
left join 
(
select
t0.f01 hryid,
t0.kjtid,
count(t1.order_id) fund_order_count,
sum(t1.trans_amt)/100 fund_invest_amount
from bidata.s_s61_t6110 t0
left join funduser.t_fund_share_order@fdb t1
on t0.kjtid=t1.kjt_cust_id
where t1.trans_type='I' and t1.status=5 
and t1.create_time < to_date('20170501','yyyymmdd')
group by t0.f01,t0.kjtid ) T3
on T1.PROMOTED_ID=T3.hryid
left join bidata.dim_user_hry_users T4
on T1.PROMOTED_ID=T4.hryid
where T4.ctime<to_date('20170501','yyyymmdd') 
and T4.CTIME>=to_date('20170401','yyyymmdd')
--) T
--where T."被推荐人总投资次数">0
;