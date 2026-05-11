import SwiftUI

extension Color {
    enum AppColor {
        // R: 162, G: 189, B: 128
        static var primary = Color("primary")
        
        // R: 128, G: 151, B: 97
        static var primaryFocus = Color("primaryFocus")
        
        // light: R: 0, G: 0, B: 0
        // dark: R: 255, G: 255, B: 255
        static var textPrimary = Color("textPrimary")
        
        // R: 153, G: 153, B: 153
        static var textSecondary = Color("textSecondary")
        
        // R: 255, G: 255, B: 255
        static var buttonTextPrimary = Color("buttonTextPrimary")
        
        // light: R: 237, G: 237, B: 237
        // dark: R: 51, G: 51, B: 51
        static var backgroundSecondary = Color("backgroundSecondary")
        
        // light: R: 249, G: 249, B: 249
        // dark: R: 64, G:64, B: 64
        static var inactive = Color("inactive")
        
        // R: 255, G: 59, B: 48
        static var success = Color("success")
        
        // R: 52, G: 199, B: 89
        static var error = Color("error")
        
        // R: 233, G: 202, B: 93
        static var accent = Color("accent")
    }
}
