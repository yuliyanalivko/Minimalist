import SwiftUI

struct CategoryView: View {
    let viewModel: CatalogViewModel
    
    var body: some View {
        if !viewModel.categories.isEmpty {
            ScrollView {
                LazyVGrid(columns: viewModel.columns, spacing: 16) {
                    ForEach(viewModel.categories, id: \.id) { item in
                        CategoryCardView(title: item.name, icon: item.iconName ?? nil)
                            .onTapGesture {
                                viewModel.handleCategoryCardClick(category: item)
                            }
                    }
                }
                .defaultHorizontalScreenPadding()
                .verticalScreenSpacing()
            }
        } else {
            EmptySearchResultView()
        }
    }
}

#Preview {
    CategoryView(viewModel: CatalogViewModel())
}
