import SwiftUI

struct ItemDetailsView: View {
    let id: String
    
    var body: some View {
        Text(id)
    }
}

#Preview {
    ItemDetailsView(id: "003479db-a8ec-4d3a-8657-bad7da28d01a")
}
