//
//  ViewController.swift
//  BeyondMe
//
//  Created by Joseph Son on 11/26/19.
//  Copyright © 2019 Joseph Son. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import MessageUI

let db = Firestore.firestore()

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: - Variables and Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    var sectionHeaderHeight: CGFloat = 0.0
    var model = ResumeModel.shared
    var email: String = ""
    
    // MARK: - Setup and Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        editButton.setTitle("Edit", for: .normal)

        tableView.dataSource = self
        tableView.delegate = self
        
        self.getEmail()
        
        sectionHeaderHeight = tableView.dequeueReusableCell(withIdentifier: "headerCell")?.contentView.bounds.height ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.clearAllData()
        self.readDatabase()
    }
    
    // MARK: Table Initialization
    
    // enable editting the table to rearrange
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == 0 {
            model.rearrangeEducation(from: sourceIndexPath.row, to: destinationIndexPath.row)
        } else {
            model.rearrageWorkExperience(from: sourceIndexPath.row, to: destinationIndexPath.row)
        }
    }
    
    // 2 different sections for education and work experience
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Get custom header cells
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // HeaderTableViewCell is a custom cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        
        // setup the header with the correct title
        if section == 0 {
            cell.setup(title: "Education")
        } else {
            cell.setup(title: "Work Experience")
        }
        
        return cell.contentView
    }
    
    // full section header --> does not get cut off
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    // return the amount of elements in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return model.getEducationsCount()
        } else {
            return model.getWorkExperiencesCount()
        }
    }
    
    // return the correct custom cell for their respective sections
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // EducationCell and WorkCell are both custom cells
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "educationCell") as! EducationCell
            if let education = model.educations(at: indexPath.row) {
                print(education)
                cell.setup(school: education.getSchool(), major: education.getMajor(), gpa: education.getGPA(), gradDay: education.getGradDate())
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workCell") as! WorkCell
            if let we = model.workExperiences(at: indexPath.row) {
                cell.setup(company: we.getCompany(), position: we.getPosition(), startDate: we.getStartDate(), endDate: we.getEndDate())
            }
            return cell
        }
    }
    
    
    // MARK: - iMessage Functions
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func sendMessage() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = []
        composeVC.body = formatIntoMessage()
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    
    // MARK: - Email
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func sendEmail(type: String){
        let message = formatIntoMessage()
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([])
            mail.setSubject(type)
            mail.setMessageBody(message, isHTML: false)
            present(mail, animated: true)
        }
    }
    
    
    // MARK: - Helper Functions
    
    // read education and work experiences from database
    private func readDatabase() {
        let settings = db.settings
        db.settings = settings
                
        db.collection("Education").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for users in querySnapshot!.documents {
                    if users.documentID == self.email {
                        
                        let educations = users.data()
                        for education in educations.values {
                            let curr = education as! NSDictionary
                            let school: String = curr["School"] as! String
                            let major: String = curr["Major"] as! String
                            let gpa:String = curr["GPA"] as! String
                            let gradDate: String = curr["GradDate"] as! String
                            self.model.addEducation(school: school, major: major, gpa: gpa, gradDate: gradDate)
                        }
                    }
                }
                
                self.tableView.reloadData()
            }
        }
                
        db.collection("Work Experience").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.documentID == self.email {
                        let workExperience = document.data()
                        for we in workExperience.values {
                            let curr = we as! NSDictionary
                            let company = curr["Company"] as! String
                            let position = curr["Position"] as! String
                            let startDate = curr["StartDate"] as! String
                            let endDate = curr["EndDate"] as! String
                            self.model.addWorkExperience(company: company, position: position, startDate: startDate, endDate: endDate)
                        }
                    }
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    // get the current user's email
    private func getEmail() {
        if let userEmail = Auth.auth().currentUser?.email {
            email = userEmail
        }
    }
    
    // switch view controllers
    private func switchVC(VC: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: VC)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = newVC
    }
    
    // tap share button
    func didTapContact() {
        let alert = UIAlertController(title: "Share",
                                    message: "How would you like to share your resume?",
                                    preferredStyle: UIAlertController.Style.actionSheet)

        alert.addAction(UIAlertAction(title: "Email",
                                      style: UIAlertAction.Style.default) {
                                        AlertAction in
                                        self.sendEmail(type: "Resume")
        })
        alert.addAction(UIAlertAction(title: "Message",
                                      style: UIAlertAction.Style.default) {
                                        AlertAction in
                                        self.sendMessage()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertAction.Style.cancel))
        
        self.present(alert, animated: true) {
            
        }
    }
    
    // formats resume into string
    private func formatIntoMessage() -> String {
        var message = "EDUCATION\n\n"
        
        let educations = model.getEducations()
        for edu in educations {
            message.append("School: \(edu.getSchool())\n")
            message.append("Major: \(edu.getMajor())\n")
            message.append("GPA: \(edu.getGPA())\n")
            message.append("Graduation Date: \(edu.getGradDate())\n\n")
        }
        
        message.append("\n")
        
        message.append("WORK EXPERIENCE\n\n")
        let workExperiences = model.getWorkExperiences()
        for we in workExperiences {
            message.append("Company: \(we.getCompany())\n")
            message.append("Position: \(we.getPosition())\n")
            message.append("Start Date: \(we.getStartDate())\n")
            message.append("End Date: \(we.getEndDate())\n\n")
        }
        
        return message
    }
    
    
    // MARK: - IBActions
    
    // log out function
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        
        // switch to loginViewController
        self.switchVC(VC: "LoginVC")
    }

    // enable / disable the editting function for the table
    @IBAction func editButtonPressed(_ sender: UIButton) {
        tableView.isEditing = editButton.titleLabel?.text == "Edit" ? true : false
        editButton.setTitle(editButton.titleLabel?.text == "Edit" ? "Done" : "Edit", for: .normal)

    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        didTapContact()
    }
    
    
    // MARK: - Prepare for Segue
    
    // determine which setting to land on: adding education or adding work experience
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "education" {
            if let addVC = segue.destination as? AddViewController {
                addVC.purpose = "Education"
            }
        } else {
            if let addVC = segue.destination as? AddViewController {
                addVC.purpose = "Work"
            }
        }
        
        segue.destination.modalPresentationStyle = .fullScreen
    }
}

