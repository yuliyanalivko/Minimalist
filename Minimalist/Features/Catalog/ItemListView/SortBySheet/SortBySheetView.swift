import SwiftUI

struct SortBySheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel: SortBySheetViewModel
    
    let onChanged: (SortOption?, SortOrder?) -> Void
    
    var body: some View {
        NavigationStack {
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
                                    viewModel.getSelectedOrder(option: option)
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
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.AppColor.backgroundSecondary),
                        alignment: .bottom
                    )
                }
            }
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.AppColor.backgroundSecondary),
                alignment: .top
            )
            .padding(.vertical, 40)
            .navigationTitle("Sort by")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Close", systemImage: "multiply")
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.plain)
                }
            }
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newSize in
                viewModel.updateHeight(newSize.height)
            }
        }
        .presentationDetents([.height(viewModel.height)])
        .presentationBackground(.white)
        .onChange(of: [viewModel.selectedOption, viewModel.selectedOrder] as [AnyHashable]) { _, _ in
            onChanged(viewModel.selectedOption, viewModel.selectedOrder)
        }
    }
}

#Preview {
    SortBySheetView(viewModel: SortBySheetViewModel()) {_, _ in}
}
