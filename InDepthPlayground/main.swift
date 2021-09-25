//
//  main.swift
//  InDepthPlayground
//
//  Created by Szymon Harabasz on 09.09.21.
//
//

import Foundation
import AppKit

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
       // sleep(2)
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

extension Customer: CustomStringConvertible, CustomDebugStringConvertible {
    var debugDescription: String {
        return "Customer id: \(id)"
    }

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

print("--> 5.2 Initializers and subclassing - exercise")

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

print("--> 5.3 Minimizing class initializers - exercise")

class HandHeldTelevision: Television {
    let weight: Int

    init(weight: Int, resolution: Resolution, screenType: ScreenType, serialNumber: String, room: String) {
        self.weight = weight
        super.init(resolution: resolution, screenType: screenType, serialNumber: serialNumber, room: room)
    }

    convenience override init(resolution: Resolution, screenType: ScreenType, serialNumber: String, room: String) {
        self.init(weight: 0, resolution: resolution, screenType: screenType, serialNumber: serialNumber, room: room)
    }
}

let handHeldTelevision = HandHeldTelevision(serialNumber: "293nr30znNdjW")

// 'required' initializers must be implemented in a subclass, which is needed for use in factory
// methods (returning 'Self') and when implementing a protocol which defines an initializer.
// On the other hand, in the latter case, initializers don't need to be 'required' if the class
// is 'final's

print("--> 6.1 Errors in Swift")

enum ParseLocationError: Error {
    case invalidData
    case locationDoesNotExist
    case middleOfTheOcean
}

struct Location {
    let latitude: Double
    let longitude: Double
}

@discardableResult
func parseLocation(_ latitude: String, _ longitude: String) throws -> Location {
    guard let latitude = Double(latitude), let longitude = Double(longitude)
            else {
        throw ParseLocationError.invalidData
    }
    return Location(latitude: latitude, longitude: longitude)
}

do {
    try parseLocation("I'm not a double", "4.898431")
} catch {
    print(error)
}

print("--> 6.2 Error propagation and catching")

struct Recipe {
    let ingredients: [String]
    let steps: [String]
}

enum ParseRecipeError: Error {
    case parseError(line: Int, symbol: String)
    case noRecipeDetected
    case noIngredientsDetected
}

extension ParseRecipeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .parseError: return NSLocalizedString("The HTML file had unexpected symbols.",
                comment: "Parsing error reason unexpected symbols")
        case .noIngredientsDetected: return NSLocalizedString("No ingredients were detected.",
                comment: "Parsing error reason no ingredients")
        case .noRecipeDetected: return NSLocalizedString("No recipe was detected.",
                comment: "Parsing error reason no recipe")
        }
    }

    var failureReason: String? {
        switch self {

        case .parseError(line: let line, symbol: let symbol):
            return String(format: NSLocalizedString("Prsing data failed at line: %i and symbol %@.",
                    comment: "Parsing error line symbol"), line, symbol)
        case .noRecipeDetected:
            return NSLocalizedString("The recipe seems to be missing a recipe.",
                    comment: "Parsing error reason missing recipe")
        case .noIngredientsDetected:
            return NSLocalizedString("The recipe seems to be missing its ingredients.",
                    comment: "Parsing error reason missing ingredients")
        }
    }
    public var recoverySuggestion: String? {
        return "Please try a different recipe."
    }
}

extension ParseRecipeError: CustomNSError {
    public private(set) static var errorDomain: String = "com.recipeextractor"
    public var errorCode: Int {
        return 300
    }
    public var errorUserInfo: [String: Any] {
        return [
            NSLocalizedDescriptionKey: errorDescription ?? "",
            NSLocalizedFailureReasonErrorKey: failureReason ?? "",
            NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion ?? ""
        ]
    }
}

let nsError: NSError = ParseRecipeError.parseError(line: 3, symbol: "#") as NSError
print(nsError)

struct RecipeExtractor {
    let html: String
    func extractRecipe() throws -> Recipe {
        return try parseWebpage(html)
    }

    private func parseWebpage(_ html: String) throws -> Recipe {
        let ingredients = try parseIngredients(html)
        let steps = try parseSteps(html)
        return Recipe(ingredients: ingredients, steps: steps)
    }

    private func parseIngredients(_ html: String) throws -> [String] {
        throw ParseRecipeError.noIngredientsDetected
    }

    private func parseSteps(_ html: String) throws -> [String] {
        throw ParseRecipeError.noRecipeDetected
    }
}

struct ErrorHandler {
    static let `default` = ErrorHandler()
    let genericMessage = "Sorry! Something went wrong"

    func handleError(_ error: Error) {
        presentToUser(message: genericMessage)
    }

    func handleError(_ error: LocalizedError) {
        if let errorDescription = error.errorDescription {
            presentToUser(message: errorDescription)
        } else {
            presentToUser(message: genericMessage)
        }
    }

    func presentToUser(message: String) {
        print(message)
    }
}

let html = "<html></html>"
let recipeExtractor = RecipeExtractor(html: html)

do {
    let _ = try recipeExtractor.extractRecipe()
} catch {
    ErrorHandler.default.handleError(error)
}

print("--> 7.3 Multiple constraints - exercise")

// Hmm... we don't need to specify constraints explicitly in the new Swift?
func occurrences<T> (in arr: [T]) -> [T: Int] {
    var result = [T: Int]()
    for elem in arr {
        result[elem, default: 0] += 1
    }
    return result
}

struct Point: Hashable {
    let x: Float
    let y: Float
}
print(occurrences(in: [1, 2, 3, 4, 3, 2, 3, 4, 1, 6]))
print(occurrences(in: [
    Point(x: 1.0, y: 1.0),
    Point(x: 1.0, y: 1.0),
    Point(x: 1.0, y: 2.0)
]))

func logger<T>(of instance: T) where T: CustomStringConvertible & CustomDebugStringConvertible {
    print("Description: \(instance.description), debug description: \(instance.debugDescription)")
}

logger(of: customer)

print("--> 7.4 Creating a generic type - exercise")

class Cache<K: Hashable> {
    private var dict = [K: Any]()

    func put(key: K, value: Any) {
        dict[key] = value
    }
    func contains(key: K) -> Bool {
        return dict.keys.contains(key)
    }
    func get(key: K) -> Any? {
        return dict[key]
    }
    func evict(key: K) {
        dict.removeValue(forKey: key)
    }
    func evictAll() {
        dict.removeAll()
    }
}

print("--> 8.2 The why of associated types and 8.3 Passing protocols with associated types")

protocol Worker {
    associatedtype Input
    associatedtype Output

    @discardableResult
    func start(input: Input) -> Output
}
class MailJob: Worker {
    typealias Input = String
    typealias Output = Bool

    func start(input: String) -> Bool {
        return true
    }
}
class FileRemover: Worker {
    func start(input: URL) -> [String] {
        do {
            var results = [String]()
            let fileManager = FileManager.default
            let fileURLs = try fileManager.contentsOfDirectory(at: input,
                    includingPropertiesForKeys: nil)

            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
                results.append(fileURL.absoluteString)
            }
            return results
        } catch {
            print("Clearing directory failed.")
            return []
        }

    }
}

func runWorker<W: Worker>(worker: W, input: [W.Input]) {
    input.forEach { (value: W.Input) in
        worker.start(input: value)
    }
}

let mailJob = MailJob()
runWorker(worker: mailJob, input: ["groover@sesamestreet.com", "bigbird@sesamestreet.com"])

let fileRemover = FileRemover()
runWorker(worker: fileRemover, input: [
    URL(fileURLWithPath: "./cache", isDirectory: true),
    URL(fileURLWithPath: "./tmp", isDirectory: true)
])

final class User {
    let firstName: String
    let lastName: String
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

func runWorker<W>(worker: W, input: [W.Input])
where W: Worker, W.Input == User {
    input.forEach { (user: W.Input) in
        worker.start(input: user)
        print("Finished processing user \(user.firstName) \(user.lastName)")
    }
}

final class ImageCropper: Worker {

    let size: CGSize
    init(size: CGSize) {
        self.size = size
    }

    func start(input: NSImage) -> Bool {
        return true
    }
}

final class ImageProcessor<W: Worker>
where W.Input == NSImage, W.Output == Bool {
    let worker: W

    init(worker: W) {
        self.worker = worker
    }

    private func process() {
        let amount = 50
        var offset = 0
        var images = fetchImages(amount: amount, offset: offset)

        var failedCount = 0
        while !images.isEmpty {
            for image in images {
                if !worker.start(input: image) {
                    failedCount += 1
                }
            }
            offset += amount
            images = fetchImages(amount: amount, offset: offset)
        }
        print("\(failedCount) images failed")
    }

    private func fetchImages(amount: Int, offset: Int) -> [NSImage] {
        return [NSImage(), NSImage()]
    }
}

let cropper = ImageCropper(size: CGSize(width: 200, height: 200))
let imageProcessor: ImageProcessor<ImageCropper> = ImageProcessor(worker: cropper)

print("--> 8.2 The why of associated types - exercise")

protocol AbstractDamage {}
class Fire: AbstractDamage {}
class BluntDamage: AbstractDamage {}

protocol Enemy {
    associatedtype Damage: AbstractDamage
    func attack() -> Damage
}

class Imp: Enemy {
    typealias Damage = Fire

    func attack() -> Fire {
        return Fire()
    }
}

class Centaur: Enemy {
    typealias Damage = BluntDamage

    func attack() -> BluntDamage {
        return BluntDamage()
    }
}

print("--> 8.3 Passing protocols with asspciated types - exercise")

protocol Playable {
    associatedtype Input

    var contents: Input { get }
    func play()
}

final class Movie: Playable {
    let contents: URL

    init(contents: URL) {
        self.contents = contents
    }

    func play() {
        print("Playing video at \(contents)")
    }
}

struct AudioFile {}

final class Song: Playable {
    let contents: AudioFile

    init(contents: AudioFile) {
        self.contents = contents
    }

    func play() {
        print("Playing song")
    }
}

Movie(contents: URL(string: "mov.mp4")!).play()
Song(contents: AudioFile()).play()

final class Playlist<T: Playable> {

    private var queue: [T] = []

    func addToQueue(playable: T) {
        queue.append(playable)
    }

    func start() {
        queue.first?.play()
    }
}

let moviePlaylist = Playlist<Movie>()
moviePlaylist.addToQueue(playable: Movie(contents: URL(string: "mov1.mp4")!))
moviePlaylist.addToQueue(playable: Movie(contents: URL(string: "mov2.mp4")!))
moviePlaylist.start()

let songPlaylist = Playlist<Song>()
songPlaylist.addToQueue(playable: Song(contents: AudioFile()))
songPlaylist.addToQueue(playable: Song(contents: AudioFile()))
songPlaylist.start()

print("9.1 Iterating")

let cheeses = ["gouda", "camembert", "brie"]
var cheeseIterator = cheeses.makeIterator()
while let cheese = cheeseIterator.next() {
    print(cheese)
}

let result = [1, 2, 3].filter { (value) -> Bool in return value > 1 }
print(result)

func deleteFile(path: String) {
    print("Deleting file \(path)")
}

["file_one.txt", "fi;e_2.txt"].forEach { path in deleteFile(path: path) }
["file_one.txt", "fi;e_2.txt"].forEach(deleteFile)

["First line", "Second line", "Third line"].enumerated().forEach { (index: Int, element: String) in
    print("\(index+1): \(element)")
}

let bigRange = 0..<Int.max

let filtered = bigRange.lazy.filter { (int) -> Bool in
    return int.isMultiple(of: 2)
}

let lastThree = filtered.suffix(3)

for value in lastThree {
    print(value)
}

let text = "This is some text.\nAnother line.\nYet another line again"
let startValue = 0
let numberOfLineBreaks = text.reduce(startValue) { (accumulation: Int, char: Character) in
    if char == "\n" {
        return accumulation + 1
    } else {
        return accumulation
    }
}
print("Number of line breaks: \(numberOfLineBreaks)")

let grades = [3.2, 4.2, 2.6, 4.1]
let results = grades.reduce(into: [:]) {
    (results: inout [Character: Int], grade: Double) in
    switch grade {
    case 1..<2: results["D", default: 0] += 1
    case 2..<3: results["C", default: 0] += 1
    case 3..<4: results["B", default: 0] += 1
    case 4...: results["A", default: 0] += 1
    default: break
    }
}
print(results)

for (integer, string) in zip(0..<10, ["a", "b", "c"]) {
    print("\(integer): \(string)")
}

print("--> 9.3 Creating a generic data structure with Sequence")

struct InfiniteSequence<Element> {
    private var store: [Element]
    init(_ store: [Element]) {
        self.store = store
    }
}

extension InfiniteSequence: CustomStringConvertible {
    var description: String {
        if store.isEmpty {
            return store.description
        } else {
            let desc = store.description
            return desc.dropLast(1) + ", ...]"
        }
    }
}
print(InfiniteSequence<Int>([1,2,3]))
/*
struct InfiniteSequenceIterator<Element>: IteratorProtocol {
    var store: [Element]
    var index = 0
    mutating func next() -> Element? {
        if store.isEmpty {
            return nil
        }
        defer {
            index += 1
            if index >= store.count {
                index = 0
            }
        }
        return store[index]
    }
}

extension InfiniteSequence: Sequence {
    func makeIterator() -> InfiniteSequenceIterator<Element> {
        return InfiniteSequenceIterator(store: store)
    }
}
 or:
*/
extension InfiniteSequence: Sequence {
    func makeIterator() -> AnyIterator<Element> {
        var index = 0
        return AnyIterator<Element> {
            if store.isEmpty {
                return nil
            }
            defer {
                index += 1
                if index >= store.count {
                    index = 0
                }
            }
            return store[index]
        }
    }
}

extension InfiniteSequence: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self.init(elements)
    }

    typealias ArrayLiteralElement = Element
}

let seq: InfiniteSequence = ["a", "b", "c"]
for (first, second) in zip(0..<10, seq) {
    print("\(first): \(second)")
}

print("--> 9..4 The Collection protocol")

var arr = [1,2,3,4,5]
let index = arr.partition { (int) -> Bool in
    return int % 2 == 0
}

print(arr[..<index])
print(arr[index...])

var muppets = ["Kermit", "Miss Piggy", "Fozzie bear"]
muppets += ["Statler", "Waldorf"]

muppets.removeFirst()
print(muppets)

muppets.removeSubrange(1..<3)
print(muppets)

muppets.removeAll(where: { $0.contains("dorf") } )
print(muppets)

var letters = "abcd"
var lastIndex = letters.endIndex
while lastIndex > letters.startIndex {
    lastIndex = letters.index(before: lastIndex)
    print(letters[lastIndex])
}

for element in repeatElement("Broken record", count: 3) {
    print(element)
}

print("--> 9.5 Creating a collection")

struct Activity: Equatable {
    let date: Date
    let description: String
}

struct Day: Hashable {
    let date: Date

    init(date: Date) {
        let unitFlags: Set<Calendar.Component> = [ .day, .month, .year ]
        let components: DateComponents = Calendar.current.dateComponents(unitFlags, from: date)
        guard let convertedDate = Calendar.current.date(from: components) else {
            self.date = date
            return
        }
        self.date = convertedDate
    }
}

struct TravelPlan {
    typealias DataType = [Day: [Activity]]

    private var trips = DataType()

    init(activities: [Activity]) {
        self.trips = Dictionary(grouping:activities) { activity -> Day in
            Day(date: activity.date)
        }
    }
}

extension TravelPlan: Collection {
    typealias KeysIndex = DataType.Index
    typealias DataElement = DataType.Element
    var startIndex: KeysIndex {
        return trips.keys.startIndex
    }
    public var endIndex: KeysIndex {
        return trips.keys.endIndex
    }

    func index(after i: KeysIndex) -> KeysIndex {
        return trips.index(after: i)
    }

    subscript(index: KeysIndex) -> DataElement {
        return trips[index]
    }
}
extension TravelPlan {
    subscript(date: Date) -> [Activity] {
        return trips[Day(date: date)] ?? []
    }
    subscript(day: Day) -> [Activity] {
        return trips[day] ?? []
    }
}
extension TravelPlan: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Activity...) {
        self.init(activities: elements)
    }
}
extension TravelPlan: ExpressibleByDictionaryLiteral {
    init(dictionaryLiteral elements: (Day, [Activity])...) {
        self.trips = Dictionary(elements) { first, second in return first }
    }
}
let adrenalineTrip = Day(date: Date())
let adrenalineActivities = [
    Activity(date: Date(), description: "Bungee jumping"),
    Activity(date: Date(), description: "Driving in rush hour LA"),
    Activity(date: Date(), description: "Ski diving")
]
let travelPlan: TravelPlan = [adrenalineTrip: adrenalineActivities] // note: must be literal not variable
let defaultIterator: IndexingIterator<TravelPlan> = travelPlan.makeIterator()

struct Fruits: Collection {
    typealias Index = Int
    typealias Element = String

    let banana = "Banana"
    let apple = "Apple"
    let tomato = "Tomato"
    private(set) var startIndex = 0
    private(set) var endIndex = 3
    subscript(position: Int) -> String {
        switch position % 3 {
        case 0: return banana
        case 1: return apple
        case 2: return tomato
        default:
            return ""
        }
    }

    func index(after i: Int) -> Int {
        return i+1
    }
}

for (index, fruit) in zip(0..<10, Fruits()) {
    print("\(index): \(fruit)")
}

print("10.1 Becoming familiar with map - exercises")

func makeSubArrays<T>(_ arr: [T])  -> [[T]] {
    return arr.map { [$0] }
}
print(makeSubArrays(["a", "b", "c"]))
print(makeSubArrays([100,50,1]))

func transformRating(_ ratings: [String : Float]) -> [String: String] {
    let keysWithValues = ratings.map { (key: String, value: Float) -> (String, String) in
        var textRating: String
        switch (value) {
        case 1..<2: textRating = "Weak"
        case 2..<3: textRating = "Average"
        case 3..<4: textRating = "Good"
        case 4..<5: textRating = "Excellent"
        default: textRating = "Unknown"
        }
        return (key, textRating)
    }
    return Dictionary(uniqueKeysWithValues: keysWithValues)
}

let moviesAndRatings: [String: Float] = [
    "Home ALone 4": 1.2,
    "Who Framed Roger Rabbit?": 4.6,
    "Star Wars: The Phantom Menace": 2.2,
    "The Shawshank Redemption": 4.9
]
print(transformRating(moviesAndRatings))
print(transformRating(moviesAndRatings).map { (title, rating) -> String in
    return "\(title) (\(rating))"
})

print("--> 10.2 Mapping over sequences")

let arrLetters = ["a", "b", "c"]
print((0..<50).map { i in return arrLetters[i % arrLetters.count] })

print("--> 10.3 Mapping over optionals")

let contact =
        ["address":
        [
            "zipcode": "12345",
            "street": "broadway",
            "city": "wichita"
        ]
        ]
func capitalizedAndTrimmed(_ string: String) -> String {
    return string.trimmingCharacters(in: .whitespaces).capitalized
}

let capitalizedStreet = contact["address"].map{ $0["street"] ?? "" }.map(capitalizedAndTrimmed) ?? ""
let capitalizedCity = contact["address"].map{ $0["city"] ?? "" }.map(capitalizedAndTrimmed) ?? ""
print(capitalizedStreet)
print(capitalizedCity)

print("--> 10.6 flatMapping over collections")

func plusMinusOne(arr: [Int]) -> [Int] {
    return arr.flatMap{ [$0-1,$0+1] }
}
print(plusMinusOne(arr: [20, 30, 40]))

print((1..<50).map{ [2*$0] }.flatMap{ (arr: [Int]) -> [Int] in
    if arr[0] % 10 == 0 {
        return []
    } else {
        return arr
    }
})

let setOfVowels = Set<Character>(["e", "y", "u", "i", "o", "a"])
func removeVowels(_ string: String) -> String {
    let filteredChars = string.flatMap { (c: Character) -> String in
        if setOfVowels.contains(c) {
            return ""
        } else {
            return String(c)
        }
    }
    return String(filteredChars)
}
print(removeVowels("Mapping over optionals"))

func combinations<T>(_ arr: [T]) -> [(T, T)] {
    return arr.flatMap{ a in
        arr.map { b in
            return (a, b)
        }
    }
}
print(combinations([1,2]))
print(combinations([1,2,3]))

func duplicate<T>(_ arr: [T]) -> [T] {
    return arr.flatMap{ [$0, $0] }
}
print(duplicate([["a","b"], ["c", "d"]]))

print("--> 11.1 Why use the Result type?")

let url = URL(string: "https://itunes.apple.com/search?term=iron%20man")
callURL(with: url) {  (result: Result<Data, NetworkError>) in
    switch result {
    case .success(let data):
        let value = String(data: data, encoding: .utf8)
        print(value ?? "")
    case .failure(let error):
        print(error)
    }
}

search(term: "Iron Man") { (result: SearchResult<JSON>) in
    print(result)
}

// If not sleeping, the app finishes and the output from asynchronous calls is not printed
// sleep(1)

print("--> 12.2 Protocol inheritance vs. protocol composition - exercise")
protocol Mentos {}
protocol Coke {}

struct Mixture: Mentos & Coke {}

extension Mentos where Self: Coke {
    func explode() {
        print("Boom!!!")
    }
}

func mix<T>(concoction: T) where T: Mentos, T: Coke {
    concoction.explode()
}

mix(concoction: Mixture())

print("--> 12.4 Extending in two directions")

class Controller {}
class RestController: Controller {}

protocol MyProtocol {}

extension Controller : MyProtocol {
    func sayHello() {
        print("hi")
    }
}
extension MyProtocol where Self: Controller {
    func sayGoodbye() {
        print("bye")
    }
}
// Not as written in the book? Controller and its subclass adhere now to both protocols
let controller = RestController()
controller.sayHello()
controller.sayGoodbye()

print("--> 12.5 Extending with associated types")

extension Collection where Element: Equatable {
    func unique() -> [Element] {
        var uniqueValues = [Element]()
        for element in self {
            if !uniqueValues.contains(element) {
                uniqueValues.append(element)
            }
        }
        return uniqueValues
    }
}
extension Collection where Element: Hashable {
    func unique() -> [Element] {
        var set = Set<Element>()
        var uniqueValues = [Element]()
        for element in self {
            if !set.contains(element) {
                uniqueValues.append(element)
                set.insert(element)
            }
        }
        return uniqueValues
    }
}
extension Set {
    func unique() -> [Element] {
        return Array(self)
    }
}
print(String("Extending with associated types".unique()))

print("--> 12.7 Extending Sequence - exercise")
extension Sequence {
    func scan<T>(initialResult: T, f: (T, Element) -> T) -> [T] {
        var output = [T]()
        var last = initialResult
        for element in self {
            let new = f(last, element)
            last = new
            output.append(new)
        }
        return output
    }
}
let strings = (0..<5).scan(initialResult: "") { (result: String, int: Int) -> String in
    return "\(result)\(int)"
}
print(strings)
let lowercased = ["S", "W", "I", "F", "T"].scan(initialResult: "") { (result: String, string: String) -> String in
    return "\(result)\(string.lowercased())"
}
print(lowercased)