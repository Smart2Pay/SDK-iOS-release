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
    var creditCard: CreditCard? = nil
    
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var creditCardView: CreditCardFormView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        paymentManager.set(urlScheme: urlScheme)
        
        self.perform(#selector(setupCreditCard), with: nil, afterDelay: 0.1)
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
        case 2:
            processCreditCard()
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
    
    // Credit Card
    
    @objc private func setupCreditCard() {
        
        creditCard = CreditCard(holderName: "John Doe", number: "4111111111111111", expirationMonth: 2, expirationYear: 2030, securityCode: "321")
        creditCardView.cardHolderString = creditCard!.holderName
        creditCardView.paymentCardTextFieldDidChange(cardNumber: creditCard!.number, expirationYear: creditCard!.expirationYear, expirationMonth: creditCard!.expirationMonth, cvc: creditCard!.securityCode)
        
    }
    
    private func processCreditCard() {
        // Get the API key first
        AuthorizationService.postAuthorizationApiKey(){ (apiKey, error) in
            if error == nil {
                print("Apikey: \(apiKey ?? "nil")" )
                self.paymentManager.authenticateCreditCard(self.creditCard!.getParameters(), apiKey: apiKey!, debug: true
                    , completionHandler: { (creditCardToken, error) in
                        if error != nil {
                            print(error!)
                        } else {
                            print("Credit Card Token: \(creditCardToken!)")
                        }
                })
            } else {
                print(error!)
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
