import SwiftUI

struct QuizView: View {
    @Binding var currentView: String
    @AppStorage("unlockedQuizzes") private var unlockedQuizzes: Int = 1 // Keeps track of unlocked quizzes

    var body: some View {
        ScrollView {
            VStack(spacing: 100) {
                sectionView(title: "Introduction to Budgeting")
                sectionView(title: "Introduction to Financial Math")
                sectionView(title: "Introduction to Investing")
                sectionView(title: "Introduction to Business Communication")
                sectionView(title: "Introduction to Credit Principles")

                sectionView(title: "Intermediate Budgeting")
                sectionView(title: "Intermediate Financial Math")
                sectionView(title: "Intermediate Investing")
                sectionView(title: "Intermediate Business Communication")
                sectionView(title: "Intermediate Credit Principles")

                sectionView(title: "Advanced Budgeting")
                sectionView(title: "Advanced Financial Math")
                sectionView(title: "Advanced Investing")
                sectionView(title: "Advanced Business Communication")
                sectionView(title: "Advanced Credit Principles")
            }
            .padding(.top, 40)
            .padding(.bottom, 80)
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }

    @ViewBuilder
    private func sectionView(title: String) -> some View {
        VStack(alignment: .center, spacing: 40) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.cyan)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

            GeometryReader { geometry in
                VStack(spacing: 50) {
                    quizCircle(number: 1, color: .blue, action: {
                        currentView = "QuizQuestionView"
                        unlockedQuizzes = max(unlockedQuizzes, 2) // Unlock Quiz 2
                    })
                    .offset(x: -geometry.size.width * 0.2)

                    quizCircle(number: 2, color: unlockedQuizzes >= 2 ? .blue : .gray, action: {
                        if unlockedQuizzes >= 2 {
                            currentView = "QuizQuestionView_2"
                            unlockedQuizzes = max(unlockedQuizzes, 3)
                        }
                    })
                    .offset(x: geometry.size.width * 0.2)

                    quizCircle(number: 3, color: unlockedQuizzes >= 3 ? .blue : .gray, action: {
                        if unlockedQuizzes >= 3 {
                            currentView = "QuizQuestionView_3"
                        }
                    })
                    .offset(x: -geometry.size.width * 0.2)

                    quizCircle(number: 4, color: unlockedQuizzes >= 4 ? .blue : .gray, action: {
                        if unlockedQuizzes >= 4 {
                            currentView = "QuizQuestionView_4"
                        }
                    })
                    .offset(x: geometry.size.width * 0.2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 400)
        }
        .padding(.bottom, 40)
    }

    @ViewBuilder
    private func quizCircle(number: Int, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text("\(number)")
                .font(.title)
                .fontWeight(.bold)
                .frame(width: 90, height: 90)
                .foregroundColor(.white)
                .background(
                    Circle()
                        .fill(color)
                        .shadow(color: .gray.opacity(0.4), radius: 8, x: 4, y: 4)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                        )
                )
        }
        .disabled(color == .gray) // Disable locked quizzes
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(currentView: .constant("Quiz"))
    }
}
