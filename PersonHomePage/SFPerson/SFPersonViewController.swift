//
//  SFPersonViewController.swift
//  UtoVRTips
//
//  Created by brian on 2018/2/27.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

/*
 * 遇到的最大的“坑”！！！
 * 在滚动页面时，自然想到的是通过iOS事件传递机制，让点击HeaderImageView和TabBarView时事件穿透到UITableView，让UITableView在上部分被挡住的地方也可以滑动。
 * 实际实现：
 *      首先保证上半部分（HeaderImageView，IconImageView，TabBarView）和UITableView平级，这样就不需要考虑通过事件传递机制，因为UITableView和上半部分平级，又因为上半部分把UITableView的上部分挡住了，这里我们只需要禁止上半部分的事件响应，就可以让UITableView被挡住的上部分也能响应滚动事件。
 * 如何让上半部分的icon、TabBarView上的两个button都能响应事件呢?
 *      通过自定义SFTableView，重写SFTableView的touchBegan方法，通过点在SFTableView上的点转换，当点击icon、button时通过通知实现事件响应。
 */

import UIKit

class SFPersonViewController: UIViewController {
    
    // 选中的tabBarButton
    var selectedButton: UIButton?
    // 导航栏的标题label
    var navigationTitleLabel: UILabel?
    // 子类对该属性赋值，在闭包中实现点击icon的跳转事件
    var iconClickClosure: (() -> Void)?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var headerBgImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerBgImageView.clipsToBounds = true
        
        // 同级UIView控件，如果希望点击实现位于下面的UIView控件接收事件，需要设置上面的UIView控件不接收事件
        headerContainerView.isUserInteractionEnabled = false
        tabBarView.isUserInteractionEnabled = false
        
        // 监听icon的点击
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: kClickIcon), object: nil, queue: nil) { (notification) in
            self.iconClickClosure?()
        }

        // 监听tabBarView上的button的点击
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: kClickTab), object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo as? [String: UIView] else {
                return
            }
            
            if let button = userInfo[kClickButtonObjcKey] as? UIButton {
                self.tabBarButtonClick(button: button)
            }
        }
    }
    
    /*
     * 为什么要在这里添加子控件？
     *      子控制器继承自SFPersonViewController，如果在父控制器的viewDidLoad中添加，那么子控制器无法在viewDidLoad方法中在正常super.viewDidLoad执行后对属性进行这里。为了让子控制器尽可能“正常”一点，所以这里只好再viewWillAppear中添加子控件。
     * 因为viewWillAppear在每次页面显示的时候都会调用，为了防止重复添加，这里扩展了DispatchQueue实现一次性代码（swift3.0后GCD废弃了一次性代码）
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.once("com.utovr.www") {
            self.setupNavigationBar()
            self.setupChildVC()
            self.setupTabBar()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //布局tabBarView上的button
        let count = tabBarView.subviews.count
        var buttonX : CGFloat = 0
        let buttonY : CGFloat = 0
        let buttonW : CGFloat = tabBarView.bounds.width / CGFloat(count)
        let buttonH : CGFloat = tabBarView.bounds.height
        
        for index in 0..<count {
            buttonX = CGFloat(index) * buttonW
            tabBarView.subviews[index].frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
        }
    }
    
    // 这里务必实现自定义构造方法，否则SFPersonViewController不会从Xib加载
    convenience init() {
        self.init(nibName: "SFPersonViewController", bundle: nil)
    }
}

extension SFPersonViewController {
    
    func setupNavigationBar() {
        
        // 设置导航栏背景图透明
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // 设置导航栏标题
        let label = UILabel()
        navigationTitleLabel = label
        label.text = "UtoVR"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.sizeToFit()
        navigationItem.titleView = label
    }
    
    func setupChildVC() {
        for childVC in self.childViewControllers {
            if let peronTableVC = childVC as? SFPersonTableViewController {
                peronTableVC.headerViewHeightConstraint = headerViewHeightConstraint
                peronTableVC.navigationTitleLabel = navigationTitleLabel
                peronTableVC.iconImageView = iconImageView
                peronTableVC.tabBarView = tabBarView
            }
        }
    }
    
    func setupTabBar() {
        for childVC in self.childViewControllers {
            let button = UIButton(type: .custom)
            button.tag = tabBarView.subviews.count
            button.setTitle(childVC.title, for: .normal)
            button.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            button.setTitleColor(UIColor.black, for: UIControlState.selected)
            button.addTarget(self, action: #selector(tabBarButtonClick), for: .touchUpInside)
            if button.tag == 0 {
                tabBarButtonClick(button: button)
            }
            tabBarView.addSubview(button)
        }
    }
}

extension SFPersonViewController {
    
    @objc func tabBarButtonClick(button: UIButton) {
        
        // 如果是已经点过，直接返回
        if button == selectedButton {
            return
        }
        
        // 如果已经点过tabBarView上的button，移除正在显示的view
        var tempPreviousTableView : SFTableView?
        if let selectedButton = selectedButton,
            let previousTableView = self.childViewControllers[selectedButton.tag].view as? SFTableView {
            previousTableView.removeFromSuperview()
            tempPreviousTableView = previousTableView
        }
        
        // 添加选中的view
        if let currentTableView = self.childViewControllers[button.tag].view as? SFTableView {
            contentView.addSubview(currentTableView)
            if let tempPreviousTableView = tempPreviousTableView {
                if tempPreviousTableView.contentOffset.y > -(kHeaderViewMinHeight + kTabBarViewHeight) {
                    print(kHeaderViewHeight - kHeaderViewMinHeight)
                    currentTableView.contentOffset.y = currentTableView.contentOffset.y + (kHeaderViewHeight - kHeaderViewMinHeight)
                } else if tempPreviousTableView.contentOffset.y < -(kHeaderViewMinHeight + kTabBarViewHeight) && tempPreviousTableView.contentOffset.y > -(kHeaderViewHeight + kTabBarViewHeight) {
                    currentTableView.contentOffset.y = currentTableView.contentOffset.y + (tempPreviousTableView.contentOffset.y + (kHeaderViewHeight + kTabBarViewHeight))
                }
            }
        }
        
        // 调整按钮的状态
        selectedButton?.isSelected = false
        button.isSelected = true
        selectedButton = button
    }
}
