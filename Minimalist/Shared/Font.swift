import SwiftUI

extension Font {
    enum AppFont {
        // Typeface: SF Pro Text, weight: semibold, size: 25
        static var appName: Font {
            .system(size: 25, weight: .semibold)
        }
        
        // Typeface: SF Pro Text, weight: semibold, size: 17
        static var headline: Font {
            .system(size: 17, weight: .semibold)
        }
        
        // Typeface: SF Pro Text, weight: regular, size: 16
        static var inputText: Font {
            .system(size: 16, weight: .regular)
        }
        
        // Typeface: SF Pro Text, weight: regular, size: 15
        static var cardTitle: Font {
            .system(size: 15, weight: .regular)
        }
        
        // Typeface: SF Pro Text, weight: regular, size: 15
        static var body: Font {
            .system(size: 15, weight: .regular)
        }
        
        // Typeface: SF Pro Text, weight: regular, size: 12
        static var caption: Font {
            .system(size: 12, weight: .regular)
        }
    }
}
