//
//  ViewController.swift
//  YJPictureProcess
//
//  Created by Ace on 16/3/21.
//  Copyright © 2016年 Ace. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var selectBtn: UIButton!
    // MARK: - 控制器生命周期函数 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setUI();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 初始化相关
    func setUI() {
        self.selectBtn.addTarget(self, action: "importPictureAction", forControlEvents: .TouchUpInside);
    }

    // MARK: - button点击及手势
    func importPictureAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle());
        if let inPhotoController = storyboard.instantiateViewControllerWithIdentifier("InPhotoController") as? InPhotoController {
            let nav = UINavigationController(rootViewController: inPhotoController);
            self.presentViewController(nav, animated: true, completion: { () -> Void in
                inPhotoController.passImageClosure = {
                    self.selectedImageView.image = $0;
                }
            });
        }
    }
}

