//
//  File.swift
//  CarBoss
//
//  Created by leon on 2019/8/20.
//  Copyright © 2019 leon. All rights reserved.
//

import Foundation
import UIKit
import QMUIKit


let cScreenWidth = UIScreen.main.bounds.size.width
let cScreenHeight = UIScreen.main.bounds.size.height

//iPhone X
let iPhoneX = cScreenHeight >= 812.0 ? true : false
//导航栏高度
let cNavigationHeight = CGFloat(iPhoneX ? 88.0 : 64.0)
// tabBar高度
let cTabbarHeight = CGFloat(iPhoneX ? (49.0 + 34.0) : 49.0)
// home indicator
let cIndicatorHeight  = CGFloat(iPhoneX ? 34.0 : 0.0)
//状态栏高度
let cStatusHeight = UIApplication.shared.statusBarFrame.size.height
//顶部整体高度
let cNaviTopHeight = cStatusHeight + cNavigationHeight

let cMainGrayColor = UIColor.qmui_color(withHexString: "#F6F9FC")

///测试服务器标签
let TestTag = "BankeBus_test"
///正式环境标签
let ReleaseTag = "BankeBus_release"
///测试服务器别名
let TestAlia = "test_"
///正式环境别名
let ReleaseAlia = "release_"

//主窗口
let cKeyWindow = UIApplication.shared.keyWindow

func localizedString(_ string:String) -> String {
    return NSLocalizedString(string, comment: "")
}

func HEX(_ String:String) -> UIColor {
    return UIColor.qmui_color(withHexString: String)!
}

func MediumFont(size:CGFloat) -> UIFont? {
    return UIFont(name: "PingFang-SC-Medium", size: size)
}

func RGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) ->UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

func ImageWith(_ name:String) -> UIImage {
    return UIImage(named: name) ?? UIImage()
}

func BoldFontSize(_ size:CGFloat) -> UIFont {
    return UIFont.init(name: "PingFang-SC-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
}

func ratioWidth(width f:CGFloat) -> CGFloat {
    return floor(f*100/375.0*cScreenWidth)/100
}

func ratioHeight(height h:CGFloat) -> CGFloat {
    return floor(h*100/667.0*cScreenHeight)/100
}

func acceptRatioWidth(width w:CGFloat) -> CGFloat {
    return cScreenWidth > 375 ? ratioWidth(width: w) : w
}

func acceptRatioHeight(height h:CGFloat) -> CGFloat {
    return cScreenHeight > 667 ? ratioHeight(height: h) : h
}
