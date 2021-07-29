//
//  BaseService.swift
//  Smart2Pay Example
//
//  Created by David Jupijn on 05/11/2018.
//  Copyright © 2018 David Jupijn. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseService {
  static var manager = BaseService.getManager()
  static var cachedManager = BaseService.getCachedManager()
  static var urlCache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)

  //static func getManager() -> Session {
  static func getManager() -> SessionManager {
    let configuration = defaultSessionConfiguration()
    configuration.urlCache = nil
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    //return Session(configuration: configuration)
    return SessionManager(configuration: configuration)
  }

  //static func getCachedManager() -> Session {
  static func getCachedManager() -> SessionManager {
    let configuration = defaultSessionConfiguration()
    configuration.urlCache = urlCache
    configuration.requestCachePolicy = .returnCacheDataElseLoad
//    return Session(configuration: configuration)
    return SessionManager(configuration: configuration)
  }

  static func resetManagers() {
    self.manager = BaseService.getManager()
    self.cachedManager = BaseService.getCachedManager()
  }

  private static func defaultSessionConfiguration() -> URLSessionConfiguration {
    //var defaultHeaders = Session.default.session.configuration.httpAdditionalHeaders ?? [:]
    var defaultHeaders = SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
    defaultHeaders["Authorization"] = "\(apiToken)"

    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = defaultHeaders

    return configuration
  }

  // MARK - Error handling helpers

  //static func apiErrorFor(_ response: AFDataResponse<Any>, error: NSError, params: [String: AnyObject]?) -> ApiError {
  static func apiErrorFor(_ response: DataResponse<Any>, error: NSError, params: [String: AnyObject]?) -> ApiError {
//    LogInfo("BaseService: \(#function)")
    let apiError = ApiError(response: response, error: error, params: params)
    if apiError.message == nil {
      apiError.message = error.localizedDescription
    }
    return apiError
  }

  static func jsonContainsSuccess(_ value: AnyObject?) -> Bool {
//    LogInfo("BaseService: \(#function)")
    if value != nil {
      let json = JSON(value!)
      return json["success"].boolValue
    }

    return false
  }
}
//Basic MzAwMDc6ZUhzSkxodEw1ZDk0TGlJUHdYYkpFbUpVY0dmbDkyRXc3OXRKOXQ0ZEMwMG05UFhYOUE=
