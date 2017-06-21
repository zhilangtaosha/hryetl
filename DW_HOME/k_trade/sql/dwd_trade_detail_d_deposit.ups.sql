SELECT * FROM;



SELECT payment_seq_no,count(*) FROM  K_TRADE.DWD_TRADE_DETAIL_D   --partition(P201703 )
GROUP BY payment_seq_no
having count(*) > 1

ALTER TABLE K_TRADE.DWD_TRADE_DETAIL_D TRUNCATE SUBPARTITION P201706_DEPOSIT

INSERT INTO "K_TRADE"."DWD_TRADE_DETAIL_D" 
SELECT  
     TRADE_VOUCHER_NO      
    ,PAYMENT_VOUCHER_NO    
    ,PAYMENT_SEQ_NO        
    ,'DEPOSIT' TRADE_SOURCE          
    ,'充值' TRADE_TYPE 
    ,NULL TRADE_TYPE_DESC
    ,NULL TRADE_PAYMENT_TYPE    
    ,BIZ_PRODUCT_CODE      
    ,BIZ_PRODUCT_CODE_DESC 
    ,PRODUCT_CODE          
    ,AMOUNT                
    ,TRADE_FEE             
    ,ACCESS_CHANNEL        
    ,MEMBER_ID             
    ,ACCOUNT_NO            
    ,CASE WHEN UPPER(PAY_MODE) in ('ONLINE_BANK','QPAY') THEN BANK_CODE ELSE null END  BANK_CODE  
    ,TRADE_STATUS ORI_TRADE_STATUS          
    ,TRADE_PAYMENT_STATUS ORI_TRADE_PAYMENT_STATUS      
    ,TRADE_STATUS TRADE_STATUS          
    ,TRADE_PAYMENT_STATUS TRADE_PAYMENT_STATUS  
    ,PAY_MODE              
    ,PAY_MODE_DESC         
    ,PAY_CHANNEL           
    ,PAYMENT_TYPE          
    ,PAYMENT_CODE          
    ,MEMBER_ID PAYEE_MEMBER_ID       
    ,MEMBER_TYPE PAYEE_MEMBER_TYPE     
    ,ACCOUNT_NO PAYEE_ACCOUNT_NO      
    ,NULL PAYEE_ACCOUNT_TYPE    
    ,NULL PAYEE_BANK_CODE       
    ,NULL PAYEE_BANK_ACCOUNT_NO 
    ,TRADE_FEE PAYEE_FEE             
    ,NULL PAYER_MEMBER_ID       
    ,NULL PAYER_MEMBER_TYPE     
    ,NULL PAYER_ACCOUNT_NO      
    ,NULL PAYER_ACCOUNT_TYPE    
    ,CASE WHEN UPPER(PAY_MODE) in ('ONLINE_BANK','QPAY') THEN BANK_CODE ELSE null END PAYER_BANK_CODE       
    ,NULL PAYER_BANK_ACCOUNT_NO 
    ,NULL PAYER_FEE         
    
    ,channel.CMF_SEQ_NO
    ,channel.CMF_ORDER_STATUS  
    ,channel.INST_ORDER_NO 
    ,channel.INST_ORDER_STATUS
    ,channel.FUND_CHANNEL_CODE
    ,channel.FUND_CHANNEL_NAME
    ,channel.CHANNEL_ORDER_TYPE
    ,channel.REAL_PAY_MODE        
    
    ,'充值' Accounting_TYPE
    ,MEMBER_ID Accounting_OWNER_ID    
    
    ,TRADE_GMT_CREATE      
    ,TRADE_PAYMENT_GMT_CREATE
    ,PAYMENT_GMT_CREATE    
    ,CMF_GMT_CREATE
    ,sysdate DW_CREATE_TIME        
    ,sysdate DW_MODIFIED_TIME   
 FROM
 (SELECT 
           d.TRADE_VOUCHER_NO  TRADE_VOUCHER_NO
          ,d.BIZ_PRODUCT_CODE  BIZ_PRODUCT_CODE
          ,c.PRODUCT_CODE PRODUCT_CODE
          ,c.MEMO BIZ_PRODUCT_CODE_DESC
          ,d.AMOUNT  AMOUNT
          ,d.ACCESS_CHANNEL ACCESS_CHANNEL
          ,d.TRADE_STATUS  TRADE_STATUS
          ,d.GMT_CREATE TRADE_GMT_CREATE
       FROM K_TRADE.DWD_DEPOSIT_ORDER_D d 
       LEFT OUTER JOIN K_LKP.BUSINESS_PRODUCT_CODE c
          ON d.BIZ_PRODUCT_CODE = c.BIZ_PRODUCT_CODE
        WHERE d.GMT_CREATE >= to_date('20170101','YYYYMMDD'）
    ) deposit_order

LEFT OUTER JOIN 
      (
      SELECT 
           d.PAYMENT_VOUCHER_NO  PAYMENT_VOUCHER_NO
          ,d.TRADE_VOUCHER_NO TRADE_VOUCHER_NO_P
          --,PRODUCT_CODE  
          ,d.MEMBER_ID   
          ,u.MEMBER_TYPE
          ,d.ACCOUNT_NO   
          --,AMOUNT  
          ,d.FEE  TRADE_FEE
          ,d.PAY_MODE  
          ,c.REMARK PAY_MODE_DESC
          ,d.PAY_CHANNEL  
          ,d.PAYMENT_STATUS  TRADE_PAYMENT_STATUS
          --,EXT
          ,regexp_replace( regexp_substr(d.EXT,'"BANK_CODE":"[[:alnum:]]+',1,1),'"BANK_CODE":"') BANK_CODE
          ,d.GMT_CREATE TRADE_PAYMENT_GMT_CREATE
          --,d.ACCESS_CHANNEL TRADE_PAYMENT_ACCESS_CHANNEL
       FROM K_TRADE.DWD_DEPOSIT_PAYMENT_ORDER_D d 
       LEFT OUTER JOIN K_USER.DIM_USER u
         on d.MEMBER_ID = u.member_id
       LEFT OUTER JOIN k_lkp.pay_mode c
            ON d.PAY_MODE = c.PAY_MODE
        WHERE d.GMT_CREATE >= to_date('20170101','YYYYMMDD'）  
 
      ) deposit_payment
    ON deposit_order.TRADE_VOUCHER_NO = deposit_payment.TRADE_VOUCHER_NO_P

LEFT OUTER JOIN 
      (SELECT   
            PAYMENT_SEQ_NO
           ,PAYMENT_TYPE
           ,PAYMENT_CODE
           ,PAYMENT_ORDER_NO
           --,PAY_MODE
           --,PAY_CHANNEL 
           ,GMT_CREATE PAYMENT_GMT_CREATE
        FROM K_TRADE.DWD_PAYMENT_ORDER_D  
         WHERE GMT_CREATE >= to_date('20170101','YYYYMMDD') 
      )payment_order
    ON deposit_payment.PAYMENT_VOUCHER_NO = payment_order.PAYMENT_ORDER_NO    


LEFT OUTER JOIN 
 (
  SELECT 
     PAYMENT_SEQ_NO CHANNEL_PAYMENT_SEQ_NO
    ,CMF_SEQ_NO
    , CMF_ORDER_STATUS  
    , INST_ORDER_NO 
    , INST_ORDER_STATUS
    , FUND_CHANNEL_CODE
    , FUND_CHANNEL_NAME
    , ORDER_TYPE CHANNEL_ORDER_TYPE
    , REAL_PAY_MODE REAL_PAY_MODE  
    ,GMT_CREATE CMF_GMT_CREATE
  FROM K_CHANNEL.DWD_FUND_CHANNEL_ORDER_D 
  WHERE  GMT_CREATE >= to_date('20170101','YYYYMMDD')
 ) channel
on payment_order.PAYMENT_SEQ_NO = channel.CHANNEL_PAYMENT_SEQ_NO;

COMMIT;



 






