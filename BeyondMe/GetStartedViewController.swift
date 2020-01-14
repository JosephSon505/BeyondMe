//
//  GetStartedViewController.swift
//  BeyondMe
//
//  Created by Joseph Son on 12/12/19.
//  Copyright © 2019 Joseph Son. All rights reserved.
//

import UIKit
import FirebaseAuth

class GetStartedViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets and Variables
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var email: String = ""
    
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getEmail()
        
        // Do any additional setup after loading the view.
        tf1.delegate = self
        tf2.delegate = self
        tf3.delegate = self
        tf4.delegate = self
        
        titleLabel.text = "Add Education"
        label1.text = "School"
        label2.text = "Major"
        label3.text = "GPA"
        label4.text = "Graduation Date"
        
        tf1.placeholder = "Enter School"
        tf2.placeholder = "Enter Major"
        tf3.placeholder = "Enter GPA"
        tf4.placeholder = "Enter Graduation Date"
        
        nextButton.isEnabled = false
    }
    
    private func getEmail() {
        if let userEmail = Auth.auth().currentUser?.email {
            email = userEmail
        }
    }
    
    
    // MARK: - Keyboard Logic
    
    // automatically focus the next text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tf1 {
            tf1.resignFirstResponder()
            tf2.becomeFirstResponder()
        } else if textField == tf2 {
            tf2.resignFirstResponder()
            tf3.becomeFirstResponder()
        } else if textField == tf3 {
            tf3.resignFirstResponder()
            tf4.becomeFirstResponder()
        } else {
            tf4.resignFirstResponder()
        }
        
        return true
    }
    
    // update after each input and see if button should be enabled
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if textField == tf1 {
                enableNextButton(updatedText, tf2.text ?? "", tf3.text ?? "", tf4.text ?? "")
            } else if textField == tf2 {
                enableNextButton(tf1.text ?? "", updatedText, tf3.text ?? "", tf4.text ?? "")
            } else if textField == tf3 {
                enableNextButton(tf1.text ?? "", tf2.text ?? "", updatedText, tf4.text ?? "")
            } else {
                enableNextButton(tf1.text ?? "", tf2.text ?? "", tf3.text ?? "", updatedText)
            }
        }
        
        return true
    }
    
    // enable / disable the button
    private func enableNextButton(_ field1: String, _ field2: String, _ field3: String, _ field4: String) {
        nextButton.isEnabled = field1.count > 0 && field2.count > 0 && field3.count > 0 && field4.count > 0
    }
    
    
    // MARK: - IBActions
    
    @IBAction func tappedBackground(_ sender: Any) {
        tf1.resignFirstResponder()
        tf2.resignFirstResponder()
        tf3.resignFirstResponder()
        tf4.resignFirstResponder()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        if let one = tf1.text, let two = tf2.text, let three = tf3.text, let four = tf4.text {
            if titleLabel.text == "Add Education" {
                // Add to database
                let newEDU = [ "School": one,
                               "Major": two,
                               "GPA": three,
                               "GradDate": four
                ]
                let addEDU: [String: Any] = ["0": newEDU]
                                
                db.collection("Education").document(email).setData(addEDU) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                    self.switchToWorkExperience()
                }
            } else {
                // Add to database --> then go to resume page
                let newWE = [ "Company": one,
                              "Position": two,
                              "StartDate": three,
                              "EndDate": four
                ]
                let addWE: [String: Any] = ["0": newWE]
                db.collection("Work Experience").document(email).setData(addWE) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                    self.switchVC(vc: "SuccessfulLogInVC")
                }
            }
        }
    }
    
    
    // MARK: - Helper Functions
    
    private func switchVC(vc: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: vc)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = newVC
    }
    
    private func switchToWorkExperience() {
        titleLabel.text = "Add Work Experience"
        label1.text = "Company"
        label2.text = "Position"
        label3.text = "Start Date"
        label4.text = "End Date"
        
        tf1.text = ""
        tf2.text = ""
        tf3.text = ""
        tf4.text = ""
        
        tf1.placeholder = "Enter Company"
        tf2.placeholder = "Enter Position"
        tf3.placeholder = "Enter Start Date"
        tf4.placeholder = "Enter End Date"
        
        nextButton.isEnabled = false
    }
}
