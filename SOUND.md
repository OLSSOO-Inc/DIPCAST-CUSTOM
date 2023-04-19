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