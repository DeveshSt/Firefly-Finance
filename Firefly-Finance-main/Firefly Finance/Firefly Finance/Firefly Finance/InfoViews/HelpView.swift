import SwiftUI

struct HelpView: View {
    @Binding var currentView: String

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Firefly Finance Help")
                        .font(.largeTitle)
                        .foregroundColor(.cyan)
                        .padding(.top, 50)
                    
                    Text("Welcome to Firefly Finance, a financial management simulation app where you can learn and practice managing finances by simulating various financial scenarios.")
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Text("Things to Do:")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Group {
                        Text("1. View and Manage Accounts")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("On the Home screen, you can see your cash balance and the net account value, which includes all your savings and investments.")
                            .foregroundColor(.white)
                        
                        Text("2. Deposit and Withdraw Money")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("You can deposit money into your savings account or withdraw money from it by clicking on the respective buttons in the Savings Accounts section.")
                            .foregroundColor(.white)
                        
                        Text("3. Buy and Sell Stocks")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("In the Stocks section, you can buy shares of stocks or sell shares you already own. Make sure to check the stock prices and your cash balance before making transactions.")
                            .foregroundColor(.white)
                        
                        Text("4. Simulate Growth")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("You can simulate the growth of your investments over a specified number of years. Enter the number of years and click Simulate to see how your account grows over time.")
                            .foregroundColor(.white)
                        
                        Text("5. Save Progress")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Don't forget to save your progress regularly. Click on the Save Progress button to save your current state.")
                            .foregroundColor(.white)
                    }
                    
                    Text("Goal:")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Text("The goal of Firefly Finance is to help you understand and practice financial management. Try to grow your net account value by making smart investment decisions and managing your savings effectively. Reach the highest net account value by the end of 100 years and see if you can top your previous records!")
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color.black)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(currentView: .constant("Help"))
    }
}
