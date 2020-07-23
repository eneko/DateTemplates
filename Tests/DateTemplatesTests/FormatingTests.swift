import XCTest
import DateTemplates

final class FormattingTests: XCTestCase {

    func testEra() {
        XCTAssertEqual(DateTemplate().era().localizedString(from: cesar, locale: enUS), "BC")
        XCTAssertEqual(DateTemplate().era(.full).localizedString(from: cesar, locale: enUS), "Before Christ")
        XCTAssertEqual(DateTemplate().era(.narrow).localizedString(from: cesar, locale: enUS), "B")
    }

    func testQuarter() {
        XCTAssertEqual(DateTemplate()
                        .quarter().localizedString(from: futurama, locale: enUS),
                       "04")
        XCTAssertEqual(DateTemplate()
                        .quarter(.abbreviated).localizedString(from: futurama, locale: enUS),
                       "Q4")
        XCTAssertEqual(DateTemplate()
                        .quarter(.full).localizedString(from: futurama, locale: enUS),
                       "4th quarter")
    }

    // MARK: Custom Date Templates

    func testWeekdayAndTime() {
        let template = DateTemplate().dayOfWeek(.full).time()
        XCTAssertEqual(template.localizedString(from: epoch, locale: enUS, timeZone: utc), "Thursday 12:00 AM")
        XCTAssertEqual(template.localizedString(from: epoch, locale: esES, timeZone: utc), "jueves, 0:00")
        XCTAssertEqual(template.localizedString(from: epoch, locale: jaJP, timeZone: utc), "木曜日 0:00")
        XCTAssertEqual(template.localizedString(from: epoch, locale: ruRU, timeZone: utc), "четверг 00:00")
        XCTAssertEqual(template.localizedString(from: epoch, locale: arEG, timeZone: utc), "الخميس ١٢:٠٠ ص")
    }

    func testWeekdayDayMonthYear() {
        let template = DateTemplate().dayOfWeek().day().month(.abbreviated).year()
        XCTAssertEqual(template.localizedString(from: epoch, locale: enUS, timeZone: utc),
                       "Thu, Jan 1, 1970")
    }

    func testCesarsDeath() {
        let template = DateTemplate().day().month(.abbreviated).year(length: 2).era()
        XCTAssertEqual(template.localizedString(from: cesar, locale: enUS),
                       "Mar 15, 44 BC")
        XCTAssertEqual(template.localizedString(from: cesar, locale: esES),
                       "15 mar 44 a. C.")
    }

    func testShortDate() {
        let template = DateTemplate().month().day().year()
        XCTAssertEqual(template.localizedString(from: futurama, locale: enUS),
                       "12/31/2999")
        XCTAssertEqual(template.localizedString(from: futurama, locale: esES),
                       "31/12/2999")
    }

    func testShortDateWithWeekday() {
        let template = DateTemplate().month().day().year().dayOfWeek()
        XCTAssertEqual(template.localizedString(from: futurama, locale: enUS),
                       "Tue, 12/31/2999")
        XCTAssertEqual(template.localizedString(from: futurama, locale: esES),
                       "mar, 31/12/2999")
    }

    func testMediumDate() {
        let template = DateTemplate().month(.abbreviated).day().year()
        XCTAssertEqual(template.localizedString(from: futurama, locale: enUS),
                       "Dec 31, 2999")
        XCTAssertEqual(template.localizedString(from: futurama, locale: esES),
                       "31 dic 2999")
    }

    func testLongDate() {
        let template = DateTemplate().month(.full).day().year()
        XCTAssertEqual(template.localizedString(from: futurama, locale: enUS),
                       "December 31, 2999")
        XCTAssertEqual(template.localizedString(from: futurama, locale: esES),
                       "31 de diciembre de 2999")
    }

    func testFullDates() {
        let template = DateTemplate()
            .era(.full)
            .year()
            .month(.full)
            .day()
            .dayOfWeek(.full)

        XCTAssertEqual(template.localizedString(from: cesar, locale: enUS),
                       "Wednesday, March 15, 44 Before Christ")
        XCTAssertEqual(template.localizedString(from: cesar, locale: esES),
                       "miércoles, 15 de marzo de 44 antes de Cristo")

        XCTAssertEqual(template.localizedString(from: futurama, locale: enUS),
                       "Tuesday, December 31, 2999 Anno Domini")
        XCTAssertEqual(template.localizedString(from: futurama, locale: esES),
                       "martes, 31 de diciembre de 2999 después de Cristo")
    }

    // MARK: - Time

    func testTime() {
        let template = DateTemplate().hours().minutes().seconds()
        XCTAssertEqual(template.localizedString(from: futurama, locale: enUS, timeZone: utc),
                       "11:59:59 PM")
        XCTAssertEqual(template.localizedString(from: futurama, locale: esES, timeZone: utc),
                       "23:59:59")
    }

    /// Period should have no effect when used as a template (localized), if clock is in 24hr format
    func testTimeAndPeriod() {
        let template = DateTemplate().hours().period()
        XCTAssertEqual(template.localizedString(from: futurama, locale: enUS, timeZone: utc),
                       "11 PM")
        XCTAssertEqual(template.localizedString(from: futurama, locale: esES, timeZone: utc),
                       "23")
    }

    /// Period standalone, will always render
    func testPeriod() {
        let template = DateTemplate().period()
        XCTAssertEqual(template.localizedString(from: futurama, locale: enUS, timeZone: utc),
                       "PM")
        XCTAssertEqual(template.localizedString(from: futurama, locale: esES, timeZone: utc),
                       "p. m.")
    }

    func testHoursLocalized() {
        let date = Date(day: 1, month: 1, year: 2020, hours: 0, minutes: 0, seconds: 0)
        XCTAssertEqual(DateTemplate().hours().localizedString(from: date, locale: esES), "0")
        XCTAssertEqual(DateTemplate().hours(.h12).localizedString(from: date, locale: esES), "12 a. m.")
        XCTAssertEqual(DateTemplate().hours(.h24).localizedString(from: date, locale: esES), "0")
        XCTAssertEqual(DateTemplate().hours(.h1_12).localizedString(from: date, locale: esES), "12 a. m.")
        XCTAssertEqual(DateTemplate().hours(.h0_23).localizedString(from: date, locale: esES), "0")
        XCTAssertEqual(DateTemplate().hours(.h0_11).localizedString(from: date, locale: esES), "12 a. m.")
        XCTAssertEqual(DateTemplate().hours(.h1_24).localizedString(from: date, locale: esES), "0")
    }

    func testHoursNonLocalized() {
        let date = Date(day: 1, month: 1, year: 2020, hours: 0, minutes: 0, seconds: 0)
        XCTAssertEqual(DateTemplate().hours().nonLocalizedString(from: date, locale: esES), "")
        XCTAssertEqual(DateTemplate().hours(.h12).nonLocalizedString(from: date, locale: esES), "12")
        XCTAssertEqual(DateTemplate().hours(.h24).nonLocalizedString(from: date, locale: esES), "0")
        XCTAssertEqual(DateTemplate().hours(.h1_12).nonLocalizedString(from: date, locale: esES), "12")
        XCTAssertEqual(DateTemplate().hours(.h0_23).nonLocalizedString(from: date, locale: esES), "0")
        XCTAssertEqual(DateTemplate().hours(.h0_11).nonLocalizedString(from: date, locale: esES), "0")
        XCTAssertEqual(DateTemplate().hours(.h1_24).nonLocalizedString(from: date, locale: esES), "24")
    }

    func testTimeZone() {
        let timeZone = TimeZone(identifier: "America/Los_Angeles")
        let date = Date(day: 1, month: 1, year: 2020, timeZone: timeZone)
        XCTAssertEqual(DateTemplate().time().timeZone()
                        .localizedString(from: date, locale: enUS, timeZone: timeZone),
                       "12:00 AM PST")
    }

}
