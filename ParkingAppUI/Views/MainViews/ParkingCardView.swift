import SwiftUI

struct ParkingCardView: View {
    
    let parkingPlace: Result?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(parkingPlace?.name ?? "")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.darkColor)
                
                Text(parkingPlace?.vicinity ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                HStack {
                    //TODO: from where we got this images?
                    Image(systemName: "car.fill").foregroundColor(.gray)
                    Text("\(parkingPlace?.carLimit ?? 0)")
                    Image(systemName: "dollarsign.circle.fill").foregroundColor(.gray)
                    Text("$\(String.init(format: "%0.2f", parkingPlace?.fee ?? 0))/h")
                }
            }
            Spacer()
            Image(parkingPlace?.icon ?? "")
                .resizable()
                .frame(width: 80, height: 80)
                .scaledToFit()
                .cornerRadius(15)
        }
        .padding()
        .frame(height: 150)
        .background(Color.white)
        .cornerRadius(40)
    }
}
