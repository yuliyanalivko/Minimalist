import SwiftUI

struct ItemReviewsView: View {
    
    let reviews: [Review]
    
    @State var viewModel: ItemReviewsViewModel
    
    init(reviews: [Review]) {
        self.reviews = reviews
        viewModel = ItemReviewsViewModel(reviews: reviews)
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.selectedIndex) {
                ForEach(Array(reviews.enumerated()), id: \.element.id) { index, review in
                    reviewItem(review)
                        .padding(.horizontal, 60)
                        .tag(index)
                }
            }
            .sheet(isPresented: $viewModel.isFullViewOpened) {
                NavigationStack {
                    FullReviewView(review: reviews[viewModel.selectedIndex])
                        .padding(.top, 40)
                }
                .presentationDetents([.medium, .large])
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 100)
            
            HStack {
                prevButton
                Spacer()
                    .allowsHitTesting(false)
                nextButton
            }
            .padding(.top, 15)
            .defaultHorizontalScreenPadding()
        }
        .tint(.AppColor.primary)
    }
    
    @ViewBuilder
    private func reviewItem(_ review: Review) -> some View {
        
        VStack {
            RatingView(rating: Double(review.rating))
                .allowsHitTesting(false)
            
            if let message = review.message {
                Text(message)
                    .font(.AppFont.caption)
                    .lineSpacing(6)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.handleReviewClick()
        }
    }
    
    private var prevButton: some View {
        Button {
            withAnimation {
                viewModel.navigateBack()
            }
        } label: {
            Image.previous
                .font(.AppFont.icon)
        }
        .disabled(viewModel.isPrevButtonDisabled)
        .opacity(viewModel.prevButtonOpacity)
    }
    
    private var nextButton: some View {
        Button {
            withAnimation {
                viewModel.navigateForward()
            }
        } label: {
            Image.next
                .font(.AppFont.icon)
        }
        .disabled(viewModel.isNextButtonDisabled)
        .opacity(viewModel.nextButtonOpacity)
    }
}

#Preview {
    ItemReviewsView(reviews: [
        Review(id: "2-id", rating: 4, message: "A text view always uses exactly the amount of space it needs to display its rendered contents, but you can affect the view’s layout. For example, you can use the frame(width:height:alignment:) modifier to propose specific dimensions to the view. If the view accepts the proposal but the text doesn’t fit into the available space, the view uses a combination of wrapping, tightening, scaling, and truncation to make it fit. With a width of 100 points but no constraint on the height, a text view might wrap a long string: A text view always uses exactly the amount of space it needs to display its rendered contents, but you can affect the view’s layout. For example, you can use the frame(width:height:alignment:) modifier to propose specific dimensions to the view. If the view accepts the proposal but the text doesn’t fit into the available space, the view uses a combination of wrapping, tightening, scaling, and truncation to make it fit. With a width of 100 points but no constraint on the height, a text view might wrap a long string: A text view always uses exactly the amount of space it needs to display its rendered contents, but you can affect the view’s layout. For example, you can use the frame(width:height:alignment:) modifier to propose specific dimensions to the view. If the view accepts the proposal but the text doesn’t fit into the available space, the view uses a combination of wrapping, tightening, scaling, and truncation to make it fit. With a width of 100 points but no constraint on the height, a text view might wrap a long string:"),
        Review(id: "1-id", rating: 2, message: "I very like it!"),
        Review(id: "3-id", rating: 5, message: nil)
    ])
}
