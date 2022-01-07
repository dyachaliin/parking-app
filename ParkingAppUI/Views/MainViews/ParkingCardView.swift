import SwiftUI

struct ParkingCardView: View {
    
    @EnvironmentObject var parkingFinder: ParkingFinder

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(parkingFinder.selectedPlace?.name ?? "")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.darkColor)
                
                Text(parkingFinder.selectedPlace?.vicinity ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                HStack {
                    Image(systemName: "car.fill").foregroundColor(.gray)
                    Text("\(parkingFinder.selectedPlace?.carLimit ?? 0)")
                    Image(systemName: "dollarsign.circle.fill").foregroundColor(.gray)
                    Text("$\(String.init(format: "%0.2f", parkingFinder.selectedPlace?.fee ?? 0))/h")
                }
            }
            Spacer()
            Image(parkingFinder.selectedPlace?.icon ?? "")
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
