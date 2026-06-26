import SwiftUI

struct ImagePlaceholder: View {
    var body: some View {
        Image.photo
            .font(.largeTitle)
            .foregroundStyle(Color.AppColor.textSecondary)
    }
}

#Preview {
    ImagePlaceholder()
}
