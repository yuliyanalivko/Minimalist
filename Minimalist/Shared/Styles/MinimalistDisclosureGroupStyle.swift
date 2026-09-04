import SwiftUI

struct MinimalistDisclosureGroupStyle: DisclosureGroupStyle {
    var showBadge: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            Button {
                withAnimation {
                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    configuration.label
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .fontWeight(.semibold)
                        .overlay(
                            Group {
                                if showBadge {
                                    badge
                                }
                            },
                            alignment: .topTrailing
                        )
                    
                    Spacer()
                    
                    Image(systemName: configuration.isExpanded ? AppIcon.arrowUp.rawValue : AppIcon.arrowDown.rawValue)
                        .foregroundStyle(Color.AppColor.textSecondary)
                        .animation(nil, value: configuration.isExpanded)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(Color.AppColor.inactive)
                .foregroundStyle(Color.AppColor.textPrimary)
                .font(.AppFont.body)
                .contentShape(Rectangle())
                .separator(.bottom)
                .separator(.top)
            }
            .buttonStyle(.plain)
            
            if configuration.isExpanded {
                configuration.content
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
            }
        }
    }
    
    @ViewBuilder
    var badge: some View {
        Circle()
            .fill(Color.AppColor.primary)
            .frame(width: 8, height: 8)
            .offset(x: 10)
    }
}
