import SwiftUI

struct CategoryView: View {
    let viewModel: CategoryViewModel
    
    var body: some View {
        
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
                
            case .content(let categories):
                ScrollView {
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
                }
                
            case .emptySearch:
                EmptySearchResultView()
                
            case .empty:
                Text("No Data")
            }
        }
        .task {
            await viewModel.fetchCategories()
        }
    }
}

#Preview {
    CategoryView(viewModel: CategoryViewModel(router: CatalogRouter()))
}
