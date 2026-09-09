import SwiftUI

struct NoDataView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Nothing was found", systemImage: "arrow.clockwise")
        } description: {
            Text("Pull to refresh to try again.")
        }
    }
}

#Preview {
    NoDataView()
}
