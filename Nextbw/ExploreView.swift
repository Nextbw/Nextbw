import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""

    let categories = [
        Category(name: "Technologie", icon: "cpu", color: .blue),
        Category(name: "Design", icon: "paintbrush.fill", color: .pink),
        Category(name: "Business", icon: "chart.bar.fill", color: .green),
        Category(name: "Science", icon: "atom", color: .orange),
        Category(name: "Art", icon: "photo.artframe", color: .purple),
        Category(name: "Musique", icon: "music.note", color: .red)
    ]

    var filteredCategories: [Category] {
        if searchText.isEmpty {
            return categories
        }
        return categories.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List(filteredCategories) { category in
                NavigationLink {
                    CategoryDetailView(category: category)
                } label: {
                    HStack(spacing: 16) {
                        Image(systemName: category.icon)
                            .font(.title2)
                            .foregroundStyle(category.color)
                            .frame(width: 40)

                        VStack(alignment: .leading) {
                            Text(category.name)
                                .font(.headline)
                            Text("Decouvrir \(category.name.lowercased())")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Explorer")
            .searchable(text: $searchText, prompt: "Rechercher...")
        }
    }
}

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

struct CategoryDetailView: View {
    let category: Category

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: category.icon)
                .font(.system(size: 80))
                .foregroundStyle(category.color)

            Text(category.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Contenu a venir pour la categorie \(category.name).")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 40)
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ExploreView()
}
