//
//  ActivityFeed.swift
//  ribbon
//
//  Created by Alexandr on 28.12.2021.
//


import Foundation


// MARK: - ActivityFeed
struct ActivityFeed: Codable {
	let count: Int
	let next: String?
	let previous: String?
	let results: [ResultFeed]
}

// MARK: - Result
struct ResultFeed: Codable {
	let id: Int
	let publicationDate: String
	let photo: String?
	var totalLikes: Int
	let trainingResult: TrainingResult
	var hasLike: Bool
	let commentsCount: Int
	let account: Account

	enum CodingKeys: String, CodingKey {
		case id
		case publicationDate = "publication_date"
		case photo
		case totalLikes = "total_likes"
		case trainingResult = "training_result"
		case hasLike = "has_like"
		case commentsCount = "comments_count"
		case account
	}
}

// MARK: - Account
struct Account: Codable {
	let id: Int
	let photoURL: String?
	let firstname: String?
	let lastname: String?

	enum CodingKeys: String, CodingKey {
		case id
		case photoURL = "photo_url"
		case firstname, lastname
	}
}

// MARK: - TrainingResult
struct TrainingResult: Codable {
	let id: Int
	let creationDate: String
	let training: Trainings
	let trainingKcal: Int
	let trainingKM: Double
	let trainingSeconds: Int
	let trainingAveragePulse: Int

	enum CodingKeys: String, CodingKey {
		case id
		case creationDate = "creation_date"
		case training
		case trainingKcal = "training_kcal"
		case trainingKM = "training_km"
		case trainingSeconds = "training_seconds"
		case trainingAveragePulse = "training_average_pulse"
	}
}

