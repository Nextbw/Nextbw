import SwiftUI

struct SpeedQuizView: View {
    @EnvironmentObject var engine: GameEngine
    @Environment(\.dismiss) var dismiss

    @State private var currentIndex = 0
    @State private var score = 0
    @State private var timeRemaining: Double = 60
    @State private var isActive = false
    @State private var isFinished = false
    @State private var selectedAnswer: Int? = nil
    @State private var showCorrect = false
    @State private var combo = 0
    @State private var maxCombo = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var shakeOffset: CGFloat = 0

    // Collect all questions and shuffle
    let allQuestions: [Question] = {
        var questions: [Question] = []
        for quiz in SampleData.quizzes {
            questions.append(contentsOf: quiz.questions)
        }
        return questions.shuffled()
    }()

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var currentQuestion: Question? {
        guard currentIndex < allQuestions.count else { return nil }
        return allQuestions[currentIndex]
    }

    var body: some View {
        ZStack {
            // Dynamic background
            LinearGradient(
                colors: backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: combo)

            if !isActive && !isFinished {
                countdownView
            } else if isFinished {
                resultsView
            } else {
                gameView
            }
        }
        .onReceive(timer) { _ in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 0.1
            } else {
                isFinished = true
                isActive = false
                let xp = score * 5 + maxCombo * 10
                engine.awardXP(xp, reason: "Speed Quiz")
            }
        }
    }

    // MARK: - Countdown

    var countdownView: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "bolt.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.white)
                .symbolEffect(.pulse)

            Text("SPEED QUIZ")
                .font(.system(size: 40, weight: .black))
                .foregroundStyle(.white)

            Text("Repondez a un maximum de questions en 60 secondes !")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "clock.fill")
                    Text("60 secondes")
                }
                HStack {
                    Image(systemName: "flame.fill")
                    Text("Combos = bonus XP")
                }
                HStack {
                    Image(systemName: "star.fill")
                    Text("5 XP par bonne reponse")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.7))

            Spacer()

            Button {
                withAnimation {
                    isActive = true
                }
            } label: {
                Text("GO !")
                    .font(.system(size: 24, weight: .black))
                    .foregroundStyle(.orange)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, 40)

            Button("Retour") { dismiss() }
                .foregroundStyle(.white.opacity(0.6))
                .padding(.bottom)
        }
    }

    // MARK: - Game View

    var gameView: some View {
        VStack(spacing: 16) {
            // Top bar
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                }

                Spacer()

                // Timer
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                    Text(String(format: "%.0f", max(timeRemaining, 0)))
                        .font(.title2)
                        .fontWeight(.black)
                        .contentTransition(.numericText())
                }
                .foregroundStyle(timeRemaining < 10 ? .red : .white)

                Spacer()

                // Score
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                    Text("\(score)")
                        .fontWeight(.black)
                }
                .foregroundStyle(.yellow)
            }
            .padding(.horizontal)
            .padding(.top)

            // Combo indicator
            if combo > 1 {
                HStack {
                    Image(systemName: "flame.fill")
                    Text("COMBO x\(combo)")
                        .fontWeight(.black)
                    Image(systemName: "flame.fill")
                }
                .foregroundStyle(.yellow)
                .scaleEffect(pulseScale)
                .animation(.spring(response: 0.3), value: pulseScale)
            }

            Spacer()

            // Question
            if let question = currentQuestion {
                Text(question.text)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .offset(x: shakeOffset)

                Spacer()

                // Quick answers
                speedAnswers(for: question)
                    .padding(.horizontal)
            }

            Spacer()
        }
    }

    @ViewBuilder
    func speedAnswers(for question: Question) -> some View {
        switch question.type {
        case .multipleChoice(let choices, let correctIndex):
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(choices.indices, id: \.self) { index in
                    Button {
                        answerTapped(index, correct: correctIndex)
                    } label: {
                        Text(choices[index])
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(buttonColor(index, correct: correctIndex))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(showCorrect)
                }
            }

        case .trueFalse(let correctAnswer):
            HStack(spacing: 12) {
                Button {
                    answerTapped(0, correct: correctAnswer ? 0 : 1)
                } label: {
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                        Text("Vrai")
                            .fontWeight(.bold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(tfButtonColor(isTrue: true, correct: correctAnswer))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(showCorrect)

                Button {
                    answerTapped(1, correct: correctAnswer ? 0 : 1)
                } label: {
                    VStack {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                        Text("Faux")
                            .fontWeight(.bold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(tfButtonColor(isTrue: false, correct: correctAnswer))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(showCorrect)
            }

        default:
            // Skip unsupported question types
            Button("Passer") {
                nextQuestion()
            }
            .foregroundStyle(.white)
        }
    }

    // MARK: - Results

    var resultsView: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("⏱️")
                .font(.system(size: 60))

            Text("TEMPS ECOULE !")
                .font(.system(size: 30, weight: .black))
                .foregroundStyle(.white)

            // Stats
            VStack(spacing: 16) {
                statRow(icon: "star.fill", label: "Score", value: "\(score)", color: .yellow)
                statRow(icon: "questionmark.circle.fill", label: "Questions", value: "\(currentIndex)", color: .blue)
                statRow(icon: "flame.fill", label: "Meilleur combo", value: "x\(maxCombo)", color: .orange)
                statRow(icon: "sparkles", label: "XP gagnes", value: "+\(score * 5 + maxCombo * 10)", color: .purple)
            }
            .padding()
            .background(.white.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 30)

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Terminer")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 40)
            .padding(.bottom)
        }
    }

    func statRow(icon: String, label: String, value: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)
            Text(label)
                .foregroundStyle(.white.opacity(0.8))
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
    }

    // MARK: - Logic

    func answerTapped(_ index: Int, correct: Int) {
        selectedAnswer = index
        showCorrect = true

        if index == correct {
            score += 1
            combo += 1
            maxCombo = max(maxCombo, combo)
            pulseScale = 1.3
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { pulseScale = 1.0 }
        } else {
            combo = 0
            withAnimation(.default.repeatCount(3, autoreverses: true).speed(6)) {
                shakeOffset = 8
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { shakeOffset = 0 }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            nextQuestion()
        }
    }

    func nextQuestion() {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentIndex += 1
            selectedAnswer = nil
            showCorrect = false
            if currentIndex >= allQuestions.count {
                isFinished = true
                isActive = false
            }
        }
    }

    func buttonColor(_ index: Int, correct: Int) -> Color {
        guard showCorrect else { return .white.opacity(0.2) }
        if index == correct { return .green }
        if index == selectedAnswer { return .red }
        return .white.opacity(0.1)
    }

    func tfButtonColor(isTrue: Bool, correct: Bool) -> Color {
        guard showCorrect else { return .white.opacity(0.2) }
        if isTrue == correct { return .green }
        let idx = isTrue ? 0 : 1
        if selectedAnswer == idx { return .red }
        return .white.opacity(0.1)
    }

    var backgroundColors: [Color] {
        if combo >= 5 { return [.red, .orange] }
        if combo >= 3 { return [.orange, .yellow] }
        return [.indigo, .purple]
    }
}

#Preview {
    SpeedQuizView()
        .environmentObject(GameEngine.shared)
}
