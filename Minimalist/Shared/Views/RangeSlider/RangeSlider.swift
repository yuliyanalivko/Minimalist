import SwiftUI

struct RangeSlider: View {
    @Binding var from: Double
    @Binding var to: Double    

    @State private var viewModel: RangeSliderViewModel
    
    init(from: Binding<Double>, to: Binding<Double>, bounds: ClosedRange<Double>) {
        self._from = from
        self._to = to
        _viewModel = State(initialValue: RangeSliderViewModel(bounds: bounds))
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.AppColor.backgroundSecondary)
                .frame(height: 3)
                .onGeometryChange(for: CGSize.self) { proxy in
                    proxy.size
                } action: { newValue in
                    viewModel.width = newValue.width
                }
            
            Rectangle()
                .fill(Color.AppColor.primary)
                .frame(width: viewModel.sliderWidth(width: viewModel.width, from: from, to: to), height: 3)
                .offset(x: viewModel.xOffset(width: viewModel.width, for: from))
            
            fromThumb
                .offset(x: viewModel.xThumbOffset(width: viewModel.width, for: from))
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .named(viewModel.trackCoordinateSpace))
                        .onChanged { value in
                            from = viewModel.lowerValue(atX: value.location.x, width: viewModel.width, upperBound: to)
                        }
                )
            
            toThumb
                .offset(x: viewModel.xThumbOffset(width: viewModel.width, for: to))
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .named(viewModel.trackCoordinateSpace))
                        .onChanged { value in
                            to = viewModel.upperValue(atX: value.location.x, width: viewModel.width, lowerBound: from)
                        }
                )
        }
        .coordinateSpace(.named(viewModel.trackCoordinateSpace))
    }
    
    private func thumb(value: Double, labelWidth: Binding<CGFloat>) -> some View {
        Circle()
            .fill(Color.AppColor.primary)
            .frame(width: viewModel.thumbSize, height: viewModel.thumbSize)
            .overlay(alignment: .top) {
                label(value: value)
                    .fixedSize()
                    .onGeometryChange(for: CGFloat.self) {
                        $0.size.width
                    } action: {
                        labelWidth.wrappedValue = $0
                    }
                    .offset(x: viewModel.labelXOffset(trackWidth: viewModel.width, value: value, labelWidth: labelWidth.wrappedValue))
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
        thumb(value: from, labelWidth: $viewModel.fromLabelWidth)
    }
    
    private var toThumb: some View {
        thumb(value: to, labelWidth: $viewModel.toLabelWidth)
    }
}

#Preview {
    @Previewable @State var from: Double = 10
    @Previewable @State var to: Double = 40
    
    RangeSlider(from: $from, to: $to, bounds: 0...100)
}
