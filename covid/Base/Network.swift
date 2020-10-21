//
//  Network.swift
//  covid
//
//  Created by 김현인 on 2020/10/12.
//

import Foundation
import Alamofire

class Network {
    static let shared = Network()
    private init() {}
    
    private var serviceKey: String = "V0gkf%2Bht8OFhiv%2Bd75Da0vhpyv15AZcnswUwqdRjRL%2Fdy1yhxWVdMeLc7x%2BaOvon087McqgXReWjBZOWmOuwnQ%3D%3D"
    public func getCovidStatus(pageNo: Int, numberOfRows: Int, startCreateDt: String, endCreateDt: String, handler: ((Covid?) -> Void)? = nil) {
        
        let deocdeKey =  serviceKey.removingPercentEncoding ?? ""
        let requestURL: String = "http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson"
        
        let parameter: [String : Any] = [
            "ServiceKey" : deocdeKey,
            "pageNo" : pageNo,
            "numberOfRows" : numberOfRows,
            "startCreateDt" : startCreateDt,
            "endCreateDt" : endCreateDt
        ]
        
        Alamofire.request(requestURL, method: .get, parameters: parameter)
            .responseData { (response) in
                var covid: Covid?
                defer {
                    handler?(covid)
                }
                switch response.result {
                case .success(let result):
                    covid = Covid(data: result)
                case .failure(let error):
                    print(error.localizedDescription, error)
                }
            }
        
    }
}
