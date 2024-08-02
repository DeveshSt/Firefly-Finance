import SwiftUI

struct ChatHelpView: View {
    @Binding var showingHelp: Bool

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("ChatBot Prompts")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text("Here are some things you can ask the AI:")
                        .font(.title2)
                        .foregroundColor(.black)

                    Group {
                        Text("1. Check balance")
                        Text("2. Deposit money")
                        Text("3. Withdraw money")
                        Text("4. Purchase stocks")
                        Text("5. Simulate growth")
                        Text("6. Learn about financial literacy")
                    }
                    .font(.body)
                    .foregroundColor(.black)

                    Spacer()
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding()
            
            Button(action: { showingHelp = false }) {
                Text("Back to Chat")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct ChatHelpView_Previews: PreviewProvider {
    static var previews: some View {
        ChatHelpView(showingHelp: .constant(true))
    }
}
