import SwiftUI

struct RangeSlider: View {
    @Binding var from: Double
    @Binding var to: Double
    
    let bounds: ClosedRange<Double>
    
    @State private var width: Double = 0
    @State private var fromLabelWidth: CGFloat = 0
    @State private var toLabelWidth: CGFloat = 0
    
    private let thumbSize: CGFloat = 18
    private let step: Double = 1
    private let trackCoordinateSpace = "RangeSliderTrack"
    
    private var math: RangeSliderMath {
        RangeSliderMath(bounds: bounds, step: step, thumbSize: thumbSize)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.AppColor.backgroundSecondary)
                .frame(height: 3)
                .onGeometryChange(for: CGSize.self) { proxy in
                    proxy.size
                } action: { newValue in
                    width = newValue.width
                }
            
            Rectangle()
                .fill(Color.AppColor.primary)
                .frame(width: math.sliderWidth(width: width, from: from, to: to), height: 3)
                .offset(x: math.xOffset(width: width, for: from))
            
            fromThumb
                .offset(x: math.xThumbOffset(width: width, for: from))
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .named(trackCoordinateSpace))
                        .onChanged { value in
                            from = math.lowerValue(atX: value.location.x, width: width, upperBound: to)
                        }
                )
            
            toThumb
                .offset(x: math.xThumbOffset(width: width, for: to))
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .named(trackCoordinateSpace))
                        .onChanged { value in
                            to = math.upperValue(atX: value.location.x, width: width, lowerBound: from)
                        }
                )
        }
        .coordinateSpace(.named(trackCoordinateSpace))
    }
    
    private func thumb(value: Double, labelWidth: Binding<CGFloat>) -> some View {
        Circle()
            .fill(Color.AppColor.primary)
            .frame(width: thumbSize, height: thumbSize)
            .overlay(alignment: .top) {
                label(value: value)
                    .fixedSize()
                    .onGeometryChange(for: CGFloat.self) {
                        $0.size.width
                    } action: {
                        labelWidth.wrappedValue = $0
                    }
                    .offset(x: math.labelXOffset(trackWidth: width, value: value, labelWidth: labelWidth.wrappedValue))
            }
    }
    
    private func label(value: Double) -> some View {
        Text("\(value, specifier: "%.2f") $")
            .font(.AppFont.body)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.white)
                    .stroke(Color.AppColor.primary, lineWidth: 1)
            )
            .offset(y: -30)
    }
    
    private var fromThumb: some View {
        thumb(value: from, labelWidth: $fromLabelWidth)
    }
    
    private var toThumb: some View {
        thumb(value: to, labelWidth: $toLabelWidth)
    }
}

#Preview {
    @Previewable @State var from: Double = 10
    @Previewable @State var to: Double = 40
    
    RangeSlider(from: $from, to: $to, bounds: 0...100)
}
