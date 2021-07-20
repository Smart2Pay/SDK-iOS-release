//
//  ThreeDPaymentViewController.swift
//  Smart2Pay Example
//
//  Created by Michael Kessler on 19/07/2021.
//  Copyright © 2021 David Jupijn. All rights reserved.
//

import UIKit
import Smart2Pay

class ThreeDPaymentViewController: UIViewController {
    
    var amount: String!
    var currency: String!
    var auth3dOutput: Smart2Pay.S2PAuth3dOutput!

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let input: [String: Any] = [
            "Amount": amount!,
            "Currency": currency!,
            "MethodId": "6",
            "3DSecureData": [
                "TransactionStatus": auth3dOutput.result == .approved ? "Y" : "N",
                "ECI": auth3dOutput.eci!,
                "AuthenticationValue": auth3dOutput.cavv!,
                "DSTransId": auth3dOutput.dsTransID!,
                "MessageVersion": "2.1.0",
                "ThreeDSecureAuthenticationType1": "F",
            ]
        ]
        inputTextView.text = "\(input)"
    }
    
    @IBAction func pay() {
        guard
            let amount = amount,
            let currency = currency,
            auth3dOutput.result == .approved,
            let eci = auth3dOutput.eci,
            let authenticationValue = auth3dOutput.cavv,
            let dsTransId = auth3dOutput.dsTransID
        else {
            print(#function, "Wrong input")
            return
        }

        PaymentsService.post3dPayment(
            amount: amount,
            currency: currency,
            transactionStatus: "Y",
            eci: eci,
            authenticationValue: authenticationValue,
            dsTransId: dsTransId,
            messageVersion: "2.1.0")
        { [weak self] json, error in
            if let json = json {
                self?.outputTextView.text = "Success:\n\(json)"
            } else if let error = error {
                self?.outputTextView.text = "Error:\n\(error)"
            } else {
                self?.outputTextView.text = "Unknown error occurred"
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
