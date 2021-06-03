//
//  ImageSymbol.swift
//
//  Created by Tom Brodhurst-Hill on 5/2/20.
//  Copyright © 2020 BareFeetWare. All rights reserved.
//

// TODO: Make extendable, such as by changing from enum to struct.

public enum ImageSymbol: String {
    case arrowUp = "arrow.up"
    case arrowUpCircleFill = "arrow.up.circle.fill"
    case arrowUpLeftAndArrowDownRight = "arrow.up.left.and.arrow.down.right"
    case arrowtriangleDownSquare = "arrowtriangle.down.square"
    case arrowDownCircleFill = "arrow.down.circle.fill"
    case battery0 = "battery.0"
    case battery25 = "battery.25"
    case battery100 = "battery.100"
    case bell
    case bolt
    case boltFill = "bolt.fill"
    case boltHeart = "bolt.heart"
    case boltHeartFill = "bolt.heart.fill"
    case building
    case building2 = "building.2"
    case calendarBadgeClock = "calendar.badge.clock"
    case camera
    case chartBarFill = "chart.bar.fill"
    case checkmark = "checkmark"
    case checkmarkCircle = "checkmark.circle"
    case checkmarkCircleFill = "checkmark.circle.fill"
    case checkmarkSquareFill = "checkmark.square.fill"
    case checkmarkShield = "checkmark.shield"
    case chevronDown = "chevron.down"
    case chevronLeft = "chevron.left"
    case chevronRight = "chevron.right"
    case chevronUp = "chevron.up"
    case circle = "circle"
    case circleBottomthirdSplit = "circle.bottomthird.split"
    case circleFill = "circle.fill"
    case clock
    case docRichText = "doc.richtext"
    case docText = "doc.text"
    case docTextFill = "doc.text.fill"
    case docTextMagnifyingglass = "doc.text.magnifyingglass"
    case dollarSignCircle = "dollarsign.circle"
    case dollarSignCircleFill = "dollarsign.circle.fill"
    case dollarSignSquare = "dollarsign.square"
    case dotSquare = "dot.square"
    case ellipsis
    case envelopeFill = "envelope.fill"
    case equal
    case exclamationmark
    case exclamationmarkCircleFill = "exclamationmark.circle.fill"
    case exclamationmarkTriangle = "exclamationmark.triangle"
    case exclamationmarkTriangleFill = "exclamationmark.triangle.fill"
    case eye
    case eyeSlash = "eye.slash"
    case filemenuAndSelection = "filemenu.and.selection"
    case gauge
    case gear
    case goforward = "goforward"
    case globe
    case handThumbsup = "hand.thumbsup"
    case handThumbsupFill = "hand.thumbsup.fill"
    case heart
    case home
    case house
    case houseFill = "house.fill"
    case hifispeaker
    case infoCircle = "info.circle"
    case infoCircleFill = "info.circle.fill"
    case leafArrowCirclePath = "leaf.arrow.circlepath"
    case listBulletRectangle = "list.bullet.rectangle"
    case lightbulb
    case lightbulbFill = "lightbulb.fill"
    case lockFill = "lock.fill"
    case magnifyingglass
    case message
    case messageFill = "message.fill"
    case moonFill = "moon.fill"
    case pauseCircleFill = "pause.circle.fill"
    case pauseFill = "pause.fill"
    case pencilCircleFill = "pencil.circle.fill"
    case person
    case personCropRectangleFill = "person.crop.rectangle.fill"
    case personCropCircleBadgeQuestionmark = "person.crop.circle.badge.questionmark"
    case personFill = "person.fill"
    case person2Fill = "person.2.fill"
    case personCircle = "person.circle"
    case phoneFill = "phone.fill"
    case photo
    case plus
    case rectangleGrid2x2Fill = "rectangle.grid.2x2.fill"
    case rectangleGrid3x2 = "rectangle.grid.3x2"
    case share = "square.and.arrow.up"
    case star
    case starFill = "star.fill"
    case starCircle = "star.circle"
    case startCircleFill = "star.circle.fill"
    case sunMax = "sun.max"
    case sunMaxFill = "sun.max.fill"
    case sunMinFill = "sun.min.fill"
    case square
    case tag
    case trashCircleFill = "trash.circle.fill"
    case water
    case waveformPathEcg = "waveform.path.ecg"
    case windSnow = "wind.snow"
    case wifi
    case wrench
    case xCircleFill = "x.circle.fill"
    case xmark
}

extension ImageSymbol {
    var name: String { rawValue }
}
