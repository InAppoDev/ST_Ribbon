//
//  PostCommentResponseModel.swift
//  ribbon
//
//  Created by Alexandr on 28.12.2021.
//

import Foundation

// MARK: - CommentModel
struct CommentResponseModel: Codable {
	let id: Int
	let text: String
	let feedPost: Int
	let publicationDate: Double
	let account: Account

	enum CodingKeys: String, CodingKey {
		case id, text
		case feedPost = "feed_post"
		case publicationDate = "publication_date"
		case account
	}
}
