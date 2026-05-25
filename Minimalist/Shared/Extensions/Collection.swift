import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    func filtered(by searchText: String, key: KeyPath<Element, String>) -> [Element] {
        let cleanSearchText = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        
        if cleanSearchText.isEmpty {
            return Array(self)
        }
        
        return self.filter { $0[keyPath: key].lowercased().contains(cleanSearchText) }
    }
}
