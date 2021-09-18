//
//  main.swift
//  InDepthPlayground
//
//  Created by Szymon Harabasz on 09.09.21.
//
//

import Foundation

print("--> 2.1 Or vs. and")

enum Message {
    case text(userId: String, contents: String, date: Date)
    case draft(userId: String, date: Date)
    case join(userId: String, date: Date)
    case leave(userId: String, date: Date)
    case balloon(userId: String, date: Date)
}

func logMessage(message: Message) {
    switch message {
    case let .text(userId: id, contents: contents, date: date):
        print("[\(date)] User \(id) sends message: \(contents)")
    case let .draft(userId: id, date: date):
        print("[\(date)] User \(id) is drafting a message")
    case let .join(userId: id, date: date):
        print("[\(date)] User \(id) has joined the chatroom")
    case let .leave(userId: id, date: date):
        print("[\(date)] User \(id) has left the chatroom")
    case let .balloon(userId: id, date: date):
        print("[\(date)] User \(id) is sending balloons")
    }
}

func logMessage2(message: Message) {
    if case let Message.text(_, contents: contents, _) = message {
        print("Received: \(contents)")
    }
}

let textMessage = Message.text(userId: "2", contents: "Bonjour!", date: Date())
let joinMessage = Message.join(userId: "2", date: Date())

logMessage(message: textMessage)
logMessage(message: joinMessage)
logMessage2(message: textMessage)
logMessage2(message: joinMessage)

print("--> 2.2 Enums for polymorphism")

enum DateType {
    case singleDate(Date)
    case dateRange(Range<Date>)
    case year(Int)
}

let now = Date()
let hourFromNow = Date(timeIntervalSinceNow: 3600)

let dates: [DateType] = [
    DateType.singleDate(now),
    DateType.dateRange(now..<hourFromNow),
    DateType.year(1970),
    DateType.year(2021)
]

for dateType in dates {
    switch dateType {
    case .singleDate(let date): print("Date is \(date)")
    case .dateRange(let range): print("Range is \(range)")
    case .year(let year): print("Year is \(year)")
    }
}

print("--> 2.5 A safer use if strings")
enum Currency: String { // or Character, integer, floating-point
    case euro = "eur"
    case usd // if not provided, then String is the same as name
    case gbp
}
print(Currency.euro.rawValue)
print(Currency.gbp.rawValue)

func iconName(for fileExtension: String) -> String {
    switch fileExtension {
    case "jpg": return "assetIconJpeg"
    case "bmp": return "assetIconBitmap"
    case "gif": return "assetIconGif"
    default: return "assetIconUnknown"
    }
}

enum ImageType: String {
    case jpg
    case bmp
    case gif

    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "jpg", "jped": self = .jpg
        case "bmp", "bitmap": self = .bmp
        case "gif", "gifv": self = .gif
        default: return nil
        }
    }
}
func iconName2(for fileExtension: String) -> String {
    guard let imageType = ImageType(rawValue: fileExtension) else {
        return "assetIconUnknown"
    }
    switch imageType {
    case .jpg: return "assetIconJpeg"
    case .bmp: return "assetIconBitmap"
    case .gif: return "assetIconGif"
    }
}
print(iconName(for: "JPED"))
print(iconName2(for: "JPED"))

print("--> 3,1 Computed properties")

struct Run {
    let id: String
    let startTime: Date
    var endTIme: Date?

    var elapsedTime: TimeInterval {
        return Date().timeIntervalSince(startTime)
    }

    var isFinished: Bool {
        return endTIme != nil
    }

    mutating func setFinished() {
        endTIme = Date()
    }

    init(id: String, startTime: Date) {
        self.id = id
        self.startTime = startTime
        self.endTIme = nil
    }
}

var run = Run(id: "10", startTime: Date())
print(run.elapsedTime)
print(run.elapsedTime)
print(run.isFinished)

print("--> 3.2 Lazy properties")

struct LearningPlan {
    let level: Int
    var description: String

    lazy private(set) var contents: String = {
        print("I'm taking my sweet time to calculate.")
        sleep(2)
        switch level {
        case ..<25: return "Watch an English documentary."
        case ..<50: return "Translate a newspaper article to English and transcribe one song."
        case 100...: return "Read two academic papers and translate them into your native language."
        default: return "Try to read English for 30 minutes."
        }
    }()

    init(level: Int, description: String) {
        self.level = level
        self.description = description
    }

}

var plan = LearningPlan(level: 10, description: "A special plan for today!")
print(Date())
for _ in 0..<5 {
    var _ = plan.contents
}
// private(set)
//plan.contents = "Watch Netflix"
print(Date())

print("--> 3.3 Property observers")

class Player {
    let id: String
    var name: String {
        didSet {
            print("My previous name was \(oldValue)")
            name = name.trimmingCharacters(in: .whitespaces)
        }
    }

    init(id: String, name: String) {
        defer { self.name = name }
        self.id = id
        self.name = name
    }
}

let jeff = Player(id: "1", name: "SuperJeff1      ")
print(jeff.name)
print(jeff.name.count)

jeff.name = "SuperJeff2     "
print(jeff.name)
print(jeff.name.count)

print("--> 4.1 Clean optional unwrapping and 4.6 Granular control over optionals")

struct Customer {
    let id: String
    let email: String
    let balance: Int
    let firstName: String?
    let lastName: Optional<String> // the same
    
    var displayName: String? {
        switch (firstName, lastName) {
        case let (first?, last?): return first + " " + last
        case let (first?, nil): return first
        case let (nil, last?): return last
        default: return nil
        }
    }
}

let customer = Customer(id: "30", email: "mayolover@gmail.com", balance: 4750, firstName: "Jake", lastName: "Freemason")
print(customer.firstName ?? "default")
if let firstName = customer.firstName, let _ = customer.lastName, 4500..<5000 ~= customer.balance {
    print("Customer's first name is \(firstName), they have some last name, and they can buy something.")
}
print(customer.displayName ?? "default")

switch customer.firstName {
case .some(let name): print("First name is \(name).")
    case .none: print("Customer didn't enter a first name.")
}
// the same
switch customer.firstName {
case let name?: print("First name is \(name).")
case nil: print("Customer didn't enter a first name.")
}

print("--> 4.3 Variable shadowing")

extension Customer: CustomStringConvertible {
    var description: String {
        var customDescription = "\(id), \(email)"
        if let firstName = firstName {
            customDescription += ", \(firstName)"
        }
        if let lastName = lastName {
            customDescription += " \(lastName)"
        }
        
        return customDescription
    }
}
print(customer)

print("--> 4.8 Simplifying optional enums - exercise")

enum PasteBoardContents {
    case url(url: String)
    case emailAddress(emailAddress: String)
    case other(contents: String)
}

enum pasteBoardEvent {
    case added
    case erased
    case pasted
}

func describeAction(event: pasteBoardEvent?, contents: PasteBoardContents?) -> String {
    switch (event, contents) {
    case (.added?, .url(let url)): return "User added an url to pasteboard: \(url)."
    case (.added, _): return "User added something to pasteboard."
    case (.erased, .emailAddress(_)): return "An user erased an email address from the pasteboard."
    default: return "The pasteboard is updated."
    }
}

print(describeAction(event: .added, contents: .url(url: "www.manning.com")))
print(describeAction(event: .added, contents: .emailAddress(emailAddress: "info@manning.com")))
print(describeAction(event: .erased, contents: .emailAddress(emailAddress: "info@manning.com")))
print(describeAction(event: .erased, contents: nil))
print(describeAction(event: nil, contents: .other(contents: "Swift in Depth")))

print("--> 4.10 Constraining optional Booleans - exercise")

enum AudioSetting: RawRepresentable {
    case enabled
    case disabled
    case unknown

    init(rawValue: Bool?) {
        switch rawValue {
            case true: self = .enabled
            case false: self = .disabled
            default: self = .unknown
        }
    }
    
    var rawValue: Bool? {
        switch self {
        case .enabled: return true
        case .disabled: return false
        default: return nil
        }
    }
}

let configuration = ["audioEnabled": true]
//let configuration = ["audioEnables": true]

let audioSetting = AudioSetting(rawValue: configuration["audioEnabled"])
switch audioSetting {
case .enabled: print("Turn up the jam!")
case .disabled: print("sshh")
case .unknown: print("Ask the user for the audio settings.")
}
print(audioSetting.rawValue ?? "default")

let path = "www.manning.com"
guard let url = URL(string: path) else {
    fatalError("Could not create url on \(#line) in \(#function)")
}

print("--> 5.1 Struct initializer rules - exercise")

struct Pancakes {
    enum SyrupType {
        case corn, molasses, maple
    }

    let syrupType: SyrupType
    let stackSize: Int
}

extension Pancakes {
    init(syrupType: SyrupType) {
        self.stackSize = 10
        self.syrupType = syrupType
    }
}

let pancakes = Pancakes(syrupType: .corn, stackSize: 8)
let morePancakes = Pancakes(syrupType: .maple)

print("5.2 Initializers and subclassing - exercise")

class Device {
    var serialNumber: String
    var room: String

    init(serialNumber: String, room: String) {
        print("Calling HandHeldTelevision::init")
        self.serialNumber = serialNumber
        self.room = room
    }

    convenience init() {
        self.init(serialNumber: "Unknown", room: "Unknown")
    }

    convenience init(serialNumber: String) {
        print("Calling Device::convenience init")
        self.init(serialNumber: serialNumber, room: "Unknown")
    }

    convenience init(room: String) {
        self.init(serialNumber: "Unknown", room: room)
    }
}

class Television: Device {
    enum ScreenType {
        case led, oled, lcd, unknown
    }
    enum Resolution {
        case ultraHd, fullHd, hd, sd, unknown
    }
    let resolution: Resolution
    let screenType: ScreenType

    init(resolution: Resolution, screenType: ScreenType, serialNumber: String, room: String) {
        print("Calling Television::init")
        self.resolution = resolution
        self.screenType = screenType
        super.init(serialNumber: serialNumber, room: room)
    }

    convenience override init(serialNumber: String, room: String) {
        print("Calling Television::convenience override init")
        self.init(resolution: .unknown, screenType: .unknown, serialNumber: serialNumber, room: room)
    }
}

let firstTelevision = Television(room: "Lobby")
let secondTelevision = Television(serialNumber: "abc")

print("5.3 Minimizing class initializers - exercise")

class HandHeldTelevision: Television {
    let weight: Int

    init(weight: Int, resolution: Resolution, screenType: ScreenType, serialNumber: String, room: String) {
        self.weight = weight
        super.init(resolution: resolution, screenType: screenType, serialNumber: serialNumber, room: room)
    }

    convenience override init(resolution: Resolution, screenType: ScreenType, serialNumber: String, room: String) {
        self.init(resolution: resolution, screenType: screenType, serialNumber: serialNumber, room: room)
    }
}

let handHeldTelevision = HandHeldTelevision(serialNumber: "293nr30znNdjW")

// 'required' initializers must be implemented in a subclass, which is needed for use in factory
// methods (returning 'Self') and when implementing a protocol which defines an initializer.
// On the other hand, in the latter case, initializers don't need to be 'required' if the class
// is 'final's