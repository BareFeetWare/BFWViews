//
//  ImageSymbol.swift
//
//  Created by Tom Brodhurst-Hill on 5/2/20.
//  Copyright © 2020 BareFeetWare. All rights reserved.
//

public struct ImageSymbol {
    public let name: String
    
    public init(_ name: String) {
        self.name = name
    }
}

public extension ImageSymbol {
    static let arrowDown: Self = .init("arrow.down")
    static let arrowLeft: Self = .init("arrow.left")
    static let arrowRight: Self = .init("arrow.right")
    static let arrowUp: Self = .init("arrow.up")
    static let arrowUpLeftAndArrowDownRight: Self = .init("arrow.up.left.and.arrow.down.right")
    static let arrowtriangleDown: Self = .init("arrowtriangle.down")
    static let battery0: Self = .init("battery.0")
    static let battery25: Self = .init("battery.25")
    static let battery100: Self = .init("battery.100")
    static let bell: Self = .init("bell")
    static let bolt: Self = .init("bolt")
    static let boltHeart: Self = .init("bolt.heart")
    static let building: Self = .init("building")
    static let building2: Self = .init("building.2")
    static let calendarBadgeClock: Self = .init("calendar.badge.clock")
    static let camera: Self = .init("camera")
    static let chartBar: Self = .init("chart.bar")
    static let checkmark: Self = .init("checkmark")
    static let checkmarkDiamond: Self = .init("checkmark.diamond")
    static let checkmarkShield: Self = .init("checkmark.shield")
    static let chevronDown: Self = .init("chevron.down")
    static let chevronLeft: Self = .init("chevron.left")
    static let chevronRight: Self = .init("chevron.right")
    static let chevronUp: Self = .init("chevron.up")
    static let circle: Self = .init("circle")
    static let circleBottomthirdSplit: Self = .init("circle.bottomthird.split")
    static let clock: Self = .init("clock")
    static let docRichText: Self = .init("doc.richtext")
    static let docText: Self = .init("doc.text")
    static let docTextMagnifyingglass: Self = .init("doc.text.magnifyingglass")
    static let dollarSign: Self = .init("dollarsign")
    static let dot: Self = .init("dot")
    static let drop: Self = .init("drop")
    static let ellipsis: Self = .init("ellipsis")
    static let envelope: Self = .init("envelope")
    static let equal: Self = .init("equal")
    static let exclamationmark: Self = .init("exclamationmark")
    static let exclamationmarkTriangle: Self = .init("exclamationmark.triangle")
    static let eye: Self = .init("eye")
    static let eyeSlash: Self = .init("eye.slash")
    static let filemenuAndSelection: Self = .init("filemenu.and.selection")
    static let gauge: Self = .init("gauge")
    static let gear: Self = .init("gear")
    static let goforward: Self = .init("goforward")
    static let globe: Self = .init("globe")
    static let hammer: Self = .init("hammer")
    static let handPointUp: Self = .init("hand.point.up")
    static let handThumbsup: Self = .init("hand.thumbsup")
    static let heart: Self = .init("heart")
    static let home: Self = .init("home")
    static let house: Self = .init("house")
    static let hifispeaker: Self = .init("hifispeaker")
    static let info: Self = .init("info")
    static let leafArrowCirclePath: Self = .init("leaf.arrow.circlepath")
    static let listBulletRectangle: Self = .init("list.bullet.rectangle")
    static let lightbulb: Self = .init("lightbulb")
    static let lock: Self = .init("lock")
    static let magnifyingglass: Self = .init("magnifyingglass")
    static let map: Self = .init("map")
    static let message: Self = .init("message")
    static let moon: Self = .init("moon")
    static let network: Self = .init("network")
    static let paperclip: Self = .init("paperclip")
    static let pause: Self = .init("pause")
    static let pencil: Self = .init("pencil")
    static let person: Self = .init("person")
    static let personCrop: Self = .init("person.crop")
    static let personCropCircleBadgeQuestionmark: Self = .init("person.crop.circle.badge.questionmark")
    static let person2: Self = .init("person.2")
    static let phone: Self = .init("phone")
    static let photo: Self = .init("photo")
    static let pin: Self = .init("pin")
    static let plus: Self = .init("plus")
    static let rectangleGrid2x2: Self = .init("rectangle.grid.2x2")
    static let rectangleGrid3x2: Self = .init("rectangle.grid.3x2")
    static let ruler: Self = .init("ruler")
    static let share: Self = .init("square.and.arrow.up")
    static let star: Self = .init("star")
    static let sunMax: Self = .init("sun.max")
    static let sunMin: Self = .init("sun.min")
    static let square: Self = .init("square")
    static let squareAndPencil: Self = .init("square.and.pencil")
    static let tag: Self = .init("tag")
    static let trash: Self = .init("trash")
    static let water: Self = .init("water")
    static let waveformPathEcg: Self = .init("waveform.path.ecg")
    static let windSnow: Self = .init("wind.snow")
    static let wifi: Self = .init("wifi")
    static let wrench: Self = .init("wrench")
    static let x: Self = .init("x")
    static let xmark: Self = .init("xmark")
}
