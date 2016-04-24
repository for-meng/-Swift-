//
//  BSADViewController.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/21.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
class BSADViewController: UIViewController {
    //MARK: - 系统方法
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置启动图片
        setupLaunchImage()
        //初始化设置
        setUp()
        //加载数据
        loadData()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "delay", userInfo: nil, repeats: true)
    }
    
    //MARK: - 初始化方法
    func setUp(){
        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "tap"))
        asView.addSubview(imageView)
    }
    
    //设置启动图片
    func setupLaunchImage(){
        var image:UIImage?
        if (iPhone6p){
            image = UIImage(named: "LaunchImage-800-Portrait-736h@3x")
        } else if (iPhone6){
            image = UIImage(named: "LaunchImage-800-667h")
        } else if (iPhone5){
            image = UIImage(named: "LaunchImage-700-568h")
        } else if (iPhone4){
            image = UIImage(named: "LaunchImage-700")
        }
        launchingImage.image = image!
    }
    //MARK: - 自定义方法
    func loadData(){
        let dict = ["code2" : code2]
        BSHttpTool.GETADData(dict, success: {(object) -> () in
            let adDict = object!["ad"] as! NSArray
            self.anaylize(adDict.firstObject as! NSDictionary)
            }) { (_) -> () in
                SVProgressHUD.showErrorWithStatus("请求失败")
        }
    }
    
    func anaylize(dict : NSDictionary){
        item = BSADModel.init(dict: dict)
        if item!.w <= 0 { return }
        //展示界面
        let h = screenHeight / CGFloat((item?.w)!) * CGFloat((item?.h)!)
        imageView.frame = CGRectMake(0, 0, screenWidth, h)
        imageView.sd_setImageWithURL(NSURL.init(string: (item?.w_picurl)!)) { (image, _, _, _) -> Void in
            self.imageView.image = image
        }
    }
    //计时器
    var timeOut = 5
    func delay(){
        if timeOut == 0
        {
            skinBtnOnClick()
        }
        skinBtn.setTitle("跳过 (\(timeOut--))", forState: UIControlState.Normal)
    }
    
    //点击广告图片
    func tap (){
        let app = UIApplication.sharedApplication()
       if app.canOpenURL(NSURL.init(string: (item?.ori_curl)!)!)
       {
            app.openURL(NSURL.init(string: (item?.ori_curl)!)!)
        }
    }
    
    @IBAction func skinBtnOnClick() {
        UIApplication.sharedApplication().keyWindow?.rootViewController = BSTabBarViewController()
        
        timer?.invalidate()
    }
    //MARK: - 懒加载 属性
    lazy var imageView:UIImageView = {
        let view = UIImageView.init()
        view.userInteractionEnabled = true
        return view
    }()
    var timer : NSTimer?
    var item : BSADModel?
    @IBOutlet weak var asView: UIView!
    @IBOutlet weak var launchingImage: UIImageView!
    @IBOutlet weak var skinBtn: UIButton!
    let iPhone6p = screenHeight == 736
    let iPhone6  = screenHeight == 667
    let iPhone5  = screenHeight == 568
    let iPhone4  = screenHeight == 480
    let code2 = "phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"
}


//MARK: - 模型
class BSADModel : NSObject {
    init(dict : NSDictionary) {
        super.init()
        setValuesForKeysWithDictionary(dict as! [String : AnyObject])
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    var w_picurl:String?
    var ori_curl:String?
    var w:Int64 = 0
    var h:Int64 = 0
}
