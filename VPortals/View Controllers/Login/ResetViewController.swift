//
//  ViewController.swift
//  Clean Login
//
//

import Foundation
import UIKit
import Alamofire
import JGProgressHUD
import SwiftyJSON

class ResetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldPortalNumber: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textError: UILabel!
    @IBOutlet weak var pNumber: UILabel!
    @IBOutlet weak var eMail: UILabel!
    @IBOutlet weak var lblResetPass: UILabel!
    @IBOutlet weak var ivSuccess: UIImageView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnReturn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textFieldPortalNumber.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        textFieldEmail.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        self.textFieldPortalNumber.tag = 0
        self.textFieldEmail.tag = 1
                
        self.textFieldPortalNumber.delegate = self
        self.textFieldEmail.delegate = self
    }
    override var prefersStatusBarHidden: Bool {
      return true
    }
    @IBAction func actBackToLogin(_ sender: UIButton) {
     
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func actBackReturn(_ sender: UIButton) {
     
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

     print("Hello viewWillAppear")
    self.textFieldPortalNumber.layer.borderColor = UIColor.white.cgColor
    self.textFieldEmail.layer.borderColor = UIColor.white.cgColor
    self.textFieldPortalNumber.text = ""
    self.textFieldEmail.text = ""
    }
    
    @objc func textFieldDidChange(textField: UITextField){

   
        if !self.textFieldPortalNumber.text!.isEmpty && !self.textFieldEmail.text!.isEmpty {
             //print("Text changed if")
            self.btnSend.isEnabled = true
            self.btnSend.backgroundColor = UIColor(red: 0.333, green: 0.808, blue: 0.278, alpha: 1)
        }
        else{
            //print("Text changed else")
            self.btnSend.isEnabled = false
            self.btnSend.backgroundColor = UIColor(red: 0.573, green: 0.573, blue: 0.573, alpha: 1)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textFieldPortalNumber {
            self.textFieldEmail.becomeFirstResponder()
        } else if textField == self.textFieldEmail {
            self.textFieldEmail.resignFirstResponder()
        }
            //...so on and so forth....
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.textFieldPortalNumber.isFirstResponder == true {
            self.textFieldPortalNumber.placeholder = ""
        }
        else if self.textFieldEmail.isFirstResponder == true {
            self.textFieldEmail.placeholder = ""
        }
    }

    @IBAction func actShowHome(_ sender: UIButton) {
        
        let hud = JGProgressHUD()
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Processing..."
        hud.show(in: self.view)
        
        let header : HTTPHeaders = ["deviceID" : "13456","Content-Type": "application/x-www-form-urlencoded"]
        
        let parameters = ["PortalNumber": textFieldPortalNumber.text ?? "", "EmailAddress": textFieldEmail.text ?? ""]
        debugPrint(parameters)
        AF.request("https://api.votingportals.com/api/Login/ForgotPassword", method: .post, parameters: parameters, headers: header).responseJSON { response in
            //SVProgressHUD.dismiss()
            //hud.dismiss()
            if let data = response.data {
                let prJson: JSON = JSON(data)
                debugPrint(prJson)
                if prJson["Flag"] != false {
                hud.dismiss()
                self.textError.text = prJson["message"].string!
                    self.pNumber.isHidden = true
                    self.eMail.isHidden = true
                    self.textFieldPortalNumber.isHidden = true
                    self.textFieldEmail.isHidden = true
                    self.btnReturn.isHidden = true
                    self.btnSend.isHidden = true
                    self.btnBack.isHidden = false
                    self.ivSuccess.isHidden = false
                }
                else {
                    self.lblResetPass.isHidden = true
                    self.textFieldPortalNumber.layer.borderColor = UIColor.red.cgColor
                                       self.textFieldEmail.layer.borderColor = UIColor.red.cgColor
                    
                                       self.textError.textColor = UIColor.red
                    
                    self.textError.text = prJson["message"].string!
                    debugPrint(prJson["message"])
                    //let msg: String = prJson["Message"].string!
//                    UIView.animate(withDuration: 0.1, animations: {
//                        hud.textLabel.text = nil
//                        hud.detailTextLabel.text = prJson["Message"].string!
////                        hud.detailTextLabel.text = nil
//                        hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                    })
                    
                    hud.dismiss()
                }
            }
//            let jsonData = response.data
//            let json = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any]
//            debugPrint(json!["Message"] as? String ?? "0")
//                if let collection = json["key"] as? NSArray {
//                           //extracting values
//            }
            //if let data = response.data {
//            if let value = data.value as? [String: AnyObject] {
            //debugPrint(response.data as NSDictionary)
//            }
// let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary
               // debugPrint(json[""])
//                //print("Failure Response: \(json ?? default value)")
//                print(json["flag"]);
            //}
        }
        
//        if let loginAction = loginAction {
//            loginAction(textFieldPortalNumber.text ?? "", textFieldEmail.text ?? "", textFieldPassword.text ?? "")
//        }

    }
    
    func navigateToHomeViewController() {
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(homeViewController, animated:true)
        }
        
    }
    
}
