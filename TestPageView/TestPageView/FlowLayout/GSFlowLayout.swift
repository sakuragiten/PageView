//
//  GSFlowLayout.swift
//  TestPageView
//
//  Created by gongsheng on 2018/5/31.
//  Copyright © 2018 gongsheng. All rights reserved.
//

import UIKit

protocol GSFlowLayoutDataSource : class{
    func numberOfCols(_ waterfall: GSFlowLayout) -> Int
    func waterFall(_ waterfall: GSFlowLayout, item: Int) -> CGFloat
}

class GSFlowLayout: UICollectionViewFlowLayout {
    
    weak var dataSource: GSFlowLayoutDataSource?
    
    fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    fileprivate lazy var cols: Int = {
        return self.dataSource?.numberOfCols(self) ?? 2
    }()
    
    fileprivate lazy var totalHeigts : [CGFloat] = Array.init(repeating: self.sectionInset.top, count: self.cols)
    
}


extension GSFlowLayout {
    override func prepare() {
         super.prepare()
        
        //1.获取cell的个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        //2、给每一个cell创建一个UICollectionViewLayoutAttributes
        let cellW : CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        
        for i in cellAttrs.count..<itemCount {
            // 根据i创建indexPath
            let indexPath = IndexPath(item: i, section: 0)
            
            //2 根据indexPath 创建对应的UICollectionViewLayoutAttributes
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            //3 设置attr中的frame
            guard let cellH: CGFloat = dataSource?.waterFall(self, item: i) else {
                fatalError("请实现对应的数据源方法, 并方慧Cell高度")
            }
            let minH = totalHeigts.min()!
            let minIndex = totalHeigts.index(of: minH)!
            let cellX: CGFloat = sectionInset.left + (minimumInteritemSpacing + cellW) * CGFloat(minIndex)
            let cellY: CGFloat = minH
            attr.frame = CGRect(x: cellX, y: cellY, width: cellW, height: cellH)
            //保存
            cellAttrs.append(attr)
            
            totalHeigts[minIndex] = minH + minimumLineSpacing + cellH
            
        }
    }
}

extension GSFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}

extension GSFlowLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: totalHeigts.max()! + sectionInset.bottom - minimumLineSpacing)
    }
}









