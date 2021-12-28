//
//  TrainingModel.swift
//  ribbon
//
//  Created by Alexandr on 28.12.2021.
//


import Foundation

struct Trainings: Codable {
	let id: Int?
	let name: String
	let difficultyLevel: Int
	let description: String
	let distance: Int
	let paidAccess: Bool
	let coverURL: String
	let kcalPerMinute: Double
	let metersPerMinute: Int
	let lastResult: LastResult?
	let materials: [Material]?

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case difficultyLevel = "difficulty_level"
		case description
		case distance
		case paidAccess = "paid_access"
		case coverURL = "cover_url"
		case kcalPerMinute = "kcal_per_minute"
		case metersPerMinute = "meters_per_minute"
		case lastResult = "last_result"
		case materials
	}
}

// MARK: - LastResult
struct LastResult: Codable {
}

// MARK: - Material
struct Material: Codable {
	let id: Int
	let content: String
	let video: Video?
}

// MARK: - Video
struct Video: Codable {
	let name, fileURL: String

	enum CodingKeys: String, CodingKey {
		case name
		case fileURL = "file_url"
	}
}

