import XCTest
import DateFormats

final class DateTemplateTests: XCTestCase {

    let enUS = Locale(identifier: "en_US")
    let esES = Locale(identifier: "es_ES")
    let utc = TimeZone(secondsFromGMT: 0) ?? .current

    let epoch = Date(timeIntervalSince1970: 0) // 1/1/1970 00:00:00 UTC
    let futurama = Date(timeIntervalSince1970: 32503679999) // Dec 31 2999 @23:59:59 UTC

    func testEra() {
        let sut = DateTemplate().era().template
        XCTAssertEqual(sut, "G")
    }

    func testCesarsDeath() throws {
        let cesar = try XCTUnwrap(Date(day: 15, month: 3, year: 44, era: 0))
        let template = DateTemplate().day().month(.abbreviated).year(lenght: 2).era()
        XCTAssertEqual(template.localizedString(from: cesar, locale: enUS), "Mar 15, 44 BC")
        XCTAssertEqual(template.localizedString(from: cesar, locale: esES), "15 mar 44 a. C.")
    }

    func testMediumDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = DateTemplate().month().day().year().localizedFormat(locale: esES)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        XCTAssertEqual(formatter.string(from: futurama), "31/12/2999")
    }
}

extension Date {
    init?(day: Int, month: Int, year: Int, era: Int? = nil,
          hours: Int = 0, minutes: Int = 0, seconds: Int = 0, timeZone: TimeZone = .current) {
        let components = DateComponents(calendar: .current, timeZone: timeZone, era: era, year: year, month: month, day: day,
                                        hour: hours, minute: minutes, second: seconds)
        guard let date = components.date else {
            return nil
        }
        self = date
    }
}
