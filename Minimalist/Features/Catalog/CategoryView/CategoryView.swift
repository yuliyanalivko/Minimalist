import SwiftUI

struct CategoryView: View {
    let viewModel: CategoryViewModel
    
    var body: some View {
        if !viewModel.displayedCategories.isEmpty {
            ScrollView {
                LazyVGrid(columns: viewModel.columns, spacing: 16) {
                    ForEach(viewModel.displayedCategories, id: \.id) { item in
                        CategoryCardView(title: item.name, icon: item.iconName ?? nil)
                            .contentShape(Rectangle())
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
    CategoryView(viewModel: CategoryViewModel(router: CatalogRouter()))
}
