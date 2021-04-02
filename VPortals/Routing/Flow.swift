//
//  Flow.swift
//  Clean Login
//
//  Created by Ali Jawad on 17/05/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation

class Flow {
    let router: RouterProtocol
    init(router: RouterProtocol) {
        self.router = router

    }
    
    func start(loginNetworkServiceExecutor: NetworkServiceExecutorProtocol, validator: LoginInputValidatorProtocol) {
                
        self.router.navigateToLoginViewControllerWithLoginAction {[weak self] (PortalNumber: String?, UserName: String?, Password: String?) in
            var errors: Dictionary<String, String> = Dictionary<String, String>()
            validator.validateLoginInput(PortalNumber: PortalNumber ?? "",UserName: UserName ?? "", Password: Password ?? "" , errors: &errors)
            
            if(errors.values.count == 0) {
                loginNetworkServiceExecutor.authenticateUser(PortalNumber: PortalNumber ?? "",UserName: UserName ?? "", Password: Password ?? "", successBlock: {
                    print("successBlock");
                    //print(successBlock["sdf"]);
                    //var json = JSON(data: successBlock!)

                    //print(json)
                    //print(successBlock.jspm);
                    //self?.router.navigateToHomeViewController()
                    
                }) { (error) in
                    self?.router.showMessage_networkError(message: error?.localizedDescription ?? "Something went wrong", retryHandler: {
                        // retry here
                    })
                }
            } else {
                self?.router.showErrorMessage(title: "Invalid input", message: errors.values.first ?? "Invalid input")
            }
            
            
        }
        
    }
    
    func navigateToHomeViewController() {
        self.router.navigateToHomeViewController()
    }
}
