//
//  AddonsChangeDownloadName.js
//  Orion
//
//  Created by Jules Amalie on 2022/01/02.
//

const browserHandler = {
  get: function(obj, prop) {
    return obj[prop];
  },
  set: function(obj, prop, value) {
    // Do nothing... except throw an error... for now.
    throw Error("Not allowed to set browser object.")
  }
}


const swapHandler = {
  get: function(obj, prop) {
    return obj[prop]
  },
  set: function (obj, prop, value) {
    obj[prop] = value
  }
}


window.browser = new Proxy({
  topSites: (() => {
    const handlerNames = [
      "topSites.get",
      "topSites.MostVisitedURL"
    ]
    const topSites = function () {}
    
    topSites.prototype['get'] = (options = {
      includeSearchShortcuts: false,
      includeBlocked: false,
      includeFavicon: false,
      includePinned: false,
      onePerDomain: true,
      newtab: false,
      limit: 12,
    }) => {
      console.log(window.webkit)
    };
    
    topSites.prototype.MostVisitedURL = (() => {
      return topSites.get()[0].url
    })();
    return new topSites();
  })(),
}, browserHandler);
