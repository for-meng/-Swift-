//
//  BSShareViewController.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/22.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit

class BSShareViewController: UIViewController {
    //MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加子控件
        addSubViews()
    }
    //MARK: - 初始化方法
    func addSubViews(){
        collectionView.registerClass(BSShareCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: ID)
        collectionView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "tap"))
        collectionView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        collectionView.backgroundColor = UIColor.whiteColor()
        view.addSubview(collectionView)
       
        cancelBtn.sizeToFit()
        cancelBtn.center.x = view.centerX
        cancelBtn.center.y = screenHeight * 0.9
        collectionView.addSubview(cancelBtn)
    }
    //MARK: - 自定义方法
    func cancel(){
        if !isLayout
        {
            isLayout = true
            collectionView.reloadData()
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    func tap(){
        cancel()
    }
    
    //MARK: - 懒加载
    lazy var cancelBtn : UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage(named: "shareButtonCancel"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "shareButtonCancelClick"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: "cancel", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    lazy var dict : NSDictionary = {
        let diction = [
            "发声音"   : "publish-audio",
            "审帖"     : "publish-review",
            "离线下载"  : "publish-offline",
            "视频"     : "publish-video",
            "发图片"   : "publish-picture",
            "发段子"   : "publish-text"]
        return diction
    }()

    lazy var collectionView:UICollectionView = {
        let flow = BSCollectionViewLayout.init()
        let view = UICollectionView.init(frame: CGRectZero, collectionViewLayout:flow)
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    var isLayout:Bool = false
    let ID:String = "BSMoreCollectionCell"
}

let row = 2
let col = 3

//MARK: - 协议、代理
extension BSShareViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return row * col + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ID, forIndexPath: indexPath) as! BSShareCollectionViewCell
        let keys = dict.allKeys
        if (indexPath.item < (row * col))
        {
            let key = (keys[indexPath.item]) as! String
            cell.setImage(dict[key] as! String , title: key)
        }else {
            cell.setImage("app_slogan", title: nil)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cellY = cell.y
        let cellH = cell.height
        if (isLayout == false)
        {
            cell.frame.origin.y = -cellY
            animations({ () -> Void in
                    cell.frame.origin.y = cellY + cellH * 0.5
                }, completion: { (_) -> Void in
                    cell.frame.origin.y = cellY
                }, delay: Double(indexPath.row))
        }else {
            animations({ () -> Void in
                    cell.frame.origin.y = cellY - cellH * 0.5
                }, completion: { (_) -> Void in
                    cell.frame.origin.y = screenHeight
                }, delay: Double(indexPath.row))
        }
    }
    
    //执行cell动画
    func animations(animations: () -> Void, completion: (() -> Void)? , delay : Double){
        let time = (Int64)(Double((delay + 1.0) * 0.1) * Double(NSEC_PER_SEC))
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time), dispatch_get_main_queue(), { () -> Void in
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                    animations()
                }) { (_) -> Void in
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        completion!()
                        }, completion: nil)
            }
        })
    }
}

//MARK: - 自定义布局
class BSCollectionViewLayout: UICollectionViewLayout {
    let margin:CGFloat = 20
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arrM: Array<UICollectionViewLayoutAttributes> = Array()
        for (var i = 0; i < (col * row); i++)
        {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            arrM.append(layoutAttributesForItemAtIndexPath(indexPath)!)
        }
        let indexPath = NSIndexPath(forItem: (col * row), inSection: 0)
        let att = layoutAttributesForItemAtIndexPath(indexPath)
        att?.bounds = CGRectMake(0, 0, 200, 44)
        att?.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.3)
        arrM.append(att!)
        return arrM
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let itemW = (screenWidth - margin * CGFloat(col + 1)) / CGFloat(col)
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let itemX = CGFloat(indexPath.item % col) * (margin + itemW) + margin
        let itemY = CGFloat(row - 1 - indexPath.item / col) * (margin + itemW) + screenHeight * 0.4
        attributes.frame = CGRectMake(itemX, itemY, itemW, itemW)
        return attributes
    }
}
