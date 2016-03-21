//
//  PhotoController.swift
//  YJPictureProcess
//
//  Created by Ace on 16/3/21.
//  Copyright © 2016年 Ace. All rights reserved.
//

import UIKit

class PhotoDealController:BasePublishController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    /// 照片
    lazy var photoImageView = UIImageView(frame: CGRectZero);
    /// 剪切窗口
    @IBOutlet weak var clipView: UIView!
    /// img资源
    var photoImage: UIImage?
    
    /// 照片上一次坐标
    var lastX: CGFloat = 0;
    var lastY: CGFloat = 0;
    
    /// PhotoImageView原尺寸
    var oldWidth: CGFloat = 0;
    var oldHeight: CGFloat = 0;
    /// photoImageView的实际尺寸
    var photoSize = CGSizeZero;
    /// 照片的原frame
    var oldFrame: CGRect = CGRectZero;
    
    var rate: CGFloat = 1.0;
    /// 缩放系数
    var scale: CGFloat = 1.0;
    /// 原缩放系数
    var oldScale: CGFloat = 1.0;
    
    /// 旋转系数
    var rotationCount:Int = 0;
    
    /// 用于其他页面回调
    var passImageClosure: ImageClosure?
    
    // MARK:- 控制器生命周期函数
    override func viewDidLoad() {
        //UI设置
        self.setupUI();
        //数据初始化
        self.initData();
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    // MARK:- 初始化相关
    /// 数据初始化
    func initData() {
        if let imageGet = self.photoImage {
            let img = imageGet.fixOrientation();
            // 根据图片的实际大小记录photoImageView的size
            self.rate = img.size.width/img.size.height
            if rate >= 1 {
                self.photoImageView.frame = CGRectMake(0, 0, kScreenMainWidth*rate, kScreenMainWidth);
            } else {
                self.photoImageView.frame = CGRectMake(0, 0, kScreenMainWidth, kScreenMainWidth/rate);
            }
            //            self.photoImageView.contentMode = UIViewContentMode.ScaleAspectFill;
            self.photoImageView.image = img;
            self.view.addSubview(self.photoImageView);
            self.photoImageView.image = img;
            self.oldFrame = self.photoImageView.frame;
            
            self.oldWidth = self.photoImageView.width;
            self.oldHeight = self.photoImageView.height;
        }
    }
    
    /// ui设置
    func setupUI() {
        //        self.view.backgroundColor = UIColor(hexString: "#666666");
        self.navigationItem.title = "预览";
        //imageView手势拖动手势添加
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panAction:");
        //imageView缩放手势添加
        let pinch: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "pinchAction:");
        self.clipView.addGestureRecognizer(pan);
        self.clipView.addGestureRecognizer(pinch);
    }
    
    // MARK:- 触发事件相关处理
    // MARK: imageView手势
    /// 拖动手势
    func panAction(pan: UIPanGestureRecognizer) {
        let translatedPoint = pan.translationInView(self.photoImageView);
        if pan.state == UIGestureRecognizerState.Began {
            self.lastX = self.photoImageView.frame.origin.x;
            self.lastY = self.photoImageView.frame.origin.y;
        }
        var x: CGFloat = lastX + translatedPoint.x;
        var y: CGFloat = lastY + translatedPoint.y;
        let width = self.photoImageView.width;
        let height = self.photoImageView.height;
        
        if x >= 0 {
            x = 0;
        }
        if x <= kScreenMainWidth - width {
            x = kScreenMainWidth - width;
        }
        
        if y >= 0 {
            y = 0;
        }
        if y <= kScreenMainWidth - height {
            y = kScreenMainWidth - height;
        }
        
        self.photoImageView.center = CGPointMake(x+width/2, y+height/2);
        if pan.state == UIGestureRecognizerState.Ended {
            self.oldFrame = CGRectMake(x, y, self.oldFrame.width, self.oldFrame.height);
        }
    }
    
    /// 缩放手势
    func pinchAction(pin: UIPinchGestureRecognizer) {
        if pin.state == UIGestureRecognizerState.Began {
            self.oldScale = self.scale;
        }
        self.scale = self.oldScale + pin.scale - 1;
        if self.scale >= 3.0 {
            self.scale = 3.0;
        } else if self.scale <= 1.0 {
            self.scale = 1.0;
        }
        
        var x = self.oldFrame.origin.x;
        var y = self.oldFrame.origin.y;
        let width = self.oldFrame.width*scale;
        let height = self.oldFrame.height*scale;
        
        if x > 0 {
            x = 0;
        }
        if x < kScreenMainWidth - width {
            x = kScreenMainWidth - width;
        }
        
        if y > 0 {
            y = 0;
        }
        if y < kScreenMainWidth - height {
            y = kScreenMainWidth - height;
        }
        
        self.photoImageView.frame = CGRectMake(x, y, width, height);
    }
    
    // MARK: btn点击事件
    /// 旋转btn点击事件
    @IBAction func rotationAction(sender: UIButton) {
        if ++self.rotationCount == 4 {
            self.rotationCount = 0;
        }
        
        var type:UIImageOrientation
        switch self.rotationCount {
        case 1:
            type = .Right
        case 2:
            type = .Down
        case 3:
            type = .Left
        default:
            type = .Up
        }
        let newImg = UIImage(CGImage: (self.photoImageView.image?.CGImage)!, scale:1, orientation: type);
        self.photoImageView.frame = CGRectMake(0, 0, self.photoImageView.height, self.photoImageView.width);
        self.oldFrame = CGRectMake(0, 0, self.oldFrame.height, self.oldFrame.width);
        self.photoImageView.image = newImg;
    }
    
    ///confirm
    @IBAction func confirmAction(sender: UIButton) {
        let photoImg = self.photoImageView.image!;
        let maxWH_img = max(photoImg.size.width, photoImg.size.height);
        let minWH_img = min(photoImg.size.width, photoImg.size.height);
        let maxWH_imgView = max(self.photoImageView.width, self.photoImageView.height);
        //        _ = max(self.photoImageView.width, self.photoImageView.height);
        
        var x: CGFloat = 0;
        var y: CGFloat = 0;
        var type:UIImageOrientation
        switch self.rotationCount {
        case 1:
            type = .Right;
            x = -self.photoImageView.y * maxWH_img / maxWH_imgView;
            if self.rate >= 1 {
                y = minWH_img - minWH_img / self.scale + self.photoImageView.x * maxWH_img / maxWH_imgView;
            } else {
                y = maxWH_img - minWH_img / self.scale + self.photoImageView.x * maxWH_img / maxWH_imgView;
            }
        case 2:
            type = .Down;
            x = minWH_img - minWH_img / self.scale + self.photoImageView.x * maxWH_img / maxWH_imgView;
            if self.rate >= 1 {
                y = minWH_img - minWH_img / self.scale + self.photoImageView.y * maxWH_img / maxWH_imgView;
            } else {
                y = maxWH_img - minWH_img / self.scale + self.photoImageView.y * maxWH_img / maxWH_imgView;
            }
        case 3:
            type = .Left;
            if self.rate >= 1 {
                x = maxWH_img - minWH_img / self.scale + self.photoImageView.y * maxWH_img / maxWH_imgView;
            } else {
                x = minWH_img - minWH_img / self.scale + self.photoImageView.y * maxWH_img / maxWH_imgView;
            }
            y = -self.photoImageView.x * maxWH_img / maxWH_imgView;
        default:
            type = .Up;
            x = -self.photoImageView.x * maxWH_img / maxWH_imgView;
            y = -self.photoImageView.y * maxWH_img / maxWH_imgView;
        }
        let rect = CGRectMake(x, y, minWH_img/self.scale , minWH_img/self.scale);
        let cropImg = UIImage(CGImage: CGImageCreateWithImageInRect(photoImg.CGImage, rect)!, scale:0.05, orientation:type);
        UIGraphicsBeginImageContext(CGSizeMake(kScreenMainWidth, kScreenMainWidth));
        cropImg.drawInRect(CGRectMake(0, 0, kScreenMainWidth, kScreenMainWidth));
        UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if let imgClosure = self.passImageClosure {
            imgClosure(image: cropImg);
        }
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil);        
    }
    
    ///cancel
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
}
