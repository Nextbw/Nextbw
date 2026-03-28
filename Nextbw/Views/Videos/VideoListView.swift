import SwiftUI

struct VideoListView: View {
    @EnvironmentObject var engine: GameEngine
    @State private var selectedCategory: QuizCategory? = nil
    @State private var selectedVideo: TrainingVideo? = nil

    var filteredVideos: [TrainingVideo] {
        if let category = selectedCategory {
            return SampleData.videos.filter { $0.category == category }
        }
        return SampleData.videos
    }

    var newVideos: [TrainingVideo] {
        filteredVideos.filter { $0.isNew }
    }

    var allVideos: [TrainingVideo] {
        filteredVideos.filter { !$0.isNew }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Category filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Button {
                                withAnimation { selectedCategory = nil }
                            } label: {
                                Text("Toutes")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedCategory == nil ? .blue : .blue.opacity(0.15))
                                    .foregroundStyle(selectedCategory == nil ? .white : .blue)
                                    .clipShape(Capsule())
                            }

                            ForEach(QuizCategory.allCases, id: \.self) { category in
                                Button {
                                    withAnimation {
                                        selectedCategory = selectedCategory == category ? nil : category
                                    }
                                } label: {
                                    CategoryChip(category: category, isSelected: selectedCategory == category)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // New videos
                    if !newVideos.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Nouveautes")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Image(systemName: "sparkles")
                                    .foregroundStyle(.yellow)
                            }
                            .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 14) {
                                    ForEach(newVideos) { video in
                                        VideoFeaturedCard(video: video, isWatched: engine.currentUser.completedVideos.contains(video.id))
                                            .onTapGesture { selectedVideo = video }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    // All videos
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Toutes les formations")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        LazyVStack(spacing: 10) {
                            ForEach(allVideos.isEmpty ? filteredVideos : allVideos) { video in
                                VideoRowCard(video: video, isWatched: engine.currentUser.completedVideos.contains(video.id))
                                    .onTapGesture { selectedVideo = video }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Formations")
            .sheet(item: $selectedVideo) { video in
                VideoPlayerView(video: video)
                    .environmentObject(engine)
            }
        }
    }
}

// MARK: - Featured Card

struct VideoFeaturedCard: View {
    let video: TrainingVideo
    let isWatched: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [video.thumbnailColor, video.thumbnailColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 220, height: 130)

                Image(systemName: "play.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.white.opacity(0.9))

                if video.isNew {
                    VStack {
                        HStack {
                            Spacer()
                            Text("NEW")
                                .font(.caption2)
                                .fontWeight(.black)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(.red)
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(8)
                }

                if isWatched {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .background(Circle().fill(.white).padding(2))
                        }
                    }
                    .padding(8)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(video.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)

                HStack {
                    Label(video.duration, systemImage: "clock")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    DifficultyStars(difficulty: video.difficulty)
                }
            }
        }
        .frame(width: 220)
    }
}

// MARK: - Row Card

struct VideoRowCard: View {
    let video: TrainingVideo
    let isWatched: Bool

    var body: some View {
        HStack(spacing: 14) {
            // Mini thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(video.thumbnailColor.gradient)
                    .frame(width: 80, height: 56)

                Image(systemName: "play.fill")
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(video.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    if isWatched {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.caption2)
                    }
                }

                Text(video.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    CategoryChip(category: video.category)
                    Label(video.duration, systemImage: "clock")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
    }
}

#Preview {
    VideoListView()
        .environmentObject(GameEngine.shared)
}
