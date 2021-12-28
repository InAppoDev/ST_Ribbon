//
//  LocalNetworkManager.swift
//  ribbon
//
//  Created by Alexandr on 28.12.2021.
//


import Foundation
import Alamofire

class LocalNetworkManager {
	static let shared = LocalNetworkManager()
	
	private init() {}
	
	private let networkManager = NetworkManager.shared

	//MARK: Search Friend
	func searchFriend(page: Int, text: String, token: String, completion: @escaping (InfoFriend?, CustomErrors?) -> Void) {
		let urlString = URLRequests.searchFriend.rawValue + "?page=\(page)" + "&q=\(text)"
		let headers: HTTPHeaders = ["Content-Type": "accept: application/json", "Authorization": token]
		
		networkManager.fetchData(urlString: urlString, method: .get, headers: headers) { result, error in
			completion(result, error)
		}
	}
	
	//MARK: - Add Friend
	func addFriend(userID: Int, token: String, completion: @escaping (AddFriendResponse?, CustomErrors?) -> Void) {
		let parameters = ["friend" : userID]
		let headers: HTTPHeaders = ["Authorization": token]
		
		networkManager.fetchData(urlString: URLRequests.addFriend.rawValue, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers) { result, error in
			completion(result, error)
		}
	}
	
	//MARK: - Get Feed
	func getFeed(page: Int, language: String, token: String, completion: @escaping (ActivityFeed?, CustomErrors?) -> Void) {
		let urlString = URLRequests.activityFeed.rawValue + "?page=\(page)"
		let headers: HTTPHeaders = ["Content-Type": "accept: application/json", "Accept-Language": language, "Authorization": token]
		
		networkManager.fetchData(urlString: urlString, method: .get, headers: headers) { result, error in
			completion(result, error)
		}
	}
	
	//MARK: - Get Friends
	func getFriends(page: Int, token: String, completion: @escaping (InfoFriend?, CustomErrors?) -> Void) {
		let urlString = URLRequests.getFriends.rawValue + "?page=\(page)"
		let headers: HTTPHeaders = ["Content-Type": "accept: application/json", "Authorization": token]
		
		networkManager.fetchData(urlString: urlString, method: .get, headers: headers) { result, error in
			completion(result, error)
		}
	}
	
	//MARK: - Add Like
	func addLike(feedPostID: Int, token: String, completion: @escaping (LikeModelReponse?, CustomErrors?) -> Void) {
		let headers: HTTPHeaders = ["Authorization": token]
		let parameters = ["feed_post" : feedPostID]
		
		networkManager.fetchData(urlString: URLRequests.addLike.rawValue, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers) { result, error in
			completion(result, error)
		}
	}

	//MARK: - Remove Like
	func removeLike(feedPostID: Int, token: String, completion: @escaping (Bool?, CustomErrors?) -> Void) {
		let urlString = URLRequests.addLike.rawValue + "\(feedPostID)/"
		let headers: HTTPHeaders = ["Content-Type": "accept: application/json", "Authorization": token]
		
		networkManager.fetchData(urlString: urlString, method: .delete, headers: headers) { result, error in
				completion(result, error)
		}
	}
	
	//MARK: - Add Comment
	func addComment(data: PostCommentModel, token: String, comletion: @escaping (CommentResponseModel?, CustomErrors?) -> Void) {
		let headers: HTTPHeaders = ["Authorization": token]

		networkManager.fetchData(urlString: URLRequests.addComment.rawValue, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: headers) { result, error in
			comletion(result, error)
		}
	}
	
	//MARK: - Add Comment
	func getComments(page: Int, feedPostID: Int, token: String, comletion: @escaping (CommentResultModel?, CustomErrors?) -> Void) {
		let urlString = URLRequests.addComment.rawValue + "?page=\(page)&feed_post_id=\(feedPostID)"
		let headers: HTTPHeaders = ["Content-Type": "accept: application/json", "Authorization": token]
		
		networkManager.fetchData(urlString: urlString, method: .get, headers: headers) { result, error in
			comletion(result, error)
		}
	}
}

