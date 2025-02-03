public protocol Pipe<Value> {
	associatedtype Value

	func handle(_ value: Value) throws -> Value
}
