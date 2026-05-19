import SwiftUI

struct SubCategoryView: View {
    let viewModel: CategoryViewModel
    
    var body: some View {
        if let subCategories = viewModel.subCategories, !subCategories.isEmpty {
            List {
                ForEach(subCategories, id: \.id) { item in
                    Text(item.name)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .cardBorder()
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: item.id == subCategories.last?.id ? 0 : 16, trailing: 0))
                        .listRowSeparator(.hidden)
                        .defaultHorizontalScreenPadding()
                        .onTapGesture {
                            viewModel.handleSubCategoryCardClick(subCategory: item)
                        }
                }
            }
            .verticalScreenSpacing()
            .listStyle(.plain)
        } else {
            EmptySearchResultView()
        }
    }
}

#Preview {
    SubCategoryView(viewModel: CategoryViewModel(router: CatalogRouter()))
}
