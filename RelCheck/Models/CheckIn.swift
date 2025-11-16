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
    var date: Date = Date()
    var contact: Contact?
    
    @Transient
    var dateFormatted: String {
        date.formatted(date: .abbreviated, time: .shortened)
    }
    
    init(date: Date, contact: Contact) {
        self.date = date
        self.contact = contact
    }
}
