import SwiftUI

struct StocksInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Stocks")
                    .font(.title)
                    .foregroundColor(.cyan)
                    .padding(.top, 100) // Increased padding to lower the text

                // General info about stocks
                Text("Stocks represent ownership in a company and a claim on part of the company's assets and earnings. There are two main types of stocks: common and preferred.")

                Text("Common Stocks")
                    .font(.headline)
                    .foregroundColor(.cyan)
                Text("Common stocks are securities that represent equity ownership in a corporation. Holders of common stock exercise control by electing a board of directors and voting on corporate policy. Common shareholders are on the bottom of the priority ladder for ownership structure. In the event of liquidation, common shareholders have rights to a company's assets only after bondholders, preferred shareholders, and other debt holders are paid in full.")

                Text("Preferred Stocks")
                    .font(.headline)
                    .foregroundColor(.cyan)
                Text("Preferred stock is a class of ownership in a corporation that has a higher claim on its assets and earnings than common stock. Preferred shares generally have a dividend that must be paid out before dividends to common shareholders and the shares usually do not have voting rights.")

                Text("Risk Levels")
                    .font(.headline)
                    .foregroundColor(.cyan)
                Text("Stocks come with varying levels of risk. High-risk stocks may offer higher potential returns but come with a greater chance of loss. Low-risk stocks generally provide more stable returns but with less potential for high earnings.")

                Text("ETFs")
                    .font(.headline)
                    .foregroundColor(.cyan)
                Text("Exchange-traded funds (ETFs) are investment funds traded on stock exchanges, much like stocks. ETFs hold assets such as stocks, commodities, or bonds and generally operate with an arbitrage mechanism designed to keep it trading close to its net asset value, though deviations can occasionally occur.")

                Spacer()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("Stocks", displayMode: .inline)
    }
}

struct StocksInfoView_Previews: PreviewProvider {
    static var previews: some View {
        StocksInfoView()
    }
}
