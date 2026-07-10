import Testing
import Foundation
@testable import Minimalist

struct URLRequestTests {
    
    let testURL = URL(string: "https://example.com")!

    @Test(
        "Should correctly configure basic properties and Accept header when body is omitted",
        arguments: [HTTPRequestMethod.get, .delete]
    )
    func init_withoutBody_configureBasicRequest(method: HTTPRequestMethod) {
        let request = URLRequest(url: testURL, method: method)
        
        #expect(request.url == testURL)
        #expect(request.httpMethod == method.rawValue)
        #expect(request.httpBody == nil)
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == nil)
    }

    @Test("Should attach body and include Content-Type header when body data is provided")
    func init_withBody_attachPayloadAndHeaders() {
        let payload = mockCategories.data(using: .utf8)!
        
        let request = URLRequest(url: testURL, method: .put, body: payload)
        
        #expect(request.url == testURL)
        #expect(request.httpMethod == HTTPRequestMethod.put.rawValue)
        #expect(request.httpBody == payload)
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }
}
