import Foundation

/// Declarative date formatting templates, based on standard formatting symbols.
///
/// This type provides a means to easily create custom date formats, with proper template
/// localization, without having to manually remember or look up which letter symbols to use
/// for each date part, how many symbols to use, or if uppercase/lowercase should be used.
///
/// Examples:
/// ```swift
/// DateTemplate().month().day().year() // "MM/dd/yyyy" in USA, "dd/MM/yyyy" in UK
/// DateTemplate().hours().minutes() // "hh:mm a" in USA, "HH:mm" in FR
/// ```
///
/// - See: http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
public struct DateTemplate {
    public let template: String

    public init(template: String = "") {
        self.template = template
    }

    public func appending(symbol: String) -> DateTemplate {
        DateTemplate(template: "\(template)\(symbol)")
    }
}

extension DateTemplate {
    /// Template symbol form.
    /// - `numeric`: numeric form
    /// - `zeroPadded`: zero-padded numeric form
    /// - `narrow`: one letter localized abbreviation
    /// - `abbreviated`: short localized abbreviation (2-3 letters)
    /// - `fullName`: full string localized name
    public enum Form {
        case numeric
        case zeroPadded
        case narrow
        case abbreviated
        case full
    }
}

// MARK: - Era Symbols

extension DateTemplate {
    /// Append Era to date format template.
    /// - Parameter form: form to be used for rendering the Era
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric
    ///     .zeroPadded
    ///     .abbreviated    "G"         AD
    ///     .full           "GGGG"      Anno Domini
    ///     .narrow         "GGGGG"     A
    ///     ```
    /// - Returns: Updated date format template
    public func era(_ form: Form = .abbreviated) -> DateTemplate {
        switch form {
        case .numeric, .zeroPadded:
            return self
        case .abbreviated:
            return appending(symbol: "G")
        case .full:
            return appending(symbol: "GGGG")
        case .narrow:
            return appending(symbol: "GGGGG")
        }
    }
}

// MARK: - Year Symbols

extension DateTemplate {
    /// Append Year to date format template.
    /// Normally the length specifies the padding, but for two letters it also specifies the maximum length.
    /// - Parameter lenght: number of digits to include, zero padded.
    /// - Returns: Updated date format template
    public func year(lenght: Int = 4) -> DateTemplate {
        appending(symbol: Array(repeating: "y", count: lenght).joined())
    }

    /// Append Year (from Week-year calendar) to date format template.
    /// Year (in "Week of Year" based calendars). Normally the length specifies the padding, but for two letters it
    /// also specifies the maximum length. This year designation is used in ISO year-week calendar as defined
    /// by ISO 8601, but can be used in non-Gregorian based calendar systems where week date processing is
    /// desired. May not always be the same value as calendar year.
    /// - Parameter lenght: number of digits to include, zero padded.
    /// - Returns: Updated date format template
    public func weekYear(lenght: Int = 4) -> DateTemplate {
        appending(symbol: Array(repeating: "Y", count: lenght).joined())
    }

    /// Append Extended Year to date format template.
    /// Extended year. This is a single number designating the year of this calendar system, encompassing all
    /// supra-year fields. For example, for the Julian calendar system, year numbers are positive, with an era
    /// of BCE or CE. An extended year value for the Julian calendar system assigns positive values to CE
    /// years and negative values to BCE years, with 1 BCE being year 0.
    /// - Parameter lenght: number of digits to include, zero padded.
    /// - Returns: Updated date format template
    public func extendedYear(lenght: Int = 4) -> DateTemplate {
        appending(symbol: Array(repeating: "u", count: lenght).joined())
    }

    /// Append Cyclic Year to date format template.
    /// - Parameter form: form to be used for rendering the month
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric
    ///     .zeroPadded
    ///     .abbreviated    "U"         甲子
    ///     .full           "UUUU"      (currently also 甲子)
    ///     .narrow         "UUUUU"     (currently also 甲子)
    ///     ```
    /// - Returns: Updated date format template
    public func cyclicYear(_ form: Form = .abbreviated) -> DateTemplate {
        switch form {
        case .numeric, .zeroPadded:
            return self
        case .abbreviated:
            return appending(symbol: "U")
        case .full:
            return appending(symbol: "UUUU")
        case .narrow:
            return appending(symbol: "UUUUU")
        }
    }
}

// MARK: - Quarter Symbols

extension DateTemplate {
    /// Append Quarter to date format template.
    /// - Parameter form: form to be used for rendering the Quarter
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric        "Q"         2
    ///     .zeroPadded     "QQ"        02
    ///     .abbreviated    "QQQ"       Q2
    ///     .full           "QQQQ"      2nd quarter
    ///     .narrow
    ///     ```
    /// - Returns: Updated date format template
    public func quarter(_ form: Form = .zeroPadded) -> DateTemplate {
        switch form {
        case .numeric:
            return appending(symbol: "Q")
        case .zeroPadded:
            return appending(symbol: "QQ")
        case .abbreviated:
            return appending(symbol: "QQQ")
        case .full:
            return appending(symbol: "QQQQ")
        case .narrow:
            return self
        }
    }

    /// Append stand-alone Quarter to date format template.
    /// - Parameter form: form to be used for rendering the stand-alone Quarter
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric        "q"         2
    ///     .zeroPadded     "qq"        02
    ///     .abbreviated    "qqq"       Q2
    ///     .full           "qqqq"      2nd quarter
    ///     .narrow
    ///     ```
    /// - Returns: Updated date format template
    public func standAloneQuarter(_ form: Form = .zeroPadded) -> DateTemplate {
        switch form {
        case .numeric:
            return appending(symbol: "q")
        case .zeroPadded:
            return appending(symbol: "qq")
        case .abbreviated:
            return appending(symbol: "qqq")
        case .full:
            return appending(symbol: "qqqq")
        case .narrow:
            return self
        }
    }
}

// MARK: - Month Symbols

extension DateTemplate {
    /// Append Month to date format template.
    /// - Parameter form: form to be used for rendering the Month
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric        "M"         9
    ///     .zeroPadded     "MM"        09
    ///     .abbreviated    "MMM"       Sept
    ///     .full           "MMMM"      September
    ///     .narrow         "MMMMM"     S
    ///     ```
    /// - Returns: Updated date format template
    public func month(_ form: Form = .zeroPadded) -> DateTemplate {
        switch form {
        case .numeric:
            return appending(symbol: "M")
        case .zeroPadded:
            return appending(symbol: "MM")
        case .abbreviated:
            return appending(symbol: "MMM")
        case .full:
            return appending(symbol: "MMMM")
        case .narrow:
            return appending(symbol: "MMMMM")
        }
    }

    /// Append stand-alone Month to date format template.
    /// - Parameter form: form to be used for rendering the stand-alone Month
    ///     ```
    ///     // Form         Template    Example
    ///     .numeric        "L"         9
    ///     .zeroPadded     "LL"        09
    ///     .abbreviated    "LLL"       Sept
    ///     .full           "LLLL"      September
    ///     .narrow         "LLLLL"     S
    ///     ```
    /// - Returns: Updated date format template
    public func standAloneMonth(_ form: Form = .zeroPadded) -> DateTemplate {
        switch form {
        case .numeric:
            return appending(symbol: "L")
        case .zeroPadded:
            return appending(symbol: "LL")
        case .abbreviated:
            return appending(symbol: "LLL")
        case .full:
            return appending(symbol: "LLLL")
        case .narrow:
            return appending(symbol: "LLLLL")
        }
    }
}

// MARK: - Week Symbols

extension DateTemplate {
    /// Append Week of Year to date format template
    /// - Example: 3
    /// - Returns: Updated date format template
    public func weekOfYear() -> DateTemplate {
        appending(symbol: "w")
    }

    /// Append zero-padded Week of Year to date format template
    /// - Example: 03
    /// - Returns: Updated date format template
    public func paddedWeekOfYear() -> DateTemplate {
        appending(symbol: "ww")
    }

    /// Append Week of Month to date format template
    /// - Example: 3
    /// - Returns: Updated date format template
    public func weekOfMonth() -> DateTemplate {
        appending(symbol: "W")
    }
}

// MARK: - Day Symbols

extension DateTemplate {
    /// Append Day to date format template.
    /// - Example: 5
    /// - Returns: Updated date format template
    public func day() -> DateTemplate {
        appending(symbol: "d")
    }

    /// Append zero-padded Day to date format template.
    /// - Example: 05
    /// - Returns: Updated date format template
    public func paddedDay() -> DateTemplate {
        appending(symbol: "dd")
    }

    /// Append Day of Year to date format template.
    /// - Example: 345
    /// - Returns: Updated date format template
    public func dayOfYear() -> DateTemplate {
        appending(symbol: "D")
    }

    /// Append Day of Week in Month to date format template.
    /// - Example: 2
    /// - Returns: Updated date format template
    public func dayOfWeekInMonth() -> DateTemplate {
        appending(symbol: "F")
    }
}

// MARK: - Formatting helpers (syntax sugar)

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
