//
//  PostCommentMode.swift
//  ribbon
//
//  Created by Alexandr on 28.12.2021.
//

import Foundation

struct PostCommentModel: Codable {
	let text: String
	let feedPost: Int
	let account: CommentAccount
	
	enum CodingKeys: String, CodingKey {
		case text
		case feedPost = "feed_post"
		case account
	}
}

struct CommentAccount: Codable {
	let firstname: String
	let lastname: String
}

