# Web3MQ SDK for iOS Swift

[![Swift Package Manager Compatible](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)

## Overview

Developed in Swift, the Web3MQ SDK for iOS Swift provides a modern way of implementing Web3MQ APIs. The features included in this SDK will help you develop an iOS app with engaging and personalized user experience.

For more information, refer to the [Web3MQ SDK Docs](https://docs.web3messaging.online/).

## iOS Main Features

- **Uses `UIKit` patterns and paradigms:** The API follows the design of native system SDKs. It makes integration with your existing code easy and familiar.
- **First-class support for `Combine` and `Concurrency`**
- **Swift native API:** Uses Swift's powerful language features to make the SDK usage easy and type-safe.

## Integrating the SDK

### Prerequisites

before you run your project, make sure that your development environment is provided with:

- Xcode 11
- iOS 13.0 or later

### Installation

#### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding Web3MQSDK as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "git@github.com:Generative-Labs/Web3MQ-SDK-Swift.git", .upToNextMajor(from: "0.1.0"))
]
```

## Initialize the SDK

Let's get started by initializing the client:

```swift
import Web3MQ

// the SDK will find the endpoint with lowest latency for you 
ChatClient.default.setup(with: Configuration(appKey: "{AppKey}"))

// or you prefer to set a specific endpoint     
ChatClient.default.setup(with: Configuration(appKey: "{AppKey}", endpoint: Endpoint.Dev.jp1))
```

## Connecting

### Signup

For any first-time user of Web3MQ's network, you'll need to register on Web3MQ's network. SDK takes care of the key generation process and subsequent wallet signing process. `ChatClient.default.connectWithMateMask` is a utility method that does this automatically.

```swift
// Keep your private key in a safe place!
let (keyPair, userId) = await ChatClient.default.connectWithMateMask()
```

SDK will save the `KeyPair` in Keychain by default, you could disable it by setting keychainStore false

```swift
let (keyPair, userId) = await ChatClient.default.connectWithMateMask(keychainStore: false)
```

### Connecting Automatically

If there is a key-pair in keychain, it will automatically connect to that user.

```swift
ChatClient.default.autoConnect()
```

### Connecting Manually

You could also connect manually.

```swift
ChatClient.default.connect(with: KeyPair(privateKey: "{PrivateKey}", publicKey: "{PublicKey}"), userId: "{UserId}")
```

### Connecting Status

If you want to react instantly with the connecting status updating, just subscribe this publisher:  `ChatClient.default.connectingStatusPublisher`

```swift
let status: Web3MQConnectingStatus = ChatClient.default.connectingStatus

public enum Web3MQConnectingStatus {
  case idle 
  // the SDK will always try to reconnect the Web3MQ network, so you don't need 
  // to care about that part.
  case connecting
  case connected(nodeId: String)
  // only when you disconnect manually 
  case disconnected 
  case error(_ error: Error?)
}
```

## Channels

Let’s continue by initializing your first channel. A channel contains messages, a list of members that are watching the channel. The example below shows how to set up a channel to support chat for a group conversation:

```swift
let channelId: String = await ChatClient.default.channelManager.createChannel(name: "{channel_name}") 
```

## Messages

Now that we have the channel set up, let's send our first chat message:

### Sending Message

send a message to a user or a channel

```swift
// sessionId: userId or channelId
ChatClient.default.messageManager.sendMessage("{Text}", topicId: "{TopicId}") async throws
```

### Receiving Message

subscribe the messagePublisher to receive messages.

```swift
ChatClient.default.messageManager.messagePublisher
```

## Notifications

### Receiving Notification

The notification is also a specific message. Just subscribe the `notificationPublisher` to receive notifications.

```swift
ChatClient.default.notificationManager.notificationPublisher
```
