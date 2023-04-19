# DIPCAST - CUSTOM

DCCE 사용 예제
***

### DCCE 스크립트 파일 수정 (전화수신시 DID 번호별로 각기 다른 링그룹으로 수신통화를 분기)
>
> 1. 파일 목록에서 수정할 스크립트 파일을 클릭합니다.
> 1. 스크립트를 수정하고, 저장합니다.
>
> ```
> [T2_cos-all](+)
> 
> [acastar-incoming]
> exten => in,1,NoOp(아카스타 전화 수신, DID: ${DID_NUMBER})
>  same => n,Set(OPERATION=12000) ;; 운영
>  same => n,Set(MANAGE=13000) ;; 경영
>  same => n,Set(LAB=14000) ;; 연구
>  same => n,Set(EDUCATION=15000) ;; 교육(전화영어)
>  same => n,Set(CHANNEL(accountcode)=07043199999) ;; 녹취구분
> 
>  ;same => n,GotoIf($["${DID_NUMBER}"="07043199999"]?T2_ext-ringgroups,12000,1) ;; 테스트
> ```
>
> <img src="resources/images/dcce-dialplan.png">
>
### DIPCAST VOIP > 어플리케이션 > 커스텀 컨텍스트에 적용
>
> 1. 좌측 메뉴에 ```VOIP```를 클릭합니다.
> 1. 좌측 메뉴에 ```어플리케이션```을 클릭합니다.
> 1. 좌측 메뉴에 ```커스텀 컨텍스트```를 클릭합니다.
> 1. ```DCCE```에서 작성한 스크립트 내용을 확인하여 각 항목에 맞게 입력합니다.
>       1. context : ```acastar-incoming```
>       1. exten : ```IN```
>       1. priority : ```1```
> <img src="resources/images/dcce-custom-context.png">
