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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    let cellReuseIdentifier = "cell"
    var refreshControl = UIRefreshControl()
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var nameText: UITextView!
    @IBOutlet weak var nameTextB: UITextView!
    @IBOutlet weak var logoTop: UIImageView!
    @IBOutlet weak var nobimv: UIImageView!
    @IBOutlet weak var noblvt: UILabel!
    @IBOutlet weak var noblvd: UILabel!
    @IBOutlet weak var uiTabBarOutlet: UITabBar!
    
    let cellSpacingHeight: CGFloat = 22
    
    var albumArray = [AnyObject]()
    var greeting = ""
    var sectorId: Int = 0
    
    override func viewDidLoad() {
           super.viewDidLoad()
           uiTabBarOutlet.selectedItem = uiTabBarOutlet.items?[1]
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
                           let header : HTTPHeaders = ["AuthToken" : authToken, "DeviceToken" : "52.170.151.93", "Content-Type": "application/x-www-form-urlencoded"]

                           AF.request("https://api.votingportals.com/api/Ballot/List", method: .post, headers: header).responseJSON { response in
                               //SVProgressHUD.dismiss()
                               hud.dismiss()
                               if let data = response.data {
                                   let prJson: JSON = JSON(data)
                                   let prJsonData: JSON = JSON(prJson["Data"])
                                   if prJson["Flag"] != false {
                                     debugPrint(prJson["Message"])
                                    
                                    if let fetchedImages = prJsonData.arrayObject as [AnyObject]? {
                                        self.albumArray = fetchedImages
                                    }
                                      
                                      if let resData = prJsonData[].arrayObject {
                                          self.albumArray = resData as [AnyObject]; ()
                                      }
                                      if self.albumArray.count > 0 {
                                        
                                        self.tableView.reloadData()
                                      }
                                      else{
                                        debugPrint("self.albumArray.count")
                                        debugPrint(self.albumArray.count)
                                        self.nobimv.isHidden = false
                                        self.noblvt.isHidden = false
                                        self.noblvd.isHidden = false
                                      }
                                   }
                                   else {
                                       debugPrint(prJson["Message"])
                                   }
                               }
                               
                           }
        }
        
        if let fName = defaults.string(forKey: "FirstName")
        {
            greetingLogic(fname: fName)
        }
        
        if let associationLogoURL = defaults.string(forKey: "AssociationLogoURL")
        {
            print(associationLogoURL)
            logoTop.sd_setImage(with: URL(string: associationLogoURL))
        }
        
        self.sectorId = defaults.integer(forKey: "SectorID")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableView.addSubview(refreshControl)
        //print(self.sectorId);
       }
    @objc func refresh(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
         if let authToken = defaults.string(forKey: "AuthToken")
         {
                        //let parameters = []
                        let header : HTTPHeaders = ["AuthToken" : authToken, "DeviceToken" : "52.170.151.93", "Content-Type": "application/x-www-form-urlencoded"]

                        AF.request("https://api.votingportals.com/api/Ballot/List", method: .post, headers: header).responseJSON { response in
                            
                            self.refreshControl.endRefreshing()
                            
                            if let data = response.data {
                                let prJson: JSON = JSON(data)
                                let prJsonData: JSON = JSON(prJson["Data"])
                                if prJson["Flag"] != false {
                                  debugPrint(prJson["Message"])
                                 
                                 if let fetchedImages = prJsonData.arrayObject as [AnyObject]? {
                                     self.albumArray = fetchedImages
                                 }
                                   
                                   if let resData = prJsonData[].arrayObject {
                                       self.albumArray = resData as [AnyObject]; ()
                                   }
                                   if self.albumArray.count > 0 {
                                     
                                     self.tableView.reloadData()
                                   }
                                   else{
                                     debugPrint("self.albumArray.count")
                                     debugPrint(self.albumArray.count)
                                     self.nobimv.isHidden = false
                                     self.noblvt.isHidden = false
                                     self.noblvd.isHidden = false
                                   }
                                }
                                else {
                                    debugPrint(prJson["Message"])
                                }
                            }
                            
                        }
     }
    }
    func greetingLogic(fname: String) {
        let date = NSDate()
        let calendar = NSCalendar.current
        let currentHour = calendar.component(.hour, from: date as Date)
        let hourInt = Int(currentHour.description)!

        if hourInt >= 12 && hourInt <= 16 {
            greeting = "Good Afternoon, "+fname
        }
        else if hourInt >= 0 && hourInt <= 12 {
            greeting = "Good Morning, "+fname
        }
        else if hourInt >= 16 && hourInt <= 20 {
            greeting = "Good Evening, "+fname
        }
        else if hourInt >= 20 && hourInt <= 24 {
            greeting = "Good Night, "+fname
        }
        else{
            greeting = "Hello, "+fname
        }

        nameText.text = greeting
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        let result = formatter.string(from: Date())
        
        nameTextB.text = result
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 1) {
            debugPrint("1")
        } else if(item.tag == 2) {
            debugPrint("2")
        } else if(item.tag == 3) {
            let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                 // print("Handle Yes logic here")
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

                                AF.request("https://api.votingportals.com/api/Login/LogOut", method: .post, headers: header).responseJSON { response in
                                    //SVProgressHUD.dismiss()
                                    hud.dismiss()
                                    if let data = response.data {
                                        let prJson: JSON = JSON(data)
//                                        let prJsonData: JSON = JSON(prJson["Data"])
                                        if prJson["Flag"] != false {
                                          debugPrint(prJson["Message"])
                                         
                                            let dictionary = defaults.dictionaryRepresentation()
                                             dictionary.keys.forEach { key in
                                                 defaults.removeObject(forKey: key)
                                             }

                         self.navigateToLoginViewController()
                                         
                                        }
                                        else {
                                            debugPrint(prJson["Message"])
                                        }
                                    }
                                    
                                }
             }
               
                
            }))

            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle No Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
 
    func navigateToLoginViewController() {
        
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated:true)
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
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "VotingCell", for: indexPath) as! VotingTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.mainBackground.layer.borderColor = UIColor.white.cgColor
        cell.mainBackground.layer.borderWidth = 0.5
        cell.mainBackground.layer.cornerRadius = 20
        cell.mainBackground.clipsToBounds = true
        
        let vTitle = albumArray[indexPath.row]["VoteText"] as? String
        cell.vTitle.text = vTitle
        
        let vDateTime = albumArray[indexPath.row]["MeetingDateTime"] as? String
        let vUnit = albumArray[indexPath.row]["UnitNumber"] as? String
        let strUnit = NSMutableAttributedString(string:"Unit: \(vUnit!) ")
        let vAddress = albumArray[indexPath.row]["Address"] as? String
        let strAddress = NSMutableAttributedString(string:"Address: \(vAddress!) ")
        
        let vHasVoted = albumArray[indexPath.row]["HasVoted"] as? Bool
        
        let clrPending = [NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "#FF5C00", op: 1.0)]
        let clrCompleted = [NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "#55CE47", op: 1.0)]
        
            let strPending = NSMutableAttributedString(string:"Pending", attributes:clrPending)

            let strCompleted = NSMutableAttributedString(string:"Completed", attributes:clrCompleted)
        
        if(vHasVoted == true){
            strUnit.append(strCompleted)
        }
        else{
            strUnit.append(strPending)
        }
        
        if (self.sectorId == 1) {
            
            cell.vAddress.attributedText = strUnit
            cell.vUnit.isHidden = true
        }
        else if (self.sectorId == 2) {
           
            
            cell.vUnit.attributedText = strUnit
            cell.vAddress.attributedText = strAddress
        }
        else{
            
            if(vHasVoted == true){
                cell.vAddress.attributedText = strCompleted
            }
            else{
                cell.vAddress.attributedText = strPending
            }
            
            cell.vUnit.isHidden = true
        }
        
        //if(vDateTime)
        if (vDateTime ?? "").isEmpty {
            let voteTypeID = albumArray[indexPath.row]["VoteTypeID"] as! Int
            if voteTypeID == 1{
                cell.vDateTime.text = "No Close Date"
            }
            else{
                cell.vDateTime.text = ""
            }
            cell.vDaysAgo.text = ""
        }
        else{
            
            let dateFormatter = DateFormatter()// set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let fdate = dateFormatter.date(from:vDateTime!)!
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "MM/dd/yyyy"
            
            let result = formatter.string(from: fdate)
            cell.vDateTime.text = "Closes: "+result
            
            let eDate = formatter.date(from:result)!
            
            let csdate = formatter.string(from: Date())
            
            let sDate = formatter.date(from: csdate)!
            
            let calendar = Calendar.current
//
//            // Replace the hour (time) of both dates with 00:00
//            let date1 = calendar.startOfDay(for: Date())
//            let date2 = dateFormatter.date(from: fdate!)!
//
//            //let date2 = calendar.startOfDay(for: fdate)
//
            let components = calendar.dateComponents([.day], from: sDate, to: eDate)
            
            
//            if (components.day! > 0) {
             cell.vDaysAgo.text = String(components.day!)+" days left"
//            }
//            else{
//                cell.vDaysAgo.text = ""
//            }
            
        }
        
        //cell.textLabel?.text = title["VoteText"] as? String
        // set the text from the data model
        //cell.myLabel?.text = self.albumArray[indexPath.row]
//        debugPrint("cellForRowAt")
//        debugPrint(title["VoteText"]!!)
        
        return cell
    }
    
    func hexStringToUIColor(hex:String, op:Float) -> UIColor {
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
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! VotingTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "VotingCell", for: indexPath) as! VotingTableViewCell
        print("cell.vDateTime.text")
        print(cell.vDateTime.text ?? "")
        
        let voteTypeID = albumArray[indexPath.row]["VoteTypeID"] as! Int
        //if voteTypeID == 1{
            
        let vDateTime = albumArray[indexPath.row]["MeetingDateTime"] as? String
                      
        let hasVoted = albumArray[indexPath.row]["HasVoted"] as! Bool
        
        let isRequireVotingCode = albumArray[indexPath.row]["IsRequireVotingCode"] as! Bool
        
        if (!hasVoted) {
         
            if (isRequireVotingCode) {
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let votpViewController = storyBoard.instantiateViewController(withIdentifier: "VOTPViewController") as! VOTPViewController
            if (vDateTime ?? "").isEmpty {
                if voteTypeID == 1{
                    votpViewController.closeDate = "No Close Date"
                }
                else{
                    votpViewController.closeDate = ""
                }
            }
            else{
                votpViewController.closeDate = cell.vDateTime.text!
            }
            
            votpViewController.votigId = self.albumArray[indexPath.row]["VoteID"] as! Int
            votpViewController.vTypeId = self.albumArray[indexPath.row]["VoteTypeID"] as! Int
            votpViewController.vName = self.albumArray[indexPath.row]["VoteText"] as! String
            votpViewController.vAddress = self.albumArray[indexPath.row]["Address"] as! String
            votpViewController.vUnit = self.albumArray[indexPath.row]["UnitNumber"] as! String
            
            self.navigationController?.pushViewController(votpViewController, animated:true)
            }
        }
            else{
                let vTypeId: Int = self.albumArray[indexPath.row]["VoteTypeID"] as! Int
                let votigId: Int = self.albumArray[indexPath.row]["VoteID"] as! Int
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
                        
                        let parameters = ["VoteID": String(votigId), "VotingCode": "", "Address": self.albumArray[indexPath.row]["Address"] as! String]

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
                                                if vTypeId == 1{
                                                       let vStartViewController = storyBoard.instantiateViewController(withIdentifier: "VStartViewController") as! VStartViewController
                                                    if (vDateTime ?? "").isEmpty {
                                                        if voteTypeID == 1{
                                                            vStartViewController.closeDate = "No Close Date"
                                                        }
                                                        else{
                                                            vStartViewController.closeDate = ""
                                                        }
                                                    }
                                                    else{
                                                        vStartViewController.closeDate = cell.vDateTime.text!
                                                    }
                                                        vStartViewController.votingToken = vToken
                                                        vStartViewController.vName = self.albumArray[indexPath.row]["VoteText"] as! String
                                                vStartViewController.votigId = self.albumArray[indexPath.row]["VoteID"] as! Int
                                                       self.navigationController?.pushViewController(vStartViewController, animated:true)
                                                }
                                                else{
                                                    let sStartViewController = storyBoard.instantiateViewController(withIdentifier: "SurveyStartViewController") as! SurveyStartViewController
                                                    if (vDateTime ?? "").isEmpty {
                                                        if voteTypeID == 1{
                                                            sStartViewController.closeDate = "No Close Date"
                                                        }
                                                        else{
                                                            sStartViewController.closeDate = ""
                                                        }
                                                    }
                                                    else{
                                                        sStartViewController.closeDate = cell.vDateTime.text!
                                                    }
                                                    sStartViewController.votingToken = vToken
                                                    sStartViewController.vName = self.albumArray[indexPath.row]["VoteText"] as! String
                                                    sStartViewController.votigId = self.albumArray[indexPath.row]["VoteID"] as! Int
                                                    sStartViewController.vAddress = self.albumArray[indexPath.row]["Address"] as! String
                                                    sStartViewController.vUnit = self.albumArray[indexPath.row]["UnitNumber"] as! String
                                                    self.navigationController?.pushViewController(sStartViewController, animated:true)
                                                }
                                                   }
                                           }
                                           else {
                                            hud.dismiss()
                                               debugPrint(prJson["Message"])
                                            
                                           }
                                       }
                                       
                                   }
                }
                
                
            }
        }
    }
}
