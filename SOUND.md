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