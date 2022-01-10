//
//  OrionWindowController.swift
//  Orion
//
//  Created by Jules Amalie on 2021/12/30.
//

import Cocoa

class OrionWindowController: NSWindowController, NSToolbarItemValidation {
  
  var tabCollectionController: OrionTabCollectionController!
  var mainViewController: OrionViewController!
  
  var backNavigationControl: NSButton?
  var forwardNavigationControl: NSButton?
  
  var resizeObservers: [OrionWindowResizeObserver] = []
  
  init() {
    // MARK: - Window Setup
    super.init(window: NSWindow(contentRect: NSMakeRect(0, 0, 1076, 678),
                                styleMask: [.miniaturizable, .closable, .resizable, .titled],
                                backing: .buffered,
                                defer: false))
    self.window?.minSize = NSSize(width: 575, height: 250)
    self.window?.delegate = self
    
    // MARK: - Controller Setup
    self.tabCollectionController = OrionTabCollectionController()
    self.mainViewController = OrionViewController()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func showWindow(_ sender: Any?) {
    // MARK: - Configure Window
    if let window = self.window {
      // MARK: - Toolbar
      let toolbar = NSToolbar(identifier: NSToolbar.Identifier.windowToolbarIdentifier)
      toolbar.delegate = self
//      delegate.extensionManager.loadAllExtensionData()
//      print("Passed extension data load stage")
      toolbar.allowsUserCustomization = true
      // TODO: fix weird double extension button bug
//      toolbar.autosavesConfiguration = true
      toolbar.displayMode = .iconOnly
      
      window.titleVisibility = .hidden
      //  window.titlebarAppearsTransparent = true
      
      // toolbar.showsBaselineSeparator = false
      // TODO: .unified for macOS 10.13+ ?
      if #available(macOS 11.0, *) {
        window.toolbarStyle = .unified
      }
      
      window.toolbar = toolbar
//      delegate.extensionManager.loadAllExtensions(toWindow: window)
      window.toolbar?.validateVisibleItems()
      
      // MARK: - Visual Effects
      let visualEffect = NSVisualEffectView()
      visualEffect.blendingMode = .behindWindow
      visualEffect.state = .followsWindowActiveState
      visualEffect.material = .dark
      window.contentView = visualEffect
      window.styleMask.insert(.fullSizeContentView)
      
      window.contentView = mainViewController.view
      window.contentView?.wantsLayer = true
      mainViewController?.currentWebView?.navigationDelegate = self
      
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(controllerWebViewDidChange),
        name: NSNotification.Name.OrionControllerWebViewChanged,
        object: nil
      )
      
      window.makeKeyAndOrderFront(sender)
      window.center()
    } else {
      print("No window exists?")
    }
  }
  
  // MARK: - Tab Switching Logic
  
  @objc func controllerWebViewDidChange() {
    mainViewController?.currentWebView?.navigationDelegate = self
  }
  
  // MARK: - Toolbar Validation
  
  func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
//    print("Validating toolbar item: \(item.itemIdentifier)")
    switch item.itemIdentifier {
    case .navigationItemIdentifier:
      if let navigationStack = item.view as? NSStackView {
        if let currentWebView = mainViewController.currentWebView {
          /// Yes, it's not the best practice, but it works for my purposes
          /// since I know the values will never change.
          
          if !currentWebView.canGoBack {
            navigationStack.subviews[0].removeFromSuperview()
          } else {
            navigationStack.insertArrangedSubview(backNavigationControl!, at: 0)
          }
          
          if !currentWebView.canGoForward {
            navigationStack.subviews[1].removeFromSuperview()
          } else {
            navigationStack.insertArrangedSubview(forwardNavigationControl!, at: 1)
          }
          
          return true
        }
      }
      
      /// Only if we failed to get all the resources
      /// required for validation
      return false
    default: return true
    }
  }
  
  // MARK: - Toolbar Selectors
  
  @objc func dummy() {}
  
  @objc func newTab(_ sender: NSToolbarItem) {
//    NotificationCenter.default.post(name: <#T##NSNotification.Name#>, object: <#T##Any?#>)
  }
  
  /// Updates the navigator item
  /// Essentially, it shows/hides the forward/backward toolbar items
  /// when its valid to have these interactive elements.
  ///
  /// It uses `WKWebView.canGoBack` and `WKWebView.canGoForward` to determine
  /// when to hide/show the items.
  
  @objc func navigate(_ sender: NSButton) {
    if let currentWebView = mainViewController.currentWebView {
      if sender == backNavigationControl {
        currentWebView.goBack()
      } else {
        currentWebView.goForward()
      }
    }
    
    window?.toolbar?.items.first(where: { item in
      item.itemIdentifier == .navigationItemIdentifier
    })?.validate()
  }
  
  @objc func extensionDidActivate(_ ext: NSToolbarItem) {
    let alert = NSAlert()
    alert.messageText = "Extension running support isn't implemented yet."
    alert.addButton(withTitle: "Ok")
    alert.runModal()
  }
  
  @objc func reloadHandler(_ sender: NSToolbarItem) {
    if let currentWebView = mainViewController.currentWebView {
      if currentWebView.isLoading {
        delegate.stopReloadingCurrent()
      } else {
        delegate.reloadCurrent()
      }
    }
  }
}
