import SwiftUI

struct PlaythroughsView: View {
    @State private var playthroughs: [Playthrough] = LocalStorage.getPlaythroughs()
    @Binding var userAccount: UserAccount
    @Binding var currentYear: Double
    @Binding var earningsOverTime: [(year: Int, value: Double)]
    @Binding var currentView: String
    @Binding var previousView: String?
    
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
            
            VStack(spacing: 20) {
                // Header with stats
                VStack(spacing: 8) {
                    Text("Trading History")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    if let best = bestPlaythrough {
                        Text("Best Performance: $\(best.netAccountValue, specifier: "%.2f")")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.cyan)
                    }
                }
                .padding(.top, 40)
                .padding(.bottom, 20)
                
                if playthroughs.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No trading history yet")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        Text("Complete a simulation to see your results here")
                            .font(.system(size: 14))
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    Spacer()
                } else {
                    // Playthrough cards in a scrollview
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(playthroughs.sorted(by: { $0.netAccountValue > $1.netAccountValue })) { playthrough in
                                PlaythroughCard(
                                    playthrough: playthrough,
                                    isBest: playthrough == bestPlaythrough,
                                    onContinue: { continuePlaythrough(playthrough) },
                                    onDelete: { deletePlaythrough(playthrough) }
                                )
                                .transition(.opacity)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .onAppear {
            playthroughs = LocalStorage.getPlaythroughs()
        }
    }
    
    private var bestPlaythrough: Playthrough? {
        playthroughs.filter { $0.year == 100 }.max(by: { $0.netAccountValue < $1.netAccountValue })
    }
    
    private func deletePlaythrough(_ playthrough: Playthrough) {
        withAnimation {
            LocalStorage.deletePlaythrough(playthrough)
            playthroughs = LocalStorage.getPlaythroughs()
        }
    }
    
    private func continuePlaythrough(_ playthrough: Playthrough) {
        userAccount = playthrough.userAccount
        currentYear = Double(playthrough.year)
        earningsOverTime = playthrough.earningsOverTime
        currentView = "Home"
    }
}

struct PlaythroughCard: View {
    let playthrough: Playthrough
    let isBest: Bool
    let onContinue: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with performance indicators
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    if isBest {
                        HStack {
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.yellow)
                            Text("Best Performance")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Text("Year \(playthrough.year)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 4) {
                        Text("Net Worth:")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        Text("$\(playthrough.netAccountValue, specifier: "%.2f")")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.cyan)
                    }
                }
                
                Spacer()
                
                // Date badge
                Text(playthrough.date.formatted(.dateTime.month().day()))
                    .font(.system(size: 14, weight: .medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                    )
                    .foregroundColor(.gray)
            }
            
            // Action buttons
            if playthrough.year < 100 {
                HStack(spacing: 12) {
                    Button(action: onContinue) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Continue")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.cyan, Color.cyan.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                        .foregroundColor(.black)
                    }
                    
                    Button(action: onDelete) {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Delete")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                        .foregroundColor(.red)
                    }
                }
            } else {
                Button(action: onDelete) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Delete")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
                    .foregroundColor(.red)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(isBest ? Color.yellow.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 10)
    }
}

struct PlaythroughsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaythroughsView(
            userAccount: .constant(UserAccount(
                cashBalance: 10000,
                savingsAccounts: [SavingsAccount(name: "High Yield Savings", interestRate: 0.05, balance: 0)],
                stocks: [
                    Stock(name: "CyberMosaic Systems", ticker: "CMSY", price: 100, riskLevel: .high, projectedRateOfReturn: 0.05),
                    Stock(name: "Prickler Holdings", ticker: "PHGS", price: 210, riskLevel: .medium, projectedRateOfReturn: 0.0, dividendYield: 0.03),
                    Stock(name: "Pinemoore Finance", ticker: "PIMF", price: 75, riskLevel: .medium, projectedRateOfReturn: 0.10, dividendYield: 0.01)
                ],
                investments: []
            )),
            currentYear: .constant(0),
            earningsOverTime: .constant([]),
            currentView: .constant("Playthroughs"),
            previousView: .constant(nil)
        )
    }
}
