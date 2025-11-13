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
        AppIcon(rawValue: iconName) ?? .personFill
    }

    init(name: String, daysBetweenNotifications: Int, icon: AppIcon = .personFill) {
        self.name = name
        self.daysBetweenNotifications = daysBetweenNotifications
        self.iconName = icon.rawValue
    }
}

enum AppIcon: String, CaseIterable {
    
    case sunMaxFill = "sun.max.fill"
    case moonStarsFill = "moon.stars.fill"
    case cloudSunFill = "cloud.sun.fill"
    case cloudBoltRainFill = "cloud.bolt.rain.fill"
    case flameFill = "flame.fill"
    case snowflake = "snowflake"
    case leafFill = "leaf.fill"
    case pawprintFill = "pawprint.fill"
    case boltFill = "bolt.fill"
    case heartFill = "heart.fill"
    case starFill = "star.fill"
    case sparkle = "sparkle"
    case faceSmiling = "face.smiling"
    case faceDashed = "face.dashed"
    case brain = "brain"
    case lightbulbFill = "lightbulb.fill"
    case gamecontrollerFill = "gamecontroller.fill"
    case paintbrushPointedFill = "paintbrush.pointed.fill"
    case musicNote = "music.note"
    case wandAndSparkles = "wand.and.sparkles"
    case bookFill = "book.fill"
    case figureWalk = "figure.walk"
    case figureRun = "figure.run"
    case bicycle = "bicycle"
    case sparkles = "sparkles"
    case crownFill = "crown.fill"
    case globeEuropeAfricaFill = "globe.europe.africa.fill"
    case rainbow = "rainbow"
    case handThumbsupFill = "hand.thumbsup.fill"
    case handThumbsdownFill = "hand.thumbsdown.fill"
    case personFill = "person.fill"
    
    var image: Image {
        Image(systemName: self.rawValue)
    }
}
