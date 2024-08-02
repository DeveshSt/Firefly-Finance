import SwiftUI

struct HYSAInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("High Yield Savings Account")
                    .font(.largeTitle)
                    .foregroundColor(.cyan)
                    .padding(.top, 100) // Increased padding to lower the text

                // General info about High Yield Savings Accounts
                Text("A High Yield Savings Account (HYSA) is a type of savings account that typically offers a much higher interest rate compared to a traditional savings account. This allows your savings to grow faster.")
                    .foregroundColor(.white)

                Text("Pros:")
                    .font(.headline)
                    .foregroundColor(.cyan)

                // Pros of High Yield Savings Accounts
                Text("1. Higher interest rates: Earn more on your savings compared to regular savings accounts.\n2. FDIC insurance: Your money is insured up to the legal limit.\n3. Easy access: You can access your money easily, typically through online banking.")
                    .foregroundColor(.white)

                Text("Cons:")
                    .font(.headline)
                    .foregroundColor(.cyan)

                // Cons of High Yield Savings Accounts
                Text("1. Withdrawal limits: There may be limits on the number of withdrawals you can make each month.\n2. Variable rates: The interest rate can change based on market conditions.\n3. Minimum balance requirements: Some accounts may require a minimum balance to earn the high yield rate.")
                    .foregroundColor(.white)

                Spacer()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("HYSA Info", displayMode: .inline)
    }
}

struct HYSAInfoView_Previews: PreviewProvider {
    static var previews: some View {
        HYSAInfoView()
    }
}
