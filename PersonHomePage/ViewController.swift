//
//  ViewController.swift
//  PersonHomePage
//
//  Created by brian on 2018/3/2.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

class ViewController: SFPersonViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerBgImageView.image = UIImage(named: "KobeBryant")
        self.iconImageView.image = UIImage(named: "PaulWalker")
        self.iconClickClosure = {
            print("点击头像跳转")
        }
        addChildVC()
    }
}

extension ViewController {
    func addChildVC()  {
        
        let oneVC = OneViewController()
        oneVC.title = "One"
        self.addChildViewController(oneVC)
        
        let twoVC = TwoViewController()
        twoVC.title = "two"
        self.addChildViewController(twoVC)
    }
}
