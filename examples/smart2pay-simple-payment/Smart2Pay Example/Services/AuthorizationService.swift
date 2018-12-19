//
//  BindersService.swift
//  Smart2Pay Example
//
//  Created by David Jupijn on 18/12/2018.
//  Copyright © 2018 David Jupijn. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Smart2Pay

class AuthorizationService: BaseService {
    // Name might be a bit confusing. This is for getting the API Key!
    static func postAuthorizationApiKey(completionHandler: @escaping (_ apiKey: String?, _ error: ApiError?) -> Void) {
        let url = "\(apiURL)/api/authorization/apikey"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        manager.request(request)
            .validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        completionHandler(json["ApiKey"]["Value"].stringValue, nil)
                    }
                } else if response.result.isFailure {
                    let apiErrorResponse = apiErrorFor(response, error: response.result.error! as NSError, params: nil)
                    completionHandler(nil, apiErrorResponse)
                }
        }
    }
}
