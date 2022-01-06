//
//  CellBorder.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 5/12/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    
    func cellBorder(color: Color, lineWidth: CGFloat = 1) -> some View {
        uiTableViewCell { cell in
            cell.addBorder(color: UIColor(color), lineWidth: lineWidth)
        }
    }
    
    // Must be a separate function. Trying to combine them with an isFake parameter causes crashes and weird cell recycling.
    
    // Same visual as cellBorder, but for use when not in a UITableView and if single row in a section.
    func fakeCellBorder(color: Color, lineWidth: CGFloat = 1) -> some View {
        self
            .padding(round(8 + lineWidth / 2))
            .padding(.horizontal, 4)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(color, lineWidth: lineWidth / 2)
            )
    }
    
}

private extension UIView {
    func addBorder(color: UIColor, lineWidth: CGFloat) {
        let borderView: BorderView
        if let subview = subviews.first(where: { $0 is BorderView }) as? BorderView {
            borderView = subview
        } else {
            borderView = BorderView(frame: bounds, color: color, lineWidth: lineWidth)
            addSubview(borderView)
            borderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
}

private class BorderView: UIView {
    
    let color: UIColor
    let lineWidth: CGFloat
    
    init(frame: CGRect, color: UIColor, lineWidth: CGFloat = 1) {
        self.lineWidth = lineWidth
        self.color = color
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBorderLayer() {
        guard let superview = superview else { return }
        let maskedCorners = superview.layer.maskedCorners
        let cornerRadius = superview.layer.cornerRadius
        let borderLayerName = "border"
        let borderLayer: CAShapeLayer
        if let layer = layer.sublayers?.first(where: { $0.name == borderLayerName }) as? CAShapeLayer {
            borderLayer = layer
        } else {
            borderLayer = CAShapeLayer()
            borderLayer.name = borderLayerName
            layer.addSublayer(borderLayer)
        }
        borderLayer.path = UIBezierPath(
            roundedRect: bounds.inset(
                by: UIEdgeInsets(
                    top: maskedCorners.contains(.layerMinXMinYCorner) ? 0 : -lineWidth,
                    left: 0,
                    bottom: maskedCorners.contains(.layerMinXMaxYCorner) ? 0 : -lineWidth,
                    right: 0
                )
            ),
            byRoundingCorners: maskedCorners.rectCorner,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        ).cgPath
        borderLayer.strokeColor = color.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = lineWidth
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBorderLayer()
    }
    
}

private extension CACornerMask {
    var rectCorner: UIRectCorner {
        switch self {
        case [.layerMinXMinYCorner, .layerMaxXMinYCorner]: return [.topLeft, .topRight]
        case [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]: return [.bottomLeft, .bottomRight]
        case [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]: return .allCorners
        default: return []
        }
    }
}


struct CellBorder_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases) { colorSceheme in
            Group {
                List {
                    Section(
                        header: Text("cellBorder")
                            .textCase(.none)
                    ) {
                        Text("Alone")
                    }
                    .cellBorder(color: .orange, lineWidth: 8)
                    Section {
                        Text("Top")
                        Text("Middle")
                        Text("Bottom")
                    }
                    .cellBorder(color: .purple, lineWidth: 2)
                }
                ScrollView {
                    VStack(alignment: .leading) {
                        Section(
                            header: Text("fakeCellBorder")
                                .textCase(.none)
                        ) {
                            Text("Alone")
                                .distributed(.leading)
                                .fakeCellBorder(color: .orange, lineWidth: 8)
                        }
                    }
                    .padding()
                }
                .background(
                    Color(colorSceheme == .light ? .tertiarySystemGroupedBackground : .systemBackground)
                        .ignoresSafeArea()
                )
            }
            .colorScheme(colorSceheme)
        }
    }
}
