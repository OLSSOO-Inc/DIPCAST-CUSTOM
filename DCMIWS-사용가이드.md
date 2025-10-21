# 🚀 DIPCAST DCMIWS API 문서 

> **Version 1.0** | 최종 업데이트: 2025년 10월  
> DIPCAST DCMIWS API 완벽 가이드 - 착신전환 및 클릭투콜 관리

---

## 📑 목차

1. [🎯 기본 개념](#-기본-개념)
2. [📊 응답 타입](#-응답-타입)
3. [⚠️ 에러 유형](#️-에러-유형)
4. [💚 Core 서비스 상태 확인](#-core-서비스-상태-확인)
5. [📞 착신전환 관리](#-착신전환-관리)
6. [🎯 착신번호 설정](#-착신번호-설정)
7. [☎️ 클릭투콜 (Click to Call)](#️-클릭투콜-click-to-call)
8. [📋 빠른 참조](#-빠른-참조)

---

## 🎯 기본 개념

### 🔒 고정 파라미터

| 파라미터 | 설명 | 예시 |
|:--------|:-----|:-----|
| **TenantID** | 멀티테넌트 구성시 회사별 구분 값 | `7be69580e27641df` |

### 🔧 변수 파라미터

| 파라미터 | 설명 | 예시 |
|:--------|:-----|:-----|
| **AMIServerID** | 다중 서버인 경우 서버의 ID | `1`, `2` |
| **ExtensionID** | 착신전환을 사용할 단말번호 | `2471`, `45144800` |
| **Value** | 설정 값 | `yes`, `no` |
| **ssl** | SSL 사용여부 | `true`, `false` |
| **Action** | DCMIWS에서 제공하는 액션 | `ping`, `Command`, `Originate` |
| **Command** | DCMIWS에서 제공하는 명령 | `database get`, `database put` |
| **ActionID** | 요청 구분을 위한 고유 ID | `DIPCAST-{AMIServerID}-{TenantID}-{ExtensionID}-{설명}-{유니크값}` |

### 📝 기본 요청 포맷

```json
{
   "AMIServerID": {{AMIServerID}},
   "data": {
      "Action": "ping",
      "ActionID": "DIPCAST-{{AMIServerID}}-Custom"
   }
}
```

> **💡 Tip:** ActionID는 요청과 응답을 매칭하는 핵심 식별자입니다. 명확하고 일관된 네이밍 규칙을 사용하세요.

---

## 📊 응답 타입

응답 메시지의 `type` 필드는 다음과 같은 값을 가질 수 있습니다:

| Type | 값 | 설명 | 비고 |
|:-----|:---|:-----|:-----|
| **Unknown** | `0` | 알 수 없는 타입 | 오류 상황 |
| **Prompt** | `1` | 프롬프트 | 사용자 입력 대기 |
| **Action** | `2` | 액션 | 실행 요청 |
| **Event** | `3` | 이벤트 | 시스템 알림 |
| **Response** | `4` | 응답 | 일반 응답 메시지 |
| **Response with command output** | `5` | 명령 출력 포함 응답 | 명령 실행 결과 포함 |
| **Queues list** | `6` | 큐 목록 | AMI 텍스트 형식 |

> **🎯 주요 타입:** 대부분의 응답은 `type: 4` (Response)를 사용합니다.

---

## ⚠️ 에러 유형

### 🔴 Database 관련 에러

| 에러 메시지 | 원인 | 해결 방법 |
|:-----------|:-----|:---------|
| `Database entry not found` | 데이터베이스에 해당 항목이 없음 | 키 경로 확인 또는 초기값 설정 |
| `Usage: database put <family> <key> <value>` | 문법 오류 (put 명령) | `database put` 명령 형식 재확인 |
| `a given family, key, and value` | 파라미터 누락 | family, key, value 모두 제공 확인 |

> **⚡ 주의:** `database get`과 `database put` 명령의 파라미터 순서와 개수를 정확히 지켜야 합니다.

---

## 📞 착신전환 종류

### 📋 착신전환 타입 개요

| 약어 | 전체 명칭 | 한글명 | 설명 | 적용 조건 |
|:-----|:----------|:------|:-----|:---------|
| **CFI** | CallForwardImmediately | 즉시 착신전환 | 어떠한 조건없이 무조건 착신전환 | 즉시 |
| **CFB** | CallForwardBusy | 통화중 착신전환 | 통화중이면 착신전환 | 통화중일 때 |
| **CFN** | CallForwardNoanswer | 부재중 착신전환 | 일정시간 동안 전화를 안 받으면 착신전환 | 일정시간 미응답시 |
| **CFU** | CallForwardUnavailable | 미연결 착신전환 | 단말기(IP전화기)가 서버에 등록이 안된 경우 착신전환 | 단말기 미등록시 |

> **💡 참고:** 각 착신전환 타입은 독립적으로 설정 가능하며, 동시에 여러 타입을 활성화할 수 있습니다.

---

## 💚 Core 서비스 상태 확인

서버의 정상 작동 여부를 확인하는 Ping/Pong 메커니즘입니다.

### 🖥️ 첫 번째 Core 서버 확인

#### 📤 요청 (Request)

```json
{
   "AMIServerID": 1,
   "data": {
      "Action": "ping",
      "ActionID": "DIPCAST-CoreServiceCheck-1-Custom"
   }
}
```

#### 📥 응답 (Response)

```json
{
    "type": 4,
    "server_id": 1,
    "server_name": "dcrm.makecall.io",
    "ssl": false,
    "data": {
        "Response": "Success",
        "ActionID": "DIPCAST-CoreServiceCheck-1-Custom",
        "Ping": "Pong",
        "Timestamp": "1760579048.983137"
    }
}
```

**✅ 성공 확인:**
- `Response: "Success"`
- `Ping: "Pong"`
- Timestamp 반환

---

### 🖥️ 두 번째 Core 서버 확인

#### 📤 요청 (Request)

```json
{
   "AMIServerID": 2,
   "data": {
      "Action": "ping",
      "ActionID": "DIPCAST-CoreServiceCheck-2-Custom"
   }
}
```

#### 📥 응답 (Response)

```json
{
    "type": 4,
    "server_id": 2,
    "server_name": "dcrm2.makecall.io",
    "ssl": false,
    "data": {
        "Response": "Success",
        "ActionID": "DIPCAST-CoreServiceCheck-2-Custom",
        "Ping": "Pong",
        "Timestamp": "1760579202.514635"
    }
}
```

> **💡 활용:** 주기적인 Ping으로 서버 헬스체크를 구현할 수 있습니다.

---

## 📞 착신전환 관리

---

### 🚨 중요 사항

> **⚠️ CFI 착신전환 활성화 필수 조건:**
> 
> 1. ✅ `diversions/{단말번호}/CFI/enable` 값이 **`yes`** 이어야 함
> 2. ✅ `diversions/{단말번호}/CFI/destination` 에 **착신번호**가 설정되어 있어야 함
> 
> **두 조건 중 하나라도 충족하지 않으면 착신전환이 작동하지 않습니다!**

**🔧 기본값:** `yes`

---

### 🔍 착신전환 여부 조회

#### 📤 요청 (Read Request)

**시나리오:** 테넌트 `7be69580e27641df`의 `1010` 단말번호 착신전환 상태 확인

```json
{
   "AMIServerID": 1,
   "data": {
      "Action": "Command",
      "Command": "database get 7be69580e27641df diversions/1010/CFI/enable",
      "ActionID": "DIPCAST-ServerID_1-7be69580e27641df-1010-CFI-Custom"
   }
}
```

---

#### 📥 응답 - ❌ 사용안함 (no)

```json
{
    "type": 4,
    "server_id": 1,
    "server_name": "dcrm.makecall.io",
    "ssl": false,
    "data": {
        "Response": "Success",
        "ActionID": "DIPCAST-ServerID_1-7be69580e27641df-1010-CFI-Custom",
        "Message": "Command output follows",
        "Output": "Value: no"
    }
}
```

**🔴 상태:** 착신전환 비활성화

---

#### 📥 응답 - ✅ 사용함 (yes)

```json
{
    "type": 4,
    "server_id": 1,
    "server_name": "dcrm.makecall.io",
    "ssl": false,
    "data": {
        "Response": "Success",
        "ActionID": "DIPCAST-ServerID_1-7be69580e27641df-1010-CFI-Custom",
        "Message": "Command output follows",
        "Output": "Value: yes"
    }
}
```

**🟢 상태:** 착신전환 활성화

---

### ✅ 착신전환 활성화 (yes로 변경)

#### 📤 요청 (Update Request)

**시나리오:** 테넌트 `7be69580e27641df`의 `1010` 단말번호 착신전환 켜기

```json
{
   "AMIServerID": 1,
   "data": {
      "Action": "Command",
      "Command": "database put 7be69580e27641df diversions/1010/CFI/enable yes",
      "ActionID": "DIPCAST-ServerID_1-7be69580e27641df-1010-CFI-yes-Custom"
   }
}
```

#### 📥 응답 (Update Response)

```json
{
    "type": 4,
    "server_id": 1,
    "server_name": "dcrm.makecall.io",
    "ssl": false,
    "data": {
        "Response": "Success",
        "ActionID": "DIPCAST-ServerID_1-7be69580e27641df-1010-CFI-yes-Custom",
        "Message": "Command output follows",
        "Output": "Updated database successfully"
    }
}
```

**✅ 결과:** 착신전환이 활성화되었습니다.

---

### ❌ 착신전환 비활성화 (no로 변경)

#### 📤 요청 (Update Request)

**시나리오:** 테넌트 `7be69580e27641df`의 `1010` 단말번호 착신전환 끄기

```json
{
   "AMIServerID": 1,
   "data": {
      "Action": "Command",
      "Command": "database put 7be69580e27641df diversions/1010/CFI/enable no",
      "ActionID": "DIPCAST-ServerID_1-7be69580e27641df-1010-CFI-no-Custom"
   }
}
```

#### 📥 응답 (Update Response)

```json
{
    "type": 4,
    "server_id": 1,
    "server_name": "dcrm.makecall.io",
    "ssl": false,
    "data": {
        "Response": "Success",
        "ActionID": "DIPCAST-ServerID_1-7be69580e27641df-1010-CFI-no-Custom",
        "Message": "Command output follows",
        "Output": "Updated database successfully"
    }
}
```

**✅ 결과:** 착신전환이 비활성화되었습니다.

---

## 🎯 착신번호 설정

착신전환될 목적지 번호를 설정하고 관리합니다.

**🔧 기본값:** `null`

---

### 🔍 착신번호 조회

#### 📤 요청 (Read Request)

**시나리오:** 테넌트 `7be69580e27641df`의 `1010` 단말번호의 착신번호 확인

```json
{
   "AMIServerID": 1,
   "data": {
      "Action": "Command",
      "Command": "database get 7be69580e27641df diversions/1010/CFI/destination",
      "ActionID": "DIPCAST-ServerID_1-7be69580e27641df-1010-착신번호조회-Custom"
   }
}
```

#### 📥 응답 (Read Response)

**현재 착신번호:** `01099552471`

```json
{
    "type": 4,
    "server_id": 1,
    "server_name": "dcrm.makecall.io",
    "ssl": false,
    "data": {
        "Response": "Success",
        "ActionID": "DIPCAST-ServerID_1-7be69580e27641df-1010-착신번호조회-Custom",
        "Message": "Command output follows",
        "Output": "Value: sub-custom-numbers,01099552471,1"
    }
}
```

**📊 Output 형식:** `sub-custom-numbers,{착신번호},1`

---

### 🔄 착신번호 변경

#### 📤 요청 (Update Request)

**시나리오:** 착신번호를 `01026132471`로 변경

```json
{
   "AMIServerID": 1,
   "data": {
      "Action": "Command",
      "Command": "database put 7be69580e27641df diversions/1010/CFI/destination sub-custom-numbers,01026132471,1",
      "ActionID": "DIPCAST-ServerID_1-7be69580e27641df-1010-착신번호변경-01026132471-Custom"
   }
}
```

#### 📥 응답 (Update Response)

**새 착신번호:** `01026132471`

```json
{
    "type": 4,
    "server_id": 1,
    "server_name": "dcrm.makecall.io",
    "ssl": false,
    "data": {
        "Response": "Success",
        "ActionID": "DIPCAST-ServerID_1-7be69580e27641df-1010-착신번호변경-01026132471-Custom",
        "Message": "Command output follows",
        "Output": "Updated database successfully"
    }
}
```

**✅ 결과:** 착신번호가 성공적으로 변경되었습니다.

> **💡 Tip:** 착신번호 변경 후에는 반드시 `enable`이 `yes`인지 확인하세요!

---

## ☎️ 클릭투콜 (Click to Call)

즉시 통화를 연결하는 기능입니다. REST API 와 WebSocket 방식, 두 가지 방식을 지원합니다.

---

### 🌐 REST API 방식 (추천)

REST API를 통한 더 간편한 클릭투콜 방식입니다.
인증을 위해 아래의 2개 정보를 헤더에 필수로 추가해야합니다.

```
(예제)
tenant: 7be69580e27641df
app-key: 얼씨구절씨구
```

#### 📡 엔드포인트

```
POST https://{{host}}/api/v2/core/click_to_call
```

#### 📤 요청 Body

**계정번호:** `07045805605`

```json
{
    "caller": "1010",
    "callee": "16682471",
    "cos_id": "2",
    "cid_name": "얼쑤팩토리",
    "cid_number": "16662471",
    "variables": {
        "EXEC_AA": "yes",
        "CHANNEL(language)": "ko",
        "CHANNEL(accountcode)": "07045805605"
    }
}
```

#### 📋 필드 설명

| 필드 | 설명 | 예시 |
|:-----|:-----|:-----|
| `caller` | 발신 단말번호 | `1010` |
| `callee` | 수신 전화번호 | `16682471` |
| `cos_id` | COS ID (Class of Service) | `2` |
| `cid_name` | 발신자 표시 이름 | `얼쑤팩토리` |
| `cid_number` | 발신자 표시 번호 | `16662471` |
| `variables` | 추가 설정 변수 | 객체 |

> **💡 Tip:** REST API 방식이 WebSocket보다 구현이 간단하며, 대부분의 경우 권장됩니다.

---

### 🌐 WebSocket 방식

#### 📝 파라미터 설명

| 파라미터 | 설명 | 예시 |
|:--------|:-----|:-----|
| `{단말번호}` | 착신전환이 설정된 단말번호 | `1010`, `1013` |
| `{발신번호}` | 발신하고자 하는 전화번호 | `07045144801`, `01026132471` |
| `{070번호}` | CDR에서 통화구분을 위한 전화번호 | `07045805605` |
| `{발신자이름}` | 본인과 상대방에 표시될 이름 | `얼쑤팩토리`, `지화자` |
| `{발신자번호}` | 본인과 상대방에 표시될 번호 | `16682471`, `16662471` |
| `{실행ID}` | 클릭투콜 개별실행을 구분하기 위한 ID | `DIPCAST-C2C` |

---

#### 📋 기본 포맷

```json
{
   "AMIServerID": 1,
   "data": {
      "Action": "Originate",
      "Channel": "Local/{단말번호}@T2_cos-all",
      "Context": "T2_cos-all",
      "Exten": "{발신번호}",
      "Priority": "1",
      "Timeout": "30000",
      "Variable": "EXEC_AA=yes",
      "Variable": "CHANNEL(language)=ko",
      "Variable": "CHANNEL(accountcode)={070번호}",
      "Callerid": "{발신자이름} <{발신자번호}>",
      "ActionID": "{실행ID}",
      "EarlyMedia": "true",
      "Async": "yes"
   }
}
```

---

#### 📞 예시 1: 얼쑤팩토리 → 07045144801

**통화 시나리오:**
- 발신자: `1010` (착신번호: `01026132471`)
- 수신자: `07045144801`
- 계정번호: `07045805605`

```json
{
   "AMIServerID": 1,
   "data": {
      "Action": "Originate",
      "Channel": "Local/1010@T2_cos-all",
      "Context": "T2_cos-all",
      "Exten": "07045144801",
      "Priority": "1",
      "Timeout": "30000",
      "Variable": "EXEC_AA=yes",
      "Variable": "CHANNEL(language)=ko",
      "Variable": "CHANNEL(accountcode)=07045805605",
      "Callerid": "얼쑤팩토리 <16682471>",
      "ActionID": "DIPCAST-C2C",
      "EarlyMedia": "true",
      "Async": "yes"
   }
}
```

**📊 통화 흐름:**
1. 단말 `1010`이 먼저 호출됨
2. 착신전환 설정에 따라 `01026132471`로 연결됨
3. 응답 후 자동으로 `07045144801`과 연결됨

---

#### 📞 예시 2: 지화자 → 01026132471

**통화 시나리오:**
- 발신자: `1013`
- 수신자: `01026132471`
- 계정번호: `07045805605`

```json
{
   "AMIServerID": 1,
   "data": {
      "Action": "Originate",
      "Channel": "Local/1013@T2_cos-all",
      "Context": "T2_cos-all",
      "Exten": "01026132471",
      "Priority": "1",
      "Timeout": "30000",
      "Variable": "EXEC_AA=yes",
      "Variable": "CHANNEL(language)=ko",
      "Variable": "CHANNEL(accountcode)=07045805605",
      "Callerid": "지화자 <07045805605>",
      "ActionID": "DIPCAST-C2C",
      "EarlyMedia": "true",
      "Async": "yes"
   }
}
```

---

## 📋 빠른 참조

### 🎯 주요 명령어 패턴

```bash
# 조회 (GET)
database get {TenantID} {Key}

# 변경 (PUT)
database put {TenantID} {Key} {Value}
```

### 🗝️ 주요 Database 키

| 기능 | Key 패턴 | Value 예시 |
|:-----|:---------|:----------|
| 착신전환 활성화 | `diversions/{단말번호}/CFI/enable` | `yes` / `no` |
| 착신번호 설정 | `diversions/{단말번호}/CFI/destination` | `sub-custom-numbers,01012345678,1` |

### ✅ 응답 확인 체크리스트

- [ ] `Response: "Success"` - 요청 성공
- [ ] `Output: "Updated database successfully"` - DB 업데이트 성공
- [ ] `Output: "Value: {값}"` - 조회된 값
- [ ] `Ping: "Pong"` - 서버 정상 작동

### 🔄 일반적인 워크플로우

#### 착신전환 설정 워크플로우

```
1. 착신전환 상태 조회
   ↓
2. 착신번호 설정/확인
   ↓
3. 착신전환 활성화 (enable → yes)
   ↓
4. 설정 확인
```

#### 클릭투콜 워크플로우

```
1. 착신전환 설정 확인
   ↓
2. WebSocket 또는 REST API 호출
   ↓
3. 발신자 단말 호출
   ↓
4. 착신번호로 전환
   ↓
5. 수신자 연결
```

---

## 🎓 추가 참고사항

### 💡 Best Practices

1. **ActionID 명명 규칙**
   - 일관된 형식 사용: `DIPCAST-{기능}-{서버ID}-{테넌트ID}-{단말번호}-{설명}`
   - 디버깅을 위해 의미있는 이름 사용

2. **에러 처리**
   - 항상 `Response` 필드 확인
   - `Database entry not found` 에러 시 기본값 설정 고려

3. **착신전환 설정**
   - enable과 destination을 함께 확인
   - 변경 후 조회로 설정 검증

4. **클릭투콜**
   - Timeout 값은 상황에 맞게 조정 (기본 30초)
   - Async 옵션으로 비동기 처리 권장

### 🔐 보안 고려사항

- TenantID는 민감 정보로 취급
- API 엔드포인트는 인증된 요청만 허용
- 로그에 개인 전화번호 노출 주의

### 📞 지원

문제가 발생하거나 추가 정보가 필요한 경우:
- 기술 지원 문의
- API 문서 업데이트 확인
- 로그 분석 및 ActionID 추적

---

## 📄 문서 정보

- **작성일:** 2025년 10월
- **버전:** 1.0
- **대상:** DIPCAST DCMIWS API 개발자 및 관리자
- **라이선스:** 내부 사용 전용

---

**🎉 문서 끝**

> 이 문서는 DIPCAST DCMIWS API의 모든 핵심 기능을 다룹니다.  
> 실제 구현 시 각 예시를 참고하여 개발하시기 바랍니다.