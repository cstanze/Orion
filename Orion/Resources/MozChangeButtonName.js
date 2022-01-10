//
//  AddonsChangeDownloadName.js
//  Orion
//
//  Created by Jules Amalie on 2022/01/02.
//
 
(() => {
  if (window.location.href.startsWith("https://addons.mozilla.org")) {
    
    const observationCallback = function(mutations, _observer) {
      const button = document.getElementsByClassName('AMInstallButton-button')[0];
      if (button == null) {
        return;
      }
      
      if (button.innerText.includes('Firefox')) {
        button.innerText = button.innerText.replace('Firefox', 'Orion');
      }
    }
    
    const observer = new MutationObserver(observationCallback);
    observer.observe(document.querySelector('body'), { childList: true, subtree: true });
    
    observationCallback([], null);
  }
})()
