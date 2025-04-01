import SwiftUI

struct ShareHoldingsView: View {
    @Binding var userAccount: UserAccount
    var scrollToStocks: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Current Holdings")
                .font(.headline)
                .foregroundColor(.white)
            
            if userAccount.investments.isEmpty {
                VStack {
                    Text("No Current Positions")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Button(action: scrollToStocks) {
                        Text("Purchase Stocks")
                            .padding()
                            .background(Color.cyan)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                }
            } else {
                ForEach(userAccount.investments) { investment in
                    if let stock = userAccount.stocks.first(where: { $0.id == investment.stockId }) {
                        HStack {
                            Text(stock.name)
                                .foregroundColor(.white)
                            Spacer()
                            Text("Shares: \(investment.amount / stock.price, specifier: "%.2f")")
                                .foregroundColor(.white)
                            Spacer()
                            Text("Value: $\(investment.amount, specifier: "%.2f")")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding(.bottom, 20)
    }
}
