import SwiftUI
import Testing
@testable import Minimalist

struct ColorTests {
    
    @Test
    func primary_hasExpectedRGBValues() async throws {
        let color = UIColor(named: "primary")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 162.0/255.0) < 0.01, "primary red component is incorrect")
        #expect(abs(g - 189.0/255.0) < 0.01, "primary green component is incorrect")
        #expect(abs(b - 128.0/255.0) < 0.01, "primary blue component is incorrect")
    }
    
    @Test
    func primaryFocus_hasExpectedRGBValues() async throws {
        let color = UIColor(named: "primaryFocus")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 128.0/255.0) < 0.01, "primaryFocus red component is incorrect")
        #expect(abs(g - 151.0/255.0) < 0.01, "primaryFocus green component is incorrect")
        #expect(abs(b - 97.0/255.0) < 0.01, "primaryFocus blue component is incorrect")
    }
    
    @Test
    func textPrimary_hasExpectedRGBValues() async throws {
        var color = UIColor(named: "textPrimary")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 0.0) < 0.01, "Light textPrimary red component is incorrect")
        #expect(abs(g - 0.0) < 0.01, "Light textPrimary green component is incorrect")
        #expect(abs(b - 0.0) < 0.01, "Light textPrimary blue component is incorrect")
        
        color = UIColor(named: "textPrimary")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 255.0/255.0) < 0.01, "Dark textPrimary red component is incorrect")
        #expect(abs(g - 255.0/255.0) < 0.01, "Dark textPrimary green component is incorrect")
        #expect(abs(b - 255.0/255.0) < 0.01, "Dark textPrimary blue component is incorrect")
    }
    
    @Test
    func textSecondary_hasExpectedRGBValues() async throws {
        let color = UIColor(named: "textSecondary")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 153.0/255.0) < 0.01, "textSecondary red component is incorrect")
        #expect(abs(g - 153.0/255.0) < 0.01, "textSecondary green component is incorrect")
        #expect(abs(b - 153.0/255.0) < 0.01, "textSecondary blue component is incorrect")
    }
    
    @Test
    func buttonTextPrimary_hasExpectedRGBValues() async throws {
        let color = UIColor(named: "buttonTextPrimary")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 255.0/255.0) < 0.01, "buttonTextPrimary red component is incorrect")
        #expect(abs(g - 255.0/255.0) < 0.01, "buttonTextPrimary green component is incorrect")
        #expect(abs(b - 255.0/255.0) < 0.01, "buttonTextPrimary blue component is incorrect")
    }
    
    @Test
    func backgroundSecondary_hasExpectedRGBValues() async throws {
        var color = UIColor(named: "backgroundSecondary")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 237.0/255.0) < 0.01, "Light backgroundSecondary red component is incorrect")
        #expect(abs(g - 237.0/255.0) < 0.01, "Light backgroundSecondary green component is incorrect")
        #expect(abs(b - 237.0/255.0) < 0.01, "Light backgroundSecondary blue component is incorrect")
        
        color = UIColor(named: "backgroundSecondary")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        #expect(abs(r - 51.0/255.0) < 0.01, "Dark backgroundSecondary red component is incorrect")
        #expect(abs(g - 51.0/255.0) < 0.01, "Dark backgroundSecondary green component is incorrect")
        #expect(abs(b - 51.0/255.0) < 0.01, "Dark backgroundSecondary blue component is incorrect")
    }
    
    @Test
    func inactive_hasExpectedRGBValues() async throws {
        var color = UIColor(named: "inactive")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 249.0/255.0) < 0.01, "Light inactive red component is incorrect")
        #expect(abs(g - 249.0/255.0) < 0.01, "Light inactive green component is incorrect")
        #expect(abs(b - 249.0/255.0) < 0.01, "Light inactive blue component is incorrect")
        
        color = UIColor(named: "inactive")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        #expect(abs(r - 64.0/255.0) < 0.01, "Dark inactive red component is incorrect")
        #expect(abs(g - 64.0/255.0) < 0.01, "Dark inactive green component is incorrect")
        #expect(abs(b - 64.0/255.0) < 0.01, "Dark inactive blue component is incorrect")
    }
    
    @Test
    func success_hasExpectedRGBValues() async throws {
        let color = UIColor(named: "success")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 52.0/255.0) < 0.01, "success red component is incorrect")
        #expect(abs(g - 199.0/255.0) < 0.01, "success green component is incorrect")
        #expect(abs(b - 89.0/255.0) < 0.01, "success blue component is incorrect")
    }
    
    @Test
    func error_hasExpectedRGBValues() async throws {
        let color = UIColor(named: "error")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 255.0/255.0) < 0.01, "error red component is incorrect")
        #expect(abs(g - 59.0/255.0) < 0.01, "error green component is incorrect")
        #expect(abs(b - 48.0/255.0) < 0.01, "error blue component is incorrect")
    }
    
    @Test
    func accent_hasExpectedRGBValues() async throws {
        let color = UIColor(named: "accent")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 233.0/255.0) < 0.01, "accent red component is incorrect")
        #expect(abs(g - 202.0/255.0) < 0.01, "accent green component is incorrect")
        #expect(abs(b - 93.0/255.0) < 0.01, "accent blue component is incorrect")
    }
}
