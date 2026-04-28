import SwiftUI
import Testing
@testable import Minimalist

struct ColorTests {
    
    @Test
    func primary() async throws {
        let color = UIColor(named: "primary")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 162.0/255.0) < 0.01)
        #expect(abs(g - 189.0/255.0) < 0.01)
        #expect(abs(b - 128.0/255.0) < 0.01)
    }
    
    @Test
    func primaryFocus() async throws {
        let color = UIColor(named: "primaryFocus")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 128.0/255.0) < 0.01)
        #expect(abs(g - 151.0/255.0) < 0.01)
        #expect(abs(b - 97.0/255.0) < 0.01)
    }
    
    @Test
    func textPrimary() async throws {
        var color = UIColor(named: "textPrimary")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 0.0) < 0.01)
        #expect(abs(g - 0.0) < 0.01)
        #expect(abs(b - 0.0) < 0.01)
        
        color = UIColor(named: "textPrimary")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 255.0/255.0) < 0.01)
        #expect(abs(g - 255.0/255.0) < 0.01)
        #expect(abs(b - 255.0/255.0) < 0.01)
    }
    
    @Test
    func textSecondary() async throws {
        let color = UIColor(named: "textSecondary")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 153.0/255.0) < 0.01)
        #expect(abs(g - 153.0/255.0) < 0.01)
        #expect(abs(b - 153.0/255.0) < 0.01)
    }
    
    @Test
    func buttonTextPrimary() async throws {
        let color = UIColor(named: "buttonTextPrimary")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 255.0/255.0) < 0.01)
        #expect(abs(g - 255.0/255.0) < 0.01)
        #expect(abs(b - 255.0/255.0) < 0.01)
    }
    
    @Test
    func backgroundSecondary() async throws {
        var color = UIColor(named: "backgroundSecondary")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 237.0/255.0) < 0.01)
        #expect(abs(g - 237.0/255.0) < 0.01)
        #expect(abs(b - 237.0/255.0) < 0.01)
        
        color = UIColor(named: "backgroundSecondary")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        #expect(abs(r - 51.0/255.0) < 0.01)
        #expect(abs(g - 51.0/255.0) < 0.01)
        #expect(abs(b - 51.0/255.0) < 0.01)
    }
    
    @Test
    func inactive() async throws {
        var color = UIColor(named: "inactive")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 249.0/255.0) < 0.01)
        #expect(abs(g - 249.0/255.0) < 0.01)
        #expect(abs(b - 249.0/255.0) < 0.01)
        
        color = UIColor(named: "inactive")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        #expect(abs(r - 64.0/255.0) < 0.01)
        #expect(abs(g - 64.0/255.0) < 0.01)
        #expect(abs(b - 64.0/255.0) < 0.01)
    }
    
    @Test
    func success() async throws {
        let color = UIColor(named: "success")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 52.0/255.0) < 0.01)
        #expect(abs(g - 199.0/255.0) < 0.01)
        #expect(abs(b - 89.0/255.0) < 0.01)
    }
    
    @Test
    func error() async throws {
        let color = UIColor(named: "error")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 255.0/255.0) < 0.01)
        #expect(abs(g - 59.0/255.0) < 0.01)
        #expect(abs(b - 48.0/255.0) < 0.01)
    }
    
    @Test
    func accent() async throws {
        let color = UIColor(named: "accent")!
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        #expect(abs(r - 233.0/255.0) < 0.01)
        #expect(abs(g - 202.0/255.0) < 0.01)
        #expect(abs(b - 93.0/255.0) < 0.01)
    }
}
