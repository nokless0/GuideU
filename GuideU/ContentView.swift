import SwiftUI

struct ContentView: View {
    @AppStorage("GuideU.finishedOnboarding") private var finishedOnboarding = false
    @AppStorage("GuideU.largeText") private var largeText = false
    @StateObject private var progress = ProgressStore()

    var body: some View {
        Group {
            if finishedOnboarding {
                MainTabs(progress: progress)
            } else {
                OnboardingView {
                    finishedOnboarding = true
                }
            }
        }
        .tint(GuideUTheme.accent)
        .modifier(LargeTextModifier(enabled: largeText))
    }
}

private struct LargeTextModifier: ViewModifier {
    let enabled: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if enabled {
            content.dynamicTypeSize(.accessibility1)
        } else {
            content
        }
    }
}

private struct MainTabs: View {
    @ObservedObject var progress: ProgressStore

    var body: some View {
        TabView {
            NavigationStack {
                DashboardView(progress: progress)
            }
            .tabItem { Label("Inicio", systemImage: "house.fill") }

            NavigationStack {
                ChallengesListView(progress: progress)
            }
            .tabItem { Label("Retos", systemImage: "rectangle.stack.fill") }

            NavigationStack {
                ProgressScreen(progress: progress)
            }
            .tabItem { Label("Progreso", systemImage: "star.circle.fill") }

            NavigationStack {
                SettingsScreen(progress: progress)
            }
            .tabItem { Label("Ajustes", systemImage: "gearshape.fill") }
        }
    }
}

#Preview {
    ContentView()
}
