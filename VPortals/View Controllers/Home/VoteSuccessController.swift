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

class VoteSuccessController: UIViewController, UITabBarDelegate {
    
    let cellReuseIdentifier = "cell"
    var closeDate: String = ""
    var vName: String = ""
    var vUnit: String = ""
    @IBOutlet weak var logoTop: UIImageView!
    @IBOutlet weak var nameText: UITextView!
    @IBOutlet weak var nameTextB: UITextView!
    @IBOutlet weak var textunit: UILabel!
    @IBOutlet weak var textasso: UILabel!
    @IBOutlet weak var uiTabBarOutlet: UITabBar!
    
    let cellSpacingHeight: CGFloat = 22
    
    var albumArray = [AnyObject]()
    var greeting = ""
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        
        let defaults = UserDefaults.standard
        
        if let associationLogoURL = defaults.string(forKey: "AssociationLogoURL")
        {
            //logoTop.sd_setImage(with: URL(string: associationLogoURL), placeholderImage: UIImage(named: "new_logo.png"))
            logoTop.sd_setImage(with: URL(string: associationLogoURL))
        }
        nameText.text = vName
        
        nameTextB.text = closeDate
        
        let vunitdata = "Your selection has been counted for \(vUnit) in connection with:"
        self.textunit.text = vunitdata
        
        if let associationName = defaults.string(forKey: "AssociationName")
        {
        let vassdata = "Email sent by Voting Portals on behalf of \(associationName). If this message was found in your SPAM folder, please add our email to your safe-senders list."
            self.textasso.text = vassdata
        }
        
        
       }
    @IBAction func actCloseVoting(_ sender: UIButton) {
       
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(homeViewController, animated:true)
        }
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 1) {
            debugPrint("1")
        } else if(item.tag == 2) {
            self.navigateToHomeViewController()
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
    
    func navigateToHomeViewController() {
        
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(homeViewController, animated:true)
        }
        
    }
 
    func navigateToLoginViewController() {
        
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated:true)
        }
        
    }

}
