//
//  OrionSiteAffinityObject.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/02.
//

import Foundation

struct OrionPageAffinityRepresentable: Codable {
  /// The title we found when saving this into the affinity manager
  var title: String
  
  /// Taken from `URL.absoluteString`
  var url: String
  
  /// Same as the affinity field in
  /// `OrionSiteAffinityRepresentable`
  ///
  /// Do note, this is *relative* to the
  /// original site's affinity.
  var affinity: Int
  
  func asTopSitesRepresentable() -> [String: String] {
    return [
      "title": self.title,
      "url": self.url
    ]
  }
}

struct OrionSiteAffinityRepresentable: Codable {
  /// The domain of the site. Seems kind of obvious what this might be.
  var domain: String
  
  /// Full list of pages (not just the domain).
  ///
  /// It's also good to note that this is relative.
  /// This means that the affinity starts at `1` for every page,
  /// regardless of the affinity of the whole site.
  var visitedPages: [OrionPageAffinityRepresentable]
  
  /// Just a number of times the user visited this site
  /// In a real browser, this would likely be based off of:
  /// `numberOfTimesVisited / timeSpentPerVisit`
  /// for a more accurate affinity score.
  var affinity: Int
}
