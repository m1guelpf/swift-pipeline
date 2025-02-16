public class Pipeline<Value> {
	public typealias PipeFn = (Value) throws -> Value

	/// The object being passed through the pipeline.
	private var passable: Value

	/// The array of class pipes.
	private var pipes: [PipeFn] = []

	private init(_ passable: Value) {
		self.passable = passable
	}

	/// Set the object being sent through the pipeline.
	public static func send(_ passable: Value) -> Pipeline<Value> {
		return Pipeline(passable)
	}

	/// Set the array of pipes.
	public func through(_ pipes: [PipeType<Value>]) -> Self {
		self.pipes = pipes.map { pipe in pipe.toFunction() }

		return self
	}

	/// Push additional pipes onto the pipeline.
	public func pipe(_ pipes: [PipeType<Value>]) -> Self {
		self.pipes.append(contentsOf: pipes.map { $0.toFunction() })

		return self
	}

	/// Run the pipeline with a final destination callback.
	public func then<Return>(_ callable: @escaping (Value) throws -> Return) throws -> Return {
		passable = try pipes.reversed().reduce(passable) { passable, pipe in
			try pipe(passable)
		}

		return try callable(passable)
	}

	/// Run the pipeline and return the result.
	public func thenReturn() throws -> Value {
		return try then { $0 }
	}

	/// Run the pipeline.
	public func run() throws {
		_ = try thenReturn()
	}
}

// Convenience methods for `through`
public extension Pipeline {
	/// Set the array of pipes.
	func through(_ pipes: [any Pipe<Value>]) -> Self {
		return through(pipes.map { .pipe($0) })
	}

	/// Set the array of pipes.
	func through(_ pipes: [PipeFn]) -> Self {
		return through(pipes.map { .fn($0) })
	}

	/// Set the array of pipes.
	func through(_ pipes: PipeType<Value>...) -> Self {
		return through(pipes)
	}

	/// Set the array of pipes.
	func through(_ pipes: any Pipe<Value>...) -> Self {
		return through(pipes)
	}

	/// Set the array of pipes.
	func through(_ pipes: PipeFn...) -> Self {
		return through(pipes)
	}
}

// Convenience methods for `pipe`
public extension Pipeline {
	/// Push additional pipes onto the pipeline.
	func pipe(_ pipes: PipeType<Value>...) -> Self {
		return pipe(pipes)
	}

	/// Push additional pipes onto the pipeline.
	func pipe(_ pipes: [PipeFn]) -> Self {
		return pipe(pipes.map { .fn($0) })
	}

	/// Push additional pipes onto the pipeline.
	func pipe(_ pipes: [any Pipe<Value>]) -> Self {
		return pipe(pipes.map { .pipe($0) })
	}

	/// Push additional pipes onto the pipeline.
	func pipe(_ pipes: PipeFn...) -> Self {
		return pipe(pipes)
	}

	/// Push additional pipes onto the pipeline.
	func pipe(_ pipes: any Pipe<Value>...) -> Self {
		return pipe(pipes)
	}
}
