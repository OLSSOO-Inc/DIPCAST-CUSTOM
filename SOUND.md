# DIPCAST - CUSTOM

CUSTOM 사운드 파일 
***
### CUSTOM 사운드 파일 사용
> ```
> same => n,Answer() ;채널이 연결된 상태에서만 음성이 재생됩니다.
> ; 환영합니다 재생 (silence/1 -> 1초 묵음)
> same => n,Playback(silence/1&custom/welcome)
> ; 죄송합니다 재생 (silence/1 -> 1초 묵음)
> same => n,Playback(silence/1&custom/sorry)
> ```

|파일 이름| 재생 내용|
|:---------:|:---------:|
|hi | 안녕하세요|
|sorry | 죄송합니다|
|error | 에러|
|time | 시간|
|welcome | 환영합니다|
|goodbye| 이용해 주셔서 감사합니다|
|activated| 설정되었습니다|
|de-activated| 해제되었습니다|
|yipnida| 입니다|
|minutes| 분|
|seconds| 초|
|dot | 점|
|agent-pass|비밀번호를 누르시고 우물정자를 누르세요|
|cannot-complete-as-dialed|일시적으로 통화가 불가능하거나 발신이 금지된 번호입니다|
|check-number-dial-again |번호를 확인하시고 다시 걸어주세요|
|cannot-complete-network-error |네트워크 장애로 통화가종료됩니다|
|announce_record | 서비스 개선을 위해 통화 내용이 녹음됨을 알려드립니다|
|auth-incorrect |입력하신 비밀번호가 다릅니다|
|auth-thankyou| 감사합니다|
|080-dnd-intro|마케팅 문자 메세지 수신거부 등록시스템입니다 |
|080-dnd-input-number|발송되는 문자 메세지에 대해 수신거부를 원하시면 고객님의 핸드폰 번호를 입력하신후 우물정자를 누르세요 |
|080-dnd-confrim-1-2|등록 번호가 맞으면 일번, 아니면 이번으로 눌러주세요 |
|080-dnd-incorrect | 입력번호가 다릅니다|
|080-dnd-timeout | 5초안에 입력해 주세요|
|080-dnd-play-cidnumber-pre|고객님의 번호는|
|080-dnd-input-number-short|등록을 원하는 번호를 입력하시고 우물정자를 누르세요|
|080-dnd-wrong-number|입력하신 번호가 고객정보와 일치 하지 않습니다. 다시 입력해 주세요|
|080-dnd-complete|수신거부 등록이 정상적으로 처리되었습니다|
|080-dnd-end-retry|이용 방법을 확인하시고 다시 전화 주세요|
|080-dnd-wrong-mobile-number|등록 가능한 번호가 아닙니다. 다시 입력해 주세요 |
|080-dnd-play-inputnumber-pre | 입력하신  번호는|
|080-dnd-intro-brand|당신의 더 나은 커뮤니티 여정을 함께 하는 주식회사 얼쑤팩토리|
|gc-unique-check|현재 동일 이름의 회의가 진행중입니다. 잠시 후에 다시 이용해 주세요 |
|gc-invite|그룹통화의 참석자로 초대되었습니다 |
|gc-admin-menu|시작할 그룹통화 번호를 눌러주세요|
|gc-password-invalid|회의 비밀번호를 확인후 다시 이용해 주세요|