# Animated Drawing
그림을 움직이는 애니메이션으로 바꿔주는 iOS 앱입니다.
https://sketch.metademolab.com/ 웹을 클론코딩 했습니다.


<img src="docs/adapp_preview/Preview_with1.png" width="200px"/><img src="docs/adapp_preview/Preview_with2.png" width="200px"/><img src="docs/adapp_preview/Preview_with3.png" width="200px"/>

<p align="center">
<a href="https://apps.apple.com/app/animated-drawing/id6469684346" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 200px; height: 83px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&amp;releaseDate=1641254400&h=ddfff0c3bd61d9f88f53494b401881d3" alt="Download on the App Store" style="border-radius: 13px; width: 250px; height: 83px;"></a>
</p>


# Micro Feature Architecture
[Tuist 공식문서](https://docs.tuist.io/building-at-scale/microfeatures/)에서 µFeatures Architecture라 불리우는 Micro Feature Architecture를 적용했습니다. 프로젝트의 모듈 분리는 아래 그래프 그림과 같습니다.

## Dependencies Graph
<img src="graph.png"/>

### 5 Layer
- App : 프로젝트 앱
- Presentation : 뷰와 뷰로직 관련 코드
- Domain : 데이터를 Presentation 영역에 사용할 수 있게 가공
- Core : 데이터 CRUD 작업을 할 수 있는 Storage
- Shared : ThirdPartyLibrary와 같은 공용 모듈

### Presentation ADFeature
<img src="docs/ADFeature.png"/>

- 왼쪽이 Tuist의 µFeature, 오른쪽이 제 프로젝트의 ADFeature
- 하나의 모듈에 다섯개 target을 만든 µFeature 구조를 착안해 Presentation영역에 적용했습니다.
    - ViewExample : 데모 앱
    - ViewTest : View, Feature 테스트코드
    - View : UI 관련 코드, Feature를 의존
    - Feature : 로직 관련 코드

# Library
- [TCA](https://github.com/pointfreeco/swift-composable-architecture)

# Rules
- [Swift Style Guide](https://github.com/airbnb/swift)
- [Commit Convention](docs/CommitConvention.md)
- Git Flow 적용
    - main, develop, (feature, design ...) 브랜치 운영
    - 되도록 두줄
