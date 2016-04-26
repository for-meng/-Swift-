//
//  BSMusicManage.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/24.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
import AVFoundation

class BSMusicManage {
    //类方法中不能使用属性
    ///存储音乐播放器数组
    static var _players:[String : AVAudioPlayer] = Dictionary()
    ///存储音效ID数组
    static var _soundIds:[String : SystemSoundID] = Dictionary()

    /**
     判断对应的音乐是否正在播放
     */
    class func musicIsPlaying(urlString : String) ->Bool{
        if let currentPlayer = _players[urlString]{
            return currentPlayer.playing
        }
        return false  }
    /**
    根据网络URL下载音乐到本地，下载完成后自动包房
    */
    class func playMusicWithURLString(urlString : String){
        if urlString.characters.count == 0 {
            NSException(name: "无法下载该音乐", reason: "路径为空或者错误", userInfo: nil).raise()  }
        
        if let _ = _players[urlString]{
            //播放器存在 不要再次创建
            return}
        
        if NSFileManager.defaultManager().fileExistsAtPath(BSFileManager.cacheFilePath(urlString)) {
            //已经下载在本地了   直接创建播放器
            do{
              let player = try AVAudioPlayer.init(contentsOfURL: NSURL(string: urlString)!, fileTypeHint: AVFileTypeMPEGLayer3)
                //url为Key存储到数组中
                _players.updateValue(player, forKey: urlString)
                player.play()
                return
            }catch{
                //错误会自动传进来
                print("\(error)")
            }}
        //创建错误 或者 本地没有文件-->下载音乐文件
        BSHttpTool.downLoadNomal(urlString) { (filePath) -> () in
            do{
                let player = try AVAudioPlayer.init(contentsOfURL:filePath , fileTypeHint: AVFileTypeMPEGLayer3)
                //url为Key存储到数组中
                _players.updateValue(player, forKey: urlString)
                player.play()
                return
            }catch{
                //错误会自动传进来
                print("\(error)")
            }}}
    /**
     暂停对应的音乐
     */
    class func pauseMusicWithMusicName(urlString : String){
        if let player = _players[urlString]{
            player.pause()
        }
    }
    /**
     停止音乐
     */
    class func stopMusicWithMusicName(urlString : String){
        if let player = _players[urlString]{
            player.stop()
            _players.removeValueForKey(urlString)
        }
    }
    /**
     播放音效
     */
    class func playSoundWithSounddName(soundName: String){
        //定义SystemSoundId
        var soundID : SystemSoundID = 0
        //从字典中取出SoundId，取出时nil，表示字典中没有
        if let soundId = _soundIds[soundName] {
           if soundId == 0 {
            if let url:CFURLRef = NSBundle.mainBundle().URLForResource(soundName, withExtension: nil){
                    var sound = UnsafeMutablePointer<SystemSoundID>.alloc(1);
                    sound.initialize(soundId)
                    AudioServicesCreateSystemSoundID(url, sound)
                    _soundIds.updateValue(soundId, forKey: soundName)
                    sound.destroy()
                    sound.dealloc(1)
                    sound = nil
                }
           }else {
            //不为 0 则赋值
            soundID = soundId   }
        }
        AudioServicesPlaySystemSound(soundID)
    }
}
