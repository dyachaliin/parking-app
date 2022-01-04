import SwiftUI
import MapKit



//class ParkingFinder: ObservableObject {
//    @Published var spots = DataModel.spots
//    @Published var selectedPlace: ParkingItem?
//    @Published var showDetail = false
//    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: DataModel.spots[0].location.latitude, longitude: DataModel.spots[0].location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
//}

class ParkingFinder1: ObservableObject {
    @Published var spots: [Result]?
    @Published var selectedPlace: Result?
    @Published var showDetail = false
    
}
