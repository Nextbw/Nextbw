import SwiftUI

struct QuizPlayView: View {
    @EnvironmentObject var engine: GameEngine
    @Environment(\.dismiss) var dismiss

    let quiz: Quiz

    @State private var currentIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showExplanation = false
    @State private var score = 0
    @State private var isFinished = false
    @State private var timeRemaining: Double = 30
    @State private var timerActive = true
    @State private var shake = false
    @State private var correctAnimation = false

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var currentQuestion: Question {
        quiz.questions[currentIndex]
    }

    var progress: Double {
        Double(currentIndex) / Double(quiz.questions.count)
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [quiz.category.color.opacity(0.1), .clear],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()

            if isFinished {
                quizResultsView
            } else {
                VStack(spacing: 0) {
                    // Header
                    quizHeader

                    ScrollView {
                        VStack(spacing: 24) {
                            // Question
                            questionCard

                            // Answers
                            answersSection

                            // Explanation
                            if showExplanation {
                                explanationCard
                            }
                        }
                        .padding()
                    }

                    // Bottom button
                    if showExplanation {
                        nextButton
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            guard timerActive && !showExplanation else { return }
            if timeRemaining > 0 {
                timeRemaining -= 0.1
            } else {
                // Time's up - auto wrong
                timerActive = false
                showExplanation = true
            }
        }
    }

    // MARK: - Header

    var quizHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(currentIndex + 1) / \(quiz.questions.count)")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.orange)
                    Text("\(score)")
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal)

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray.opacity(0.2))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(quiz.category.color.gradient)
                        .frame(width: geo.size.width * progress)
                        .animation(.spring, value: progress)
                }
            }
            .frame(height: 6)
            .padding(.horizontal)

            // Timer
            HStack {
                Image(systemName: "clock")
                    .foregroundStyle(timeRemaining < 10 ? .red : .secondary)
                Text(String(format: "%.0f s", max(timeRemaining, 0)))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(timeRemaining < 10 ? .red : .secondary)

                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }

    // MARK: - Question

    var questionCard: some View {
        VStack(spacing: 8) {
            Text(currentQuestion.text)
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .modifier(ShakeEffect(shakes: shake ? 2 : 0))
    }

    // MARK: - Answers

    @ViewBuilder
    var answersSection: some View {
        switch currentQuestion.type {
        case .multipleChoice(let choices, let correctIndex):
            multipleChoiceAnswers(choices: choices, correctIndex: correctIndex)
        case .trueFalse(let correctAnswer):
            trueFalseAnswers(correctAnswer: correctAnswer)
        case .imageChoice(let choices, let correctIndex, _):
            multipleChoiceAnswers(choices: choices, correctIndex: correctIndex)
        case .ordering(let items, _):
            // Fallback to simple display for ordering
            VStack(spacing: 8) {
                ForEach(items.indices, id: \.self) { index in
                    Text(items[index])
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    func multipleChoiceAnswers(choices: [String], correctIndex: Int) -> some View {
        VStack(spacing: 10) {
            ForEach(choices.indices, id: \.self) { index in
                Button {
                    selectAnswer(index, correctIndex: correctIndex)
                } label: {
                    HStack {
                        Text(answerLetter(index))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(answerLetterColor(index, correctIndex: correctIndex))
                            .frame(width: 36, height: 36)
                            .background(answerLetterBackground(index, correctIndex: correctIndex))
                            .clipShape(Circle())

                        Text(choices[index])
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        if showExplanation {
                            if index == correctIndex {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            } else if index == selectedAnswer {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(answerBackground(index, correctIndex: correctIndex))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(answerBorder(index, correctIndex: correctIndex), lineWidth: 2)
                    )
                }
                .disabled(showExplanation)
            }
        }
    }

    func trueFalseAnswers(correctAnswer: Bool) -> some View {
        HStack(spacing: 12) {
            Button {
                let index = 0
                selectAnswer(index, correctIndex: correctAnswer ? 0 : 1)
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.largeTitle)
                    Text("Vrai")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(trueFalseBackground(isTrue: true, correct: correctAnswer))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(showExplanation)

            Button {
                let index = 1
                selectAnswer(index, correctIndex: correctAnswer ? 0 : 1)
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                    Text("Faux")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(trueFalseBackground(isTrue: false, correct: correctAnswer))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(showExplanation)
        }
    }

    // MARK: - Explanation

    var explanationCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.yellow)
                Text("Explication")
                    .fontWeight(.bold)
            }

            Text(currentQuestion.explanation)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.yellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // MARK: - Next Button

    var nextButton: some View {
        Button {
            withAnimation {
                if currentIndex < quiz.questions.count - 1 {
                    currentIndex += 1
                    selectedAnswer = nil
                    showExplanation = false
                    timeRemaining = 30
                    timerActive = true
                    correctAnimation = false
                } else {
                    isFinished = true
                    engine.completeQuiz(quiz.id, score: score, totalQuestions: quiz.questions.count)
                }
            }
        } label: {
            Text(currentIndex < quiz.questions.count - 1 ? "Question suivante" : "Voir les resultats")
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(quiz.category.color.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding()
    }

    // MARK: - Results

    var quizResultsView: some View {
        VStack(spacing: 24) {
            Spacer()

            // Score circle
            ZStack {
                Circle()
                    .stroke(.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 160, height: 160)

                Circle()
                    .trim(from: 0, to: Double(score) / Double(quiz.questions.count))
                    .stroke(scoreColor.gradient, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))

                VStack {
                    Text("\(score)/\(quiz.questions.count)")
                        .font(.system(size: 36, weight: .black))
                    Text(scoreMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Text(scoreEmoji)
                .font(.system(size: 50))

            Text(scoreTitle)
                .font(.title)
                .fontWeight(.bold)

            // XP earned
            HStack(spacing: 20) {
                VStack {
                    Text("+\(xpEarned)")
                        .font(.title2)
                        .fontWeight(.black)
                        .foregroundStyle(.orange)
                    Text("XP gagnes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if engine.streakMultiplier > 1.0 {
                    VStack {
                        Text("x\(String(format: "%.2g", engine.streakMultiplier))")
                            .font(.title2)
                            .fontWeight(.black)
                            .foregroundStyle(.red)
                        Text("Bonus serie")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Terminer")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(quiz.category.color.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }

    // MARK: - Logic

    func selectAnswer(_ index: Int, correctIndex: Int) {
        selectedAnswer = index
        timerActive = false
        if index == correctIndex {
            score += 1
            correctAnimation = true
        } else {
            withAnimation(.default) { shake = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { shake = false }
        }
        withAnimation(.spring) {
            showExplanation = true
        }
    }

    // MARK: - Styling Helpers

    func answerLetter(_ index: Int) -> String {
        ["A", "B", "C", "D"][index]
    }

    func answerLetterColor(_ index: Int, correctIndex: Int) -> Color {
        guard showExplanation else { return selectedAnswer == index ? .white : .primary }
        if index == correctIndex { return .white }
        if index == selectedAnswer { return .white }
        return .primary
    }

    func answerLetterBackground(_ index: Int, correctIndex: Int) -> Color {
        guard showExplanation else { return selectedAnswer == index ? quiz.category.color : .gray.opacity(0.15) }
        if index == correctIndex { return .green }
        if index == selectedAnswer { return .red }
        return .gray.opacity(0.15)
    }

    func answerBackground(_ index: Int, correctIndex: Int) -> Color {
        guard showExplanation else { return selectedAnswer == index ? quiz.category.color.opacity(0.1) : .clear }
        if index == correctIndex { return .green.opacity(0.1) }
        if index == selectedAnswer { return .red.opacity(0.1) }
        return .clear
    }

    func answerBorder(_ index: Int, correctIndex: Int) -> Color {
        guard showExplanation else { return selectedAnswer == index ? quiz.category.color : .gray.opacity(0.2) }
        if index == correctIndex { return .green }
        if index == selectedAnswer { return .red }
        return .gray.opacity(0.2)
    }

    func trueFalseBackground(isTrue: Bool, correct: Bool) -> Color {
        guard showExplanation else {
            let idx = isTrue ? 0 : 1
            return selectedAnswer == idx ? quiz.category.color.opacity(0.2) : Color(.systemGray6)
        }
        if isTrue == correct { return .green.opacity(0.2) }
        let idx = isTrue ? 0 : 1
        if selectedAnswer == idx { return .red.opacity(0.2) }
        return Color(.systemGray6)
    }

    var scoreColor: Color {
        let pct = Double(score) / Double(quiz.questions.count)
        if pct >= 0.8 { return .green }
        if pct >= 0.5 { return .orange }
        return .red
    }

    var scoreMessage: String {
        let pct = Double(score) / Double(quiz.questions.count)
        if pct >= 0.9 { return "Excellent !" }
        if pct >= 0.7 { return "Tres bien !" }
        if pct >= 0.5 { return "Pas mal !" }
        return "A revoir"
    }

    var scoreEmoji: String {
        let pct = Double(score) / Double(quiz.questions.count)
        if pct >= 0.9 { return "🏆" }
        if pct >= 0.7 { return "🎉" }
        if pct >= 0.5 { return "👍" }
        return "📚"
    }

    var scoreTitle: String {
        let pct = Double(score) / Double(quiz.questions.count)
        if pct >= 0.9 { return "Parfait !" }
        if pct >= 0.7 { return "Bien joue !" }
        if pct >= 0.5 { return "Correct" }
        return "Continuez a apprendre !"
    }

    var xpEarned: Int {
        let pct = Double(score) / Double(quiz.questions.count)
        let base: Int
        switch pct {
        case 0.9...1.0: base = 100
        case 0.7..<0.9: base = 70
        case 0.5..<0.7: base = 40
        default: base = 20
        }
        return Int(Double(base) * engine.streakMultiplier)
    }
}

// MARK: - Shake Effect

struct ShakeEffect: GeometryEffect {
    var shakes: CGFloat
    var animatableData: CGFloat {
        get { shakes }
        set { shakes = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: 10 * sin(shakes * .pi * 2), y: 0))
    }
}

#Preview {
    QuizPlayView(quiz: SampleData.quizzes[0])
        .environmentObject(GameEngine.shared)
}
