import SwiftUI

struct CategoryView: View {
    let vm: CatalogViewModel
    @Environment(CatalogRouter.self) private var router
    @State private var searchText = ""
    
    var body: some View {
        if !vm.categories.isEmpty {
            ScrollView {
                LazyVGrid(columns: vm.columns, spacing: 16) {
                    ForEach(vm.categories, id: \.id) { item in
                        CategoryCardView(title: item.name, icon: item.iconName ?? nil)
                            .onTapGesture {
                                vm.select(item)
                                router.navigate(to: CatalogRoute.subcategory(title: item.name))
                            }
                    }
                }
                .horizontalScreenPadding()
                .verticalScreenSpacing()
            }
        } else {
            EmptySearchResultView()
        }
    }
}

#Preview {
    CategoryView(vm: CatalogViewModel())
}
