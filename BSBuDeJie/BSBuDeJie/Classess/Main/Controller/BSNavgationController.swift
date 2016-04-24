//
//  BSNavgationController.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/19.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit

class BSNavgationController: UINavigationController {    
    override class func initialize() {
        let bar:UINavigationBar = UINavigationBar.appearance()
        bar.setBackgroundImage(UIImage(named: "navigationbarBackgroundWhite"), forBarMetrics: UIBarMetrics.Default)
        
        let item:UIBarButtonItem = UIBarButtonItem.appearance()
        
        item.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        item.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orangeColor()], forState: UIControlState.Highlighted)
        item.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: 154.0/255.0, green: 154.0/255.0, blue: 154.0/255.0, alpha: 0.8)], forState: UIControlState.Disabled)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - 添加全屏返回手势
        addGestureRecognizer()
    }
    
    private func addGestureRecognizer(){
        let pan : UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self.interactivePopGestureRecognizer?.delegate, action: NSSelectorFromString("handleNavigationTransition:"))
        pan.delegate = self
        view.addGestureRecognizer(pan)
    }
    
    //MARK: -系统方法
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {//非根控制器
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWithTarget(self, action: Selector("back"), image: "navigationButtonReturn", highlightImage: "navigationButtonReturnClick")
            viewController.navigationItem.rightBarButtonItem = UIBarButtonItem.itemWithTarget(self, action: Selector("moreClick"), image: "cellmorebtnnormal", highlightImage: "cellmorebtnclick")
            
            viewController.navigationController?.navigationBar.shadowImage = UIImage(named: "cell-content-line")    
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func back(){
        popViewControllerAnimated(true)
    }
    
    func moreClick(){
        popViewControllerAnimated(true)
    }
}

extension BSNavgationController: UIGestureRecognizerDelegate{
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if childViewControllers.count == 1 {
            return false
        }
        return true
    }
}

extension UIBarButtonItem {
    class func itemWithTarget(target: AnyObject?, action: Selector, image: String, highlightImage: String)
        -> UIBarButtonItem
    {
        let btn : UIButton = UIButton(type: UIButtonType.Custom)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.setBackgroundImage(UIImage(named: image), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: highlightImage), forState: UIControlState.Highlighted)
        btn.bounds.size = (btn.currentBackgroundImage?.size)!
        btn.adjustsImageWhenHighlighted = false
        //用uiview包装后位置会产生偏移
        let newViwe : UIView = UIView.init(frame: btn.bounds)
//        newViwe.addSubview(btn)
        return UIBarButtonItem.init(customView: btn)
    }
    
    class func itemWithTarget(target: AnyObject?, action: Selector, image: String, seletedImage: String)
        -> UIBarButtonItem
    {
        let btn : UIButton = UIButton(type: UIButtonType.Custom)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.setBackgroundImage(UIImage(named: image), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: seletedImage), forState: UIControlState.Selected)
        btn.bounds.size = (btn.currentBackgroundImage?.size)!
        btn.adjustsImageWhenHighlighted = false
        //用uiview包装后位置会产生偏移
        //        newViwe.addSubview(btn)
        return UIBarButtonItem.init(customView: btn)
    }
}