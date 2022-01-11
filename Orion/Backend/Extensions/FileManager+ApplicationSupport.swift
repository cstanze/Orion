//
//  FileManager+ApplicationSupport.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/03.
//

import Foundation

extension FileManager {
  /// Checks if support directory exists. Otherwise, creates it. Returns the URL
  var applicationSupportUrl: URL? {
    let appSupport = self.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    let directoryUrl = appSupport.appendingPathComponent("com.constanze.Orion")

    var isDirectory = ObjCBool(false)
    if self.fileExists(atPath: directoryUrl.path, isDirectory: &isDirectory) && isDirectory.boolValue {
      return directoryUrl
    }

    print("Creating Application Support directory for Orion")
    do {
      try self.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
    } catch {
      print("Some error occured in creating Application Support: \(error)")

      return nil
    }

    return directoryUrl
  }

  var extensionDirectory: URL? {
    self.applicationSupportUrl?.appendingPathComponent("Extensions")
  }

  func directoryExists(atPath path: String) -> Bool {
    var isDirectory = ObjCBool(false)
    if self.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue {
      return true
    }
    return false
  }
}
