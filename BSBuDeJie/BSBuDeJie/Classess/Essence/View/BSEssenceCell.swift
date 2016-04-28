//
//  BSEssenceCell.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/22.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
import SDWebImage
import MediaPlayer
class BSEssenceCell: UITableViewCell {
    //MARK: - 系统方法
    override var frame: CGRect{
        set{
            var newframe = newValue
            newframe.size.height -= 10
            super.frame = newframe
        }
        get{
            return super.frame
        }
    }
    override func awakeFromNib() {
        image_View.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        //添加约束
        let constraintTop = NSLayoutConstraint(item: image_View, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: imgView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let constraintLeft = NSLayoutConstraint(item: image_View, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: imgView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let constraintRight = NSLayoutConstraint(item: image_View, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: imgView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let constraintBottom = NSLayoutConstraint(item: image_View, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: imgView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        image_View.addConstraints([constraintTop,constraintBottom,constraintLeft,constraintRight])
    }
    
    //MARK: - 懒加载  属性
    var _model : BSEssenceModel?
    internal var model : BSEssenceModel?{
        set{
            _model = newValue
            //赋值完毕
            iconImage.sd_setImageWithURL(NSURL.init(string: (newValue?.profile_image)!), placeholderImage: UIImage(named: "defaultUserIcon"))
            nameLabel.text = newValue!.name
            timeLabel.text = newValue!.created_at
            text_label.text = newValue!.text
            let top_cmt = newValue!.top_cmt
            if top_cmt?.count > 0
            {
                let comment = top_cmt![0]

                hotCommentDefaultLabel.text = "最热评论"
                hotCommentLabel.text = "\((comment.user?.username)!)" + ": " + "\((comment.content)!)"
            }else {
                hotCommentDefaultLabel.text = nil
                hotCommentLabel.text = nil
            }
            setBtn(dingButton, title: (newValue?.love)!, name: "顶")
            setBtn(caiButton, title: (newValue?.cai)!, name: "踩")
            setBtn(repostButton, title: (newValue?.repost)!, name: "转发")
            setBtn(commentButton, title: (newValue?.comment)!, name: "评论")
            imgView.model = newValue
            
            var imageH : CGFloat = 0
            if Float(newValue!.width!)!  !=  0 {
                imageH = CGFloat(NSString(string: model!.height!).floatValue / NSString(string: model!.width!).floatValue) * (screenWidth - 20)
            }
            if model!.isBigImage == true
            {
                imageH = screenHeight
            }
            imageHeight.constant = imageH
        }
        get{
            return _model
        }
    }
    
    private func setBtn(btn : UIButton,title : String , name: String){
        if title.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            btn.setTitle(name, forState: UIControlState.Normal)
        }else{
            btn.setTitle(title, forState: UIControlState.Normal)
        }
        
    }
    
    @IBAction func dingBtnClick() {
        print(__FUNCTION__)
    }
    @IBAction func caiBtnClick() {
        print(__FUNCTION__)
    }
    @IBAction func repostBtnClick() {
        print(__FUNCTION__)
    }
    @IBAction func commentBtnClick() {
        print(__FUNCTION__)
    }
    @IBAction func moreButtonOnClick() {
        print(__FUNCTION__)
    }
    lazy var imgView = BSEssenceImage.essenceImage()
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var text_label: UILabel!
    @IBOutlet weak var image_View: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var hotCommentDefaultLabel: UILabel!
    @IBOutlet weak var hotCommentLabel: UILabel!
    @IBOutlet weak var dingButton: UIButton!
    @IBOutlet weak var caiButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
}


//MARK: - 图片
class BSEssenceImage: UIView {
    //MARK: - 方法
    class func essenceImage() ->BSEssenceImage{
        return NSBundle.mainBundle().loadNibNamed("BSEssenceImage", owner: nil, options: nil).first as! BSEssenceImage
    }
    
    //方法图片
    func newBigImage(image : UIImage) -> UIImage{
        let imageW = width
        let imageH = height
        if height == 0 {
            return image
        }
        //崩溃原因  高度为0
        UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
        let imageHH = CGFloat(NSString(string: model!.height!).floatValue / NSString(string: model!.width!).floatValue) * imageW
        image.drawInRect(CGRectMake(0, 0, imageW, imageHH))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }

    //MARK: - 懒加载  属性
    var model : BSEssenceModel?{
        willSet{
            pictureImageView.image = UIImage(named: "defaultUserIcon") }
        didSet{
            if model?.image0?.characters.count > 0
            {
                pictureImageView.sd_setImageWithURL(NSURL.init(string: (model?.image1)!), placeholderImage: UIImage(named: "defaultUserIcon"), completed: { (image, _, _, _) -> Void in
                    if image != nil {
                    if self.model?.isBigImage == true{
                        self.pictureImageView.image = self.newBigImage(image)
                    }else {
                        self.pictureImageView.image = image
                        }}})
            }else {
                pictureImageView.image = nil    }
                pictureImageView.contentMode = UIViewContentMode.ScaleToFill
            //服务器返回的是String类型   不能用Boll去接收
                if let is_gif = model?.is_gif{
                    if is_gif == "1"
                    {
                        GifButton.hidden = false
                    }else {
                        GifButton.hidden = true     }
                }else {
                    GifButton.hidden = true         }
            voicePlayButton.hidden = !(model?.voiceuri?.characters.count > 0)
            videoPlayButton.hidden = !(model?.videouri?.characters.count > 0)
            showBigImageButton.hidden = (model?.isBigImage == false)
           
            //播放次数
        setLabel(playCount, str: model?.playcount) { (floatValue) -> () in
                self.playCount.text = "播放次数:\(floatValue)次"}
            //播放时长
            
        if NSString(string: (model?.videotime)!).integerValue > 0 {
        setLabel(timeLenthLabel, str: model?.videotime) { (Value) -> () in
            self.timeLenthLabel.text = String(format: "%02d:%02d", arguments: [(Value / 60) , (Value % 60)])}
            }else{
                setLabel(timeLenthLabel, str: model?.voicetime) { (Value) -> () in
                    self.timeLenthLabel.text = String(format: "%02d:%02d", arguments: [(Value / 60) , (Value % 60)])}
            }}}
    
    func setLabel(label : UILabel, str : String?, doSomething: (Value : Int)->()){
        label.hidden = true
        if let str = str{
            let value = NSString(string: str).integerValue
            if  value > 0{
                label.hidden = false
                doSomething(Value: value)
            }}}
    
    /** 音频播放     */
    @IBAction func playVoiceClick(sender: UIButton) {
        sender.selected = !BSRemoteMusicManage.shareInstance.isCurrentMusic(model!.voiceuri!)
        BSRemoteMusicManage.shareInstance.playMusic(model!.voiceuri!)
        //正在播放音乐就选中
//        sender.selected = BSMusicManage.musicIsPlaying((model?.voiceuri)!)
//        let dict = ["model":model!] as [NSObject:AnyObject]
//        NSNotificationCenter.defaultCenter().postNotificationName("playVoiceClick", object: nil, userInfo: dict)
    }
    
    /** 视频播放     */
    @IBAction func playVideoClick(sender: UIButton) {
            playVideo()
    }
    func playVideo(){
        let movieVc = MPMoviePlayerViewController.init(contentURL: NSURL.init(string: (model?.videouri)!))
        movieVc.moviePlayer.controlStyle = MPMovieControlStyle.Fullscreen
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentMoviePlayerViewControllerAnimated(movieVc)
    }
    
    @IBAction func showBigImageClick() {
        let Vc = BSShowmediumController()
        Vc.model = model
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(Vc, animated: true, completion: nil)
    }
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var voicePlayButton: UIButton!
    @IBOutlet weak var GifButton: UIButton!
    @IBOutlet weak var showBigImageButton: UIButton!
    @IBOutlet weak var videoPlayButton: UIButton!
    @IBOutlet weak var playCount: UILabel!
    @IBOutlet weak var timeLenthLabel: UILabel!
    
}