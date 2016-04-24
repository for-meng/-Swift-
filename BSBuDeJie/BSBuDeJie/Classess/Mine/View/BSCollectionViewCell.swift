//
//  BSCollectionViewCell.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/21.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
import SDWebImage
class BSCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var model:BSCollectionModel?{
        didSet{
            if let newModel = model{
                nameLabel.text = newModel.name
                iconImage.sd_setImageWithURL(NSURL.init(string: newModel.icon!))
            }
        }
    }
   
}
