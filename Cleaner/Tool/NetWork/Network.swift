//
//  CBService.swift
//  RxSwiftLogin
//
//  Created by fst on 2019/12/23.
//  Copyright © 2019 fst. All rights reserved.
//

import UIKit
import Moya
import QMUIKit

struct Network {
    // 请求成功的回调
    typealias successCallback = (_ result: Any) -> Void
    // 请求失败的回调
    typealias failureCallback = (_ error: MoyaError) -> Void
    
    //设置请求超时时间
    static let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<HRService>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            //这里的超时最好根据不同网络下，设置不同的值
            if let url = request.url {
                   request.timeoutInterval = 30
            }
            done(.success(request))
        } catch {
            return
        }
    }
    //设置了超时时间的
    static let provider = MoyaProvider<HRService>(requestClosure: requestTimeoutClosure)

    // 发送网络请求
    static func request(
        target: HRService,
        success: @escaping successCallback,
        failure: @escaping failureCallback
        ) {
        
        provider.request(target) { result in
            switch result {
            case let .success(moyaResponse):
                if  let responseJson = try? moyaResponse.mapJSON() {// 转成json数据
                    if let dict = responseJson as? [String:Any]{
                        success(dict)
                    }else if let array = responseJson as? [Any] {
                        success(array)
                    }
                }else if let image = try? moyaResponse.mapImage() {//转成图片文件
                    success(image)
                }else {//报错
                        QMUITips.hideAllTips()
                        failure(MoyaError.jsonMapping(moyaResponse))
                        QMUITips.showError(moyaResponse.description)
                }
            case let .failure(error):
                QMUITips.hideAllTips()
                failure(error)
                if error.localizedDescription.contains("The Internet connection appears to be offline") {
                    QMUITips.showError("网络断开连接，请检查网络！")
                }else {
                    QMUITips.showError(error.errorDescription)
                }
            }
        }
    }
}

// 定义请求方法
struct HRService {
    
    var url:String = ""
    var paramer:[String:Any] = [:]
    var requesMethod:Moya.Method = .get
    var imgArray:[UIImage]?
    
    init(url:String,paramer:[String:Any],requesMethod:Moya.Method) {
        self.url = url
        self.paramer = paramer
        self.requesMethod = requesMethod
    }
    
  init(url:String,paramer:[String:Any],requesMethod:Moya.Method,imgArray:[UIImage]) {
        self.url = url
        self.paramer = paramer
        self.requesMethod = requesMethod
        self.imgArray = imgArray
    }
    
}

extension HRService: TargetType {
    
    // 请求服务器的根路径
    var baseURL: URL { return URL(string: self.url)! }

    // 每个API对应的具体路径
    var path: String {
       return ""
    }
    
    // 各个接口的请求方式，get或post
    var method: Moya.Method {
        return self.requesMethod
    }
    
    // 请求是否携带参数
    var task: Task {
        switch self.requesMethod {
        case .post:
            if let imgs = self.imgArray {//有图片数组，则进行图片上传
                var multipartData:[MultipartFormData] = []
                for img in imgs {
                    //图片转成Data
                    guard let imgData:Data = img.jpegData(compressionQuality: 0.3) else {
                        print("传入的图片转data失败")
                        return .requestPlain
                    }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyyMMddHHmmss"
                    let dateString = formatter.string(from: Date())
                    let fileName = dateString + ".png"
                    let formData = MultipartFormData(provider: .data(imgData), name: "file",fileName: fileName, mimeType: "image/png")
                    multipartData.append(formData)
                }
                
                let parametersData = Network.bodyParts(self.paramer)
                multipartData.append(contentsOf: parametersData)
                return .uploadMultipart(multipartData)
            }else{//正常的post请求
                 return .requestParameters(parameters: self.paramer, encoding: JSONArrayEncoding.default)
            }
        case .get:
                return .requestParameters(parameters: self.paramer, encoding: URLEncoding.default)
        case .put:
            return .requestParameters(parameters: self.paramer, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    // 单元测试使用
    var sampleData: Data {
        return Data()
    }
    
    // 请求头
    var headers: [String : String]? {
           return ["Content-type" : "application/json"]
    }
}

extension Network {
    /// - Parameter params: 参数
    /// - Returns: MultipartFormData上传数据数组
   static func bodyParts(_ params: Dictionary<String , Any>) -> [MultipartFormData] {
        
        var datas:[MultipartFormData] = []
        for (key, value) in params {
            if let str = value as? String {
                let v = str.data(using: .utf8)!
                datas.append(MultipartFormData(provider: .data(v), name: key))
            }else if let intValue = value as? Int {
                let v = String(intValue).data(using: .utf8)!
                datas.append(MultipartFormData(provider: .data(v), name: key))
            }else if let doubleValue = value as? Double {
                let v = String(doubleValue).data(using: .utf8)!
                datas.append(MultipartFormData(provider: .data(v), name: key))
            }else if let floatValue = value as? Float {
                let v = String(floatValue).data(using: .utf8)!
                datas.append(MultipartFormData(provider: .data(v), name: key))
            }
        }
        return datas
    }
}


extension Network {
    ///用于接收非json数据返回字符串
    static func requestStringData(
        target: HRService,
        success: @escaping successCallback,
        failure: @escaping failureCallback
        ) {
        
        provider.request(target) { result in
            switch result {
            case let .success(moyaResponse):
                if  let responseJson = try? moyaResponse.mapString() {// 转成json数据
                   
                        success(responseJson)

                }else{
                        
                }
            case let .failure(error):
                QMUITips.hideAllTips()
                failure(error)
                QMUITips.showError(error.errorDescription)
            }
        }
    }
}

extension Network {
    ///用于接收Image文件
    static func requestImageData(
        target: HRService,
        success: @escaping successCallback,
        failure: @escaping failureCallback
        ) {
        
        provider.request(target) { result in
            switch result {
            case let .success(moyaResponse):
                if  let responseJson = try? moyaResponse.mapImage() {// 转成image数据
                   
                        success(responseJson)

                }else{
                        
                }
            case let .failure(error):
                QMUITips.hideAllTips()
                failure(error)
                QMUITips.showError(error.errorDescription)
            }
        }
    }
}
