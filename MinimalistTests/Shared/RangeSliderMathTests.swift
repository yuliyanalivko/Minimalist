import Testing
import Foundation
@testable import Minimalist

struct RangeSliderViewModelTests {
    
    private let viewModel = RangeSliderViewModel(bounds: 0...100)
    
    @Test("Should not shift a centered label")
    func labelXOffset_zeroWhenCentered() {
        let offset = viewModel.labelXOffset(trackWidth: 200, value: 50, labelWidth: 40)
        
        #expect(offset == 0)
    }
    
    @Test("Should shift a left-edge label inward")
    func labelXOffset_shiftInwardAtMin() {
        let offset = viewModel.labelXOffset(trackWidth: 200, value: 0, labelWidth: 40)
        
        #expect(offset == 11)
    }
    
    @Test("Should shift a right-edge label inward")
    func labelXOffset_shiftInwardAtMax() {
        let offset = viewModel.labelXOffset(trackWidth: 200, value: 100, labelWidth: 40)
        
        #expect(offset == -11)
    }
    
    @Test("Should center a label that is wider than the track")
    func labelXOffset_centerWhenLabelWiderThanTrack() {
        let offset = viewModel.labelXOffset(trackWidth: 200, value: 0, labelWidth: 240)
        
        #expect(offset == 91)
    }
    
    @Test("Should snap a value to whole steps")
    func value_snapsToStep() {
        #expect(viewModel.value(atX: 100, width: 200) == 50)
    }
    
    @Test("Should keep a value inside the bounds")
    func value_clampedToBounds() {
        #expect(viewModel.value(atX: -50, width: 200) == 0)
        #expect(viewModel.value(atX: 500, width: 200) == 100)
    }
    
    @Test("Should clamp snapped values that round outside the bounds")
    func snap_clampedToBounds() {
        let math = RangeSliderViewModel(bounds: 10.5...20.5)
        
        #expect(math.snap(10.5) == 10.5)
        #expect(math.snap(20.5) == 20.5)
        #expect(math.snap(9) == 10.5)
        #expect(math.snap(22) == 20.5)
    }
    
    @Test("Should keep out-of-bounds values on the track")
    func percentage_clampedForOutOfBoundsValues() {
        #expect(viewModel.xOffset(width: 200, for: -50) == viewModel.xOffset(width: 200, for: 0))
        #expect(viewModel.xOffset(width: 200, for: 150) == viewModel.xOffset(width: 200, for: 100))
    }
    
    @Test("Should keep thumbs inside the track")
    func xThumbOffset_keepsThumbsInsideTrack() {
        #expect(viewModel.xThumbOffset(width: 200, for: 0) == 0)
        #expect(viewModel.xThumbOffset(width: 200, for: 100) == 182)
    }
    
    @Test("Should fall back to the lower bound without a measured track")
    func value_lowerBoundWithoutWidth() {
        #expect(viewModel.value(atX: 100, width: 0) == 0)
    }
    
    @Test("Should not let the lower thumb pass the upper thumb")
    func lowerValue_stopsAtUpperValue() {
        #expect(viewModel.lowerValue(atX: 180, width: 200, upperBound: 40) == 40)
        #expect(viewModel.lowerValue(atX: 45, width: 200, upperBound: 40) == 20)
    }
    
    @Test("Should not let the upper thumb pass the lower thumb")
    func upperValue_stopsAtLowerValue() {
        #expect(viewModel.upperValue(atX: 20, width: 200, lowerBound: 40) == 40)
        #expect(viewModel.upperValue(atX: 155, width: 200, lowerBound: 40) == 80)
    }
    
    @Test("Should clamp a from/to pair into the bounds")
    func clamp_fromToPair() {
        let clamped = viewModel.clamp(from: -10, to: 150)
        
        #expect(clamped.0 == 0)
        #expect(clamped.1 == 100)
    }
    
    @Test("Should keep from below to when clamping")
    func clamp_fromNeverExceedsTo() {
        let clamped = viewModel.clamp(from: 80, to: 20)
        
        #expect(clamped.0 == 80)
        #expect(clamped.1 == 80)
    }
    
    @Test("Should measure the selected track between two values")
    func sliderWidth_distanceBetweenValues() {
        #expect(viewModel.sliderWidth(width: 200, from: 0, to: 100) == 182)
        #expect(viewModel.sliderWidth(width: 200, from: 25, to: 75) == 91)
    }
    
    @Test("Should clamp a single value into the bounds")
    func clamp_singleValue() {
        #expect(viewModel.clamp(-10) == 0)
        #expect(viewModel.clamp(50) == 50)
        #expect(viewModel.clamp(150) == 100)
    }
    
    @Test("Should not shift a label without a measured track or width")
    func labelXOffset_zeroWithoutMeasurements() {
        #expect(viewModel.labelXOffset(trackWidth: 0, value: 50, labelWidth: 40) == 0)
        #expect(viewModel.labelXOffset(trackWidth: 200, value: 50, labelWidth: 0) == 0)
    }
    
    @Test("Should keep offsets at the origin when the bounds have no span")
    func xOffset_zeroSpanBounds() {
        let viewModel = RangeSliderViewModel(bounds: 10...10)
        
        #expect(viewModel.xOffset(width: 200, for: 10) == 9)
        #expect(viewModel.xThumbOffset(width: 200, for: 10) == 0)
        #expect(viewModel.value(atX: 100, width: 200) == 10)
    }
}
