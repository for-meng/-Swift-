//
//  BSRecommendCell.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/21.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
import SDWebImage
class BSRecommendCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model:BSRecommendModel?{
        didSet{
            if model?.image_list?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0{
            self.iconImage.sd_setImageWithURL(NSURL.init(string: (model?.image_list)!), placeholderImage: UIImage(named: "defaultUserIcon")) { (image, _, _, _) -> Void in
                self.iconImage.image = image.circleImage()
                }
            }
            self.nameLabel.text = model?.theme_name
            self.numLabel.text = model?.sub_number
        }
    }
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
}
