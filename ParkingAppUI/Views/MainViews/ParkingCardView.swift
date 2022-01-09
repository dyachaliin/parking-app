import SwiftUI

struct ParkingCardView: View {
    let networkManager: NetworkManager = NetworkManager()
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
            
            AsyncImage(url: URL(string: networkManager.getURL(photoReference: parkingFinder.selectedPlace?.photos?.first?.photoReference ?? ""))) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                } placeholder: {
                Text("loading")
                }
        }
        .padding()
        .frame(height: 150)
        .background(Color.white)
        .cornerRadius(40)
        .transition(.move(edge: .bottom))
    }
}
