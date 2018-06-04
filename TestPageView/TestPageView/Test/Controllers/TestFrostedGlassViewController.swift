//
//  TestFrostedGlassViewController.swift
//  TestPageView
//
//  Created by gongsheng on 2018/6/1.
//  Copyright © 2018 gongsheng. All rights reserved.
//

import UIKit
import GPUImage
class TestFrostedGlassViewController: UIViewController {
    fileprivate var imageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension TestFrostedGlassViewController {
    fileprivate func setupUI() {
        imageView = UIImageView()
        let image = UIImage(named: "test.jpg")
        imageView.image = generateBlurImage(image!)
        imageView.frame = self.view.bounds
        
        view.addSubview(imageView)
    }
    
    
    fileprivate func generateBlurImage(_ sourceImage: UIImage) -> UIImage {
        //1.创建图片处理的View
        let processView = GPUImagePicture(image: sourceImage)
        
        //2,创建滤镜
        let blurFilter = GPUImageGaussianBlurFilter()
        blurFilter.texelSpacingMultiplier = 4.5
        blurFilter.blurRadiusInPixels = 4.5
        processView?.addTarget(blurFilter)
        
        //处理图片
        blurFilter.useNextFrameForImageCapture()
        processView?.processImage()
        
        return blurFilter.imageFromCurrentFramebuffer()
    }
    
}














