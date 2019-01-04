//
//  UserDetailsController.swift
//  GitHubSearch
//
//  Created by Sharad S. Chauhan on 03/01/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import UIKit

class UserDetailsController: UIViewController {

    @IBOutlet weak var userAvatarImageView: ImageDownloader!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    @IBOutlet weak var numberOfFollowers: UILabel!
    @IBOutlet weak var numberOfFollowing: UILabel!
    @IBOutlet weak var userDetailsContainerView: UIView!
    @IBOutlet weak var repositoryCollectionView: UICollectionView!
    @IBOutlet weak var shadowView: UIView!
    
    let userDetailsViewModel = UserDetailsViewModel()
    var foundUserDetails: UserDetails?
    var foundRepositories = [RepositoryDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        initialSetup()
    }

    private func initialSetup() {
        if let userDetails = foundUserDetails {
            name.text              = userDetails.name
            companyName.text       = userDetails.company
            if let locationString = userDetails.location {
                location.text          = "Location - \(locationString)"
            }
            if let usernameString = userDetails.userName {
                username.text          = "Username - \(usernameString)"
                getRepoDetails(username: usernameString)
            }
            if let bioString = userDetails.bio {
                bio.text               = "Bio - \(bioString)"
            }
            if let followers = userDetails.numberOfFollowers {
                numberOfFollowers.text = "Followers - \(followers)"
            }
            if let updatedAtString = userDetails.updatedAt {
                updatedAt.text = "Updated at - \(getReadableDateStringFrom(dateString: updatedAtString))"
            }
            if let following = userDetails.numberOfFollowing {
                numberOfFollowing.text = "Following - \(following)"
            }
            
            if let imageUrlString = userDetails.avatarUrlString, let imageUrl = URL(string: imageUrlString) {
                userAvatarImageView.downloadImageFrom(url: imageUrl, imageMode: .scaleAspectFill)
            }
        }
        
        userDetailsContainerView.addCornerRadius(radius: 5.0)
        userDetailsContainerView.addShadow()
    }
    
    private func getReadableDateStringFrom(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            let readableDateFormatter = DateFormatter()
            readableDateFormatter.dateFormat = "dd MMM yyyy"
            let stringDate = readableDateFormatter.string(from: date)
            return stringDate
        }
        return ""
    }
    
    
    private func registerCells() {
        let repositoryCollectionCell = UINib(nibName: "RepositoryCollectionCell", bundle: nil)
        repositoryCollectionView.register(repositoryCollectionCell, forCellWithReuseIdentifier: "RepositoryCollectionCell")
        
        repositoryCollectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 0)
    }
    
    private func getRepoDetails(username: String) {
        let activityIndicator    = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = repositoryCollectionView.center
        repositoryCollectionView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        userDetailsViewModel.callRepoSearchAPI(username: username)
        
        userDetailsViewModel.repoSearchCallback = { [weak self] (repoSearhResponse) in
            guard let weakSelf = self else {return}
            weakSelf.foundRepositories = repoSearhResponse
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                weakSelf.repositoryCollectionView.reloadData()
            }
        }
        
        userDetailsViewModel.repoSearchFailure = {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareUserUrlAction(_ sender: UIButton) {
        guard let userDetails = foundUserDetails, let username = userDetails.userName, let url = URL(string: "\(baseUrl)/\(username)") else {return}
        let text                                                         = "Please find Github user's profile link"
        let sharedObjects                                                = [text as AnyObject, url as AnyObject]
        let activityViewController                                       = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes                     = [ UIActivityType.airDrop, UIActivityType.postToFacebook, UIActivityType.postToTwitter, UIActivityType.mail]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension UserDetailsController: UICollectionViewDelegate {}

extension UserDetailsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foundRepositories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepositoryCollectionCell", for: indexPath) as! RepositoryCollectionCell
        cell.repositoryDetail = foundRepositories[indexPath.item]
        return cell
    }
}

extension UserDetailsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10.0
        let width = collectionView.bounds.width/4 + padding
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}
