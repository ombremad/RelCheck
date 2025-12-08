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
    var fastCheckIn: Bool = false
    
    init(fastCheckIn: Bool = false) {
        self.fastCheckIn = fastCheckIn
    }
}
