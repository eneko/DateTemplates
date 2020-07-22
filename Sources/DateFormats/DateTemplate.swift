import Foundation

/// Declarative date formatting templates, based on standard formatting symbols.
///
/// This type provides a means to easily create custom date formats, with proper template
/// localization, without having to manually remember or look up which letter symbols to use
/// for each date part, how many symbols to use, or if uppercase/lowercase should be used.
///
/// ## Examples
/// ```swift
/// DateTemplate().month().day().year() // "MM/dd/yyyy" in USA, "dd/MM/yyyy" in UK
/// DateTemplate().hours().minutes() // "hh:mm a" in USA, "HH:mm" in FR
/// ```
///
/// ## Form variants
/// Most template symbols can be used in different variants.
/// ```
/// month()             // equivalent to "MM"  -> 04
/// month(.abbreviated) // equivalent to "MMM" -> Apr
/// ```
///
/// ## Template symbols
/// Supported template symbols are:
/// - Era
/// - Year
/// - Quarter
/// - Month
/// - Week
/// - Day
/// - Week Day
///
/// For more information about Unicode Technical Standard #35, see:
///
///   UNICODE LOCALE DATA MARKUP LANGUAGE (LDML) PART 4: DATES
///   http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
///
public struct DateTemplate {
    public let template: String

    public init(template: String = "") {
        self.template = template
    }

    public func appending(element: String) -> DateTemplate {
        DateTemplate(template: "\(template)\(element)")
    }
}

extension DateTemplate {
    /// Template symbol form.
    /// - `.numeric`: numeric form
    /// - `.zeroPadded`: zero-padded numeric form
    /// - `.abbreviated`: localized abbreviation (Tues, Sept, PDT...)
    /// - `.fullName`: full string localized name
    /// - `.narrow`: one letter localized abbreviation (T, S, M...)
    /// - `.short`: short name (applies to week days only: Mo, Tu, We...)
    public enum Form: Int {
        case numeric = 1
        case zeroPadded
        case abbreviated
        case full
        case narrow
        case short

        func element(_ symbol: String) -> String {
            Array(repeating: symbol, count: self.rawValue).joined()
        }
    }
}

extension DateTemplate {
    /// Time format, for hours and period
    /// - `.auto`: preferred device format (12hr or 24hr), depending on user settings
    /// - `.h12`: 12-hour-cycle (1-12). Period will appear (am/pm)
    /// - `.h24`: 24-hour-cycle (0-23). Period will not appear
    /// - `.h11`: 12-hour-cycle (0-11). Period will appear (am/pm)
    /// - `.h23`: 24-hour-cycle (1-24). Period will not appear
    public enum TimeForm {
        case auto
        case h12
        case h24
        case h11
        case h23
    }
}

// MARK: - Era Symbols

extension DateTemplate {
    /// Append Era to date format template.
    /// - Parameter form: Form to be used for rendering the Era. Defaults to `.abbreviated`
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric
    ///     .zeroPadded
    ///     .abbreviated    "GGG"       AD
    ///     .full           "GGGG"      Anno Domini
    ///     .narrow         "GGGGG"     A
    ///     .short
    ///     ```
    ///     Forms `.numeric`, `.zeroPadded`, and `.short` have no effect and
    ///     do not alter the template.
    /// - Returns: Updated date format template
    public func era(_ form: Form = .abbreviated) -> DateTemplate {
        switch form {
        case .abbreviated, .full, .narrow:
            return appending(element: form.element("G"))
        case .numeric, .zeroPadded, .short:
            return self
        }
    }
}

// MARK: - Year Symbols

extension DateTemplate {
    /// Append Year to date format template.
    /// Normally the length specifies the padding, but for two letters it also specifies the maximum length.
    /// - Parameter length: number of digits to include, zero padded. (defaults to 1)
    /// - Returns: Updated date format template
    public func year(length: Int = 1) -> DateTemplate {
        appending(element: Array(repeating: "y", count: length).joined())
    }

    /// Append Year (from Week-year calendar) to date format template.
    /// Year (in "Week of Year" based calendars). Normally the length specifies the padding, but for two letters it
    /// also specifies the maximum length. This year designation is used in ISO year-week calendar as defined
    /// by ISO 8601, but can be used in non-Gregorian based calendar systems where week date processing is
    /// desired. May not always be the same value as calendar year.
    /// - Parameter length: number of digits to include, zero padded.
    /// - Returns: Updated date format template
    public func weekCalendarYear(length: Int = 1) -> DateTemplate {
        appending(element: Array(repeating: "Y", count: length).joined())
    }

    /// Append Extended Year to date format template.
    /// Extended year. This is a single number designating the year of this calendar system, encompassing all
    /// supra-year fields. For example, for the Julian calendar system, year numbers are positive, with an era
    /// of BCE or CE. An extended year value for the Julian calendar system assigns positive values to CE
    /// years and negative values to BCE years, with 1 BCE being year 0.
    /// - Parameter length: number of digits to include, zero padded.
    /// - Returns: Updated date format template
    public func extendedYear(length: Int = 1) -> DateTemplate {
        appending(element: Array(repeating: "u", count: length).joined())
    }

    /// Append Cyclic Year to date format template.
    /// - Parameter form: Form to be used for rendering the Cyclic Year. Defaults to `.abbreviated`
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric
    ///     .zeroPadded
    ///     .abbreviated    "UUU"       甲子
    ///     .full           "UUUU"      (currently also 甲子)
    ///     .narrow         "UUUUU"     (currently also 甲子)
    ///     .short
    ///     ```
    ///     Forms `.numeric`, `.zeroPadded`, and `.short` have no effect and
    ///     do not alter the template.
    /// - Returns: Updated date format template
    public func cyclicYear(_ form: Form = .abbreviated) -> DateTemplate {
        switch form {
        case .numeric, .zeroPadded, .short:
            return self
        case .abbreviated, .full, .narrow:
            return appending(element: form.element("U"))
        }
    }
}

// MARK: - Quarter Symbols

extension DateTemplate {
    /// Append Quarter to date format template.
    /// - Parameter form: Form to be used for rendering the Quarter. Defaults to `.zeroPadded`
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric        "Q"         2
    ///     .zeroPadded     "QQ"        02
    ///     .abbreviated    "QQQ"       Q2
    ///     .full           "QQQQ"      2nd quarter
    ///     .narrow
    ///     .short
    ///     ```
    ///     Forms `.narrow`, and `.short` have no effect and do not alter the template.
    /// - Returns: Updated date format template
    public func quarter(_ form: Form = .zeroPadded) -> DateTemplate {
        switch form {
        case .numeric, .zeroPadded, .abbreviated, .full:
            return appending(element: form.element("Q"))
        case .narrow, .short:
            return self
        }
    }

    /// Append stand-alone Quarter to date format template.
    /// - Parameter form: Form to be used for rendering the stand-alone Quarter. Defaults to `.zeroPadded`
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric        "q"         2
    ///     .zeroPadded     "qq"        02
    ///     .abbreviated    "qqq"       Q2
    ///     .full           "qqqq"      2nd quarter
    ///     .narrow
    ///     .short
    ///     ```
    ///     Forms `.narrow`, and `.short` have no effect and do not alter the template.
    /// - Returns: Updated date format template
    public func standAloneQuarter(_ form: Form = .zeroPadded) -> DateTemplate {
        switch form {
        case .numeric, .zeroPadded, .abbreviated, .full:
            return appending(element: form.element("q"))
        case .narrow, .short:
            return self
        }
    }
}

// MARK: - Month Symbols

extension DateTemplate {
    /// Append Month to date format template.
    /// - Parameter form: Form to be used for rendering the Month. Defaults to `.zeroPadded`
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric        "M"         9
    ///     .zeroPadded     "MM"        09
    ///     .abbreviated    "MMM"       Sept
    ///     .full           "MMMM"      September
    ///     .narrow         "MMMMM"     S
    ///     .short
    ///     ```
    ///     Form `.short` has no effect and does not alter the template.
    /// - Returns: Updated date format template
    public func month(_ form: Form = .zeroPadded) -> DateTemplate {
        switch form {
        case .numeric, .zeroPadded, .abbreviated, .full, .narrow:
            return appending(element: form.element("M"))
        case .short:
            return self
        }
    }

    /// Append stand-alone Month to date format template.
    /// - Parameter form: Form to be used for rendering the stand-alone Month. Defaults to `.zeroPadded`
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric        "L"         9
    ///     .zeroPadded     "LL"        09
    ///     .abbreviated    "LLL"       Sept
    ///     .full           "LLLL"      September
    ///     .narrow         "LLLLL"     S
    ///     .short
    ///     ```
    ///     Form `.short` has no effect and does not alter the template.
    /// - Returns: Updated date format template
    public func standAloneMonth(_ form: Form = .zeroPadded) -> DateTemplate {
        switch form {
        case .numeric, .zeroPadded, .abbreviated, .full, .narrow:
            return appending(element: form.element("L"))
        case .short:
            return self
        }
    }
}

// MARK: - Week Symbols

extension DateTemplate {
    /// Append Week of Year to date format template
    /// - Example: 3
    /// - Returns: Updated date format template
    public func weekOfYear() -> DateTemplate {
        appending(element: "w")
    }

    /// Append zero-padded Week of Year to date format template
    /// - Example: 03
    /// - Returns: Updated date format template
    public func paddedWeekOfYear() -> DateTemplate {
        appending(element: "ww")
    }

    /// Append Week of Month to date format template
    /// - Example: 3
    /// - Returns: Updated date format template
    public func weekOfMonth() -> DateTemplate {
        appending(element: "W")
    }
}

// MARK: - Day Symbols

extension DateTemplate {
    /// Append Day to date format template.
    /// - Example: 5
    /// - Returns: Updated date format template
    public func day() -> DateTemplate {
        appending(element: "d")
    }

    /// Append zero-padded Day to date format template.
    /// - Example: 05
    /// - Returns: Updated date format template
    public func paddedDay() -> DateTemplate {
        appending(element: "dd")
    }

    /// Append Day of Year to date format template.
    /// - Example: 345
    /// - Returns: Updated date format template
    public func dayOfYear() -> DateTemplate {
        appending(element: "D")
    }

    /// Append Day of Week in Month to date format template.
    /// - Example: 2
    /// - Returns: Updated date format template
    public func dayOfWeekInMonth() -> DateTemplate {
        appending(element: "F")
    }

    /// Append Julian Day to date format template.
    /// - Example: 2451334
    /// - Returns: Updated date format template
    public func julianDay(length: Int) -> DateTemplate {
        appending(element: Array(repeating: "g", count: length).joined())
    }
}

// MARK: - Week Day Symbols

extension DateTemplate {
    /// Append Day of Week to date format template.
    ///
    /// Both `.numeric` and `.zeroPadded` are localized. This means the value returned
    /// depends on the local starting day of the week (Monday...Sunday).
    ///
    /// - Parameter form: Form to be used for rendering the Day of Week. Defaults to `.abbreviated`
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric        "e"         2
    ///     .zeroPadded     "ee"        02
    ///     .abbreviated    "eee"       Tues
    ///     .full           "eeee"      Tuesday
    ///     .narrow         "eeeee"     T
    ///     .short          "eeeeee"    Tu
    ///     ```
    /// - Returns: Updated date format template
    public func dayOfWeek(_ form: Form = .abbreviated) -> DateTemplate {
        return appending(element: form.element("e"))
    }

    /// Append stand-alone Day of Week to date format template.
    ///
    /// Both `.numeric` and `.zeroPadded` are localized. This means the value returned
    /// depends on the local starting day of the week (Monday...Sunday).
    ///
    /// - Parameter form: Form to be used for rendering the stand-alone Day of Week. Defaults to `.abbreviated`
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric        "c"         2
    ///     .zeroPadded     "cc"        02
    ///     .abbreviated    "ccc"       Tues
    ///     .full           "cccc"      Tuesday
    ///     .narrow         "ccccc"     T
    ///     .short          "cccccc"    Tu
    ///     ```
    /// - Returns: Updated date format template
    public func standAloneDayOfWeek(_ form: Form = .abbreviated) -> DateTemplate {
        return appending(element: form.element("c"))
    }
}

// MARK: - Period Symbols

extension DateTemplate {
    /// Append period (am/pm) to date format template.
    /// - Example: AM, PM
    /// - Returns: Updated date format template
    func period() -> DateTemplate {
        appending(element: "a")
    }
}

// MARK: - Hour Symbols

extension DateTemplate {
    /// Append Hours to date format template.
    /// - Example: 5
    /// - Returns: Updated date format template
    public func hours(_ form: TimeForm = .auto) -> DateTemplate {
        appending(element: "j")
    }

    /// Append zero-padded Hours to date format template.
    /// - Example: 05
    /// - Returns: Updated date format template
    public func paddedHours(_ form: TimeForm = .auto) -> DateTemplate {
        appending(element: "jj")
    }

//    public func clockFormat() -> String {
//
//    }
}

// MARK: - Minute Symbols

extension DateTemplate {
    /// Append Minutes to date format template.
    /// - Example: 5
    /// - Returns: Updated date format template
    public func minutes() -> DateTemplate {
        appending(element: "mm")
    }

    /// Append non-padded Minutes to date format template.
    /// - Example: 05
    /// - Returns: Updated date format template
    public func nonPaddedMinutes() -> DateTemplate {
        appending(element: "m")
    }
}

// MARK: - Second Symbols

extension DateTemplate {
    /// Append Seconds to date format template.
    /// - Example: 5
    /// - Returns: Updated date format template
    public func seconds() -> DateTemplate {
        appending(element: "ss")
    }

    /// Append non-padded Seconds to date format template.
    /// - Example: 05
    /// - Returns: Updated date format template
    public func nonPaddedSeconds() -> DateTemplate {
        appending(element: "s")
    }
}

// MARK: - Templating helpers

//extension DateTemplate {
//    public func space() -> DateTemplate {
//        appending(element: " ")
//    }
//
//    public func literal(text: String) -> DateTemplate {
//        appending(element: "'\(text)'")
//    }
//}

// MARK: - Formatting helpers

extension DateTemplate {
    /// Localized date format for the current template and given locale
    /// - Parameter locale: Locale for format localization (defaults to current device locale)
    /// - Returns: Localized date format
    public func localizedFormat(locale: Locale = .current) -> String {
        DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale) ?? template
    }

    /// Localized date string using current template, and given date, locale and time-zone
    /// - Parameters:
    ///   - date: Date to convert to string
    ///   - locale: Locale for date localization (defaults to current device locale)
    ///   - timeZone: Time-zone for date formatting (defaults to current device time-zone)
    /// - Returns: Localized date string
    public func localizedString(from date: Date, locale: Locale = .current, timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = localizedFormat(locale: locale)
        formatter.timeZone = timeZone
        return formatter.string(from: date)
    }
}
