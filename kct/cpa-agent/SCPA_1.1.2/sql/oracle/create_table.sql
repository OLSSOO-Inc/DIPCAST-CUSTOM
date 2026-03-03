CREATE TABLE  {tableName} (
    SEQ_NUM varchar2(20) NOT NULL,
    R_DATE varchar2(24) DEFAULT NULL,
    ORGADDR varchar2(32) DEFAULT NULL,
    DSTADDR varchar2(32) DEFAULT NULL,
    CALLBACK varchar2(32) DEFAULT NULL,
    MESSAGE varchar2(2000) DEFAULT NULL,
    SRC_TYPE char(1) DEFAULT NULL,
    PRIMARY KEY (SEQ_NUM)
);

CREATE INDEX idx_sms_rDate ON {tableName}(R_DATE);