
//
//  BSNewController.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/20.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit

class BSNewController: UIViewController {
    //MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        //子控制器
        addChildViewControllers()
        //导航条
        setUpNav()
        //初始化设置
        setting()
        //子标题栏
        setSubNavBar()
    }
    //MARK: - 初始化方法
    func setUpNav (){
        navigationItem.titleView = UIImageView.init(image: UIImage(named: "MainTitle"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.itemWithTarget(self, action: "MainTagSubIconClick", image: "MainTagSubIcon", highlightImage: "MainTagSubIconClick")
        
        navigationController?.navigationBar.shadowImage = UIImage(named: "cell-content-line")
    }
    
    //MARK: - 自定义方法
    func MainTagSubIconClick(){
        navigationController?.pushViewController(BSRecommendController(), animated: true)
    }
    
    //设置子标题栏
    private func setSubNavBar (){
        let toolBar: BSScollerToolBar = BSScollerToolBar()
        let dict = [BSType.All : "全部",BSType.Video : "视频",BSType.Picture : "图片",BSType.Voice : "音乐",BSType.Article : "段子"]
        toolBar.setTitleArray(dict)
        toolBar.frame = CGRectMake(0, NavBarHeight, screenWidth, ToolBarHeight)
        toolBar.scrollToolBardelegate = self
        toolBar.delegate = self
        view.addSubview(toolBar)
        NSNotificationCenter.defaultCenter().addObserver(BSToolBarRepeatClickNotification, selector: "toolbarBtnRepeatClick", name: nil, object: nil)
    }
    
    private func setting (){
        //去除ScrollerView的自动调整
        automaticallyAdjustsScrollViewInsets = false;
        scrollView.backgroundColor = UIColor.blueColor()
        scrollView.contentSize = CGSizeMake(CGFloat(childViewControllers.count) * screenWidth, 0)
        view.addSubview(scrollView)
        switchSubController(BSType.All)
    }
    
    //添加子控制器
    private func addChildViewControllers(){
        //全部
        addChildViewController(BSEssenceBaseController(),type:BSType.All)
        //视频
        addChildViewController(BSEssenceBaseController(),type:BSType.Video)
        //图片
        addChildViewController(BSEssenceBaseController(),type:BSType.Picture)
        //声音
        addChildViewController(BSEssenceBaseController(),type:BSType.Voice)
        //段子
        addChildViewController(BSEssenceBaseController(),type:BSType.Article)
    }

    func addChildViewController(ViewController:BSEssenceBaseController,type:BSType){
        addChildViewController(ViewController)
        ViewController.aValue = "newlist"
        ViewController.type = type
    }
    
    func switchSubController(type: BSType){
        var newVc : BSEssenceBaseController?
        for childVc in childViewControllers{
            let Vc = childVc as! BSEssenceBaseController
            if Vc.type == type
            {
                newVc = Vc
                break
            }}
        currentVc?.view .removeFromSuperview()
        newVc?.view.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        scrollView.addSubview((newVc?.view)!)
        currentVc = newVc
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tabBarBtnRepeatClick", name: BSTabBarRepeatClickNotification, object: nil)
    }
    
    //如果设置为private 的话，会导致无法在其他类中无法找到这个方法
    //MARK: - 监听方法
    func toolbarBtnRepeatClick(){
        if currentVc?.view.window != nil {
            //刷新
        }
    }
    
    func tabBarBtnRepeatClick(){
        toolbarBtnRepeatClick()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //MARK: - 懒加载
    var currentVc : UITableViewController?
    
    lazy var scrollView: UIScrollView = {
        let View:UIScrollView = UIScrollView.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        View.scrollEnabled = false  // 先禁止
        View.pagingEnabled = true
        View.scrollsToTop = false
        View.showsHorizontalScrollIndicator = false
        return View
    }()
}

//MARK: - 协议、代理
extension BSNewController : BSScrollerToolBarDelegate,UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("\(scrollView.contentOffset.x)")
    }
    
    func scrollerToolBarButtonClick(toolBar: BSScollerToolBar, type: BSType) {
        switchSubController(type)
    }
}


