import SwiftUI

struct CategoryView: View {
    let viewModel: CategoryViewModel
    
    var body: some View {
        
        ScrollView {
            switch viewModel.state {
            case .loading:
                ProgressView()
                
            case .content(let categories):
                LazyVGrid(columns: viewModel.columns, spacing: 16) {
                    ForEach(categories, id: \.id) { item in
                        CategoryCardView(title: item.name, icon: item.iconName ?? nil)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.handleCategoryCardClick(category: item)
                            }
                    }
                }
                .defaultHorizontalScreenPadding()
                .verticalScreenSpacing()
                
            case .emptySearch:
                EmptySearchResultView()
                    .tabBarAwareCentering()
                
            case .empty:
                Text("No Data")
                    .tabBarAwareCentering()
            }
        }
        .defaultScrollAnchor(viewModel.scrollAnchorAligment, for: .alignment)
        .task {
            await viewModel.fetchCategories()
        }
        .refreshable {
            await viewModel.fetchCategories()
        }
    }
}

#Preview {
    CategoryView(viewModel: CategoryViewModel(router: CatalogRouter()))
}
