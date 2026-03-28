import SwiftUI

@main
struct NextbwApp: App {
    @StateObject private var engine = GameEngine.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(engine)
        }
    }
}
