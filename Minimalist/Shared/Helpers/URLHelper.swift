import Foundation

struct URLHelper {
    static func mapUrls<T>(of items: [T], keyPath: WritableKeyPath<T, String?>) -> [T] {
        items.map { item in
            guard let urlString = item[keyPath: keyPath],
                  let url = URL(string: urlString) else {
                return item
            }
            
            var updatedItem = item
            
            updatedItem[keyPath: keyPath] = url.resized(to: 500).absoluteString
            
            return updatedItem
        }
    }
}
