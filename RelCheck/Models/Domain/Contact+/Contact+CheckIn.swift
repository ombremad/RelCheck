//
//  Contact+CheckIn.swift
//  RelCheck
//
//  Created by Anne Ferret on 12/02/2026.
//

import Foundation
import SwiftData

extension Contact {
    @MainActor
    func checkIn(modelContext: ModelContext) {
        scheduleNextNotification(modelContext: modelContext)
        let checkIn = CheckIn(date: .now, contact: self)
        modelContext.insert(checkIn)
    }
}
