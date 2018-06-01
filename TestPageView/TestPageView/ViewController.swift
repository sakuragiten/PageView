//
//  ViewController.swift
//  TestPageView
//
//  Created by gongsheng on 21/05/2018.
//  Copyright © 2018 gongsheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}




extension ViewController {
    fileprivate func setupUI() {
        
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64)
        
        let titles = ["beautiful", "love", "All", "Falls", "Down", "Allen", "Walker", "When it don't work", "I'll be fine"]
        
        let style = PageStyle()
        style.isScrollEnable = true
        style.isNeedScale = true
        style.isShowBottomLine = true
        style.isShowCover = true
        var childVCs = [UIViewController]()
        for i in 0..<titles.count {
            
            if i == 0 {
                let vc = TestFrostedGlassViewController()
                childVCs.append(vc)
                continue
            }
            
            if i == 3 {
                let vc = TestCollectionViewController()
                childVCs.append(vc)
                continue
            }
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVCs.append(vc)
        }
        
        let pageView = PageView(frame: pageFrame, titles: titles, style: style, childVCs: childVCs, parentController: self)
        
        view.addSubview(pageView)
        
    }
}
