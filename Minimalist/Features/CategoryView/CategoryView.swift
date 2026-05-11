import SwiftUI

struct CategoryView: View {
    let vm: CatalogViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: vm.columns, spacing: 16) {
                ForEach(vm.categories, id: \.id) { item in
                    CategoryCardView(title: item.name, icon: item.iconName ?? nil)
                        .onTapGesture {
                            vm.select(item)
                        }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    CategoryView(vm: CatalogViewModel())
}
