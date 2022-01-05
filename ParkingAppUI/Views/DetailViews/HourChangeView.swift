import SwiftUI

struct HourChangeView: View {
    
    @Binding var selectedHour: CGFloat
    @Binding var showHourSliderView: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.1).ignoresSafeArea()
            //TODO: why we should use this widget
            GeometryReader { geometry in
                VStack {
                    Text("Choose Hour(max: 6hour)").foregroundColor(.darkColor)
                    // hour change slider
                    HourSliderView(
                        progress: $selectedHour,
                        showHourSlider: $showHourSliderView,
                        width: geometry.size.width)
                }
            }
            .frame(height: 80)
            .padding(20)
            .background(Color.white)
            .cornerRadius(15)
            .offset(y: -140)
        }
    }
}
