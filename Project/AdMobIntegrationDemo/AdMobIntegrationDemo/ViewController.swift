import UIKit

//MARK: - ViewController
class ViewController: UIViewController {

    @IBOutlet var btnBannerAds: UIButton!
    @IBOutlet var btnInterstitial: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnInterstitial.layer.cornerRadius = btnInterstitial.frame.size.height / 2.0
        
        btnBannerAds.tag = 1
        btnBannerAds.setTitle("Hide Banner Ads", for: UIControlState.normal)
        btnBannerAds.layer.cornerRadius = btnBannerAds.frame.size.height / 2.0
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

//MARK: - Tapped Event
    @IBAction func tappedOnInterstitialBtn(_ sender: Any) {
        
        //Show Interstitial Ads
        GoogleAdMob.sharedInstance.showInterstitial()
    }
    @IBAction func tappedOnBannerBtn(_ sender: Any) {
        
        if btnBannerAds.tag == 0 {
            
            btnBannerAds.tag = 1
            btnBannerAds.setTitle("Hide Banner Ads", for: UIControlState.normal)
            
            //Show banner view
            GoogleAdMob.sharedInstance.showBannerView()
            
        } else {
        
            btnBannerAds.tag = 0
            btnBannerAds.setTitle("Show Banner Ads", for: UIControlState.normal)
            
            //Hide banner view
            GoogleAdMob.sharedInstance.hideBannerView()
        }
    }

}

