import SwiftUI
import MapKit
class Constants{
    static let foundLogitude = 50.4560705
    static let foundLatitude = 30.4099772
    static let foundRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: foundLogitude, longitude: foundLatitude), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
}

class ContentViewController: ObservableObject {
    let networkManager = NetworkManager()
    
    @Published var isLoading = false
    @Published var region = Constants.foundRegion
    @Published var placesOfClosure: [Result] = []
    @Published var result: Result?
    @Published var failedDownloading = false
    @Published var animateCardView = false

}
struct ContentView: View {
    
    @EnvironmentObject var controller: ContentViewController
    @EnvironmentObject var parkingFinder: ParkingFinder
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack(alignment: .top) {
                // background
                Color.accentColor.ignoresSafeArea()
                // map view
                Map(coordinateRegion: $controller.region, annotationItems: controller.placesOfClosure) { spot in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude:  spot.geometry.location.lat, longitude:  spot.geometry.location.lng)
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
                
                screenDetailsView
                
                if parkingFinder.showDetail {
                    // parking detail view when click on card
                    ParkingDetailView(parkingFinder: parkingFinder, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: parkingFinder.selectedPlace!.geometry.location.lat, longitude: parkingFinder.selectedPlace!.geometry.location.lng) , span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
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
                let temp: [Result] = results.map({ result in
                    var element = result
                    element.carLimit = Int.random(in: 10...45)
                    element.fee = CGFloat.random(in: 1...5)
                    element.placeID = randomString()
                    return element
                })
                controller.isLoading = false
                controller.placesOfClosure = temp
            }, onFailure: {error in
                controller.isLoading = false
                controller.failedDownloading = true
            })
        }
        .alert(isPresented: $controller.failedDownloading) {
            Alert(title: Text("Error"), message: Text("Downloading data is failed"), dismissButton: .default(Text("Ok")))
        }
        
    }
    
    var bottomCardView: some View {
        VStack {
            ParkingCardView()
            
                .offset(y: -25)
                .onTapGesture {
                    withAnimation {
                        controller.animateCardView.toggle()
                    }
                    parkingFinder.showDetail = true
                }
            
        }
        
        
        
    }
    
    var screenDetailsView: some View {
        VStack {
            // top navigation
            TopNavigationView()
            Spacer()
            // parking card view
            if parkingFinder.selectedPlace != nil {
                bottomCardView
                    .animation(.easeOut(duration: 0.1))
            }
            // search view
            SearchView()
            
        }
        .padding(.horizontal)
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
