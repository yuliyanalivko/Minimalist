import SwiftUI

struct FullReviewView: View {
    let review: Review
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                RatingView(rating: Double(review.rating))
                
                Text(review.message ?? "")
                    .lineSpacing(6)
                    .padding(.top)
            }
            .defaultHorizontalScreenPadding()
        }
    }
}

#Preview {
    FullReviewView(review: Review(id: "2-id", rating: 4, message: "A text view always uses exactly the amount of space it needs to display its rendered contents, but you can affect the view’s layout. For example, you can use the frame(width:height:alignment:) modifier to propose specific dimensions to the view. If the view accepts the proposal but the text doesn’t fit into the available space, the view uses a combination of wrapping, tightening, scaling, and truncation to make it fit. With a width of 100 points but no constraint on the height, a text view might wrap a long string:"))
}
