import Foundation
@testable import Minimalist

final class MockImagePrefetcher: ImagePrefetching {
    private(set) var calls: [[URL]] = []

    var lastPrefetchedURLs: [URL] {
        calls.last ?? []
    }

    func prefetch(urls: [URL]) {
        calls.append(urls)
    }
}
