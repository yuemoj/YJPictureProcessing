//
//  InPhotoCllCell.swift
//  YJPictureProcess
//
//  Created by Ace on 16/3/21.
//  Copyright © 2016年 Ace. All rights reserved.
//

import UIKit

class InPhotoCllCell: UICollectionViewCell {
    /// 图片
    @IBOutlet weak var photoImgView: UIImageView!
    /// 信息label
    @IBOutlet weak var infoLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.photoImgView.layer.cornerRadius = 5.0;
        self.photoImgView.layer.borderColor = UIColor(hexString: "#e5e5e5")?.CGColor;
        self.photoImgView.layer.borderWidth = 1.0;
    }
    
    func fillCellWithImage(image: UIImage?) {
        if let img = image {
            self.photoImgView.image = img;
        }
    }
}
