//
//  VStartViewController.swift
//  VPortals
//
//  Created by Nadeem Khan on 19/01/21.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD
import SDWebImage

class SurveyStartViewController: UIViewController {
    
    @IBOutlet weak var nameTextT: UITextView!
    @IBOutlet weak var nameTextTB: UITextView!
    @IBOutlet weak var nameText: UITextView!
    @IBOutlet weak var nameTextB: UITextView!
    @IBOutlet weak var logoTop: UIImageView!
    
    var closeDate: String = ""
    var votingToken: String = ""
    var vName: String = ""
    var vAddress: String = ""
    var vUnit: String = ""
    var votigId: Int = 0
    var vTypeId: Int = 0
    var greeting = ""
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
        let defaults = UserDefaults.standard
        
        if let associationLogoURL = defaults.string(forKey: "AssociationLogoURL")
        {
            //logoTop.sd_setImage(with: URL(string: associationLogoURL))
            logoTop.sd_setImage(with: URL(string: associationLogoURL))
        }
        
        nameText.text = vName
        
        nameTextB.text = closeDate
        
        if let fName = defaults.string(forKey: "FirstName")
        {
            greetingLogic(fname: fName)
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

        nameTextT.text = greeting
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        let result = formatter.string(from: Date())
        
        nameTextTB.text = result
        
    }
    
    @IBAction func actStartVoting(_ sender: UIButton) {
       
        DispatchQueue.main.async {
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
                   let vStartViewController = storyBoard.instantiateViewController(withIdentifier: "SurveyOptionViewController") as! SurveyOptionViewController
            vStartViewController.closeDate = self.nameTextB.text
            vStartViewController.votingToken = self.votingToken
            vStartViewController.vName = self.vName
            vStartViewController.votigId = self.votigId
            vStartViewController.vAddress = self.vAddress
            vStartViewController.vUnit = self.vUnit
            vStartViewController.vTypeId = self.vTypeId
                   self.navigationController?.pushViewController(vStartViewController, animated:true)
               }
        
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
}
