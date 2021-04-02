//
//  HomeViewController.swift
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

class VOptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellReuseIdentifier = "cell"
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var nameText: UITextView!
    @IBOutlet weak var nameTextB: UITextView!
    @IBOutlet weak var nameTextC: UILabel!
    @IBOutlet weak var logoTop: UIImageView!
    @IBOutlet weak var lbBottom: UILabel!
    @IBOutlet weak var btnCastMyVote: UIButton!
    @IBOutlet weak var lvDateThis: UILabel!
    
    let cellSpacingHeight: CGFloat = 10
    
    var albumArray = [AnyObject]()
    var closeDate: String = ""
    var votingToken: String = ""
    var vName: String = ""
    var votigId: Int = 0
    var selectedRowIND: Int = 10
    var ip : IndexPath = []
    
    override func viewDidLoad() {
           super.viewDidLoad()
           self.tableView.sectionFooterHeight = cellSpacingHeight;
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
                               let prJsonData: JSON = JSON(prJson["Data"])
                            let prJsonVOG: JSON = JSON(prJsonData["voteOptionGroups"][0])
                            let prJsonVO: JSON = JSON(prJsonVOG["voteOptions"])
                                   if prJson["Flag"] != false {
                                      if let resData = prJsonVO[].arrayObject {
                                          self.albumArray = resData as [AnyObject]; ()
                                      }
                                      if self.albumArray.count > 0 {
                                        let number = self.albumArray.count
                                        let formatter = NumberFormatter()
                                        formatter.numberStyle = .spellOut
                                        let numberString = formatter.string(from: NSNumber(value: number))
                                        let vdata = "The \(numberString ?? "") (\(number)) candidates for the Board of Directors are not in alphabetical order."
                                        self.nameTextC.text = vdata
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
        
        let calendar = Calendar.current
        let date = Date()
        let dateComponents = calendar.component(.day, from: date)
        let numberFormatter = NumberFormatter()

        numberFormatter.numberStyle = .ordinal

        let day = numberFormatter.string(from: dateComponents as NSNumber)
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MMMM, yyyy"

        let dateString = "Dated this \(day!) day of \(dateFormatter.string(from: date))"

        lvDateThis.text = dateString
        
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
    
    @IBAction func actCastVoting(_ sender: UIButton) {
       
        let defaults = UserDefaults.standard
         if let authToken = defaults.string(forKey: "AuthToken")
         {
            print(authToken)
            let prJsonData: JSON = JSON(albumArray[self.ip.row]["VoteOptionID"] as Any)
            print(prJsonData)
            print(self.ip.row)
            
            let hud = JGProgressHUD()
                          hud.vibrancyEnabled = true
                          hud.textLabel.text = "Processing..."
                          hud.show(in: self.view)
                          
                          //let parameters = []
               let header : HTTPHeaders = ["AuthToken" : authToken, "VotingToken" : self.votingToken,"DeviceToken" : "52.170.151.93", "Content-Type": "application/x-www-form-urlencoded"]
               
               //let parameters = ["VoteID": String(self.votigId)]
            let parameters: [String: Any] = [
                "VOGID":"0",
                "SelectedOptions": [
                    [
                        "VOID": String(self.votigId),
                        "VoteOptionID": prJsonData.string ?? "",
                        "Rating":0,
                        "Comment":""
                    ]
                ]
            ]

                          AF.request("https://api.votingportals.com/api/Ballot/Votesubmit", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
                              //SVProgressHUD.dismiss()
                              hud.dismiss()
                              if let data = response.data {
                              let prJson: JSON = JSON(data)
                                debugPrint(prJson)
                                  if prJson["Flag"] != false {
                                    let prJsonData: JSON = JSON(prJson["Data"])
                                    DispatchQueue.main.async {
                                               let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                        
                                               let vStartViewController = storyBoard.instantiateViewController(withIdentifier: "VoteSuccessController") as! VoteSuccessController
                                               vStartViewController.closeDate = self.nameTextB.text
                                                vStartViewController.vName = self.nameText.text
                                                vStartViewController.vUnit = prJsonData["Address"].string!
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
                                  }
                              }
                              
                          }
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "VOptionCell", for: indexPath) as! VOptionTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.mainBackground.layer.borderColor = hexStringToUIColor(hex: "#8EBCF1", op: 1.0).cgColor
        cell.mainBackground.layer.borderWidth = 1
        cell.mainBackground.layer.cornerRadius = 14
        cell.mainBackground.clipsToBounds = false
        
        let vTitle = albumArray[indexPath.row]["FullName"] as? String
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
        let vTitle = albumArray[tappedImage.tag]["FullName"] as? String
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
        
        if(self.selectedRowIND == 10){
            
            let cell = self.tableView.cellForRow(at: indexPath) as! VOptionTableViewCell
            cell.vTitle.textColor = hexStringToUIColor(hex: "#2883ED", op: 0.6)
            cell.vBio.image = UIImage(named: "bio_on")
            cell.vRadio.image = UIImage(named: "radio_on")
            cell.mainBackground.backgroundColor = hexStringToUIColor(hex: "#C6D8FF", op: 0.3)
            self.selectedRowIND = indexPath.section
            self.ip = indexPath
            
            lbBottom.isHidden = true
            btnCastMyVote.isHidden = false
            lvDateThis.isHidden = false
        }
        else
        {
            let cell = self.tableView.cellForRow(at: self.ip) as! VOptionTableViewCell
            
            cell.vBio.image = UIImage(named: "bio_off")
            cell.vRadio.image = UIImage(named: "radio_off")
            cell.mainBackground.backgroundColor = UIColor.white
            cell.vTitle.textColor = hexStringToUIColor(hex: "#4A4A4A", op: 0.6)
            let cell2 = self.tableView.cellForRow(at: indexPath) as! VOptionTableViewCell
            
            cell2.vTitle.textColor = hexStringToUIColor(hex: "#2883ED", op: 0.6)
            cell2.vBio.image = UIImage(named: "bio_on")
            cell2.vRadio.image = UIImage(named: "radio_on")
            cell2.mainBackground.backgroundColor = hexStringToUIColor(hex: "#C6D8FF", op: 0.3)
            self.selectedRowIND = indexPath.section
            self.ip = indexPath
        }
    }
}
