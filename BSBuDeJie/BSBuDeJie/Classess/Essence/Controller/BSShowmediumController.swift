//
//  BSShowmediumController.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/23.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import Photos
class BSShowmediumController: UIViewController {
    //MARK: - 系统方法
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        //显示大图
        showImage()
        //初始化设置
        setting()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let he = CGFloat(Float(model!.height!)! / Float(model!.width!)!) * screenWidth
        imageView.x = 0
        imageView.y = 0
        imageView.width = screenWidth
        imageView.height = he
        scrollView.frame = imageView.bounds
        
        if he < screenHeight {
            imageView.y = (screenHeight - he) * 0.5
        }
        scrollView.contentSize = imageView.frame.size
        
        backButton.sizeToFit()
        backButton.x = 20; backButton.y = 20
        
        saveButton.sizeToFit()
        saveButton.x = screenWidth - 20.0 - saveButton.width
        saveButton.y = screenHeight - 20.0 - saveButton.height
        
        let maxScale = CGFloat(Float(model!.width!)!) / imageView.width
        if maxScale > 1.0 {
            scrollView.maximumZoomScale = maxScale
        }
    }
    
    //MARK: - 初始化方法
    func showImage(){
        imageView.sd_setImageWithURL(NSURL.init(string: (model?.image1)!)) { (image, _, _, _) -> Void in
            if image == nil  {return}
            self.imageView.image = image
        }
    }
    
    func setting(){
        scrollView.contentMode = UIViewContentMode.Center
        scrollView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        scrollView.addSubview(imageView)
        
        backButton.addTarget(self, action: "backClick", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(backButton)
        
        saveButton.addTarget(self, action: "saveClick", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.titleLabel?.textColor = UIColor.blackColor()
        view.addSubview(saveButton)
    }
    //MARK: -自定义方法
    func backClick(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //保存图片
    func saveClick(){

    }
    
    //MARK: - 懒加载  属性
    //保存按钮
    var saveButton:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "FollowBtnBg"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "FollowBtnClickBg"), forState: UIControlState.Highlighted)
        btn.setTitle("保存", forState: UIControlState.Normal)
        return btn
    }()
    var backButton:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "show_image_back_icon"), forState: UIControlState.Normal)
        return btn
    }()
    
    var imageView:UIImageView = {
        let view = UIImageView.init()
//        view.userInteractionEnabled = false
        return view
    }()
    
    var scrollView:UIScrollView = {
        let view = UIScrollView.init()
        view.showsVerticalScrollIndicator = false
        view.bounces = false
        return view
    }()
    var model : BSEssenceModel?
}


//MARK: - 协议、代理
extension BSShowmediumController:UIScrollViewDelegate{
    
}