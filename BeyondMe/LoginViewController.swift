//
//  LoginViewController.swift
//  BeyondMe
//
//  Created by Joseph Son on 12/11/19.
//  Copyright © 2019 Joseph Son. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets and Variables
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    // MARK: - Setup and Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTF.delegate = self
        passwordTF.delegate = self
        passwordTF.textContentType = .password
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener({ (auth: Auth, user: User?) in
            // if authenticated
            if user != nil {
                // print message
                print("User is already logged in")
                
                // automatically switch to success view
                self.switchVC(vc: "SuccessfulLogInVC")
            } else {
                print("Not logged in.")
            }
        })
    }
    
    
    // MARK: - Helper Functions
    
    // switch current view controller to vc
    private func switchVC(vc: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: vc)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = newVC
    }
    
    
    // MARK: - Keyboard Logic
    
    // automatically focus the next text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            emailTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        } else {
            passwordTF.resignFirstResponder()
        }
        
        return true
    }
    
    
    // MARK: - IBActions
    
    @IBAction func tappedBackground(_ sender: Any) {
        self.emailTF.resignFirstResponder()
        self.passwordTF.resignFirstResponder()
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTF.text else { return }
        guard let pass = passwordTF.text else { return }
        
        // log in with password
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            // if login is not successful (error != nil)
            if error != nil {
                // print / display error
                print(error!.localizedDescription)

                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true)

                return
            }  else {
                // switch to success view
                self.switchVC(vc: "SuccessfulLogInVC")
            }
        }
    }
}
