
//  BSEssenceBaseController.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/20.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
import MJExtension
import MJRefresh
import SVProgressHUD
class BSEssenceBaseController: UITableViewController {
    //MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置刷新控件
        setRefresh()
        //初始化设置
        setting()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playMusic:", name: "playVoiceClick", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var currentMusicModel : BSEssenceModel?
    func playMusic(noti : NSNotification){
        let model = noti.userInfo!["model"] as! BSEssenceModel
        if currentMusicModel != model{
            //停止正在播放的
            BSMusicManage.stopMusicWithMusicName((currentMusicModel?.voiceuri)!)
            //开始播放新的
            BSMusicManage.playMusicWithURLString((model.voiceuri)!)
            currentMusicModel = model
        }else {
            BSMusicManage.stopMusicWithMusicName((model.voiceuri)!)
            currentMusicModel = nil
        }
    }
    
    //MARK: - 初始化方法
    func setting(){
        view.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.7)
        tableView.contentInset = UIEdgeInsetsMake(NavBarHeight + ToolBarHeight + 10, 0, TabBarHeight, 0)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(NavBarHeight + ToolBarHeight, 0, TabBarHeight, 0)
        //开始刷新
        tableView.mj_header.beginRefreshing()
        //注册cell
        tableView.registerNib(UINib.init(nibName: "BSEssenceCell", bundle: nil), forCellReuseIdentifier: ID)
    }
    func setRefresh(){
        //头部
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        header.setTitle("下拉刷新", forState: .Idle)
        header.setTitle("松手刷新", forState: .Pulling)
        header.setTitle("加载中...", forState: .Refreshing)
        header.stateLabel?.font = UIFont.systemFontOfSize(15)
        header.stateLabel?.textColor = UIColor.brownColor()
        header.automaticallyChangeAlpha = true
        tableView.mj_header = header
        
        //底部
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        footer.setTitle("正在加载更多数据", forState: MJRefreshState.Refreshing)
        footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        footer.automaticallyHidden = true
        footer.stateLabel?.textColor = UIColor.purpleColor()
        tableView.mj_footer = footer
    }
    //MARK: - 自定义方法
    func loadNewData(){
        setParameter()
        setParameterFirst()
        BSHttpTool.GETData(dict, success: { (object) -> () in
            let dict = object! as! [String : AnyObject]
                self.modelArray = self.anaylize(dict)
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
            }) { (error) -> () in
                print("\(error.description)")
                SVProgressHUD.showErrorWithStatus("请求失败")
                self.tableView.mj_header.endRefreshing()
        }
    }
    func loadMoreData(){
        setParameter()
        BSHttpTool.GETData(dict, success: { (object) -> () in
            let swiftArr = self.anaylize(object! as! [String : AnyObject]) as NSArray
            for model in swiftArr
                {
                    self.modelArray.append(model)
                }
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing()
            }) { (_) -> () in
                SVProgressHUD.showErrorWithStatus("请求失败")
                self.tableView.mj_footer.endRefreshing()
        }
    }
        //处理数据  -> Array<BSEssenceModel>
    func anaylize(dict : [String : AnyObject])-> [BSCommentModel] {
        //value中有些不是字符串
        let dict1 = dict["info"]! as! [String : AnyObject]
        maxtime = dict1["maxtime"] as? String
        let dataArray = dict["list"] as! [AnyObject]
        let arr = BSEssenceModel.mj_objectArrayWithKeyValuesArray(dataArray).copy() as! [BSCommentModel]
        return arr
    }
    
    func setParameter(){
        dict["a"] = aValue!
        dict["c"] = "data"
        dict["type"] = "\(type!.rawValue)"
        dict["maxtime"] = maxtime
    }
    
    func setParameterFirst(){
        //只加载第一页
        dict.removeValueForKey("maxtime")
    }
    
    //MARK: - 懒加载  属性
    var aValue :String?
    //maxtime
    var maxtime:String?
    //控制器类型
    var type:BSType?
    //模型数组
    var modelArray : [AnyObject] = Array()
    //参数字典
    var dict : [String : String] = Dictionary()
    let ID = "EssenceCell"
    let margin:CGFloat = 10
    let textW = screenWidth - 20
}

//MARK: - 协议、代理
extension BSEssenceBaseController{
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ID) as? BSEssenceCell
        let model = modelArray[indexPath.row] as! BSEssenceModel
        cell!.model = model
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let model = modelArray[indexPath.row] as! BSEssenceModel
        let textH = (NSString(string: model.text!)).size(UIFont.systemFontOfSize(15.0), maxW: textW).height
        var commentH : CGFloat = 0
        var hotComment : CGFloat = 0
        let top_cmt = model.top_cmt
        if top_cmt?.count > 0{
            let comment = top_cmt!.first!
            commentH = (NSString(string: comment.content!)).size(UIFont.systemFontOfSize(14.0), maxW: textW).height + 5
            hotComment = 20
        }
        var imageH : CGFloat = 0
        if Float(model.width!)!  !=  0 {
            imageH = CGFloat(NSString(string: model.height!).floatValue / NSString(string: model.width!).floatValue) * textW + margin
        }
        
        if model.isBigImage == true
        {
            imageH = screenHeight + margin
        }
        
        let cellHeight:CGFloat = margin + 50 + margin + textH + margin + imageH + margin + hotComment + commentH + 30
        return cellHeight
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let height = tableView.cellForRowAtIndexPath(indexPath)?.height
        let model = modelArray[indexPath.row] as! BSEssenceModel
        let Vc =  BSCommentViewController.init(style: UITableViewStyle.Grouped)
        Vc.cellHeight = height!
        Vc.model = model
        self.navigationController?.pushViewController(Vc, animated: true)
    }
}
