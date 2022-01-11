//
//  OrionHistoryManager.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/03.
//

import Foundation

struct OrionHistoryEntry: Codable {
  /// Title of site accessed
  var title: String

  /// Url of site accessed
  var url: String

  /// Date and Time of access
  var dt: String
}

class OrionHistoryManager {
  static func writeEntryIntoHistory(withTitle title: String, url: URL) {
    /// Generate a current date to be saved in the history file
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP") /// Yes, this shouldn't be default but it looks nicer
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    let now = dateFormatter.string(from: Date.now)

    /// Theres definitely a better way to do this but it works.
    let entry = OrionHistoryEntry(title: title, url: url.absoluteString, dt: now)
    var currentConfig: [OrionHistoryEntry]? = OrionConfig.getFromConfig(named: "history")
    guard currentConfig != nil else { return }

    currentConfig!.append(entry)
    OrionConfig.writeToConfig(named: "history", data: currentConfig!)
  }
}
