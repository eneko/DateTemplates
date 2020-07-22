import Foundation

// MARK: Locales

let enUS = Locale(identifier: "en_US")
let esES = Locale(identifier: "es_ES")

// MARK: TimeZones

let utc = TimeZone(secondsFromGMT: 0) ?? .current

// MARK: - Dates

// 1/1/1970 00:00:00 UTC
let epoch = Date(timeIntervalSince1970: 0)

// Dec 31 2999 @23:59:59 UTC
let futurama = Date(day: 31, month: 12, year: 2999, hours: 23, minutes: 59, seconds: 59, timeZone: utc)

// Mar 15 44 BC
let cesar = Date(day: 15, month: 3, year: 44, era: 0)

// MARK: - Mock Dates

extension Date {
    init(day: Int, month: Int, year: Int, era: Int? = nil,
         hours: Int = 0, minutes: Int = 0, seconds: Int = 0, timeZone: TimeZone = .current) {
        let components = DateComponents(calendar: .current, timeZone: timeZone, era: era,
                                        year: year, month: month, day: day,
                                        hour: hours, minute: minutes, second: seconds)
        self = components.date ?? Date.distantPast
    }
}
