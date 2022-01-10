//
//  OrionViewController+WKUIDelegate.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/02.
//

import Foundation
import WebKit

extension OrionViewController: WKUIDelegate {
  func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    let alert = NSAlert()
    alert.messageText = message
    alert.alertStyle = .informational
    alert.addButton(withTitle: "Close")
    alert.beginSheetModal(for: view.window!) { response in
      completionHandler()
    }
  }
  
  func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
    let alert = NSAlert()
    alert.messageText = message
    alert.alertStyle = .informational
    alert.addButton(withTitle: "Yes")
    alert.addButton(withTitle: "No")
    alert.beginSheetModal(for: view.window!) { response in
      completionHandler(response == .alertFirstButtonReturn)
    }
  }
  
  func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
    let alert = NSAlert()
    alert.messageText = prompt
    alert.alertStyle = .informational
    alert.addButton(withTitle: "Ok")
    alert.addButton(withTitle: "Cancel")
    let inputTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
    alert.accessoryView = inputTextField
    alert.beginSheetModal(for: view.window!) { response in
      if response == .alertFirstButtonReturn {
        completionHandler(inputTextField.stringValue)
      } else {
        completionHandler("")
      }
    }
  }
  
  func webView(_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
    let openPanel = NSOpenPanel()
    openPanel.allowsMultipleSelection = parameters.allowsMultipleSelection
    if #available(macOS 10.13.4, *) {
      openPanel.canChooseDirectories = parameters.allowsDirectories
    }
    openPanel.runModal()
    completionHandler(openPanel.urls.count == 0 ? nil : openPanel.urls)
  }
}
