//
//  GoogleSearch.swift
//  GoogleAutoComplete
//
//  Created by Apple on 29/04/18.
//  Copyright © 2018 leena. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
import IQKeyboardManagerSwift

class GoogleSearch: BaseViewController {

    @IBOutlet  weak var searchBar : UISearchBar!
    @IBOutlet weak var tblView : UITableView!
   
    var tableData = [GMSAutocompletePrediction]()
    var fetcher: GMSAutocompleteFetcher?
    var completion:((GMSAutocompletePrediction?, Error?) -> Void)!
    
    /// Insatance
    ///
    /// - Returns: SignUpViewController
    class func instance() -> GoogleSearch? {
        return UIStoryboard(name: "GoogleSearch", bundle: nil).instantiateViewController(withIdentifier: "GoogleSearch") as? GoogleSearch
    }
    
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        //white label
        //AIzaSyBD7jL0m7-m1T0xhR00teozg7YQDI6fXm0
        GMSPlacesClient.provideAPIKey(ServiceApiKey.Google.kGMSServicesAPIKey)
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        //filter.country = "US"
        fetcher = GMSAutocompleteFetcher()
        fetcher?.autocompleteFilter = filter
        fetcher?.delegate = self
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): AppConstants.appColor], for: .normal)
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension GoogleSearch : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SearchResultCell
        aCell?.lblTitle.text = tableData[indexPath.row].attributedPrimaryText.string
        aCell?.lblAddress.text = tableData[indexPath.row].attributedSecondaryText?.string
        return aCell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completion(tableData[indexPath.row], nil)
        dismiss(animated: true, completion: nil)
    }
    
}

extension GoogleSearch : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(NetworkReachabilityManager()!.isReachable) {
            self.showTopMessage(message: AlertMessage.InternetError, type: .Error)
        } else {
            fetcher?.sourceTextHasChanged(searchBar.text!)
        }
        
    }// called when text changes (including clear)
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}

extension GoogleSearch : GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
      
        tableData.removeAll()
        
        for prediction in predictions {
            
            tableData.append(prediction)
            
        }
        tblView.reloadData()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        
     //   completion(nil,error)
       // dismiss(animated: true, completion: nil)
    }
}
