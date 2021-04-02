//
//  SurveyNextViewController.swift
//  Clean Login
//
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD
import SDWebImage
import DataModel
import ABSteppedProgressBar

class SurveySaveViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameText: UITextView!
    @IBOutlet weak var nameTextB: UITextView!
    @IBOutlet weak var nameTextC: UILabel!
    @IBOutlet weak var logoTop: UIImageView!
    @IBOutlet weak var btnCastMyVote: UIButton!
    @IBOutlet weak var textPB: ABSteppedProgressBar!
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnFive: UIButton!
    @IBOutlet weak var btnSix: UIButton!
    @IBOutlet weak var btnAddComment: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tvComment: UITextField!
    
    let cellSpacingHeight: CGFloat = 10
    
    var albumArrayOne = [AnyObject]()
    var albumArrayTwo = [AnyObject]()
    var albumArrayThree = [AnyObject]()
    var closeDate: String = ""
    var votingToken: String = ""
    var vName: String = ""
    var vAddress: String = ""
    var vUnit: String = ""
    var votigId: Int = 0
    var vTypeId: Int = 0
    var selectedRowIND: Int = 20
    var ip : IndexPath = []
    var selectedCells:[Int] = []
    var prJsonData : JSON = JSON()
    var vRating: Int = 0
    var vComment: String = ""
    var vCheck: Int = 0
    var vCheckDone: Int = 0
    var vCheckF: Bool = false
    
    override func viewDidLoad() {
           super.viewDidLoad()
          self.textPB.numberOfPoints = 3
            self.textPB.currentIndex = 2
            self.textPB.delegate = self
            self.textPB.backgroundShapeColor = UIColor(red: 241/255, green: 244/255, blue: 250/255, alpha: 0.7)
            self.textPB.selectedBackgoundColor = UIColor(red: 40/255, green: 131/255, blue: 237/255, alpha: 1)
            self.textPB.lineHeight = 0.01
            self.textPB.stepTextColor = UIColor(red: 198/255, green: 216/255, blue: 255/255, alpha: 1)
            self.textPB.stepTextFont = UIFont.systemFont(ofSize: 17)
            let prJsonVOGOne: JSON = JSON(self.prJsonData["voteOptionGroups"][0]["voteOptions"])
            self.tvComment.delegate = self
            //let prJsonVO: JSON = JSON(prJsonVOG["voteOptions"])
              if let resData = prJsonVOGOne[].arrayObject {
                 self.albumArrayOne = resData as [AnyObject]; ()
                     }
        
            let prJsonVOGTwo: JSON = JSON(self.prJsonData["voteOptionGroups"][1]["voteOptions"])
                if let resData = prJsonVOGTwo[].arrayObject {
                   self.albumArrayTwo = resData as [AnyObject]; ()
                       }
        
        let prJsonVOGThree: JSON = JSON(self.prJsonData["voteOptionGroups"][2]["voteOptions"])
            if let resData = prJsonVOGThree[].arrayObject {
               self.albumArrayThree = resData as [AnyObject]; ()
                   }
        
                     if self.albumArrayThree.count > 0 {
                        self.nameTextC.text = self.prJsonData["voteOptionGroups"][2]["GroupName"].string!
                        }
        
        nameText.text = vName
        
        nameTextB.text = closeDate
        
       // tableView?.allowsMultipleSelection = true
        
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    
    func gotoSubmit() {
        
        self.vCheck = 0
        
        let prJsonVOGID: JSON = JSON(self.prJsonData["voteOptionGroups"][0]["VoteOptionGroupID"] as Any)
        let prJsonVOID: JSON;
        if(self.ip.isEmpty){
            prJsonVOID = ""
        }
        else{
            prJsonVOID = JSON(self.albumArrayOne[self.ip.row]["VoteOptionID"] as Any)
        }
        
        //print(self.prJsonData)
        let pOne: [String: Any] = [
            "VOGID": "\(prJsonVOGID)",
            "SelectedOptions": [
                [
                    "VOID": "\(prJsonVOID)",
                    "VoteOptionID": "\(prJsonVOID)",
                    "Rating":0,
                    "Comment":""
                ]
            ]
        ]
        
        var pTwoData = [[String: Any]]()
        
        for num in selectedCells {
            let prJsonTVOID: JSON = JSON(self.albumArrayTwo[num]["VoteOptionID"] as Any)
            let pTwoDataAdd: [String: Any] = [
                        "VOID": "\(prJsonTVOID)",
                        "VoteOptionID": "\(prJsonTVOID)",
                        "Rating":0,
                        "Comment":""
                    ]
            pTwoData.append(pTwoDataAdd)
        }
        
        
        let prJsonTVOGID: JSON = JSON(self.prJsonData["voteOptionGroups"][1]["VoteOptionGroupID"] as Any)
        let pTwo: [String: Any] = [
            "VOGID":"\(prJsonTVOGID)",
            "SelectedOptions": pTwoData
        ]
        
        let prJsonDThreeOne: JSON = JSON(albumArrayThree[0]["VoteOptionID"] as Any)
        //print(prJsonDOne)
        let prJsonDThreeTwo: JSON = JSON(albumArrayThree[1]["VoteOptionID"] as Any)
        //print(prJsonDTwoTwo)
        let prJsonThVOGID: JSON = JSON(self.prJsonData["voteOptionGroups"][2]["VoteOptionGroupID"] as Any)
        let pThree: [String: Any] = [
            "VOGID": "\(prJsonThVOGID)",
            "SelectedOptions": [
                [
                    "VOID": "\(prJsonDThreeOne)",
                    "VoteOptionID": "\(prJsonDThreeOne)",
                    "Rating":self.vRating,
                    "Comment":""
                ],
                [
                    "VOID": "\(prJsonDThreeTwo)",
                    "VoteOptionID": "\(prJsonDThreeTwo)",
                    "Rating":0,
                    "Comment":self.vComment
                ]
            ]
        ]
        
        var pFinal = [[String: Any]]()
        
        if(!self.ip.isEmpty){
        pFinal.append(pOne)
        }
        else{
            let pOneE: [String: Any] = [
                "VOGID": "\(prJsonVOGID)",
                "SelectedOptions": []
            ]
        pFinal.append(pOneE)
        self.vCheck += 1
        }
        
        if(!self.selectedCells.isEmpty){
        pFinal.append(pTwo)
        }
        else{
            let pTwoE: [String: Any] = [
                "VOGID": "\(prJsonTVOGID)",
                "SelectedOptions": []
            ]
        pFinal.append(pTwoE)
            self.vCheck += 1
        }
        
//        if(self.vRating != 0){
        pFinal.append(pThree)

        if(self.vRating == 0){
            self.vCheck += 1
        }
        
        print(pFinal)
        print(self.vCheck)
        print(self.vTypeId)
        
        if self.vCheck == 3 && self.vTypeId == 9 && self.vCheckF
        {
            self.btnCastMyVote.isEnabled = false
            self.btnCastMyVote.backgroundColor = UIColor(red: 0.573, green: 0.573, blue: 0.573, alpha: 1)
            
        }
        else{
        let defaults = UserDefaults.standard
         if let authToken = defaults.string(forKey: "AuthToken")
         {
            
            
            let hud = JGProgressHUD()
                          hud.vibrancyEnabled = true
                          hud.textLabel.text = "Processing..."
                          hud.show(in: self.view)
                          
                          //let parameters = []
               let header : HTTPHeaders = ["AuthToken" : authToken, "VotingToken" : self.votingToken,"DeviceToken" : "52.170.151.93", "Content-Type": "application/x-www-form-urlencoded"]
               
            let parameters: [String: Any] = ["data":pFinal]
            
           // let newparameters: [String: Any] = [parameters]
            
           // print(parameters)
            
            var request = URLRequest(url: URL(string: "https://api.votingportals.com/api/Ballot/SurveySubmit")!)
//            var request = URLRequest(url: URL(string: "https://qcapi.associationportals.com/api/Ballot/Votesubmit")!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.headers = header
            //let values = ["06786984572365", "06644857247565", "06649998782227"]

            request.httpBody = try! JSONSerialization.data(withJSONObject: [parameters])
            
                          AF.request(request).responseJSON { response in
                              //SVProgressHUD.dismiss()
                              hud.dismiss()
                            //debugPrint(response)
                              if let data = response.data {
                                debugPrint(data)
                              let prJson: JSON = JSON(data)
                                //debugPrint(prJson)
                                  if prJson["Flag"] != false {
                                    let prJsonData: JSON = JSON(prJson["Data"])
                                    DispatchQueue.main.async {
                                               let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                        
                                               let vStartViewController = storyBoard.instantiateViewController(withIdentifier: "SurveySuccessController") as! SurveySuccessController
                                                vStartViewController.closeDate = self.nameTextB.text
                                                vStartViewController.vName = self.vName
                                                vStartViewController.vAddress = self.vAddress
                                                if(prJsonData.isEmpty){
                                                    vStartViewController.vUnit = ""
                                                }
                                                else{
                                                    vStartViewController.vUnit = prJsonData["Address"].string!
                                                }
                                                
                                               self.navigationController?.pushViewController(vStartViewController, animated:true)
                                           }
                                  }
                                  else {
                                    let msg: String = prJson["Message"].string!
                                    let hud = JGProgressHUD()
                                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                                    hud.textLabel.text = msg
                                    hud.show(in: self.view)
                                    hud.dismiss(afterDelay: 2.0)
                                      //debugPrint(prJson["Message"])
                                  }
                              }
                              
                          }
                }
         }
        
    }
    
    @IBAction func actCastVoting(_ sender: UIButton) {
       
        let minSelect = self.prJsonData["voteOptionGroups"][2]["MinSelectionCount"]
        print("minimum select \(minSelect)")
        if(minSelect >= 1){
            if(self.vRating == 0){
                let hud = JGProgressHUD()
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.textLabel.text = "Select minimum \(minSelect) option"
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 1.0)
            }
            else{
                self.gotoSubmit()
            }
        }
        else{
            if self.vCheckDone == 2 {
            self.vCheckF = true
            }
            else{
                self.vCheckF = false
            }
            self.gotoSubmit()
        }
 
    }
    
    @IBAction func actBack(_ sender: UIButton) {
        
        print(self.vCheckDone)
        
        DispatchQueue.main.async {
                   self.navigationController?.popViewController(animated:true)
               }
        
    }
    
    @IBAction func actOne(_ sender: UIButton) {
        
        self.btnOne.isSelected = !self.btnOne.isSelected
        
        self.btnTwo.isSelected = false
        self.btnThree.isSelected = false
        self.btnFour.isSelected = false
        self.btnFive.isSelected = false
        self.btnSix.isSelected = false
        
        self.vRating = 1
        
        self.btnCastMyVote.isEnabled = true
        self.btnCastMyVote.backgroundColor = UIColor(red: 0.333, green: 0.808, blue: 0.278, alpha: 1)
        
    }
    @IBAction func actTwo(_ sender: UIButton) {
        
        self.btnTwo.isSelected = !self.btnTwo.isSelected
        
        self.btnOne.isSelected = false
        self.btnThree.isSelected = false
        self.btnFour.isSelected = false
        self.btnFive.isSelected = false
        self.btnSix.isSelected = false
        
        self.vRating = 2
        
        self.btnCastMyVote.isEnabled = true
        self.btnCastMyVote.backgroundColor = UIColor(red: 0.333, green: 0.808, blue: 0.278, alpha: 1)
        
    }
    @IBAction func actThree(_ sender: UIButton) {
        
        self.btnThree.isSelected = !self.btnThree.isSelected
        
        self.btnOne.isSelected = false
        self.btnTwo.isSelected = false
        self.btnFour.isSelected = false
        self.btnFive.isSelected = false
        self.btnSix.isSelected = false
        
        self.vRating = 3
        
        self.btnCastMyVote.isEnabled = true
        self.btnCastMyVote.backgroundColor = UIColor(red: 0.333, green: 0.808, blue: 0.278, alpha: 1)
        
    }
    @IBAction func actFour(_ sender: UIButton) {
        
        self.btnFour.isSelected = !self.btnFour.isSelected
        
        self.btnOne.isSelected = false
        self.btnTwo.isSelected = false
        self.btnThree.isSelected = false
        self.btnFive.isSelected = false
        self.btnSix.isSelected = false
        
        self.vRating = 4
        
        self.btnCastMyVote.isEnabled = true
        self.btnCastMyVote.backgroundColor = UIColor(red: 0.333, green: 0.808, blue: 0.278, alpha: 1)
        
    }
    @IBAction func actFive(_ sender: UIButton) {
        
        self.btnFive.isSelected = !self.btnFive.isSelected
        
        self.btnOne.isSelected = false
        self.btnTwo.isSelected = false
        self.btnThree.isSelected = false
        self.btnFour.isSelected = false
        self.btnSix.isSelected = false
        
        self.vRating = 5
        
        self.btnCastMyVote.isEnabled = true
        self.btnCastMyVote.backgroundColor = UIColor(red: 0.333, green: 0.808, blue: 0.278, alpha: 1)
        
    }
    @IBAction func actSix(_ sender: UIButton) {
        
        self.btnSix.isSelected = !self.btnSix.isSelected
        
        self.btnOne.isSelected = false
        self.btnTwo.isSelected = false
        self.btnThree.isSelected = false
        self.btnFour.isSelected = false
        self.btnFive.isSelected = false
        
        self.vRating = 6
        
        self.btnCastMyVote.isEnabled = true
        self.btnCastMyVote.backgroundColor = UIColor(red: 0.333, green: 0.808, blue: 0.278, alpha: 1)
        
    }
    @IBAction func actAddComment(_ sender: UIButton) {
     
        self.tvComment.isHidden = false
        self.btnSave.isHidden = false
        self.btnAddComment.isHidden = true
        
        self.tvComment.backgroundColor = UIColor.white
        self.tvComment.layer.borderColor = hexStringToUIColor(hex: "#8EBCF1", op: 1.0).cgColor
        self.tvComment.layer.borderWidth = 1
        self.tvComment.layer.cornerRadius = 14
        self.tvComment.clipsToBounds = false
        
        self.btnOne.isHidden = true
        self.btnTwo.isHidden = true
        self.btnThree.isHidden = true
        self.btnFour.isHidden = true
        self.btnFive.isHidden = true
        self.btnSix.isHidden = true
        
    }
    @IBAction func actSave(_ sender: UIButton) {
        
        self.tvComment.isHidden = true
        self.btnSave.isHidden = true
        self.btnAddComment.isHidden = false
        
        self.vComment = self.tvComment.text!
        
        self.btnOne.isHidden = false
        self.btnTwo.isHidden = false
        self.btnThree.isHidden = false
        self.btnFour.isHidden = false
        self.btnFive.isHidden = false
        self.btnSix.isHidden = false
    }
    
    @IBAction func actCloseVoting(_ sender: UIButton) {
       
        
        DispatchQueue.main.async {
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
                   let vStartViewController = storyBoard.instantiateViewController(withIdentifier: "VoteCloseController") as! VoteCloseController
                   vStartViewController.closeDate = self.nameTextB.text
                    vStartViewController.vName = self.nameText.text
                   self.navigationController?.pushViewController(vStartViewController, animated:true)
               }
        
    }
    
    func hexStringToUIColor (hex:String, op:Float) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(op)
        )
    }
    
  
}

extension SurveySaveViewController: ABSteppedProgressBarDelegate {
  
  func progressBar(_ progressBar: ABSteppedProgressBar,
                   willSelectItemAtIndex index: Int) {
    print("progressBar:willSelectItemAtIndex:\(index)")
  }
  
  func progressBar(_ progressBar: ABSteppedProgressBar,
                   didSelectItemAtIndex index: Int) {
    print("progressBar:didSelectItemAtIndex:\(index)")
  }
  
  func progressBar(_ progressBar: ABSteppedProgressBar,
                   canSelectItemAtIndex index: Int) -> Bool {
    print("progressBar:canSelectItemAtIndex:\(index)")
    //Only next (or previous) step can be selected
    let offset = abs(progressBar.currentIndex - index)
    return (offset <= 1)
  }
  
  func progressBar(_ progressBar: ABSteppedProgressBar,
                   textAtIndex index: Int) -> String {
    let text: String
    switch index {
    case 0:
      text = "1"
    case 1:
      text = "2"
    case 2:
      text = "3"
    case 3:
      text = "4"
    case 4:
      text = "5"
    case 5:
      text = "6"
    case 6:
      text = "7"
    case 7:
      text = "8"
    case 8:
      text = "9"
    case 9:
      text = "10"
    default:
      text = "0"
    }
    print("progressBar:textAtIndex:\(index)")
    return text
  }
  
}
