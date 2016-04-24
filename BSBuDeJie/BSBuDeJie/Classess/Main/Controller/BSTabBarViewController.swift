//
//  BSTabBarViewController.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/19.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
class BSTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加所有控制器
        addChildViewControllers()
        //替换系统TabBar
        replaceTabbar()
    }

    // MARK: - 初始化控件
    
    private func replaceTabbar (){
        let tabbar: BSTabBar = BSTabBar()
        setValue(tabbar, forKey: "tabBar")
    }
    
    private func addChildViewControllers()
    {
        addChildViewController(BSEssenceController(), ti: "精华", Image: "tabBar_essence_icon", selectedImage: "tabBar_essence_click_icon")
        addChildViewController(BSNewController(), ti: "新帖", Image: "tabBar_new_icon", selectedImage: "tabBar_new_click_icon")
        addChildViewController(BSFriendViewController(), ti: "关注", Image: "tabBar_friendTrends_icon", selectedImage: "tabBar_friendTrends_click_icon")
        addChildViewController(UIStoryboard.init(name: "BSMineTableViewController", bundle: nil).instantiateInitialViewController()!, ti: "我的", Image: "tabBar_me_icon", selectedImage: "tabBar_me_click_icon")
    }
    
    private func addChildViewController(Vc: UIViewController, ti: String ,Image: String, selectedImage: String) {
        let nvC: BSNavgationController = BSNavgationController.init(rootViewController: Vc)
        Vc.tabBarItem.image = UIImage(named: Image)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Vc.tabBarItem.selectedImage = UIImage(named: selectedImage)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Vc.title = ti
        addChildViewController(nvC)
    }
}

//自定义UITabBar
class BSTabBar: UITabBar {
    //Swift中重写父类需要override关键字
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundImage = UIImage(named: "tabbar-light")
        barTintColor = UIColor.grayColor()
        addSubview(self.plusBtn)
        self.plusBtn.addTarget(self, action: "plusBtnOnClick:", forControlEvents: UIControlEvents.TouchUpInside)

            }
    
    func plusBtnOnClick(btn:UIButton){
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(BSShareViewController(), animated: true, completion: nil)
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        self.plusBtn.sizeToFit()
        self.plusBtn.center.x = self.bounds.width * 0.5
        self.plusBtn.center.y = self.bounds.height * 0.5
        
        var index:NSInteger = 0
        var btnX : CGFloat  = 0
        let btnW : CGFloat = self.bounds.width / 5
        //系统布局完之后再布局
        for obj in self.subviews
        {
            if obj.isKindOfClass(NSClassFromString("UITabBarButton")!)
            {
                if index == 2
                {
                    index++
                }
                btnX = CGFloat(index) * btnW
                obj.frame.origin.x = btnX
                index++
                (obj as! UIControl).addTarget(self, action: "repeatClick:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
    }
    var previousTabBarButton:UIControl?
    func repeatClick(tabBarBtn : UIControl)
    {
        if previousTabBarButton != tabBarBtn{
            previousTabBarButton = tabBarBtn
            return
        }
        NSNotificationCenter.defaultCenter().postNotificationName(BSTabBarRepeatClickNotification, object: nil)
    }
    
    lazy var plusBtn: UIButton = {
        let btn: UIButton = UIButton(type: UIButtonType.Custom)
        btn.setBackgroundImage(UIImage(named: "tabBar_publish_icon"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabBar_publish_click_icon"), forState: UIControlState.Highlighted)
        btn.bounds.size = (btn.currentBackgroundImage?.size)!
        return btn
    }()
    
    //Swift只允许一种初始化方式，要么纯代码  要么XIB
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}