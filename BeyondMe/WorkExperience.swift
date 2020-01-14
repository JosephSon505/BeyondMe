//
//  WorkExperience.swift
//  BeyondMe
//
//  Created by Joseph Son on 12/11/19.
//  Copyright © 2019 Joseph Son. All rights reserved.
//

import Foundation

struct WorkExperience: Equatable {
    
    // MARK: - Variables

    private var company: String
    private var position: String
    private var startDate: String
    private var endDate: String
    
    
    // MARK: - Initializer

    init(company: String, position: String, startDate: String, endDate: String) {
        self.company = company
        self.position = position
        self.startDate = startDate
        self.endDate = endDate
    }
    
    
    // MARK: - Getters
    
    func getCompany() -> String {
        return company
    }
    
    func getPosition() -> String {
        return position
    }
    
    func getStartDate() -> String {
        return startDate
    }
    
    func getEndDate() -> String {
        return endDate
    }
}
