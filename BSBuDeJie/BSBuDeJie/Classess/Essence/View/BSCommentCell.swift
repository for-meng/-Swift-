//
//  BSCommentCell.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/24.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit

class BSCommentCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var model : BSCommentModel?{
        didSet{
            iconImageView.sd_setImageWithURL(NSURL.init(string: (model?.user?.profile_image)!))
            nameLabel.setTitle(model?.user?.username, forState: UIControlState.Normal)
            text_Label.text = model?.content
            lovaLabel.text = model?.like_count
        }
    }
    @IBAction func loveButtonClick(sender: AnyObject) {
    }
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UIButton!
    @IBOutlet weak var text_Label: UILabel!
    @IBOutlet weak var lovaLabel: UILabel!
}
