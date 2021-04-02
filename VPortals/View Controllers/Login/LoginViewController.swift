//
//  ViewController.swift
//  Clean Login
//
//

import Foundation
import UIKit
import Alamofire
import JGProgressHUD
import SwiftyJSON
//import SheetViewController
import FittedSheets

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldPortalNumber: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldRemember: UISwitch!
    @IBOutlet weak var textError: UILabel!
    @IBOutlet var cb4: CheckBox!
    let bWidth: CGFloat = 1
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.addSubview(scrollView)
        cb4.style = .tick
        //cb4.borderStyle = .roundedSquare(radius: 12)
        cb4.borderStyle = .roundedSquare(radius: 2.24)
//        cb4.checkboxBackgroundColor = .clear
        cb4.layer.cornerRadius = 5.0;
//        self.textFieldPortalNumber.layer.borderColor = UIColor.white.cgColor
//        self.textFieldPortalNumber.layer.cornerRadius = 8.0
//        self.textFieldPortalNumber.layer.borderWidth = bWidth
//
//        self.textFieldEmail.layer.cornerRadius = 8.0
//        self.textFieldPassword.layer.cornerRadius = 8.0
        
        self.textFieldPortalNumber.tag = 0
        self.textFieldEmail.tag = 1
        self.textFieldPassword.tag = 2
                
        self.textFieldPortalNumber.delegate = self
        self.textFieldEmail.delegate = self
        self.textFieldPassword.delegate = self
        //assignbackground()
    }
    override var prefersStatusBarHidden: Bool {
      return true
    }
//    func assignbackground(){
//            let background = UIImage(named: "login_bg.png")
//
//            var imageView : UIImageView!
//            imageView = UIImageView(frame: view.bounds)
//        //imageView.contentMode =  UIView.ContentMode.scaleAspectFill
//            imageView.clipsToBounds = true
//            imageView.image = background
//            //imageView.center = view.center
//            view.addSubview(imageView)
//            self.view.sendSubviewToBack(imageView)
//        }
//    override func viewWillLayoutSubviews(){
//    super.viewWillLayoutSubviews()
//    scrollView.contentSize = CGSize(width: 375, height: 800)
//    }
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    // print("Hello viewWillAppear")
    self.textFieldPortalNumber.layer.borderColor = UIColor.white.cgColor
    self.textFieldEmail.layer.borderColor = UIColor.white.cgColor
    self.textFieldPassword.layer.borderColor = UIColor.white.cgColor
    self.textError.isHidden = true
    self.textError.text = ""
    self.textFieldPortalNumber.text = ""
    self.textFieldEmail.text = ""
    self.textFieldPassword.text = ""
    
    
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textFieldPortalNumber {
            self.textFieldEmail.becomeFirstResponder()
        } else if textField == self.textFieldEmail {
            self.textFieldPassword.becomeFirstResponder()
        }
        else if textField == self.textFieldPassword {
            self.textFieldPassword.resignFirstResponder()
        }
            //...so on and so forth....
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.textFieldPortalNumber.isFirstResponder == true {
            self.textFieldPortalNumber.placeholder = ""
        }
        else if self.textFieldEmail.isFirstResponder == true {
            self.textFieldEmail.placeholder = ""
        }
        else if self.textFieldPassword.isFirstResponder == true {
            self.textFieldPassword.placeholder = ""
        }
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
       
        switch textField {
        case self.textFieldEmail:
            self.textFieldEmail.becomeFirstResponder()
            
        case self.textFieldPassword:
            self.textFieldPassword.becomeFirstResponder()
        default:
            self.textFieldPassword.resignFirstResponder()
        }
    }
    
    @IBAction func actShowIntro(_ sender: UIButton) {
     
        view.endEditing(true)
        //let controller = HelpViewController()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let helpController = storyBoard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController

        let options = SheetOptions(
            useInlineMode: true
        )

        let sheetController = SheetViewController(controller: helpController, sizes: [.percent(0.77), .fullscreen], options: options)
        sheetController.allowGestureThroughOverlay = false
        sheetController.dismissOnOverlayTap = true
        sheetController.overlayColor = UIColor(white: 1, alpha: 0.0)
        sheetController.willMove(toParent: self)
        sheetController.cornerRadius = 15
        self.addChild(sheetController)
        view.addSubview(sheetController.view)
        sheetController.didMove(toParent: self)

        sheetController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sheetController.view.topAnchor.constraint(equalTo: view.topAnchor),
            sheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // animate in
        sheetController.animateIn()
        
    }
    
    @IBAction func actShowReset(_ sender: UIButton) {
     
        //print("Hello")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "ResetViewController") as! ResetViewController
        self.navigationController?.pushViewController(homeViewController, animated:true)
        
    }

    @IBAction func actShowHome(_ sender: UIButton) {
        
        let hud = JGProgressHUD()
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Processing..."
        hud.show(in: self.view)
        
        let parameters = ["PortalNumber": textFieldPortalNumber.text ?? "", "UserName": textFieldEmail.text ?? "", "Password": textFieldPassword.text ?? "", "deviceToken":"52.170.151.93"]

        AF.request("https://api.votingportals.com/api/Login/LoginAuthentication", method: .post, parameters: parameters).responseJSON { response in
            //SVProgressHUD.dismiss()
            //hud.dismiss()
            if let data = response.data {
                let prJson: JSON = JSON(data)
                
                if prJson["Flag"] != false {
                  //debugPrint(prJson["Message"])
                    UIView.animate(withDuration: 0.1, animations: {
                                           hud.textLabel.text = nil
                                            hud.detailTextLabel.text = prJson["Message"].string!
//                                           hud.detailTextLabel.text = nil
                                           hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                                       })
                   hud.dismiss()
                let dJson: JSON = JSON(prJson["Data"])
                
                let defaults = UserDefaults.standard
                defaults.set(dJson["FirstName"].string!, forKey: "FirstName")
                defaults.set(dJson["LastName"].string!, forKey: "LastName")
                defaults.set(dJson["EmailAddress"].string!, forKey: "EmailAddress")
                defaults.set(dJson["PhoneNo"].string!, forKey: "PhoneNo")
                defaults.set("https://cdn.votingportals.com"+dJson["AssociationLogoURL"].string!, forKey: "AssociationLogoURL")
                defaults.set(dJson["AuthToken"].string!, forKey: "AuthToken")
                    defaults.set(dJson["SectorID"].intValue, forKey: "SectorID")
                defaults.set(dJson["AssociationName"].string!, forKey: "AssociationName")
                    
                    if self.cb4.isChecked {
                       defaults.set("On", forKey: "Remember")
                    }
                    else{
                        defaults.set(nil, forKey: "Remember")
                    }
                    
                self.navigateToHomeViewController()
                }
                else {
                    self.textFieldPortalNumber.layer.borderColor = UIColor.red.cgColor
                    self.textFieldEmail.layer.borderColor = UIColor.red.cgColor
                    self.textFieldPassword.layer.borderColor = UIColor.red.cgColor
                    self.textError.isHidden = false
                    self.textError.text = prJson["Message"].string!
                    debugPrint(prJson["Message"])
                    hud.dismiss()
                    //let msg: String = prJson["Message"].string!
//                    UIView.animate(withDuration: 0.1, animations: {
//                        hud.textLabel.text = nil
//                        hud.detailTextLabel.text = prJson["Message"].string!
////                        hud.detailTextLabel.text = nil
//                        hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                    })
//                    
//                    hud.dismiss(afterDelay: 1.0)
                    
                }
            }
            
        }
        
    }
    
    func navigateToHomeViewController() {
        
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(homeViewController, animated:true)
        }
        
    }
    
}
