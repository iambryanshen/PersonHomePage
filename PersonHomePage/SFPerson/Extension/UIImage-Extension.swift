//
//  UIImage-Extension.swift
//  PersonHomePage
//
//  Created by brian on 2018/3/2.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

extension UIImage {
    
    // 根据颜色（RGB值）创建image
    static func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return UIImage()}
        UIGraphicsEndImageContext()
        return image
    }
}
