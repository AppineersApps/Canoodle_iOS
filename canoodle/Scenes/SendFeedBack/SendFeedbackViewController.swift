//
//  SendFeedbackViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 26/09/19.

import UIKit

/// Protocol for presenting response
protocol SendFeedbackDisplayLogic: class {
    /// Did Receive response for feedback
    ///
    /// - Parameters:
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSendFeedbackResponse(message: String, successCode: String)
}

/// This class is used for sending feedback from app to admin panel. 
class SendFeedbackViewController: BaseViewController {
    
    // MARK: IBOutlet
    /// Textview to add message
    @IBOutlet weak var txtView: UITextView!
    ///Label to show send feedback text
    @IBOutlet weak var lblText: UILabel!
    /// Placeholder for textview
    @IBOutlet weak var lblPlaceHolder: UILabel!
    /// Collectionview for photos
    @IBOutlet weak var clctnView: UICollectionView!
    /// Character count label
    @IBOutlet weak var lblDescriptionCharacterCount: UILabel!
    
    /// Interactor for API Call
    var interactor: SendFeedbackBusinessLogic?
    
    /// Image Array to display images in scroll
    var imageArray = [UIImage]() {
        didSet {
            clctnView.reloadData()
            self.scrollToBottom()
        }
    }
    
    // MARK: Object lifecycle
     /// Override method to initialize with nib
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib name
    ///   - nibBundleOrNil: Bundle in which nib is present
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    /// Default method
    ///
    /// - Parameter aDecoder: Decoder
   /// Decoder
    ///
    /// - Parameter aDecoder: Decoder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = SendFeedbackInteractor()
        let presenter = SendFeedbackPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: View lifecycle
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLayout()
        
        //Border for textview
        txtView!.layer.borderWidth = 1
        txtView!.layer.borderColor = UIColor.black.cgColor
//        txtView!.layer.borderColor = UIColor.redColor().CGColor
    }
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /// Instance
    ///
    /// - Returns: SignUpViewController
    class func instance() -> SendFeedbackViewController? {
        return StoryBoard.SendFeedback.board.instantiateViewController(withIdentifier: AppClass.SendFeedbackVC.rawValue) as? SendFeedbackViewController
    }
    
    // MARK: Class Methods
    // SetUpLayout initial setup UI
    func setUpLayout() {
        self.title = AlertMessage.sendFeedbackTitle
        self.lblText.text = AlertMessage.sendFeedbackText
        self.addAnayltics(analyticsParameterItemID: "id-sendfeedbackscreen", analyticsParameterItemName: "view_sendfeedbackscreen", analyticsParameterContentType: "view_sendfeedbackscreen")
    }
    
    /// Scroll colllecttionview to last index while add image
    func scrollToBottom() {
        DispatchQueue.main.async {
            if self.imageArray.count == 5 {
                let indexPath = IndexPath(row: self.imageArray.count - 1, section: 0)
                self.clctnView.scrollToItem(at: indexPath, at: .right, animated: false)
            } else {
                let indexPath = IndexPath(row: self.imageArray.count, section: 0)
                self.clctnView.scrollToItem(at: indexPath, at: .right, animated: false)
            }
        }
    }
    
    /// Open camera/gallery
    func addPhoto() {
        CustomImagePicker.shared.openImagePickerWith(mediaType: .MediaTypeImage, allowsEditing: false, actionSheetTitle: AppInfo.kAppName, message: "", cancelButtonTitle: "Cancel", cameraButtonTitle: "Camera", galleryButtonTitle: "Gallery") { (_, success, dict) in
            if success {
                if let img = (dict!["image"] as? UIImage) {
                    self.imageArray.append(img)
                }
            }
        }
    }
    
    /// Validiate all fields and call login api
    func validateFields() {
        if self.internetAvailable() {
            if self.txtView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                self.showTopMessage(message: AlertMessage.enterFeedback, type: .Error)
            } else {
                let request = SendFeedback.Request(postdescription: self.txtView.text.trimmingCharacters(in: .whitespacesAndNewlines), imageArray: self.imageArray, imageCount: String(self.imageArray.count))
                interactor?.callSendFeedbackAPI(request: request)
            }
        }
    }
    
    
    // MARK: IBAction
    /// Button sendt action
    ///Check validation
    /// - Parameter sender: WLButton
    @IBAction func btnSendAction(_ sender: Any) {
        self.validateFields()
    }
}

//UITextfield delegate and set number of text count in textview
extension SendFeedbackViewController: UITextViewDelegate {
    
    /// Method is called when textview text changes
    ///
    /// - Parameter textView: TextView
    func textViewDidChange(_ textView: UITextView) {
        lblPlaceHolder.isHidden = !txtView.text.isEmpty
        if textView.text.count > 1000 {
            var str = textView.text ?? ""
            str = String(str.prefix(1000))
            self.txtView.text = str
        }
        self.lblDescriptionCharacterCount.text = "(\(textView.text.count)/1000)"
    }
}

//UIcollectionview Methods
extension SendFeedbackViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    /// Method is called to get number of items to be displayed in collectionview
    ///
    /// - Parameters:
    ///   - collectionView: CollectionView
    ///   - section: Section
    /// - Returns: Return number of rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count == 5 {
            return imageArray.count
        } else {
            return imageArray.count + 1
        }
    }
    
    /// Method is called to get cell for row at particular index
    ///
    /// - Parameters:
    ///   - collectionView: Collectionview
    ///   - indexPath: Indexpath
    /// - Returns: Return cell for indexpath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == imageArray.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addImage", for: indexPath) as? SendFeedbackAddImageCollectionViewCell
            cell?.btnAddTappedClouser = {
                self.addPhoto()
            }
            return cell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? SendFeedbackImageCollectionViewCell
            cell?.imgPicked.image = imageArray[indexPath.row]
            cell?.btnRemoveTappedClouser = {
                self.displayAlert(msg: AlertMessage.deleteMessage, ok: "Yes", cancel: "No", okAction: {
                    self.imageArray.remove(at: indexPath.row)
                }, cancelAction: nil)
                
            }
            return cell!
        }
    }
}

//API Response
extension SendFeedbackViewController: SendFeedbackDisplayLogic {
    
    /// Did Receive response for feedback
    ///
    /// - Parameters:
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSendFeedbackResponse(message: String, successCode: String) {
        if successCode == "1" {
            self.showTopMessage(message: message, type: .Success)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
