//
//  const.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/20.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit

public enum BSType : Int {
    case All =  1
    case Picture = 10
    case Article = 29
    case Voice = 31
    case Video = 41
    
}

let ToolBarHeight:CGFloat = 35;
let NavBarHeight:CGFloat = 65;
let TabBarHeight:CGFloat = 49;

/// 屏幕宽度
var screenWidth:CGFloat{
get{  return UIScreen.mainScreen().bounds.width  }}

/// 屏幕高度
var screenHeight:CGFloat{
get{  return UIScreen.mainScreen().bounds.height  }}

let BSToolBarRepeatClickNotification = "BSImageViewButtonRepeatClickNotification"
let BSTabBarRepeatClickNotification = "BSTabBarRepeatClickNotification"
