//
//  SignInViewController.swift
//  International Jokes
//
//  Created by Ephrem Beaino on 7/4/20.
//  Copyright © 2020 ephrembeaino. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var haveAnAccountButton: UIButton!
    
    var isSignUpScreen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            try? Auth.auth().signOut()
        }
        
        self.switchViewBetweenSignInUp()
    }
    
    func switchViewBetweenSignInUp() {
        self.retypePassword.isHidden = !self.isSignUpScreen
        if self.isSignUpScreen == true {
            self.signInButton.setTitle("Sign Up", for: .normal)
            self.haveAnAccountButton.setTitle("Already have an account? Sign In Here!", for: .normal)
            self.passwordTF.textContentType = .newPassword
        } else {
            self.signInButton.setTitle("Sign In", for: .normal)
            self.haveAnAccountButton.setTitle("Don't have an account? Sign UP here!", for: .normal)
            self.passwordTF.textContentType = .password
        }
    }

    @IBAction func didClickSignInButton(_ sender: Any) {
        if isSignUpScreen {
            //signUp
            Auth.auth().createUser(withEmail: emailTF.text ?? "", password: passwordTF.text ?? "") { (authResult, error) in
                if authResult != nil {
                    //SignUpSuccess
                    self.takeUserToHomeScreen()
                } else {
                    //Show failure alert
                    self.showAlert(title: "Sign Up FAILED", message: error?.localizedDescription ?? "")
                }
            }
        } else {
            //signIn
            Auth.auth().signIn(withEmail: emailTF.text ?? "", password: passwordTF.text ?? "") { (authResult, error) in
                if authResult != nil {
                    //SignIn success
                    self.takeUserToHomeScreen()
                } else {
                    //Show alert failure
                    self.showAlert(title: "Sign In Failed", message: "")
                }
            }
        }
    }
    @IBAction func signUpButtonPressed(_ sender: Any) {
        self.isSignUpScreen = !self.isSignUpScreen
        switchViewBetweenSignInUp()
    }
    
    func takeUserToHomeScreen() {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }
}
