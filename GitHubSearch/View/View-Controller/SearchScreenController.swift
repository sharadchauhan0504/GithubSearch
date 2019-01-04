//
//  SearchScreenController.swift
//  GitHubSearch
//
//  Created by Sharad S. Chauhan on 03/01/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import UIKit

class SearchScreenController: UIViewController {

    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var foundUserLabel: UILabel!
    @IBOutlet weak var foundUserButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchResultViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchResultView: UIView!
    @IBOutlet weak var searchTextFieldCenterYConstraint: NSLayoutConstraint!
    
    let searchScreenViewModel = SearchScreenViewModel()
    var foundUserDetails: UserDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        searchTextField.delegate = self
        searchResultView.alpha = 0.0
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            searchTextFieldCenterYConstraint.constant = -(keyboardSize.height/2)
            self.view.animateViewWith(duration: 0.5)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        searchTextFieldCenterYConstraint.constant = -50
        self.view.animateViewWith(duration: 0.5)
    }
    
    private func callGithubUsersAPI(username: String) {
        
        let activityIndicator    = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        searchTextField.resignFirstResponder()
        
        searchScreenViewModel.callUserSearchAPI(username: username)
        
        searchScreenViewModel.usernameSearchCallback = { [weak self] (userSearchResponse) in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                weakSelf.view.isUserInteractionEnabled = true
                
                weakSelf.foundUserButton.isUserInteractionEnabled = true
                weakSelf.bringSearchResultView()
                weakSelf.foundUserDetails = userSearchResponse
                if let message = userSearchResponse.message, !message.isEmpty {
                    weakSelf.foundUserLabel.text = userSearchResponse.message
                    weakSelf.viewLabel.text      = ""
                } else {
                    weakSelf.foundUserLabel.text = userSearchResponse.userName
                    weakSelf.viewLabel.text      = "View"
                }
            }
        }
        
        searchScreenViewModel.userNameSearchFailure = { [weak self] in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                weakSelf.view.isUserInteractionEnabled = true
                
                weakSelf.bringSearchResultView()
                weakSelf.foundUserButton.isUserInteractionEnabled = false
                weakSelf.foundUserLabel.text                      = "Not Found"
                weakSelf.viewLabel.text                           = ""
            }
        }
    }
    
    private func bringSearchResultView() {
        searchResultViewCenterYConstraint.constant = searchResultView.bounds.height
        searchResultView.alpha                     = 1.0
        self.view.animateViewWith(duration: 0.5)
    }
    
    private func hideSearchResultView() {
        searchResultViewCenterYConstraint.constant = 0
        searchResultView.alpha                     = 0.0
        self.view.animateViewWith(duration: 0.5)
    }
    
    @IBAction func foundUserButtonAction(_ sender: UIButton) {
        
        searchTextField.text                   = ""
        hideSearchResultView()
        
        let userDetailsController              = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailsController") as! UserDetailsController
        userDetailsController.foundUserDetails = foundUserDetails
        self.navigationController?.pushViewController(userDetailsController, animated: true)
    }
    
    private func showNetworkAlert() {
        let alertController = UIAlertController(title: "Network", message: "You seem to be offline, check your data connection.", preferredStyle: .alert)
        let okayAction      = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SearchScreenController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchString = textField.text, !searchString.isEmpty {
            if Reachability.isConnectedToNetwork() {
                callGithubUsersAPI(username: searchString)
            } else {
                showNetworkAlert()
            }
        }
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideSearchResultView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
        
    }
}
