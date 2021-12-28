//
//  STCommentsViewController.swift
//  swim-training
//
//  Created by Alexandr on 03.12.2021.
//

import UIKit

class STCommentsViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	@IBOutlet weak var textField: UITextField!
	
	@IBOutlet weak var sendButtonOutlet: UIButton!
	
	@IBOutlet weak var bottomTFConstraint: NSLayoutConstraint!
	
	var feedPostID: Int?
	
	private var page = 1
	private var nextPage: String?
	private var comments: [CommentResult] = []
	
	private var needLoadComments = false
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "CommentsTitle".localizeString
		configureTable()
		beginKeyboardObserving()
		getComments()
		
		
		textField.layer.borderWidth = 2
		textField.layer.borderColor = UIColor.lightGray.cgColor
		textField.layer.cornerRadius = 4
    }

	
	override func keyboardWillShow(withHeight keyboardHeight: CGFloat,  duration: TimeInterval, options: UIView.AnimationOptions) {

		bottomTFConstraint.constant = keyboardHeight - 70
		UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
			self.view.layoutIfNeeded()
		})

	}
	
	override func keyboardWillHide(withDuration duration: TimeInterval, options: UIView.AnimationOptions) {

		bottomTFConstraint.constant = 10
		UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
			self.view.layoutIfNeeded()
		})
	}
		
	private func configureTable() {
		let nibName = String(describing: STFriendCell.self)
		let nib = UINib(nibName: nibName, bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "friendCell")
		
		let nibNameLoadingCell = String(describing: CellWithLoadingIndicator.self)
		let nibLoadingCell = UINib(nibName: nibNameLoadingCell, bundle: nil)
		tableView.register(nibLoadingCell, forCellReuseIdentifier: "loadingCell")
	}
	
	private func getComments(isLoadMore: Bool = false) {
		guard let token = UserManager.shared.userToken, let feedPostID = feedPostID else { return }
needLoadComments = false
		
		if isLoadMore { SpiningManager.shared.startIndicator()}
		LocalNetworkManager.shared.getComments(page: page, feedPostID: feedPostID, token: token) { [weak self] result, error in
			SpiningManager.shared.stopIndicator()
			
			if let result = result {
				if isLoadMore {
					var tempArray = result.results
					tempArray.reverse()
					self?.comments.insert(contentsOf: tempArray, at: 0)
				} else {
					self?.comments = result.results
					self?.comments.reverse()
				}
				
				self?.nextPage = result.next
				if let next = result.next, !next.isEmpty {
					self?.page  = ( (self?.comments.count)! / 20) + 1
				} else {
				}
				
				self?.tableView.reloadData()
				if !isLoadMore {
					if result.results.count > 1 {
						//MARK: -
					self?.tableView.scrollToRow(at: IndexPath(row: self!.comments.count - 1, section: 0), at: .bottom, animated: false)
					}
				} else {
					self?.tableView.scrollToRow(at: IndexPath(row: result.results.count - 1, section: 0), at: .bottom, animated: false)
				}
			}  else {
				self?.showErrorAlert(error: error)
			}
		
		}
	}
	
	@IBAction func sendButtonTapped(_ sender: UIButton) {
		
		guard let token = UserManager.shared.userToken, let accountID = UserManager.shared.userAccountID, let feedPostID = feedPostID, let text = textField.text, !text.isEmpty else { return }
		
		let accountModel = CommentAccount(firstname: "", lastname: "")
		let data = PostCommentModel(text: text, feedPost: feedPostID, account: accountModel)
		
		LocalNetworkManager.shared.addComment(data: data, token: token) { [weak self] result, error in
			if let result = result {
				let commentResult = CommentResult(id: result.id, text: result.text, feedPost: result.feedPost, publicationDate: result.publicationDate, account: result.account)
				self?.comments.append(commentResult)
				let indexPath = IndexPath(row: self!.comments.count - 1, section: 0)
				self?.tableView.insertRows(at: [indexPath], with: .automatic)
				self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
				self?.textField.text = nil
			} else {
				self?.showErrorAlert(error: error)
			}
		}
	}
	
}

//MARK: - UITableViewDataSource
extension STCommentsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let nextPage = nextPage, !nextPage.isEmpty {
			return comments.count + 1
		} else {
			return comments.count
		}
	}
	

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if let nextPage = nextPage, !nextPage.isEmpty && indexPath.row != 0 {
			needLoadComments = true
		}

		if let nextPage = nextPage, !nextPage.isEmpty &&  indexPath.row == 0 && needLoadComments {
			let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
			getComments(isLoadMore: true)
			needLoadComments = false
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! STFriendCell

			var comment: CommentResult
			if let nextPage = nextPage, !nextPage.isEmpty {
				comment = comments[indexPath.row - 1]
			} else {
				comment = comments[indexPath.row]
			}
			let firstname = comment.account.firstname ?? ""
			let lastname = comment.account.lastname ?? ""
			let fullName = firstname + lastname
			cell.configureCommentCell(photoString: comment.account.photoURL ?? "", name: fullName, text: comment.text)
			
			return cell
		}
	}
}

//MARK: - UITableViewDelegate
extension STCommentsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		80
	}
}

//MARK: - UITextFieldDelegate
extension STCommentsViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
