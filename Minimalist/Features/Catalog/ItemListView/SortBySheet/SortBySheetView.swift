import SwiftUI

struct SortBySheetView: View {
    let viewModel: SortBySheetViewModel
    
    var body: some View {
        SheetContainerView(title: "Sort by") {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.options, id: \.self) { option in
                    HStack {
                        Text(option.rawValue)
                            .font(.AppFont.body)
                            .padding(.leading, 40)
                        Spacer()
                        SortingControl(
                            order: Binding(
                                get: {
                                    viewModel.selectedOrder(for: option)
                                },
                                set: { newOrder in
                                    viewModel.updateSelection(order: newOrder, option: option)
                                }
                            )
                        )
                        .frame(width: 100)
                        .padding(.trailing, 40)
                    }
                    .padding(.vertical, 10)
                    .background(Color.AppColor.inactive)
                    .separator(.bottom)
                }
            }
            .separator(.top)
        }
    }
}

#Preview {
    SortBySheetView(viewModel: SortBySheetViewModel())
}
