//
//  MozillaExtensionManifest.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/03.
//

import Foundation
import AppKit

/// No, I'm not documenting these...
/// It all seems pretty self-explanatory anyways...

struct MozExtManifest: Codable {
  var author: String
  var browserAction: BrowserAction
  var defaultLocale, description: String
  var homepageUrl: String
  var icons: [String: String]
  var manifestVersion: Int
  var name: String
  var optionsUi: OptionsUI
  var permissions: [String]
  var version: String

  init(_ path: URL) throws {
    let fm = FileManager.default
    guard fm.fileExists(atPath: path.path) else {
      throw MozManifestError.missing
    }

    let jd = JSONDecoder()
    jd.keyDecodingStrategy = .convertFromSnakeCase
    do {
      let data = try Data(contentsOf: path)
      self = try jd.decode(MozExtManifest.self, from: data)
    } catch {
      throw MozManifestError.malformed
    }
  }

  func extensionIcon() -> NSImage? {
    guard !self.icons.keys.isEmpty else { return nil }

    var imageUrl = FileManager.default.extensionDirectory!.appendingPathComponent(self.name)
    /// This should give us the highest resolution
    imageUrl.appendPathComponent(self.icons[self.icons.keys.sorted().last!]!)
    print(self.icons.keys.sorted().last!)

    return NSImage(contentsOf: imageUrl)
  }
}

struct BrowserAction: Codable {
  var browserStyle: Bool
  var defaultIcon: [String: String]
  var defaultPopup, defaultTitle: String
}

struct OptionsUI: Codable {
  var browserStyle: Bool
  var page: String
}
