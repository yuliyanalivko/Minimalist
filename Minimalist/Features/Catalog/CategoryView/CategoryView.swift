import SwiftUI

struct CategoryView: View {
    let viewModel: CategoryViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: viewModel.columns, spacing: 16) {
                ForEach(viewModel.displayedCategories ?? [], id: \.id) { item in
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
        .overlay(
            Group {
                switch viewModel.state {
                case .emptySearch:
                    ContentUnavailableView.search
                    
                case .loading:
                    ProgressView()
                    
                case .empty:
                    NoDataView()
                    
                default:
                    EmptyView()
                }
            }
                .tabBarAwareCentering()
                .fixedSize()
        )
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
