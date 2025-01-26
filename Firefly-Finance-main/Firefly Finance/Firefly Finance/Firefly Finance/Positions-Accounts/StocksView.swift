import SwiftUI

struct StocksView: View {
    @Binding var userAccount: UserAccount // Binding to the user's account
    @Binding var stockTransactionShares: [UUID: String] // Binding to the stock transaction shares
    @Binding var stockTransactionSellShares: [UUID: String] // Binding to the stock transaction sell shares
    let purchaseStock: (Stock, String) -> Void // Function to purchase stock
    let sellStock: (Stock, String) -> Void // Function to sell stock
    
    var body: some View {
        VStack(spacing: 20) {
            // Header for Stocks section
            Section(header:
                HStack {
                    Text("Stocks")
                        .font(.headline)
                        .foregroundColor(.white)
                    NavigationLink(destination: StocksInfoView()) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.cyan)
                    }
                }
                .padding(.top, 20)) {
                // Display each stock
                ForEach(userAccount.stocks) { stock in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(stock.name)
                            Spacer()
                            Text("Ticker: \(stock.ticker)")
                        }
                        .foregroundColor(.white)
                        HStack {
                            Text("Current Price: $\(stock.price, specifier: "%.2f")")
                            Spacer()
                        }
                        .foregroundColor(.white)
                        if stock.name == "Prickler Holdings" {
                            HStack {
                                Text("Projected Yearly Return: 0% to 8%")
                                Spacer()
                            }
                            .foregroundColor(.white)
                            HStack {
                                Text("Dividend Yield: 3%")
                                NavigationLink(destination: DividendInfoView()) {
                                    Image(systemName: "questionmark.circle")
                                        .foregroundColor(.cyan)
                                }
                                Spacer()
                            }
                            .foregroundColor(.white)
                        } else {
                            HStack {
                                Text("Projected Yearly Return: 3% to 7%")
                                Spacer()
                            }
                            .foregroundColor(.white)
                        }
                        VStack(spacing: 10) {
                            HStack {
                                TextField("Shares", text: Binding(
                                    get: { stockTransactionShares[stock.id, default: ""] },
                                    set: { stockTransactionShares[stock.id] = $0 }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .padding()
                                
                                if let shares = Double(stockTransactionShares[stock.id] ?? ""), shares > 0 {
                                    Text("Total: $\(shares * stock.price, specifier: "%.2f")")
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    purchaseStock(stock, stockTransactionShares[stock.id] ?? "")
                                }) {
                                    Text("Buy Shares")
                                        .padding()
                                        .background(Color.cyan)
                                        .foregroundColor(.black)
                                        .cornerRadius(8)
                                }
                                .padding(.trailing)
                            }
                            
                            HStack {
                                TextField("Sell Shares", text: Binding(
                                    get: { stockTransactionSellShares[stock.id, default: ""] },
                                    set: { stockTransactionSellShares[stock.id] = $0 }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .padding()
                                
                                if let shares = Double(stockTransactionSellShares[stock.id] ?? ""), shares > 0 {
                                    Text("Total: $\(shares * stock.price, specifier: "%.2f")")
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    sellStock(stock, stockTransactionSellShares[stock.id] ?? "")
                                }) {
                                    Text("Sell Shares")
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.black)
                                        .cornerRadius(8)
                                }
                                .padding(.trailing)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .shadow(radius: 10)
                }
            }
        }
        .padding()
    }
}

struct StocksView_Previews: PreviewProvider {
    static var previews: some View {
        StocksView(
            userAccount: .constant(UserAccount(
                cashBalance: 10000,
                savingsAccounts: [],
                stocks: [
                    Stock(name: "CyberMosaic Systems", ticker: "CMSY", price: 100, riskLevel: .high, projectedRateOfReturn: 0.05),
                    Stock(name: "Prickler Holdings", ticker: "PHGS", price: 210, riskLevel: .medium, projectedRateOfReturn: 0.0, dividendYield: 0.03),
                    Stock(name: "Pinemoore Finance", ticker: "PIMF", price: 75, riskLevel: .medium, projectedRateOfReturn: 0.10, dividendYield: 0.01)
                ],
                investments: []
            )),
            stockTransactionShares: .constant([:]),
            stockTransactionSellShares: .constant([:]),
            purchaseStock: { _, _ in },
            sellStock: { _, _ in }
        )
    }
}
