//
//  BSHttpTool.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/21.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
import AFNetworking
/// 网络请求工具类
class BSHttpTool {
    /**
     GET请求
     - parameter dict:    参数字典
     - parameter success: 请求成功闭包回调
     - parameter filure:  请求失败闭包回调
     */
   internal class func GETData(dict:AnyObject,success:(AnyObject?)->(),filure:(NSError)->()){
        let manager = AFHTTPSessionManager.init()
        manager.requestSerializer.timeoutInterval = 10
        manager.GET("http://api.budejie.com/api/api_open.php", parameters: dict, progress: nil, success: { (_, respondObject) -> Void in
                success(respondObject)
            }) { (_, error) -> Void in
                filure(error)
        }
    }
    /**
     POST 请求
     
     - parameter dict:    参数字典
     - parameter success: 请求成功闭包回调
     - parameter filure:  请求失败闭包回调
     */
    internal class func POSTData(dict:AnyObject,success:(AnyObject?)->(),filure:(NSError)->())
    {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.timeoutInterval = 10
        manager.POST("http://api.budejie.com/api/api_open.php", parameters: dict, progress: nil, success: { (_, respondObject) -> Void in
            success(respondObject)
            }) { (_, error) -> Void in
                filure(error)
        }
        
    }

    /**
     文件下载
     - parameter urlString:   下载url路径
     - parameter complection: 下载完成闭包回调
     */
    internal class func downLoadNomal(urlString :String,complection : (filePath : NSURL)->()){
        let session = AFURLSessionManager.init()
        session.downloadTaskWithRequest(NSURLRequest(URL: NSURL(string: urlString)!), progress: nil, destination: { (url, _) -> NSURL in
                return NSURL(fileURLWithPath: BSFileManager.cacheFilePath(urlString))
            }) { (_, filePath, _) -> Void in
                complection(filePath: filePath!)
        }
    }
    
    /**广告*/
   internal class func GETADData(dict:AnyObject,success:(AnyObject?)->(),filure:(NSError)->())
    {
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(object:"text/html") as? Set<String>
        manager.GET("http://mobads.baidu.com/cpro/ui/mads.php", parameters: dict, progress: nil, success: { (_, respondObject) -> Void in
            success(respondObject)
            }) { (_, error) -> Void in
                filure(error)
        }
    }
    

    
}
