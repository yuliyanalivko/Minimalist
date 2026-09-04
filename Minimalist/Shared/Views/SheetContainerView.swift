import SwiftUI

struct SheetContainerView<Content: View, Footer: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    
    let content: Content
    let footer: Footer
    
    @State private var contentHeight: CGFloat = 200
    @State private var footerHeight: CGFloat = 0
    @State private var navigationBarHeight: CGFloat = 0
        
    private var hasFooter: Bool {
        Footer.self != EmptyView.self
    }
    
    private var sheetHeight: CGFloat {
        return contentHeight + footerHeight + navigationBarHeight
    }
    
    init(
        title: String,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.title = title
        self.content = content()
        self.footer = footer()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                content
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                    .onGeometryChange(for: CGFloat.self) {
                        $0.size.height
                    } action: {
                        contentHeight = $0
                    }
            }
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.safeAreaInsets.top
            } action: {
                navigationBarHeight = $0
            }
            .scrollBounceBehavior(.basedOnSize)
            .contentMargins(.bottom, 0, for: .scrollContent)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if hasFooter {
                    footer
                        .padding(.top, 30)
                        .frame(maxWidth: .infinity)
                        .onGeometryChange(for: CGFloat.self) {
                            $0.size.height
                        } action: {
                            footerHeight = $0
                        }
                }
            }
            .navigationTitle(title)
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
        }
        .presentationDetents([.height(sheetHeight), .medium])
        .presentationBackground(.white)
    }
}

extension SheetContainerView where Footer == EmptyView {
    init(
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.init(title: title, content: content, footer: { EmptyView() })
    }
}
