import Foundation

@Observable
class RangeSliderViewModel {
    
    let bounds: ClosedRange<Double>
    
    let step: Double = 1
    let thumbSize: CGFloat = 18
    var width: Double = 0
    var fromLabelWidth: CGFloat = 0
    var toLabelWidth: CGFloat = 0
    let trackCoordinateSpace = "RangeSliderTrack"
    
    init(bounds: ClosedRange<Double>) {
        self.bounds = bounds
    }
    
    func sliderWidth(width: CGFloat, from: Double, to: Double) -> CGFloat {
        xOffset(width: width, for: to) - xOffset(width: width, for: from)
    }
    
    func xOffset(width: CGFloat, for value: Double) -> CGFloat {
        thumbSize / 2 + usableWidth(for: width) * percentage(for: value)
    }
    
    func xThumbOffset(width: CGFloat, for value: Double) -> CGFloat {
        xOffset(width: width, for: value) - thumbSize / 2
    }
    
    func labelXOffset(trackWidth: CGFloat, value: Double, labelWidth: CGFloat) -> CGFloat {
        guard trackWidth > 0, labelWidth > 0 else {
            return 0
        }
        
        let centerX = xOffset(width: trackWidth, for: value)
        let halfLabel = labelWidth / 2
        let minCenter = halfLabel
        let maxCenter = trackWidth - halfLabel
        
        guard minCenter < maxCenter else {
            return trackWidth / 2 - centerX
        }
        
        let clampedCenter = min(max(centerX, minCenter), maxCenter)
        
        return clampedCenter - centerX
    }
    
    func value(atX x: CGFloat, width: CGFloat) -> Double {
        let usableWidth = usableWidth(for: width)
        
        guard usableWidth > 0 else {
            return bounds.lowerBound
        }
        
        let adjustedX = x - thumbSize / 2
        let ratio = min(max(adjustedX / usableWidth, 0), 1)
        let raw = bounds.lowerBound + (bounds.upperBound - bounds.lowerBound) * Double(ratio)
        
        return snap(raw)
    }
    
    func lowerValue(atX x: CGFloat, width: CGFloat, upperBound: Double) -> Double {
        let maxAllowed = min(max(upperBound, bounds.lowerBound), bounds.upperBound)
        
        return min(value(atX: x, width: width), maxAllowed)
    }
    
    func upperValue(atX x: CGFloat, width: CGFloat, lowerBound: Double) -> Double {
        let minAllowed = min(max(lowerBound, bounds.lowerBound), bounds.upperBound)
        
        return max(value(atX: x, width: width), minAllowed)
    }
    
    func clamp(_ value: Double) -> Double {
        min(max(value, bounds.lowerBound), bounds.upperBound)
    }
    
    func clamp(from: Double, to: Double) -> (Double, Double) {
        let lowerBound = clamp(from)
        let upperBound = max(clamp(to), lowerBound)
        
        return (lowerBound, upperBound)
    }
    
    func snap(_ value: Double) -> Double {
        guard step > 0 else { return clamp(value) }
        
        let clamped = clamp(value)
        let steps = ((clamped - bounds.lowerBound) / step).rounded()
        
        return clamp(bounds.lowerBound + steps * step)
    }
    
    private func usableWidth(for width: CGFloat) -> CGFloat {
        max(width - thumbSize, 0)
    }
    
    private func percentage(for value: Double) -> CGFloat {
        let denominator = bounds.upperBound - bounds.lowerBound
        
        guard denominator > 0 else { return 0 }
        
        return CGFloat(min(max((value - bounds.lowerBound) / denominator, 0), 1))
    }
}
