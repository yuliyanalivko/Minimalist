import SwiftUI
import Kingfisher

struct ImageView: View {
    let url: URL?
    
    init(url: String, size: Int = 500) {
        self.url = URL(string: url)?.resized(to: size)
    }
    
    var body: some View {
        KFImage.url(url)
            .placeholder {
                ProgressView()
            }
            .onFailureView {
                ImagePlaceholder()
            }
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .resizable()
            .scaledToFill()
    }
}

#Preview {
    ImageView(url: "https://www.mamp.one/wp-content/uploads/2024/09/image-resources2.jpg")
}
