# BFWViews
A framework to simplify building apps using SwiftUI.

BFWViews contains many features to simplify building apps visually, especially when using SwiftUI. Features include:

- AsyncNavigationLink acts like NavigationLink, but takes an async destination. It shows a ProgressView while fetching the content for the next scene.
- AsyncImage acts like SwiftUI's AsyncImage, but also works with SVG content from a URL source.
- Alert(error) shows a modal Alert dialog with error description. 
- ObservingWrapper provides an on the fly struct wrapper for a view to observe changes in an observed object.
- readFrame() reads the coordinate frame of a view.
- Plan.List for constructing nested array of sections and cells.
- Plan.Section provides isExpanded to pre iOS 17.
- ImageSymbol maps SF Symbols to compile time instances.
