import SwiftUI

@main
struct ParkingAppUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ContentViewController())
                .environmentObject(ParkingFinder())

        }
    }
}
