# DateTemplates

DateTemplates is a library that provides a simple way to generate date formatting templates
that can be used to format dates in all Apple platforms and Linux. With a declarative Swift 
syntax that's easy to read and natural to write, `DateTemplate` works seamesly with
`DateFormatter`. Automatic support for localization makes it easier than ever to work with
custom date formats.


## Declarative Syntax

DateTemplates uses a declarative syntax so you can simply state which elements should
be included in the formatted date string. For example, you can write that you want a date
consisting of full week day, and time, without having to worry about template symbols, 
localization discrepancies, or clock-format.

```swift
let template = DateTemplate().dayOfWeek(.full).time()
print(template.localizedString(from: Date()))
```

This template will render dates as follows:

| Locale | Formatted String |
| -------- | ------------------- | 
| "en_US" | "Thursday 12:00 AM" |
| "es_ES" | "jueves, 0:00" |
| "ja_JP" | "木曜日 0:00" |
| "ru_RU" | "четверг 00:00" |
| "ar_EG" | "الخميس ١٢:٠٠ ص" | 

### Examples

The following examples assume "America/Los_Angeles" time-zone and "en_US" locale:

| Template | Formatted String |
| ---------- | --------------------| 
| `DateTemplate().time().timeZone()` | "12:00 AM PST" |
| `DateTemplate().dayOfWeek().day().month(.abbreviated).year()` | "Thu, Jan 1, 1970" |
| `DateTemplate().day().month(.abbreviated).year(length: 2).era()` | "Mar 15, 44 BC" |


## Under the Hood

A `DateTemplate` instance provides a declarative way to composing date formatting template 
strings. These are regular, standard templates that can be used with `DateFormatter`.

```swift
let dateTemplate = DateTemplate().year().month().day().hours().minutes()
print(dateTemplate.template) // "yMdjmm"
```

These template strings can be used to generate a localized date format:

```swift
let template = DateTemplate().year().month().day().hours().minutes().template
let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: nil) ?? template
print(format) // "M/d/y, h:mm a" (assuming en_US locale)
```

For convenience, `DateTemplate` provides a `localizedFormat` method:

```swift
let template = DateTemplate().year().month().day().hours().minutes()
let format = template.localizedFormat()
print(format) // "M/d/y, h:mm a" (assuming en_US locale)
```

Localized format strings can be used with `DateFormatter` to convert dates to strings (and viceversa):

```swift
let formatter = DateFormatter()
formatter.locale = Locale(identifier: "en_US")
formatter.dateFormat = format // "M/d/y, h:mm a" 
formatter.timeZone = TimeZone(secondsFromGMT: 0)
let string = formatter.string(from: Date(timeIntervalSince1970: 0))
print(string) // "1/1/1970, 12:00 AM"
```

For convenience, `DateTemplate` provides a `localizedString` method:

```swift
let template = DateTemplate().year().month().day().hours().minutes()
let string = template.localizedString(from: Date(timeIntervalSince1970: 0),
                                      locale: Locale("en_US"), 
                                      timeZone: TimeZone(secondsFromGMT: 0))
print(string) // "1/1/1970, 12:00 AM"
```


## Benefits of Using DateTemplates

These are some benefits:
- Easily composition of custom localized formats: specify which 
    elements to include, and don't worry about the rest. 
- Bug prevention:
  - Ever heard of the [difference between "YYYY" and "yyyy"](https://stackoverflow.com/questions/15133549/difference-between-yyyy-and-yyyy-in-nsdateformatter)?
  - How about the difference between "MM" and "mm"?
  - 12hr vs. 24 hr clock
  - etc.
- Not reinventing the wheel. Based on [Unicode Locale Data Markup Language standard for dates](http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns).
- 100% compatible with `DateFormatter`.


## Installation

### For Xcode projects 🛠
Add Swift Package to Xcode via `File -> Swift Packages -> Add Package Dependency...`


### For Swift Packages 📦
Add DateTemplates dependency to `Packages.swift`

```swift
dependencies: [
    // other dependencies
    .package(url: "https://github.com/eneko/DateTemplates", from: "0.1.0")
],
targets: [
    .target(name: "YourPackage", dependencies: [
        // other dependencies
        "DateTemplates"
    ]),
    // other targets
]
```

## License

MIT License

Copyright (c) 2020 Eneko Alonso
