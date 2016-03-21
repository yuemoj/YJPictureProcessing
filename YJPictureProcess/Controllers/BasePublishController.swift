//
//  BasePublishController.swift
//  YJPictureProcess
//
//  Created by Ace on 16/3/21.
//  Copyright © 2016年 Ace. All rights reserved.
//

import UIKit

class BasePublishController: UIViewController {
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController!.navigationBarHidden == true {
            self.navigationController!.navigationBarHidden = false;
        }
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController!.navigationBar.barTintColor = UIColor(hexString: "#484848");
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName: UIFont(name: fontName, size: 17)!];
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_nor"), style: UIBarButtonItemStyle.Plain, target: self, action: "popController")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor();
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor();
        /*  设置导航栏透明
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        */
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func popController() {
        if let _ = self.navigationController {
            self.navigationController!.popViewControllerAnimated(true);
            self.navigationController!.dismissViewControllerAnimated(true, completion: nil);
        }
      
    }
}
