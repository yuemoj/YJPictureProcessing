//
//  UIImage+Extension.swift
//  YJPictureProcess
//
//  Created by Ace on 16/3/21.
//  Copyright © 2016年 Ace. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    /// 图片处理
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.Up {
            return self;
        }
        
        // transform
        var transform = CGAffineTransformIdentity;
        switch (self.imageOrientation) {
        case .Down:
            fallthrough;
        case .DownMirrored:
            // 根据指定的size大小----
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            // 旋转
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
        case .Left:
            fallthrough;
        case .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2));
        case .Right:
            fallthrough;
        case .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -CGFloat(M_PI_2));
        default:
            break;
        }
        
        // context
        let ctx = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height), CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage).rawValue);
        CGContextConcatCTM(ctx, transform);
        switch (self.imageOrientation) {
        case .Left:
            fallthrough;
        case .LeftMirrored:
            fallthrough;
        case .Right:
            fallthrough;
        case .RightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
        }
        
        // 创建一个新的UIImage对象
        let cgimg = CGBitmapContextCreateImage(ctx);
        let img = UIImage(CGImage: cgimg!);
        return img;
    }
}