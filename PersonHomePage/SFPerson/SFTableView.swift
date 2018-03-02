//
//  SFTableView.swift
//  UtoVRTips
//
//  Created by brian on 2018/2/28.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

let kClickIcon: String = "kClickIcon"
let kClickTab: String = "kClickTab"
let kClickButtonObjcKey: String = "kClickButtonObjcKey"

class SFTableView: UITableView {
    
    var iconImageView: UIImageView?
    var tabBarView: UIView?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        guard let point = touch?.location(in: self) else {
            return super.touchesBegan(touches, with: event)
        }
        
        // 处理点击了icon
        let iconPoint = self.convert(point, to: iconImageView)
        if let boolValue = iconImageView?.point(inside: iconPoint, with: event), boolValue {
            // 通知点击了icon
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kClickIcon), object: nil)
            return
        }
        
        // 处理点击tabBar上的按钮
        guard let subviews = tabBarView?.subviews else {
            return super.touchesBegan(touches, with: event)
        }
        
        for tempView in subviews {
            let tempViewPoint = self.convert(point, to: tempView)
            if tempView.point(inside: tempViewPoint, with: event) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kClickTab), object: nil, userInfo: [kClickButtonObjcKey: tempView])
            }
        }
        
        super.touchesBegan(touches, with: event)
    }
}
