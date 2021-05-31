//
//  BaseViewControllerWithAd.swift
//  WhiteLabelApp
//
//  Created by hb on 26/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Alamofire
#if canImport(TALogger)
import TALogger
#endif
import MoPubSDK

/// Base View controller with ads
class BaseViewControllerWithAd: UIViewController {
    /// Interstitial ads
    var interstitialView: MPInterstitialAdController!
    /// Banner view for ads
    var bannerView: MPAdView!
    
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppConstants.backgroundColor
        let bg = UIImageView.init(frame: CGRect(x: 20, y: self.view.frame.height - 350, width: self.view.frame.width, height: 250))
        bg.image = UIImage.init(named: "pawBg")
        bg.contentMode = .scaleAspectFit
        self.view.addSubview(bg)
    }
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.logScreenEvent("\(#function)")
        if bannerView != nil {
            self.bannerView.startAutomaticallyRefreshingContents()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if bannerView != nil {
            self.bannerView.stopAutomaticallyRefreshingContents()
        }
    }
    
    func logScreenEvent(_ functionName:String) {
        var aName = GlobalUtility.classNameAsString(obj: self) + " Screen"
        aName = aName.replacingOccurrences(of: "ViewController", with: "")
        let className = GlobalUtility.classNameAsString(obj: self)
        
        if let aModel = UserDefaultsManager.getLoggedUserDetails()
        {
            GlobalUtility.setUser(user: aModel.email ?? "")
        }
        else
        {
            GlobalUtility.setUser(user: "N/A")
        }
        
        GlobalUtility.logScreenEvent(file: className, name: functionName, description: aName)
        
    }
    
    func logAdEvent(_ functionName:String) {
        var aName = GlobalUtility.classNameAsString(obj: self) + " Screen"
        aName = aName.replacingOccurrences(of: "ViewController", with: "")
        let className = GlobalUtility.classNameAsString(obj: self)
        
        if let aModel = UserDefaultsManager.getLoggedUserDetails()
        {
            GlobalUtility.setUser(user: aModel.email ?? "")
        }
        else
        {
            GlobalUtility.setUser(user: "N/A")
        }
        
            #if canImport(TALogger)
            TALogger.shared.LogEvent(type: "Ad", function:functionName ,file:GlobalUtility.classNameAsString(obj: self), name: functionName, description: description)
            #endif
        
    }
    
    
    /// set ad mob view
    ///
    /// - Parameter viewAdd: view for ad
    func setAddMobView(viewAdd: UIView) {
         if !(UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false){
            if !checkIFBannerIsAdded(viewAdd)
            {
                if bannerView == nil {
                    var adUnitID = MoPubLive.bannerAdUnitID
                    if(AppConstants.isDebug) {
                        adUnitID = MoPubTest.bannerAdUnitID
                    }
                    self.bannerView = MPAdView(adUnitId: adUnitID)
                    self.bannerView.delegate = self
                    self.bannerView.frame = viewAdd.frame
                    viewAdd.addSubview(bannerView)
                    self.bannerView.loadAd()
                }
               // addBannerViewToView(bannerView, viewAdd: viewAdd)
               // bannerView.frame = viewAdd.frame
               // bannerView.rootViewController = self
            }
        }
        /*else
        {
            for vw in viewAdd.subviews {
                if vw is GADBannerView {
                    vw.removeFromSuperview()
                }
            }
        }*/
    }
    
    func checkIFBannerIsAdded(_ bannerView:UIView) -> Bool
      {
          var alreadyAdded = false
          for vw in bannerView.subviews {
              if vw is GADBannerView {
                  alreadyAdded = true
              }
          }
          return alreadyAdded
      }
    
    /// Add Banner Ad to view
    ///
    /// - Parameters:
    ///   - bannerView:Banner View
    ///   - viewAdd: View ad
    func addBannerViewToView(_ bannerView: GADBannerView, viewAdd: UIView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.center = viewAdd.center
        viewAdd.addSubview(bannerView)
    }
    
    /// Reload Interstitial ad
    ///
    /// - Returns: Return Interstitial ad
  /*  func reloadInterstitialAd() -> GADInterstitial {
        if(AppConstants.isDebug) {
            interstitialView = GADInterstitial(adUnitID: AdMobTest.interstitialAdUnitId)
        } else {
            interstitialView = GADInterstitial(adUnitID: AdMobLive.interstitialAdUnitId)
        }
        interstitialView.delegate = self
        let request = GADRequest()
        interstitialView.load(request)
        return interstitialView
    }*/

    
    /// Show Full ad
    func showFullAdd() {
        if !(UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false) {
            var adUnitID = MoPubLive.interstitialAdUnitId
            if(AppConstants.isDebug) {
                adUnitID = MoPubTest.interstitialAdUnitId
            }
            interstitialView = MPInterstitialAdController(forAdUnitId: adUnitID)
            interstitialView.delegate = self
            interstitialView.loadAd()
        }
    }
    
    /// Check internet is available
    ///
    /// - Returns: Return If internet is available
    func internetAvailable()-> Bool {
        if !(NetworkReachabilityManager()!.isReachable) {
            self.showTopMessage(message: AlertMessage.InternetError, type: .Error)
            return false
        }else {
            return true
        }
    }
}

// MARK: - Ad Mob
extension BaseViewControllerWithAd: GADBannerViewDelegate {
    
    /// Method is called when ad is received
    ///
    /// - Parameter bannerView: Bannerview
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.logAdEvent("\(#function)")
        print("")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        self.logAdEvent("\(#function)")
        
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        self.logAdEvent("\(#function)")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        self.logAdEvent("\(#function)")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        self.logAdEvent("\(#function)")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        self.logAdEvent("\(#function)")
    }
}

extension BaseViewControllerWithAd: MPAdViewDelegate {
    
    func adViewDidLoadAd(_ view: MPAdView!, adSize: CGSize) {
        print("MoPubAd loaded with width: " + adSize.width.description)
        self.bannerView?.startAutomaticallyRefreshingContents()
    }
    
    func adView(_ view: MPAdView!, didFailToLoadAdWithError error: Error!) {
        print("MoPubAd load failed: " + error.debugDescription)
    }
    
    func viewControllerForPresentingModalView() -> UIViewController? {
        return self
    }
}

extension BaseViewControllerWithAd: MPInterstitialAdControllerDelegate {
    
    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        guard interstitial.ready else {
            self.logScreenEvent("Attempted to show an interstitial ad when it is not ready \(#function)")
            print("Attempted to show an interstitial ad when it is not ready")
            return
        }
        print("Loaded interstitial ad successfully \(#function)")
        interstitial.show(from: self)
    }
    
    func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
        print("Failed to load interstitial Ad")
        self.logScreenEvent("Failed to load interstitial Ad : \(#function)")
    }
    
}


