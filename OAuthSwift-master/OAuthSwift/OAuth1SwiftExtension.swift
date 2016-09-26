//
//  OAuth1SwiftExtension.swift
//  OAuthSwift
//
//  Created by Catt Liu on 16/9/26.
//  Copyright © 2016年 Dongri Jin. All rights reserved.
//

import Foundation

extension OAuth1Swift {
    convenience public init(consumerKey: String, consumerSecret: String, accessTokenUrl: String) {
        self.init(consumerKey: consumerKey, consumerSecret: consumerSecret, requestTokenUrl: "", authorizeUrl: "", accessTokenUrl: accessTokenUrl)
    }
    
    public func xauthorizeWithUsername(username: String, password:String, success: @escaping TokenSuccessHandler, failure: FailureHandler?) {
        var parameters = Dictionary<String, Any>()
        parameters["x_auth_username"] = username
        parameters["x_auth_password"] = password
        parameters["x_auth_mode"] = "client_auth"
        let _ = self.client.post(
            self.access_token_url, parameters: parameters,
            success: { [weak self] data, response in
                guard let this = self else { OAuthSwift.retainError(failure); return }
                let responseString = String(data: data, encoding: String.Encoding.utf8)!
                let parameters = responseString.parametersFromQueryString()
                if let oauthToken=parameters["oauth_token"] {
                    this.client.credential.oauth_token = oauthToken.safeStringByRemovingPercentEncoding
                }
                if let oauthTokenSecret=parameters["oauth_token_secret"] {
                    this.client.credential.oauth_token_secret = oauthTokenSecret.safeStringByRemovingPercentEncoding
                }
                success(this.client.credential, response, parameters)
            }, failure: failure
        )
    }
}
