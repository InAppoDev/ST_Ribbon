//
//  STSearchViewController.swift
//  swim-training
//
//  Created by Alexandr on 29.11.2021.
//

import UIKit

class STSearchViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	var page = 1
	var friends: [FriendsResult] = []
	var nextPage: String?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		searchBar.placeholder = "EnterNameTitle".localizeString
		title = "SearchTitle".localizeString
		
		configureTable()
    }
	
	private func configureTable() {
		let nibName = String(describing: STFriendCell.self)
		let nib = UINib(nibName: nibName, bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "friendCell")
		
		let nibNameActivity = String(describing: CellWithLoadingIndicator.self)
		let nibActivity = UINib(nibName: nibNameActivity, bundle: nibBundle)
		tableView.register(nibActivity, forCellReuseIdentifier: "loadingCell")
	}
	
	private func searchFriend(text: String, isLoadMore: Bool = false) {
		guard let token = UserManager.shared.userToken else { return }
		if !isLoadMore {
			SpiningManager.shared.startIndicator()
		}
		LocalNetworkManager.shared.searchFriend(page: page, text: text, token: token) { [weak self]  result, error in
			SpiningManager.shared.stopIndicator()
			if let result = result {
				if isLoadMore {
					self?.friends.append(contentsOf: result.results)
				} else {
					self?.friends = result.results
				}
				
				self?.tableView.reloadData()
				self?.nextPage = result.next
				if let next = result.next, !next.isEmpty {
					self?.page  = ( (self?.friends.count)! / 20) + 1
				}
			}  else {
				self?.showErrorAlert(error: error)
			}
		}
	}
	
	private func addFriend(userID: Int) {
		guard let userToken = UserManager.shared.userToken else { return }
		let userID = userID
		
		SpiningManager.shared.startIndicator()
		LocalNetworkManager.shared.addFriend(userID: userID, token: userToken) { [weak self] result, error in
			SpiningManager.shared.stopIndicator()
			
			if result != nil {
				self?.navigationController?.popViewController(animated: true)
			}  else {
				self?.showErrorAlert(error: error)
			}
		}
	}
}

//MARK: - UITableViewDataSource
extension STSearchViewController: UITableViewDataSource {
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
			let searchText = searchBar.text ?? ""
			searchFriend(text: searchText, isLoadMore: true)
			
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
extension STSearchViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if UIDevice().userInterfaceIdiom == .pad {
			return 120
		} else {
			return 80
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let userID = friends[indexPath.row].id
		let userName = friends[indexPath.row].firstname ?? "user"
		let message = "AddFriendMessage".localizeString + userName  + "?"
		
		let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
		alert.addAction(.init(title: "No".localizeString, style: .cancel))
		alert.addAction(.init(title: "Yes".localizeString, style: .default, handler: { _ in
			self.addFriend(userID: userID)
		}))
		
		self.present(alert, animated: true)
	}
}

//MARK: - UISearchBarDelegate
extension STSearchViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.contains(" ") || searchText.contains(".") {
			var newSearchText = searchText
			newSearchText.removeAll { char in
				char == " " || char == "."
			}
			
			searchFriend(text: newSearchText)
		} else {
			searchFriend(text: searchText)
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}
