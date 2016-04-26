//
//  BSFileManager.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/21.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit

class BSFileManager {
    /**拼接 cache路径*/
    class func cacheFilePath(urlString : String) ->String {
        return (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingString("/\(urlString)"))!
    }
    
    /**拼接 document路径*/
    class func documentFilePath(urlString : String) ->String {
        return (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingString("/" + "\(urlString)"))!
    }
    
///清空文件夹
    class func removeDirectoryPath(directoryPath : String)
    {
        let mgr = NSFileManager.defaultManager()
        //想系统申请一个bool类型的指针
        var isDirectory = UnsafeMutablePointer<ObjCBool>.alloc(1);
        //初始化该指针为true
        isDirectory.initialize(true)
        let isExist = mgr.fileExistsAtPath(directoryPath, isDirectory: isDirectory)
        if !isExist || isDirectory.memory.boolValue == false
        {
            NSException(name: "filePathError", reason: "传错,必须传文件夹路径", userInfo: nil).raise()
        }
        //摧毁指针
        isDirectory.destroy()
        //释放分配的内存
        isDirectory.dealloc(1)
        isDirectory = nil
        var subPaths:[String]?
        do{
            subPaths = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(directoryPath)
        }catch{
            //错误会自动传进来
            print("\(error)")
        }
        for subPath in subPaths!
        {
            let filePath = (directoryPath as NSString).stringByAppendingPathComponent(subPath)
            do{
               try mgr.removeItemAtPath(filePath)
            }catch{
                //错误会自动传进来
                print("\(error)")
            }
        }
    }
///  计算文件夹尺寸
    class func getDirectorySize(directoryPath : String)->UInt64
    {
        let mgr = NSFileManager.defaultManager()
        var isDirectory = UnsafeMutablePointer<ObjCBool>.alloc(1);
        isDirectory.initialize(true)
        let isExist = mgr.fileExistsAtPath(directoryPath, isDirectory: isDirectory)
        if !isExist || isDirectory.memory.boolValue == false
        {
            NSException(name: "filePathError", reason: "传错,必须传文件夹路径", userInfo: nil).raise()
        }
        isDirectory.destroy()
        isDirectory.dealloc(1)
        isDirectory = nil

        var subPaths:[String]?
        var totalSize:UInt64 = 0
        do{
            subPaths = try NSFileManager.defaultManager().subpathsOfDirectoryAtPath(directoryPath)
        }catch{
            //错误会自动传进来
            print("\(error)")
        }
        for subPath in subPaths!
        {   //拼接路径
            let filePath = (directoryPath as NSString).stringByAppendingPathComponent(subPath)
            //想系统申请一个bool类型的指针
            var isDirectory = UnsafeMutablePointer<ObjCBool>.alloc(1);
            //初始化该指针为false
            isDirectory.initialize(true)
            let isExist = mgr.fileExistsAtPath(directoryPath, isDirectory: isDirectory)
            if !isExist || isDirectory.memory.boolValue == false
            {
                continue
            }
            //摧毁指针
            isDirectory.destroy()
            //释放分配的内存
            isDirectory.dealloc(1)
            isDirectory = nil
            if filePath.containsString(".DS") {
                continue
            }
            do{
                let attr:NSDictionary = try mgr.attributesOfItemAtPath(filePath)
                let size = attr.fileSize()
                totalSize += size
            }catch{
                //错误会自动传进来
                print("\(error)")
            }}
            return totalSize
    }
    
}
