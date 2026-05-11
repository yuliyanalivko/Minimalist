import SwiftUI

struct CatalogView: View {
    private let vm = CatalogViewModel()
    
    var body: some View {
        switch vm.displayMode {
        case .category:
            CategoryView(vm: vm)
        case .subCategory:
            SubCategoryView(vm: vm)
        }
    }
}

#Preview {
    CatalogView()
}
