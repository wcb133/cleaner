//
//  NSMutableAttributedString+CSExtension.swift
//  CarStaff
//
//  Created by fst on 2020/4/9.
//  Copyright © 2020 fst. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    /// 设置文本高亮
    /// - Parameters:
    ///   - normal: 包含高亮文字的字符串
    ///   - highLight: 需要高亮的文字字符串
    ///   - font: 字体大小
    ///   - color: 普通文字颜色
    ///   - highLightColor: 高亮文字颜色
    static func highText(_ normal: String, highLight: String, font: UIFont, color: UIColor, highLightColor: UIColor) -> NSMutableAttributedString {
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let strings = normal.components(separatedBy: highLight)
        
        for i in 0..<strings.count {
            let item = strings[i]
            let dict = [NSAttributedString.Key.font: font,
                        NSAttributedString.Key.foregroundColor: color]
            
            let content = NSAttributedString(string: item, attributes: dict)
            attributedStrM.append(content)
            
            if i != strings.count - 1 {
                let dict1 = [NSAttributedString.Key.font: font,
                             NSAttributedString.Key.foregroundColor: highLightColor]
                
                let content2 = NSAttributedString(string: highLight,
                                                  attributes: dict1)
                attributedStrM.append(content2)
            }
        }
        return attributedStrM
    }
    
    /// 设置文本高亮
    /// - Parameters:
    ///   - normal: 包含高亮文字的字符串
    ///   - highLight: 需要高亮的文字字符串
    ///   - font: 普通字体大小
    ///   - highLightFont:高亮文字字体大小
    ///   - color: 普通文字颜色
    ///   - highLightColor: 高亮文字颜色
    static func highLightText(_ normal: String, highLight: String, font: UIFont,highLightFont:UIFont, color: UIColor, highLightColor: UIColor) -> NSMutableAttributedString {
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let strings = normal.components(separatedBy: highLight)
        
        for i in 0..<strings.count {
            let item = strings[i]
            let dict = [NSAttributedString.Key.font: font,
                        NSAttributedString.Key.foregroundColor: color]
            
            let content = NSAttributedString(string: item, attributes: dict)
            attributedStrM.append(content)
            
            if i == 0 {//避免多个高亮，只高亮第一个
                let dict1 = [NSAttributedString.Key.font: highLightFont,
                             NSAttributedString.Key.foregroundColor: highLightColor]
                
                let content2 = NSAttributedString(string: highLight,
                                                  attributes: dict1)
                attributedStrM.append(content2)
            }else if i != strings.count - 1 {
                let dict1 = [NSAttributedString.Key.font: font,
                             NSAttributedString.Key.foregroundColor: color]
                
                let content2 = NSAttributedString(string: highLight,
                                                  attributes: dict1)
                attributedStrM.append(content2)
            }
        }
        return attributedStrM
    }
}

