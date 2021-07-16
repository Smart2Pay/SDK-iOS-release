//
//  Auth3dViewController.swift
//  Smart2Pay Example
//
//  Created by Michael Kessler on 14/07/2021.
//  Copyright © 2021 David Jupijn. All rights reserved.
//

import UIKit
import Smart2Pay

class Auth3dViewController: UIViewController {

    var creditCardToken: String!
    var amount: String!
    var currency: String!
    var cvv: String!
    var apiKey: String!

    @IBOutlet weak var creditCardTokenTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var merchantIdTextField: UITextField!
    @IBOutlet weak var merchantSiteIdTextField: UITextField!
    
    @IBOutlet weak var auth3dButton: UIButton!
    
    @IBOutlet weak var resultTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        creditCardTokenTextField.text = creditCardToken
        amountTextField.text = amount
        currencyTextField.text = currency
        cvvTextField.text = cvv
    }
    
    @IBAction func authenticate3d() {
        guard
            let creditCardToken = creditCardTokenTextField.text,
            let cvv = cvvTextField.text,
            let amount = amountTextField.text,
            let currency = currencyTextField.text,
            let apiKey = apiKey
        else { return }
        
        self.resultTextView.text = "Input:"
            + "\n- creditCardToken: \(creditCardToken)"
            + "\n- cvv: \(cvv)"
            + "\n- amount: \(amount)"
            + "\n- currency: \(currency)"
            + "\n- apiKey: \(apiKey)"

        PaymentManager.shared.authenticate3d(viewController: self, creditCardToken: creditCardToken, creditCardSecurityCode: cvv, amount: amount, currency: currency, apiKey: apiKey, debug: true) { [weak self] (output, error) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let output = output {
                    self.resultTextView.text = self.resultTextView.text + "\n\n-----------------\n\n" + "\(output.printingDescriptiopn)"
                } else if let error = error {
                    self.resultTextView.text = self.resultTextView.text + "\n\n-----------------\n\n" + "Error: \(error)"
                } else {
                    self.resultTextView.text = self.resultTextView.text + "\n\n-----------------\n\n" + "No output returned"
                }
            }
        }
    }
}

extension S2PAuth3dOutput {
    fileprivate var printingDescriptiopn: String {
        get {
            return ""
                + "\nresult: \(self.result)"
                + "\nuserPaymentOptionId: \(self.userPaymentOptionId ?? "(nil)")"
                + "\ncavv: \(self.cavv ?? "(nil)")"
                + "\neci: \(self.eci ?? "(nil)")"
                + "\nxid: \(self.xid ?? "(nil)")"
                + "\ndsTransID: \(self.dsTransID ?? "(nil)")"
                + "\nccCardNumber: \(self.ccCardNumber ?? "(nil)")"
                + "\nbin: \(self.bin ?? "(nil)")"
                + "\nlast4Digits: \(self.last4Digits ?? "(nil)")"
                + "\nccExpMonth: \(self.ccExpMonth ?? "(nil)")"
                + "\nccExpYear: \(self.ccExpYear ?? "(nil)")"
                + "\nccTempToken: \(self.ccTempToken ?? "(nil)")"
                + "\ntransactionId: \(self.transactionId ?? "(nil)")"
                + "\nthreeDReasonId: \(self.threeDReasonId ?? "(nil)")"
                + "\nthreeDReason: \(self.threeDReason ?? "(nil)")"
                + "\nchallengePreferenceReason: \(self.challengePreferenceReason ?? "(nil)")"
                + "\nisLiabilityOnIssuer: \(self.isLiabilityOnIssuer?.description ?? "(nil)")"
                + "\ncancelled: \(self.cancelled)"
                + "\nchallengeCancelReasonId: \(self.challengeCancelReasonId ?? "(nil)")"
                + "\nchallengeCancelReason: \(self.challengeCancelReason ?? "(nil)")"
                + "\nerrorCode: \(self.errorCode?.description ?? "(nil)")"
                + "\nerrorDescription: \(self.errorDescription ?? "(nil)")"
        }
    }
}
