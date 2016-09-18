import XCTest
@testable import TryResult

class TryResultTests: XCTestCase {
    func testFlatMapLeft() {
        do {
            let a: Result<Int> = { 3 }
            let r: Result<Int> = a >>- { a in { a * a } }
            XCTAssertEqual(try! r(), 9)
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let r: Result<Int> = a >>- { a in { a * a } }
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "a")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { 3 }
            let r: Result<Int> = a >>- { _ in { throw MyError(message: "f") } }
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "f")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { 3 }
            let r: Result<Int> = a >>- { _ in throw MyError(message: "f") }
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "f")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let r: Result<Int> = a >>- { _ in { throw MyError(message: "f") } }
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "a")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let r: Result<Int> = a >>- { _ in throw MyError(message: "f") }
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "a")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<String> = { "42" }
            let r: Result<Int> = a >>- { Int($0).result }
            XCTAssertEqual(try! r(), 42)
        }
        
        do {
            let a: Result<String> = { "ABC" }
            let r: Result<Int> = a >>- { Int($0).result }
            do {
                _ = try r()
                XCTFail()
            } catch is NilError {
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { 2 }
            let b: Result<Int> = { 3 }
            let r: Result<Int> = a >>- { a in b >>- { b in { a + b } } }
            XCTAssertEqual(try! r(), 5)
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let b: Result<Int> = { 3 }
            let r: Result<Int> = a >>- { a in b >>- { b in { a + b } } }
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "a")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { 2 }
            let b: Result<Int> = { throw MyError(message: "b") }
            let r: Result<Int> = a >>- { a in b >>- { b in { a + b } } }
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "b")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let b: Result<Int> = { throw MyError(message: "b") }
            let r: Result<Int> = a >>- { a in b >>- { b in { a + b } } }
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "a")
            } catch {
                XCTFail()
            }
        }
    }
    
    func testFlatMapRight() {
        do {
            let a: Result<Int> = { 3 }
            let r: Result<Int> = { a in { a * a } } -<< a
            XCTAssertEqual(try! r(), 9)
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let r: Result<Int> = { a in { a * a } } -<< a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "a")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { 3 }
            let r: Result<Int> = { _ in { throw MyError(message: "f") } } -<< a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "f")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { 3 }
            let r: Result<Int> = { _ in throw MyError(message: "f") } -<< a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "f")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let r: Result<Int> = { _ in { throw MyError(message: "f") } } -<< a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "a")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let r: Result<Int> = { _ in throw MyError(message: "f") } -<< a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "a")
            } catch {
                XCTFail()
            }
        }
    }
    
    func testMap() {
        do {
            let a: Result<Int> = { 3 }
            let r: Result<Int> = { a in a * a } <^> a
            XCTAssertEqual(try! r(), 9)
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let r: Result<Int> = { a in a * a } <^> a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "a")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { 3 }
            let r: Result<Int> = { _ in throw MyError(message: "f") } <^> a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "f")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let r: Result<Int> = { _ in throw MyError(message: "f") } <^> a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "a")
            } catch {
                XCTFail()
            }
        }
    }
    
    func testApply() {
        do {
            let a: Result<Int> = { 3 }
            let f: Result<(Int) -> Int> = { { $0 * $0 } }
            let r: Result<Int> = f <*> a
            XCTAssertEqual(try! r(), 9)
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let f: Result<(Int) -> Int> = { { $0 * $0 } }
            let r: Result<Int> = f <*> a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "a")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { 3 }
            let f: Result<(Int) -> Int> = { throw MyError(message: "f") }
            let r: Result<Int> = f <*> a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "f")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { 3 }
            let f: Result<(Int) throws -> Int> = { { _ in throw MyError(message: "f") } }
            let r: Result<Int> = f <*> a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "f")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let f: Result<(Int) -> Int> = { throw MyError(message: "f") }
            let r: Result<Int> = f <*> a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "f")
            } catch {
                XCTFail()
            }
        }
        
        do {
            let a: Result<Int> = { throw MyError(message: "a") }
            let f: Result<(Int) throws -> Int> = { { _ in throw MyError(message: "f") } }
            let r: Result<Int> = f <*> a
            do {
                _ = try r()
                XCTFail()
            } catch let error as MyError {
                XCTAssertEqual(error.message, "a")
            } catch {
                XCTFail()
            }
        }
    }
    
    func testSample() {
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
            /**/ print(sum)
        } catch {
            // error handling
        }

        // Operators
        let sum: Result<Int> = a >>- { a in b >>- { b in { a + b } } } // flatMap
        let square: Result<Int> = { $0 * $0 } <^> a // map
        let vector: Result<Vector2> = curry(Vector2.init) <^> { 2.0 } <*> { 3.0 } // apply
        
        XCTAssertEqual(try! a(), 3)
        do {
            _ = try b()
            XCTFail()
        } catch let error as MyError {
            XCTAssertEqual(error.message, "")
        } catch {
            XCTFail()
        }
        XCTAssertEqual(value, 3)
        do {
            _ = try sum()
            XCTFail()
        } catch let error as MyError {
            XCTAssertEqual(error.message, "")
        } catch {
            XCTFail()
        }
        XCTAssertEqual(try! square(), 9)
        XCTAssertEqual(try! vector().x, 2.0)
        XCTAssertEqual(try! vector().y, 3.0)
    }

    static var allTests : [(String, (TryResultTests) -> () throws -> Void)] {
        return [
            ("testFlatMapLeft", testFlatMapLeft),
            ("testFlatMapRight", testFlatMapRight),
            ("testMap", testMap),
            ("testApply", testApply),
            ("testSample", testSample),
        ]
    }
}

struct MyError: Error {
    let message: String
    
    init(message: String = "") {
        self.message = message
    }
}

struct NilError: Error {}

extension Optional {
    var result: Result<Wrapped> {
        if let value = self {
            return { value }
        } else {
            return { throw NilError() }
        }
    }
}

struct Vector2 {
    let x: Float
    let y: Float
}

func curry<A, B, Z>(_ f: @escaping (A, B) -> Z) -> (A) -> (B) -> Z {
    return { a in { b in f(a, b) } }
}
