public protocol AsyncPipe<Value> {
	associatedtype Value

	func handle(_ value: Value) async throws -> Value
}
