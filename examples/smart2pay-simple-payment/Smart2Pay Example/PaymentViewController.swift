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
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var creditCardView: CreditCardFormView!
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var creditCardTokenTextField: UITextField!
    @IBOutlet weak var authenticate3dButton: UIButton!
    
    private var forceWebChallenge = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        paymentManager.set(urlScheme: urlScheme)
        
        self.perform(#selector(setupCreditCard), with: nil, afterDelay: 0.1)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyboard)))
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
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
    
    @IBAction func fill(sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "Flow", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Force Web Challenge", style: .default, handler: { [weak self] (_) in
            self?.creditCardView.cardHolderString = "CL-BRW1"
            self?.cvvTextField.text = "123"
            self?.creditCard?.holderName = "CL-BRW1"
            self?.creditCard?.number = "5111426646345761"
            self?.creditCard?.securityCode = "123"
            self?.creditCard?.expirationYear = 2021
            self?.creditCard?.expirationMonth = 12
            self?.forceWebChallenge = true
            if let creditCard = self?.creditCard {
                self?.creditCardView.paymentCardTextFieldDidChange(
                    cardNumber: creditCard.number,
                    expirationYear: creditCard.expirationYear,
                    expirationMonth: creditCard.expirationMonth,
                    cvc: creditCard.securityCode
                )
            }
        }))
//        actionSheet.addAction(UIAlertAction(title: "Challenge", style: .default, handler: { [weak self] (_) in
//            self?.creditCardView.cardHolderString = "CL-APP1"
//            self?.cvvTextField.text = "123"
//            self?.creditCard?.holderName = "CL-APP1"
//            self?.creditCard?.number = "5111426646345761"
//            self?.creditCard?.securityCode = "123"
//            self?.creditCard?.expirationYear = 2021
//            self?.creditCard?.expirationMonth = 12
//            self?.forceWebChallenge = false
//            if let creditCard = self?.creditCard {
//                self?.creditCardView.paymentCardTextFieldDidChange(
//                    cardNumber: creditCard.number,
//                    expirationYear: creditCard.expirationYear,
//                    expirationMonth: creditCard.expirationMonth,
//                    cvc: creditCard.securityCode
//                )
//            }
//        }))
        actionSheet.addAction(UIAlertAction(title: "Frictionless", style: .default, handler: { [weak self] (_) in
            self?.creditCardView.cardHolderString = "FL-APP1"
            self?.cvvTextField.text = "123"
            self?.creditCard?.holderName = "FL-APP1"
            self?.creditCard?.number = "5111426646345761"
            self?.creditCard?.securityCode = "123"
            self?.creditCard?.expirationYear = 2021
            self?.creditCard?.expirationMonth = 12
            self?.forceWebChallenge = false
            if let creditCard = self?.creditCard {
                self?.creditCardView.paymentCardTextFieldDidChange(
                    cardNumber: creditCard.number,
                    expirationYear: creditCard.expirationYear,
                    expirationMonth: creditCard.expirationMonth,
                    cvc: creditCard.securityCode
                )
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "3Dv1", style: .default, handler: { [weak self] (_) in
            self?.creditCardView.cardHolderString = "CL-APP1"
            self?.cvvTextField.text = "123"
            self?.creditCard?.holderName = "CL-APP1"
            self?.creditCard?.number = "4407106439671112"
            self?.creditCard?.securityCode = "123"
            self?.creditCard?.expirationYear = 2021
            self?.creditCard?.expirationMonth = 12
            self?.forceWebChallenge = false
            if let creditCard = self?.creditCard {
                self?.creditCardView.paymentCardTextFieldDidChange(
                    cardNumber: creditCard.number,
                    expirationYear: creditCard.expirationYear,
                    expirationMonth: creditCard.expirationMonth,
                    cvc: creditCard.securityCode
                )
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            actionSheet.modalPresentationStyle = .popover
            actionSheet.popoverPresentationController?.sourceView = sender
        }
        
        present(actionSheet, animated: true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Auth3dViewController {
            destination.creditCardToken = creditCardTokenTextField.text
            destination.amount = amountTextField.text
            destination.currency = currencyTextField.text
            destination.cvv = cvvTextField.text
            destination.apiKey = apiKeyTextField.text
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
                debugPrint(#function, json?.stringValue ?? "json empty")
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
        creditCardView.paymentCardTextFieldDidChange(
            cardNumber: creditCard!.number,
            expirationYear: creditCard!.expirationYear,
            expirationMonth: creditCard!.expirationMonth,
            cvc: creditCard!.securityCode
        )
    }
    
    private func processCreditCard() {
        // Get the API key first
        AuthorizationService.postAuthorizationApiKey() { [weak self] (apiKey, error) in
            if let error = error {
                print(#function, "error = \(error)")
            } else if let apiKey = apiKey, let creditCard = self?.creditCard {
                print(#function, "apiKey: \(apiKey)")
                self?.apiKeyTextField.text = apiKey
                self?.paymentManager.authenticateCreditCard(creditCard.getParameters(), apiKey: apiKey, debug: true, completionHandler: { (creditCardToken, error) in
                    DispatchQueue.main.async {
                        self?.creditCardTokenTextField.text = creditCardToken
                        self?.setupAuth3dButtonAvailablility(apiKey: apiKey, ccToken: creditCardToken)
                    }
                    if let error = error {
                        print(#function, "Error code: \(error.statusCode ), message: \(error.message ?? "")")
                    } else {
                        print(#function, "Credit Card Token: \(creditCardToken!)")
                    }
                })
            } else {
                print(#function, "apiKey is nil")
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
    
    private func setupAuth3dButtonAvailablility(apiKey: String?, ccToken: String?) {
        guard let apiKey = apiKey, let ccToken = ccToken else {
            authenticate3dButton.isEnabled = false
            return
        }
        authenticate3dButton.isEnabled = !apiKey.isEmpty && !ccToken.isEmpty
    }
}

extension PaymentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        
        if textField == cvvTextField {
            creditCard?.securityCode = newText
            return true
        }
        
        switch textField {
        case apiKeyTextField:
            setupAuth3dButtonAvailablility(apiKey: newText, ccToken: creditCardTokenTextField.text)
        case creditCardTokenTextField:
            setupAuth3dButtonAvailablility(apiKey: apiKeyTextField.text, ccToken: newText)
        default:
            break
        }
        return true
    }
}
