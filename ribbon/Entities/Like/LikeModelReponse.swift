//
//  LikeModelRepons.swift
//  ribbon
//
//  Created by Alexandr on 28.12.2021.
//

import Foundation

struct LikeModelReponse: Codable {
	let account: Int
	let feedPost: Int
	let id: Int
	
	enum CodingKeys: String, CodingKey {
		case account
		case feedPost = "feed_post"
		case id
	}
}
