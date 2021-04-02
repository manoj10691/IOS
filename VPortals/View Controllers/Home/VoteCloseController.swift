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

class VoteCloseController: UIViewController {
    
    var closeDate: String = ""
    var vName: String = ""
    @IBOutlet weak var logoTop: UIImageView!
    @IBOutlet weak var nameText: UITextView!
    @IBOutlet weak var nameTextB: UITextView!
    
    
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
       }
    @IBAction func actCloseVoting(_ sender: UIButton) {
       
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(homeViewController, animated:true)
        }
        
    }
    

}
