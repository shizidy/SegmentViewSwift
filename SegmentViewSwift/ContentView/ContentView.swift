//
//  ContentView.swift
//  SegmentViewSwift
//
//  Created by Macmini on 2019/3/5.
//  Copyright © 2019 Macmini. All rights reserved.
//

import UIKit

@objc protocol ContentViewDelegate {
    func scrollViewBeginDragging(scrollView: UIScrollView)
    func scrollViewScroll(scrollView: UIScrollView)
    func scrollViewEndDecelerating(scrollView: UIScrollView)
}

class ContentView: BaseView {
    
    weak var contentDelegate: ContentViewDelegate?
    var tempFrame: CGRect!
    var homeVC: BaseViewController!
    
    init(frame: CGRect, viewController: BaseViewController) {
        super.init(frame: frame)
        self.tempFrame = frame
        self.homeVC = viewController
        self.backgroundColor = UIColor.white
        self.addSubview(self.scrollView)
        
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.tempFrame.width, height: self.tempFrame.height))
        scrollView.isPagingEnabled = true
        scrollView.delegate = self 
        scrollView.contentSize = CGSize.init(width: CGFloat.init(self.homeVC.children.count) * UIScreen.main.bounds.width, height: 0)
        var count = 0
        for i in 0..<self.homeVC.children.count {
            let viewController: UIViewController = self.homeVC.children[i]
            viewController.view.frame = CGRect.init(x: CGFloat.init(i)*self.tempFrame.width, y: 0, width: self.tempFrame.width, height: self.tempFrame.height)
            viewController.view.backgroundColor = UIColor.init(red: CGFloat.init(arc4random()%256)/255.0, green: CGFloat.init(arc4random()%256)/255.0, blue: CGFloat.init(arc4random()%256)/255.0, alpha: 1.0)
            scrollView.addSubview(viewController.view)
        }
        return scrollView
    }()
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: ========== UIScrollViewDelegate ==========
extension ContentView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.contentDelegate?.scrollViewBeginDragging(scrollView: scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.contentDelegate?.scrollViewScroll(scrollView: scrollView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.contentDelegate?.scrollViewEndDecelerating(scrollView: scrollView)
    }
}
