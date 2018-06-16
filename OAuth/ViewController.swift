//
//  ViewController.swift
//  OAuth
//
//  Created by Станислав Тищенко on 09.06.2018.
//  Copyright © 2018 Станислав Тищенко. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore

class ViewController: UIViewController, LoginButtonDelegate {
    var accessToken: String?
    lazy var login = Login(delegate: self)
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var logOutButtonOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func button(_ sender: Any) {
        login.loginButton(email: emailText.text!, password: passwordText.text!, activityIndicator: activityIndicator)
        emptyField()
    }

    @IBAction func clearCookies(_ sender: Any) {
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            print(cookies)
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }
        loginButtonOutlet.isEnabled = true
        logOutButtonOutlet.isEnabled = false
    }

    func emptyField() {
        if emailText.text == "" {
            emailText.layer.borderWidth = 1
            emailText.layer.borderColor = UIColor.red.cgColor
        } else {
            emailText.layer.borderWidth = 0
        }
        if passwordText.text == "" {
            passwordText.layer.borderWidth = 1
            passwordText.layer.borderColor = UIColor.red.cgColor
        } else {
            passwordText.layer.borderWidth = 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordText.isSecureTextEntry = true
        var isAuth = 1
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                print(cookies)
                if cookie.value(forKey: "name") as? String == "uauth"
                || cookie.value(forKey: "name") as? String == "acct" {
                    loginButtonOutlet.isEnabled = false
                    logOutButtonOutlet.isEnabled = true
                    isAuth = 0
                    break
                } else {
                    logOutButtonOutlet.isEnabled = false
                }
            }
        }
        if isAuth == 1 {
            logOutButtonOutlet.isEnabled = false
        }
    }
    func logInButton(isHidden: Bool) {
        self.loginButtonOutlet.isEnabled = isHidden
    }
    func logOutButton(isHidden: Bool) {
        self.logOutButtonOutlet.isEnabled = isHidden
    }
    func getAccessToken(accessToken: String) {
        self.accessToken = accessToken
    }
}



