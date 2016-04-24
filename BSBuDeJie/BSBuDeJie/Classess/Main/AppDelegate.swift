//
//  AppDelegate.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/19.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
//      window?.rootViewController = BSADViewController()
        window?.rootViewController = BSTabBarViewController()
        window?.makeKeyAndVisible()
        //添加FPS监测
        addFPS()
        return true
    }
    
    
    private func addFPS(){
        let link = CADisplayLink.init(target: self, selector: "timeUp")
        link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        window?.addSubview(FpsLabel)
        dislink = link
    }
    
    lazy var FpsLabel:UILabel = {
        let label = UILabel.init(frame: CGRectMake(10, UIScreen.mainScreen().bounds.height - 30, 0, 0))
        label.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        label.textColor = UIColor.blackColor()
                return label
    }()
    
    var dislink : CADisplayLink?
    var count = 0
    var previousTime:CFTimeInterval = 0
    func timeUp(){
        if previousTime == 0 {
            //开始的时间
            previousTime = dislink!.timestamp
        }
        count++
        let detal = (dislink?.timestamp)! - previousTime
        if detal < 1 {
            return
        }
        previousTime = 0
        FpsLabel.text = "FPS:(\(count))"
        FpsLabel.sizeToFit()
        count = 0
    }
    
}