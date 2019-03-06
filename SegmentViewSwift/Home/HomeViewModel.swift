//
//  HomeViewModel.swift
//  SegmentViewSwift
//
//  Created by Macmini on 2019/3/5.
//  Copyright © 2019 Macmini. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    override init() {
        super.init()
    }
    //MARK: ========== 懒加载 ==========
    lazy var menuArr: NSMutableArray = {
        let menuArr = NSMutableArray.init(array: ["菜单1", "菜单2", "菜单3", "菜单4", "菜单5", "菜单6"])
        return menuArr
    }()
}
