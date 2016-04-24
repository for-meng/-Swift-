//
//  BSShareCollectionViewCell.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/22.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit

class BSShareCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews(){
        imageBtn.addTarget(self, action: "imageBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(imageBtn)
    }
    func imageBtnClick(){
        
    }
    //MARK: - 外部方法
    internal func setImage(imageName : String,title: String?){
        imageBtn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        if let str = title{
            if str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
            {
                imageBtn.setTitle(title, forState: UIControlState.Normal)
            }
        }
    }
    
    lazy var imageBtn:BSImageButton = {
        let btn = BSImageButton.init(frame: CGRectZero)
      btn.titleLabel?.textAlignment = NSTextAlignment.Center
      btn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
      btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
      btn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        return btn
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageBtn.frame = bounds
    }
}



//MARK: - 自定义Button
class BSImageButton:UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.x = 0
        imageView?.y = 0
        imageView?.width = width
        
        titleLabel?.y = CGRectGetMaxY((imageView?.frame)!)
        titleLabel?.x = 0
        titleLabel?.width = width
        titleLabel?.height = CGRectGetMaxX((titleLabel?.frame)!)
    }
}