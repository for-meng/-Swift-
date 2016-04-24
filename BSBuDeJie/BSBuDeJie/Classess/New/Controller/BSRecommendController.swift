//
//  BSRecommendController.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/20.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
import SVProgressHUD
class BSRecommendController: UITableViewController {
    //MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载数据
        loadData()
        tableView.registerNib(UINib.init(nibName: "BSRecommendCell", bundle: nil), forCellReuseIdentifier: ID)
    }
    //MARK: - 初始化方法
    
    //MARK: - 自定义方法
    //加载数据
    private func loadData(){
        let dict = ["a":"tag_recommend","c":"topic","action":"sub"]
        
        BSHttpTool .GETData(dict, success: {(object) -> () in
            self.analyzeData(object! as! NSArray)
            self.tableView.reloadData()
            }) { (_) -> () in
                SVProgressHUD.showErrorWithStatus("请求失败")
        }
    }
    //数据处理
    func analyzeData(object : NSArray){
//        let newObjecy = object as! Array<[String : String]>
        for dict in object
        {
            let model = BSRecommendModel.init(dict: dict as! NSDictionary)
            modelArray.append(model)
        }
    }
    
    //MARK: - 懒加载
    private let ID : String = "subTag"
    //如果没有初始化 则必须赋值
    lazy var modelArray:[BSRecommendModel] = Array()
}


//MARK: - 协议、代理
extension BSRecommendController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ID) as! BSRecommendCell
        let model = modelArray[indexPath.row]
        cell.model = model
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}

class BSRecommendModel: NSObject {
    init(dict : NSDictionary) {
        super.init()
        setValuesForKeysWithDictionary(dict as! [String : AnyObject])
    }
    override init() {
        super.init()
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
 /// 头像
    var image_list:String?
 /// 名称
    var theme_name:String?
 /// 订阅数
    var _sub_number:String?
    var sub_number:String?{
        get{
            let num = (_sub_number! as NSString).longLongValue
            if num < 1000{
                return "\(num)人订阅"
            }else{
                let count = num / Int64(10000.0)
                return "\(count)万人订阅"
            }
        }
        set{
            _sub_number = newValue
        }
    }
}