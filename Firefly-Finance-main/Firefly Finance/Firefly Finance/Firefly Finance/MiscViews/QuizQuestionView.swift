import SwiftUI

struct QuizQuestionView: View {
    @Binding var currentView: String
    @Binding var quizScore: Int
    @Binding var totalQuizQuestions: Int
    @State private var questionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var isSubmitted = false

    // Placeholder questions
    let questions = [
        ("What is a budget?", ["A plan for spending money", "A savings account", "An investment strategy", "A tax policy"], 0),
        ("Why is budgeting important?", ["To track spending", "To save for future goals", "To avoid debt", "All of the above"], 3),
        ("What is an expense?", ["Money earned", "Money spent", "A type of investment", "A loan"], 1),
        ("What is a savings goal?", ["An amount set aside for future use", "A credit card limit", "A type of loan", "A tax deduction"], 0)
    ]

    var body: some View {
        VStack {
            // Score Counter (Top Right)
            HStack {
                Spacer()
                Text("Score: \(quizScore)/\(totalQuizQuestions)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.trailing, 20)
            }
            .padding(.top, 30)

            Text("Introduction to Budgeting")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.cyan)
                .padding(.top, 10)

            // Question Box
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 4)
                .frame(width: 340, height: 150)
                .overlay(
                    Text(questions[questionIndex].0)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .multilineTextAlignment(.center)
                )
                .padding(.top, 20)

            // Answer Choices
            VStack(spacing: 15) {
                ForEach(0..<4, id: \.self) { i in
                    Button(action: {
                        if !isSubmitted {
                            selectedAnswer = i
                        }
                    }) {
                        Text(questions[questionIndex].1[i])
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .frame(width: 300, height: 50)
                            .background(getButtonColor(for: i))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(getBorderColor(for: i), lineWidth: 2)
                            )
                    }
                    .disabled(isSubmitted)
                }
            }
            .padding(.top, 20)

            Spacer()

            // Submit & Next Button
            HStack {
                Button(action: submitAnswer) {
                    Text("Submit")
                        .font(.headline)
                        .frame(width: 120, height: 45)
                        .background(isSubmitted ? Color.gray.opacity(0.5) : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isSubmitted || selectedAnswer == nil)

                Spacer()

                Button(action: nextQuestion) {
                    Text("Next")
                        .font(.headline)
                        .frame(width: 120, height: 45)
                        .background(isSubmitted ? Color.orange : Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isSubmitted)
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 70)
        }
        .padding()
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }

    private func submitAnswer() {
        if let selected = selectedAnswer {
            isSubmitted = true
            totalQuizQuestions += 1
            let correctAnswer = questions[questionIndex].2
            if selected == correctAnswer {
                quizScore += 1
            }
        }
    }

    private func nextQuestion() {
        if questionIndex < questions.count - 1 {
            questionIndex += 1
            selectedAnswer = nil
            isSubmitted = false
        } else {
            currentView = "QuizResultView"
        }
    }

    private func getButtonColor(for index: Int) -> Color {
        if isSubmitted {
            let correctAnswer = questions[questionIndex].2
            if index == correctAnswer {
                return Color.green
            } else if index == selectedAnswer {
                return Color.red
            }
        } else if selectedAnswer == index {
            return Color.blue
        }
        return Color.cyan
    }

    private func getBorderColor(for index: Int) -> Color {
        if isSubmitted {
            let correctAnswer = questions[questionIndex].2
            if index == correctAnswer {
                return Color.green
            } else if index == selectedAnswer {
                return Color.red
            }
        }
        return Color.gray
    }
}

struct QuizQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuizQuestionView(
            currentView: .constant("QuizQuestionView"),
            quizScore: .constant(0),
            totalQuizQuestions: .constant(0)
        )
    }
}
