//
//  DonateViewController.swift
//  Serve
//
//  Created by Bamlak Gessessew on 8/8/17.
//  Copyright © 2017 Bamlak Gessessew. All rights reserved.
//

import UIKit
import PassKit
import Stripe

class DonateViewController: UIViewController{
    
    @IBOutlet weak var moneyLabel: UITextField!
    @IBOutlet weak var orgLabel: UILabel!
    @IBOutlet weak var applePayButton: UIButton!
    
    //let amount = 12.01 as! Decimal

      
    
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let AppleMerchantID = "merchant.com.Hamlett.Serve"

    override func viewDidLoad() {
        super.viewDidLoad()
        moneyLabel.text = "\(1.01)"
        applePayButton.isHidden = !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }

    
    @IBAction func didPressView(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    
    @IBAction func openApplePay(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Individual", bundle: nil)
//        let popOverVC = storyboard.instantiateViewController(withIdentifier: "popUpStoryboard2") as! ApplePayViewController
//        self.addChildViewController(popOverVC)
//        popOverVC.view.frame = self.view.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
        
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = AppleMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Pls", amount: 1.01)
        ]
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest : request)
        applePayController.delegate = self
        self.present(applePayController, animated: true, completion: nil)
        
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DonateViewController: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        Stripe.setDefaultPublishableKey("pk_test_hJDB1NL54vUfkD8cxV1VDGZ8")
        STPAPIClient.shared().createToken(with: payment) {
            (token, error) -> Void in
            
            if (error != nil) {
                print(error)
                completion(PKPaymentAuthorizationStatus.failure)
                return
            }
            
            let url = URL(string: "http://172.24.71.82:5000/pay")  // Replace with computers local IP Address!
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            print(token!.tokenId)
            
            let body = ["stripeToken": token?.tokenId,
                        "amount": 1.01 ,
                        "description": "Girls Who Code"] as [String : Any]
            
            var error: NSError?
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
            } catch{
                print("rboek")
            }
            
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request as URLRequest) {data, response, error -> Void in
                if (error != nil) {
                    completion(PKPaymentAuthorizationStatus.failure)
                    print("fail")
                } else {
                    completion(PKPaymentAuthorizationStatus.success)
                    print("success")
                }}
            task.resume()
            
         
            
        }
        
    }
    
}
