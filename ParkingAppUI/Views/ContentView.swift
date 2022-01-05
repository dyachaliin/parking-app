import SwiftUI
import MapKit
class Constants{
    static let foundLogitude = 50.4560705
    static let foundLatitude = 30.4099772
    static let foundRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: foundLogitude, longitude: foundLatitude), span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
}

//TODO: ALL VERIALBLES SHOULD BE MOVED TO ONE OBSERVSBLE OBJECT
class ContentViewController: ObservableObject {
    let networkManager = NetworkManager()
    
    @Published var isLoading = false
    @Published var region = Constants.foundRegion
    @Published var placesOfClosure: [Result] = []
    @Published var result: Result?
    
}
struct ContentView: View {
    
    @EnvironmentObject var controller: ContentViewController
    @EnvironmentObject var parkingFinder: ParkingFinder
    //    @State var isLoading = false
    //
    //    @State var region = Constants.foundRegion
    //    @StateObject var parkingFinder1 = ParkingFinder1()
    //    //TODO: how to setup initial value
    //    @State var placesOfClosure: [Result] = []
    //
    //    @State var result: Result?
    
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack(alignment: .top) {
                // background
                Color.white.ignoresSafeArea()
                // map view
                Map(coordinateRegion: $controller.region, annotationItems: controller.placesOfClosure) { spot in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude:  spot.geometry.location.lat, longitude:  spot.geometry.location.lng)
                                  //TODO: what is the anchor point?
                                  , anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                        Button(action: {
                            parkingFinder.selectedPlace = spot
                        }, label: {
                            SpotAnnotatonView(fee: "\(Int(spot.fee ?? 0.0))", selected: spot.id == parkingFinder.selectedPlace?.id)
                        })
                    }
                }
                .preferredColorScheme(.dark)
                .cornerRadius(40)
                .edgesIgnoringSafeArea(.top)
                .offset(y: -70)
                
                bottomCardView
                
                //TODO: should be hendled
                if parkingFinder.showDetail {
                    // parking detail view when click on card
                    ParkingDetailView(parkingFinder1: parkingFinder, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: parkingFinder.selectedPlace!.geometry.location.lat, longitude: parkingFinder.selectedPlace!.geometry.location.lng) , span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
                }
                if controller.isLoading {
                    Group{
                        
                        BlurView(style: .dark)
                            .frame(maxWidth: 100, maxHeight: 100, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    } .frame(height: geometry.size.height, alignment: .center)
                    
                    
                }
                
            }
            
        }
        .onAppear {
            controller.isLoading = true
            controller.networkManager.doTask(longitude: Constants.foundLogitude, latitude: Constants.foundLatitude, radius: 1500, onSuccess: { results in
                controller.isLoading = false
                controller.placesOfClosure = results
                //TODO: show succes for user
                print("")
            }, onFailure: {error in
                controller.isLoading = false
                //TODO: show error alert for user
                print(error)
            })
        }
        
    }
    
    var bottomCardView: some View {
        VStack {
            // top navigation
            TopNavigationView()
            Spacer()
            // parking card view
            ParkingCardView()
                .offset(y: -25)
                .onTapGesture {
                    parkingFinder.showDetail = true
                }
            // search view
            SearchView()
            
        }
        .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
