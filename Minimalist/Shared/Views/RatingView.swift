import SwiftUI

struct RatingView: View {
    let rating: Double
    private let starSize: CGFloat = 17
    private let spacing: CGFloat = 4
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<5, id: \.self) { index in
                let starFill = max(0, min(1, rating - Double(index)))
                
                Image.star
                    .resizable()
                    .frame(width: starSize, height: starSize)
                    .foregroundStyle(Color.AppColor.backgroundSecondary)
                    .overlay(
                        Image.star
                            .font(.system(size: starSize))
                            .foregroundStyle(Color.AppColor.accent)
                            .mask(
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .frame(width: starFill == 1 ? nil : (starSize + spacing) * starFill)
                                    if starFill < 1 {
                                        Spacer(minLength: 0)
                                    }
                                }
                            )
                    )
            }
        }
    }
    
    private func starRow(filled: Bool) -> some View {
        HStack(spacing: spacing) {
            ForEach(0..<5, id: \.self) { _ in
                Image.star
                    .resizable()
                    .frame(width: starSize, height: starSize)
                    .foregroundStyle(filled ? Color.AppColor.accent : Color.AppColor.backgroundSecondary)
            }
        }
        .clipped()
    }
}

#Preview {
    RatingView(rating: 3.5)
}
