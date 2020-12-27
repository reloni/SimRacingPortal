import Vapor

protocol ViewContext: Content {
    var title: String { get }
}

