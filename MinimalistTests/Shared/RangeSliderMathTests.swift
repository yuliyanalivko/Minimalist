import Testing
import Foundation
@testable import Minimalist

struct RangeSliderMathTests {
    
    private let math = RangeSliderMath(bounds: 0...100, step: 1, thumbSize: 18)
    
    @Test("Should not shift a centered label")
    func labelXOffset_zeroWhenCentered() {
        let offset = math.labelXOffset(trackWidth: 200, value: 50, labelWidth: 40)
        
        #expect(offset == 0)
    }
    
    @Test("Should shift a left-edge label inward")
    func labelXOffset_shiftInwardAtMin() {
        let offset = math.labelXOffset(trackWidth: 200, value: 0, labelWidth: 40)
        
        #expect(offset == 11)
    }
    
    @Test("Should shift a right-edge label inward")
    func labelXOffset_shiftInwardAtMax() {
        let offset = math.labelXOffset(trackWidth: 200, value: 100, labelWidth: 40)
        
        #expect(offset == -11)
    }
    
    @Test("Should center a label that is wider than the track")
    func labelXOffset_centerWhenLabelWiderThanTrack() {
        let offset = math.labelXOffset(trackWidth: 200, value: 0, labelWidth: 240)
        
        #expect(offset == 91)
    }
    
    @Test("Should snap a value to whole steps")
    func value_snapsToStep() {
        #expect(math.value(atX: 100, width: 200) == 50)
    }
    
    @Test("Should keep a value inside the bounds")
    func value_clampedToBounds() {
        #expect(math.value(atX: -50, width: 200) == 0)
        #expect(math.value(atX: 500, width: 200) == 100)
    }
    
    @Test("Should clamp snapped values that round outside the bounds")
    func snap_clampedToBounds() {
        let math = RangeSliderMath(bounds: 10.5...20.5, step: 1, thumbSize: 18)
        
        #expect(math.snap(10.5) == 10.5)
        #expect(math.snap(20.5) == 20.5)
        #expect(math.snap(9) == 10.5)
        #expect(math.snap(22) == 20.5)
    }
    
    @Test("Should keep out-of-bounds values on the track")
    func percentage_clampedForOutOfBoundsValues() {
        #expect(math.xOffset(width: 200, for: -50) == math.xOffset(width: 200, for: 0))
        #expect(math.xOffset(width: 200, for: 150) == math.xOffset(width: 200, for: 100))
    }
    
    @Test("Should keep thumbs inside the track")
    func xThumbOffset_keepsThumbsInsideTrack() {
        #expect(math.xThumbOffset(width: 200, for: 0) == 0)
        #expect(math.xThumbOffset(width: 200, for: 100) == 182)
    }
    
    @Test("Should fall back to the lower bound without a measured track")
    func value_lowerBoundWithoutWidth() {
        #expect(math.value(atX: 100, width: 0) == 0)
    }
    
    @Test("Should not let the lower thumb pass the upper thumb")
    func lowerValue_stopsAtUpperValue() {
        #expect(math.lowerValue(atX: 180, width: 200, upperBound: 40) == 40)
        #expect(math.lowerValue(atX: 45, width: 200, upperBound: 40) == 20)
    }
    
    @Test("Should not let the upper thumb pass the lower thumb")
    func upperValue_stopsAtLowerValue() {
        #expect(math.upperValue(atX: 20, width: 200, lowerBound: 40) == 40)
        #expect(math.upperValue(atX: 155, width: 200, lowerBound: 40) == 80)
    }
    
    @Test("Should clamp a from/to pair into the bounds")
    func clamp_fromToPair() {
        let clamped = math.clamp(from: -10, to: 150)
        
        #expect(clamped.0 == 0)
        #expect(clamped.1 == 100)
    }
    
    @Test("Should keep from below to when clamping")
    func clamp_fromNeverExceedsTo() {
        let clamped = math.clamp(from: 80, to: 20)
        
        #expect(clamped.0 == 80)
        #expect(clamped.1 == 80)
    }
    
    @Test("Should measure the selected track between two values")
    func sliderWidth_distanceBetweenValues() {
        #expect(math.sliderWidth(width: 200, from: 0, to: 100) == 182)
        #expect(math.sliderWidth(width: 200, from: 25, to: 75) == 91)
    }
    
    @Test("Should clamp a single value into the bounds")
    func clamp_singleValue() {
        #expect(math.clamp(-10) == 0)
        #expect(math.clamp(50) == 50)
        #expect(math.clamp(150) == 100)
    }
    
    @Test("Should skip snapping when the step is zero")
    func snap_returnsClampedValueWhenStepIsZero() {
        let math = RangeSliderMath(bounds: 0...100, step: 0, thumbSize: 18)
        
        #expect(math.snap(33.3) == 33.3)
        #expect(math.snap(-5) == 0)
        #expect(math.snap(200) == 100)
    }
    
    @Test("Should not shift a label without a measured track or width")
    func labelXOffset_zeroWithoutMeasurements() {
        #expect(math.labelXOffset(trackWidth: 0, value: 50, labelWidth: 40) == 0)
        #expect(math.labelXOffset(trackWidth: 200, value: 50, labelWidth: 0) == 0)
    }
    
    @Test("Should keep offsets at the origin when the bounds have no span")
    func xOffset_zeroSpanBounds() {
        let math = RangeSliderMath(bounds: 10...10, step: 1, thumbSize: 18)
        
        #expect(math.xOffset(width: 200, for: 10) == 9)
        #expect(math.xThumbOffset(width: 200, for: 10) == 0)
        #expect(math.value(atX: 100, width: 200) == 10)
    }
}
