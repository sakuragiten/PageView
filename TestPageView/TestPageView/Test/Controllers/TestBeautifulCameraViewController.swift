//
//  TestBeautifulCameraViewController.swift
//  TestPageView
//
//  Created by gongsheng on 2018/6/4.
//  Copyright © 2018 gongsheng. All rights reserved.
//

import UIKit
import GPUImage
class TestBeautifulCameraViewController: UIViewController {
    
    fileprivate var imageView : UIImageView!
    fileprivate var stilCamera: GPUImageStillCamera!
    fileprivate var filter: GPUImageBrightnessFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        
        //创建相机
        stilCamera = GPUImageStillCamera(sessionPreset: AVCaptureSession.Preset.vga640x480.rawValue, cameraPosition: .front)
        stilCamera?.outputImageOrientation = .portrait
        
        //创建滤镜
        filter = GPUImageBrightnessFilter()
        filter.brightness = 0.3
        stilCamera?.addTarget(filter)
        
        //创建显示实时画面的View
        let showView = GPUImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.height))
        view.insertSubview(showView, at: 0)
        filter.addTarget(showView)
        
        //默认进来就开始拍摄
//        stilCamera?.startCapture()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension TestBeautifulCameraViewController {
    fileprivate func setupUI() {
        
        imageView = UIImageView()
        imageView.frame = self.view.bounds
        view.addSubview(imageView)
        
        
        let rotateBtn = UIButton(type: .custom)
        rotateBtn.frame = CGRect(x: 50, y: 30, width: 80, height: 30)
        rotateBtn.backgroundColor = UIColor.randomColor()
        rotateBtn.addTarget(self, action: #selector(rotateAction(_ :)), for: .touchUpInside)
        rotateBtn.titleLabel?.textColor = UIColor.white
        rotateBtn.setTitle("Rotate", for: .normal)
        view.addSubview(rotateBtn)
        
        
        let startBtn = UIButton(type: .custom)
        startBtn.frame = CGRect(x: 50, y: 90, width: 80, height: 30)
        startBtn.backgroundColor = UIColor.randomColor()
        startBtn.addTarget(self, action: #selector(startAction(_ :)), for: .touchUpInside)
        startBtn.titleLabel?.textColor = UIColor.white
        startBtn.setTitle("Start", for: .normal)
        view.addSubview(startBtn)
        
        let stopBtn = UIButton(type: .custom)
        stopBtn.frame = CGRect(x: 50, y: 150, width: 80, height: 30)
        stopBtn.backgroundColor = UIColor.randomColor()
        stopBtn.addTarget(self, action: #selector(stopAction(_ :)), for: .touchUpInside)
        stopBtn.titleLabel?.textColor = UIColor.white
        stopBtn.setTitle("Stop", for: .normal)
        view.addSubview(stopBtn)
        
    }
}


extension TestBeautifulCameraViewController {
    @objc fileprivate func rotateAction(_ sender: UIButton) {
        stilCamera.rotateCamera()
    }
    
    @objc fileprivate func startAction(_ sender: UIButton) {
        self.stilCamera.startCapture()
    }
    
    @objc fileprivate func stopAction(_ sender: UIButton) {
//        stilCamera.capturePhotoAsImageProcessedUp(toFilter: filter, withCompletionHandler: {
//            (image: UIImage?, error: Error?) in
//            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
//            self.stilCamera.stopCapture()
//        })
        self.stilCamera.removeInputsAndOutputs()
    }
    
}
