//
//  SFPersonCollectionViewController.swift
//  UtoVRTips
//
//  Created by brian on 2018/2/28.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

let kHeaderViewHeight: CGFloat = 250
let kTabBarViewHeight: CGFloat = 44
let kHeaderViewMinHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 44

private let reuseIdentifier = "Cell"

// 内容VC继承该类，实现UITableView的UITableViewDataSource，UITableViewDelegate
class SFPersonTableViewController: UITableViewController {
    
    var headerViewHeightConstraint: NSLayoutConstraint!
    var navigationTitleLabel: UILabel?
    var iconImageView: UIImageView?
    var tabBarView: UIView?
    
    override func loadView() {
        let tableView = SFTableView(frame: UIScreen.main.bounds)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView = tableView
        self.view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tableView = tableView as? SFTableView {
            tableView.contentInset = UIEdgeInsets(top: kHeaderViewHeight + kTabBarViewHeight, left: 0, bottom: 0, right: 0)
            tableView.iconImageView = iconImageView
            tableView.tabBarView = tabBarView
        }
    }
}

//MARK: - UIScrollViewDelegate
extension SFPersonTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset)
        
        // 控制header背景图缩放、TabBarView跟随移动
        let offsetY: CGFloat = scrollView.contentOffset.y
        let dis = -(kHeaderViewHeight + kTabBarViewHeight) - offsetY
        var headerViewHeight = dis + kHeaderViewHeight
        if headerViewHeight < kHeaderViewMinHeight {
            headerViewHeight = kHeaderViewMinHeight
        }
        headerViewHeightConstraint.constant = headerViewHeight
        
        // 计算透明度
        let alpha = -dis / (kHeaderViewHeight - kHeaderViewMinHeight)
        
        // 设置导航栏文字透明度
        navigationTitleLabel?.textColor = UIColor(white: 0, alpha: alpha)
        
        // 设置导航栏透明度
        navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor(white: 1, alpha: alpha)), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: UIColor(white: 0.827, alpha: alpha))
    }
}
