//
//  OrionWindowController+NSWindowDelegate.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/02.
//

import Cocoa

extension OrionWindowController: NSWindowDelegate {
  func windowShouldClose(_ sender: NSWindow) -> Bool {
    // Teardown `webView`
    // This kills all media and any running scripts
    // since WebKit doesn't detect any of that.
    // YouTube, SoundCloud, other media platforms will keep
    // playing media if this line wasn't here.
    mainViewController.currentWebView?.loadHTMLString("", baseURL: nil)

    return true
  }
}
