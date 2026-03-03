CREATE TABLE {tableName}
(
    SEQ_NUM  varchar(20)   NOT NULL,
    R_DATE   datetime      DEFAULT NULL,
    ORGADDR  varchar(32)   DEFAULT NULL,
    DSTADDR  varchar(32)   DEFAULT NULL,
    CALLBACK varchar(32)   DEFAULT NULL,
    MESSAGE  varchar(2000) DEFAULT NULL,
    SRC_TYPE char(1)       DEFAULT NULL,
    PRIMARY KEY (SEQ_NUM)
);

CREATE INDEX idx_sms_rDate ON {tableName}(R_DATE);