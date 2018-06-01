//
//  PageView.swift
//  TestPageView
//
//  Created by gongsheng on 21/05/2018.
//  Copyright © 2018 gongsheng. All rights reserved.
//

import UIKit

class PageView: UIView {
    
    
    fileprivate var titles: [String]!
    fileprivate var childVCs: [UIViewController]!
    fileprivate weak var parentVC: UIViewController!
    fileprivate var style: PageStyle!
    
    fileprivate var titleView: PageTitleView!
    
    fileprivate var contentView : PageContentView!
    
    
    init(frame: CGRect, titles: [String], style: PageStyle, childVCs: [UIViewController], parentController: UIViewController) {
        super.init(frame: frame)
        
        self.style = style
        self.titles = titles
        self.childVCs = childVCs
        self.parentVC = parentController
        
        parentController.automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension PageView {
    fileprivate func setupUI() {
//        self.backgroundColor = UIColor.randomColor()
        
        let titleH = style.titleHeight
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        
        titleView = PageTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.delegate = self
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView  = PageContentView(frame: contentFrame, childVCs: childVCs, parentViewController: parentVC)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.delegate = self
        addSubview(contentView)
        
    }
}

extension PageView : PageTitleViewDelegate {
    func titleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}


extension PageView : PageContentViewDelegate {
    func contentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleViewWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: PageContentView) {
        titleView.contentViewDidEndScroll()
    }
}











