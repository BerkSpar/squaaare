//
//  Duration.swift
//  telly
//
//  Created by Felipe Passos on 29/08/23.
//

import Foundation

struct Duration {
    var days: Int
    var hours: Int
    var minutes: Int
    var seconds: Int
    var milliseconds: Int
    var microseconds: Int

    init(days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0, milliseconds: Int = 0, microseconds: Int = 0) {
        self.days = days
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.milliseconds = milliseconds
        self.microseconds = microseconds
    }

    func inSeconds() -> TimeInterval {
        return TimeInterval(days * 86400 + hours * 3600 + minutes * 60 + seconds + milliseconds / 1000 + microseconds / 1_000_000)
    }

    func inNanoseconds() -> UInt64 {
        let daysInNanoseconds = UInt64(days) * 86_400_000_000_000
        let hoursInNanoseconds = UInt64(hours) * 3_600_000_000_000
        let minutesInNanoseconds = UInt64(minutes) * 60_000_000_000
        let secondsInNanoseconds = UInt64(seconds) * 1_000_000_000
        let millisecondsInNanoseconds = UInt64(milliseconds) * 1_000_000
        let microsecondsInNanoseconds = UInt64(microseconds) * 1_000
        return daysInNanoseconds + hoursInNanoseconds + minutesInNanoseconds + secondsInNanoseconds + millisecondsInNanoseconds + microsecondsInNanoseconds
    }
}
