//
//  ApiError.swift
//  Smart2Pay Example
//
//  Created by David Jupijn on 05/11/2018.
//  Copyright © 2018 David Jupijn. All rights reserved.
//


import UIKit

import Foundation
import SwiftyJSON
import Alamofire

class ApiError {
  var nsError: NSError = NSError(domain: Bundle.main.bundleIdentifier!, code: -1, userInfo: nil)
  var message: String?
  var statusCode: Int?
  var params: [String: AnyObject]?

  var description: String {
    return "message: \(message!) statusCode: \(statusCode!)"
  }

  convenience init(response: AFDataResponse<Any>) {
    self.init()
    update(response)
  }

  convenience init(response: AFDataResponse<Any>, error: NSError, params: [String: AnyObject]?) {
    self.init(response: response)
    self.nsError = error
    self.params = params
  }

  func update(_ response: AFDataResponse<Any>) {
    do {
        let json = try JSON(data: response.data!)
        print(json["errors"])
        let errors = json["errors"].dictionaryValue
        for key in errors {
            for errorMessage in key.1 {
                if message == nil {
                    message = "\(errorMessage.1)"
                } else {
                    message!.append("\n\(errorMessage.1)")
                }
            }
        }
        
        if message == nil {
            message = String(data: response.data!, encoding: String.Encoding.utf8)
        }
        
        statusCode = response.response?.statusCode ?? 0
    } catch {
        print("Error in update of APIERROR: \(error)")
    }
    
  }
}
