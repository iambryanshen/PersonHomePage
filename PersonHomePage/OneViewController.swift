//
//  OneViewController.swift
//  PersonHomePage
//
//  Created by brian on 2018/3/2.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

import UIKit

class OneViewController: SFPersonTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "kOneCell")
    }
}

extension OneViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kOneCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)行"
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
}
