//
//  EModel.swift
//  Test-1104
//
//  Created by Amit Prajapati on 11/04/22.
//

import Foundation

struct EmployeeM : Codable {
    var department : String
    var employee : [Employee]
}

struct Employee : Codable {
    var email : String
    var isStatus : Bool = false
}
