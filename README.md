# Pipeline for Swift

[![Swift Version](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fm1guelpf%2Fswift-pipeline%2Fbadge%3Ftype%3Dswift-versions&color=brightgreen)](https://swiftpackageindex.com/m1guelpf/swift-pipeline)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/m1guelpf/swift-pipeline/main/LICENSE)

A convenient way to "pipe" a given input through a series of invokable classes, closures, or callables, giving each class the opportunity to inspect or modify the input and invoke the next callable in the pipeline.

## Installation

### Swift Package Manager

The Swift Package Manager allows for developers to easily integrate packages into their Xcode projects and packages and is also fully integrated into the swift compiler.

### SPM Through XCode Project

-   File > Swift Packages > Add Package Dependency
-   Add https://github.com/m1guelpf/swift-pipeline.git
-   Select "Branch" with "main"

### SPM Through Xcode Package

Once you have your Swift package set up, add the Git link within the dependencies value of your Package.swift file.

```swift
dependencies: [
    .package(url: "https://github.com/m1guelpf/swift-pipeline.git", .branch("main"))
]
```

## Usage

To get started, create a new pipeline with the `send` method, passing the input you want to pipe through the pipeline. Then, use the `through` method to add a series of pipes (either classes implenting the `Pipe` protocol, or closures) to the pipeline. Finally, call the `then` method to transform and get the final output.

You can also append `Pipe`s to an existing pipeline using the `pipe` method, or use `thenReturn` to get the final output without transforming it.

```swift
import Pipeline;

try Pipeline.send(project).through(
    .pipe(BuildProject(),
    .pipe(UploadProject(),
    .pipe(DeployProject()),
    .fn { project in
        // ...

        return project
    }
))).run()
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
