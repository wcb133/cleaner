//
//  UIButton + Extension.swift
//  HippoCharge
//
//  Created by leon on 2020/5/27.
//  Copyright © 2020 leon. All rights reserved.
//

import Foundation
import UIKit

/**
 扩大Button点击范围  设置clickEdgeInsets
 */
extension UIButton {
    
    private struct RuntimeKey {
        static let clickEdgeInsets = UnsafeRawPointer.init(bitPattern: "clickEdgeInsets".hashValue)
        /// ...其他Key声明
    }
    /// 需要扩充的点击边距
    public var clickEdgeInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
    }
    // 重写系统方法修改点击区域
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        var bounds = self.bounds
        if (clickEdgeInsets != nil) {
            let x: CGFloat = -(clickEdgeInsets?.left ?? 0)
            let y: CGFloat = -(clickEdgeInsets?.top ?? 0)
            let width: CGFloat = bounds.width + (clickEdgeInsets?.left ?? 0) + (clickEdgeInsets?.right ?? 0)
            let height: CGFloat = bounds.height + (clickEdgeInsets?.top ?? 0) + (clickEdgeInsets?.bottom ?? 0)
            bounds = CGRect(x: x, y: y, width: width, height: height) //负值是方法响应范围
        }
        return bounds.contains(point)
    }
}


extension UIButton {
    /** 部分圆角
     * - corners: 需要实现为圆角的角，可传入多个
     * - radii: 圆角半径
     */
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
