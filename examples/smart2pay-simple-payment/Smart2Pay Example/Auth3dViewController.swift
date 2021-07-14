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
    var apiKey: String!

    @IBOutlet weak var creditCardTokenTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var merchantIdTextField: UITextField!
    @IBOutlet weak var merchantSiteIdTextField: UITextField!
    
    @IBOutlet weak var resultTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        creditCardTokenTextField.text = creditCardToken
        amountTextField.text = amount
        currencyTextField.text = currency
    }
    
    @IBAction func authenticate3d() {
        self.resultTextView.text = "Processing..."

        guard
            let creditCardToken = creditCardTokenTextField.text,
            let amount = amountTextField.text,
            let currency = currencyTextField.text
        else { return }
        PaymentManager.shared.authenticate3d(viewController: self, creditCardToken: creditCardToken, amount: amount, currency: currency, apiKey: apiKey, debug: true) { [weak self] (output, error) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let output = output {
                    self.resultTextView.text = "\(output.printingDescriptiopn)"
                } else if let error = error {
                    self.resultTextView.text = "Error: \(error)"
                } else {
                    self.resultTextView.text = "Unknown output returned"
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