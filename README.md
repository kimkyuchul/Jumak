# Jumak

<img width="940" alt="Slide 16_9 - 156 (1)" src="https://github.com/kimkyuchul/Jumak/assets/25146374/2739e103-c35a-4491-b42c-a29ed84c6f64">

### [📱 앱 설치하러 가기](https://apps.apple.com/kr/app/%EC%A3%BC%EB%A7%89/id6470310590)

> 내 주변의 막걸리 주막 찾기 🍶, Jumak
> 
> 
> v1.0.0 **개발기간: 2023.09.26 ~ 2023.10.23**
> 
> **지속적인 업데이트**: 2023.10.23 ~ (진행중)


# **✨ 프로젝트 주요 화면**

![주막 레포 이미지 002](https://github.com/kimkyuchul/Jumak/assets/25146374/17b3c9a2-82e3-4eb6-96c3-e44ba259a846)

### 주요 기능
- 사용자 위치 기반 막걸리, 파전, 보쌈 주막 찾기 기능 제공
- 주막 즐겨찾기, 평점 등록 및 해당 주막에서의 에피소드 작성, 조회
- 평점, 즐겨찾기, 에피소드 등록을 통한 주막 리스트 조회 및 다양한 필터링

# **⚙️ 개발환경 및 기술스택**

- Minimum Deployments: iOS 15.5
- Dependence Manager : **SPM & CocoaPod(NaverMap)**
- Swift Version: 5.8.1
- `UIKit` `MVVM` `RxSwift` `RxCocoa`
- `Codebase UI` `SnapKit`
- `DiffableDataSource` `CompositionalLayout` `PHPickerViewController` `RxDataSources` `RxGesture` `RxKeyboard`
- `CoreLocation` `NaverMap`
- `Alamofire` `RxReachability`
- `RealmSwift`
- `Firebase Crashlytics` `Firebase Push Notifications`

# **🔥 기술적 도전**

### Clean Architecture

<img width="770" alt="스크린샷 2023-11-09 오전 2 53 48" src="https://github.com/kimkyuchul/Jumak/assets/25146374/6213f76d-045c-4aea-89f5-5361d49a8c00">

**Why**

- 약 4주라는 기간 안에 앱스토어 출시라는 목표를 잡았습니다. 디자인, 기획 등이 개발 중에도 수정되어, 서비스의 방향과 스펙, UI 등이 변경될 수 있다고 생각했습니다. 핵심 비즈니스 로직과 변경이 자주 발생하는 외부의 레이어를 명확하게 분리하여 결합도를 낮출 수 있는 구조 설계를 고민했고, Clean-Architecture을 채택하게 되었습니다.

**Result**

- ViewModel의 비즈니스 로직들을 UseCase로, 네트워크나 외부 프레임워크에 대한 요청은 Repository로 분리해 각 레이어의 역할을 분명하게 나누어, 코드의 결합도를 낮추고, 의존성이 Domain Layer를 향하도록 구현할 수 있었습니다.
- MVVM 구조에서 ViewModel이 모든 비즈니스 로직을 처리하는 것을 피할 수 있었습니다.
- 각각의 레이어를 역할에 따라 분리하여 방대한 양의 코드를 쉽게 파악할 수 있었습니다.

  ---

### MVVM + Input Output Patten

<img width="500" alt="스크린샷 2023-11-09 오전 3 10 58" src="https://github.com/kimkyuchul/Jumak/assets/25146374/b507a99d-c2b7-4682-99f7-f5b7cd2877cf">

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

# 🫡 TroubleShooting

### 1. **검색한 위치가 GeocodeLocation을 할 수 없는 지역일 경우 런타임 오류 이슈**

CLGeocoder을 활용한 Address String Observable을 반환하는 메서드를 구현했다. 알 수 없는 위치에서 주막 재 검색 시 `if let error = error` 로 빠지는 걸 확인할 수 있었다.

CLGeocoder 공식 문서를 찾아본 결과 특정 위치에 정보를 사용할 수 없는 경우 에러를 준다는 것을 확인했다.

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
ViewModel에서 위치 재검색 버튼 선택 시 flatMap을 통해 위의 reverseGeocodeLocation을 Output의 currentUserAddresst에 바인딩 하고 있었다. 해당 구문에서 에러 처리가 필요했다.

1번처럼 처리할 경우 subscribe의 error로 떨어진 이후 스트림이 끊겨서 위치 재검색 버튼 이벤트가 방출되지 않는다.

2번처럼 flatMap의 catchAndReturn을 통해 Error Default값을 보내고 스트림이 끊기지 않도록 처리했다.

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

---

### 2. **CollectionView 페이징 시 Cell의 Index와 Map Annotation이 동일한 Index로 선택 & 맵 중심 좌표 이동 로직 구현**

![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 06 37](https://github.com/kimkyuchul/Jumak/assets/25146374/66f249df-fed7-4b22-898b-c85f4a55b43b)

위의 영상과 같이 하단 주막 정보 CollectionView를 페이징 시 Annotation과 맵 중심 좌표가 이동되어야 했다.

Compositional Layout의 visibleitemsinvalidationhandler을 활용했다. 
visibleItems.last?.indexPath.row(페이징 될 때 마다 현재 섹션 화면에 표시된 아이템의 indexPath)을 Subject에 담아서 viewModel의 input으로 활용했다.

더불어 transform 속성을 사용하여 페이징 시 셀이 커지고 줄어드는 Carousel view 효과를 적용했다.
```swift
section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) in
            visibleItems.forEach { item in
                let intersectedRect = item.frame.intersection(CGRect(x: offset.x, y: offset.y, width: env.container.contentSize.width, height: item.frame.height))
                let percentVisible = intersectedRect.width / item.frame.width
                
                if percentVisible >= 1.0 {
                    if let currentIndex = visibleItems.last?.indexPath.row {
                        self?.visibleItemsRelay.accept(currentIndex)
                    }
                }
                
                let scale = 0.5 + (0.5 * percentVisible)
                item.transform = CGAffineTransform(scaleX: 0.98, y: scale)
            }
        }        
```
viewModel에선 페이징 시 visibleItems Index 값을 토대로 Annotation과 맵 중심 좌표가 이동되도록 구현했다.

[[iOS] Compositional Layout의 visibleitemsinvalidationhandler 활용](https://medium.com/@kyuchul2/ios-compositional-layout%EC%9D%98-visibleitemsinvalidationhandler-%ED%99%9C%EC%9A%A9-190cde90c933)

```swift
// didScrollStoreCollectionView == visibleItemsRelay
input.didScrollStoreCollectionView
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, visibleIndex in
                guard let index = visibleIndex else { return }
                let store = owner.storeList[index]
                output.setCameraPosition.accept((store.y, store.x))
                output.selectedMarkerIndex.accept(index)
            })
            .disposed(by: disposeBag)
```
---

### 3. **Map의 Annotation 선택 시 CollectionView 스크롤 이벤트 때문에 여러 Annotation을 선택하고 오는 이슈**

![ezgif com-resize (2)](https://github.com/kimkyuchul/Jumak/assets/25146374/e52745c3-651d-497d-8cdf-ebba918b5fad)

2번 이슈에서 CollectionView 페이징 시 visibleItems Index를 방출하여 Cell의 선택된 Index와 Annotation을 동일하게 선택되게 하고, 해당 Index로 맵 중심 좌표를 이동시키게 구현했다.

반대로 Map의 Annotation 선택 시 해당 Annotation 인덱스로 CollectionView가 스크롤되어야 했는데 `selectItem` 애니메이션 때문에 맵 중심 좌표가 여러 마커를 들렸다 오는 이슈를 발견했다.

```swift
output.selectedMarkerIndex
            .distinctUntilChanged()
            .withLatestFrom(output.storeList) { index, storeList in
                return (index, storeList)
            }
            .withUnretained(self)
            .bind(onNext: { owner, data in
                let (selectedIndex, storeList) = data
                owner.setUpMarker(selectedIndex: selectedIndex, storeList: storeList)
                owner.locationView.storeCollectionView.selectItem(at: IndexPath(row: selectedIndex ?? 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            })
            .disposed(by: disposeBag)
```
스크롤(페이징) 이벤트 input 옵저버블에 `debounce` 를 걸었다. `debounce`는 일정 시간동안 새로운 이벤트가 없을 때에만 이벤트를 전달하며, 중간에 들어오는 이벤트들을 무시한다.

이를 활용하여 `selectItem`의 스크롤 애니메이션 때 들어오는 visibleItems Index를 무시하고, 스크롤 애니메이션이 끝나고 마지막에 들어온 visibleItems Index 값만 받아서 선택한 Annotation의 맵 중심 좌표로 이동시킬 수 있었다.

```swift
locationView.visibleItemsRelay.asObservable().debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
```
---

### 4. **RxReachability 네트워크 상태 감지**

NaverMap의 경우 Map이 init되는 시점에 네트워크 연결 실패 시 무한 naver map error code -1020 에러를 방출 -> 즉, Map이 포함된 뷰가 그려지기 전에 네트워크 상태 감지가 필요했다.

더불어 NaverMap을 사용하는 쏘카, 요기요 등의 경우 MapView가 그려지기 전에 네트워크 체크를 진행하는것처럼 보였다. (B에 Map이 포함되어 있다고 치면, A에서 네트워크를 감지해서 네트워크 미연결 시 B로 진입하는 뷰를 막아버림)

BaseViewController에서 Reachability을 활용해 viewWillAppear 시 startNotifier() viewWillDisappear 시 stopNotifier() 되도록 구현하고 reachability?.rx.isDisconnected 시 rx.makeErrorAlert를 방출하도록 했다.

```swift
import Reachability
import RxReachability

class BaseViewController: UIViewController, BaseViewControllerProtocol, BaseBindableProtocol {
    
    var disposeBag: DisposeBag = .init()
    var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            reachability = try Reachability()
        } catch {
            print("Reachability 에러: \(error)")
        }
       
        bindReachability())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? reachability?.startNotifier()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability?.stopNotifier()
    }
        
    func bindReachability() {
        reachability?.rx.isDisconnected
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.rx.makeErrorAlert(
                    title: "네트워크 연결 오류",
                    message: "네트워크 연결이 불안정 합니다.",
                    cancelButtonTitle: "확인"
                )
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
}
```
앱의 첫번째로 보여지는 뷰에서 NaverMap을 사용하고 있었기 때문에, Splash에서 네트워크를 감지하여 `reachability?.rx.isConnected` 시에만 Main으로 이동되도록 했다.

Main에서도 `reachability?.rx.isReachable` 로 네트워크 미연결 뷰를 핸들링하는`rx.handleNetworkErrorViewVisibility`를 바인딩해서 네트워크 미연결 시 Detail로 이동되지 못하도록 구현했다.

```swift
// Splash에서 네트워크를 감지하여, 네트워크 미연결 시 Main으로 이동되지 못하도록 구현 (Main에 Map이 존재하기 때문)
final class SplashViewController: BaseViewController {

override func viewDidLoad() {
        super.viewDidLoad()
        reachability?.rx.isConnected
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                RootHandler.shard.update(.main)
            })
            .disposed(by: disposeBag)
    }

// Main에서 네트워크를 감지하여, 네트워크 미연결 시 Detail로 이동되지 못하도록 구현 (Detail에 Map이 존재하기 때문)
final class LocationViewController: BaseViewController {

override func bindReachability() {
        super.bindReachability()
        
        let isReachable = reachability?.rx.isReachable
            .distinctUntilChanged()
            .share()
        
        isReachable?
            .bind(to: locationView.rx.handleNetworkErrorViewVisibility)
            .disposed(by: disposeBag)
        
        isReachable?
            .withUnretained(self)
            .bind(onNext:{ owner, isReachable in
                if !isReachable {
                    owner.clearMarker()
                }
            })
            .disposed(by: disposeBag)
    }
```

![ezgif com-resize (1)](https://github.com/kimkyuchul/Jumak/assets/25146374/37bf445e-8679-4f71-a51e-4ea8ad068cb2)
![ezgif com-resize](https://github.com/kimkyuchul/Jumak/assets/25146374/a21dae17-b79f-4a7d-b7b3-c5659a8649ec)

  ---

주막 서비스의 주차별 개발 일지를 보고 싶으시다면! [🍶 주막 프로젝트 Iteration](https://www.notion.so/bee21dc07a0a46aea22f20a6a15c3615?pvs=21)

# **🫀 실행 화면**

🍶  내 위치 근처 혹은 내가 검색하고 싶은 위치에서 막걸리 주막을 찾을 수 있어요.

![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 05 37](https://github.com/kimkyuchul/Jumak/assets/25146374/1e0d07bf-c1fb-4c56-9dc8-c0a3b8ec666f)
![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 07 03](https://github.com/kimkyuchul/Jumak/assets/25146374/28b681be-a941-413a-8b87-04415fb43a1b)

🍶  막걸리지도에서 찾은 주막을 선택해 상세 정보를 얻으세요. 주막까지의 길찾기 기능과 즐겨찾기 및 평점 등록이 가능합니다.

![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 35 00](https://github.com/kimkyuchul/Jumak/assets/25146374/a77c3536-884f-46df-8aab-1137acf0315a)

🍶  해당 주막에서 있었던 에피소드를 등록하세요. 에피소드 조회와 삭제도 가능합니다.

![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 43 26](https://github.com/kimkyuchul/Jumak/assets/25146374/a50761bc-c5b4-4440-88ba-a8bed6455884)
![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 39 30](https://github.com/kimkyuchul/Jumak/assets/25146374/7a02d966-b4f6-4fac-bd73-f646606546db)

🍶  평점, 즐겨찾기, 에피소드 등록을 통해 나만의 주막 리스트를 만들어보세요. 다양한 필터 기능으로 최적화된 주막을 선정 할 수 있습니다.

![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 53 56](https://github.com/kimkyuchul/Jumak/assets/25146374/daaae176-dbe2-4b2a-9119-9e394cad87f1)
![Simulator Screen Recording - iPhone 14 Pro - 2023-11-02 at 19 46 58](https://github.com/kimkyuchul/Jumak/assets/25146374/0abca9be-ba36-4f74-827d-1c5d32b76ae1)
