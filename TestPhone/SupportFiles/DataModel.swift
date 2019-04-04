//
//  DataModel.swift
//  TestPhone
//
//  Created by Vitaliy Kozlov on 03/04/2019.
//  Copyright © 2019 Vitaliy Kozlov. All rights reserved.
//

import Foundation

struct Contact : Codable{
    var name : String?
    var picture : String?
   var tags : [String]?
   var phone : String?
}
struct Contacts : Codable{
    var error = ""
    var contacts : [Contact]?
}
var contactsData = Contacts()
