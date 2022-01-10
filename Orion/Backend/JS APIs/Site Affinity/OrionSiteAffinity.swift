//
//  OrionSiteAffinity.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/02.
//

import Foundation

/// Handles all the affinity stuff (fetching, saving, mutation, etc.)
class OrionSiteAffinityManager {
  
  var siteAffinities: [OrionSiteAffinityRepresentable] = []
  
  init() {
    readAffinityIntoManager()
  }
  
  func readAffinityIntoManager() {
    let historyEntries: [OrionHistoryEntry]? = OrionConfig.getFromConfig(named: "history")
    guard historyEntries != nil else {
      print("Failed to load history entries from config. Loading empty site affinities.")
      return
    }
    
    /**
     * The structure for this is quite easy:
     *
     * domain:
     *  - history entry
     *  - another entry
     * secondDomain:
     *  - third entry
     *
     * Then, to count affinity, we just get the entry count per domain.
     *
     * Note: since there really isn't any simple way to handle all TLD cases,
     * the domains include subdomains. (I blame all the `.co.<tld>` names :c)
     */
    var entryTree: [String: [OrionHistoryEntry]] = [:]
    for entry in historyEntries! {
      let components = URLComponents(string: entry.url)
      guard components != nil else { continue } /// Yes, this has failed before...  I have no idea why
      
      if entryTree.keys.contains(components!.host!) {
        entryTree[components!.host!] = []
      }
      
      entryTree[components!.host!]?.append(entry)
    }
    
    /// Now, we can create site affinities
    for key in entryTree.keys {
      /// This structure is even simpler. It's a map of domain (including subdomain, as noted above) to page affinity
      var visitedPages: [String: OrionPageAffinityRepresentable] = [:]
      for page in entryTree[key]! {
        let components = URLComponents(string: page.url)
        guard components != nil else { continue }
        
        if !visitedPages.keys.contains(components!.host!) {
          visitedPages[components!.host!] = OrionPageAffinityRepresentable(title: page.title, url: page.url, affinity: 1)
        } else {
          // Yikes... the unwrap pyramid of doom.
          visitedPages[components!.host!]!.affinity += 1
        }
      }
      
      siteAffinities.append(OrionSiteAffinityRepresentable(
        domain: key,
        /// The keys were only needed for mapping purposes,
        /// now we can use
        visitedPages: Array(visitedPages.values),
        affinity: entryTree[key]!.count
      ))
    }
  }
  
  /**
   * It's best to go over the algorithm used here despite it being very simple.
   *
   * Since the `topSites` API (without any options) gives us a list of sites
   * with only one per-domain and 12 item maximum, we need to compile a similar list.
   *
   * I iterate through each site and then pick the "sub-page" with the highest
   * relative affinity. If - for some odd reason - the site doesn't have any "sub-pages"
   * then we just pass the site itself (and set the title to the domain).
   *
   * I also need to be sure that the affinity 
   */
  func compileTopSites() -> [[String: String]] {
    var topSites: [[String: String]] = []
    
    for siteAffinity in siteAffinities {
      let topPage = siteAffinity.visitedPages.reduce(OrionPageAffinityRepresentable(title: "", url: "", affinity: 0)) { partialResult, item in
        if partialResult.affinity < item.affinity {
          return item
        }
        return partialResult
      }
      
      topSites.append(topPage.asTopSitesRepresentable())
    }
    
    return topSites
  }
}
