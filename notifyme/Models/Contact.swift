//
//  Contact.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//


import SwiftUI
import SwiftData

@Model
class Contact {
    var name: String
    var daysBetweenNotifications: Int
    var iconName: String
    
    @Relationship(deleteRule: .cascade, inverse: \Notification.contact)
    var notifications: [Notification] = []
    
    @Relationship(deleteRule: .cascade, inverse: \CheckIn.contact)
    var checkIns: [CheckIn] = []

    var nextUpcomingNotification: Notification? {
        notifications
            .filter { !$0.isCompleted && $0.date > Date() }
            .sorted { $0.date < $1.date }
            .first
    }
    
    var icon: AppIcon {
        AppIcon(rawValue: iconName) ?? .personfill
    }

    init(name: String, daysBetweenNotifications: Int, icon: AppIcon = .personfill) {
        self.name = name
        self.daysBetweenNotifications = daysBetweenNotifications
        self.iconName = icon.rawValue
    }
}

enum AppIcon: String, CaseIterable {
    
    case personfill = "person.fill"
    case figure2andchildholdinghands = "figure.2.and.child.holdinghands"
    case figureaustralianfootball = "figure.australian.football"
    case figuredance = "figure.dance"
    case figurediscsports = "figure.disc.sports"
    case figureequestriansports = "figure.equestrian.sports"
    case figureroll = "figure.roll"
    case figureskiingdownhill = "figure.skiing.downhill"
    case airplaneupright = "airplane.up.right"
    case brainfilledheadprofile = "brain.filled.head.profile"
    case carrearfill = "car.rear.fill"
    case dollarsign = "dollarsign"
    case eyeglasses = "eyeglasses"
    case figurestanddress = "figure.stand.dress"
    case gamecontrollerfill = "gamecontroller.fill"
    case heartfill = "heart.fill"
    case motorcyclefill = "motorcycle.fill"
    
    var image: Image {
        Image(systemName: self.rawValue)
    }
}
