# ``BFWViewsFetch``

Bridges BFWFetch and BFWViews, conforming `JSON` to `Plan.Node` so JSON data can be displayed as Plan rows.

## Overview

BFWViewsFetch is an optional framework that connects BFWFetch's ``JSON`` type to BFWViews' ``Plan/Node`` protocol. Import it in projects that use both BFWFetch and BFWViews and want to build navigable row hierarchies from arbitrary JSON responses.

BFWViews and BFWFetch remain independent of each other. This framework owns the conformance, avoiding retroactive conformance warnings in consuming apps.

## Topics

### Conformance

- ``JSON``
