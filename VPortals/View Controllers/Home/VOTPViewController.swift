//
//  VOTPViewController.swift
//  VPortals
//
//  Created by Nadeem Khan on 18/01/21.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD
import SDWebImage
import MIOTPVerificationSPM


class VOTPViewController: UIViewController, OTPViewDelegate {
    
    @IBOutlet weak var nameText: UITextView!
    @IBOutlet weak var nameTextB: UITextView!
    @IBOutlet weak var logoTop: UIImageView!
    @IBOutlet weak var viewOTP: OTPView!
    @IBOutlet weak var textOtpTopText: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var textError: UILabel!
    var str = ""
    var greeting = ""
    var closeDate: String = ""
    var vName: String = ""
    var vAddress: String = ""
    var vUnit: String = ""
    var votigId: Int = 0
    var vTypeId: Int = 0
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
        let defaults = UserDefaults.standard
         
        
        if let associationLogoURL = defaults.string(forKey: "AssociationLogoURL")
        {
            //logoTop.sd_setImage(with: URL(string: associationLogoURL))
            logoTop.sd_setImage(with: URL(string: associationLogoURL))
        }
        
        if let uEmail = defaults.string(forKey: "EmailAddress")
        {
            textOtpTopText.text = "Enter the 6 digit authentication passcode sent to \(uEmail) in order to vote on this ballot."
        }
         
        viewOTP.fieldsCount = 6
        viewOTP.borderWidth = 1
        //viewOTP.emptyFieldBorderColor = .purple
        viewOTP.isSecureEntry = false
        //viewOTP.secureEntrySymbol = .dot
        //viewOTP.keyboardType = .numberPad
        viewOTP.txtPlaceholder = .none
        viewOTP.isTextfieldBecomFirstResponder = true
        //viewOTP.fieldFont = UIFont.systemFont(ofSize: 55)
        //viewOTP.textColor = .red
        viewOTP.delegate = self
        //viewOTP.cursorColor = .black
        viewOTP.otpFieldDisplayType = .underlined
        viewOTP.initializeOTPUI()
        
        //debugPrint(votigId)
        
        nameText.text = vName
        
//        let dateFormatter = DateFormatter()// set locale to reliable US_POSIX
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        let fdate = dateFormatter.date(from:closeDate)!
//
//        let formatter = DateFormatter()
//
//        formatter.dateFormat = "MM/dd/yyyy"
//
//        let result = formatter.string(from: fdate)
        
        nameTextB.text = closeDate
       }
    
func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
//    print("hasEnteredAllOTP")
//    return str == "123456" ? hasEntered : false
    return true
}

func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
   // print("shouldBecomeFirstResponderForOTP")
    self.btnSubmit.isEnabled = false
    self.btnSubmit.backgroundColor = UIColor(red: 0.333, green: 0.808, blue: 0.278, alpha: 0.5)
    return true
}

func enteredOTP(otpString: String) {
    str = otpString
    print(otpString)
    self.btnSubmit.isEnabled = true
           self.btnSubmit.backgroundColor = UIColor(red: 0.333, green: 0.808, blue: 0.278, alpha: 1)
}
    
    @IBAction func actValidateOTP(_ sender: UIButton) {
     
        let defaults = UserDefaults.standard
            if let authToken = defaults.string(forKey: "AuthToken")
            {
            //print(authToken)
             let hud = JGProgressHUD()
                           hud.vibrancyEnabled = true
                           hud.textLabel.text = "Processing..."
                           hud.show(in: self.view)
                           
                           //let parameters = []
                           let header : HTTPHeaders = ["AuthToken" : authToken, "DeviceToken" : "52.170.151.93", "Content-Type": "application/x-www-form-urlencoded"]
                
                let parameters = ["VoteID": String(self.votigId), "VotingCode": self.str, "Address": self.vAddress]

                AF.request("https://api.votingportals.com/api/Ballot/GenerateVotingToken", method: .post, parameters: parameters, headers: header).responseJSON { response in
                               //SVProgressHUD.dismiss()
                              
                               if let data = response.data {
                                   let prJson: JSON = JSON(data)
                                   let prJsonData: JSON = JSON(prJson["Data"])
                                   if prJson["Flag"] != false {
                                     hud.dismiss()
                                     debugPrint(prJson["Message"])
                                     let vToken: String = prJsonData["VotingToken"].string!
                                    DispatchQueue.main.async {
                                               let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                        if self.vTypeId == 1{
                                               let vStartViewController = storyBoard.instantiateViewController(withIdentifier: "VStartViewController") as! VStartViewController
                                               vStartViewController.closeDate = self.nameTextB.text
                                                vStartViewController.votingToken = vToken
                                                vStartViewController.vName = self.nameText.text
                                        vStartViewController.votigId = self.votigId
                                               self.navigationController?.pushViewController(vStartViewController, animated:true)
                                        }
                                        else{
                                            let sStartViewController = storyBoard.instantiateViewController(withIdentifier: "SurveyStartViewController") as! SurveyStartViewController
                                            sStartViewController.closeDate = self.nameTextB.text
                                            sStartViewController.votingToken = vToken
                                            sStartViewController.vName = self.nameText.text
                                            sStartViewController.votigId = self.votigId
                                            sStartViewController.vAddress = self.vAddress
                                            sStartViewController.vUnit = self.vUnit
                                            sStartViewController.vTypeId = self.vTypeId
                                            self.navigationController?.pushViewController(sStartViewController, animated:true)
                                        }
                                           }
                                   }
                                   else {
                                    hud.dismiss()
                                       debugPrint(prJson["Message"])
                                    self.textError.isHidden = false
                                    self.textError.text = prJson["Message"].string!
                                    self.viewOTP.clearOTP()
                                    self.viewOTP.emptyFieldBorderColor = .red
                                    self.viewOTP.initializeOTPUI()
                                    
                                    
                                   }
                               }
                               
                           }
        }
    }
}
