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
    /// 协议delegate
    weak var delegate: ContentViewDelegate?
    /// tempFrame
    var tempFrame: CGRect!
    var viewModel: HomeViewModel!
    
    
    init(frame: CGRect, delegate: ContentViewDelegate, viewModel: HomeViewModel) {
        super.init(frame: frame)
        self.tempFrame = frame
        self.viewModel = viewModel
        self.delegate = delegate
        
        self.backgroundColor = UIColor.white
        self.addSubview(self.scrollView)
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.tempFrame.width, height: self.tempFrame.height))
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        let viewController: HomeViewController = self.delegate as! HomeViewController
        scrollView.contentSize = CGSize.init(width: CGFloat.init(viewController.children.count) * UIScreen.main.bounds.width, height: 0)
        var count = 0
        for i in 0..<viewController.children.count {
            let viewController: UIViewController = viewController.children[i]
            viewController.view.frame = CGRect.init(x: CGFloat.init(i)*self.tempFrame.width, y: 0, width: self.tempFrame.width, height: self.tempFrame.height)
            viewController.view.backgroundColor = UIColor.init(red: CGFloat.init(arc4random() % 256) / 255.0, green: CGFloat.init(arc4random() % 256) / 255.0, blue: CGFloat.init(arc4random() % 256) / 255.0, alpha: 1.0)
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

//MARK: - UIScrollViewDelegate 
extension ContentView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewBeginDragging(scrollView: scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewScroll(scrollView: scrollView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewEndDecelerating(scrollView: scrollView)
    }
}
