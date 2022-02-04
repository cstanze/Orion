//
//  OrionWindowController+WKNavigationDelegate.swift
//  Orion
//
//  Created by Jules Amalie on 2022/01/01.
//

import Cocoa
import WebKit

extension OrionWindowController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    window?.toolbar?.validateVisibleItems()

    guard webView.title != nil && webView.url != nil else { return } // It happened... now it doesn't
    guard webView.url!.absoluteString != "about:blank" else { return } // This also happened... now it doesn't

    OrionHistoryManager.writeEntryIntoHistory(withTitle: webView.title!, url: webView.url!)
    NotificationCenter.default.post(name: .TabLocationChanged, object: webView.url!)
  }

  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    if let webViewUrl = navigationAction.request.url {
      if let components = URLComponents(url: webViewUrl, resolvingAgainstBaseURL: false) {
        if components.host == "addons.mozilla.org" {
          webView.customUserAgent = mainViewController.firefoxUA
        } else if components.host == "addons.cdn.mozilla.net" {
          decisionHandler(.cancel)
          print("Cancelled, downloading extension")
          OrionExtensionManager.shared.downloadExtension(withUrl: webView.url!)
          return
        } else {
          webView.customUserAgent = mainViewController.safariUA
        }
      }
    }

    decisionHandler(.allow)
  }

  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    typealias Code = URLError.Code

    let error = error as NSError
    switch Code(rawValue: error.code) {
    case Code.timedOut:
      webView.loadHTMLString(
        Bundle.main.loadResource(withName: "ErrorTimedOut", ofType: "")
          .replacingOccurrences(of: "__URL__", with: (webView.url ?? URL(string: "about:blank")!)!.absoluteString),
        baseURL: nil
      )
    default:
      print("Found code: \(error.code) (\(Code(rawValue: error.code))")
    }
  }
}
