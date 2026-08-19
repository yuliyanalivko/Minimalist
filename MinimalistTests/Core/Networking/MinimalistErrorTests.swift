import Testing
import Foundation
@testable import Minimalist

struct MinimalistErrorTests {

    @Test("Should return correct user message for basic error cases")
    func mapping_returnCorrectMessage() {
        struct MockError: Error {}
        let mapping = MinimalistError.mappingError(error: MockError())
        
        #expect(mapping.errorDescription == "We couldn't load the data. Please try again.")
    }
    
    @Test("Should return correct user message for basic error cases")
    func unknown_returnCorrectMessage() {
        let unknown = MinimalistError.unknown
        
        #expect(unknown.errorDescription == "Something went wrong. Please try again.")
    }

    @Test(
        "Should return correct message for specific network error codes", 
        arguments: [
            (URLError.Code.notConnectedToInternet, "Please check your internet connection and try again."),
            (.networkConnectionLost, "Please check your internet connection and try again."),
            (.dataNotAllowed, "Please check your internet connection and try again."),
            (.timedOut, "The request took too long. Please try again."),
            (.cannotFindHost, "We couldn't reach the server. Please try again later."),
            (.cannotConnectToHost, "We couldn't reach the server. Please try again later."),
            (.dnsLookupFailed, "We couldn't reach the server. Please try again later."),
            (.badServerResponse, "The server returned an unexpected response. Please try again later."),
            (.badURL, "The URL provided was invalid."),
            (.unsupportedURL, "The URL provided was invalid."),
            (.cancelled, "The request was cancelled.")
        ]
    )
    func networkError_returnCorrectMessage(code: URLError.Code, expectedMessage: String) {
        let error = MinimalistError.networkError(error: URLError(code))
        
        #expect(error.errorDescription == expectedMessage)
    }

    @Test("Should fall back to the default message if a network error is not a URLError")
    func networkError_withNonURLError_returnsDefaultMessage() {
        struct NonURLError: Error {}
        let error = MinimalistError.networkError(error: NonURLError())
        
        #expect(error.errorDescription == "Something went wrong. Please try again.")
    }
}
