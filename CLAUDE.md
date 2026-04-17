# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Jumak (주막 / "Makgulli") is a published iOS app (App Store id6470310590) that helps users find nearby makgeolli pubs, save favorites, rate them, and log episodes. Minimum iOS 15.5, Swift 5.8.1, UIKit-based.

The Xcode target is named **`Makgulli`** — open `Makgulli.xcodeproj`. All dependencies are SPM.

## Build / Release

```sh
# Install Ruby deps (fastlane)
bundle install

# Open project
open Makgulli.xcodeproj

# TestFlight release (CI runs this on push/PR to main)
bundle exec fastlane tf
```

`fastlane tf` requires env vars (`KEYCHAIN_NAME`, `KEYCHAIN_PASSWORD`, `MATCH_PASSWORD`, `APP_STORE_CONNECT_API_KEY_*`) and SSH access to two private sibling repos:
- `kimkyuchul/Jumak-fastlane-certificate` — match certificate storage (appstore + development)
- `kimkyuchul/Jumak-iOS-ignored` — checked out into `Makgulli/Common/Resource/APIKey` to supply gitignored API key files

The GitHub Actions workflow (`.github/workflows/swift.yml`) bootstraps both via `shimataro/ssh-key-action` and an `ACTION_TOKEN`. There is no separate lint/test job — CI exists only to ship TestFlight builds.

## Architecture

Clean Architecture + MVVM-C with RxSwift. The `Makgulli/` source root is split by layer, and the dependency rule points inward toward `Domain`:

```
Application/    AppDelegate, SceneDelegate, Coordinator/, DIContainer/
Presentation/   Feature folders (Location, LocationDetail, Favorite,
                EpisodeDetail, WriteEpisode, AppInfo) each containing
                View/, ViewModel/, Coordinator/. Presentation/Common/
                holds Splash and Tabbar.
Domain/         UseCase/ (Location, Favorite, Episode), VO/,
                RepositoryInterface/ — pure Swift, no framework imports.
Data/           Repositories/ (concrete impls of Domain interfaces),
                Network/ (API, DTO+Mapping, Foundation), Persistence/
                (Realm, FileManager).
Common/         Base/, Extension/, Enum/, Literal/, Protocal/ [sic],
                Resource/ (Assets, Fonts, Info.plist, APIKey/),
                Service/, UIComponent/, Util/.
```

Key conventions:

- **Coordinators own navigation.** Each feature has its own coordinator; `AppCoordinator` wires the root and the tabbar. Use `RootHandler.shard.update(.main)` to swap roots (e.g. Splash → Main after network check).
- **DI is manual via `*DIContainer` classes** under `Application/DIContainer/`. When adding a screen, wire it up through the matching container (`LocationDIContainer`, `FavoriteDIContainer`, `EpisodeDIContainer`, `AppInfoDIContainer`) rather than constructing dependencies ad hoc.
- **ViewModels use an Input/Output pattern.** All user events are modeled as `Input` Observables; all bindings to the view come from `Output` Relays/Subjects. Follow this structure — one-way, consistent — rather than exposing arbitrary public methods on the ViewModel.
- **`BaseViewController` binds network reachability.** It manages a `Reachability` instance (start/stop in `viewWillAppear`/`viewWillDisappear`) and shows an alert on disconnect. Screens that host `NaverMap` (Splash → Main → LocationDetail) additionally gate navigation on `reachability?.rx.isConnected` / `isReachable` to avoid NaverMap's `-1020` infinite-retry loop when offline — preserve this gating if you touch those flows.
- **Map ↔ CollectionView sync is intentional.** `CompositionalLayout.visibleItemsInvalidationHandler` drives a `visibleItemsRelay` that the ViewModel consumes to move the map camera and select annotations. The input Observable is `debounce(.milliseconds(300))`'d on purpose — this prevents `selectItem` scroll animations from re-triggering marker selection and "walking" through intermediate annotations. Don't remove the debounce.
- **Geocoding streams must not break.** `reverseGeocodeLocation` can error for unknown regions; wrap it with `catchAndReturn("알 수 없는 지역입니다.")` inside `flatMapLatest` so the outer stream (e.g. refresh-button taps) keeps emitting.

## Testing

Unit tests live in `MakgulliTests/` and target the **UseCase layer** (Domain). Stack is `XCTest` + `RxBlocking` for synchronous assertions, with `RxTest` linked to the test target for virtual-time scheduling when needed.

```
MakgulliTests/
  UseCase/      XCTestCase per UseCase (SearchLocationUseCaseTests, FavoriteUseCaseTests,
                LocationDetailUseCaseTests, EpisodeDetailUseCaseTests, WriteEpisodeUseCaseTests).
                Streams are drained via `.toBlocking().first()` / `.materialize()`.
  Mock/         Hand-written mocks conforming to Domain's RepositoryInterface
                (MockSearchLocationRepository, MockFavoriteRepository, …). Each UseCase has
                its remote + local repo mocks.
  TestHelper/   Fixture factories (e.g. `StoreVOFactory`) for building Domain VOs.
```

## Secrets / ignored files

`Makgulli/Common/Resource/APIKey/` is gitignored and populated at CI time from the `Jumak-iOS-ignored` repo. Locally you'll need to place the same API key files there for the app to build and for NaverMap / network calls to work. Don't commit anything into that directory.
