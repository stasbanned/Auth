//
//  Login.swift
//  OAuth
//
//  Created by Станислав Тищенко on 16.06.2018.
//  Copyright © 2018 Станислав Тищенко. All rights reserved.
//

import Foundation
import Alamofire

protocol LoginButtonDelegate {
    func logInButton(isHidden: Bool)
    func logOutButton(isHidden: Bool)
    func getAccessToken(accessToken: String)
}

class Login {
    var delegate: LoginButtonDelegate?
    init(delegate: LoginButtonDelegate) {
        self.delegate = delegate
    }
    func loginButton(email: String, password: String, activityIndicator: UIActivityIndicatorView) {
        var parametersEmailAndPassword: Parameters = ["Email": "",
                                                      "Password": ""]
        if email != "" && password != "" {
            activityIndicator.startAnimating()
            parametersEmailAndPassword["Email"] = email
            parametersEmailAndPassword["Password"] = password
            request("https://stackoverflow.com/users/login", method: .post,
            parameters: parametersEmailAndPassword).responseJSON { _ in
            request("https://stackoverflow.com/oauth/dialog?client_id=12653&scope=read_inbox,no_expiry&redirect_uri=https://stackexchange.com/oauth/login_success").response { response in
                print(response.response?.url)
                if "\(response.response?.url)".contains("access_token") {
                    self.delegate?.getAccessToken(accessToken: "\(response.response?.url)".components(separatedBy: "=")[1])
                    //self.accessToken = "\(response.response?.url)".components(separatedBy: "=")[1]
                    print("Access token = " + "\(response.response?.url)".components(separatedBy: "=")[1])
                    self.delegate?.logInButton(isHidden: false)
                    self.delegate?.logOutButton(isHidden: true)
//                    self.loginButtonOutlet.isEnabled = false
//                    self.logOutButtonOutlet.isEnabled = true
                }
                activityIndicator.stopAnimating()
            }
            }
        }
    }
}
