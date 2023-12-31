// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Web3MQ",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "Web3MQ",
      targets: ["Web3MQ"]),

    .library(
      name: "DappConnect",
      targets: ["DappConnect"]),

    .library(
      name: "Web3MQNetworking",
      targets: ["Web3MQNetworking"]),

    .library(
      name: "Web3MQServices",
      targets: ["Web3MQServices"]),

    .library(
      name: "UIComponentCore",
      targets: ["UIComponentCore"]),

    .library(
      name: "UIComponentSign",
      targets: ["UIComponentSign"]),

    .library(
      name: "UIComponentNotification",
      targets: ["UIComponentNotification"]),

    .library(
      name: "UIComponentChats",
      targets: ["UIComponentChats"]),

    .library(
      name: "UIComponentContacts",
      targets: ["UIComponentContacts"]),

  ],
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
    .package(url: "git@github.com:apple/swift-protobuf.git", from: "1.6.0"),
    .package(url: "https://github.com/daltoniam/Starscream.git", .upToNextMajor(from: "4.0.0")),
    .package(
      url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMinor(from: "1.6.0")),
    .package(url: "git@github.com:Batxent/Presentable.git", branch: "main"),
    .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0")),
    .package(url: "git@github.com:Batxent/swift-sodium.git", branch: "master"),
    .package(url: "git@github.com:vapor/url-encoded-form.git", branch: "master"),
    .package(url: "git@github.com:hyperoslo/Cache.git", .upToNextMajor(from: "6.0.0")),
    .package(url: "git@github.com:SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
    .package(url: "https://github.com/rechsteiner/Parchment", exact: "3.1.0"),
    .package(url: "git@github.com:MessageKit/MessageKit.git", .upToNextMajor(from: "4.0.0")),
  ],
  targets: [

    .target(
      name: "Web3MQNetworking",
      dependencies: [
        .product(name: "SwiftProtobuf", package: "swift-protobuf"),
        .product(name: "Alamofire", package: "Alamofire"),
        .product(name: "Starscream", package: "Starscream"),
        .product(name: "CryptoSwift", package: "CryptoSwift"),
        .product(name: "Sodium", package: "swift-sodium"),
      ]),

    .target(name: "Web3MQServices", dependencies: ["Web3MQNetworking"]),

    .target(name: "Web3MQ", dependencies: ["Web3MQServices"]),

    .target(
      name: "DappConnect",
      dependencies: [
        "Web3MQNetworking", "Cache",
        .product(name: "URLEncodedForm", package: "url-encoded-form"),
      ]),

    .target(
      name: "UIComponentCore",
      dependencies: ["SnapKit", "Web3MQ"]),

    .target(
      name: "UIComponentChats",
      dependencies: [
        "UIComponentCore", "SnapKit",
        "Web3MQ",
        "MessageKit",
      ]),

    .target(
      name: "UIComponentSign",
      dependencies: ["Presentable", "Kingfisher"]),

    .target(
      name: "UIComponentNotification",
      dependencies: [
        "Web3MQ",
        "Web3MQNetworking",
        "Kingfisher", "UIComponentCore",
      ]),

    .target(
      name: "UIComponentContacts",
      dependencies: [
        "UIComponentCore", "Kingfisher", "Parchment",
        "Web3MQ",
      ]),

    .testTarget(
      name: "UIComponentTests",
      dependencies: ["UIComponentSign"]),

    .testTarget(
      name: "Web3MQTests",
      dependencies: ["Web3MQ", "DappConnect"]),

    .testTarget(
      name: "DappConnectTests",
      dependencies: ["Web3MQ", "DappConnect"]),

    .testTarget(
      name: "SignTests",
      dependencies: ["Web3MQ", "DappConnect"]),
  ]
)
