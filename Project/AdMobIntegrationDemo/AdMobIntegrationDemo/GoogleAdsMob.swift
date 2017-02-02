import UIKit
import GoogleMobileAds

//MARK: - Google Ads Unit ID
struct GoogleAdsUnitID {
    
    //Google Test Unit ID
    struct Test {
        static var strBannerAdsID = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXXX"
        static var strInterstitialAdsID = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXXX"
    }
    
    //Google Live admob Unit ID
    struct Live {
        static var strBannerAdsID = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXXX"
        static var strInterstitialAdsID = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXXX"
    }
}

//MARK: - Banner View Size
struct BannerViewSize {
    
    static var screenWidth = UIScreen.main.bounds.size.width
    static var screenHeight = UIScreen.main.bounds.size.height
    static var height = CGFloat((UIDevice.current.userInterfaceIdiom == .pad ? 90 : 50))
}

//MARK: - Create GoogleAdMob Class
class GoogleAdMob:NSObject, GADInterstitialDelegate, GADBannerViewDelegate {
    
    //MARK: - Shared Instance
    static let sharedInstance : GoogleAdMob = {
        let instance = GoogleAdMob()
        return instance
    }()
    
//MARK: - Variable
    private var isBannerViewDisplay = false
    
    private var isInitializeBannerView = false
    private var isInitializeInterstitial = false
    
    private var isBannerLiveID = false
    private var isInterstitialLiveID = false
    
    private var interstitialAds: GADInterstitial!
    private var bannerView: GADBannerView!

//MARK: - Create Banner View
    func initializeBannerView(isLiveUnitID:Bool) {
        
        self.isInitializeBannerView = true
        self.isBannerLiveID = isLiveUnitID
        self.createBannerView()
    }
    @objc private func createBannerView() {
        
        print("GoogleAdMob : create")
        if UIApplication.shared.keyWindow?.rootViewController == nil {
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(createBannerView), object: nil)
            self.perform(#selector(createBannerView), with: nil, afterDelay: 0.5)
        } else {
            
            isBannerViewDisplay = true
            bannerView = GADBannerView(frame: CGRect(
                x:0 ,
                y:BannerViewSize.screenHeight - BannerViewSize.height ,
                width:BannerViewSize.screenWidth ,
                height:BannerViewSize.height))
            
            if self.isBannerLiveID == false {
                
                self.bannerView.adUnitID = GoogleAdsUnitID.Test.strBannerAdsID
            } else {
                
                self.bannerView.adUnitID = GoogleAdsUnitID.Live.strBannerAdsID
            }
            
            self.bannerView.rootViewController = UIApplication.shared.keyWindow?.rootViewController
            self.bannerView.delegate = self
            self.bannerView.backgroundColor = .gray
            self.bannerView.load(GADRequest())
            UIApplication.shared.keyWindow?.addSubview(bannerView)
        }
    }
//MARK: - Hide - Show Banner View
    func showBannerView() {
        
        print("showBannerView")
        isBannerViewDisplay = true
        if isInitializeBannerView == false {
            
            print("First initialize Banner View")
        } else {
            
            print("isBannerViewCreate : true")
            self.bannerView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.bannerView.frame = CGRect(x:0 ,y:BannerViewSize.screenHeight - BannerViewSize.height ,width:BannerViewSize.screenWidth ,height:BannerViewSize.height)
            })
        }
    }
    func hideBannerView() {
        
        print("hideBannerView")
        isBannerViewDisplay = false
        if self.bannerView != nil {
            UIView.animate(withDuration: 0.3, animations: {
                self.bannerView.frame = CGRect(x:0 ,y:BannerViewSize.screenHeight ,width:BannerViewSize.screenWidth ,height:BannerViewSize.height)
            })
        }
    }
    @objc private func showBanner() {

        print("showBanner")
        if self.bannerView != nil && isBannerViewDisplay == true {
            self.bannerView.isHidden = false
        }
    }
    private func hideBanner() {
        
        print("hideBanner")
        if self.bannerView != nil {
            self.bannerView.isHidden = true
        }
    }
//MARK: - GADBannerView Delegate
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        print("adViewDidReceiveAd")
    }
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        
        print("adViewDidDismissScreen")
    }
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        
        print("adViewWillDismissScreen")
    }
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        
        print("adViewWillPresentScreen")
    }
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        
        print("adViewWillLeaveApplication")
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        
        print("adView")
    }
//MARK: - Create Interstitial Ads
    func initializeInterstitial(isLiveUnitID:Bool) {
        self.isInitializeInterstitial = true
        self.isInterstitialLiveID = isLiveUnitID
        self.createInterstitial()
    }
    private func createInterstitial() {
        
        if self.isInterstitialLiveID == false {
            interstitialAds = GADInterstitial(adUnitID: GoogleAdsUnitID.Test.strInterstitialAdsID)
        } else {
            interstitialAds = GADInterstitial(adUnitID: GoogleAdsUnitID.Live.strInterstitialAdsID)
        }
        
        interstitialAds.delegate = self
        interstitialAds.load(GADRequest())
    }
//MARK: - Show Interstitial Ads
    func showInterstitial() {
        
        if isInitializeInterstitial == false {
            
            print("First initialize Interstitial")
        } else {
            
            if interstitialAds.isReady {
                interstitialAds.present(fromRootViewController: (UIApplication.shared.keyWindow?.rootViewController)!)
                
            } else {
                print("Interstitial not ready")
                self.createInterstitial()
            }
        }
    }
//MARK: - GADInterstitial Delegate
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        
        print("interstitialDidReceiveAd")
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        
        print("interstitialDidDismissScreen")
        self.createInterstitial()
    }
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        
        print("interstitialWillDismissScreen")
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showBanner), object: nil)
        self.perform(#selector(showBanner), with: nil, afterDelay: 0.1)
    }
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        
        print("interstitialWillPresentScreen")
        self.hideBanner()
    }
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        
        print("interstitialWillLeaveApplication")
    }
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        
        print("interstitialDidFail")
    }
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        
        print("interstitial")
    }
}
