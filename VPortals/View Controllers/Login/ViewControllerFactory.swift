//
//  ViewControllerFactory.swift
//  Clean Login
//
//

import Foundation
import UIKit

protocol ViewControllerFactory {
    
    func loginViewController(loginAction:@escaping(String, String, String) ->Void) -> UIViewController?
    func homeViewController() -> UIViewController?
     
}


class VPortalsLoginViewControllerFactory: ViewControllerFactory {
    func loginViewController(loginAction:@escaping(String, String, String) ->Void) -> UIViewController? {
        
        if(isKeyPresentInUserDefaults(key: "Remember")){
        let viewHomeController: HomeViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController

        return viewHomeController
        }
        else{
            let viewLogController: LoginViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            
            return viewLogController
        }
        
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func homeViewController() -> UIViewController? {
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        return homeViewController
    }

}
