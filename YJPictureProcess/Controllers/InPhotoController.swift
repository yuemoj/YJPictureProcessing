//
//  InPhotoController.swift
//  YJPictureProcess
//
//  Created by Ace on 16/3/21.
//  Copyright © 2016年 Ace. All rights reserved.
//

import UIKit
import AssetsLibrary

class InPhotoController: BasePublishController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// 相册collectionView
    @IBOutlet weak var photoCllView: UICollectionView!
    
    /// 相册管理对象
    lazy var library = ALAssetsLibrary();
    /// 相片数组
    lazy var photoSource = [ALAsset]();
    
    var passImageClosure: ImageClosure?
    
    // MARK: - ========================= 控制器生命周期函数 =========================
    override func viewDidLoad() {
        super.viewDidLoad();
        self.setUI();
        self.initData();
    }
    
    // MARK: - ========================= 初始化相关 =========================
    func setUI() {
//        self.navigationItem.title = "导入图片"
    }
    
    func initData() {
        self.library.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: { (group: ALAssetsGroup!, stop) -> Void in
            if group != nil {
                group.enumerateAssetsUsingBlock({ (result: ALAsset!, index: Int, stop) -> Void in
                    if result != nil {
                        let s = result.valueForProperty(ALAssetPropertyType) as! String;
                        if s == ALAssetTypePhoto {
                            self.photoSource.append(result);
                        }
                    }
                });
                self.photoCllView.reloadData();
            }
        }) { (error) -> Void in
            print(error);
            self.navigationController?.popViewControllerAnimated(true);
            self.alert(self, message: "亲,相册授权没有打开,是否前往打开?!", confirmClosure: { (action) -> Void in
                self.openSetting();
                }, cancelClosure: { (action) -> Void in
                }
            );
            return;
        }
    }
    
    // MARK: - ========================= 代理方法相关 =========================
    /// 每组cell
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoSource.count;
    }
    
    /// 设置cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("InPhotoCllCell", forIndexPath: indexPath) as! InPhotoCllCell;
        
        // 取缩略图
        if indexPath.item < self.photoSource.count {
            let myAsset = self.photoSource[indexPath.item];
            let image = UIImage(CGImage: myAsset.thumbnail().takeUnretainedValue());
            // 填充cell
            photoCell.fillCellWithImage(image);
        }
        
        return photoCell;
    }
    
    /// 设置大小
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (kScreenMainWidth - 50) / 5;
        return CGSizeMake(width, width);
    }
    
    /// cell点击事件
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 取清晰图
        let myAsset = self.photoSource[indexPath.item];
        let image = UIImage(CGImage: myAsset.defaultRepresentation().fullScreenImage().takeUnretainedValue());
        // 控制器跳转
        if let photoDealController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("PhotoDeal") as? PhotoDealController {
            photoDealController.photoImage = image;
//            photoDealController.confirmType = self.confirmType;
            photoDealController.passImageClosure = self.passImageClosure;
            self.navigationController?.pushViewController(photoDealController, animated: true);
        }
    }
    
    // MARK: - ========================= 自定义方法 =========================
    func openSetting() {
        if let settingUrl = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(settingUrl);
        }
    }
    
    func alert(message: String) {
        let alertView = UIAlertView(title: "温馨提示", message: message, delegate: self, cancelButtonTitle: "确定");
        alertView.show();
    }
    
    func alert(relyController: UIViewController, message: String, confirmClosure: AlertActionClosure?=nil, cancelClosure: AlertActionClosure?=nil) {
        let alertController = UIAlertController(title: "温馨提示", message: message, preferredStyle: UIAlertControllerStyle.Alert);
        if let canc = cancelClosure {
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: canc);
            alertController.addAction(cancelAction);
        }
        if let conc = confirmClosure {
            let confirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: conc);
            alertController.addAction(confirmAction);
        }
        relyController.presentViewController(alertController, animated: false, completion: nil);
    }

}
