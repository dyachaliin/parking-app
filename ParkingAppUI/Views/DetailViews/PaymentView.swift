import SwiftUI

struct PaymentView: View {
    
    @Binding var selectedHour: CGFloat
    let perHourFee: CGFloat
    
    var onBack: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text("$\(String(format: "%.2f", selectedHour/2 * perHourFee))")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.darkColor)

            Spacer()
            Button(action: {
                // Tap handler
                onBack?()
            }, label: {
                Text("Pay")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 180, height: 60)
                    .background(Color.yellowColor)
                    .cornerRadius(20)
            })
        }
    }

}
