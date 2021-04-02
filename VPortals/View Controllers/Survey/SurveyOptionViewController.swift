//
//  SurveyOptionViewController.swift
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

class SurveyOptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellReuseIdentifier = "cell"
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var nameText: UITextView!
    @IBOutlet weak var nameTextB: UITextView!
    @IBOutlet weak var nameTextC: UILabel!
    @IBOutlet weak var logoTop: UIImageView!
    @IBOutlet weak var btnCastMyVote: UIButton!
    @IBOutlet weak var textPB: ABSteppedProgressBar!
    
    let cellSpacingHeight: CGFloat = 10
    
    var albumArray = [AnyObject]()
    var closeDate: String = ""
    var votingToken: String = ""
    var vName: String = ""
    var vAddress: String = ""
    var vUnit: String = ""
    var votigId: Int = 0
    var vTypeId: Int = 0
    var vCheckDone: Int = 0
    var selectedRowIND: Int = 20
    var ip : IndexPath = []
    var prJsonData : JSON = JSON()
    
    override func viewDidLoad() {
           super.viewDidLoad()
           self.tableView.sectionFooterHeight = cellSpacingHeight;
            self.textPB.numberOfPoints = 3
            self.textPB.currentIndex = 0
            self.textPB.delegate = self
            self.textPB.backgroundShapeColor = UIColor(red: 241/255, green: 244/255, blue: 250/255, alpha: 0.7)
            self.textPB.selectedBackgoundColor = UIColor(red: 40/255, green: 131/255, blue: 237/255, alpha: 1)
            self.textPB.lineHeight = 0.01
            self.textPB.stepTextColor = UIColor(red: 198/255, green: 216/255, blue: 255/255, alpha: 1)
            self.textPB.stepTextFont = UIFont.systemFont(ofSize: 17)
        
           let defaults = UserDefaults.standard
            if let authToken = defaults.string(forKey: "AuthToken")
            {
            //print(authToken)
             let hud = JGProgressHUD()
                           hud.vibrancyEnabled = true
                           hud.textLabel.text = "Processing..."
                           hud.show(in: self.view)
                           
                           //let parameters = []
                let header : HTTPHeaders = ["AuthToken" : authToken, "VotingToken" : self.votingToken,"DeviceToken" : "52.170.151.93", "Content-Type": "application/x-www-form-urlencoded"]
                
                let parameters = ["VoteID": String(self.votigId)]

                           AF.request("https://api.votingportals.com/api/Ballot/VoteOptions", method: .post, parameters: parameters, headers: header).responseJSON { response in
                               //SVProgressHUD.dismiss()
                               hud.dismiss()
                               if let data = response.data {
                               let prJson: JSON = JSON(data)
                                self.prJsonData = JSON(prJson["Data"])
                            let prJsonVOG: JSON = JSON(self.prJsonData["voteOptionGroups"][0])
                            let prJsonVO: JSON = JSON(prJsonVOG["voteOptions"])
                                   if prJson["Flag"] != false {
                                      if let resData = prJsonVO[].arrayObject {
                                          self.albumArray = resData as [AnyObject]; ()
                                      }
                                      if self.albumArray.count > 0 {
                                        
                                        self.nameTextC.text = prJsonVOG["GroupName"].string!
//                                        self.nameTextC.text = "Hello From Voting Portals Hello From Voting Portals Hello From Voting Portals Hello From Voting Portals Hello From Voting Portals Hello From Voting Portals Hello From Voting Portals Hello From Voting Portals Hello From Voting Portals"
                                        self.tableView.reloadData()
                                      }
                                   }
                                   else {
                                       debugPrint(prJson["Message"])
                                   }
                               }
                               
                           }
        }
        
        nameText.text = vName
        
        nameTextB.text = closeDate
        
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
    
    func gotoNext() {
        
        DispatchQueue.main.async {
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
                   let vStartViewController = storyBoard.instantiateViewController(withIdentifier: "SurveyNextViewController") as! SurveyNextViewController
            vStartViewController.closeDate = self.nameTextB.text
            vStartViewController.votingToken = self.votingToken
            vStartViewController.vName = self.vName
            vStartViewController.votigId = self.votigId
            vStartViewController.prJsonData = self.prJsonData
            vStartViewController.ip = self.ip
            vStartViewController.vAddress = self.vAddress
            vStartViewController.vUnit = self.vUnit
            vStartViewController.vTypeId = self.vTypeId
            vStartViewController.vCheckDone = self.vCheckDone
                   self.navigationController?.pushViewController(vStartViewController, animated:true)
               }
        
    }
    
    @IBAction func actCastVoting(_ sender: UIButton) {
       
        let minSelect = self.prJsonData["voteOptionGroups"][0]["MinSelectionCount"]
        print("minimum select \(minSelect)")
        if(minSelect >= 1){
            if(self.selectedRowIND == 20){
                let hud = JGProgressHUD()
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.textLabel.text = "Select minimum \(minSelect) option"
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 1.0)
            }
            else{
                self.gotoNext()
            }
        }
        else{
            if self.vCheckDone == 0 {
            self.vCheckDone = 1
            }
            self.gotoNext()
        }
    }

    // Set the spacing between sections
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return cellSpacingHeight
//    }
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumArray.count
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
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
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyOptionCell", for: indexPath) as! SurveyOptionTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.mainBackground.layer.borderColor = hexStringToUIColor(hex: "#8EBCF1", op: 1.0).cgColor
        cell.mainBackground.layer.borderWidth = 1
        cell.mainBackground.layer.cornerRadius = 14
        cell.mainBackground.clipsToBounds = false
        
        let vTitle = albumArray[indexPath.row]["OptionText"] as? String
        cell.vTitle.text = vTitle
        
        let prJsonData: JSON = JSON(albumArray[indexPath.row]["optionAttachments"] as Any)
        
        if(!prJsonData.isEmpty){
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.vBio.isUserInteractionEnabled = true
            tapGestureRecognizer.numberOfTapsRequired = 1
            tapGestureRecognizer.numberOfTouchesRequired = 1
            tapGestureRecognizer.cancelsTouchesInView = false
            cell.vBio.tag = indexPath.row
            cell.vBio.clipsToBounds = true
            //cell.vBio.frame = CGRect(x: 303, y: 17, width: 70, height: 40)
            cell.vBio.addGestureRecognizer(tapGestureRecognizer)
            //tapGestureRecognizer.delegate = self
            
        }
        else{
            cell.vBio.isHidden = true
        }
        
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let prJsonData: JSON = JSON(albumArray[tappedImage.tag]["optionAttachments"] as Any)
        
        if(!prJsonData.isEmpty){
            
        let pdfEurl = prJsonData[0]["FilePath"]
        let vTitle = albumArray[tappedImage.tag]["OptionText"] as? String
        let pdfUrl = "https://cdn.votingportals.com\(pdfEurl)"
        //debugPrint(pdfUrl)
            /*
        guard let url = URL(string: pdfUrl) else { return }
        UIApplication.shared.open(url)
             */
            DispatchQueue.main.async {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

                let vpdfViewController = storyBoard.instantiateViewController(withIdentifier: "VPdfViewController") as! VPdfViewController
                vpdfViewController.vPName = vTitle!
                vpdfViewController.vPUrl = pdfUrl
                self.navigationController?.pushViewController(vpdfViewController, animated:true)
            }
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(self.selectedRowIND == 20){
            
            let cell = self.tableView.cellForRow(at: indexPath) as! SurveyOptionTableViewCell
            cell.vTitle.textColor = hexStringToUIColor(hex: "#2883ED", op: 0.6)
            cell.vBio.image = UIImage(named: "bio_on")
            cell.vRadio.image = UIImage(named: "radio_on")
            cell.mainBackground.backgroundColor = hexStringToUIColor(hex: "#C6D8FF", op: 0.3)
            self.selectedRowIND = indexPath.section
            self.ip = indexPath
            
            btnCastMyVote.isHidden = false
            
        }
        else
        {
            let cell = self.tableView.cellForRow(at: self.ip) as! SurveyOptionTableViewCell
            
            cell.vBio.image = UIImage(named: "bio_off")
            cell.vRadio.image = UIImage(named: "radio_off")
            cell.mainBackground.backgroundColor = UIColor.white
            cell.vTitle.textColor = hexStringToUIColor(hex: "#4A4A4A", op: 0.6)
            let cell2 = self.tableView.cellForRow(at: indexPath) as! SurveyOptionTableViewCell
            
            cell2.vTitle.textColor = hexStringToUIColor(hex: "#2883ED", op: 0.6)
            cell2.vBio.image = UIImage(named: "bio_on")
            cell2.vRadio.image = UIImage(named: "radio_on")
            cell2.mainBackground.backgroundColor = hexStringToUIColor(hex: "#C6D8FF", op: 0.3)
            self.selectedRowIND = indexPath.section
            self.ip = indexPath
        }
    }
}

extension SurveyOptionViewController: ABSteppedProgressBarDelegate {
  
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
