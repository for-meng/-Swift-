//
//  NSString+Extension.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/23.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit
extension NSString{
    func size(font : UIFont, maxW:CGFloat) ->CGSize{
        let maxSize = CGSizeMake(maxW, CGFloat.max)
        return boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
    }
    func size(font : UIFont) ->CGSize{
        return size(font, maxW: CGFloat.max)
    }
}
