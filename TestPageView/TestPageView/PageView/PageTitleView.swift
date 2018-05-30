//
//  PageTitleView.swift
//  TestPageView
//
//  Created by gongsheng on 21/05/2018.
//  Copyright © 2018 gongsheng. All rights reserved.
//

import UIKit


protocol PageTitleViewDelegate : class {
    func titleView(_ titleView : PageTitleView, selectedIndex index : Int)
}

class PageTitleView: UIView {

    weak var delegate : PageTitleViewDelegate?
    
    fileprivate var titles: [String]!
    fileprivate var style: PageStyle!
    fileprivate lazy var currentIndex: Int = 0
    
    fileprivate lazy var titleLables: [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    fileprivate lazy var splitLineView: UIView = {
        let spitView = UIView()
        spitView.backgroundColor = UIColor.lightGray
        let h: CGFloat = 0.5
        spitView.frame = CGRect(x: 0, y: self.frame.height - h, width: self.frame.width, height: h)
        
        return spitView
    }()
    
    
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        
        return bottomLine
    }()
    
    fileprivate lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = 0.7
        
        return coverView
    }()
    
    
    fileprivate lazy var selectRGB : (r: CGFloat, g: CGFloat, b: CGFloat) = getRGBWithColor(self.style.selectColor)
    fileprivate lazy var  normalRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = getRGBWithColor(self.style.normalColor)
    
    init(frame: CGRect, titles: [String], style: PageStyle) {
        super.init(frame: frame)
        self.titles = titles
        self.style = style
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension PageTitleView {
    
    private func setupUI() {

        addSubview(scrollView)
        
        addSubview(splitLineView)
        
        setupTitleLabels()
        
        setupTitleLabelsPosition()
        
        if style.isShowBottomLine {
            setupBottomLine()
        }
        
        if style.isShowCover {
            setupCoverView()
        }
    }
    
    fileprivate func setupTitleLabels() {
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.tag = index
            label.text = title
            label.font = style.font
            label.textColor = index == currentIndex ? style.selectColor : style.normalColor
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLableClick(_ :)))

            label.addGestureRecognizer(tap)
            
            titleLables.append(label)
            
            scrollView.addSubview(label)
        }
    }
    
    fileprivate func setupTitleLabelsPosition() {
        
        var titleX : CGFloat = 0.0
        var titleW : CGFloat = 0.0
        let titleY : CGFloat = 0.0
        let titleH : CGFloat = frame.height
        
        let count = titles.count
        
        for (index, label) in titleLables.enumerated() {
            if style.isScrollEnable {
                let rect = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : style.font], context: nil)
                titleW = rect.width
                if index == 0 {
                    titleX = style.ttitleMargin * 0.5
                } else {
                    let preLabel = titleLables[index - 1]
                    titleX = preLabel.frame.maxX + style.ttitleMargin
                }
            } else {
                titleW = frame.width / CGFloat(count)
                titleX = titleW * CGFloat(index)
            }
//            label.backgroundColor = UIColor.randomColor()
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            
            //放大
            if index == 0 {
                let scale = style.isNeedScale ? style.scale : 1.0
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        if style.isScrollEnable {
            scrollView.contentSize = CGSize(width: titleLables.last!.frame.maxX + style.ttitleMargin, height: titleH)
        }
    }
    
    
    fileprivate func setupBottomLine() {
        scrollView.addSubview(bottomLine)
        bottomLine.frame = titleLables.first!.frame
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.frame.origin.y = scrollView.bounds.height - style.bottomLineHeight
    }
    
    fileprivate func setupCoverView() {
        scrollView.insertSubview(coverView, at: 0)
        let firstLabel = titleLables[0]
        var coverW = firstLabel.frame.width
        let coverH = style.coverH
        var coverX = firstLabel.frame.origin.x
        let coverY = (scrollView.bounds.height - coverH) * 0.5
        
        if style.isScrollEnable {
            coverX -= style.coverMargin
            coverW += style.coverMargin * 2
        }
        
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
        
    }
    
    
}

///事件处理
extension PageTitleView {
    @objc fileprivate func titleLableClick(_ tap : UITapGestureRecognizer) {
        //获取当前Label
        
        guard let currentLabel = tap.view as? UILabel else {return}
        
        if currentLabel.tag == currentIndex {return}
        
        let lastLabel = titleLables[currentIndex]
        
        lastLabel.textColor = style.normalColor
        currentLabel.textColor = style.selectColor
        
        currentIndex = currentLabel.tag
        
        delegate?.titleView(self, selectedIndex: currentIndex)
        
        contentViewDidEndScroll()
        
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.15, animations: {
                self.bottomLine.frame.origin.x = currentLabel.frame.origin.x
                self.bottomLine.frame.size.width = currentLabel.frame.width
            })
        }
        
        if style.isNeedScale {
            lastLabel.transform = CGAffineTransform.identity
            currentLabel.transform = CGAffineTransform(scaleX: style.scale, y: style.scale)
        }
        
        if style.isShowCover {
            let coverX = style.isScrollEnable ? (currentLabel.frame.origin.x - style.coverMargin) : (currentLabel.frame.origin.x)
            let coverW = style.isScrollEnable ? (currentLabel.frame.size.width + style.coverMargin * 2) : (currentLabel.frame.size.width)
            
            UIView.animate(withDuration: 0.15, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }
        
        
    }
}




extension PageTitleView {
    func contentViewDidEndScroll() {
        guard style.isScrollEnable else {return}
        
        let targetLabel = titleLables[currentIndex]
        
        var offSetX = targetLabel.center.x - bounds.width * 0.5
        
        if offSetX < 0 {
            offSetX = 0
        }
        
        
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offSetX > maxOffset {
            offSetX = maxOffset
        }
        
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
        
//        scrollView.scrollRectToVisible(<#T##rect: CGRect##CGRect#>, animated: <#T##Bool#>)
        
        
    }
}



// MARK: - 获取rgb
extension PageTitleView {
    fileprivate func getRGBWithColor(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("请使用RGB方式给title赋值颜色")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}



// MARK: - 对外暴露的方法
extension PageTitleView {
    func setTitleViewWithProgress(_ progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        let sourceLabel = titleLables[sourceIndex]
        let targetLabel = titleLables[targetIndex]
        
        let colorData = (selectRGB.0 - normalRGB.0, selectRGB.1 - normalRGB.1, selectRGB.2 - normalRGB.2)
        
        sourceLabel.textColor = UIColor(r: selectRGB.0 - colorData.0 * progress, g: selectRGB.1 - colorData.1 * progress, b: selectRGB.2 - colorData.2 * progress)
        targetLabel.textColor = UIColor(r: normalRGB.0 + colorData.0 * progress, g: normalRGB.1 + colorData.1 * progress, b: normalRGB.2 + colorData.2 * progress)
        
        currentIndex = targetIndex
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        
        let moveTotalW = targetLabel.frame.size.width - sourceLabel.frame.size.width
        
        
        
        if style.isShowBottomLine {
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress
            bottomLine.frame.size.width = sourceLabel.frame.width + moveTotalW * progress
        }
        
        if style.isNeedScale {
            let scaleData = (style.scale - 1.0) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: style.scale - scaleData, y: style.scale - scaleData)
            targetLabel.transform = CGAffineTransform(scaleX: 1 + scaleData, y: 1 + scaleData)
        }
        
        if style.isShowCover {
            coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + moveTotalW * progress) : (sourceLabel.frame.width + moveTotalW * progress)
            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + moveTotalX * progress) : (sourceLabel.frame.origin.x + moveTotalX * progress)
        }
 
    }
}











