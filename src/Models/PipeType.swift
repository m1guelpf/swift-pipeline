public enum PipeType<Value> {
	case pipe(any Pipe<Value>)
	case fn((Value) throws -> Value)

	func toFunction() -> (Value) throws -> Value {
		switch self {
			case let .pipe(pipe):
				return { try pipe.handle($0) }
			case let .fn(fn):
				return fn
		}
	}
}
