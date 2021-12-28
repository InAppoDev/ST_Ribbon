//
//  InfoFriend.swift
//  ribbon
//
//  Created by Alexandr on 28.12.2021.
//

import Foundation

// MARK: - InfoFriend
struct InfoFriend: Codable {
	let count: Int
	let next: String?
	let previous: String?
	let results: [FriendsResult]
	
	init() {
		count = 0
		next = ""
		previous = ""
		results = []
	}
	
	init(count: Int, next: String, previous: String, results: [FriendsResult]) {
		self.count = count
		self.next = next
		self.previous = previous
		self.results = results
	}
}

// MARK: - Result
struct FriendsResult: Codable {
	let id: Int
	let photoURL: String
	let firstname: String?
	let lastname: String?

	enum CodingKeys: String, CodingKey {
		case id
		case photoURL = "photo_url"
		case firstname, lastname
	}
}

