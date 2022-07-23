//
//  Fonts.swift
//  MyHabbits
//
//  Created by m.khutornaya on 23.07.2022.
//

import UIKit

public extension UIFont {
    static func sfProRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Regular-1", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func sfProSemibold(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProDisplay-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
