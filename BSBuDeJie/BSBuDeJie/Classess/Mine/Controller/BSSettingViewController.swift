//
//  BSSettingViewController.swift
//  BSBuDeJie
//
//  Created by mh on 16/4/21.
//  Copyright © 2016年 BS. All rights reserved.
//

import UIKit

class BSSettingViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BSSettingViewController{
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ID = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID)
        if cell == nil
        {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: ID)
        }
        
        if indexPath.row == 0
        {
            let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
            let size = NSString(format: "%.2f", Double(BSFileManager.getDirectorySize(cachePath)) / 1000000.0)
            cell?.textLabel?.text = "清除缓存(\(size)"+"MB)"
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        BSFileManager.removeDirectoryPath(cachePath)
        tableView.reloadData()
    }
}