//
//  BSFriendViewController.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/20.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit

class BSFriendViewController: UIViewController {
    //MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        //导航栏
        setUpNav()
    }
    //MARK: - 初始化方法
    func setUpNav (){
        navigationItem.title = "我的关注"
        
        navigationItem.titleView = UIImageView.init(image: UIImage(named: "MainTitle"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.itemWithTarget(self, action: "friendsRecommen", image: "friendsRecommentIcon", highlightImage: "friendsRecommentIcon-click")
        
    }

    //MARK: - 自定义方法
    func friendsRecommen(){
      print("关注的人")
    }
    
    @IBAction func loginOrRegister() {
        self.presentViewController(BSLoginOrRegisterVc(), animated: true, completion: nil)
    }
    //MARK: - 懒加载
    
}


//MARK: - 协议、代理
