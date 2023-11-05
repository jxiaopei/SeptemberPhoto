//
//  UIScreenExtensions.swift
//  SeptemberPhoto
//
//  Created by Eric on 2023/9/21.
//

import UIKit

extension UIScreen {
    static let ScreenW = UIScreen.main.bounds.size.width
    static let ScreenH = UIScreen.main.bounds.size.height
    static let statusBarH: CGFloat = UIApplication.shared.currentWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
}
