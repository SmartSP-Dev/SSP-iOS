//
//  Fonts.swift
//  StudySwiftUI
//
//  Created by 황상환 on 3/18/25.
//

import SwiftUI

extension Font {
    enum Pretend {
        case extraBold
        case bold
        case semibold
        case medium
        case regular
        case light
        
        var value: String {
            switch self {
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .bold:
                return "Pretendard-Bold"
            case .semibold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            case .light:
                return "Pretendard-Light"
            }
        }
    }
    
    static func pretend(type: Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    // MARK: - Main Text Styles
    static var PretendardExtraBold24: Font {
        return .pretend(type: .extraBold, size: 24)
    }
    
    static var PretendardBold20: Font {
        return .pretend(type: .bold, size: 20)
    }
    
    static var PretendardBold16: Font {
        return .pretend(type: .bold, size: 16)
    }
    
    static var PretendardSemiBold18: Font {
        return .pretend(type: .semibold, size: 18)
    }
    
    static var PretendardMedium16: Font {
        return .pretend(type: .medium, size: 16)
    }
    
    static var PretendardRegular13: Font {
        return .pretend(type: .regular, size: 13)
    }
    
    static var PretendardRegular09: Font {
        return .pretend(type: .regular, size: 9)
    }
    
    static var PretendardRegular18: Font {
        return .pretend(type: .regular, size: 18)
    }
    
    static var PretendardRegular12: Font {
        return .pretend(type: .regular, size: 12)
    }
    
    static var PretendardBold24: Font {
        return .pretend(type: .bold, size: 24)
    }
    
    static var PretendardSemiBold24: Font {
        return .pretend(type: .semibold, size: 24)
    }
    
    static var PretendardSemiBold16: Font {
        return .pretend(type: .semibold, size: 16)
    }
    
    static var PretendardSemiBold38: Font {
        return .pretend(type: .semibold, size: 38)
    }
    
    static var PretendardLight14: Font {
        return .pretend(type: .light, size: 14)
    }
    
    // MARK: - Button Text Styles
    static var PretendardMedium18: Font {
        return .pretend(type: .medium, size: 18)
    }
}
