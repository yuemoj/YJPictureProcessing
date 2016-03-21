//
//  Constant.swift
//  jiaxiaoxi
//
//  Created by Kevin Wang on 15/6/21.
//  Copyright (c) 2015年 Kevin Wang. All rights reserved.
//

import Foundation
import UIKit

let path = NSSearchPathForDirectoriesInDomains(
    .DocumentDirectory, .UserDomainMask, true
    ).first! as String

let dbPath = "\(path)/user.plist"

let fontName = "Helvetica-Light"

let kScreenMainWidth = UIScreen.mainScreen().bounds.width

let kScreenMainHeight = UIScreen.mainScreen().bounds.height

/// MARK:- ****************************** 闭包 ******************************

/// MARK: 无参 无返回值闭包
typealias VoidClosure = () -> Void;

/// MARK: Bool回调
typealias BoolClosure = (b: Bool) -> Void;

/// MARK: Int回调
typealias IntClosure = (i: Int) -> Void;

/// MARK: Float回调
typealias FloatClosure = (f: Float) -> Void;

/// MARK: String回调
typealias StringClosure = (text: String) -> Void;

/// MARK: Date回调
typealias DateClosure = (date: NSDate) -> Void;

/// MARK: Image回调
typealias ImageClosure = (image: UIImage) -> Void;

/// MARK: AlertAction回调
typealias AlertActionClosure = (action: UIAlertAction!) -> Void;

/// MARK: sender回调
typealias SenderClosure  = (sender: AnyObject) -> Void;

/****************************** 闭包end ******************************/
