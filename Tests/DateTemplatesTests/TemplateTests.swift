import XCTest
import DateTemplates

final class TemplateTests: XCTestCase {

    func testDateTime() {
        let dateTemplate = DateTemplate().year().month().day().hours().minutes()
        XCTAssertEqual(dateTemplate.template, "yMdjmm")
    }

    func testDateTimeFormat() {
        let template = DateTemplate().year().month().day().hours().minutes()
        XCTAssertEqual(template.localizedFormat(locale: enUS), "M/d/y, h:mm a")
    }

    func testDateTimeFormattedString() {
        let template = DateTemplate().year().month().day().hours().minutes()
        XCTAssertEqual(template.localizedString(from: epoch, locale: enUS, timeZone: utc), "1/1/1970, 12:00 AM")
    }

    func testHour() {
        XCTAssertEqual(DateTemplate().hours().template, "j")
        XCTAssertEqual(DateTemplate().hours(.h12).template, "h")
        XCTAssertEqual(DateTemplate().hours(.h24).template, "H")
        XCTAssertEqual(DateTemplate().hours(.h1_12).template, "h")
        XCTAssertEqual(DateTemplate().hours(.h0_23).template, "H")
        XCTAssertEqual(DateTemplate().hours(.h0_11).template, "K")
        XCTAssertEqual(DateTemplate().hours(.h1_24).template, "k")
    }

    func testHourFormat() {
        XCTAssertEqual(DateTemplate().hours().localizedFormat(locale: esES), "H")
        XCTAssertEqual(DateTemplate().hours(.h12).localizedFormat(locale: esES), "h a")
        XCTAssertEqual(DateTemplate().hours(.h24).localizedFormat(locale: esES), "H")
        XCTAssertEqual(DateTemplate().hours(.h1_12).localizedFormat(locale: esES), "h a")
        XCTAssertEqual(DateTemplate().hours(.h0_23).localizedFormat(locale: esES), "H")
        XCTAssertEqual(DateTemplate().hours(.h0_11).localizedFormat(locale: esES), "h a")
        XCTAssertEqual(DateTemplate().hours(.h1_24).localizedFormat(locale: esES), "H")
    }
}
