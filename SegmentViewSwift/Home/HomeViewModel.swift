//
//  HomeViewModel.swift
//  SegmentViewSwift
//
//  Created by Macmini on 2019/3/5.
//  Copyright © 2019 Macmini. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    var titleItemWidth: CGFloat = 0.0
    var titleItemNum: Int = 0
    let menuArray: NSMutableArray = NSMutableArray.init(array: [
        "菜单0",
        "菜单1",
        "菜单2",
        "菜单3",
        "菜单4",
        "菜单5",
        "菜单6",
        "菜单7",
    ])
    
    override init() {
        super.init()
        self.titleItemNum = min(KScreenItemNum, self.menuArray.count)
        self.titleItemWidth = KScreenWidth / CGFloat(self.titleItemNum)
    }
}
