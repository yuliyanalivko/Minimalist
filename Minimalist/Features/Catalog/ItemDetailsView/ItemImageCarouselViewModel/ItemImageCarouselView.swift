import SwiftUI

struct ItemImageCarouselView: View {
    
    @Bindable var viewModel: ItemImageCarouselViewModel

    var body: some View {
        TabView(selection: $viewModel.selectedIndex) {
            ForEach(Array(viewModel.imageUrls.enumerated()), id: \.offset) { index, url in
                image(url: url)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: viewModel.imageHeight)
        .task {
            viewModel.preloadImages()
        }

    }

    @ViewBuilder
    private func image(url: String) -> some View {
        Color.AppColor.backgroundSecondary
            .frame(height: viewModel.imageHeight)
            .overlay {
                ImageView(url: url)
            }
            .cornerRadius(10)
            .defaultHorizontalScreenPadding()
    }
}


#Preview {
    ItemImageCarouselView(viewModel: ItemImageCarouselViewModel(imageUrls: [
        "https://www.mamp.one/wp-content/uploads/2024/09/image-resources2.jpg",
        "https://picsum.photos/id/237/200/300",
        "https://iso.500px.com/wp-content/uploads/2018/05/Blog-marketplace-getty500px-48429366-nologo-3000x2000.png",
        "https://cdn.pixabay.com/photo/2018/03/31/13/43/bird-3278162_1280.jpg",
        "https://static.wikia.nocookie.net/alldimensions/images/0/02/Universe-expanding-acceleration-1.jpg/revision/latest?cb=20260328105224",
        "https://lsc.org/a360c87dad4512ce6cb6f84fc5978602.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/5/55/Large_breaking_wave.jpg",
        "https://www.shaylehollie.co.uk/wp-content/uploads/2025/04/Thurstaston-Beach-Sunset.jpg"
    ]))
}
