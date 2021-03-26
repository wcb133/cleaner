//
//  CBOperationDataPieView.swift
//  CarBoss
//
//  Created by fst on 2019/8/27.
//  Copyright © 2019 leon. All rights reserved.
//

import Foundation

class CBDataOperationPieView: UIView {
    fileprivate let animateTimeInterval:CFTimeInterval = 0.9
    //圆弧宽度
    fileprivate let lineWidth:CGFloat = 9
    //圆弧中心半径
    fileprivate let radius:CGFloat = 95
    //圆弧渐变色
    var arcFromColor:UIColor?
    var arcToColor:UIColor?
    
    let tipslab = UILabel()
    
    lazy var circleView: UIView = {
        let w = radius * 2 - lineWidth - 40
        let circleView = UIView()
        circleView.layer.backgroundColor = UIColor.white.cgColor
        circleView.layer.cornerRadius = w * 0.5
        circleView.layer.shadowColor = UIColor.black.cgColor
        circleView.layer.shadowOffset = CGSize(width: 0, height: 0)
        circleView.layer.shadowRadius = 8
        circleView.layer.shadowOpacity = 0.2
        self.addSubview(circleView)
        circleView.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
            m.width.height.equalTo(w)
        }
        return circleView
    }()
    
    fileprivate lazy var percentLab:UICountingLabel = {
        let lab = UICountingLabel()
        lab.textAlignment = .center
        circleView.addSubview(lab)
        lab.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalTo(23)
            m.width.equalToSuperview().offset(-8)
        }
        lab.animationDuration = animateTimeInterval
        lab.method = .linear
        lab.attributedFormatBlock = {
            (value:CGFloat)-> NSAttributedString in
            let percentString = String(format: "%0.0f%%", value * 100)
            let attrPercentString = NSMutableAttributedString(string: percentString)
            attrPercentString.addAttributes([.font : UIFont.boldSystemFont(ofSize: 42),.foregroundColor : HEX("#28B3FF")], range: NSRange(location: 0, length: percentString.count))
            attrPercentString.addAttributes([.font : UIFont.boldSystemFont(ofSize: 18)], range: NSRange(location: percentString.count - 1, length: 1))
            return attrPercentString
        }
        return lab
    }()
    
    lazy var memoryUseLab:UILabel = {
        let lab = UILabel()
        lab.text = "--"
        lab.textAlignment = .center
        lab.textColor = HEX("#28B3FF")
        lab.font = .systemFont(ofSize: 14)
        circleView.addSubview(lab)
        lab.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalTo(self.percentLab.snp.bottom).offset(6)
            m.width.equalToSuperview().offset(-8)
        }
        
        
        tipslab.text = "已使用"
        tipslab.textAlignment = .center
        tipslab.textColor = HEX("#28B3FF")
        tipslab.font = .systemFont(ofSize: 14)
        circleView.addSubview(tipslab)
        tipslab.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalTo(lab.snp.bottom).offset(8)
            m.width.equalToSuperview().offset(-8)
        }
        
        return lab
    }()
    
    var circleLayer:CAShapeLayer?
    
    weak var circleShapeLayer:CAShapeLayer?
    
    weak var gradientLayer:CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arcFromColor = HEX("F15D64")
        arcToColor = HEX("FDCC33")
        self.circleView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(percent:CGFloat) {
        self.layoutIfNeeded()
        DispatchQueue.main.async {
            let arcCenter = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)
            //这一步是为了让图形好看
            let tmpPercent = percent > 0.96 &&  percent < 1.0 ? 0.96:percent
            let path = UIBezierPath(arcCenter: arcCenter, radius: self.radius, startAngle: 1.5 * .pi + (self.lineWidth * 0.5) / self.radius, endAngle: 1.5 * .pi + tmpPercent * .pi * 2, clockwise: true)
            //灰色背景圆环
            self.addBgLayer(arcCenter: arcCenter)
            self.addArcCircleLayer(path: path,percent: tmpPercent)
            
            
            if tmpPercent > 0.75 {
                self.percentLab.attributedFormatBlock = {
                    (value:CGFloat)-> NSAttributedString in
                    let percentString = String(format: "%0.0f%%", value * 100)
                    let attrPercentString = NSMutableAttributedString(string: percentString)
                    attrPercentString.addAttributes([.font : UIFont.boldSystemFont(ofSize: 42),.foregroundColor : HEX("F15D64")], range: NSRange(location: 0, length: percentString.count))
                    attrPercentString.addAttributes([.font : UIFont.boldSystemFont(ofSize: 18)], range: NSRange(location: percentString.count - 1, length: 1))
                    return attrPercentString
                }
                
                self.memoryUseLab.textColor = HEX("F15D64")
                self.tipslab.textColor = HEX("F15D64")
                
            }else if percent < 0.75 && percent > 0.25 {
                self.percentLab.attributedFormatBlock = {
                    (value:CGFloat)-> NSAttributedString in
                    let percentString = String(format: "%0.0f%%", value * 100)
                    let attrPercentString = NSMutableAttributedString(string: percentString)
                    attrPercentString.addAttributes([.font : UIFont.boldSystemFont(ofSize: 42),.foregroundColor : HEX("FDCC33")], range: NSRange(location: 0, length: percentString.count))
                    attrPercentString.addAttributes([.font : UIFont.boldSystemFont(ofSize: 18)], range: NSRange(location: percentString.count - 1, length: 1))
                    return attrPercentString
                }
                self.memoryUseLab.textColor = HEX("FDCC33")
                self.tipslab.textColor = HEX("FDCC33")
            }else{
                self.percentLab.attributedFormatBlock = {
                    (value:CGFloat)-> NSAttributedString in
                    let percentString = String(format: "%0.0f%%", value * 100)
                    let attrPercentString = NSMutableAttributedString(string: percentString)
                    attrPercentString.addAttributes([.font : UIFont.boldSystemFont(ofSize: 42),.foregroundColor : HEX("#28B3FF")], range: NSRange(location: 0, length: percentString.count))
                    attrPercentString.addAttributes([.font : UIFont.boldSystemFont(ofSize: 18)], range: NSRange(location: percentString.count - 1, length: 1))
                    return attrPercentString
                }
                self.memoryUseLab.textColor = HEX("#28B3FF")
                self.tipslab.textColor = HEX("#28B3FF")
            }
            self.percentLab.countFromZero(to: percent)

        }
    }
    
    private func addBgLayer(arcCenter:CGPoint) {
        if self.circleLayer != nil { return }
        let bgLayer = CAShapeLayer()
        bgLayer.strokeColor = UIColor.qmui_color(withHexString: "ECEDEF")?.cgColor
        bgLayer.fillColor = UIColor.clear.cgColor
        bgLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
        bgLayer.lineWidth = 2
        layer.addSublayer(bgLayer)
        self.circleLayer = bgLayer
    }
    
    private  func addArcCircleLayer(path:UIBezierPath,percent:CGFloat)
    {
        self.circleShapeLayer?.removeFromSuperlayer()
        let shapeLayer = CAShapeLayer()
        self.circleShapeLayer = shapeLayer
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = lineWidth
        var offset:CGFloat = 0
        shapeLayer.lineCap =  .round
        if percent < 1.0 {
            shapeLayer.lineCap =  .round
        }else{
            offset = 0
        }
        
        //渐变图层
        
        let containerLayer = CALayer()
        
        self.gradientLayer?.removeFromSuperlayer()
        containerLayer.frame = self.bounds

        let thirstLayer = creatGradientLayer(fromColor: arcFromColor, toColor: arcToColor)
        thirstLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width * 0.5 - offset, height: self.bounds.size.height)
        
        let tmpFromColor = HEX("28B3FF")
        let toFromColor = HEX("FDCC33")
        let secondLayer = creatGradientLayer(fromColor: tmpFromColor, toColor: toFromColor)
        secondLayer.frame = CGRect(x: self.bounds.size.width * 0.5 - offset, y: 0, width: self.bounds.size.width * 0.5 + offset, height: self.bounds.size.height)
        
        containerLayer.addSublayer(secondLayer)
        containerLayer.addSublayer(thirstLayer)
        
        containerLayer.mask = shapeLayer
        layer.addSublayer(containerLayer)
        self.gradientLayer = containerLayer
        
        
        let strokeAnimation:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.duration = animateTimeInterval
        strokeAnimation.fillMode = .forwards
        shapeLayer.add(strokeAnimation, forKey: "stroke")
    }

    private func creatGradientLayer(fromColor:UIColor?,toColor:UIColor?) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        guard let from = fromColor else {
            return gradientLayer
        }
        guard let to = toColor else {
            return gradientLayer
        }
        gradientLayer.colors = [from.cgColor,to.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        return gradientLayer
    }
}
