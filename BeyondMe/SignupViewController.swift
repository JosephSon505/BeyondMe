//
//  SignupViewController.swift
//  BeyondMe
//
//  Created by Joseph Son on 12/11/19.
//  Copyright © 2019 Joseph Son. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class SignupViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets and Variables
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    // MARK: - Setup and Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    
    // MARK: - Keyboard Logic
    
    // automatically focus the next text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            nameTF.resignFirstResponder()
            emailTF.becomeFirstResponder()
        } else if textField == emailTF {
            emailTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        } else {
            passwordTF.resignFirstResponder()
        }
        
        return true
    }
    
    
    // MARK: - Helper Functions
    
    private func switchVC(vc: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: vc)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = newVC
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        nameTF.text = ""
        emailTF.text = ""
        passwordTF.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        guard let email = emailTF.text else { return }
        guard let pass = passwordTF.text else { return }
        
        // create user in firebase
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            // if user is not nil and error is nil
            if error == nil && user != nil {
                // resign first responder
                self.nameTF.resignFirstResponder()
                self.emailTF.resignFirstResponder()
                self.passwordTF.resignFirstResponder()
                
                // switch to success view controller
                self.switchVC(vc: "GetStartedVC")
           } else {
                // display error on screen
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true)
           }
       }
    }
    
    @IBAction func tappedBackground(_ sender: Any) {
        nameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
}
