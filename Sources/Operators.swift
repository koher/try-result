precedencegroup TryResultMonadicPrecedenceRight {
    associativity: right
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: AssignmentPrecedence
}

precedencegroup TryResultMonadicPrecedenceLeft {
    associativity: left
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: AssignmentPrecedence
}

precedencegroup TryResultApplicativePrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
    lowerThan: NilCoalescingPrecedence
}

infix operator >>- : TryResultMonadicPrecedenceLeft
infix operator -<< : TryResultMonadicPrecedenceRight

infix operator <^> : TryResultApplicativePrecedence
infix operator <*> : TryResultApplicativePrecedence
