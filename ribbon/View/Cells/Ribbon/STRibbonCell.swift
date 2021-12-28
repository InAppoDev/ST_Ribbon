//
//  STRibbonCell.swift
//  swim-training
//
//  Created by Alexandr on 30.11.2021.
//

import UIKit
import SDWebImage

protocol STRibbonCellProtocol: AnyObject {
	func toggleLike(index: IndexPath, isRemoveLike: Bool)
}

class STRibbonCell: UITableViewCell {
	
	@IBOutlet weak var avatarImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	
	@IBOutlet weak var mainImage: UIImageView!
	
	@IBOutlet weak var likeButtonOutlet: UIButton!
	@IBOutlet weak var commentButtonOutlet: UIButton!
	
	var feedPostID: Int?
	var indexPath = IndexPath()
	weak var delegate: STRibbonCellProtocol?
	
	private var hasLike = false
	private var likesCount = 0
	
	func configureCell(avatarStringURL: String, userName: String, description: String, publicationDate: String, coverStringURL: String, likesCount: Int, commentsCount: Int, seconds: Int, hasLike: Bool) {
		
		nameLabel.text = userName
		descriptionLabel.text = description
		likeButtonOutlet.setTitle("\(likesCount)", for: .normal)
		commentButtonOutlet.setTitle("\(commentsCount)", for: .normal)
		timeLabel.text = TimeManager.shared.getTimeString(seconds: seconds)
		
		let publicationDateString = DateManager.shared.publicationTime(value: publicationDate)
		nameLabel.text = "\(userName) \(publicationDateString)"
		
		self.hasLike = hasLike
		self.likesCount = likesCount

		if hasLike {
			self.likeButtonOutlet.imageView?.tintColor = UIColor(red: 203/255, green: 11/255, blue: 69/255, alpha: 1)
		} else {
			self.likeButtonOutlet.imageView?.tintColor = .lightGray
		}
		
		setCoverImage(coverStringURL: coverStringURL)
		setAvatarImage(avatarStringURL: avatarStringURL)
	}

	private func setCoverImage(coverStringURL: String) {
		if let mainImageURL = URL(string: URLRequests.baseMediaUrl.rawValue + coverStringURL) {
			mainImage.sd_setImage(with: mainImageURL) { image, _, _, _ in
				
			}
		}
	}
	
	private func setAvatarImage(avatarStringURL: String) {
		if let avatarImageURL = URL(string: URLRequests.baseMediaUrl.rawValue + avatarStringURL) {
			avatarImage.sd_setImage(with: avatarImageURL) { image, _, _, _ in
				if image == nil {
					self.avatarImage.image = UIImage(systemName: "person.circle")
				}
			}
		}
	}
	
	@IBAction func likeButtonTapped(_ sender: UIButton) {
		guard let feedPostID = feedPostID, let token = UserManager.shared.userToken else { return }

		if self.hasLike {
			self.removeLike(feedPostID: feedPostID, token: token)
		} else {
			self.addLike(feedPostID: feedPostID, token: token)
		}
		
	}
	
	@IBAction func commentButtonTapped(_ sender: UIButton) {
		guard let topVC = UIApplication.topViewController() else { return }
		let commentVC = STCommentsViewController()
//		commentVC.hidesBottomBarWhenPushed = true
		commentVC.feedPostID = feedPostID
		
		topVC.navigationController?.pushViewController(commentVC, animated: true)
	}
}

//MARK: - Network
private extension STRibbonCell {
	func addLike(feedPostID: Int, token: String) {
		LocalNetworkManager.shared.addLike(feedPostID: feedPostID, token: token) { result, error in
			if let _ = result {
				self.likeButtonOutlet.imageView?.tintColor = UIColor(red: 203/255, green: 11/255, blue: 69/255, alpha: 1)
				self.likeButtonOutlet.setTitle("\(self.likesCount + 1)", for: .normal)
				self.hasLike = true
				self.delegate?.toggleLike(index: self.indexPath, isRemoveLike: false)
			} else {
//				guard let topVC = UIApplication.topViewController() else { return }
				//MARK: -
//				topVC.showErrorAlert(error: error)
			}
		}
	}
	func removeLike(feedPostID: Int, token: String) {
		LocalNetworkManager.shared.removeLike(feedPostID: feedPostID, token: token) { result, error in

			if let _ = result {
				self.likeButtonOutlet.imageView?.tintColor = .lightGray
				self.likeButtonOutlet.setTitle("\(self.likesCount - 1)", for: .normal)
				self.hasLike = false
				self.delegate?.toggleLike(index: self.indexPath, isRemoveLike: true)
			} else {
//				guard let topVC = UIApplication.topViewController() else { return }
				//MARK: -
//				topVC.showErrorAlert(error: error)
			}
		}
	}
}
