import SwiftUI

struct CatalogView: View {
    @State var router = CatalogRouter()
    
    @State private var vm = CatalogViewModel()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            screen(for: .category)
                .navigationDestination(for: CatalogRoute.self) { route in
                    screen(for: route)
                }
        }
        .environment(router)
    }
    
    @ViewBuilder
    private func screen(for route: CatalogRoute) -> some View {
        switch route {
        case .category:
            CategoryView(vm: vm)
                .navigationTitle(CatalogRoute.category.title)
                .searchable(
                    text: $vm.categorySearchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search"
                )
            
        case .subcategory:
            SubCategoryView(vm: vm)
                .navigationTitle(route.title)
                .searchable(
                    text: $vm.subCategorySearchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search"
                )
        }
    }
}

#Preview {
    CatalogView()
}
