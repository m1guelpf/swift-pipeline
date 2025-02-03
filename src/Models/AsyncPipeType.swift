public enum AsyncPipeType<Value> {
	case pipe(any AsyncPipe<Value>)
	case fn((Value) async throws -> Value)

	func toFunction() -> (Value) async throws -> Value {
		switch self {
			case let .pipe(pipe):
				return { try await pipe.handle($0) }
			case let .fn(fn):
				return fn
		}
	}
}
