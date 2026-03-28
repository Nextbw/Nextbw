import SwiftUI

struct ProfileView: View {
    @State private var username = "Utilisateur"
    @State private var isDarkMode = false
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            List {
                // Profile header
                Section {
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(username)
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text("Membre Nextbw")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // Settings
                Section("Parametres") {
                    Toggle(isOn: $isDarkMode) {
                        Label("Mode sombre", systemImage: "moon.fill")
                    }

                    Toggle(isOn: $notificationsEnabled) {
                        Label("Notifications", systemImage: "bell.fill")
                    }

                    NavigationLink {
                        Text("Parametres de confidentialite")
                            .navigationTitle("Confidentialite")
                    } label: {
                        Label("Confidentialite", systemImage: "hand.raised.fill")
                    }
                }

                // About
                Section("A propos") {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Label("Build", systemImage: "hammer")
                        Spacer()
                        Text("SwiftUI")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Label("Plateforme", systemImage: "iphone")
                        Spacer()
                        Text("iOS 17+")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Profil")
        }
        .preferredColorScheme(isDarkMode ? .dark : nil)
    }
}

#Preview {
    ProfileView()
}
