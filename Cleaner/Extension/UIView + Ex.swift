//
//  UIView + Extension.swift
//  HippoCharge
//
//  Created by leon on 2020/5/15.
//  Copyright © 2020 leon. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func cornerWith(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 添加圆角和边框
    func cornerAndBorder(byRoundingCorners corners: UIRectCorner, radii: CGFloat, borderColor:CGColor, borderWidth:CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii)).cgPath
        self.layer.mask = maskLayer
        
        // Add border
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path // Reuse the Bezier path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }

}

extension UIView {
    
    /// 快速添加镂空View
    ///
    /// - Parameters:
    ///   - radius: 圆角半径(nil:默认半径)
    ///   - color: 背景颜色(nil:看自己又没有就自己 没有就去取父控件的)
    ///   - corners: 切除部分(nil:默认切4角)
    func addHollowOutView(_ radius: CGFloat? = nil, _ color: UIColor? = nil, _ corners: UIRectCorner? = nil) {
        let rect = bounds
        let backgroundView = UIView(frame: rect) // 创建背景View
        backgroundView.isUserInteractionEnabled = false // 不接收事件 不然会阻挡原始事件触发
        var currentcolor = color ?? backgroundColor // 设置颜色
        if currentcolor == nil { // 如果没设置背景色
            if let superView = self.superview { // 看看父控件是否存在 存在直接用父控件背景色
                currentcolor = superView.backgroundColor
            } else { // 不然给定白色
                currentcolor = UIColor.white
            }
        }
        backgroundView.backgroundColor = currentcolor
        let currentradius:CGFloat = radius ?? rect.size.height*0.5 // 设置圆角半径
        self.addSubview(backgroundView) // 添加遮罩层
        self.bringSubviewToFront(backgroundView) // 放置到最顶层

        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd //  奇偶层显示规则
        let basicPath = UIBezierPath(rect: rect) // 底色
        
        let radii = CGSize(width: currentradius, height: currentradius)
        let currentcorners = corners ?? [UIRectCorner.topRight,UIRectCorner.bottomRight,UIRectCorner.bottomLeft,UIRectCorner.topLeft]
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: currentcorners, cornerRadii: radii) // 镂空路径
        basicPath.append(maskPath) // 重叠
        maskLayer.path = basicPath.cgPath
        backgroundView.layer.mask = maskLayer
    }
}


/// 新增协议 用于View  LoadNibView
protocol LoadNibable {}

extension LoadNibable where Self : UIView {
    static func loadNib(_ nibname: String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
    
}
