import SwiftUI
import Testing
@testable import Minimalist

@MainActor
struct ColorTests {
    
    @Test
    func primary_matchesAssets() async throws {
        let color = Color.AppColor.primary
        let colorToCompareWith = UIColor(named: "primary")!
        
        #expect(lightColorsEqual(color, colorToCompareWith), "light primary color does not match the corresponding assets color")
        #expect(darkColorsEqual(color, colorToCompareWith), "dark primary color does not match the corresponding assets color")
    }
    
    @Test
    func primary_hasExpectedRGBValues() async throws {
        var result = lightHasExpectedRGBValues(
            Color.AppColor.primary,
            rgb: (red: 162.0/255.0, green: 189.0/255.0, blue: 128.0/255.0),
        )
        
        #expect(result.isCorrect, "Light primary: RGB is incorrect  Expected (\(result.expected)), got: (\(result.result))")
        
        result = darkHasExpectedRGBValues(
            Color.AppColor.primary,
            rgb: (red: 162.0/255.0, green: 189.0/255.0, blue: 128.0/255.0),
        )
        
        #expect(result.isCorrect, "Dark primary: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
    }
    
    @Test
    func primaryFocus_matchesAssets() async throws {
        let color = Color.AppColor.primaryFocus
        let colorToCompareWith = UIColor(named: "primaryFocus")!
        
        #expect(lightColorsEqual(color, colorToCompareWith), "light primaryFocus color does not match the corresponding assets color")
        #expect(darkColorsEqual(color, colorToCompareWith), "dark primaryFocus color does not match the corresponding assets color")
    }
    
    @Test
    func primaryFocus_hasExpectedRGBValues() async throws {
        var result = lightHasExpectedRGBValues(
            Color.AppColor.primaryFocus,
            rgb: (red: 128.0/255.0, green: 151.0/255.0, blue: 97.0/255.0),
        )
        
        #expect(result.isCorrect, "Light primaryFocus: RGB is incorrect  Expected (\(result.expected)), got: (\(result.result))")
        
        result = darkHasExpectedRGBValues(
            Color.AppColor.primaryFocus,
            rgb: (red: 128.0/255.0, green: 151.0/255.0, blue: 97.0/255.0),
        )
        
        #expect(result.isCorrect, "Dark primaryFocus: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
    }
    
    @Test
    func textPrimary_matchesAssets() async throws {
        let color = Color.AppColor.textPrimary
        let colorToCompareWith = UIColor(named: "textPrimary")!
        
        #expect(lightColorsEqual(color, colorToCompareWith), "light textPrimary color does not match the corresponding assets color")
        #expect(darkColorsEqual(color, colorToCompareWith), "dark textPrimary color does not match the corresponding assets color")
    }
    
    @Test
    func textPrimary_hasExpectedRGBValues() async throws {
        var result = lightHasExpectedRGBValues(
            Color.AppColor.textPrimary,
            rgb: (red: 0, green: 0, blue: 0)
        )
        
        #expect(result.isCorrect, "Light textPrimary: RGB is incorrect. Expected \(result.expected), got: \(result.result)")
        
        result = darkHasExpectedRGBValues(
            Color.AppColor.textPrimary,
            rgb: (red: 1, green: 1, blue: 1)
        )
        
        #expect(result.isCorrect, "Dark textPrimary: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
    }
    
    @Test
    func textSecondary_matchesAssets() async throws {
        let color = Color.AppColor.textSecondary
        let colorToCompareWith = UIColor(named: "textSecondary")!
        
        #expect(lightColorsEqual(color, colorToCompareWith), "light textSecondary color does not match the corresponding assets color")
        #expect(darkColorsEqual(color, colorToCompareWith), "dark textSecondary color does not match the corresponding assets color")
    }
    
    @Test
    func textSecondary_hasExpectedRGBValues() async throws {
        var result = lightHasExpectedRGBValues(
            Color.AppColor.textSecondary,
            rgb: (red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0),
        )
        
        #expect(result.isCorrect, "Light textSecondary: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
        
        result = darkHasExpectedRGBValues(
            Color.AppColor.textSecondary,
            rgb: (red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0),
        )
        
        #expect(result.isCorrect, "Dark textSecondary: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
    }
    
    @Test
    func buttonTextPrimary_matchesAssets() async throws {
        let color = Color.AppColor.buttonTextPrimary
        let colorToCompareWith = UIColor(named: "buttonTextPrimary")!
        
        #expect(lightColorsEqual(color, colorToCompareWith), "light buttonTextPrimary color does not match the corresponding assets color")
        #expect(darkColorsEqual(color, colorToCompareWith), "dark buttonTextPrimary color does not match the corresponding assets color")
    }
    
    @Test
    func buttonTextPrimary_hasExpectedRGBValues() async throws {
        var result = lightHasExpectedRGBValues(
            Color.AppColor.buttonTextPrimary,
            rgb: (red: 1, green: 1, blue: 1),
        )
        
        #expect(result.isCorrect, "Light buttonTextPrimary: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
        
        result = darkHasExpectedRGBValues(
            Color.AppColor.buttonTextPrimary,
            rgb: (red: 1, green: 1, blue: 1),
        )
        
        #expect(result.isCorrect, "Dark buttonTextPrimary: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
        
    }
    
    @Test
    func backgroundSecondary_matchesAssets() async throws {
        let color = Color.AppColor.backgroundSecondary
        let colorToCompareWith = UIColor(named: "backgroundSecondary")!
        
        #expect(lightColorsEqual(color, colorToCompareWith), "light backgroundSecondary color does not match the corresponding assets color")
        #expect(darkColorsEqual(color, colorToCompareWith), "dark backgroundSecondary color does not match the corresponding assets color")
    }
    
    @Test
    func backgroundSecondary_hasExpectedRGBValues() async throws {
        var result = lightHasExpectedRGBValues(
            Color.AppColor.backgroundSecondary,
            rgb: (red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0),
        )
        
        #expect(result.isCorrect, "Light backgroundSecondary: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
        
        result = darkHasExpectedRGBValues(
            Color.AppColor.backgroundSecondary,
            rgb: (red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0),
        )
        
        #expect(result.isCorrect, "Dark backgroundSecondary: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
    }
    
    @Test
    func inactive_matchesAssets() async throws {
        let color = Color.AppColor.inactive
        let colorToCompareWith = UIColor(named: "inactive")!
        
        #expect(lightColorsEqual(color, colorToCompareWith), "light inactive color does not match the corresponding assets color")
        #expect(darkColorsEqual(color, colorToCompareWith), "dark inactive color does not match the corresponding assets color")
    }
    
    @Test
    func inactive_hasExpectedRGBValues() async throws {
        var result = lightHasExpectedRGBValues(
            Color.AppColor.inactive,
            rgb: (red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0),
        )
        
        #expect(result.isCorrect, "Light inactive: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
        
        result = darkHasExpectedRGBValues(
            Color.AppColor.inactive,
            rgb: (red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0),
        )
        
        #expect(result.isCorrect, "Dark inactive: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
    }
    
    @Test
    func success_matchesAssets() async throws {
        let color = Color.AppColor.success
        let colorToCompareWith = UIColor(named: "success")!
        
        #expect(lightColorsEqual(color, colorToCompareWith), "light success color does not match the corresponding assets color")
        #expect(darkColorsEqual(color, colorToCompareWith), "dark success color does not match the corresponding assets color")
    }
    
    @Test
    func success_hasExpectedRGBValues() async throws {
        var result = lightHasExpectedRGBValues(
            Color.AppColor.success,
            rgb: (red: 52.0/255.0, green: 199.0/255.0, blue: 89.0/255.0),
        )
        
        #expect(result.isCorrect, "Light success: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
        
        result = darkHasExpectedRGBValues(
            Color.AppColor.success,
            rgb: (red: 52.0/255.0, green: 199.0/255.0, blue: 89.0/255.0),
        )
        
        #expect(result.isCorrect, "Dark success: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
    }
    
    @Test
    func error_matchesAssets() async throws {
        let color = Color.AppColor.error
        let colorToCompareWith = UIColor(named: "error")!
        
        #expect(lightColorsEqual(color, colorToCompareWith), "light error color does not match the corresponding assets color")
        #expect(darkColorsEqual(color, colorToCompareWith), "dark error color does not match the corresponding assets color")
    }
    
    @Test
    func error_hasExpectedRGBValues() async throws {
        var result = lightHasExpectedRGBValues(
            Color.AppColor.error,
            rgb: (red: 1, green: 59.0/255.0, blue: 48.0/255.0),
        )
        
        #expect(result.isCorrect, "Light error: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
        
        result = darkHasExpectedRGBValues(
            Color.AppColor.error,
            rgb: (red: 1, green: 59.0/255.0, blue: 48.0/255.0),
        )
        
        #expect(result.isCorrect, "Dark error: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
    }
    
    @Test
    func accent_matchesAssets() async throws {
        let color = Color.AppColor.accent
        let colorToCompareWith = UIColor(named: "accent")!
        
        #expect(lightColorsEqual(color, colorToCompareWith), "light accent color does not match the corresponding assets color")
        #expect(darkColorsEqual(color, colorToCompareWith), "dark accent color does not match the corresponding assets color")
    }
    
    @Test
    func accent_hasExpectedRGBValues() async throws {
        var result = lightHasExpectedRGBValues(
            Color.AppColor.accent,
            rgb: (red: 233.0/255.0, green: 202.0/255.0, blue: 93.0/255.0),
        )
        
        #expect(result.isCorrect, "Light accent: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
        
        result = darkHasExpectedRGBValues(
            Color.AppColor.accent,
            rgb: (red: 233.0/255.0, green: 202.0/255.0, blue: 93.0/255.0),
        )
        
        #expect(result.isCorrect, "Dark accent: RGB is incorrect. Expected (\(result.expected)), got: (\(result.result))")
    }
    
    /** Helpers */
    
    typealias RGBResult = (
        isCorrect: Bool,
        expected: (Int, Int, Int),
        result: (Int, Int, Int)
    )
    
    enum Theme {
        case dark
        case light
        
        var uiStyle: UIUserInterfaceStyle {
            self == .dark ? UIUserInterfaceStyle.dark : UIUserInterfaceStyle.light
        }
        
        var colorScheme: ColorScheme {
            self == .dark ? ColorScheme.dark : ColorScheme.light
        }
    }
    
    private func lightColorsEqual(_ color1: Color, _ color2: UIColor) -> Bool {
        colorsEqual(color1, color2, theme: .light)
    }
    
    private func darkColorsEqual(_ color1: Color, _ color2: UIColor) -> Bool {
        colorsEqual(color1, color2, theme: .dark)
    }
    
    private func colorsEqual(_ color1: Color, _ color2: UIColor, theme: Theme) -> Bool {
        var env = EnvironmentValues()
        env.colorScheme = theme.colorScheme
        
        let resolved1 = color1.resolve(in: env)
        
        let red1 = CGFloat(resolved1.red)
        let green1 = CGFloat(resolved1.green)
        let blue1 = CGFloat(resolved1.blue)
        
        var red2: CGFloat = 0
        var green2: CGFloat = 0
        var blue2: CGFloat = 0
        var alpha2: CGFloat = 0
        
        let darkColor2 = color2.resolvedColor(with: UITraitCollection(userInterfaceStyle: theme.uiStyle))
        
        darkColor2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        return abs(red1 - red2) < 0.01 && abs(green1 - green2) < 0.01 && abs(blue1 - blue2) < 0.01
    }
    
    private func lightHasExpectedRGBValues(
        _ color: Color,
        rgb: (red: CGFloat, green: CGFloat, blue: CGFloat),
    ) -> RGBResult {
        hasExpectedRGBValues(color, rgb: rgb, theme: .light)
    }
    
    private func darkHasExpectedRGBValues(
        _ color: Color,
        rgb: (red: CGFloat, green: CGFloat, blue: CGFloat),
    ) -> RGBResult {
        hasExpectedRGBValues(color, rgb: rgb, theme: .dark)
    }
    
    private func hasExpectedRGBValues(
        _ color: Color,
        rgb: (red: CGFloat, green: CGFloat, blue: CGFloat),
        theme: ColorScheme
    ) -> RGBResult {
        var env = EnvironmentValues()
        env.colorScheme = theme
        
        let resolved = color.resolve(in: env)
        
        let red = CGFloat(resolved.red)
        let green = CGFloat(resolved.green)
        let blue = CGFloat(resolved.blue)
        
        return (
            isCorrect: abs(red - rgb.red) < 0.01 && abs(green - rgb.green) < 0.01 && abs(blue - rgb.blue) < 0.01,
            expected: (Int(rgb.red * 255), Int(rgb.green * 255), Int(rgb.blue * 255)),
            result: (Int(red * 255), Int(green * 255), Int(blue * 255))
        )
    }
}
