//
//  BindersService.swift
//  Smart2Pay Example
//
//  Created by David Jupijn on 05/11/2018.
//  Copyright © 2018 David Jupijn. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Smart2Pay

class PaymentsService: BaseService {
    static func postPayments(_ parameters: [String: String], completionHandler: @escaping (_ json: JSON?, _ error: ApiError?) -> Void) {
        let url = "\(apiURL)/api/payments"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            manager.request(request)
                .validate()
                .responseJSON { response in
                    
                    switch response.result {
                        case .success(let value):
                            if let value = response.value {
                                let json = JSON(value)
                                completionHandler(json, nil)
                            }
                        case .failure(let error): break
                            // error handling
                            let apiErrorResponse = apiErrorFor(response, error: response.error! as NSError, params: nil)
                            completionHandler(nil, apiErrorResponse)
                        }
            }
        } catch {
            print(error)
        }
    }
    
    static func postPaymentsVerification(_ payment: Payment, _ body: [String: Any], completionHandler: @escaping (_ success: Bool, _ error: ApiError?) -> Void) {
        let url = "\(apiURL)/api/payments/\(payment.id)/verify"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            manager.request(request)
                .validate()
                .responseJSON { response in
                    switch response.result {
                        case .success(let value):
                            let dict = response.value! as! [String: Any]
                            
                            if dict["status"] as! String == "Success" {
                                completionHandler(true, nil)
                            } else {
                                completionHandler(false, nil)
                            }
                        case .failure(let error): break
                            // error handling
                            let apiErrorResponse = apiErrorFor(response, error: response.error! as NSError, params: nil)
                            completionHandler(false, apiErrorResponse)
                        }
                    
                }
        } catch {
            print(error)
        }
    }
}
