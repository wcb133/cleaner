//
//  JSONArrayEncoding.swift
//  CarStaff
//
//  Created by fst on 2020/4/16.
//  Copyright © 2020 fst. All rights reserved.
//

import Alamofire

//moya本身不支持数组作为参数，只支持字典作为参数，为了能使用数组作为参数，需要自定义一个编码类，外部传入的依旧是字典，但对于含有特定字段的字典，将会变成数组作为参数，例如字典中若包含key值为jsonArray的值，则只会将该key对应的value值发送给服务器
struct JSONArrayEncoding: ParameterEncoding {
    static let `default` = JSONArrayEncoding()

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()

        var dataJson:Any?
        
        if let json = parameters?["csjsonArray"] {
            dataJson = json
        }else if let para = parameters {
            dataJson = para
        }
        
        guard let tmpDataJson = dataJson else { return request }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: tmpDataJson, options: [])

            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            request.httpBody = data
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        return request
    }
}
