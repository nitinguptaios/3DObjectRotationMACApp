//
//  UIColor+NamedColor.swift
//  ChatApp
//
//  Created by iPHTech36 on 21/04/22.
//

import Cocoa

enum NamedColor: String, CaseIterable {

    case backgroundColor

    var uiColor: NSColor {
        let bundle = Bundle.main
        guard let color = NSColor(named: self.rawValue, bundle: bundle) else {
            preconditionFailure("Named color {\(self.rawValue)} not included in bundle")
        }
        return color
    }
}

public extension NSColor {

    static var backgroundColor: NSColor {
        NamedColor.backgroundColor.uiColor
    }

}

extension NSColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let constA, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (constA, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (constA, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (constA, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (constA, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(constA) / 255)
    }
}
