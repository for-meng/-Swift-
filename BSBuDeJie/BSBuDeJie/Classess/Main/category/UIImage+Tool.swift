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
    /**  生成圆角图片 */
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
    /**
     生成一个带圆环的图片
     - parameter name:        图片名称
     - parameter border:      圆环宽度
     - parameter borderColor: 圆环颜色
     */
    class func image(name:String,border:CGFloat,borderColor:UIColor) ->UIImage?{
        //加载旧的图片
        let oldImage = UIImage(named: name)
        //新的图片尺寸
        let imageW = (oldImage?.size.width)! + 2 * border
        let imageH = (oldImage?.size.height)! + 2 * border
        //设置新的图片的尺寸
        let circleW = imageW > imageH ? imageH : imageW
        
        //开启上下文
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(circleW, circleW), false, 0.0)
        //画大图
        let path = UIBezierPath(ovalInRect: CGRectMake(0, 0, circleW, circleW))
        //获取当前上下文
        if let ctx = UIGraphicsGetCurrentContext(){
            //添加到上下文
            CGContextAddPath(ctx, path.CGPath)
            //设置颜色
            borderColor.set()
            //渲染
            CGContextFillPath(ctx)
            //画图  正切于旧图片的圆
            let clipPath = UIBezierPath(ovalInRect: CGRectMake(border, border, (oldImage?.size.width)!, (oldImage?.size.height)!))
            //设置裁剪区域
            clipPath.addClip()
            //画图片
            oldImage?.drawAtPoint(CGPointMake(border, border))
            //获取新的图片
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            return newImage
        }
        return nil
    }
    
    
    /**
     截屏
     - parameter view: 需要截屏的视图
     */
    class func imageWithCapturView(view : UIView) -> UIImage?{
        //开启上下文
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        //获取上下文   如果获取不到则返回nil
        if let ctx = UIGraphicsGetCurrentContext(){
        //渲染控制器view的图层到上下文
            view.layer.renderInContext(ctx)
        //获取截屏图片
          let newImage = UIGraphicsGetImageFromCurrentImageContext()
            //关闭上下文
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    /**
     返回一张受保护 的图片
     */
    class func resizableImage(imageName : String) -> UIImage?{
        let image = UIImage(named: imageName)
        //设置受保护的区域
        let leftEdgeInset = (image?.size.width)! * 0.5
        let rightEdgeInset = (image?.size.height)! * 0.5
        //返回受保护的图片
        return image?.stretchableImageWithLeftCapWidth(Int(leftEdgeInset), topCapHeight: Int(rightEdgeInset))
    }
    
}
