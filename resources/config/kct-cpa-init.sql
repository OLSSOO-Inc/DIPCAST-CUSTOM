DROP TABLE IF EXISTS `kct_mms_rcv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `kct_mms_rcv` (
  `SEQ_NUM` varchar(20) DEFAULT NULL COMMENT '고유 식별자 (시스템 내부 번호)',
  `MESSAGEID` varchar(128) DEFAULT NULL COMMENT 'MMS 고유 메시지 ID',
  `R_DATE` datetime(3) DEFAULT NULL COMMENT '수신 일시',
  `ORGADDR` varchar(32) DEFAULT NULL COMMENT '발신자전화번호',
  `DSTADDR` varchar(32) DEFAULT NULL COMMENT '수신자전화번호',
  `CALLBACK` varchar(32) DEFAULT NULL COMMENT '회신 번호 (보통 발신번호)',
  `TEXTTYPE` char(1) DEFAULT NULL COMMENT '본문 텍스트 구분 (예: E:이미자만, P:이미지 + 텍스트)',
  `CONTENT_TYPE` varchar(4) DEFAULT NULL COMMENT 'MMS 타입 (예: IMG:이미자만, IMT:이미지 + 텍스트)',
  `SUBJECT` varchar(60) DEFAULT NULL COMMENT 'MMS 제목',
  `ATTACH_FILE_NUM` varchar(2) DEFAULT NULL COMMENT '첨부 파일 개수',
  `MESSAGE` varchar(2000) DEFAULT NULL COMMENT 'MMS 메시지 본문',
  `member_id` bigint(20) unsigned DEFAULT NULL,
  `distributor_id` bigint(20) unsigned DEFAULT NULL,
  `status` tinyint(3) unsigned NOT NULL DEFAULT 2,
  `completed_at` timestamp NULL DEFAULT NULL,
  KEY `kct_mms` (`R_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='MMS 수신 메시지 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kct_sms_rcv`
--

DROP TABLE IF EXISTS `kct_sms_rcv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `kct_sms_rcv` (
  `SEQ_NUM` varchar(20) DEFAULT NULL COMMENT '고유 식별자 (시스템 내부 번호)',
  `R_DATE` datetime(3) DEFAULT NULL COMMENT '수신 일시',
  `ORGADDR` varchar(32) DEFAULT NULL COMMENT '발신자전화번호',
  `DSTADDR` varchar(32) DEFAULT NULL COMMENT '수신자전화번호',
  `CALLBACK` varchar(32) DEFAULT NULL COMMENT '회신 번호 (보통 발신번호)',
  `MESSAGE` varchar(2000) DEFAULT NULL COMMENT 'SMS 메시지 본문',
  `SRC_TYPE` char(1) DEFAULT NULL COMMENT '수신 소스 구분 (예: 1:SMS)',
  `member_id` bigint(20) unsigned DEFAULT NULL,
  `distributor_id` bigint(20) unsigned DEFAULT NULL,
  `status` tinyint(3) unsigned NOT NULL DEFAULT 2,
  `completed_at` timestamp NULL DEFAULT NULL,
  KEY `kct_sms` (`R_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='SMS 수신 메시지 테이블';