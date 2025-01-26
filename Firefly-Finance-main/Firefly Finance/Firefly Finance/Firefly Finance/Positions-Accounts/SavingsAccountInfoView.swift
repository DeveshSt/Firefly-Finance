import SwiftUI

struct SavingsAccountInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("High Yield Savings Account")
                    .font(.title)
                    .foregroundColor(.cyan)

                // Description of High Yield Savings Account
                Text("A High Yield Savings Account (HYSA) is a type of savings account that typically offers a higher interest rate compared to traditional savings accounts. The interest rate on HYSAs can be significantly higher, allowing your savings to grow more quickly.")

                Text("Pros")
                    .font(.headline)
                    .foregroundColor(.cyan)
                // Pros of HYSAs
                Text("• Higher interest rates than regular savings accounts\n• Low risk with FDIC insurance\n• Easy access to funds\n• Good for emergency savings and short-term goals")

                Text("Cons")
                    .font(.headline)
                    .foregroundColor(.cyan)
                // Cons of HYSAs
                Text("• May have higher minimum balance requirements\n• Interest rates can fluctuate\n• Limited transactions per month (usually 6)\n• May not offer checking account features")

                Spacer()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SavingsAccountInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsAccountInfoView()
    }
}
