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
    
    private var output: Smart2Pay.S2PAuth3dOutput? {
        didSet {
            guard let output = output else {
                setButton(payButton, enabled: false)
                return
            }
            
            setButton(payButton, enabled: output.result == .approved)
        }
    }

    @IBOutlet weak var creditCardTokenTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    @IBOutlet weak var auth3dButton: UIButton!
    @IBOutlet weak var payButton: UIButton!

    @IBOutlet weak var resultTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        creditCardTokenTextField.text = creditCardToken
        amountTextField.text = amount
        currencyTextField.text = currency
        cvvTextField.text = cvv
        
        setButton(payButton, enabled: false)
    }
    
    @IBAction func authenticate3d() {
        guard
            let creditCardToken = creditCardTokenTextField.text,
            let cvv = cvvTextField.text,
            let amount = amountTextField.text,
            let currency = currencyTextField.text,
            let apiKey = apiKey
        else { return }
        
        setButton(auth3dButton, enabled: false)
        self.resultTextView.text = "Input:"
            + "\n- creditCardToken: \(creditCardToken)"
            + "\n- cvv: \(cvv)"
            + "\n- amount: \(amount)"
            + "\n- currency: \(currency)"
            + "\n- apiKey: \(apiKey)"

        PaymentManager.shared.authenticate3d(
            viewController: self,
            creditCardToken: creditCardToken,
            creditCardSecurityCode: cvv,
            amount: amount,
            currency: currency,
            apiKey: apiKey)
        { [weak self] output in
            debugPrint("Auth3d: \(output.result)")
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.output = output
                self.setButton(self.auth3dButton, enabled: true)
                self.resultTextView.text = self.resultTextView.text + "\n\n-----------------\n\n" + "\(output.printingDescriptiopn)"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ThreeDPaymentViewController {
            vc.amount = amount
            vc.currency = currency
            vc.cardSecurityCode = cvv
            vc.creditCardToken = creditCardToken
            vc.auth3dOutput = output
        }
    }
    
    private func setButton(_ button: UIButton, enabled: Bool) {
        button.isEnabled = enabled
        button.alpha = enabled ? 1.0 : 0.5
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
                + "\nchallengeCancelReasonId: \(self.challengeCancelReasonId ?? "(nil)")"
                + "\nchallengeCancelReason: \(self.challengeCancelReason ?? "(nil)")"
                + "\nerrorCode: \(self.errorCode?.description ?? "(nil)")"
                + "\nerrorDescription: \(self.errorDescription ?? "(nil)")"
        }
    }
}
