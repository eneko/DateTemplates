import XCTest
import DateFormats

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
}
