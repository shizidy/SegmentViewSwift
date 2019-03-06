//
//  HomeViewController.swift
//  SegmentViewSwift
//
//  Created by Macmini on 2019/3/5.
//  Copyright © 2019 Macmini. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    //MARK: ========== 重写父类方法 ==========
    override func setUI() {
        for _ in 0..<self.homeViewModel.menuArr.count {
            let baseVC = BaseViewController.init()
            self.addChild(baseVC)
        }
        
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.contentView)
    }
    
    //MARK: ========== 懒加载 ==========
    lazy var homeViewModel: HomeViewModel = {
        var homeViewModel = HomeViewModel.init()
        return homeViewModel
    }()
    
    lazy var headerView: HeaderView = {
        let headerView = HeaderView.init(frame: CGRect.init(x: 0, y: UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: 50), menuArray: self.homeViewModel.menuArr)
        headerView.headerDelegate = self
        //闭包回调
        headerView.headerBlock = {
            (indexPath: IndexPath) -> Void in
            print("点击了\(indexPath.item)")
        }
        return headerView
    }()
    
    lazy var contentView: ContentView = {
        let contentView = ContentView.init(frame: CGRect.init(x: 0, y: self.headerView.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.headerView.frame.maxY), viewController: self)
        contentView.contentDelegate = self
        return contentView
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: HeaderViewDelegate, ContentViewDelegate {
    
    func scrollViewBeginDragging(scrollView: UIScrollView) {
        self.headerView.startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewScroll(scrollView: UIScrollView) {
        self.headerView.offsetX = scrollView.contentOffset.x
    }
    
    func scrollViewEndDecelerating(scrollView: UIScrollView) {
        self.headerView.offsetX = scrollView.contentOffset.x
    }
    
    
    //MARK: ========== HeaderViewDelegate ==========
    func xieyi(indePath: IndexPath) {
        print(indePath.item)
        self.contentView.scrollView.setContentOffset(CGPoint.init(x: CGFloat.init(indePath.item)*UIScreen.main.bounds.width, y: 0), animated: false)
    }
}
