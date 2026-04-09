//
//  ContactColor.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/04/2026.
//

import SwiftUI

enum ContactColor: String, CaseIterable {
  case silver = "silver"
  case coral = "coral"
  case tangerine = "tangerine"
  case honey = "honey"
  case sage = "sage"
  case sky = "sky"
  case indigo = "indigo"
  case violet = "violet"
  case rose = "rose"
  case ruby = "ruby"
  case teal = "teal"
  case copper = "copper"
  case gray = "gray"

  var color: Color {
    Color("contact/\(rawValue)")
  }
}

extension ContactColor: ShapeStyle {
  func resolve(in environment: EnvironmentValues) -> some ShapeStyle { color }
}
