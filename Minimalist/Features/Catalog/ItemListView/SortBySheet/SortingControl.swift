import UIKit
import SwiftUI

struct SortingControl: UIViewRepresentable {
    @Binding var order: SortOrder?
    let items = [AppIcon.arrowUp.rawValue, AppIcon.arrowDown.rawValue]
    
    func makeUIView(context: Context) -> UISegmentedControl {
        let control = DeselectableSegmentedControl(items: items)
        
        for (index, name) in items.enumerated() {
            if let image = UIImage(systemName: name) {
                control.setImage(image, forSegmentAt: index)
            }
        }
        
        control.selectedSegmentTintColor = UIColor(.AppColor.primary)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor(.AppColor.textSecondary)], for: .normal)
        
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        control.onDeselect = { _ in
            context.coordinator.segmentDeselected()
        }
        
        return control
    }
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        uiView.selectedSegmentIndex = order == .forward ? 0 : order == .reverse ? 1 : UISegmentedControl.noSegment
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: SortingControl
        
        init(_ parent: SortingControl) {
            self.parent = parent
        }
        
        @objc func valueChanged(_ sender: UISegmentedControl) {
            parent.order = sender.selectedSegmentIndex == 0 ? .forward : sender.selectedSegmentIndex == 1 ? .reverse : nil
        }
        
        func segmentDeselected() {
            parent.order = nil
        }
    }
    
    class DeselectableSegmentedControl: UISegmentedControl {
        var onDeselect: ((Int) -> Void)?
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            let previousIndex = selectedSegmentIndex
            super.touchesEnded(touches, with: event)
            
            if previousIndex == selectedSegmentIndex, previousIndex != UISegmentedControl.noSegment {
                onDeselect?(previousIndex)
            }
        }
    }
}
