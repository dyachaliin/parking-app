import SwiftUI
import MapKit
class Constants{
    static let foundLogitude = 50.4560705
    static let foundLatitude = 30.4099772
    static let foundRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: foundLogitude, longitude: foundLatitude), span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
}
struct ContentView: View {
    let test = Manager()
    @State var region = Constants.foundRegion
    @StateObject var parkingFinder1 = ParkingFinder1()
    
    @State var placesOfClosure: [Result] = []
    
    @State var result: Result?
    
    var body: some View {
        ZStack(alignment: .top) {
            // background
            Color.white.ignoresSafeArea()
            // map view
            Map(coordinateRegion: $region, annotationItems: placesOfClosure) { spot in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude:  spot.geometry.location.lat, longitude:  spot.geometry.location.lng)
, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    Button(action: {
                        parkingFinder1.selectedPlace = spot
                    }, label: {
                        SpotAnnotatonView(fee: "\(Int(spot.fee ?? 0.0))", selected: spot.id == parkingFinder1.selectedPlace?.id)
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
                ParkingCardView(parkingPlace: parkingFinder1.selectedPlace)
                    .offset(y: -25)
                    .onTapGesture {
                        parkingFinder1.showDetail = true
                    }
                // search view
                SearchView()
            }
            .padding(.horizontal)
            if parkingFinder1.showDetail {
                // parking detail view when click on card
           ParkingDetailView(parkingFinder1: parkingFinder1, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: parkingFinder1.selectedPlace!.geometry.location.lat, longitude: parkingFinder1.selectedPlace!.geometry.location.lng) , span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
            }
        }
        .onAppear {
            test.doTask(longitude: Constants.foundLogitude, latitude: Constants.foundLatitude, radius: 1500, onSuccess: { results in
                self.placesOfClosure = results
                print("")
            }, onFailure: {error in
                print(error)
            })
//            parkingFinder1.selectedPlace = parkingFinder1.spots![0]
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
