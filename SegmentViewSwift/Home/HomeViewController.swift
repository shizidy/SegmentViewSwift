//
//  HomeViewController.swift
//  SegmentViewSwift
//
//  Created by Macmini on 2019/3/5.
//  Copyright © 2019 Macmini. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    var startX: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 重写父类方法
    override func setUI() {
        for i in 0..<self.viewModel.menuArray.count {
            let childVC = BaseViewController.init()
            //
            let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            label.text = self.viewModel.menuArray[i] as? String
            label.textAlignment = .center
            label.textColor = .orange
            label.backgroundColor = .white
            label.center = childVC.view.center
            //
            childVC.view.addSubview(label)
            self.addChild(childVC)
        }
        
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.contentView)
    }
    
    //MARK: - 懒加载
    lazy var viewModel: HomeViewModel = {
        var viewModel = HomeViewModel.init()
        return viewModel
    }()
    
    lazy var headerView: HeaderView = {
        let headerView = HeaderView.init(frame: CGRect.init(x: 0, y: UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: 50), delegate: self, viewModel: self.viewModel)
        //闭包回调
        headerView.headerBlock = {
            (indexPath: IndexPath) -> Void in
            print("点击了\(indexPath.item)")
        }
        return headerView
    }()
    
    lazy var contentView: ContentView = {
        let contentView = ContentView.init(frame: CGRect.init(x: 0, y: self.headerView.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.headerView.frame.maxY), delegate: self, viewModel: self.viewModel)
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
    //MARK: - ContentViewDelegate
    func scrollViewBeginDragging(scrollView: UIScrollView) {
        self.headerView.startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewScroll(scrollView: UIScrollView) {
        self.headerView.offsetX = scrollView.contentOffset.x
    }
    
    func scrollViewEndDecelerating(scrollView: UIScrollView) {
        self.headerView.offsetX = scrollView.contentOffset.x
    }
    
    
    //MARK: - HeaderViewDelegate
    func xieyi(indePath: IndexPath) {
        self.contentView.scrollView.setContentOffset(CGPoint.init(x: CGFloat.init(indePath.item)*UIScreen.main.bounds.width, y: 0), animated: false)
    }
}
