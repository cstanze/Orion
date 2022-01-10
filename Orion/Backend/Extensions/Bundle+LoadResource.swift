//
//  Bundle+LoadResource.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/09.
//

import Foundation

extension Bundle {
  func loadResource(withName name: String, ofType type: String) -> String {
    if let path = Bundle.main.path(forResource: name, ofType: type) {
      do {
        return try String(contentsOfFile: path)
      } catch {
        print("Failed to load resource '\(name).\(type)': \(error)")
        return ""
      }
    } else {
      return ""
    }
  }
}
