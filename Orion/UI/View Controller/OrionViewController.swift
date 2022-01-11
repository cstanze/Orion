//
//  OrionViewController.swift
//  Orion
//
//  Created by Jules Amalie on 2021/12/30.
//

import Cocoa
import WebKit

class OrionViewController: NSViewController {

  /// A simple list of webviews to keep track of when tab switching
  var webViews: [WKWebView] = []

  /// The current webview which translates to the current "tab"
  var currentWebView: WKWebView?

  /// The global webview configuration.
  var webViewConfiguration: WKWebViewConfiguration?

  /// The global content controller
  var webContentController: OrionUserContentController?

  // MARK: - Custom User Agents

  /// Safari User Agent
  var safariUA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Safari/605.1.15"

  /// Firefox User Agent (for Moz Addons page)
  var firefoxUA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:97.0) Gecko/20100101 Firefox/97.0"

  override func loadView() {
    view = NSView()

    // MARK: - WKWebViewConfiguration
    webViewConfiguration = WKWebViewConfiguration()
    webContentController = OrionUserContentController(scriptNames: ["MozChangeButtonName"])
    webViewConfiguration!.userContentController = webContentController!

    currentWebView = newWebView()

    view.addSubview(currentWebView!)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(tabLocationChanged),
      name: NSNotification.Name.OrionCurrentTabLocationChangedViaUser,
      object: nil
    )
  }

  @objc func tabLocationChanged(_ notification: NSNotification) {
    guard currentWebView != nil else { return }

    if let obj = notification.object as? String {
      var request: URLRequest?
      if obj.isValidURL {
        request = URLRequest(url: URL(string: obj)!)
      } else {
        // Implement Kagi Search support ;)
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.google.com"
        components.path = "/search"
        components.queryItems = [URLQueryItem(name: "q", value: obj)]

        request = URLRequest(url: components.url!)
      }

      currentWebView!.load(request!)
    }
  }

  // MARK: - WKWebView Initialisation
  func newWebView() -> WKWebView {
    let webView = WKWebView(frame: view.bounds, configuration: webViewConfiguration!)
    webView.autoresizingMask = [.width, .height]
    webView.uiDelegate = self

    webView.allowsMagnification = true
    webView.allowsBackForwardNavigationGestures = true
    webView.customUserAgent = self.safariUA

    // MARK: - WKWebView Preferences
    webView.configuration.preferences.setValue(true, forKey: "offlineApplicationCacheIsEnabled")
    webView.configuration.preferences.setValue(true, forKey: "aggressiveTileRetentionEnabled")
    webView.configuration.preferences.setValue(true, forKey: "screenCaptureEnabled")
    webView.configuration.preferences.setValue(true, forKey: "allowsPictureInPictureMediaPlayback")
    webView.configuration.preferences.setValue(true, forKey: "fullScreenEnabled")
    webView.configuration.preferences.setValue(true, forKey: "largeImageAsyncDecodingEnabled")
    webView.configuration.preferences.setValue(true, forKey: "animatedImageAsyncDecodingEnabled")
    webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
    webView.configuration.preferences.setValue(true, forKey: "usesPageCache")
    webView.configuration.preferences.setValue(true, forKey: "mediaSourceEnabled")
    webView.configuration.preferences.setValue(true, forKey: "acceleratedDrawingEnabled")
    webView.configuration.preferences.setValue(true, forKey: "mediaDevicesEnabled")
    webView.configuration.preferences.setValue(true, forKey: "mockCaptureDevicesPromptEnabled")
    webView.configuration.preferences.setValue(true, forKey: "canvasUsesAcceleratedDrawing")
    webView.configuration.preferences.setValue(true, forKey: "videoQualityIncludesDisplayCompositingEnabled")
    webView.configuration.preferences.setValue(false, forKey: "backspaceKeyNavigationEnabled")
    webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true

    webViews.append(webView)

    webView.loadHTMLString(Bundle.main.loadResource(withName: "Home", ofType: "html"), baseURL: nil)

    return webView
  }

}
