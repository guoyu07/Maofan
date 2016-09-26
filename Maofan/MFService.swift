//
//  MFService.swift
//  Maofan
//
//  Created by Catt Liu on 16/9/26.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import OAuthSwift

class MFService: AnyObject {
    
    private static var FanfouConsumerKey: String = FanfouConsumer.key
    private static var FanfouConsumerSecret: String = FanfouConsumer.secret
    
    public typealias Success = OAuthSwiftHTTPRequest.SuccessHandler
    public typealias Failure = OAuthSwiftHTTPRequest.FailureHandler
    
    private var client: OAuthSwiftClient
    static var sharedInstance = MFService()
    
    init() {
        client = OAuthSwiftClient(consumerKey: MFService.FanfouConsumerKey, consumerSecret: MFService.FanfouConsumerSecret)
    }
    
    func xauthorize(username: String, password: String) {
        let oauthSwift = OAuth1Swift(consumerKey: MFService.FanfouConsumerKey, consumerSecret: MFService.FanfouConsumerSecret, accessTokenUrl: "http://fanfou.com/oauth/access_token")
        oauthSwift.xauthorizeWithUsername(username: username, password: password, success: { (credential, response, parameters) in
            print("authorize succeed with token: \(credential.oauth_token) and secret: \(credential.oauth_token_secret)")
            self.client = oauthSwift.client
            }, failure:{ (error) in
                print("authorize failure with error: \(error)")
        })
    }
    
    func postText(parameters: [String: String], success: Success?, failure: Failure?) {
        let urlString = "http://api.fanfou.com/statuses/update.json"
        self.client.mf_postText(urlString: urlString, parameters: parameters, success: success, failure: failure)
    }
    
    func postImage(parameters: [String: String], image: Data, success: Success?, failure: Failure?) {
        let urlString = "http://api.fanfou.com/photos/upload.json"
        self.client.mf_postImage(urlString: urlString, parameters: parameters, image: image, success: success, failure: failure)
    }
    
}
