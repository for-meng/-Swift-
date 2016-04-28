//
//  BSRemoteMusicManage.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/28.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
import AVFoundation
class BSRemoteMusicManage: NSObject {
    //单例
    static let shareInstance = BSRemoteMusicManage()
    var currentMusicUrl = ""
    let player = AVPlayer()
    
    func isCurrentMusic(urlString : String) ->Bool{
        guard urlString == currentMusicUrl else{
            return false
        }
        return true
    }
    
    func playMusic(urlString:String){
        
        guard urlString == currentMusicUrl else{
            let item = AVPlayerItem(URL: NSURL(string: urlString)!)
            player.replaceCurrentItemWithPlayerItem(item)
            player.play()
            currentMusicUrl = urlString
            return
        }
        currentMusicUrl = ""
        player.pause()
    }

}
