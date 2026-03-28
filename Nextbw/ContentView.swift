import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Accueil", systemImage: "house.fill")
                }
                .tag(0)

            ExploreView()
                .tabItem {
                    Label("Explorer", systemImage: "magnifyingglass")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
                .tag(2)
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
}
