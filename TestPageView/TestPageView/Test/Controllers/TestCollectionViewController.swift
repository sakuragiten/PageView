//
//  TestCollectionViewController.swift
//  TestPageView
//
//  Created by gongsheng on 2018/5/31.
//  Copyright © 2018 gongsheng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TestCollectionViewController: UIViewController {

    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = GSFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10.0
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return collectionView
        
    }()
    
    fileprivate lazy var cellCount:Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        
        view.addSubview(collectionView)
        
    }
}

extension TestCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        
        if indexPath.item == cellCount - 1 {
            cellCount += 30
            collectionView.reloadData()
        }
        return cell
    }
}

extension TestCollectionViewController: GSFlowLayoutDataSource {
    func numberOfCols(_ waterfall: GSFlowLayout) -> Int {
        return 3
    }
    
    func waterFall(_ waterfall: GSFlowLayout, item: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(150) + 100)
    }
}





