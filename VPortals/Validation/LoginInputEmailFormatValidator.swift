//
//  LoginInputEmailFormatValidator.swift
//  Clean Login
//
//  Created by Ali Jawad on 17/05/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation

class LoginInputEmailFormatValidator: ValidatorBase, LoginInputValidatorProtocol {
    
    func validateLoginInput(PortalNumber: String, UserName: String, Password: String, errors: inout Dictionary<String, String>) {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if(!emailPred.evaluate(with: UserName)) {
            errors["email"] = "Email format is incorrect"
            return

        }
        
        if let successor: LoginInputValidatorProtocol = self.successor as? LoginInputValidatorProtocol {
            successor.validateLoginInput(PortalNumber: PortalNumber, UserName: UserName, Password: Password, errors: &errors)
        }
    }
}
