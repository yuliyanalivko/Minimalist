import SwiftUI

struct SubCategoryView: View {
    let vm: CatalogViewModel
    
    var body: some View {
        List {
            ForEach(vm.subCategories ?? [], id: \.id) { item in
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
    }
}

#Preview {
    SubCategoryView(vm: CatalogViewModel())
}
