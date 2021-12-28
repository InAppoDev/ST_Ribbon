//
//  DateManager.swift
//  ribbon
//
//  Created by Alexandr on 28.12.2021.
//


import UIKit

class DateManager {
	static let shared = DateManager()
	
	private init() {}
	
	private var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = Constats.DateFormatter.dateFormat
		formatter.dateStyle = .medium
		formatter.locale = Locale(identifier: systemLanguage)
		
		return formatter
	}
	
	private var systemLanguage: String {
		return NSLocale.current.languageCode ?? ""
	}
	
	func getDateString(value: Int) -> String {
		let timeInterval = TimeInterval(value)
		let dateString = dateString(timeInterval: timeInterval)
		
		return dateString
	}
	
	
	func publicationTime(value: String) -> String {
		guard let value = Int(value) else { return "" }

		let timeIntervalNow = Date().timeIntervalSince1970
		let timeIntervalPost = TimeInterval(value)
		
		if (timeIntervalNow - timeIntervalPost)/3600 < 1 {
			return timePublicationInMinutes(value: value)
		} else if (timeIntervalNow - timeIntervalPost)/3600 < 24 {
			return timePublicationInHours(value: value)
		} else  {
			return "(\(getDateString(value: value)))"
		}
	}
	
	private func timePublicationInHours(value: Int) -> String {
		let timeIntervalNow = Date().timeIntervalSince1970
		let timeIntervalPost = TimeInterval(value)
		let time = Int(timeIntervalNow - timeIntervalPost) / 3600
	
		return "(\(time) \("Hours".localizeString))"
	}
	
	private func timePublicationInMinutes(value: Int) -> String {
		let timeIntervalNow = Date().timeIntervalSince1970
		let timeIntervalPost = TimeInterval(value)
		let time = Int(timeIntervalNow - timeIntervalPost) / 60
	
		return "(\(time) \("Minutes".localizeString))"
	}
	
	private func dateString(timeInterval: TimeInterval) -> String {
		let date = Date(timeIntervalSince1970: timeInterval)
		let dateString = dateFormatter.string(from: date)
		
		let yesterdayDate = Date(timeInterval: TimeInterval(-86400), since: Date())
		let yesterdayDateString = dateFormatter.string(from: yesterdayDate)
		
		let dateNow = Date()
		let dateNowString = dateFormatter.string(from: dateNow)
		
		if dateNowString == dateString {
			return "Today".localizeString
		} else if yesterdayDateString == dateString {
			return "Yesterday".localizeString
		} else {
			return dateString
		}
	}
}

