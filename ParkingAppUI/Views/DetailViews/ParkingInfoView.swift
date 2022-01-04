import SwiftUI

struct ParkingInfoView: View {
    
    let parkingItem: Result?
    @Binding var showSelectHourView: Bool
    @Binding var selectedHour: CGFloat
    
    var body: some View {
        VStack(spacing: 16) {
            Text(parkingItem!.name).font(.system(size: 30, weight: .bold)).foregroundColor(.darkColor)
                
            Text(parkingItem!.vicinity)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                
            HStack {
                Image(systemName: "car.fill").foregroundColor(.gray)
                
                Text("\(parkingItem?.carLimit ?? 0)")
                    .foregroundColor(.gray)
                    .padding(.trailing, 16)
                    
                Image(systemName: "dollarsign.circle.fill").foregroundColor(.gray)
                
                Text("$\(String.init(format: "%0.2f", parkingItem?.fee ?? 0.0))/h").foregroundColor(.gray)
            }.font(.system(size: 16))
            
            HStack(spacing: 10) {
                InfoItemView(imageName: "place", value: randomString(), title: "Parking Place")
                
                InfoItemView(imageName: "cost", value: getHour(), title: "Time")
                    .onTapGesture {
                        withAnimation { showSelectHourView = true }
                    }
            }
        }
    }
    
    func getHour() -> String {
        let hourSeparated = modf(selectedHour/2)
        let hourData = String(format: "%0.0f", hourSeparated.0)
        let minuteData = hourSeparated.1 == 0.0 ? "0" : "30"
        return "\(hourData) h \(minuteData) m"
    }
    func randomString() -> String {
      let letters = "ABCDE"
      let numbers = "123456789"
      let newStringL = String((0..<1).map{ _ in letters.randomElement()!
      })
      let newStringN = String((0..<1).map{ _ in numbers.randomElement()!
        })
        let newString = newStringL + newStringN
        return newString
    }
}
