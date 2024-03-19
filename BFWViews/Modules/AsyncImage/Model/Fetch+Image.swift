//
//  Fetch+Image.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import UIKit

public extension Fetch {
    
    static func image(url: URL, caching: Caching) async throws -> UIImage {
        let data = try await self.data(url: url, caching: caching)
        if let image = UIImage(data: data) {
            return image
        } else {
            return try await SVGRender.image(svgData: data)
        }
    }
    
}
