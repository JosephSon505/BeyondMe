//
//  AddViewController.swift
//  BeyondMe
//
//  Created by Joseph Son on 12/11/19.
//  Copyright © 2019 Joseph Son. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    //MARK: - Variables and IBOutlets
    var model = ResumeModel.shared
    var email: String = ""
    public var purpose = "Education"
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setDelegate()
        if purpose == "Education" {
            setAddEducation()
        } else {
            setAddWorkExperience()
        }
        getEmail()
    }

    // set delegate for keyboard features
    private func setDelegate() {
        tf1.delegate = self
        tf2.delegate = self
        tf3.delegate = self
        tf4.delegate = self
    }
    
    private func getEmail() {
        if let userEmail = Auth.auth().currentUser?.email {
            email = userEmail
        }
    }
    
    // reset for Add Education
    private func setAddEducation() {
        saveButton.isEnabled = false
        
        label1.text = "School:"
        label2.text = "Major:"
        label3.text = "GPA: "
        label4.text = "Graduation Date:"
        
        tf1.text = ""
        tf2.text = ""
        tf3.text = ""
        tf4.text = ""
        
        tf1.placeholder = "Enter school here"
        tf2.placeholder = "Enter major here"
        tf3.placeholder = "Enter gpa here"
        tf4.placeholder = "Enter graduation date here"
        
        segmentedControl.selectedSegmentIndex = 0
        navbar.title = "Add Education"
    }
    
    // reset for Add Work Experience
    private func setAddWorkExperience() {
        saveButton.isEnabled = false
        
        label1.text = "Company:"
        label2.text = "Position:"
        label3.text = "Start Date: "
        label4.text = "End Date:"
        
        tf1.text = ""
        tf2.text = ""
        tf3.text = ""
        tf4.text = ""
        
        tf1.placeholder = "Enter company name here"
        tf2.placeholder = "Enter position here"
        tf3.placeholder = "Enter start date here"
        tf4.placeholder = "Enter end date here"
        
        segmentedControl.selectedSegmentIndex = 1
        navbar.title = "Add Work Experience"
    }
    
    
    // MARK: - IBActions
    
    // MARK: Navbar
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let educations = model.getEducations()
        let workExperiences = model.getWorkExperiences()

        // array of dictionary objects: keys are strings and values are strings
        var eduCounter = 0
        var eduArray = [[String: Any]]()
        for edu in educations {
            let newEdu = [ "School": edu.getSchool(),
                           "Major": edu.getMajor(),
                           "GPA": edu.getGPA(),
                           "GradDate": edu.getGradDate()
            ]
            let addEDU: [String: Any] = [String(eduCounter): newEdu]
            eduArray.append(addEDU)
            eduCounter = eduCounter + 1
        }

        var weCounter = 0
        var weArray = [[String: Any]]()
        for we in workExperiences {
            let newWE = [ "Company": we.getCompany(),
                          "Position": we.getPosition(),
                          "StartDate": we.getStartDate(),
                          "EndDate": we.getEndDate()
            ]
            let addWE: [String: Any] = [String(weCounter): newWE]
            weArray.append(addWE)
            weCounter = weCounter + 1
        }

        if let one = tf1.text, let two = tf2.text, let three = tf3.text, let four = tf4.text {
            if segmentedControl.selectedSegmentIndex == 0 {
                let newEDU = [ "School": one,
                               "Major": two,
                               "GPA": three,
                               "GradDate": four
                ]
                let addEDU: [String: Any] = [String(eduCounter): newEDU]
                eduArray.append(addEDU)
                eduCounter = eduCounter + 1
            } else {
                let newWE = [ "Company": one,
                              "Position": two,
                              "StartDate": three,
                              "EndDate": four
                ]
                let addWE: [String: Any] = [String(weCounter): newWE]
                weArray.append(addWE)
                weCounter = weCounter + 1
            }
        }

        let eduRef = db.collection("Education").document(email)
        let weRef = db.collection("Work Experience").document(email)
        
        for edu in eduArray {
            let _ = eduRef.updateData(edu)
        }
        
        for we in weArray {
            let _ = weRef.updateData(we)
        }

        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        // reset the page and then dismiss the modal
        setAddEducation()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedBackground(_ sender: Any) {
        tf1.resignFirstResponder()
        tf2.resignFirstResponder()
        tf3.resignFirstResponder()
        tf4.resignFirstResponder()
    }
    
    
    // MARK: SegmentedControl
    
    // toggle between Add Education and Add Work Experience
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            setAddEducation()
        } else {
            setAddWorkExperience()
        }
    }
    
    
    // MARK: - Keyboard Logistics
    
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
                enableSaveButton(updatedText, tf2.text ?? "", tf3.text ?? "", tf4.text ?? "")
            } else if textField == tf2 {
                enableSaveButton(tf1.text ?? "", updatedText, tf3.text ?? "", tf4.text ?? "")
            } else if textField == tf3 {
                enableSaveButton(tf1.text ?? "", tf2.text ?? "", updatedText, tf4.text ?? "")
            } else {
                enableSaveButton(tf1.text ?? "", tf2.text ?? "", tf3.text ?? "", updatedText)
            }
        }
        
        return true
    }
    
    // enable / disable the button
    private func enableSaveButton(_ field1: String, _ field2: String, _ field3: String, _ field4: String) {
        saveButton.isEnabled = field1.count > 0 && field2.count > 0 && field3.count > 0 && field4.count > 0
    }
}
