import SwiftUI

struct HomeView: View {
    let features = [
        Feature(title: "Rapide", icon: "bolt.fill", color: .orange, description: "Performance optimisee pour iOS"),
        Feature(title: "Securise", icon: "lock.shield.fill", color: .green, description: "Vos donnees sont protegees"),
        Feature(title: "Moderne", icon: "sparkles", color: .purple, description: "Interface SwiftUI native"),
        Feature(title: "Connecte", icon: "wifi", color: .blue, description: "Toujours synchronise")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero section
                    VStack(spacing: 12) {
                        Image(systemName: "app.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue.gradient)

                        Text("Bienvenue sur Nextbw")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Votre nouvelle app iPhone")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)

                    // Features grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(features) { feature in
                            FeatureCard(feature: feature)
                        }
                    }
                    .padding(.horizontal)

                    // Call to action
                    VStack(spacing: 8) {
                        Text("Pret a commencer ?")
                            .font(.headline)

                        Text("Explorez les fonctionnalites de l'app.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Accueil")
        }
    }
}

struct Feature: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let description: String
}

struct FeatureCard: View {
    let feature: Feature

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: feature.icon)
                .font(.title)
                .foregroundStyle(feature.color)

            Text(feature.title)
                .font(.headline)

            Text(feature.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(feature.color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HomeView()
}
