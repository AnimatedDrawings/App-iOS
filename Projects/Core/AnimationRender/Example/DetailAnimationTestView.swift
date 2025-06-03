import ADResources
import ADUIKit
import AnimationRender
import SwiftUI

public struct DetailedAnimationTestView: View {
  @State private var renderer = DevAnimationRendererImpl()
  @State private var selectedBVH: String = "dab"
  @State private var generatedGIFData: Data?
  @State private var isGenerating: Bool = false
  @State private var errorMessage: String?
  @State private var generationTime: Double = 0
  @State private var frameCount: Int = 0
  @State private var gifSize: String = ""
  @State private var showLivePreview: Bool = true

  private let availableBVHFiles = ["dab", "zombie", "jumping", "wave_hello"]

  public init() {}

  public var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        headerSection
        controlSection
        previewSection
        statisticsSection
        resourceInfoSection
      }
      .padding()
    }
  }

  private var headerSection: some View {
    VStack(spacing: 10) {
      Text("🎭 Animation Renderer")
        .font(.largeTitle)
        .fontWeight(.bold)
        .foregroundColor(ADResourcesAsset.Color.blue2.swiftUIColor)

      Text("메시 변형 애니메이션 생성 테스트")
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
  }

  private var controlSection: some View {
    VStack(spacing: 15) {
      // BVH 선택
      VStack(alignment: .leading, spacing: 8) {
        Text("애니메이션 모션")
          .font(.headline)

        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
          ForEach(availableBVHFiles, id: \.self) { bvh in
            Button {
              selectedBVH = bvh
              renderer.updateBVHFileName(bvh)
            } label: {
              VStack {
                Text(getMotionEmoji(for: bvh))
                  .font(.title2)
                Text(bvh.capitalized)
                  .font(.caption)
                  .fontWeight(.medium)
              }
              .frame(maxWidth: .infinity)
              .padding()
              .background(
                selectedBVH == bvh
                  ? ADResourcesAsset.Color.blue1.swiftUIColor : Color.gray.opacity(0.2)
              )
              .foregroundColor(selectedBVH == bvh ? .white : .primary)
              .cornerRadius(10)
            }
          }
        }
      }

      // 생성 버튼
      Button(action: generateAnimationWithStats) {
        HStack {
          if isGenerating {
            ProgressView()
              .scaleEffect(0.8)
          } else {
            Image(systemName: "play.fill")
          }
          Text(isGenerating ? "생성 중..." : "애니메이션 생성")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(isGenerating ? Color.gray : ADResourcesAsset.Color.blue1.swiftUIColor)
        .foregroundColor(.white)
        .cornerRadius(10)
      }
      .disabled(isGenerating)
    }
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(15)
    .shadow(radius: 2)
  }

  private var previewSection: some View {
    VStack(spacing: 15) {
      HStack {
        Text("미리보기")
          .font(.headline)
        Spacer()

        // 실시간 미리보기 토글 버튼
        Button(showLivePreview ? "GIF 보기" : "실시간 보기") {
          showLivePreview.toggle()
        }
        .font(.caption)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(ADResourcesAsset.Color.blue2.swiftUIColor)
        .foregroundColor(.white)
        .cornerRadius(15)

        if generatedGIFData != nil {
          Button("저장", action: saveGIF)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(ADResourcesAsset.Color.blue1.swiftUIColor)
            .foregroundColor(.white)
            .cornerRadius(15)
        }
      }

      RoundedRectangle(cornerRadius: 15)
        .fill(Color.white)
        .shadow(radius: 5)
        .frame(width: 200, height: 300)
        .overlay {
          if isGenerating {
            // 로딩 뷰
            VStack(spacing: 15) {
              ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(
                  CircularProgressViewStyle(tint: ADResourcesAsset.Color.blue1.swiftUIColor))

              Text("애니메이션 생성 중...")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(ADResourcesAsset.Color.blue1.swiftUIColor)

              Text("잠시만 기다려주세요")
                .font(.caption2)
                .foregroundColor(.secondary)
            }
            .frame(width: 180, height: 280)
          } else if showLivePreview {
            // 실시간 미리보기 (캐릭터 이미지 표시)
            Image(uiImage: renderer.characterImage)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 180, height: 280)
              .cornerRadius(10)
          } else if let gifData = generatedGIFData {
            // GIF 미리보기
            GIFImage(gifData: gifData)
              .frame(width: 180, height: 280)
              .cornerRadius(10)
          } else {
            VStack(spacing: 10) {
              Image(systemName: "photo.artframe")
                .font(.system(size: 40))
                .foregroundColor(.gray)
              Text("애니메이션 생성 대기중")
                .font(.caption)
                .foregroundColor(.gray)
            }
          }
        }

      if let errorMessage = errorMessage {
        Text("❌ \(errorMessage)")
          .foregroundColor(.red)
          .font(.caption)
          .padding()
          .background(Color.red.opacity(0.1))
          .cornerRadius(8)
      }
    }
  }

  private var statisticsSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("생성 통계")
        .font(.headline)

      LazyVGrid(
        columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10
      ) {
        StatCard(title: "생성 시간", value: String(format: "%.1fs", generationTime), icon: "clock")
        StatCard(title: "프레임 수", value: "\(frameCount)", icon: "rectangle.stack")
        StatCard(title: "파일 크기", value: gifSize, icon: "internaldrive")
      }
    }
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(15)
    .shadow(radius: 2)
  }

  private var resourceInfoSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("사용된 리소스")
        .font(.headline)

      VStack(spacing: 8) {
        ResourceRow(icon: "photo", name: "example1.png", description: "캐릭터 이미지")
        ResourceRow(icon: "doc.text", name: "char_cfg.yaml", description: "골격 구조 설정")
        ResourceRow(icon: "waveform.path", name: "\(selectedBVH).bvh", description: "모션 데이터")
      }
    }
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(15)
    .shadow(radius: 2)
  }

  private func generateAnimationWithStats() {
    Task {
      let startTime = CFAbsoluteTimeGetCurrent()

      await MainActor.run {
        isGenerating = true
        errorMessage = nil
        generatedGIFData = nil
        generationTime = 0
        frameCount = 0
        gifSize = ""
      }

      print("🎬 [DetailedAnimationTest] 애니메이션 생성 시작")
      print("📋 [DetailedAnimationTest] 설정 - 모션: \(selectedBVH), 시작시간: \(Date())")

      do {
        let gifData = try await renderer.render()

        let endTime = CFAbsoluteTimeGetCurrent()
        let totalTime = endTime - startTime
        let fileSize = ByteCountFormatter.string(
          fromByteCount: Int64(gifData.data.count), countStyle: .file)

        await MainActor.run {
          self.generatedGIFData = gifData.data
          self.generationTime = totalTime
          self.frameCount = 30  // BVH에서 사용한 프레임 수
          self.gifSize = fileSize
          self.isGenerating = false
        }

        print("🎉 [DetailedAnimationTest] 애니메이션 생성 완료!")
        print(
          "📊 [DetailedAnimationTest] 통계 - 소요시간: \(String(format: "%.2f", totalTime))초, 파일크기: \(fileSize), 프레임수: 30"
        )

      } catch {
        let endTime = CFAbsoluteTimeGetCurrent()
        let totalTime = endTime - startTime

        await MainActor.run {
          self.errorMessage = error.localizedDescription
          self.isGenerating = false
        }

        print("❌ [DetailedAnimationTest] 애니메이션 생성 실패")
        print("⏱️ [DetailedAnimationTest] 실패까지 소요시간: \(String(format: "%.2f", totalTime))초")
        print("🔍 [DetailedAnimationTest] 오류 내용: \(error.localizedDescription)")
      }
    }
  }

  private func saveGIF() {
    print("💾 [DetailedAnimationTest] GIF 저장 기능 호출 - 추후 구현 예정")
  }

  private func getMotionEmoji(for bvh: String) -> String {
    switch bvh {
    case "dab": return "🤸‍♂️"
    case "zombie": return "🧟‍♂️"
    case "jumping": return "🦘"
    case "wave_hello": return "👋"
    default: return "🎭"
    }
  }
}

struct StatCard: View {
  let title: String
  let value: String
  let icon: String

  var body: some View {
    VStack(spacing: 5) {
      Image(systemName: icon)
        .foregroundColor(ADResourcesAsset.Color.blue1.swiftUIColor)
      Text(title)
        .font(.caption)
        .foregroundColor(.secondary)
      Text(value)
        .font(.caption)
        .fontWeight(.bold)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(8)
  }
}

struct ResourceRow: View {
  let icon: String
  let name: String
  let description: String

  var body: some View {
    HStack {
      Image(systemName: icon)
        .foregroundColor(ADResourcesAsset.Color.blue1.swiftUIColor)
        .frame(width: 20)

      VStack(alignment: .leading, spacing: 2) {
        Text(name)
          .font(.caption)
          .fontWeight(.medium)
        Text(description)
          .font(.caption2)
          .foregroundColor(.secondary)
      }

      Spacer()
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  DetailedAnimationTestView()
}
