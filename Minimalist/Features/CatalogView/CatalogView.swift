import SwiftUI

struct CatalogView: View {
    private let vm = CatalogViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: vm.columns, spacing: 16) {
                if vm.view == .category {
                    ForEach(vm.categories, id: \.id) { item in
                        CatalogCardView(title: item.name, icon: item.iconName)
                            .onTapGesture {
                                vm.selectCategory(item)
                            }
                    }
                } else {
                    ForEach(vm.subCategories ?? [], id: \.id) { item in
                        CatalogCardView(title: item.name)
                            .onTapGesture {
                                vm.selectSubCategory(item)
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CatalogView()
}
