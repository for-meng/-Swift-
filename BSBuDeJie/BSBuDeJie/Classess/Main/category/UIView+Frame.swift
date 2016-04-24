//
//  UIView+Frame.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/21.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
extension UIView{
    
    /// x 坐标
    var x:CGFloat{
        set{
            var newFrame = frame
            newFrame.origin.x = newValue
            frame = newFrame
        }
        get{   return frame.origin.x  }}
    
    /// y 坐标
    var y:CGFloat{
        set{
            var newFrame = frame
            newFrame.origin.y = newValue
            frame = newFrame
        }
        get{   return frame.origin.y  }}

    /// width 宽度
    var width:CGFloat{
        set{
            var newFrame = frame
            newFrame.size.width = newValue
            frame = newFrame
        }
        get{   return frame.size.width  }}
    
    /// height 高度
    var height:CGFloat{
        set{
            var newFrame = frame
            newFrame.size.height = newValue
            frame = newFrame
        }
        get{   return frame.size.height  }}
    
    /// centerX 中心点x
    var centerX:CGFloat{
        set{
            var newCenter = center
            newCenter.x = newValue
            center = newCenter
        }
        get{   return center.x         }}
    
    /// centerY  中心点y
    var centerY:CGFloat{
        set{
            var newCenter = center
            newCenter.y = newValue
            center = newCenter
        }
        get{   return center.y         }}
    
    /// 宽度一半
    var halfWidth:CGFloat{
        set{   width = newValue * 2 }
        get{   return frame.size.width * 0.5   }}
    
    /// 高度一半
    var halfHeight:CGFloat{
        set{   height = newValue * 2 }
        get{   return frame.size.height * 0.5   }}
}

