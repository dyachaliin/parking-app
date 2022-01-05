import SwiftUI
import MapKit

class ParkingFinder: ObservableObject {
    @Published var spots: [Result]?
    @Published var selectedPlace: Result?
    @Published var showDetail = false
}
