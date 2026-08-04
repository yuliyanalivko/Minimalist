import SwiftUI

enum AppIcon: String {
    case heart = "heart.fill"
    case sort = "arrow.up.arrow.down"
    case filter = "line.3.horizontal.decrease"
    case photo = "photo"
    case star = "star.fill"
    case magnifyingGlass = "exclamationmark.magnifyingglass"
    case cart = "cart.fill"
    case arrowLeft = "chevron.left"
    case arrowRight = "chevron.right"
    case internaldrive = "internaldrive"
    case hammer = "hammer"
}

extension Image {
    static var heart: Image {
        Image(systemName: AppIcon.heart.rawValue)
    }
    
    static var sort: Image {
        Image(systemName: AppIcon.sort.rawValue)
    }
    
    static var filter: Image {
        Image(systemName: AppIcon.filter.rawValue)
    }
    
    static var photo: Image {
        Image(systemName: AppIcon.photo.rawValue)
    }
    
    static var star: Image {
        Image(systemName: AppIcon.star.rawValue)
    }
    
    static var magnifyingGlass: Image {
        Image(systemName: AppIcon.magnifyingGlass.rawValue)
    }
    
    static var cart: Image {
        Image(systemName: AppIcon.cart.rawValue)
    }
    
    static var previous: Image {
        Image(systemName: AppIcon.arrowLeft.rawValue)
    }
    
    static var next: Image {
        Image(systemName: AppIcon.arrowRight.rawValue)
    }
    
    static var internaldrive: Image {
        Image(systemName: AppIcon.internaldrive.rawValue)
    }
    
    static var hammer: Image {
        Image(systemName: AppIcon.hammer.rawValue)
    }
}
