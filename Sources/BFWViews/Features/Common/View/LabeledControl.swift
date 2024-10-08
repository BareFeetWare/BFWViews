//
//  LabeledControl.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 7/8/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct LabeledControl<Label: View, Control: View>: View {
    
    public init(
        label: @escaping () -> Label,
        control: @escaping () -> Control
    ) {
        self.label = label
        self.control = control
    }
    
    // TODO: Add convenience into with title: String?
    
    let label: () -> Label
    let control: () -> Control
    
    public var body: some View {
        if #available(iOS 16.0, *) {
            ViewThatFits {
                hStack
                vStack
            }
        } else {
            // TODO: Alternative narrow layout for iOS 15.
            hStack
        }
    }
    
    var hStack: some View {
        HStack {
            label()
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            control()
                .multilineTextAlignment(.trailing)
        }
    }
    
    var vStack: some View {
        VStack(alignment: .leading) {
            label()
                .fixedSize(horizontal: false, vertical: true)
            control()
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

}

struct LabeledControl_Previews: PreviewProvider {
    static var previews: some View {
        LabeledControl {
            Text("Title with lots of words")
        } control: {
            Text("Trailing Control")
        }
    }
}
