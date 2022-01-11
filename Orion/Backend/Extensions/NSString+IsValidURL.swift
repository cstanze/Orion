//
//  NSString+IsValidURL.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/02.
//

import Foundation

extension String {
  /// Checks if a String is a valid URL using `NSDataDetector`
  var isValidURL: Bool {
    do {
      let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
      if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
        return match.range.length == self.utf16.count
      } else {
        return false
      }
    } catch {
      print("Encountered error while checking URL status")
      return false
    }
  }
}
