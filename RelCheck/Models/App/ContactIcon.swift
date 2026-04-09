//
//  ContactIcon.swift
//  RelCheck
//
//  Created by Anne Ferret on 07/04/2026.
//

import SwiftUI

enum ContactIcon: String, CaseIterable {

  // MARK: - Celestial & Weather
  case sunMaxFill = "sun.max.fill"
  case moonFill = "moon.fill"
  case moonStarsFill = "moon.stars.fill"
  case cloudSunFill = "cloud.sun.fill"
  case cloudBoltRainFill = "cloud.bolt.rain.fill"
  case wind = "wind"
  case tornado = "tornado"
  case rainbow = "rainbow"
  case snowflake = "snowflake"
  case dropFill = "drop.fill"

  // MARK: - Nature & Outdoors
  case flameFill = "flame.fill"
  case leafFill = "leaf.fill"
  case mountain2Fill = "mountain.2.fill"
  case tentFill = "tent.fill"
  case mapFill = "map.fill"

  // MARK: - Animals
  case pawprintFill = "pawprint.fill"
  case hareFill = "hare.fill"
  case tortoiseFill = "tortoise.fill"
  case birdFill = "bird.fill"
  case fishFill = "fish.fill"
  case antFill = "ant.fill"
  case ladybugFill = "ladybug.fill"

  // MARK: - Emotions & Expression
  case heartFill = "heart.fill"
  case starFill = "star.fill"
  case sparkle = "sparkle"
  case sparkles = "sparkles"
  case faceSmiling = "face.smiling"
  case faceDashed = "face.dashed"
  case eyeFill = "eye.fill"
  case theatermasksFill = "theatermasks.fill"

  // MARK: - Mind & Knowledge
  case brain = "brain"
  case lightbulbFill = "lightbulb.fill"
  case atom = "atom"
  case graduationcapFill = "graduationcap.fill"
  case bookFill = "book.fill"
  case pencil = "pencil"

  // MARK: - Creative Arts
  case paintbrushPointedFill = "paintbrush.pointed.fill"
  case paintpaletteFill = "paintpalette.fill"
  case cameraFill = "camera.fill"
  case scissors = "scissors"
  case wandAndSparkles = "wand.and.sparkles"

  // MARK: - Music & Media
  case musicNote = "music.note"
  case pianokeys = "pianokeys"
  case guitarsFill = "guitars.fill"
  case headphones = "headphones"
  case filmFill = "film.fill"

  // MARK: - Activities & Sports
  case gamecontrollerFill = "gamecontroller.fill"
  case figureWalk = "figure.walk"
  case figureRun = "figure.run"
  case figureHiking = "figure.hiking"
  case figureMindAndBody = "figure.mind.and.body"
  case figureMartialArts = "figure.martial.arts"
  case bicycle = "bicycle"
  case dumbbellFill = "dumbbell.fill"
  case soccerball = "soccerball"
  case trophyFill = "trophy.fill"
  case medalFill = "medal.fill"

  // MARK: - Social & Professional
  case briefcaseFill = "briefcase.fill"
  case stethoscope = "stethoscope"
  case megaphoneFill = "megaphone.fill"
  case bubbleLeftFill = "bubble.left.fill"
  case handsClapFill = "hands.clap.fill"
  case handRaisedFill = "hand.raised.fill"
  case handThumbsupFill = "hand.thumbsup.fill"
  case handThumbsdownFill = "hand.thumbsdown.fill"
  case crownFill = "crown.fill"
  case personFill = "person.fill"
  case person2Fill = "person.2.fill"
  case person3Fill = "person.3.fill"

  // MARK: - Lifestyle
  case cupAndSaucerFill = "cup.and.saucer.fill"
  case forkKnife = "fork.knife"
  case birthdayCakeFill = "birthday.cake.fill"

  // MARK: - Abstract & Universal
  case globeEuropeAfricaFill = "globe.europe.africa.fill"
  case boltFill = "bolt.fill"
  case infinitySymbol = "infinity"
  case questionmark = "questionmark"
  case exclamationmark = "exclamationmark"

  var image: Image {
    Image(systemName: self.rawValue)
  }
}
