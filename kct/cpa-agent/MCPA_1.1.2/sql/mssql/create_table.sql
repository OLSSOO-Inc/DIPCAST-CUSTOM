CREATE TABLE {tableName}
(
    SEQ_NUM         varchar(20)   DEFAULT NULL,
    MESSAGEID       varchar(128)  DEFAULT NULL,
    R_DATE          datetime      DEFAULT NULL,
    ORGADDR         varchar(32)   DEFAULT NULL,
    DSTADDR         varchar(32)   DEFAULT NULL,
    CALLBACK        varchar(32)   DEFAULT NULL,
    TEXTTYPE        char(1)       DEFAULT NULL,
    CONTENT_TYPE    varchar(4)    DEFAULT NULL,
    SUBJECT         varchar(60)   DEFAULT NULL,
    ATTACH_FILE_NUM varchar(2)    DEFAULT NULL,
    MESSAGE         varchar(2000) DEFAULT NULL,
    PRIMARY KEY (SEQ_NUM)
);

CREATE INDEX idx_mms_rDate ON {tableName}(R_DATE);