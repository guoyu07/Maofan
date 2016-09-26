//
//  ViewController.swift
//  Maofan
//
//  Created by Catt Liu on 16/9/8.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MFService.sharedInstance.xauthorize(username: FanfouConsumer.username, password: FanfouConsumer.password)
    }
    
    // MARK: 测试发消息和图片
    @IBAction func helloButtonDidTouch(_ sender: AnyObject) {
        let parameters = [
            "format": "html",
            "status": "Hello, world! \(arc4random())"
        ]
        MFService.sharedInstance.postText(parameters: parameters, success: nil, failure: nil)
//        let image = UIImageJPEGRepresentation(UIImage(named: "ImageTest")!, 0.1)!
//        MFService.sharedInstance.postImage(parameters: parameters, image: image, success: nil, failure: nil)
    }

}

