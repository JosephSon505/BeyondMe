//
//  Education.swift
//  BeyondMe
//
//  Created by Joseph Son on 12/11/19.
//  Copyright © 2019 Joseph Son. All rights reserved.
//

import Foundation

struct Education: Equatable {
    
    // MARK: - Variables

    private var school: String
    private var major: String
    private var gpa: String
    private var gradDate: String

    
    // MARK: - Initializer

    init(school: String, major: String, gpa: String, gradDate: String) {
        self.school = school
        self.major = major
        self.gpa = gpa
        self.gradDate = gradDate
    }
    
    
    // MARK: - Getters
    
    func getSchool() -> String {
        return school
    }
    
    func getMajor() -> String {
        return major
    }
    
    func getGPA() -> String {
        return gpa
    }
    
    func getGradDate() -> String {
        return gradDate
    }
}
