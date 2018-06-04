//
//  PageContentView.swift
//  TestPageView
//
//  Created by gongsheng on 21/05/2018.
//  Copyright © 2018 gongsheng. All rights reserved.
//

import UIKit

@objc protocol PageContentViewDelegate : class {
    func contentView(_ contentView : PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
    
    @objc optional func contentViewEndScroll(_ contentView: PageContentView)
}


private let kContentCellIdentifier = "kContentCellID"

class PageContentView: UIView {
    
    weak var delegate : PageContentViewDelegate?
    
    fileprivate var childVCs : [UIViewController]!
    fileprivate weak var parentViewController : UIViewController!
    
    fileprivate lazy var isForbidScrollDelegate = false
    fileprivate lazy var startOffSex: CGFloat = 0
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = self.bounds.size
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.frame = self.bounds
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellIdentifier)
        collectionView.backgroundColor = UIColor.clear
        
        return collectionView
    }()
    
    
    init(frame: CGRect, childVCs: [UIViewController], parentViewController: UIViewController) {
        super.init(frame: frame)
        
        self.childVCs = childVCs
        self.parentViewController = parentViewController
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension PageContentView {
    fileprivate func setupUI() {
        for vc in childVCs {
            parentViewController.addChildViewController(vc)
        }
        
        addSubview(collectionView)
    }
}


extension PageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellIdentifier, for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childV = childVCs[indexPath.item]
        childV.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childV.view)
        
        return cell
    }

}


extension PageContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        
        startOffSex = scrollView.contentOffset.x
    }
    
    
    func  scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScrollDelegate {return}
        
        var progress : CGFloat = 0.0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        let currentOffSetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if currentOffSetX > startOffSex {
            //左滑
            progress = currentOffSetX / scrollViewW - floor(currentOffSetX / scrollViewW)
            if progress == 0 {
                progress = 1
                targetIndex = Int(currentOffSetX / scrollViewW)
                sourceIndex = targetIndex - 1;
            } else {
                sourceIndex = Int(currentOffSetX / scrollViewW)
                targetIndex = sourceIndex + 1
            }
            
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
            //如果滑出去
//            if currentOffSetX - startOffSex >= scrollViewW {
//                progress = 1
//                targetIndex = sourceIndex
//            }
        } else {
            //右滑
            progress = 1 - (currentOffSetX / scrollViewW - floor(currentOffSetX / scrollViewW))
            
            targetIndex = Int(currentOffSetX / scrollViewW)
            
            sourceIndex = targetIndex + 1
            
            if sourceIndex >=  childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
        
        
        delegate?.contentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.contentViewEndScroll?(self)
        isForbidScrollDelegate = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.contentViewEndScroll?(self)
        }
    }
    
}


// MARK: - 对外暴露的方法
extension PageContentView {
    func  setCurrentIndex(_ currentIndex: Int) {
        
        isForbidScrollDelegate = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}






















