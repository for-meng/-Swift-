//
//  UIImage+Tool.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/21.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
//uiimage 扩展
extension UIImage{
    func circleImage() ->UIImage{
        //开图形上下文
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        //裁剪  圆形
        let clipPath = UIBezierPath(ovalInRect: CGRectMake(0, 0, size.width, size.height))
        //设置裁剪
        clipPath.addClip()
        //画图片
        drawAtPoint(CGPointZero)
        //取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //关图形上下文
        UIGraphicsEndImageContext()
        return image
    }
}
