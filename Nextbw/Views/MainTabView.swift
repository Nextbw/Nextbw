import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var engine: GameEngine
    @State private var selectedTab = 0
    @State private var showLevelUp = false
    @State private var showBadgeUnlock = false

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tabItem {
                        Label("Accueil", systemImage: "house.fill")
                    }
                    .tag(0)

                QuizListView()
                    .tabItem {
                        Label("Quiz", systemImage: "brain")
                    }
                    .tag(1)

                GamesHubView()
                    .tabItem {
                        Label("Jeux", systemImage: "gamecontroller.fill")
                    }
                    .tag(2)

                VideoListView()
                    .tabItem {
                        Label("Videos", systemImage: "play.rectangle.fill")
                    }
                    .tag(3)

                ProfileView()
                    .tabItem {
                        Label("Profil", systemImage: "person.fill")
                    }
                    .tag(4)
            }
            .tint(.blue)

            // Level up overlay
            if showLevelUp {
                LevelUpOverlay(
                    level: engine.currentUser.level,
                    rank: engine.currentRank,
                    isShowing: $showLevelUp
                )
                .transition(.opacity)
                .zIndex(100)
            }

            // Badge unlock overlay
            if showBadgeUnlock, let badge = engine.newBadge {
                BadgeUnlockOverlay(badge: badge, isShowing: $showBadgeUnlock)
                    .transition(.opacity)
                    .zIndex(101)
            }
        }
        .onChange(of: engine.showLevelUp) { _, newValue in
            if newValue {
                withAnimation { showLevelUp = true }
                engine.showLevelUp = false
            }
        }
        .onChange(of: engine.newBadge?.id) { _, _ in
            if engine.newBadge != nil {
                withAnimation { showBadgeUnlock = true }
            }
        }
        .onChange(of: showBadgeUnlock) { _, newValue in
            if !newValue {
                engine.newBadge = nil
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(GameEngine.shared)
}
