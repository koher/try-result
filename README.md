# TryResult

_TryResult_ provides `Result` as a `typealias` of a function with `throws`.

```swift
typealias Result<Value> = () throws -> Value
```

It enables us to handle errors seamlessly between `throws` and `Result`.

```swift
// Wrapping
let a: Result<Int> = { 3 } // success
let b: Result<Int> = { throw MyError() } // failure

// Unwrapping by Optional binding
if let a = try? a() {
    print(a)
}

// Forced unrwapping
let value: Int = try! a()

// do-try-catch
do {
    let sum: Int = try a() + b()
    // use `sum` here
} catch {
    // error handling
}
```

_TryResult_ also provides some functional operators to make it easy to handle `Result`s.

```swift
// Operators
let sum: Result<Int> = a >>- { a in b >>- { b in { a + b } } } // flatMap
let square: Result<Int> = { $0 * $0 } <^> a // map
let vector: Result<Vector2> = curry(Vector2.init) <^> { 2.0 } <*> { 3.0 } // apply
```

## Motivation

_do-try-catch_ is unsuitable for asynchronous operations. `Result` is useful for them. However, Swift does not provide `Result` in its standard library.

Although [antitypical/Result](https://github.com/antitypical/Result) is a de facto standard `Result` library, of course, it force our codes to have a dependency to use it. It especially has a problem when we implement a library. I want to avoid a "library lock-in" for my libraries.

_TryResult_ provides `Result` as a `typealias` of `() throws -> Value`. We do not need to depend on `TryResult` when we implement out libraries: we just need to write `() throws -> Value`. Then the libraries can be combined with `TryResult` in an application.

## Why we need `TryResult`

We can also write `() throws -> Value` without `Result<Value>`. However, it is confusing and readability suffers when we combine it with asynchronous operations. The following is an example.

```swift
func download(url: URL, callback: (() throws -> Data) -> ()) { ... }
```

_TryResult_ makes it easy to read.

```swift
func download(url: URL, callback: (Result<Data>) -> ()) { ... }
```

## Installation

Use Swift Package Manager. Add the following to dependencies in your Package.swift file.

```swift
.Package(
    url: "https://github.com/koher/try-result.git",
    majorVersion: 0
)
```

## License

[The MIT License](LICENSE)
