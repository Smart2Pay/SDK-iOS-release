//
//  CreditCard.swift
//  Smart2Pay Example
//
//  Created by David Jupijn on 21/12/2018.
//  Copyright © 2018 David Jupijn. All rights reserved.
//

import UIKit

class CreditCard: NSObject {
    var holderName = ""
    var number = ""
    var expirationMonth = UInt(0)
    var expirationYear = UInt(0)
    var securityCode = ""
    
    convenience init(holderName: String, number: String, expirationMonth: UInt, expirationYear: UInt, securityCode: String) {
        self.init()
        self.holderName = holderName
        self.number = number
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.securityCode = securityCode
    }

    func getParameters() -> [String: Any] {
        var body: [String: Any]  = [:]
        var cardAuthentication: [String: Any]  = [:]
        var customer: [String: Any]  = [:]
        var billingAddress: [String: Any]  = [:]
        var card: [String: Any]  = [:]
        
        customer["FirstName"] = "John"
        customer["LastName"] = "Doe"
        customer["Email"] = "ios@sdktest.com"
        customer["SocialSecurityNumber"] = "00003456789"
        
        billingAddress["Country"] = "BR"
        
        card["HolderName"] = holderName
        card["Number"] = number
        card["ExpirationMonth"] = expirationMonth
        card["ExpirationYear"] = expirationYear
        card["SecurityCode"] = securityCode
        
        cardAuthentication["Customer"] = customer
        cardAuthentication["BillingAddress"] = billingAddress
        cardAuthentication["Card"] = card
        
        body["CardAuthentication"] = cardAuthentication
        
        return body
    }
}
