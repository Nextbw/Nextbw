import SwiftUI

struct MemoryGameView: View {
    @EnvironmentObject var engine: GameEngine
    @Environment(\.dismiss) var dismiss

    @State private var cards: [MemoryCard] = []
    @State private var flippedIndices: [Int] = []
    @State private var matchedPairs: Int = 0
    @State private var moves: Int = 0
    @State private var isFinished = false
    @State private var gameStarted = false
    @State private var timeElapsed: Double = 0

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    let pairs: [(String, String)] = [
        ("Amoxicilline", "Beta-lactamine"),
        ("Doliprane", "Paracetamol"),
        ("Ventoline", "Salbutamol"),
        ("Levothyrox", "Levothyroxine"),
        ("Kardegic", "Aspirine"),
        ("Spasfon", "Phloroglucinol"),
        ("Gaviscon", "Antiacide"),
        ("Smecta", "Diosmectite"),
    ]

    let totalPairs = 8
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.teal.opacity(0.3), .blue.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if !gameStarted {
                startView
            } else if isFinished {
                resultsView
            } else {
                gameView
            }
        }
        .onReceive(timer) { _ in
            guard gameStarted && !isFinished else { return }
            timeElapsed += 0.1
        }
    }

    // MARK: - Start View

    var startView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "brain.head.profile")
                .font(.system(size: 70))
                .foregroundStyle(.teal)

            Text("MEMORY PHARMA")
                .font(.system(size: 32, weight: .black))

            Text("Associez chaque medicament a sa molecule ou sa classe therapeutique")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            VStack(spacing: 8) {
                Label("8 paires a retrouver", systemImage: "square.grid.3x3.fill")
                Label("Le moins de coups possible", systemImage: "hand.tap.fill")
                Label("Bonus XP si rapide", systemImage: "bolt.fill")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Spacer()

            Button {
                setupGame()
                withAnimation { gameStarted = true }
            } label: {
                Text("Jouer")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.teal.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 40)

            Button("Retour") { dismiss() }
                .foregroundStyle(.secondary)
                .padding(.bottom)
        }
    }

    // MARK: - Game View

    var gameView: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                HStack(spacing: 16) {
                    Label("\(moves)", systemImage: "hand.tap.fill")
                        .fontWeight(.semibold)

                    Label(String(format: "%.0fs", timeElapsed), systemImage: "clock")
                        .fontWeight(.semibold)

                    Label("\(matchedPairs)/\(totalPairs)", systemImage: "checkmark.circle")
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            .padding(.top)

            // Grid
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(cards.indices, id: \.self) { index in
                    MemoryCardView(card: cards[index])
                        .onTapGesture {
                            cardTapped(index)
                        }
                }
            }
            .padding(.horizontal, 8)

            Spacer()
        }
    }

    // MARK: - Results

    var resultsView: some View {
        VStack(spacing: 24) {
            Spacer()

            Text(resultEmoji)
                .font(.system(size: 60))

            Text("BRAVO !")
                .font(.system(size: 36, weight: .black))

            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "hand.tap.fill").foregroundStyle(.blue)
                    Text("Coups").foregroundStyle(.secondary)
                    Spacer()
                    Text("\(moves)").fontWeight(.bold)
                }
                HStack {
                    Image(systemName: "clock.fill").foregroundStyle(.orange)
                    Text("Temps").foregroundStyle(.secondary)
                    Spacer()
                    Text(String(format: "%.1fs", timeElapsed)).fontWeight(.bold)
                }
                HStack {
                    Image(systemName: "star.fill").foregroundStyle(.yellow)
                    Text("XP gagnes").foregroundStyle(.secondary)
                    Spacer()
                    Text("+\(xpEarned)").fontWeight(.bold).foregroundStyle(.orange)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 40)

            // Stars rating
            HStack(spacing: 4) {
                ForEach(0..<3) { i in
                    Image(systemName: i < starRating ? "star.fill" : "star")
                        .font(.title)
                        .foregroundStyle(.yellow)
                }
            }

            Spacer()

            VStack(spacing: 12) {
                Button {
                    // Replay
                    setupGame()
                    isFinished = false
                    timeElapsed = 0
                    moves = 0
                    matchedPairs = 0
                } label: {
                    Text("Rejouer")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.teal.gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                Button("Terminer") { dismiss() }
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 40)
            .padding(.bottom)
        }
    }

    // MARK: - Logic

    func setupGame() {
        var newCards: [MemoryCard] = []
        for (index, pair) in pairs.prefix(totalPairs).enumerated() {
            newCards.append(MemoryCard(id: index * 2, text: pair.0, pairId: index, color: .blue))
            newCards.append(MemoryCard(id: index * 2 + 1, text: pair.1, pairId: index, color: .teal))
        }
        cards = newCards.shuffled()
    }

    func cardTapped(_ index: Int) {
        guard !cards[index].isFlipped && !cards[index].isMatched else { return }
        guard flippedIndices.count < 2 else { return }

        withAnimation(.spring(response: 0.3)) {
            cards[index].isFlipped = true
        }
        flippedIndices.append(index)

        if flippedIndices.count == 2 {
            moves += 1
            let first = flippedIndices[0]
            let second = flippedIndices[1]

            if cards[first].pairId == cards[second].pairId {
                // Match
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        cards[first].isMatched = true
                        cards[second].isMatched = true
                    }
                    matchedPairs += 1
                    flippedIndices = []

                    if matchedPairs == totalPairs {
                        isFinished = true
                        engine.awardXP(xpEarned, reason: "Memory Pharma")
                    }
                }
            } else {
                // No match
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.spring(response: 0.3)) {
                        cards[first].isFlipped = false
                        cards[second].isFlipped = false
                    }
                    flippedIndices = []
                }
            }
        }
    }

    var xpEarned: Int {
        let timeBonus = max(0, 60 - Int(timeElapsed)) * 2
        let moveBonus = max(0, 30 - moves) * 3
        return 50 + timeBonus + moveBonus
    }

    var starRating: Int {
        if moves <= 12 { return 3 }
        if moves <= 18 { return 2 }
        return 1
    }

    var resultEmoji: String {
        if starRating == 3 { return "🧠" }
        if starRating == 2 { return "👏" }
        return "💪"
    }
}

// MARK: - Memory Card Model

struct MemoryCard: Identifiable {
    let id: Int
    let text: String
    let pairId: Int
    let color: Color
    var isFlipped = false
    var isMatched = false
}

// MARK: - Memory Card View

struct MemoryCardView: View {
    let card: MemoryCard

    var body: some View {
        ZStack {
            if card.isFlipped || card.isMatched {
                RoundedRectangle(cornerRadius: 10)
                    .fill(card.isMatched ? .green.opacity(0.3) : card.color.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(card.isMatched ? .green : card.color, lineWidth: 2)
                    )

                Text(card.text)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(4)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [.teal, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Image(systemName: "pills.fill")
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .frame(height: 70)
        .opacity(card.isMatched ? 0.6 : 1)
    }
}

#Preview {
    MemoryGameView()
        .environmentObject(GameEngine.shared)
}
