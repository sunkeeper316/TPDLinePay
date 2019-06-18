//
//  ViewController.swift
//  TPDLinePay_Example
//
//  Created by 高嘉琦 on 2017/12/29.
//  Copyright © 2017年 Cherri Tech Inc. All rights reserved.
//

import UIKit
import SafariServices
class ViewController: UIViewController {

    @IBOutlet weak var displayText: UITextView!
    
    let frontend_rediret_url = "https://example.com/front-end-redirect"
    let backend_notify_url = "https://example.com/back-end-notify"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startLinPayAction(_ sender: Any) {
        let url = URL(string: "https://sandbox.tappaysdk.com/tpc/payment/pay-by-prime")
//        let reurl = URL(string: backend_notify_url)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("partner_YqOYAtFG3TvCDbTHs3IJnAsTcGfLw1wstsBRKkzOLAnC34IryK5DBVsd", forHTTPHeaderField:"x-api-key")
        // 1. Initilize TPDLinePay Object.
        let linePay = TPDLinePay.setup(withReturnUrl: "tappaylinepayexample://frontend_redirect")
//        tappaylinepayexample://frontend_redirect
        // 2. Check current device can use LINE Pay.
        if (TPDLinePay.isLinePayAvailable()){
            
            //3. Get prime.
            linePay.onSuccessCallback { (prime) in
                
                DispatchQueue.main.async {
                    let payment = "Use below cURL to get the payment_url.\ncurl -X POST \\\nhttps://sandbox.tappaysdk.com/tpc/payment/pay-by-prime \\\n-H \'content-type: application/json\' \\\n-H \'x-api-key: partner_6ID1DoDlaPrfHw6HBZsULfTYtDmWs0q0ZZGKMBpp4YICWBxgK97eK3RM\' \\\n-d \'{ \n \"prime\": \"\(prime!)\", \"partner_key\": \"partner_6ID1DoDlaPrfHw6HBZsULfTYtDmWs0q0ZZGKMBpp4YICWBxgK97eK3RM\", \"merchant_id\": \"GlobalTesting_LINEPAY\", \"details\":\"TapPay Test\", \"amount\": 100, \"cardholder\": { \"phone_number\": \"+886923456789\", \"name\": \"Jane Doe\", \"email\": \"Jane@Doe.com\", \"zip_code\": \"12345\", \"address\": \"123 1st Avenue, City, Country\", \"national_id\": \"A123456789\" }, \"result_url\": { \"frontend_redirect_url\" : \"\(self.frontend_rediret_url)\",\"backend_notify_url\":\"\(self.backend_notify_url)\"} }\'"
                    self.displayText.text = payment
                    print(payment)
                    
                    //以下是自己加的方法在IOS做後端的資料接收和傳送
                    let tappay = ["prime": "\(prime!)","partner_key": "partner_YqOYAtFG3TvCDbTHs3IJnAsTcGfLw1wstsBRKkzOLAnC34IryK5DBVsd","merchant_id": "sunkeeper316_LINEPAY","amount": 1,"order_number":"\(100)","cardholder":["phone_number":"+886\(900)","name":"sun","email":"sunkeeper316@com"],"details":"TapPay Test","result_url":["backend_notify_url":"\(self.backend_notify_url)","frontend_redirect_url":"\(self.frontend_rediret_url)"]] as [String : Any]
                    let data = try?  JSONSerialization.data(withJSONObject: tappay)
                    let task = URLSession.shared.uploadTask(with: urlRequest, from: data){(data, response, error) in
                        print("data:\(String(data: data!, encoding: .utf8) ?? "")")
                        print("response:\(response!)")
                        if let data = data {
                            if let data = try? JSONDecoder().decode(Response.self, from: data){
                                linePay.redirect("\(data.payment_url!)", with: self, completion: { (linePayResult) in
                                    print("LINE Pay Result : \(linePayResult)")
                                    
                                    
                                })
                                
                            }
                        }
                    }
                    task.resume()
                }
                
                }.onFailureCallback { (status, msg) in
                    print("status : \(status), msg : \(msg)")
            }.getPrime()
        }
        
    }
}

