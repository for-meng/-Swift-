//
//  BSScollerToolBar.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/20.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
class BSScollerToolBar: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0.8
        bounces = false
        scrollsToTop = false
        showsHorizontalScrollIndicator = false
        backgroundColor = UIColor(patternImage: UIImage(named: "navigationbarBackgroundWhite")!)
        addSubview(contentView)
    }
    
    func setTitleArray(titleDict : [BSType : String]){
        selectedBtn = addBtn(BSType.All, titleString: titleDict[BSType.All]!)
        addBtn(BSType.Video, titleString: titleDict[BSType.Video]!)
        addBtn(BSType.Voice, titleString: titleDict[BSType.Voice]!)
        addBtn(BSType.Picture, titleString: titleDict[BSType.Picture]!)
        addBtn(BSType.Article, titleString: titleDict[BSType.Article]!)
        //下划线
        addSubview(downView)
    }
    
    private func addBtn(type : BSType,titleString : String) ->BSButton{
        let btn : BSButton = BSButton.init()
        btn.setTitle(titleString, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
        btn.addTarget(self, action: "btnOnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        contentView.addSubview(btn)
        btn.tag = type.rawValue
        return btn
    }
    
    var selectedBtn: BSButton?
    var previousToolBarButton:BSButton?
    func btnOnClick(btn: BSButton) {
        selectedBtn!.selected = false
        btn.selected = true
        selectedBtn = btn
        scrollToolBardelegate?.scrollerToolBarButtonClick(self, type: BSType(rawValue: btn.tag)!)
        setNeedsLayout()
        if previousToolBarButton != btn
        {
            previousToolBarButton = btn
            return
        }
        NSNotificationCenter.defaultCenter().postNotificationName(BSToolBarRepeatClickNotification, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var btnX : CGFloat = 0
        let btnW : CGFloat = UIScreen.mainScreen().bounds.width / CGFloat(contentView.subviews.count)
        for btn : BSButton  in (contentView.subviews as! [BSButton])
        {
            btn.frame = CGRectMake(btnX, 0, btnW, bounds.height)
            btnX += btnW
        }
        self.contentView.frame = CGRectMake(0, 0, btnX, bounds.height)
        self.contentSize = CGSizeMake(btnX, bounds.height)
        
        //转换坐标系
        let newFrame: CGRect = (selectedBtn?.titleLabel?.convertRect((selectedBtn?.titleLabel?.bounds)!, toView: self))!
        UIView.animateWithDuration(0.1) { () -> Void in
            self.downView.frame = CGRectMake(newFrame.origin.x, self.bounds.height - 2, (self.selectedBtn?.titleLabel?.bounds.width)!, 2)
        }
    }
    
    //MARK: -懒加载 属性
    weak var scrollToolBardelegate : BSScrollerToolBarDelegate?
    private let contentView = UIView.init()
    lazy var downView : UIView = {
        let view: UIView = UIView.init()
        view.backgroundColor = UIColor.redColor()
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//代理，按钮点击       clas表示只能由类遵守协议（因为结构体也可以遵守䫔）
protocol BSScrollerToolBarDelegate : class{
    func scrollerToolBarButtonClick(toolBar:BSScollerToolBar,type:BSType)
}

class BSButton: UIButton,UIScrollViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        //去除高亮状态
        adjustsImageWhenHighlighted = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}