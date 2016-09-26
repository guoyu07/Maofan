//
//  OAuthSwiftClientExtension.swift
//  OAuthSwift
//
//  Created by Catt Liu on 16/9/26.
//  Copyright © 2016年 Dongri Jin. All rights reserved.
//

import Foundation

extension OAuthSwiftClient {
    
    public func mf_postText(urlString: String, parameters: [String: String], success: OAuthSwiftHTTPRequest.SuccessHandler?, failure: OAuthSwiftHTTPRequest.FailureHandler?) {
        self.mf_multiPartRequest(url: urlString, method: .POST, parameters: parameters, image: nil, success: success, failure: failure)
    }
    
    public func mf_postImage(urlString: String, parameters: [String: String], image: Data, success: OAuthSwiftHTTPRequest.SuccessHandler?, failure: OAuthSwiftHTTPRequest.FailureHandler?) {
        self.mf_multiPartRequest(url: urlString, method: .POST, parameters: parameters, image: image, success: success, failure: failure)
    }
    
    func mf_multiPartRequest(url: String, method: OAuthSwiftHTTPRequest.Method, parameters: [String:String], image: Data?, success: OAuthSwiftHTTPRequest.SuccessHandler?, failure: OAuthSwiftHTTPRequest.FailureHandler?) {
        let boundary = "AS-boundary-\(arc4random())-\(arc4random())"
        let type = "multipart/form-data; boundary=\(boundary)"
        var paramImage: [String: AnyObject] = [:]
        if let image = image {
            paramImage["media"] = image as AnyObject
        }
        let body = self.mf_multiPartBodyFromParams(boundary: boundary, parameters: parameters, paramImage: paramImage)
        let headers = [kHTTPHeaderContentType: type]
        let mf_hackEmptyParameter: [String: String] = [:]
        if let request = makeRequest(url, method: method, parameters: mf_hackEmptyParameter, headers: headers, body: body) { // TODO check if headers do not override others...
            request.successHandler = success
            request.failureHandler = failure
            request.start()
        }
    }
    
    func mf_multiPartBodyFromParams(boundary: String, parameters: [String: String], paramImage: [String: AnyObject]) -> Data {
        var data = Data()
        let prefixData = "--\(boundary)\r\n".data(using: OAuthSwiftDataEncoding)!
        let seperData = "\r\n".data(using: OAuthSwiftDataEncoding)!
        for (key, value) in parameters {
            // 1
            data.append(prefixData)
            // 2
            let sectionDisposition = "Content-Disposition: form-data; name=\"\(key)\"\r\n".data(using: OAuthSwiftDataEncoding)!
            data.append(sectionDisposition)
            let sectionContentType = "Content-Type: text/plain\r\n".data(using: OAuthSwiftDataEncoding)!
            data.append(sectionContentType)
            // 3
            data.append(seperData)
            // 4
            let value = "\(value)\r\n".data(using: OAuthSwiftDataEncoding)!
            data.append(value)
            data.append(seperData)
            // End
        }
        for (key, value) in paramImage {
            var sectionData: Data
            var sectionType: String?
            var sectionFilename = ""
            if key == "media" {
                let multiData = value as! Data
                sectionData = multiData
                sectionType = "image/jpeg"
                sectionFilename = " filename=\"MultiPartDataFromMaofan\"" //在这里任意指定文件名
            } else {
                sectionData = "\(value)".data(using: OAuthSwiftDataEncoding)!
            }
            // 1
            data.append(prefixData)
            // 2
            let sectionDisposition = "Content-Disposition: form-data; name=\"photo\";\(sectionFilename)\r\n".data(using: OAuthSwiftDataEncoding)! // 这里的 name 原本是 media，根据饭否 API 修改为 photo
            data.append(sectionDisposition)
            if let type = sectionType {
                let sectionContentType = "Content-Type: \(type)\r\n".data(using: OAuthSwiftDataEncoding)!
                data.append(sectionContentType)
            }
            // 3
            data.append(seperData)
            // 4
            data.append(sectionData)
            data.append(seperData)
            // End
        }
        // Finish
        data.append("--\(boundary)--\r\n".data(using: OAuthSwiftDataEncoding)!)
        return data
    }

}
