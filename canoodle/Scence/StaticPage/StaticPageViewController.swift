//
//  StaticPageViewController.swift
//  Pups
//
//  Created by hb on 07/05/19.

import UIKit
import CRRefresh

/// Protocol for presenting response
protocol StaticPageDisplayLogic: class {
    /// Did Receive Static page Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveStaticPageResponse(viewModel: [StaticPage.ViewModel]?, message: String, successCode: String)
    /// Did Receive Static page Version update Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveStaticPageVersionUpdateResponse(viewModel: [StaticPage.ViewModel]?, message: String, successCode: String)
}

/// This class is used for displaying content of static pages like Privacy Policy, Terms & Conditions etc.
class StaticPageViewController: BaseViewController {
    
    // MARK: IBOutlet
    /// Interactor for API Call
    var interactor: StaticPageBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol)?
    var isFrom = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtView: UITextView!
    var showAgreeBtn = false
    
    var updateCompletion:(()->())?
    
    // MARK: Class Instance
    class func instance() -> StaticPageViewController? {
        return UIStoryboard(name: "StaticPage", bundle: nil).instantiateViewController(withIdentifier: "StaticPageViewController") as? StaticPageViewController
    }
   
    // MARK: View lifecycle
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setUpLayout()
    }
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showAgreeBtn {
            self.addIAgreeButton()
        }
    }
    
    /// Add I agree button at top
    func addIAgreeButton() {
        let aBtn = UIButton(type: .custom)
        aBtn.titleLabel?.textColor = .white
        aBtn.setTitle("I Agree", for: .normal)
        aBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 35)
        aBtn.addTarget(self, action: #selector(self.btnAgreeAction(_:)), for: .touchUpInside)
        
        let aBarBtn = UIBarButtonItem(customView: aBtn)
        self.navigationItem.rightBarButtonItem = aBarBtn
        
    }
    
    // MARK: Setup
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = StaticPageInteractor()
        let presenter = StaticPagePresenter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    /// Initial UISetUp
    private func setUpLayout() {
        let request = StaticPage.Request(pageCode: isFrom)
        interactor?.callStaticPageAPI(request: request, showLoader: true)
        
        scrollView.cr.addHeadRefresh(animator:FastAnimator(frame: scrollView.frame, color: UIColor.lightGray, arrowColor: AppConstants.appColor ?? UIColor(), lineWidth: 1.5)) { [weak self] in
            guard self?.internetAvailable() ?? false else {
                self?.scrollView.cr.endHeaderRefresh()
                return
            }
            let request = StaticPage.Request(pageCode: self?.isFrom ?? "")
            self?.interactor?.callStaticPageAPI(request: request, showLoader: false)
        }
    }
    
    /// Set Html data in textview
    ///
    /// - Parameter strHtml: Html static page data from API
    func setUpWebView(_ strHtml:String) {
        let aDescrip =  "<font face='Helvetica'; size='5' color='#000000'>" + strHtml
        let myParagraphStyle = NSMutableParagraphStyle()
        myParagraphStyle.alignment = .center
        myParagraphStyle.lineSpacing = 1
        myParagraphStyle.paragraphSpacing = 5
        let attrStr = try! NSAttributedString(
            data: aDescrip.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options:[NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html ], documentAttributes: nil)
        self.txtView.attributedText = attrStr
    }
    
    /// Agree Button Tap Event
    /// - Parameter sender: Agree Button
    @objc func btnAgreeAction(_ sender: Any) {
        
        let request = StaticPage.Request(pageCode: isFrom)
        interactor?.callPageVersionUpdate(request: request, showLoader: true)
    }
    
}

//Static Page API Response and get data from API
extension StaticPageViewController: StaticPageDisplayLogic {
    /// Did Receive Static page Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveStaticPageResponse(viewModel: [StaticPage.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            if let response = viewModel, response.count > 0 {
                self.setUpWebView(response[0].content!)
                self.navigationItem.title = response[0].pageTitle
            }
            self.scrollView.cr.endHeaderRefresh()
        } else {
            self.scrollView.cr.endHeaderRefresh()
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive Static page Version update Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveStaticPageVersionUpdateResponse(viewModel: [StaticPage.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            self.updateCompletion?()
            self.dismiss(animated: false, completion: nil)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
