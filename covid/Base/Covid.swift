//
//  Data.swift
//  Covid-19
//
//  Created by 김현인 on 2020/09/12.
//  Copyright © 2020 HyunInKim. All rights reserved.
//

import SwiftyXMLParser

extension Covid {
    struct Person {
        let accDefRate: Double
        let accExamCnt: Int
        let accExamCompCnt: Int
        let careCnt: Int
        let clearCnt: Int
        let createDt: String
        let deathCnt: Int
        let decideCnt: Int
        let examCnt: Int
        let resutlNegCnt: Int
        let seq: Int
        let stateDt: String
        let stateTime: String
       
        
        init(xml: XML.Accessor) {
            accDefRate =     xml["accDefRate"].double ?? 0.0
            accExamCnt =     xml["accExamCnt"].int ?? 0
            accExamCompCnt = xml["accExamCompCnt"].int ?? 0
            careCnt =        xml["careCnt"].int ?? 0
            clearCnt =       xml["clearCnt"].int ?? 0
            createDt =       xml["createDt"].text ?? ""
            deathCnt =       xml["deathCnt"].int ?? 0
            decideCnt =      xml["decideCnt"].int ?? 0
            examCnt =        xml["examCnt"].int ?? 0
            resutlNegCnt =   xml["resutlNegCnt"].int ?? 0
            seq =            xml["seq"].int ?? 0
            stateDt =        xml["stateDt"].text ?? ""
            stateTime =      xml["stateTime"].text ?? ""
            
            
        }
    }
}
struct Covid {
    let code: String
    let message: String
    let totalCount: String
    let itemList: [Covid.Person]
    
    init(data: Data) {
        let xml = XML.parse(data)
        
        let header = xml["response","header"]
        let body = xml["response","body"]
            
        code = header["resultCode"].text ?? ""
        message = header["resultMsg"].text ?? ""
        totalCount = body["totalCount"].text ?? ""
        
        itemList = body["items","item"].compactMap {
            return Person(xml: $0)
        }
    }
}

