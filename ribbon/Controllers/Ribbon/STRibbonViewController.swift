//
//  STRibbonViewController.swift
//  swim-training
//
//  Created by Alexandr on 11.11.2021.
//

import UIKit

class STRibbonViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	@IBOutlet weak var placeholderView: PlaceholderView!
	private var page = 1
	private var nextPage: String?
	private var feeds: [ResultFeed] = [] { didSet { showPlaceholder(feeds.count == 0)}}
	private let refreshControl = UIRefreshControl()
	
	let friendsButton = UIButton()
	
	private var friendsCount = 0
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "RibbonTitle".localizeString
		
		configureNavigationBar()
		configureTable()
		configureTabBarItem()
		configureNavigationItem()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		getFriends()
		getFeeds()
	}
	
	private func showPlaceholder(_ show: Bool) {
		placeholderView.isHidden = !show
		tableView.isHidden = show
	}

	private func configureTabBarItem() {
	
		friendsButton.setImage(UIImage(named: "friend"), for: .normal)
		friendsButton.setTitle("\(friendsCount)", for: .normal)
		friendsButton.addTarget(self, action: #selector(friendsButtonTapped), for: .touchUpInside)
		friendsButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
		friendsButton.frame = CGRect(x: 0, y: 0, width: 60, height: 0)
		
		let item = UIBarButtonItem()
		item.customView = friendsButton
		navigationItem.rightBarButtonItem = item
	}
	
	private func configureNavigationItem() {
		title = "RibbonBarItemTitle".localizeString
		navigationController?.navigationBar.tintColor = .white
		let backItem = UIBarButtonItem()
		backItem.title = "BackButtonTitle".localizeString
		navigationItem.backBarButtonItem = backItem
	}
	
	private func configureNavigationBar() {
		let appearance = UINavigationBarAppearance()
		appearance.backgroundColor = UIColor(red: 30/255, green: 82/255, blue: 143/255, alpha: 1)
		appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		navigationController?.navigationBar.compactAppearance = appearance
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = appearance
		navigationController?.navigationBar.tintColor = .white
	}
	
	private func configureTable() {
		let nibName = String(describing: STRibbonCell.self)
		let nib = UINib(nibName: nibName, bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "ribbonCell")

		let loadingCellNibName = String(describing: CellWithLoadingIndicator.self)
		let loadingCellNib = UINib(nibName: loadingCellNibName, bundle: nil)
		tableView.register(loadingCellNib, forCellReuseIdentifier: "loadingCell")
		
		tableView.refreshControl = refreshControl
		refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
	}
	
	@objc private func refreshData() {
		getFeeds(isRefresh: true)
	}
	
	@objc private func friendsButtonTapped() {
		let vc = STFriendsViewController()
		vc.hidesBottomBarWhenPushed = true

		self.navigationController?.pushViewController(vc, animated: true)
	}
	

	
	private func splitDataForCell(indexPath: IndexPath) -> (name: String, avatarStringURL: String, publicationDate: String, coverStringURL: String, description: String, likesCount: Int, commentsCount: Int, seconds: Int, hasLike: Bool) {
		
		let result = feeds[indexPath.row]
		let name = result.account.firstname! + result.account.lastname!
		let avatar = result.account.photoURL
		let publicationDate = result.publicationDate
		let photo = result.trainingResult.training.coverURL
		let description = result.trainingResult.training.name
		let likes = result.totalLikes
		let comments = result.commentsCount
		let seconds = result.trainingResult.trainingSeconds
		let hasLike = result.hasLike
		
		return(name, avatar!, publicationDate, photo, description, likes, comments, seconds, hasLike)
	}
	
	private func getFeeds(isLoadMore: Bool = false, isRefresh: Bool = false) {
		guard let token = UserManager.shared.userToken else { return }
		if !isLoadMore { SpiningManager.shared.startIndicator() }
		
		LocalNetworkManager.shared.getFeed(page: page, language: Constats.Language.systemLanguage, token: token) {
			[weak self] result, error in
			SpiningManager.shared.stopIndicator()
			if isRefresh { self?.refreshControl.endRefreshing() }
			
			if let result = result {
				if isLoadMore {
					self?.feeds.append(contentsOf: result.results)
				} else {
					self?.feeds = result.results
				}
				self?.tableView.reloadData()
				self?.nextPage = result.next
				if let next = result.next, !next.isEmpty {
					self?.page  = ( (self?.feeds.count)! / 20) + 1
				}
			} else {
				self?.showErrorAlert(error: error)
			}
		}
	}
	
	private func getFriends() {
		guard let token = UserManager.shared.userToken else { return }
		
		LocalNetworkManager.shared.getFriends(page: 1, token: token) { [weak self] result, error in
			if let result = result {
				self?.friendsCount = result.count
				self?.friendsButton.setTitle("\(result.count)", for: .normal)
			} else {
				self?.showErrorAlert(error: error)
			}
		}
		
	}
}

//MARK: - UITableViewDataSource
extension STRibbonViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let nextPage = nextPage, !nextPage.isEmpty {
			return feeds.count + 1
		} else {
			return feeds.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if let nextPage = nextPage, !nextPage.isEmpty && indexPath.row == feeds.count {
			let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
			getFeeds(isLoadMore: true)
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "ribbonCell", for: indexPath) as! STRibbonCell
			cell.delegate = self
			let feed = splitDataForCell(indexPath: indexPath)
			
			cell.configureCell(avatarStringURL: feed.avatarStringURL, userName: feed.name, description: feed.description, publicationDate: feed.publicationDate, coverStringURL: feed.coverStringURL, likesCount: feed.likesCount, commentsCount: feed.commentsCount, seconds: feed.seconds, hasLike: feed.hasLike)
			cell.feedPostID = feeds[indexPath.row].id
			cell.indexPath = indexPath
			
			return cell
		}
	}
}

//MARK: - UITableViewDelegate
extension STRibbonViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if UIDevice().userInterfaceIdiom == .pad {
			return 435
		} else {
			return 335
		}
	}
}

//MARK: - STRibbonCellProtocol
extension STRibbonViewController: STRibbonCellProtocol {
	func toggleLike(index: IndexPath, isRemoveLike: Bool) {
		var feed = feeds[index.row]
		
		if isRemoveLike {
			feed.hasLike = false
			feed.totalLikes -= 1
		} else {
			feed.hasLike = true
			feed.totalLikes += 1
		}
		
		feeds[index.row] = feed
		tableView.reloadRows(at: [index], with: .automatic)
	}
}
