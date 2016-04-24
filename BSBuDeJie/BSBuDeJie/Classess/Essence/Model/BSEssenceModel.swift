//
//  BSEssenceModel.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/22.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
class BSEssenceModel: NSObject {
    override static func mj_replacedKeyFromPropertyName() -> [NSObject : AnyObject]! {
        return ["ID" : "id"]
    }
        
    override static func mj_objectClassInArray() -> [NSObject : AnyObject]! {
        BSEssenceModel.mj_referenceReplacedKeyWhenCreatingKeyValues(true)
        return ["top_cmt":BSCommentModel.classForCoder()]
    }
    
    /// 昵称
    var name : String?
    /// 点赞数
    var love : String?
    /// 踩
    var cai : String?
    /// 评论
    var comment : String?
    /// 转发
    var repost : String?
    /// 创建时间
    var _creater_at: String?
    var created_at : String?{
        set{
            _creater_at = newValue
        }
        get{
            let formatter = NSDateFormatter.init()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //创建时间
            let date = formatter.dateFromString(_creater_at!)
            //当前时间
            let now = NSDate()
            let currentCalendar = NSCalendar.currentCalendar()
//            不能用 并连接符链接
//            let type = NSCalendarUnit.Year | NSCalendarUnit.Month | NSCalendarUnit.Day | NSCalendarUnit.Hour | NSCalendarUnit.Minute | NSCalendarUnit.Second
            let components = currentCalendar.components([.Year ,.Month , .Day , .Hour , .Minute , .Second], fromDate: date!, toDate: now, options: NSCalendarOptions.init(rawValue: 0))
            if components.year > 0 {
                //一年前            yyyy-MM-dd HH:mm:ss
                formatter.dateFormat = "yyyy年MM月dd日 HH时"
            }else if components.month > 0{
                //一个月 ~ 一年内    MM - dd  HH:mm:ss
                formatter.dateFormat = "MM月dd日 HH时";
            }else if components.day > 2{
                //两天 ~  一个月    dd  HH:mm:ss
                formatter.dateFormat = "dd日 HH时";
            }else if components.day == 2{
                //两天      前天    HH:mm:ss
                formatter.dateFormat = "前天 HH时";
            }else if components.day == 1{
                //一天      昨天   HH:mm:ss
                formatter.dateFormat = "昨天 HH时 mm分";
            }else if components.hour > 9 {
                //24小时内        x小时前
                formatter.dateFormat = "HH小时前";
                return formatter.stringFromDate(currentCalendar.dateFromComponents(components)!)
            }else if components.hour > 0{
                formatter.dateFormat = "\(components.hour)小时前"
                return formatter.stringFromDate(currentCalendar.dateFromComponents(components)!)
            }else if components.minute > 9{
                //一小时内        x分钟前
                formatter.dateFormat = "mm分钟前";
                return formatter.stringFromDate(currentCalendar.dateFromComponents(components)!)
            }else if components.minute > 0{
                formatter.dateFormat = "\(components.minute)分钟前"
                return formatter.stringFromDate(currentCalendar.dateFromComponents(components)!)
            }else {
                //一分钟内       刚刚
                formatter.dateFormat = "刚刚"
                return formatter.stringFromDate(currentCalendar.dateFromComponents(components)!)
            }
            return formatter.stringFromDate(date!)
        }
    }
    /// 帖子内容
    var text : String?
    /// 大图地址
    var bimageuri : String?
    /// 视频或图片的静态图片   小图
    var image0 : String?
    /// 视频或图片的静态图片   大图
    var image1 : String?
    /// 头像地址
    var profile_image : String?
    /// 视频地址
    var videouri : String?
    /// 音频地址
    var voiceuri : String?
    /// 是否是gif   返回值不是bool值  不能用bool接收
    var is_gif : String?
    /// 宽度
    var width : String?
    /// 高度
    var height : String?
    /// 是否是大图
    var isBigImage : Bool?{
        get{
            return NSString(string: height!).floatValue > Float(screenHeight)
        }
    }
    /// 视频长度
    var videotime : String?
    /// 音频长度
    var voicetime : String?
    /// 播放次数
    var playcount : String?
    /// 帖子id
    var ID : String?
    /// 最热评论
    var top_cmt : Array<BSCommentModel>?
}

class BSCommentModel: NSObject {
    /// 评论的内容
    var content : String?
    /// 评论被顶的次数
    var like_count : String?
    /// 评论人信息
    var user : BSUser?
}

class BSUser: NSObject {
    /// 用户名称
    var username : String?
    /// 性别
    var sex : String?
    /// 头像地址
    var profile_image : String?
}
