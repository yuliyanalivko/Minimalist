import Testing
import SwiftUI
@testable import Minimalist

@Suite("ItemReviewsViewModel Tests")
struct ItemReviewsViewModelTests {

    private let reviews: [Review] = [
        Review(id: "1", rating: 4, message: "Good"),
        Review(id: "2", rating: 2, message: "Bad"),
        Review(id: "3", rating: 5, message: nil)
    ]

    @Test("Should store reviews and default state")
    func init_defaultState() {
        let vm = ItemReviewsViewModel(reviews: reviews)

        #expect(vm.reviews == reviews)
        #expect(vm.selectedIndex == 0)
        #expect(vm.isFullViewOpened == false)
    }

    @Test("Should increment selectedIndex when navigating forward")
    func navigateForward_incrementsSelectedIndex() {
        let vm = ItemReviewsViewModel(reviews: reviews)

        vm.navigateForward()

        #expect(vm.selectedIndex == 1)
    }

    @Test("Should decrement selectedIndex when navigating back")
    func navigateBack_decrementsSelectedIndex() {
        let vm = ItemReviewsViewModel(reviews: reviews)
        vm.selectedIndex = 2

        vm.navigateBack()

        #expect(vm.selectedIndex == 1)
    }

    @Test("Should not navigate before first review")
    func navigateBack_clampsAtZero() {
        let vm = ItemReviewsViewModel(reviews: reviews)

        vm.navigateBack()

        #expect(vm.selectedIndex == 0)
    }

    @Test("Should not navigate past last review")
    func navigateForward_clampsAtLastIndex() {
        let vm = ItemReviewsViewModel(reviews: reviews)
        vm.selectedIndex = reviews.count - 1

        vm.navigateForward()

        #expect(vm.selectedIndex == reviews.count - 1)
    }

    @Test("Should disable previous button on first review")
    func isPrevButtonDisabled_isTrueOnFirstReview() {
        let vm = ItemReviewsViewModel(reviews: reviews)

        #expect(vm.isPrevButtonDisabled)
    }

    @Test("Should enable previous button when not on first review")
    func isPrevButtonDisabled_isFalseWhenNotOnFirstReview() {
        let vm = ItemReviewsViewModel(reviews: reviews)
        vm.selectedIndex = 1

        #expect(!vm.isPrevButtonDisabled)
    }

    @Test("Should reduce previous button opacity on first review")
    func prevButtonOpacity_isReducedOnFirstReview() {
        let vm = ItemReviewsViewModel(reviews: reviews)

        #expect(vm.prevButtonOpacity == 0.5)
    }

    @Test("Should use full opacity for previous button when not on first review")
    func prevButtonOpacity_isFullWhenNotOnFirstReview() {
        let vm = ItemReviewsViewModel(reviews: reviews)
        vm.selectedIndex = 1

        #expect(vm.prevButtonOpacity == 1)
    }

    @Test("Should disable next button on last review")
    func isNextButtonDisabled_isTrueOnLastReview() {
        let vm = ItemReviewsViewModel(reviews: reviews)
        vm.selectedIndex = reviews.count - 1

        #expect(vm.isNextButtonDisabled)
    }

    @Test("Should enable next button when not on last review")
    func isNextButtonDisabled_isFalseWhenNotOnLastReview() {
        let vm = ItemReviewsViewModel(reviews: reviews)

        #expect(!vm.isNextButtonDisabled)
    }

    @Test("Should reduce next button opacity on last review")
    func nextButtonOpacity_isReducedOnLastReview() {
        let vm = ItemReviewsViewModel(reviews: reviews)
        vm.selectedIndex = reviews.count - 1

        #expect(vm.nextButtonOpacity == 0.5)
    }

    @Test("Should use full opacity for next button when not on last review")
    func nextButtonOpacity_isFullWhenNotOnLastReview() {
        let vm = ItemReviewsViewModel(reviews: reviews)

        #expect(vm.nextButtonOpacity == 1)
    }

    @Test("Should present full review sheet on review click")
    func handleReviewClick_setsIsPresentedTrue() {
        let vm = ItemReviewsViewModel(reviews: reviews)

        vm.handleReviewClick()

        #expect(vm.isFullViewOpened)
    }

    @Test("Should disable both navigation buttons for a single review")
    func navigationButtons_areDisabledForSingleReview() {
        let vm = ItemReviewsViewModel(reviews: [
            Review(id: "only", rating: 3, message: "Only review")
        ])

        #expect(vm.isPrevButtonDisabled)
        #expect(vm.isNextButtonDisabled)
        #expect(vm.prevButtonOpacity == 0.5)
        #expect(vm.nextButtonOpacity == 0.5)
    }
}
