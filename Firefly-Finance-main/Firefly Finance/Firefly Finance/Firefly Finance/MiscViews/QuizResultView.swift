import SwiftUI

struct QuizResultView: View {
    @Binding var currentView: String
    let score: Int
    let totalQuestions: Int
    let didPass: Bool
    @AppStorage("unlockedQuizzes") private var unlockedQuizzes: Int = 1 // Stores unlocked quizzes

    var body: some View {
        VStack {
            Spacer()
            
            Text(didPass ? "🎉 Congratulations! 🎉" : "❌ Good Try!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(didPass ? .cyan : .red)
                .padding(.bottom, 10)

            Text(didPass ? "You have passed this topic!" : "You need a score of 3/4 to pass this topic.")
                .font(.headline)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Text("Score: \(score)/\(totalQuestions)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .padding(.top, 15)

            Spacer()
            
            Button(action: {
                currentView = "Quiz"
            }) {
                Text("Continue")
                    .font(.headline)
                    .frame(width: 180, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct QuizResultView_Previews: PreviewProvider {
    static var previews: some View {
        QuizResultView(currentView: .constant("Quiz"), score: 3, totalQuestions: 4, didPass: true)
    }
}
