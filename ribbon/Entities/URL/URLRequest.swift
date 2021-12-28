//
//  URLRequest.swift
//  ribbon
//
//  Created by Alexandr on 28.12.2021.
//

import Foundation

enum URLRequests: String {
	case baseUrl
	case baseMediaUrl
	case searchFriend
	case addFriend
	case activityFeed
	case getFriends
	case addLike
	case addComment
}

extension URLRequests {
	var rawValue: String {
		switch self {
		case .baseUrl:
			return "http://188.227.16.13/api/v3/"
		case .baseMediaUrl:
			return "http://188.227.16.13"
		case .searchFriend:
			return URLRequests.baseUrl.rawValue + "accounts/friends/search/"
		case .addFriend:
			return URLRequests.baseUrl.rawValue + "accounts/friends/"
		case .activityFeed:
			return URLRequests.baseUrl.rawValue + "activity/feed/"
		case .getFriends:
			return URLRequests.baseUrl.rawValue + "accounts/friends/"
		case .addLike:
			return URLRequests.baseUrl.rawValue + "activity/feed/like/"
		case .addComment:
			return URLRequests.baseUrl.rawValue + "activity/feed/comments/"
		}
	}
}

