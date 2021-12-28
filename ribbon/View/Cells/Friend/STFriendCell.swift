//
//  STSearchFriendCell.swift
//  swim-training
//
//  Created by Alexandr on 29.11.2021.
//

import UIKit
import SDWebImage

class STFriendCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var avatarImage: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
		avatarImage.clipsToBounds = true
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		avatarImage.clipsToBounds = true
		avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
	}
	
	func configureFriendCell(photoString: String, name: String) {
		nameLabel.text = name

		
		guard let photoURL = URL(string: URLRequests.baseMediaUrl.rawValue + photoString) else { return }
		avatarImage.sd_setImage(with: photoURL) { image, _, _, _ in
			if image == nil {
				self.avatarImage.image = UIImage(systemName: "person.circle")
			}
		}
	}
	
	func configureCommentCell(photoString: String, name: String, text: String) {
		nameLabel.text = name + ": \(text)"

		guard let photoURL = URL(string: URLRequests.baseMediaUrl.rawValue + photoString) else { return }
		avatarImage.sd_setImage(with: photoURL) { image, _, _, _ in
			if image == nil {
				self.avatarImage.image = UIImage(systemName: "person.circle")
			}
		}
	}
}
