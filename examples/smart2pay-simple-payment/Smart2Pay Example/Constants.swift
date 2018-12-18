//
//  Contants.swift
//  Smart2Pay Example
//
//  Created by David Jupijn on 05/11/2018.
//  Copyright © 2018 David Jupijn. All rights reserved.
//


import UIKit
import Foundation


let apiURL = "https://s2pmerchantserver.azurewebsites.net"
let apiToken = "Basic UzJwTWVyY2hhbnRTZXJ2ZXI6UzJwTWVyY2hhbnRTZXJ2ZXJQYXNzd29yZA=="
let wechatAppId = "wxb91c84b6c4d2e07b"
let urlScheme = "com.smart2pay.example"

func dummyCreditCardData() -> [String: Any] {
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
    
    card["HolderName"] = "John Doe"
    card["Number"] = "4111111111111111"
    card["ExpirationMonth"] = "02"
    card["ExpirationYear"] = "2019"
    card["SecurityCode"] = "321"
    
    cardAuthentication["Customer"] = customer
    cardAuthentication["BillingAddress"] = billingAddress
    cardAuthentication["Card"] = card
    
    body["CardAuthentication"] = cardAuthentication
    
    return body
}

// Move to SDK!
let cardAuthenticationApiUrl = "https://secure.smart2pay.com/v1/card/authenticate/"
let debugCardAuthenticationApiUrl = "https://securetest.smart2pay.com/v1/card/authenticate/"

