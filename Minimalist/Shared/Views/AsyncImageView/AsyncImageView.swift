import SwiftUI

struct AsyncImageView: View {
    let url: URL?
    
    init(url: String, size: Int = 500) {
        self.url = URL(string: url)?.resized(to: size)
    }

    var body: some View {
        ZStack {
            AsyncImage(url: url) { phase in
                switch phase {
                case .failure:
                    imagePlaceholder
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                default:
                    ProgressView()
                }
            }
        }
    }
    
    private var imagePlaceholder: some View {
        Image.photo
            .font(.largeTitle)
            .foregroundStyle(Color.AppColor.textSecondary)
    }
}

#Preview {
    AsyncImageView(url: "https://www.mamp.one/wp-content/uploads/2024/09/image-resources2.jpg")
}
