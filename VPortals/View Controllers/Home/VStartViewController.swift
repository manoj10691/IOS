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

class VStartViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextView!
    @IBOutlet weak var nameTextB: UITextView!
    @IBOutlet weak var logoTop: UIImageView!
    @IBOutlet weak var lvDateThis: UILabel!
    
    var closeDate: String = ""
    var votingToken: String = ""
    var vName: String = ""
    var votigId: Int = 0
    
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
    
    
    
    @IBAction func actStartVoting(_ sender: UIButton) {
       
        DispatchQueue.main.async {
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
                   let vStartViewController = storyBoard.instantiateViewController(withIdentifier: "VOptionViewController") as! VOptionViewController
            vStartViewController.closeDate = self.nameTextB.text
            vStartViewController.votingToken = self.votingToken
            vStartViewController.vName = self.nameText.text
            vStartViewController.votigId = self.votigId
                   self.navigationController?.pushViewController(vStartViewController, animated:true)
               }
        
    }
    
}
