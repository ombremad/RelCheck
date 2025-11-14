//
//  CheckIn.swift
//  notifyme
//
//  Created by Anne Ferret on 13/11/2025.
//


import Foundation
import SwiftData

@Model
class CheckIn {
    var date: Date
    var contact: Contact
    
    var dateFormatted: String {
        date.formatted(date: .abbreviated, time: .shortened)
    }
    
    init(date: Date, contact: Contact) {
        self.date = date
        self.contact = contact
    }
}
