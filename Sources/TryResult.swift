public typealias Result<Value> = () throws -> Value

public func >>-<Value, T>(result: Result<Value>, transform: (Value) throws -> Result<T>) -> Result<T> {
    do {
        return try transform(result())
    } catch let error {
        return { throw error }
    }
}

public func -<<<Value, T>(transform: (Value) throws -> Result<T>, result: Result<Value>) -> Result<T> {
    return result >>- transform
}

public func <^><Value, T>(transform: (Value) throws -> T, result: Result<Value>) -> Result<T> {
    do {
        let r = try transform(result())
        return { r }
    } catch let error {
        return { throw error }
    }
}

public func <*><Value, T>(transform: Result<(Value) throws -> T>, result: Result<Value>) -> Result<T> {
    return transform >>- { $0 <^> result }
}
