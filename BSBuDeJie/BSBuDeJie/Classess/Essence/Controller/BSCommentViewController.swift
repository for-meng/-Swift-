
//
//  BSCommentViewController.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/24.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
import MJExtension
import MJRefresh
import SVProgressHUD
class BSCommentViewController: BSEssenceBaseController {
    //MARK: - 系统方法
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: - 初始化方法
    override func setting(){
        //注册两个Cell
        tableView.registerNib(UINib(nibName: "BSEssenceCell", bundle: nil), forCellReuseIdentifier: ID)
        tableView.registerNib(UINib.init(nibName: "BSCommentCell", bundle: nil), forCellReuseIdentifier: commentID)
        
//        tableView.contentInset = UIEdgeInsetsMake(NavBarHeight , 0, 0, 0)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(NavBarHeight, 0, 0, 0)
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 10;
        tableView.tableHeaderView = UIView.init(frame: CGRectMake(0, 0, 0, 10))
        title = "评论"
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //开始刷新
        tableView.mj_header.beginRefreshing()
    }
    
    //MARK: - 自定义方法
    //处理数据  -> Array<BSEssenceModel>
    override func anaylize(dict : [String : AnyObject])-> [BSCommentModel] {
        //value中有些不是字符串
        var arr : [BSCommentModel]?
        if dict.count > 0{
            //最后评论的id
            if let commentData = dict["data"] as? [AnyObject]{
                if let obj = commentData.last as? [String:AnyObject]{
                    lastcid = obj["id"] as? String
                }else {
                    lastcid = nil}
        arr = BSCommentModel.mj_objectArrayWithKeyValuesArray(commentData).copy() as? [BSCommentModel]
            }}
        return arr!
    }
    
    override func setParameter(){
        dict["a"] = "dataList"
        dict["c"] = "comment"
        dict["data_id"] = data_id!
        if let cid = lastcid{
            dict["lastcid"] = cid
        }
        dict["hot"] = "1"}
    
    override func setParameterFirst(){
        //只加载第一页
        dict.removeValueForKey("lastcid")}

    
    //MARK: - 懒加载  属性
    //帖子ID
    var data_id:String?{
        get{
          return model?.ID
        }
    }
    //最后评论id
    var lastcid :String?
    let commentID = "commentCell"
    //当前行高
    var cellHeight :CGFloat = 0
    //当前帖子模型
    var model : BSEssenceModel?
    lazy var label : UILabel = {
        let label = UILabel()
        label.height = 20
        label.textAlignment = NSTextAlignment.Left
        label.textColor = UIColor.blueColor()
        return label
    }()
}
//MARK: - 协议、代理
extension BSCommentViewController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(ID) as! BSEssenceCell
            cell.model = model
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier(commentID) as! BSCommentCell
            let model = modelArray[indexPath.row]
            cell.model = model as? BSCommentModel
            return cell
        }else {
            let hotModel = model?.top_cmt![indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(commentID) as! BSCommentCell
            cell.model = hotModel
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return cellHeight
        }else if indexPath.section == 1{
            return 60
        }
        
        let commentCellHeight = margin + 60
        
        return commentCellHeight
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else if section == 1 {
            if model?.top_cmt?.count == 0 {
                return nil
            }
            label.text = "热门评论"
        }else if section == 2{
            if modelArray.count == 0 {
                return nil
            }
            label.text = "最新评论"
        }
        return label
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1 {
            return (model?.top_cmt?.count)!
        }
        return modelArray.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}