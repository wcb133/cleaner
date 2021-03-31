//
//  String+Extension.swift
//  HippoCharge
//
//  Created by fst on 2020/5/18.
//  Copyright © 2020 leon. All rights reserved.
//

import UIKit

extension String{
    //计算字符串占用空间大小
    func sizeWithText(font: UIFont, size: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size
    }
    
    /// 时间字符串格式转换
    /// - Parameters:
    ///   - fromDateFormat: 原本的时间格式
    ///   - toDateFormat: 目标时间格式
    func hc_dateFormater(fromDateFormat:String,toDateFormat:String) -> String{
        if self.isEmpty { return "" }
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = fromDateFormat
        if let date = dateformatter.date(from: self) {
            dateformatter.dateFormat = toDateFormat
            let s = dateformatter.string(from: date)
            return s
        }else{
            return ""
        }
    }
    
    ///车牌号校验含新能源
    func hc_valiryCarNum() -> Bool {
        let expression = "^(([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z](([0-9]{5}[DF])|([DF]([A-HJ-NP-Z0-9])[0-9]{4})))|([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z][A-HJ-NP-Z0-9]{4}[A-HJ-NP-Z0-9挂学警港澳使领]))$"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: self, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, (self as NSString).length))
        return numberOfMatches != 0
    }
    
    
    /// 向上取整，保留两位小数
    func hr_RoundFloatUp() ->String{
        
        let roundUp = NSDecimalNumberHandler(roundingMode: .up, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        let numLeft = NSDecimalNumber.init(string: self)
        let numRight = NSDecimalNumber.init(string: "1")
        let resultDec = numLeft.multiplying(by: numRight, withBehavior: roundUp)
        return NSString(format: "%@", resultDec) as String
    }
    
    func secretPhone() ->String {
        if self.isEmpty { return "" }
        if self.count >= 11 {
            let temp = self.suffix(8)
            return self.replacingOccurrences(of: temp, with: "********")
        }
        return ""
    }

}

extension String {
    /// 截取到任意位置
    func subString(to: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: to)
        return String(self[..<index])
    }
    /// 从任意位置开始截取
    func subString(from: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: from)
        return String(self[index ..< endIndex])
    }
    /// 从任意位置开始截取到任意位置
    func subString(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    //使用下标截取到任意位置
    subscript(to: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[..<index])
    }
    //使用下标从任意位置开始截取到任意位置
    subscript(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    
    
    
    /// 替换手机号中间四位
    ///
    /// - Returns: 替换后的值
    func replacePhone() -> String {
        if self.isEmpty { return "" }
        if self.count >= 11 {
            let start = self.index(self.startIndex, offsetBy: 3)
            let end = self.index(self.startIndex, offsetBy: 7)
            let range = Range(uncheckedBounds: (lower: start, upper: end))
            return self.replacingCharacters(in: range, with: "****")
        }
        return ""
    }
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
}
