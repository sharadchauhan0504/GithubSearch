//
//  RepositoryCollectionCell.swift
//  GitHubSearch
//
//  Created by Sharad S. Chauhan on 04/01/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import UIKit

class RepositoryCollectionCell: UICollectionViewCell {

    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var openRepoButton: UIButton!
    
    var repositoryDetail: RepositoryDetails? {
        didSet {
            updateCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        openRepoButton.addCornerRadius(radius: 5.0)
        self.addCornerRadius(radius: 5.0)
    }
    
    private func updateCellData() {
        guard let repoDetails = repositoryDetail else {return}
        repoName.text = repoDetails.name
        repoLanguage.text = repoDetails.language
        if let createdAtString = repoDetails.createdAt {
            createdAtLabel.text = "\(getReadableDateStringFrom(dateString: createdAtString))"
        }
    }
    
    @IBAction func openRepoAction(_ sender: UIButton) {
        guard let repoDetails = repositoryDetail, let repoUrlString = repoDetails.repoUrlString, let url = URL(string: repoUrlString) else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
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
}
