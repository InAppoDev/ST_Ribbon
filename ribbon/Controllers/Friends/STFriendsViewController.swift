//
//  STFriendsViewController.swift
//  swim-training
//
//  Created by Alexandr on 02.12.2021.
//

import UIKit

class STFriendsViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addFriendButtonOultet: GradientButton!
	
	private var page = 1
	private var nextPage: String?
	private var friends: [FriendsResult] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()

		configureTable()
		configureNavigationItem()
		getFriends()
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let topColor = Constats.Colors.topGradientColor
		let bottomColor = Constats.Colors.bottomGradientColor
		addFriendButtonOultet.applyGradient(topColor: topColor, bottomColor: bottomColor)
		
		addFriendButtonOultet.setTitle("AddFriendButtonTitle".localizeString, for: .normal)
	}

	private func configureNavigationItem() {
		title = "FriendsTitle".localizeString
		navigationController?.navigationBar.tintColor = .white
		let backItem = UIBarButtonItem()
		backItem.title = "BackButtonTitle".localizeString
		navigationItem.backBarButtonItem = backItem
	}
	
	private func configureTable() {
		let nibName = String(describing: STFriendCell.self)
		let nib = UINib(nibName: nibName, bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "friendCell")
		
		let loadingCellNibName = String(describing: CellWithLoadingIndicator.self)
		let loadingCellNib = UINib(nibName: loadingCellNibName, bundle: nil)
		tableView.register(loadingCellNib, forCellReuseIdentifier: "loadingCell")
	}
	
	private func getFriends(isLoadMore: Bool = false) {
		guard let token = UserManager.shared.userToken else { return }
		if isLoadMore { SpiningManager.shared.startIndicator() }
		
		LocalNetworkManager.shared.getFriends(page: 1, token: token) { [weak self] result, error in
			SpiningManager.shared.stopIndicator()
			if let result = result {
				if isLoadMore {
					self?.friends.append(contentsOf: result.results)
				} else {
					self?.friends = result.results
				}
				self?.nextPage = result.next
				if let next = result.next, !next.isEmpty {
					self?.page  = ( (self?.friends.count)! / 20) + 1
				}
				self?.tableView.reloadData()
			} else {
				self?.showErrorAlert(error: error)
			}
		}
		
	}
	
	@IBAction func addFriendTapped(_ sender: GradientButton) {
		let vc = STSearchViewController()
		vc.hidesBottomBarWhenPushed = true
		
		self.navigationController?.pushViewController(vc, animated: true)
	}
}

//MARK: - UITableViewDataSource
extension STFriendsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let nextPage = nextPage, !nextPage.isEmpty {
			return friends.count + 1
		} else {
			return friends.count
		}
	}
	

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let nextPage = nextPage, !nextPage.isEmpty && indexPath.row == friends.count {
			let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
			getFriends(isLoadMore: true)
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! STFriendCell
			let friend = friends[indexPath.row]
			cell.configureFriendCell(photoString: friend.photoURL, name: friend.firstname ?? "user \(friend.id)")
			
			return cell
		}
	}
}

//MARK: - UITableViewDelegate
extension STFriendsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		80
	}
}

