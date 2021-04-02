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

class SurveySuccessController: UIViewController {
    
    var closeDate: String = ""
    var vName: String = ""
    var vAddress: String = ""
    var vUnit: String = ""
    @IBOutlet weak var logoTop: UIImageView!
    @IBOutlet weak var nameText: UITextView!
    @IBOutlet weak var nameTextB: UITextView!
    var sectorId: Int = 0
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        
        let defaults = UserDefaults.standard
        
        if let associationLogoURL = defaults.string(forKey: "AssociationLogoURL")
        {
            //logoTop.sd_setImage(with: URL(string: associationLogoURL), placeholderImage: UIImage(named: "new_logo.png"))
            logoTop.sd_setImage(with: URL(string: associationLogoURL))
        }
        if let fName = defaults.string(forKey: "FirstName")
        {
            nameText.text = fName
        }
        
//        self.sectorId = defaults.integer(forKey: "SectorID")
//
//        if (self.sectorId == 1) {
//
//        }
//        else if (self.sectorId == 2) {
//
//        }
//        else{
//
//        }
        //if let associationName = defaults.string(forKey: "AssociationName")
        //{
        let vassdata = "You have completed the \(vName) from \(vUnit). You will receive an email receipt shortly."
        
            nameTextB.text = vassdata
       // }
       }
    
    @IBAction func actCloseVoting(_ sender: UIButton) {
       
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(homeViewController, animated:true)
        }
        
    }
    

}
