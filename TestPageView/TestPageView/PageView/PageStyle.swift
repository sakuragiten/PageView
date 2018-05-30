//
//  PageStyle.swift
//  TestPageView
//
//  Created by gongsheng on 21/05/2018.
//  Copyright © 2018 gongsheng. All rights reserved.
//

import UIKit


class PageStyle: NSObject {
    
    //是否是滚动的title
    var isScrollEnable = false
    
    ///未选中的title颜色
    var normalColor = UIColor(r: 0, g: 0, b: 0)
    
    ///选中的title颜色
    var selectColor = UIColor(r: 255, g: 127, b: 0)
    
    ///Title字体大小
    var font = UIFont.systemFont(ofSize: 14.0)
    
    //Title字体间距
    var ttitleMargin: CGFloat = 20.0
    
    //TitleView的高度
    var titleHeight: CGFloat = 44.0
    
    ///TitleView的背景色
    var titleBgColor: UIColor = .clear
    
    ///是否显示底部滚动条
    var isShowBottomLine = false
    
    ///底部滚动条颜色
    var bottomLineColor = UIColor.orange
    
    ///底部滚动条的高度
    var bottomLineHeight: CGFloat = 2.0
    
    ///是否进行缩放
    var isNeedScale: Bool = false
    
    ///缩放比例
    var scale: CGFloat = 1.2
    
    
    
    ///遮盖
    var isShowCover : Bool = false
    
    ///遮盖的颜色
    var coverBgColor = UIColor.lightGray
    
    ///文字遮盖的间隙
    var coverMargin : CGFloat = 5.0
    
    ///遮盖的高度
    var coverH : CGFloat = 24
    
    ///遮盖的宽度
    var coverW : CGFloat = 0
    
    ///设置圆角大小
    var coverRadius : CGFloat = 12
    
    
    
    
}
