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
        
        test2()
    }
}



extension ViewController {
    
    func test() {
        let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        
//        let reverseNames = names.sorted(by: backward)
        
//        let reverseNames = names.sorted { (s1, s2) -> Bool in
//            return s1 > s2
//        }
        
//        let reverseNames = names.sorted(by: {
//            (s1, s2) -> Bool in
//            return s1 > s2
//        })

//        let reverseNames = names.sorted(by: {s1, s2 in return s1 > s2})
        
//        let reverseNames = names.sorted(by: {$0 > $1})
        let reverseNames = names.sorted(by: >)
        
        
        print(reverseNames)
    }
    
    func backward(_ s1: String, _ s2: String) -> Bool {
        return s1 > s2
    }
    
    
    
    func test2() {
        let numbers = [123, 65, 87, 1120]
        
        
        let digitNames = [0 : "Zero", 1 : "One", 2 : "Two", 3 : "Three", 4 : "Four",
                          5 : "Five",6 : "Six" , 7 : "Seven", 8 : "Eight", 9 : "Nine"]
        
        let stringNums = numbers.map { (number) -> String in
            var num = number
            var numStr = ""
            
            repeat {
                numStr = digitNames[num % 10]! + numStr
                num = num / 10
            } while num > 0
            
            return numStr
        }
        
        print(stringNums)
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
                let vc = TestBeautifulCameraViewController()
                childVCs.append(vc)
                continue
            }
            
            if i == 1 {
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
