import SwiftUI
import MapKit
class Constants{
    static let foundLogitude = 50.4560705
    static let foundLatitude = 30.4099772
    static let foundRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: foundLogitude, longitude: foundLatitude), span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
}
//TODO: ALL VERIALBLES SHOULD BE MOVED TO ONE OBSERVSBLE OBJECT
struct ContentView: View {
    
    let test = Manager()
    
    @State var isLoading = false
    
    @State var region = Constants.foundRegion
    //TODO: difference between state and stateobject
    @StateObject var parkingFinder1 = ParkingFinder1()
    //TODO: how to setup initial value
    @State var placesOfClosure: [Result] = []
    
    @State var result: Result?
    
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack(alignment: .top) {
                // background
                //TODO: why we use ignore safe area here
                Color.white.ignoresSafeArea()
                // map view
                Map(coordinateRegion: $region, annotationItems: placesOfClosure) { spot in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude:  spot.geometry.location.lat, longitude:  spot.geometry.location.lng)
                                  //TODO: what is the anchor point?
                                  , anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                        Button(action: {
                            parkingFinder1.selectedPlace = spot
                        }, label: {
                            SpotAnnotatonView(fee: "\(Int(spot.fee ?? 0.0))", selected: spot.id == parkingFinder1.selectedPlace?.id)
                        })
                    }
                }
                .preferredColorScheme(.dark)
                .cornerRadius(40)
                .edgesIgnoringSafeArea(.top)
                //TODO: offset for? what will be if we delete it
                .offset(y: -70)
                
                VStack {
                    // top navigation
                    TopNavigationView()
                    Spacer()
                    // parking card view
                    ParkingCardView(parkingPlace: parkingFinder1.selectedPlace)
                    //TODO: again offset, why?
                        .offset(y: -25)
                        .onTapGesture {
                            parkingFinder1.showDetail = true
                        }
                    // search view
                    SearchView()
                    
                }
                .padding(.horizontal)
                //TODO: should be hendled
                if parkingFinder1.showDetail {
                    // parking detail view when click on card
                    ParkingDetailView(parkingFinder1: parkingFinder1, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: parkingFinder1.selectedPlace!.geometry.location.lat, longitude: parkingFinder1.selectedPlace!.geometry.location.lng) , span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
                }
                if isLoading {
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
            isLoading = true
            test.doTask(longitude: Constants.foundLogitude, latitude: Constants.foundLatitude, radius: 1500, onSuccess: { results in
                isLoading = false
                self.placesOfClosure = results
                //TODO: show succes for user
                print("")
            }, onFailure: {error in
                isLoading = false
                //TODO: show error alert for user
                print(error)
            })
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
