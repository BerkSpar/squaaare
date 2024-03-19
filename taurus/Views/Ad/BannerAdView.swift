import SwiftUI
import UIKit
import GoogleMobileAds

struct BannerAd: UIViewControllerRepresentable {
    let adUnitId: String
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
    }
    
    func makeUIViewController(context: Context) -> BannerAdVC {
        return BannerAdVC(adUnitId: adUnitId)
    }

    func updateUIViewController(_ uiViewController: BannerAdVC, context: Context) {
        
    }
}

class BannerAdVC: UIViewController {
    let adUnitId: String
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var bannerView: GADBannerView = GADBannerView() //Creates your BannerView
    
    override func viewDidLoad() {
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = self
      
        //Add our BannerView to the VC
        view.addSubview(bannerView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBannerAd()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.bannerView.isHidden = true //So banner doesn't disappear in middle of animation
        } completion: { _ in
            self.bannerView.isHidden = false
            self.loadBannerAd()
        }
    }

    func loadBannerAd() {
        let frame = view.frame.inset(by: view.safeAreaInsets)
        let viewWidth = frame.size.width

        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.load(GADRequest())
    }
}
