import SwiftUI

struct CatalogView: View {
    private let vm = CatalogViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: vm.columns, spacing: 16) {
                ForEach(vm.itemsToShow, id: \.id) { item in
                    CatalogCardView(title: item.name, icon: item.iconName ?? nil)
                        .onTapGesture {
                            vm.select(item)
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
