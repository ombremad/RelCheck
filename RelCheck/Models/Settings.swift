//
//  Settings.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import Foundation
import SwiftData

@Model
class Settings {
    var dailyRecap: Bool = false
    
    init(dailyRecap: Bool) {
        self.dailyRecap = dailyRecap
    }
}
