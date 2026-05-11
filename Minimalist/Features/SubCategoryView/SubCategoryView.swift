import SwiftUI

struct SubCategoryView: View {
    let vm: CatalogViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.subCategories ?? [], id: \.id) { item in
                    Text(item.name)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(CardBorder())
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    SubCategoryView(vm: CatalogViewModel())
}
