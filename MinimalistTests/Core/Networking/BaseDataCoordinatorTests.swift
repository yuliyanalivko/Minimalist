import Testing
import Foundation
@testable import Minimalist

struct BaseDataCoordinatorTests {
    
    @Test("Should pass through MinimalistError without changing it")
    func convert_minimalistError_returnsSameError() {
        let coordinator = BaseDataCoordinator()
        let originalError = MinimalistError.unknown
        
        let result = coordinator.convert(error: originalError)
        
        #expect(result.isUnknown)
    }

    @Test("Should map DecodingError to MinimalistError.mappingError")
    func convert_decodingError_returnsMappingError() {
        let coordinator = BaseDataCoordinator()
        let context = DecodingError.Context(codingPath: [], debugDescription: "Test decoding failure")
        let decodingError = DecodingError.dataCorrupted(context)
        
        let result = coordinator.convert(error: decodingError)
        
        #expect(result.isMappingError)
    }

    @Test("Should map URLError to MinimalistError.networkError")
    func convert_urlError_returnsNetworkError() {
        let coordinator = BaseDataCoordinator()
        let urlError = URLError(.notConnectedToInternet)
        
        let result = coordinator.convert(error: urlError)
        
        #expect(result.isNetworkError)
    }

    @Test("Should map any unhandled generic error to MinimalistError.unknown")
    func convert_genericError_returnsUnknownError() {
        let coordinator = BaseDataCoordinator()
        struct CustomTestError: Error {}
        let genericError = CustomTestError()
        
        let result = coordinator.convert(error: genericError)
        
        #expect(result.isUnknown)
    }
}

private extension MinimalistError {
    var isNetworkError: Bool {
        if case .networkError = self { true } else { false }
    }
    
    var isMappingError: Bool {
        if case .mappingError = self { true } else { false }
    }
    
    var isUnknown: Bool {
        if case .unknown = self { true } else { false }

    }
}
