import SwiftUI

extension View {
    func searchableWithDebounce(text: Binding<String>, action: @escaping () -> Void) -> some View {
        self
            .searchable(
                text: text,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search"
            )
            .task(id: text.wrappedValue) {
                try? await Task.sleep(for: .seconds(0.5))
                
                guard !Task.isCancelled else { return }
                
                action()
            }
    }
}
