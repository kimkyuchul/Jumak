# Jumak

<img width="960" alt="Slide 16_9 - 156 (1)" src="https://github.com/kimkyuchul/Jumak/assets/25146374/a25386dc-9f7f-4a73-b7bf-d196d60cc05a">

### [📱 앱 설치하러 가기](https://apps.apple.com/kr/app/%EC%A3%BC%EB%A7%89/id6470310590)

> 내 주변의 막걸리 주막 찾기 🍶, Jumak
> 
> 
> v1.0.0 **개발기간: 2023.09.26 ~ 2023.10.23**
> 
> **지속적인 업데이트**: 2023.10.23 ~ (진행중)


# **✨ 프로젝트 주요 화면**

![주막 레포 이미지 002](https://github.com/kimkyuchul/Jumak/assets/25146374/3339ee27-0b54-4150-ae2b-0dfaf33ef380)

### 주요 기능
- 사용자 위치 기반 막걸리, 파전, 보쌈 주막 찾기 기능 제공
- 주막 즐겨찾기, 평점 등록 및 해당 주막애서의 에피소드 작성, 조회
- 평점, 즐겨찾기, 에피소드 등록을 통한 주막 리스트 조회 및 다양한 필터링

# **⚙️ 개발환경 및 기술스택**

- Minimum Deployments: iOS 15.5
- Dependence Manager : **SPM & CocoaPod(NaverMap)**
- Swift Version: 5.8.1
- `UIKit` `MVVM` `RxSwift` `RxCocoa`
- `Codebase UI` `SnapKit`
- `DiffableDataSource` `CompositionalLayout` `PHPickerViewController` `RxDataSources` `RxGesture`
- `CoreLocation` `NaverMap`
- `Alamofire` `RxReachability`
- `RealmSwift`

# 🫡 TroubleShooting

1. **검색한 위치가 GeocodeLocation을 할 수 없는 지역일 경우 런타임 오류 이슈**

```swift
func reverseGeocodeLocation(location: CLLocation) -> Observable<String> {
        let geocoder = CLGeocoder()
        return Observable.create { emitter in
             geocoder.reverseGeocodeLocation(location) { placemarks, error in
                 if let error = error {
                     emitter.onError(error)
                     return
                 }
                 
                 guard let placemark = placemarks?.first else {
                     emitter.onError(error.unsafelyUnwrapped)
                     return
                 }
                 
                 let formattedAddress = self.getAddressString(from: placemark)
                 emitter.onNext(formattedAddress)
                 emitter.onCompleted()
             }
             return Disposables.create()
         }
     }
```
UscCase의 CLGeocoder을 통해 Address String Observable을 반환하는 메서드에서 알 수 없는 위치에서 주막 재 검색 시 `if let error = error` 로 빠지는 걸 확인할 수 있었다.

공식 문서를 찾아본 결과 특정 위치에 정보를 사용할 수 없는 경우 에러를 준다는 것을 확인했다.

```swift
/// 1번 - 스트림 끊김
input.didSelectRefreshButton
            .withUnretained(self)
            .flatMapLatest { owner, location in
                let reverseGeocodeObservable = owner.locationUseCase.reverseGeocodeLocation(location: location.convertToCLLocation)
                return reverseGeocodeObservable
            }
            .subscribe(onNext: { locationAddress in
                output.currentUserAddress.accept(locationAddress)
            }) { error in
                output.currentUserAddress.accept("알 수 없는 지역")
            }
            .disposed(by: disposeBag)

/// 2번 - 스트림이 유지
input.didSelectRefreshButton
            .withUnretained(self)
            .flatMapLatest { owner, location in
                let reverseGeocodeObservable = owner.locationUseCase.reverseGeocodeLocation(location: location.convertToCLLocation)
                    .catchAndReturn("알 수 없는 지역입니다.")
                return reverseGeocodeObservable
            }
            .bind(to: output.currentUserAddress)
            .disposed(by: disposeBag)
```
2. **CollectionView 페이징 시 Cell에 보여지는 Index와 Map의 Annotation도 동일한 Index로 선택 & 맵 중심 좌표 이동 로직 구현**
   
![Simulator Screen Recording - iPhone 14 Pro Max - 2023-10-27 at 22 47 28](https://github.com/kimkyuchul/Jumak/assets/25146374/6413c8cf-ed8a-439f-bff1-5c228bfbe29c)

ViewModel에서 위치 재검색 버튼 선택 시 flatMap을 통해 위의 reverseGeocodeLocation을 Output의 currentUserAddresst에 바인딩 하고 있었다. 해당 구문에서 에러 처리가 필요했다.

1번처럼 처리할 경우 subscribe의 error로 떨어진 이후 스트림이 끊겨서 위치 재검색 버튼 이벤트가 방출되지 않는다.

2번처럼 flatMap의 catchAndReturn을 통해 Error Default값을 보내고 스트림이 끊기지 않도록 처리했다.


- [[RxSwift] 어노테이션 선택 시 콜렉션뷰 스크롤 이벤트때문에 여러 마커를 선택하고 오는 이슈](https://medium.com/@kyuchul2/ios-compositional-layout%EC%9D%98-visibleitemsinvalidationhandler-%ED%99%9C%EC%9A%A9-190cde90c933)
- [[RxSwift] 왓챠식 3중 필터 구현기](https://medium.com/@kyuchul2/ios-compositional-layout%EC%9D%98-visibleitemsinvalidationhandler-%ED%99%9C%EC%9A%A9-190cde90c933)
- [[RxSwift] Location이 업데이트 될 때만 Network Call 하도록 구현하기](https://medium.com/@kyuchul2/ios-compositional-layout%EC%9D%98-visibleitemsinvalidationhandler-%ED%99%9C%EC%9A%A9-190cde90c933)
- [[UIKit] DiffableDatasource에서 헤더만 apply가 되지 않는 이슈](https://medium.com/@kyuchul2/ios-compositional-layout%EC%9D%98-visibleitemsinvalidationhandler-%ED%99%9C%EC%9A%A9-190cde90c933)
- [[UIKit] Presentation Layer Model을 활용하여 Local DB에 Image Data가 저장되지 않게 구현하기](https://medium.com/@kyuchul2/ios-compositional-layout%EC%9D%98-visibleitemsinvalidationhandler-%ED%99%9C%EC%9A%A9-190cde90c933)

















# **✨ 프로젝트 주요 기능**

🔑 내 위치 근처 혹은 내가 검색하고 싶은 위치에서 막걸리 주막을 찾을 수 있어요.

![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 05 37](https://github.com/kimkyuchul/Makgulli/assets/25146374/a111f000-fc9d-4d19-a665-f20426d2537a)
![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 07 03](https://github.com/kimkyuchul/Makgulli/assets/25146374/0ee4602d-b8a7-4737-8393-130d67e0ea61)

🔑 막걸리지도에서 찾은 주막을 선택해 상세 정보를 얻으세요. 주막까지의 길찾기 기능과 즐겨찾기 및 평점 등록이 가능합니다.

![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 35 00](https://github.com/kimkyuchul/Makgulli/assets/25146374/e762f7f1-1cc9-4104-924d-7630bdf24346)

🔑 해당 주막에서 있었던 에피소드를 등록하세요. 에피소드 조회와 삭제도 가능합니다.

![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 43 26](https://github.com/kimkyuchul/Makgulli/assets/25146374/40ea16e7-76c9-47ea-9baf-649333024084)
![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 39 30](https://github.com/kimkyuchul/Makgulli/assets/25146374/25bafd2e-3c7f-464f-8bd6-76e6e08890f8)

🔑 평점, 즐겨찾기, 에피소드 등록을 통해 나만의 주막 리스트를 만들어보세요. 다양한 필터 기능으로 최적화된 주막을 선정 할 수 있습니다.

![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 53 56](https://github.com/kimkyuchul/Makgulli/assets/25146374/488a5c69-ebc0-469d-be8c-907cc6a84d97)
![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 46 58](https://github.com/kimkyuchul/Makgulli/assets/25146374/4863929b-9d03-4e5f-b180-e56d9f1a5836)

# **🔥 기술적 도전**

### Clean Architecture

<img width="770" alt="스크린샷 2023-11-02 오후 3 46 22" src="https://github.com/kimkyuchul/Makgulli/assets/25146374/f4e8f02b-cb4a-4ba7-90dc-a1309eba53bd">


**Why**

- 약 4주라는 기간 안에 앱스토어 출시라는 목표를 잡았습니다. 디자인, 기획 등이 개발 중에도 수정되어, 서비스의 방향과 스펙, UI 등이 변경될 수 있다고 생각했습니다. 핵심 비즈니스 로직과 변경이 자주 발생하는 외부의 레이어를 명확하게 분리하여 결합도를 낮출 수 있는 구조 설계를 고민했고, Clean-Architecture을 채택하게 되었습니다.

**Result**

- ViewModel의 비즈니스 로직들을 UseCase로, 네트워크나 외부 프레임워크에 대한 요청은 Repository로 분리해 각 레이어의 역할을 분명하게 나누어, 코드의 결합도를 낮추고, 의존성이 Domain Layer를 향하도록 구현할 수 있었습니다.
- MVVM 구조에서 ViewModel이 모든 비즈니스 로직을 처리하는 것을 피할 수 있었습니다.
- 각각의 레이어를 역할에 따라 분리하여 방대한 양의 코드를 쉽게 파악할 수 있었습니다.

  ---

### MVVM + Input Output Patten

<img width="480" alt="스크린샷 2023-11-02 오후 5 55 40" src="https://github.com/kimkyuchul/Makgulli/assets/25146374/5cb7a0ce-1e36-4358-90a6-6cdc396662b7">

**Why**

- 뷰가 화면을 그리는 역할만 담당하고, 비즈니스 로직에 대한 분리를 위해 MVVM 패턴을 도입했습니다.
- iOS MVVM은 표준이 없고 구현하는 사람마다 패턴이 다를 수 있습니다. MVVM 패턴을 정형화하고, 데이터 흐름을 단방향으로 관리하기 위해 Input/Output 패턴을 활용했습니다.

**Result**

- 화면에서 일어나는 모든 이벤트를 Input으로 정의하여 비즈니스 로직을 요청하고, 결과로 갱신되는 값들을 Output에 바인딩해 뷰 컨트롤러는 Ouput을 보고 화면을 그리도록 구현할 수 있었습니다.
- Input/Output 패턴을 활용해 일관성 있는 구조의 뷰모델 코드를 만들 수 있어, 가독성을 높일 수 있었습니다.

  ---

### RxSwift


**Why**

- 각 객체에서 연속된 escaping closure으로 인한 연속된 콜백의 데이터 흐름을 피하고 싶었습니다.
- Notification Center, GCD등 복합적이고 다양한 비동기 API를 활용하기 보단, 일관된 비동기 프레임워크 활용하고 싶었습니다.

**Result**

- escaping closure가 아닌 RxSwift의 Operator를 활용하여 코드 양이 감소하고, 이해하기 쉬워졌습니다. 코드의 방대해짐과 실수를 방지할 수 있었습니다.
- 오로지 RxSwift만 활용해 하나의 비동기 코드로 개발할 수 있었고, 기존의 복합적인 비동기코드의 가독성을 올리고 유지보수를 쉽게 만들 수 있었습니다.
- RxTraits를 활용해 Thread 관리를 쉽고 간편하게 할 수 있었습니다.

  ---

주막 서비스의 주차별 개발 일지를 보고 싶으시다면! [🍶 주막 프로젝트 Iteration](https://www.notion.so/bee21dc07a0a46aea22f20a6a15c3615?pvs=21)
