//
//  SubscriptionViewController.swift
//  Tyst
//
//  Created by hb on 27/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit
import SwiftyStoreKit


protocol SubscriptionDisplayLogic: class {
    func didReceiveManageSubscriptionResponse(message: String, success: String)
}

class SubscriptionViewController: BaseViewController {
    //MARK: IBOutlet Constants
    
    var interactor: SubscriptionBusinessLogic?
    var router: (NSObjectProtocol & SubscriptionRoutingLogic & SubscriptionDataPassing)?
    
    @IBOutlet weak var txtViewTerms: UITextView!
    @IBOutlet weak var bgView1: UIView!
    @IBOutlet weak var bgView2: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = SubscriptionInteractor()
        let presenter = SubscriptionPresenter()
        let router = SubscriptionRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Class Instance
    class func instance() -> SubscriptionViewController? {
        return StoryBoard.Subscription.board.instantiateViewController(withIdentifier: AppClass.SubscriptionVC.rawValue) as? SubscriptionViewController
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    /// Method used for Initial setup of viewcontroller
    func setUpLayout() {
        self.navigationItem.title = "Premium Subscription"
        bgView1.layer.cornerRadius = 20.0
        bgView2.layer.cornerRadius = 20.0
        setUpTermsAndConditionPrivacyLabel()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: 850)
    }
    
    /// Method used for set terma condition  label
    func setUpTermsAndConditionPrivacyLabel() {
        txtViewTerms.textContainerInset = .zero
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(recognizer:)))
        tapGesture.numberOfTapsRequired = 1
        txtViewTerms.addGestureRecognizer(tapGesture)
        txtViewTerms.text = "For more information see our Terms & Conditions, Privacy Policy and EULA Policy"
        let range = (txtViewTerms.text! as NSString).range(of: txtViewTerms.text)
        let underlineAttriString = NSMutableAttributedString(string: txtViewTerms.text!, attributes: nil)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15.0), range: range)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray  , range: range)
        let range3 = (txtViewTerms.text! as NSString).range(of: "Terms & Conditions")
        underlineAttriString.addAttribute(NSAttributedString.Key(rawValue: "idnum"), value: "1", range: range3)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppConstants.appColor2!, range: range3)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15.0, weight: .medium), range: range3)
        let range4 = (txtViewTerms.text! as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppConstants.appColor2!, range: range4)
        underlineAttriString.addAttribute(NSAttributedString.Key(rawValue: "idnum"), value: "2", range: range4)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15.0, weight: .medium), range: range4)
        let range5 = (txtViewTerms.text! as NSString).range(of: "EULA Policy")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppConstants.appColor2!, range: range5)
        underlineAttriString.addAttribute(NSAttributedString.Key(rawValue: "idnum"), value: "3", range: range5)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15.0, weight: .medium), range: range5)
        txtViewTerms.attributedText = underlineAttriString
    }
    
    //MARK: IBAction
    @objc func tapLabel(recognizer: UITapGestureRecognizer) {
        if let textView = recognizer.view as? UITextView {
            var location: CGPoint = recognizer.location(in: textView)
            location.x -= textView.textContainerInset.left
            location.y -= textView.textContainerInset.top
            let charIndex = textView.layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            if charIndex < textView.textStorage.length {
                var range = NSRange(location: 0, length: 0)
                if (textView.attributedText?.attribute(NSAttributedString.Key(rawValue: "idnum"), at: charIndex, effectiveRange: &range) as? NSString) != nil {
                    let tappedPhrase = (textView.attributedText.string as NSString).substring(with: range)
                    if tappedPhrase == "Terms & Conditions" {
                        if let staticPageVC = StaticPageViewController.instance() {
                            staticPageVC.isFrom = StaticPageCode.termsCondition.rawValue
                            self.navigationController?.pushViewController(staticPageVC, animated: true)
                        }
                    }
                    if tappedPhrase == "Privacy Policy" {
                        if let staticPageVC = StaticPageViewController.instance() {
                            staticPageVC.isFrom = StaticPageCode.privacyPolicy.rawValue
                            self.navigationController?.pushViewController(staticPageVC, animated: true)
                        }
                    }
                    if tappedPhrase == "EULA Policy" {
                        if let staticPageVC = StaticPageViewController.instance() {
                            staticPageVC.isFrom = StaticPageCode.eula.rawValue
                            self.navigationController?.pushViewController(staticPageVC, animated: true)
                        }
                    }
                }
                if let desc = textView.attributedText?.attribute(NSAttributedString.Key(rawValue: "desc"), at: charIndex, effectiveRange: &range) as? NSString {
                    print("desc: \(desc)")
                }
            }
        }
    }
    
    @IBAction func btnBuyAction(_ sender: Any) {
        self.addAnayltics(analyticsParameterItemID: "id-premiumsubcription", analyticsParameterItemName: "Premium Subscription", analyticsParameterContentType: "click_buypremium")
        guard internetAvailable() else { return }
        buySubscription()
    }
    
    
    @IBAction func btnRestoreAction(_ sender: Any) {
        guard internetAvailable() else { return }
        self.restoreProduct(withIdentifier: AppConstants.subscriptionId)
    }
    
    
    // MARK: In App Purchase for Go Ad Free
    func buySubscription() {
        let alertController = UIAlertController(title:  AppInfo.kAppName, message: AlertMessage.subscriptionPurchaseAlert, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Buy for $5.99", style: .default) { (_) in
            self.buyProduct(withIdentifier: AppConstants.subscriptionId)
        }
        alertController.addAction(OKAction)
        
        let RestoreAction = UIAlertAction(title: "Restore your Purchase", style: .default) { (_) in
            self.restoreProduct(withIdentifier: AppConstants.subscriptionId)
        }
        
        alertController.addAction(RestoreAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// In app Purchase for Go Ad Free
    ///
    /// - Parameter identifier: Purchase Identifer
    func buyProduct(withIdentifier identifier: String) {
        GlobalUtility.showHud()
        print("Asked:\(AppInfo.kBundleIdentifier! + "." + identifier)")
        
        SwiftyStoreKit.purchaseProduct((AppInfo.kBundleIdentifier! + "." + identifier), atomically: true) { result in
            GlobalUtility.hideHud()
            
            if case .success(let purchase) = result {
                SwiftyStoreKit.finishTransaction(purchase.transaction)
                self.purchaseSuccess(purchase.productId)
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                    self.purchaseSuccess(AppInfo.kBundleIdentifier! + "." + identifier)
                }
            }
        }
    }
    
    /// Restore In app Purchase
    ///
    /// - Parameter identifier: purchase identifier
    func restoreProduct(withIdentifier identifier:String) {
        GlobalUtility.showHud()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            GlobalUtility.hideHud()
            
            var isPurchased = false
            for purchase in results.restoredPurchases {
                //  let downloads = purchase.transaction.downloads
                if purchase.productId == (AppInfo.kBundleIdentifier! + "." + identifier) {
                    isPurchased = true
                    //self.showTopMessage(message: AlertMessage.subscriptionSuccess, type: .Success)
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                    self.purchaseSuccess(AppInfo.kBundleIdentifier! + "." + identifier)
                }
            }
            
            if !isPurchased {
                self.displayAlert(msg: AlertMessage.restoreFail, ok: AlertMessage.yes, cancel: AlertMessage.no, okAction: {
                    self.buyProduct(withIdentifier: identifier)
                }, cancelAction: {
                    
                })
            }
        }
    }
    
    /// In app Purchase Success
    ///
    /// - Parameter identifier: Purchase Identifier
    func purchaseSuccess(_ identifier : String) {
        
        self.receiptDataVerification()
    }
    
    func convertToDictionary(from text: String) throws -> [String: String] {
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String] ?? [:]
    }
    
    
    /// Receipt Verification
    func receiptDataVerification() {
        if !self.internetAvailable() {
            self.showTopMessage(message: AlertMessage.NetworkError, type: .Error)
            return
        }
        
        verifyReceipt { (result) in
            GlobalUtility.hideHud()
            switch result {
            case .success(let receipt):
                print(receipt.description)
                do {
                    let request = ManageSubscription.Request(oneTimeTransactionData: SwiftyStoreKit.localReceiptData!.base64EncodedData(), fileName: "Receipt")
                    self.interactor?.manageSubscription(request: request)
                }catch {
                    self.showTopMessage(message: "Error verifying receipt", type: .Error)
                }
                
            case .error:
                self.showTopMessage(message: "Error verifying receipt", type: .Error)
                break
            }
        }
    }
    
    func createTempFile(_ file: Data) throws -> URL {
        let dir = NSTemporaryDirectory()
        let fileName = NSUUID().uuidString + ".txt"
        let url = URL(fileURLWithPath: dir + fileName)
        try file.write(to: url)
        return url
    }
    
    
    /// Verify Receipt from Apple
    ///
    /// - Parameter completion: Description
    /*func verifyReceipt(completion: @escaping (FetchReceiptResult) -> Void) {

        GlobalUtility.showHud()

        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                print("Fetch receipt success:\n\(encryptedReceipt)")

                completion(result)

            case .error(let error):
                print("Fetch receipt failed: \(error)")
            }
        }
    }*/
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "2564948a5dcc4c4bb4577f34736b0e7b")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
}

//MARK: API Response
extension SubscriptionViewController: SubscriptionDisplayLogic {
    func didReceiveManageSubscriptionResponse(message: String, success: String) {
        if success == "1" {
            self.showTopMessage(message: message, type: .Success)
            let loginData = UserDefaultsManager.getLoggedUserDetails()
            loginData?.purchaseStatus = "Yes"
            loginData?.premiumStatus = "1"
            UserDefaultsManager.setLoggedUserDetails(userDetail: loginData!)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
