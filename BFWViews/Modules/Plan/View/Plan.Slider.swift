//
//  Plan.Slider.swift
//  BFWViews
//
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    /// View-model slider. Renders as a `DetailRow` (title + optional trailing
    /// value text) above a SwiftUI `Slider`, suitable for a Form row. The
    /// trailing string is supplied by the caller per render, so it can reflect
    /// the live bound value — e.g. `trailing: "\(percent)%"`.
    public struct Slider {
        public let detailRow: Plan.DetailRow
        @Binding public var value: Double
        public let bounds: ClosedRange<Double>
        public let step: Double
    }
}

// MARK: - Convenience Inits

public extension Plan.Slider {
    
    init(
        _ detailRow: Plan.DetailRow,
        value: Binding<Double>,
        in bounds: ClosedRange<Double>,
        step: Double = 1
    ) {
        self.detailRow = detailRow
        self._value = value
        self.bounds = bounds
        self.step = step
    }
    
    init(
        _ title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        value: Binding<Double>,
        in bounds: ClosedRange<Double>,
        step: Double = 1
    ) {
        self.init(
            Plan.DetailRow(title, subtitle: subtitle, trailing: trailing),
            value: value,
            in: bounds,
            step: step
        )
    }
    
    /// Convenience for an `Int`-valued slider. Bridges to the `Double` storage
    /// so the SwiftUI slider snaps cleanly to integer steps.
    init(
        _ title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        value: Binding<Int>,
        in bounds: ClosedRange<Int>,
        step: Int = 1
    ) {
        self.init(
            Plan.DetailRow(title, subtitle: subtitle, trailing: trailing),
            value: Binding(
                get: { Double(value.wrappedValue) },
                set: { value.wrappedValue = Int($0) }
            ),
            in: Double(bounds.lowerBound) ... Double(bounds.upperBound),
            step: Double(step)
        )
    }
    
}

// MARK: - Views

extension Plan.Slider: View {
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            detailRow
            SwiftUI.Slider(value: $value, in: bounds, step: step)
        }
    }
}

// MARK: - Previews

private struct Plan_Slider_Previews: PreviewProvider {
    
    static var previews: some View {
        DoublePreview()
            .previewDisplayName("Double")
        IntPreview()
            .previewDisplayName("Int")
    }
    
    struct DoublePreview: View {
        @State var value: Double = 0.4
        
        var body: some View {
            Form {
                Plan.Slider(
                    "Volume",
                    trailing: String(format: "%.0f%%", value * 100),
                    value: $value,
                    in: 0 ... 1,
                    step: 0.05
                )
            }
        }
    }
    
    struct IntPreview: View {
        @State var percent: Int = 20
        
        var body: some View {
            Form {
                Plan.Slider(
                    "Reserve",
                    trailing: "\(percent)%",
                    value: $percent,
                    in: 0 ... 100,
                    step: 5
                )
            }
        }
    }
}
