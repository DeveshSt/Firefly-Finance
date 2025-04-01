import SwiftUI

struct ChatHelpView: View {
    @Binding var showingHelp: Bool
    
    struct PromptExample {
        let category: String
        let icon: String
        let color: Color
        let examples: [String]
    }
    
    let prompts: [PromptExample] = [
        PromptExample(
            category: "Account & Balance",
            icon: "dollarsign.circle.fill",
            color: .cyan,
            examples: [
                "What's my current balance?",
                "Show me my net worth",
                "How much money do I have?"
            ]
        ),
        PromptExample(
            category: "Savings",
            icon: "banknote.fill",
            color: .green,
            examples: [
                "I want to deposit $500",
                "Can I withdraw $200?",
                "Tell me about the savings account"
            ]
        ),
        PromptExample(
            category: "Investments",
            icon: "chart.line.uptrend.xyaxis.circle.fill",
            color: .orange,
            examples: [
                "Show me available stocks",
                "Buy $1000 of CMSY",
                "What stocks pay dividends?"
            ]
        ),
        PromptExample(
            category: "Simulation",
            icon: "clock.fill",
            color: .purple,
            examples: [
                "Simulate 5 years",
                "Show me my growth graph",
                "Project my investments"
            ]
        ),
        PromptExample(
            category: "Learning",
            icon: "book.fill",
            color: .blue,
            examples: [
                "Explain dividends",
                "What is compound interest?",
                "How do stocks work?"
            ]
        )
    ]
    
    var body: some View {
        ZStack {
            // Background gradient with stars
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.15),
                    Color(red: 0.15, green: 0.15, blue: 0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Star effect
            GeometryReader { geometry in
                ForEach(0..<100, id: \.self) { _ in
                    Circle()
                        .fill(Color.white)
                        .frame(width: .random(in: 1.5...3), height: .random(in: 1.5...3))
                        .position(
                            x: .random(in: 0...geometry.size.width),
                            y: .random(in: 0...geometry.size.height)
                        )
                        .opacity(.random(in: 0.3...0.7))
                }
            }
            .opacity(0.7)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Chat Assistant")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { showingHelp = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                Text("Try these example prompts")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                // Prompts ScrollView
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(prompts, id: \.category) { prompt in
                            PromptCard(prompt: prompt)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct PromptCard: View {
    let prompt: ChatHelpView.PromptExample
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Category header
            HStack {
                Image(systemName: prompt.icon)
                    .font(.system(size: 20))
                    .foregroundColor(prompt.color)
                
                Text(prompt.category)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Examples
            VStack(alignment: .leading, spacing: 12) {
                ForEach(prompt.examples, id: \.self) { example in
                    HStack(spacing: 12) {
                        Text("•")
                            .foregroundColor(prompt.color)
                        Text(example)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(prompt.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct ChatHelpView_Previews: PreviewProvider {
    static var previews: some View {
        ChatHelpView(showingHelp: .constant(true))
    }
}
