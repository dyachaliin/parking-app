import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var parkingFinder = ParkingFinder()
    @State var placesOfClosure: [Result] = []
    var body: some View {
        ZStack(alignment: .top) {
            // background
            Color.white.ignoresSafeArea()
            // map view
            Map(coordinateRegion: $parkingFinder.region, annotationItems: parkingFinder.spots) { spot in
                MapAnnotation(coordinate: spot.location, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    Button(action: {
                        parkingFinder.selectedPlace = spot
                    }, label: {
                        SpotAnnotatonView(fee: "\(Int(spot.fee))", selected: spot.id == parkingFinder.selectedPlace?.id)
                    })
                }
            }
            .cornerRadius(40)
            .edgesIgnoringSafeArea(.top)
            .offset(y: -70)
                    
            VStack {
                // top navigation
                
                Text("Receive element lenght:\(placesOfClosure.count)")
                TopNavigationView()
                Spacer()
                // parking card view
                ParkingCardView(parkingPlace: parkingFinder.selectedPlace ?? parkingFinder.spots[0])
                    .offset(y: -25)
                    .onTapGesture {
                        parkingFinder.showDetail = true
                    }
                // search view
                SearchView()
            }
            .padding(.horizontal)
                    
            if parkingFinder.showDetail {
                // parking detail view when click on card
                ParkingDetailView(parkingFinder: parkingFinder, region: MKCoordinateRegion(center: parkingFinder.selectedPlace?.location ?? parkingFinder.spots[0].location, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
            }
        }
        .onAppear {
            var test = Manager()
            test.doTask(longitude: 50.4560705, latitude: 30.4099772, radius: 1500, onSuccess: { placesResult in
                self.placesOfClosure = placesResult!.results
            }, onFailure: {error in
                
            })
            parkingFinder.selectedPlace = parkingFinder.spots[0]
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
