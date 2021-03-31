//
//  BKOrderDetailBlueHeadView.swift
//  BankeBus
//
//  Created by jemi on 2020/12/30.
//  Copyright © 2020 jemi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BKOrderDetailBlueHeadView: UIView,LoadNibable {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    var time:RxSwift.Disposable?
    
    ///未知=0,未支付=1,已支付=2,已发货=3,已经签收=4,部分退款=5,已退款=7,已取消=9,完成=100,删除=1000
    var model = BKShopOrderModel() {
        didSet{
            
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let now:String = format.string(from: date)
            
            switch model.state {
            case 1:
                nameLabel.text = "订单未支付"
                let sc = dateInterval(0, startTime: now, endTime: model.closeOrderTime)
                timeTranS(sc)
                img.image = UIImage(named: "下单待支付")
            case 2:
                nameLabel.text = "待发货"
                timeLabel.text = "卖家已付款"
                img.image = UIImage(named: "order待发货")
            case 3:
                nameLabel.text = "卖家已发货"
                let sc = dateInterval(1, startTime: now, endTime: model.orderReceivingTime)
                timeLabel.text = "还剩\(sc)天自动确认"
                img.image = UIImage(named: "order已发货")
            case 4:
                nameLabel.text = "已签收"
                timeLabel.text = ""
                img.image = UIImage(named: "order等签收")
            case 6:
                nameLabel.text = "交易关闭"
                timeLabel.text = ""
                img.image = UIImage(named: "order等签收")
            case 7:
                nameLabel.text = "交易关闭"
                timeLabel.text = ""
                img.image = UIImage(named: "order等签收")
            case 9:
                nameLabel.text = "订单已关闭"
                timeLabel.text = ""
                img.image = UIImage(named: "订单关闭")
            case 100:
                nameLabel.text = "已签收"
                timeLabel.text = ""
                img.image = UIImage(named: "order等签收")
            default:
                nameLabel.text = "已签收"
                timeLabel.text = ""
                img.image = UIImage(named: "order等签收")
            }
        }
    }
    
    deinit {
        time?.dispose()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func dateInterval(_ type:Int,startTime:String,endTime:String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date1 = dateFormatter.date(from: startTime),
              let date2 = dateFormatter.date(from: endTime) else {
            return -1
        }
        let components = NSCalendar.current.dateComponents([.day,.second], from: date1, to: date2)
        //如果需要返回月份间隔，分钟间隔等等，只需要在dateComponents第一个参数后面加上相应的参数即可，示例如下：
    //    let components = NSCalendar.current.dateComponents([.month,.day,.hour,.minute], from: date1, to: date2)
        if type == 1 {
            return components.day!
        }
        return components.second!
    }

    
    func timeTranS(_ second:Int){
        
        time = countdown(second: second) {[weak self] (index) in
            debugPrint(Date())
            let s:Int = index % 60
            let min:Int = (index / 60) % 60
            self?.timeLabel.text = "还剩\(min)分钟\(s)秒自动关闭"
            debugPrint("倒计时：\(index)")
        }
        .subscribe(onSuccess: {[weak self] () in
            debugPrint(Date())
            debugPrint("倒计时结束")
            self?.nameLabel.text = "订单已关闭"
            self?.timeLabel.text = ""
            self?.img.image = UIImage(named: "订单关闭")
        }) { (error) in
            debugPrint("倒计时错误:\(error)")
        }
    }
    
    //MARK: -时间戳转时间函数
    func timeStampToString(timeStamp: Int)->String {
        ///天
        let days = Int(timeStamp/(3600*24))
        ///时
        let hours = Int((timeStamp - days*24*3600)/3600)
       
        let timeString = String(format: "还剩%d天%d时自动确认",days,hours)
        return timeString
    }
        
    
    /// 倒计时
    /// - Parameters:
    ///   - second: 倒计时的秒数
    ///   - immediately: 是否立即开始，true 时将立即开始倒计时，false 时将在 1 秒之后开始倒计时
    ///   - duration: 倒计时的过程
    /// - Returns: 倒计时结束时的通知
    func countdown(second: Int,
                   immediately: Bool = true,
                   duration: ((Int) -> Void)?) -> Single<Void> {
        guard second > 0 else {
            return Single<Void>.just(())
        }

        if immediately {
            duration?(second)
        }
        return Observable<Int>
            .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { second - (immediately ? ($0 + 1) : $0) }
            .take(second + (immediately ? 0 : 1))
            .do(onNext: { (index) in
                duration?(index)
            })
            .filter { return $0 == 0 }
            .map { _ in return () }
            .asSingle()
     }
    
    
    @IBAction func backAction(_ sender: Any) {
        AppBaseNav.currentNavigationController()?.popViewController(animated: true)
    }
}
