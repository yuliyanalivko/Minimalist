import SwiftUI

struct ItemImageCarouselView: View {
    
    let urls: [String]
    
    @State var viewModel: ItemImageCarouselViewModel
    
    init(urls: [String]) {
        self.urls = urls
        self.viewModel = ItemImageCarouselViewModel(imageCount: urls.count)
    }
    
    var body: some View {
        TabView(selection: $viewModel.selectedIndex) {
            ForEach(Array(urls.enumerated()), id: \.offset) { index, url in
                HStack {
                    AsyncImageView(url: url)
                        .containerRelativeFrame(.horizontal)
                        .frame(height: viewModel.imageHeight)
                        .background(Color.AppColor.backgroundSecondary)
                        .padding(.horizontal, -20)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .tag(index)
                }
            }
        }
        .frame(height: viewModel.imageHeight)
        .tabViewStyle(.page(indexDisplayMode: .never))
        
        HStack(spacing: 8) {
            ForEach(0..<viewModel.slotCount, id: \.self) { slot in
                let index = viewModel.index(forSlot: slot)

                Circle()
                    .fill(index == viewModel.selectedIndex
                          ? Color.AppColor.primary
                          : Color.AppColor.backgroundSecondary)
                    .frame(
                        width: viewModel.dotSize(forSlot: slot),
                        height: viewModel.dotSize(forSlot: slot)
                    )
                    .onTapGesture {
                        withAnimation {
                            viewModel.select(index)
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .clipped()
        .padding(.top, 15)
        .defaultHorizontalScreenPadding()
    }
}

#Preview {
    ItemImageCarouselView(urls: [
        "https://www.mamp.one/wp-content/uploads/2024/09/image-resources2.jpg",
        "https://picsum.photos/id/237/200/300",
        "https://www.mamp.one/wp-content/uploads/2024/09/image-resources2.jpg",
        "https://picsum.photos/id/237/200/300",
        "https://www.mamp.one/wp-content/uploads/2024/09/image-resources2.jpg",
        "https://picsum.photos/id/237/200/300",
        "https://www.mamp.one/wp-content/uploads/2024/09/image-resources2.jpg",
        "https://picsum.photos/id/237/200/300",
        "https://www.mamp.one/wp-content/uploads/2024/09/image-resources2.jpg",
        "https://picsum.photos/id/237/200/300",
        "https://www.mamp.one/wp-content/uploads/2024/09/image-resources2.jpg",
        "https://picsum.photos/id/237/200/300"
    ])
}
