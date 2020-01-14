//
//  ResumeModel.swift
//  BeyondMe
//
//  Created by Joseph Son on 12/11/19.
//  Copyright © 2019 Joseph Son. All rights reserved.
//

import Foundation

class ResumeModel: NSObject {
    
    // MARK: - Variables
    public static let shared = ResumeModel()
    private var workExperiences = [WorkExperience]()
    private var educations = [Education]()    
    
    // MARK: - Initialize
    
    override init() {

    }
    
    // MARK: - Model Functions
    
    // get the number of work experience
    func getWorkExperiencesCount() -> Int {
        return workExperiences.count
    }
    
    // get the number of educations
    func getEducationsCount() -> Int {
        return educations.count
    }
    
    // get educations array
    func getEducations() -> [Education] {
        return educations
    }
    
    // get workExperiences array
    func getWorkExperiences() -> [WorkExperience] {
        return workExperiences
    }
    
    // get work experience at array
    func workExperiences(at index: Int) -> WorkExperience? {
        if index < 0 || index >= workExperiences.count {
            return nil
        }
        return workExperiences[index]
    }
    
    // get education at array
    func educations(at index: Int) -> Education? {
        if index < 0 || index >= educations.count {
            return nil
        }
        return educations[index]
    }
    
    // add work experience to array
    func addWorkExperience(company: String, position: String, startDate: String, endDate: String) {
        let we = WorkExperience(company: company, position: position, startDate: startDate, endDate: endDate)
        
        for work in workExperiences {
            if we == work {
                return
            }
        }
        
        workExperiences.append(we)
    }
    
    // add education to array
    func addEducation(school: String, major: String, gpa: String, gradDate: String) {
        let education = Education(school: school, major: major, gpa: gpa, gradDate: gradDate)
        
        for edu in educations {
            if edu == education {
                return
            }
        }
        
        educations.append(education)
    }
    
    // rearrange order of work experience
    func rearrageWorkExperience(from: Int, to: Int) {
        if from >= 0 && from < workExperiences.count && to >= 0 && to < workExperiences.count{
            let we = workExperiences.remove(at: from)
            workExperiences.insert(we, at: to)
        }
    }
    
    // rearrange order of education
    func rearrangeEducation(from: Int, to: Int) {
        if from >= 0 && from < educations.count && to >= 0 && to < educations.count{
            let education = educations.remove(at: from)
            educations.insert(education, at: to)
        }
    }
    
    func clearAllData() {
        educations.removeAll()
        workExperiences.removeAll()
    }
}
