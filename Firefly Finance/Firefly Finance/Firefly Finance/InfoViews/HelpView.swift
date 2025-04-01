import SwiftUI

struct HelpView: View {
    @Binding var currentView: String
    
    struct HelpSection: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let color: Color
        let items: [HelpItem]
    }
    
    struct HelpItem: Identifiable {
        let id = UUID()
        let title: String
        let description: String
    }
    
    let sections = [
        HelpSection(
            title: "Getting Started",
            icon: "star.fill",
            color: .cyan,
            items: [
                HelpItem(
                    title: "Initial Balance",
                    description: "You start with $10,000 to invest and manage. Use this money wisely to grow your wealth."
                ),
                HelpItem(
                    title: "Navigation",
                    description: "Use the bottom bar to switch between Home, History, Graph, Quiz, and Chat views."
                )
            ]
        ),
        HelpSection(
            title: "Investing",
            icon: "chart.line.uptrend.xyaxis.circle.fill",
            color: .green,
            items: [
                HelpItem(
                    title: "Stocks",
                    description: "Buy and sell stocks to grow your portfolio. Each stock has different risk levels and potential returns."
                ),
                HelpItem(
                    title: "Dividends",
                    description: "Some stocks pay regular dividends. These provide passive income on top of potential stock value growth."
                )
            ]
        ),
        HelpSection(
            title: "Savings",
            icon: "banknote.fill",
            color: .orange,
            items: [
                HelpItem(
                    title: "High Yield Account",
                    description: "Earn 5% annual interest on your savings. A safe way to grow your money steadily."
                ),
                HelpItem(
                    title: "Deposits & Withdrawals",
                    description: "Easily move money between your cash balance and savings account."
                )
            ]
        ),
        HelpSection(
            title: "Learning",
            icon: "book.fill",
            color: .purple,
            items: [
                HelpItem(
                    title: "Quizzes",
                    description: "Test your knowledge with quizzes on various financial topics. Progress through different difficulty levels."
                ),
                HelpItem(
                    title: "Chat Assistant",
                    description: "Ask questions about finances, get help with the app, or simulate investment scenarios."
                )
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
                    Text("Help Guide")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { currentView = "Home" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                // Sections
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(sections) { section in
                            HelpSectionView(section: section)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct HelpSectionView: View {
    let section: HelpView.HelpSection
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section Header
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Image(systemName: section.icon)
                        .font(.system(size: 24))
                        .foregroundColor(section.color)
                    
                    Text(section.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.vertical, 16)
            }
            
            if isExpanded {
                VStack(spacing: 16) {
                    ForEach(section.items) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.title)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(section.color)
                            
                            Text(item.description)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                        )
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(section.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(currentView: .constant("Help"))
    }
}
