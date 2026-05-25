import Foundation

extension URL {
    func resized(to size: Int = 500) -> URL {
        let pattern = #/(id/\d+)/\d+/\d+/#
        let originalString = self.absoluteString
        
        let resizedString = originalString.replacing(pattern) { match in
            let idPart = match.output.1
            
            return "\(idPart)/\(size)/\(size)/"
        }
        
        return URL(string: resizedString) ?? self
    }
}
