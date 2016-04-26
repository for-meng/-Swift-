//
//  BSLoginOrRegisterVc.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/22.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit

class BSLoginOrRegisterVc: UIViewController {
    //MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBarHidden = true
        
        let loginView = midView.subviews[0]
        loginView.frame = CGRectMake(0, 0, self.midView.width * 0.5, self.midView.height)
        
        let registerView = midView.subviews[1]
        registerView.frame = CGRectMake(screenWidth, 0, self.midView.width * 0.5, self.midView.height)
        
        let fastView = bottomView.subviews.last
        fastView?.frame = bottomView.bounds
    }
    //MARK: - 初始化方法
       func addSubViews(){
        midView.addSubview(BSLoginOrRegisterView.login() as! UIView)
        midView.addSubview(BSLoginOrRegisterView.register() as! UIView)
        bottomView.addSubview(BSFastLogin.fastLoginBtn())
    }
    
    //MARK: - 懒加载
    @IBAction func loginOrRegister(sender: UIButton) {
        sender.selected = !sender.selected
        leftConstaint.constant = leftConstaint.constant == 0 ? -screenWidth : 0
        UIView.animateWithDuration(0.25) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func closeClick() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var leftConstaint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var bottomView: UIView!
}

//MARK: - 子View
class BSLoginOrRegisterView : UIView{
    class func login() -> AnyObject{
        return NSBundle.mainBundle().loadNibNamed("BSLoginOrRegisterView", owner: nil, options: nil).first!
    }
    class func register() -> AnyObject{
        return NSBundle.mainBundle().loadNibNamed("BSLoginOrRegisterView",owner: nil, options: nil).last!
    }
    override func awakeFromNib() {
//        var image = UIImage(named: "loginBtnBg")
//        var highImage = UIImage(named: "loginBtnBgClick")
//        image = image?.stretchableImageWithLeftCapWidth(Int(Double(image!.size.width) * 0.5), topCapHeight: Int(Double(image!.size.height) * 0.5))
//        highImage = highImage?.stretchableImageWithLeftCapWidth(Int(Double(image!.size.width) * 0.5), topCapHeight: Int(Double(image!.size.height) * 0.5))
//        loginRegisterBtn.setBackgroundImage(image, forState: UIControlState.Normal)
//        loginRegisterBtn.setBackgroundImage(highImage, forState: UIControlState.Highlighted)
    }
    
//    @IBOutlet weak var loginRegisterBtn: BSLoginButton!
}

///快速登录按钮
class BSFastLogin:UIView{
    class func fastLoginBtn() ->UIView{
        return NSBundle.mainBundle().loadNibNamed("BSFastLogin", owner: nil, options: nil).first as! UIView
    }
}

class BSLoginButton:UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.centerX = width * 0.5
        imageView?.y = 0
        
        titleLabel?.sizeToFit()
        titleLabel?.centerX = width * 0.5
        titleLabel?.y = height - (titleLabel?.height)!
    }
}

