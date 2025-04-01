import SwiftUI

struct DividendInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Dividends")
                    .font(.title)
                    .foregroundColor(.cyan)
                    .padding(.top, 100) // Increased padding to lower the text

                // General info about dividends
                Text("Dividends are payments made by a corporation to its shareholders, usually as a distribution of profits. When a company earns a profit or surplus, it can reinvest it in the business (called retained earnings) or distribute it to shareholders as a dividend.")

                Text("Pros")
                    .font(.headline)
                    .foregroundColor(.cyan)
                // Pros of dividends
                Text("• Regular income\n• Can indicate financial health of a company\n• Can be reinvested to purchase more shares")

                Text("Cons")
                    .font(.headline)
                    .foregroundColor(.cyan)
                // Cons of dividends
                Text("• Not guaranteed\n• Can be cut if the company faces financial issues\n• Dividend payments are taxed")

                Spacer()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("Dividends", displayMode: .inline)
    }
}

struct DividendInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DividendInfoView()
    }
}
