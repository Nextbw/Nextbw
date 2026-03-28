import SwiftUI

struct VideoPlayerView: View {
    @EnvironmentObject var engine: GameEngine
    @Environment(\.dismiss) var dismiss

    let video: TrainingVideo
    @State private var isPlaying = false
    @State private var progress: Double = 0
    @State private var showCompletion = false

    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Video player area
                ZStack {
                    // Video placeholder
                    LinearGradient(
                        colors: [video.thumbnailColor, video.thumbnailColor.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    VStack(spacing: 16) {
                        Image(systemName: video.category.icon)
                            .font(.system(size: 50))
                            .foregroundStyle(.white.opacity(0.8))

                        if !isPlaying {
                            Button {
                                isPlaying = true
                            } label: {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 70))
                                    .foregroundStyle(.white)
                                    .shadow(radius: 10)
                            }
                        } else {
                            // Simulated playing state
                            VStack(spacing: 8) {
                                Image(systemName: "waveform")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                    .symbolEffect(.variableColor, isActive: isPlaying)

                                Text("Lecture en cours...")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        }
                    }

                    // Progress bar at bottom
                    VStack {
                        Spacer()
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(.white.opacity(0.3))
                                Rectangle()
                                    .fill(.white)
                                    .frame(width: geo.size.width * progress)
                                    .animation(.linear(duration: 0.5), value: progress)
                            }
                        }
                        .frame(height: 4)
                    }
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 0))

                // Controls
                HStack {
                    Button {
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                    }

                    Spacer()

                    Text("\(Int(progress * 100))%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Button {
                        // Skip to end for demo
                        progress = 1.0
                        isPlaying = false
                        completeVideo()
                    } label: {
                        HStack {
                            Image(systemName: "forward.fill")
                            Text("Terminer")
                                .font(.caption)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)

                // Video info
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Title and category
                        VStack(alignment: .leading, spacing: 8) {
                            Text(video.title)
                                .font(.title2)
                                .fontWeight(.bold)

                            HStack(spacing: 12) {
                                CategoryChip(category: video.category)
                                DifficultyStars(difficulty: video.difficulty)
                                Label(video.duration, systemImage: "clock")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Divider()

                        // Description
                        Text("Description")
                            .font(.headline)

                        Text(video.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        // XP reward info
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.orange)
                            Text("Regardez cette video pour gagner +30 XP")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.orange.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        // Key points
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Points cles")
                                .font(.headline)

                            ForEach(keyPoints, id: \.self) { point in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .font(.caption)
                                        .padding(.top, 2)
                                    Text(point)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fermer") { dismiss() }
                }
            }
            .onReceive(timer) { _ in
                guard isPlaying else { return }
                if progress < 1.0 {
                    progress += 0.02
                } else {
                    isPlaying = false
                    completeVideo()
                }
            }
            .alert("Video terminee !", isPresented: $showCompletion) {
                Button("Super !") { dismiss() }
            } message: {
                Text("Vous avez gagne +30 XP pour cette video !")
            }
        }
    }

    func completeVideo() {
        engine.completeVideo(video.id)
        showCompletion = true
    }

    var keyPoints: [String] {
        switch video.category {
        case .medicaments:
            return ["Identifier les interactions majeures", "Verifier les contre-indications", "Adapter la posologie au patient"]
        case .conseil:
            return ["Ecouter activement le patient", "Poser les bonnes questions", "Proposer une solution adaptee"]
        case .legislation:
            return ["Connaitre les obligations reglementaires", "Respecter les delais de conservation", "Maitriser la tracabilite"]
        case .phytotherapie:
            return ["Connaitre les indications principales", "Verifier les interactions", "Respecter les posologies"]
        case .dermo:
            return ["Identifier le type de peau", "Proposer une routine adaptee", "Connaitre les actifs cles"]
        case .urgence:
            return ["Evaluer la gravite", "Appeler les secours", "Pratiquer les gestes de premier secours"]
        default:
            return ["Approfondir vos connaissances", "Mettre en pratique au comptoir", "Partager avec l'equipe"]
        }
    }
}

#Preview {
    VideoPlayerView(video: SampleData.videos[0])
        .environmentObject(GameEngine.shared)
}
