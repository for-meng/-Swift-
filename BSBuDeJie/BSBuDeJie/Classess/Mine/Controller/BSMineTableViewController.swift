//
//  BSMineTableViewController.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/20.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
import WebKit
class BSMineTableViewController: UITableViewController {
    //MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航条
        setupNavBar()
        //设置底部视图
        setFootView()
        //请求数据
        loadData()
    }
    //MARK: - 初始化方法
    private func setupNavBar(){
        let settingItem = UIBarButtonItem.itemWithTarget(self, action: "setting", image: "mine-setting-icon", highlightImage: "mine-setting-icon-click")
        let nightItem = UIBarButtonItem.itemWithTarget(self, action: "night:", image: "mine-moon-icon", seletedImage:"mine-moon-icon-click")
        navigationItem.rightBarButtonItems = [settingItem,nightItem]
        
        self.navigationItem.title = "我的"
        
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 10;
        tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0)
    }
    
    //底部视图
    let ID  = "CollectionCell"
    private func setFootView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib.init(nibName: "BSCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ID)
        tableView.tableFooterView = collectionView
    }
    
    //MARK: - 自定义方法
    private func loadData(){
        BSHttpTool.GETData(["a" : "square","c" : "topic"], success: { (object) -> () in
            self.analyseData(object as! [String : NSObject])
            self.collectionView.reloadData()
            }) { (error) -> () in
            print("\(error)")
        }
    }
    ///处理数据
    func analyseData(diction : [String : NSObject]){
        dataArray.removeAll()
        let dataArr = diction["square_list"] as! Array<[String : String]>
        for modeldata in dataArr
        {
            let model =  BSCollectionModel.init(dict: modeldata)
            dataArray.append(model)
        }
        
        let count = dataArray.count
        let num = (count - 1) / 4 + 1
        collectionView.bounds.size.height = itemSizeWH * CGFloat(num) + CGFloat((num - 1) * 1)
        tableView.tableFooterView = collectionView;
        
        var extre = count % 4
        if extre != 0{
          extre = 4 - extre
            for _ in 0..<extre{
                let model = BSCollectionModel.init()
                dataArray.append(model)
            }
        }
    }
    
    func setting(){
      let Vc = UIStoryboard.init(name: "BSSettingViewController", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(Vc!, animated: true)
    }
    
    func night(btn : UIButton){
            btn.selected = !btn.selected
    }
    
    private let itemSizeWH: CGFloat = CGFloat((screenWidth -  CGFloat((4 - 1) * 1)) / 4)
    //MARK: - 懒加载
    lazy var dataArray : Array<BSCollectionModel>  = Array()
    lazy var collectionView:UICollectionView = {
        let flow = UICollectionViewFlowLayout.init()
        let collectionV = UICollectionView.init(frame: CGRectMake(0, 0, 0, 500), collectionViewLayout: flow)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 1
        flow.itemSize = CGSizeMake(self.itemSizeWH, self.itemSizeWH)
        collectionV.scrollsToTop = false
        collectionV.scrollEnabled = false
        collectionV.backgroundColor = UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0)
        return collectionV
    }()
}
//MARK: - 协议、代理
extension BSMineTableViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model:BSCollectionModel = self.dataArray[indexPath.item]
        //空模型就不要赋值
        if model.name?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
        if ((model.url?.containsString("http")) == false){
            return
        }
        let Vc = BSWebViewController()
        Vc.url = NSURL.init(string: model.url!)
        self.navigationController?.pushViewController(Vc, animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ID, forIndexPath: indexPath) as! BSCollectionViewCell
        let model = self.dataArray[indexPath.row]
        //空模型就不要赋值
        if model.name?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0{
            cell.model = model
        }
        return cell
    }
}

//MARK: - 模型
class BSCollectionModel : NSObject{
    //icon
    var icon : String?
    //name
    var name : String?
    //url
    var url : String?
    
    init(dict : [String :String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override init() {
        super.init()
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

//网页跳转控制器
class BSWebViewController: UIViewController {
    //MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    //MARK: - 初始化方法
    private func setUp(){
        webView.frame = view.bounds
        view.insertSubview(webView, atIndex: 0)
        let request = NSURLRequest.init(URL: url!)
        webView.loadRequest(request)
        
        //  监听进度
        webView .addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
        progressView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, 2)
        view.addSubview(progressView)
    }
    //KVO监听
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.hidden = progressView.progress >= 1
    }
 /// 控制器销毁
    deinit{
        webView.removeObserver(self, forKeyPath:"estimatedProgress")
    }
    
    //MARK: - 懒加载
    var url : NSURL?
    lazy var progressView = UIProgressView.init(progressViewStyle: UIProgressViewStyle.Bar)
    lazy var webView : WKWebView = WKWebView()
}



