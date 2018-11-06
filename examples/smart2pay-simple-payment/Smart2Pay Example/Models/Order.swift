//
//  Order.swift
//  Smart2Pay Example
//
//  Created by David Jupijn on 05/11/2018.
//  Copyright © 2018 David Jupijn. All rights reserved.
//

import UIKit
import Smart2Pay

class Order: NSObject {
    var type = Payment.PaymentProvider.NONE
    var amount: Int = 0
    var currency: String = ""
}
