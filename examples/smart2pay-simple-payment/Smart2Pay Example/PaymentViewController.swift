//
//  ViewController.swift
//  Smart2Pay Example
//
//  Created by David Jupijn on 02/11/2018.
//  Copyright © 2018 David Jupijn. All rights reserved.
//

import UIKit
import Smart2Pay
import SwiftyJSON

class PaymentViewController: UIViewController, PaymentManagerDelegate {
    let paymentManager = PaymentManager.shared
    
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        paymentManager.set(urlScheme: urlScheme)
    }
    
    private func pay(withType type: Payment.PaymentProvider) {
        if amountTextField.text != ""  {
            let order = Order()
            order.amount = Int(amountTextField.text!) ?? 11
            order.currency = currencyTextField.text ?? "CNY"
            order.type = type
            
            placeOrder(order: order)
        }
    }
    
    @IBAction func didClickPayButton(sender: UIButton) {
        switch sender.tag {
        case 0:
            pay(withType: .ALIPAY)
        case 1:
            pay(withType: .WECHAT)
        default:
            print("Make sure to place a correct tag on your pay button!")
        }
    }
    
    // MARK - Requests
    
    private func placeOrder(order: Order) {
        var orderParameters: [String: String] = [:]
        orderParameters["amount"] = "\(order.amount)"
        orderParameters["currency"] = order.currency
        orderParameters["methodID"] = "\(order.type.rawValue)"
        
        PaymentsService.postPayments(orderParameters) { (json, error) in
            if error == nil {
                print(json?.stringValue ?? "json empty")
                let payment = Payment(id: json!["id"].intValue)
                payment.currency = order.currency
                payment.amount = order.amount
                payment.type = order.type
                payment.instructions = json!["instructions"].stringValue
                payment.delegate = self
                
                self.paymentManager.pay(payment: payment)
            }
        }
    }
    
    private func verify(payment: Payment, body: [String: Any]) {
        PaymentsService.postPaymentsVerification(payment, body) { (success, error) in
            if success {
                print("Payment verified! :D")
            }
        }
    }
    
    // MARK - PaymentManagerDelegate
    
    func onPaymentSuccess(_ payment: Payment, _ body: [String: Any]) {
        print("onPaymentSuccess :)")
        verify(payment: payment, body: body)
    }
    
    func onPaymentFailure(_ payment: Payment) {
        print("onPaymentFailure :(")
    }
}

