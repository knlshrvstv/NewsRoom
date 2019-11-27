# NewsRoom
iOS app to show a news feed 

# Environment
Xcode 11.2.1
Deployment target- iOS 13.2
Swift 5
Dependency manager- Swift Package Manager
Version control- Git

# Overview
This project uses Swift packages to seperate out reusable components. The dependency graph looks like the following("->" translates to "is dependent on"):

NewsRoom -> Cache, LazyResourceFetcher, Utilities, Styles, Networking
Cache -> None
LazyResourceFetcher -> Networking, Cache

# Architecture
The pattern used in the project is based on MVVM where each ViewController is backed by a View Model to carry the business logic or talk to lower level interface and data stores. The project supports a reusable networking layer and lazy loading of images. 

# Future improvements
* Have Cache backed by a on-disc store so that cache can be persisted accross app runs
* If service can support pagination of API, the article response can be cached as well.

