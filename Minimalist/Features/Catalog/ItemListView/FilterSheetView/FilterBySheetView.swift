import SwiftUI

struct FilterBySheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var viewModel: FilterBySheetViewModel
    
    var body: some View {
        SheetContainerView(title: "Filter by") {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.options, id: \.self) { option in
                    DisclosureGroup(
                        option.rawValue,
                        isExpanded: viewModel.isExpanded(option: option)
                    ) {
                        content(for: option)
                    }
                    .disclosureGroupStyle(MinimalistDisclosureGroupStyle(showBadge: viewModel.hasActiveFilter(option: option)))
                }
            }
        } footer: {
            HStack(alignment: .center, spacing: 16) {
                Button {
                    viewModel.clear()
                } label: {
                    Text("Clear")
                        .textCase(.uppercase)
                        .font(.AppFont.inputText)
                        .foregroundStyle(Color.AppColor.primary)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle(backgroundColor: .clear, minWidth: 0, borderColor: .AppColor.primary))

                
                Button {
                    viewModel.apply()
                    dismiss()
                } label: {
                    Text("Apply")
                    .frame(maxWidth: .infinity)
                }
                .disabled(viewModel.isApplyDisabled)
                .buttonStyle(PrimaryButtonStyle(minWidth: 0))
            }
            .padding(.horizontal, 40)
        }
        .onAppear {
            viewModel.configureInitialState()
        }
    }
    
    @ViewBuilder
    private func content(for option: FilterOption) -> some View {
        switch option {
        case .category:
            categoryList
            
        case .price:
            RangeSlider(
                from: $viewModel.minPrice,
                to: $viewModel.maxPrice,
                bounds: viewModel.priceBounds
            )
            .padding(.top, 50)
            .padding(.bottom, 30)
            .padding(.horizontal, 40)
            
        case .rating:
            RatingView(viewModel: viewModel.ratingViewModel) { newRating in
                viewModel.draftFilterState.minRating = newRating
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
        }
    }
    
    @ViewBuilder
    private var categoryList: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.categories, id: \.id) { category in
                RadioButton(title: category.name, value: category.id, selection: $viewModel.draftFilterState.categoryId)
                    .padding(.leading, 80)
                    .padding(.trailing, 40)
                    .padding(.vertical, 15)
                    .separator(.bottom)
            }
        }
    }
}

#Preview {
    FilterBySheetView(viewModel: FilterBySheetViewModel(categories: [], priceBounds: 0...100))
}
