//
//  PlaceholderView.swift
//  swim-training
//
//  Created by Alexandr on 02.12.2021.
//

import UIKit

class PlaceholderView: ViewFromXib {

	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var addFriendButtonOutlet: GradientButton!
	
	
	override func setupViews() {
		localizeTitles()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let topColor = Constats.Colors.topGradientColor
		let bottomColor = Constats.Colors.bottomGradientColor
		addFriendButtonOutlet.applyGradient(topColor: topColor, bottomColor: bottomColor)
	}
	
	private func localizeTitles() {
		titleLabel.text = "PlaceholderLabelTitle".localizeString
		addFriendButtonOutlet.setTitle("AddFriendButtonTitle".localizeString, for: .normal)
	}

	@IBAction func addFriendTapped(_ sender: GradientButton) {
		guard let topVC = UIApplication.topViewController() else { return }
		
		let pushVC = STFriendsViewController()
		pushVC.hidesBottomBarWhenPushed = true
		topVC.navigationController?.pushViewController(pushVC, animated: true)
	}
	
}
