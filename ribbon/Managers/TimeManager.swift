//
//  TimeManager.swift
//  ribbon
//
//  Created by Alexandr on 28.12.2021.
//

import UIKit

class TimeManager {
	static let shared = TimeManager()

	private init() {}

	func getTimeString(seconds: Int) -> String {
		let time = secondsToHoursMinutesSeconds(seconds: seconds)

		let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)

		return timeString
	}

	func getTimerString(seconds: Int) -> String {
		let time = secondsToHoursMinutesSecondsTimer(seconds: seconds)
		let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)

		return timeString
	}

	func secondsToHoursMinutesSecondsTimer(seconds: Int) -> (Int, Int, Int) {
		return (((seconds / 216000)), ((seconds / 3600) % 60), ((seconds / 60) % 60 ))
	}

	private func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
		return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
	}

	private func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
		var timeString = ""
		timeString += String(format: "%02d", hours)
		timeString += " : "
		timeString += String(format: "%02d", minutes)
		timeString += " : "
		timeString += String(format: "%02d", seconds)

		return timeString
	}
}


