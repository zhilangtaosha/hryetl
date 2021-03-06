CREATE TABLE K_TRADE.DWD_DEPOSIT_ORDER_D 
(
  TRADE_VOUCHER_NO VARCHAR2(32 BYTE) NOT NULL 
, BIZ_PRODUCT_CODE VARCHAR2(16 BYTE) 
, AMOUNT NUMBER(15, 2) 
, ACCESS_CHANNEL VARCHAR2(16 BYTE) 
, GMT_SUBMIT TIMESTAMP(6) 
, TRADE_STATUS VARCHAR2(16 BYTE) NOT NULL 
, GMT_CREATE TIMESTAMP(6) NOT NULL 
, GMT_MODIFIED TIMESTAMP(6) 
, BIZNO VARCHAR2(32 BYTE) 
, DW_CREATE_TIME TIMESTAMP(6) 
, DW_MODIFIED_TIME TIMESTAMP(6) 
) 

PARTITION BY RANGE ("GMT_CREATE") INTERVAL (NUMTOYMINTERVAL(1,'MONTH')) (PARTITION "P_MONTH_1"  VALUES LESS THAN (TO_DATE('20150101','YYYYMMDD')));

COMMENT ON TABLE K_TRADE.DWD_DEPOSIT_ORDER_D IS '充值交易订单';

COMMENT ON COLUMN K_TRADE.DWD_DEPOSIT_ORDER_D.TRADE_VOUCHER_NO IS '交易凭证号，主键，统一凭证';
COMMENT ON COLUMN K_TRADE.DWD_DEPOSIT_ORDER_D.BIZ_PRODUCT_CODE IS '产品编码';
COMMENT ON COLUMN K_TRADE.DWD_DEPOSIT_ORDER_D.AMOUNT IS '交易金额';
COMMENT ON COLUMN K_TRADE.DWD_DEPOSIT_ORDER_D.ACCESS_CHANNEL IS '终端类型';
COMMENT ON COLUMN K_TRADE.DWD_DEPOSIT_ORDER_D.GMT_SUBMIT IS '交易发起时间';
COMMENT ON COLUMN K_TRADE.DWD_DEPOSIT_ORDER_D.TRADE_STATUS IS '交易状态';
COMMENT ON COLUMN K_TRADE.DWD_DEPOSIT_ORDER_D.GMT_CREATE IS '创建时间';
COMMENT ON COLUMN K_TRADE.DWD_DEPOSIT_ORDER_D.GMT_MODIFIED IS '修改时间';
COMMENT ON COLUMN K_TRADE.DWD_DEPOSIT_ORDER_D.DW_CREATE_TIME IS 'DW 创建时间';
COMMENT ON COLUMN K_TRADE.DWD_DEPOSIT_ORDER_D.DW_MODIFIED_TIME IS 'DW 修改时间';