import SwiftUI

extension Font {
    enum AppFont {
        static var appName: Font {
            .system(size: 25, weight: .semibold)
        }
        
        static var headline: Font {
            .system(size: 17, weight: .semibold)
        }
        
        static var inputText: Font {
            .system(size: 16, weight: .regular)
        }
        
        static var cardTitle: Font {
            .system(size: 15, weight: .regular)
        }
        
        static var body: Font {
            .system(size: 15, weight: .regular)
        }
        
        static var caption: Font {
            .system(size: 12, weight: .regular)
        }
    }
}
