import SwiftUI

struct SubCategoryView: View {
    let vm: CatalogViewModel
    
    var body: some View {
        if let subCategories = vm.subCategories, !subCategories.isEmpty {
            List {
                ForEach(subCategories, id: \.id) { item in
                    Text(item.name)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .cardBorder()
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                        .listRowSeparator(.hidden)
                        .horizontalScreenPadding()
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
    SubCategoryView(vm: CatalogViewModel())
}
