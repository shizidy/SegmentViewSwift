//
//  HeaderView.swift
//  SegmentViewSwift
//
//  Created by Macmini on 2019/3/5.
//  Copyright © 2019 Macmini. All rights reserved.
//

import UIKit

//MARK: - 闭包（相当于OC的block）
typealias bibao = (_ indexPath: IndexPath) -> Void

//MARK: - 协议
@objc protocol HeaderViewDelegate {
    func xieyi(indePath: IndexPath)
//    func <#name#>(parameters) -> Void
}

class HeaderView: BaseView {
    
    var headerBlock: bibao?  // 闭包（相当于OC的block）
    weak var delegate: HeaderViewDelegate?  // 协议
    private var tempFrame: CGRect!
    private var tempMenuArr: NSMutableArray!
    private var fontArr: NSMutableArray = NSMutableArray.init()
    private var itemWidth: CGFloat = 0.0
    private var viewModel: HomeViewModel!
        
    var startOffsetX: CGFloat = 0.0 {//记录contentView的scrollView的cntentOffset.x
        willSet {
            
        }
        didSet {
            
        }
    }
    var offsetX: CGFloat = 0.0 {//记录contentView的scrollView的cntentOffset.x
        willSet {
        }
        didSet {
            //滑标
            self.slideView.frame = CGRect.init(x: self.offsetX / CGFloat(self.viewModel.titleItemNum), y: self.slideView.frame.origin.y, width: self.slideView.frame.width, height: self.slideView.frame.height)
            //字体
            let index = NSInteger(self.offsetX / self.tempFrame.width)
            let rate = (self.offsetX - CGFloat(index) * self.tempFrame.width) / self.tempFrame.width / 4
            if self.startOffsetX < self.offsetX {//向右
                if index == self.tempMenuArr.count - 1 {
                    self.fontArr.replaceObject(at: index, with: 0.25 + 1 - rate)
                } else {
                    self.fontArr.replaceObject(at: index + 1, with: rate + 1)
                    self.fontArr.replaceObject(at: index, with: 0.25 + 1 - rate)
                }
            }
            if self.startOffsetX > self.offsetX {//向左
                if self.offsetX < 0 {
                    self.fontArr.replaceObject(at: index, with: 0.25 + 1 + rate)
                } else {
                    self.fontArr.replaceObject(at: index + 1, with: rate + 1)
                    self.fontArr.replaceObject(at: index, with: 0.25 + 1 - rate)
                }
            }
            self.collectionView.reloadData()
            
            self.setCollectionViewContentOffsetWithCollectionView(collectionView: self.collectionView, index: index)
        }
    }
    
    /// 构造方法
    /// - Parameters:
    ///   - frame: frame
    ///   - delegate: 协议delegate
    ///   - viewModel: 数据model
    init(frame: CGRect, delegate: HeaderViewDelegate, viewModel: HomeViewModel) {
        super.init(frame: frame)
        self.tempFrame = frame
        self.tempMenuArr = viewModel.menuArray
        self.delegate = delegate
        self.viewModel = viewModel
        
        if self.tempMenuArr.count < self.viewModel.titleItemNum {
            self.itemWidth = self.tempFrame.width / CGFloat(self.tempMenuArr.count)
        } else {
            self.itemWidth = self.tempFrame.width / CGFloat(self.viewModel.titleItemNum)
        }
        for i in 0..<self.tempMenuArr.count {
            switch i {
            case 0:
                self.fontArr.add(1.0 + 0.25)
            default:
                self.fontArr.add(1.0)
            }
        }
        self.backgroundColor = UIColor.white
        self.addSubview(self.collectionView)
        self.collectionView.addSubview(self.slideView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - collectionView contentOffset动画
    func setCollectionViewContentOffsetWithCollectionView(collectionView: UICollectionView, index: NSInteger) -> Void {
        if index <= NSInteger(self.viewModel.titleItemNum / 2) {
            collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
        
        if index > NSInteger(self.viewModel.titleItemNum / 2) && index < self.tempMenuArr.count - NSInteger(self.viewModel.titleItemNum / 2) {
            collectionView.setContentOffset(CGPoint.init(x: CGFloat(index - NSInteger(self.viewModel.titleItemNum / 2)) * self.itemWidth, y: 0), animated: true)
        }
        
        if index >= self.tempMenuArr.count - NSInteger(self.viewModel.titleItemNum / 2) {
            collectionView.setContentOffset(CGPoint.init(x: self.collectionView.contentSize.width - self.tempFrame.width, y: 0), animated: true)
        }
    }
    
    //MARK: ========== 懒加载 ==========
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.tempFrame.width, height: self.tempFrame.height), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.orange
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    lazy var slideView: UIView = {
        let slideView = UIView.init(frame: CGRect.init(x: 0, y: self.tempFrame.height - 4, width: self.itemWidth, height: 4))
        slideView.backgroundColor = UIColor.white
        return slideView
    }()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension HeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: ========== UICollectionViewDataSource ==========
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tempMenuArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath)
        for i in 0..<cell.contentView.subviews.count {
            let childView: UIView = cell.contentView.subviews[i]
            if childView is UILabel {
                childView.removeFromSuperview()
            }
        }
        let menuLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: cell.contentView.frame.width, height: cell.contentView.frame.height))
        cell.contentView.addSubview(menuLabel)
        menuLabel.text = self.tempMenuArr.object(at: indexPath.item) as? String
        menuLabel.textAlignment = .center
        menuLabel.textColor = UIColor.white
        let fontSize = self.fontArr[indexPath.item]
        menuLabel.font = UIFont.systemFont(ofSize: 16.0)
        menuLabel.transform = CGAffineTransform.init(scaleX: fontSize as! CGFloat, y: fontSize as! CGFloat)
        return cell
    }
    
    //MARK: ========== UICollectionViewDelegate ==========
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.itemWidth, height: self.tempFrame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.slideView.frame.minX == CGFloat(indexPath.item) * self.itemWidth  {
            return
        }
        
        self.delegate?.xieyi(indePath: indexPath)
        self.headerBlock!(indexPath)
        
        //MARK: - collectionView动画
        self.setCollectionViewContentOffsetWithCollectionView(collectionView: self.collectionView, index: indexPath.item)
        
        //MARK: - slide动画 
        UIView.animate(withDuration: 0.2) {
            self.slideView.frame = CGRect.init(x: CGFloat(indexPath.item) * self.itemWidth, y: self.slideView.frame.origin.y, width: self.slideView.frame.width, height: self.slideView.frame.height)
//            self.slideView.transform = CGAffineTransform.init(translationX: CGFloat(indexPath.item)*self.itemWidth, y: 0)
        }
        
        for i in 0..<self.tempMenuArr.count {
            switch i  {
            case indexPath.item:
                self.fontArr.replaceObject(at: i, with: 1.0 + 0.25)
            default:
                self.fontArr.replaceObject(at: i, with: 1.0)
            }
        }
        self.collectionView.reloadData()
    }
    
}
