import Testing
import Foundation
@testable import Minimalist

struct NetworkRequestBuilderTests {
    
    @Test("Should construct a correct URL")
    func build_withAllStandardParameters_returnCorrectURL() throws {
        let url = try NetworkRequestBuilder.build(
            host: "https://example.com",
            servicePath: "api",
            version: .v1,
            queryItems: ["token": "abc"],
            path: "categories"
        )
        
        #expect(url.host() == "example.com")
        #expect(url.path() == "/api/v1/categories")
        #expect(url.absoluteString.contains("token=abc"))
    }
    
    @Test("Should completely bypass servicePath and version if they are nil or empty")
    func build_withOmittedOptionals_skipPathSegments() throws {
        let url = try NetworkRequestBuilder.build(
            host: "https://example.com",
            servicePath: nil,
            version: .empty,
            path: "health"
        )
        
        #expect(url.absoluteString == "https://example.com/health")
    }

    @Test(
        "Should normalize slashes regardless of trailing or leading inputs",
        arguments: [
            ("https://example.com//", "///api///", "///categories///"),
            ("https://example.com", "api", "categories")
        ]
    )
    func build_withInputSlashes_removeDoubleSlashes(host: String, servicePath: String, path: String) throws {
        let url = try NetworkRequestBuilder.build(
            host: host,
            servicePath: servicePath,
            version: .v1,
            path: path
        )
        
        #expect(url.absoluteString == "https://example.com/api/v1/categories")
    }

    @Test("Should throw a badURL custom network error if the constructed string is unparseable")
    func build_withInvalidHost_throwNetworkError() {
        let brokenHost = "   https://  unparseable host string"
        
        #expect(throws: MinimalistError.self) {
            try NetworkRequestBuilder.build(
                host: brokenHost,
                servicePath: nil,
                version: .empty,
                path: "categories"
            )
        }
    }
}
