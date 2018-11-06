//
//  Parser.swift
//  Smart2Pay Example
//
//  Created by David Jupijn on 05/11/2018.
//  Copyright © 2018 David Jupijn. All rights reserved.
//

import UIKit
import SwiftyJSON

class Parser {

//  static func parseLine(json: JSON) -> Line {
//    let line = Line()
//    line.id = json["id"].intValue
//    line.externalId = json["external_id"].intValue
//    line.name = json["name"].stringValue
//    line.info = json["description"].stringValue
//    line.dayBonus = json["day_bonus"].floatValue
//    line.productionBonus = json["production_bonus"].floatValue
//    line.last5MinutesBonus = json["past_5_minutes_state"].floatValue
//    line.progress = json["progress"].floatValue
//    line.estimatedMinutesRemaining = json["estimated_minutes_remaining"].intValue
//
//    return line
//  }
//
//  static func parseMaintenance(json: JSON) -> Maintenance {
//    let maintenance = Maintenance()
//    maintenance.id = json["id"].intValue
//    maintenance.date = json["date"].stringValue
//    maintenance.mileage = json["mileage"].intValue
//    maintenance.regular = json["regular"].boolValue
//    maintenance.replacedBlades = json["replaced_blades"].boolValue
//    maintenance.replacedBinderhead = json["replaced_binderhead"].boolValue
//    maintenance.interruption = json["interruption"].boolValue
//
//    return maintenance
//  }
//
//  static func parseBinder(json: JSON) -> Binder {
//    let binder = Binder()
//    binder.id = json["id"].intValue
//    binder.name = json["number"].stringValue
//    binder.requireMaintenance = json["require_maintenance"].boolValue
//    binder.site = Parser.parseSite(json: json["site"])
//    binder.latestRegularMaintenance = Parser.parseMaintenance(json: json["latest_regular_maintenance"])
//    binder.latestMaintenance = Parser.parseMaintenance(json: json["latest_maintenance"])
//
//    return binder
//  }
//
//  static func parseSite(json: JSON) -> Site {
//    let site = Site()
//    site.id = json["id"].intValue
//    site.externalId = json["external_id"].intValue
//    site.name = json["name"].stringValue
//
//    return site
//  }
//
//  static func parseLineResult(json: JSON) -> LineResult {
//    let lineResult = LineResult()
//    lineResult.bonusDay = json["day_bonus"].floatValue
//    lineResult.bonusProduction = json["production_bonus"].floatValue
//    lineResult.bonusLast5Minutes = json["past_5_minutes_state"].floatValue
//
//    return lineResult
//  }
//
//  static func parseLineProgress(json: JSON) -> LineProgress {
//    let lineProgress = LineProgress()
//
//    lineProgress.productionProgress = json["progress"]["production_progress"].floatValue
//    lineProgress.processedAmount = json["progress"]["processed_amount"].stringValue
//    lineProgress.employeesAmount = json["progress"]["employees_amount"].stringValue
//    lineProgress.estimatedMinutesRemaining = json["estimated_minutes_remaining"].intValue
//    lineProgress.productionDescription = json["production_description"].stringValue
//    lineProgress.costPerBouquet = json["cost_per_bouquet"].floatValue
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//    let startedDate = dateFormatter.date(from: json["started_at"].stringValue)
//    let endedDate = dateFormatter.date(from: json["ended_at"].stringValue)
//    dateFormatter.dateFormat = "HH:mm"
//    if startedDate != nil {
//      lineProgress.startedAt = dateFormatter.string(from: startedDate!)
//    }
//
//    if endedDate != nil {
//      lineProgress.endedAt = dateFormatter.string(from: endedDate!)
//    }
//
//    return lineProgress
//  }
//
//  static func parseBinderToJSON(_ binder: Binder) -> [String: Any] {
//    var params: [String: Any] = [:]
//    var maintenanceParams: [String: Any] = [:]
//
//    if let binderMaintenance = binder.currentMaintenance {
//      maintenanceParams["mileage"] = binderMaintenance.mileage
//      maintenanceParams["regular"] = binderMaintenance.regular
//      maintenanceParams["replaced_blades"] = binderMaintenance.replacedBlades
//      maintenanceParams["replaced_binderhead"] = binderMaintenance.replacedBinderhead
//      maintenanceParams["interruption"] = binderMaintenance.interruption
//    }
//    params = ["maintenance": maintenanceParams]
//    return params
//  }
}
