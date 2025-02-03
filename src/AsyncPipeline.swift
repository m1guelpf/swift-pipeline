public class AsyncPipeline<Value> {
	public typealias PipeFn = (Value) async throws -> Value

	/// The object being passed through the pipeline.
	private var passable: Value

	/// The array of class pipes.
	private var pipes: [PipeFn] = []

	private init(_ passable: Value) {
		self.passable = passable
	}

	/// Set the object being sent through the pipeline.
	public static func send(_ passable: Value) -> AsyncPipeline<Value> {
		return AsyncPipeline(passable)
	}

	/// Set the array of pipes.
	public func through(_ pipes: [AsyncPipeType<Value>]) -> Self {
		self.pipes = pipes.map { pipe in pipe.toFunction() }

		return self
	}

	/// Push additional pipes onto the pipeline.
	public func pipe(_ pipes: [AsyncPipeType<Value>]) -> Self {
		self.pipes.append(contentsOf: pipes.map { $0.toFunction() })

		return self
	}

	/// Run the pipeline with a final destination callback.
	public func then<Return>(_ callable: @escaping (Value) async throws -> Return) async throws -> Return {
		passable = try await pipes.reversed().asyncReduce(passable) { passable, pipe in
			try await pipe(passable)
		}

		return try await callable(passable)
	}

	/// Run the pipeline and return the result.
	public func thenReturn() async throws -> Value {
		return try await then { $0 }
	}

	/// Run the pipeline.
	public func run() async throws {
		_ = try await thenReturn()
	}
}

// Convenience methods for `through`
public extension AsyncPipeline {
	/// Set the array of pipes.
	func through(_ pipes: [any AsyncPipe<Value>]) -> Self {
		return through(pipes.map { .pipe($0) })
	}

	/// Set the array of pipes.
	func through(_ pipes: [PipeFn]) -> Self {
		return through(pipes.map { .fn($0) })
	}

	/// Set the array of pipes.
	func through(_ pipes: AsyncPipeType<Value>...) -> Self {
		return through(pipes)
	}

	/// Set the array of pipes.
	func through(_ pipes: any AsyncPipe<Value>...) -> Self {
		return through(pipes)
	}

	/// Set the array of pipes.
	func through(_ pipes: PipeFn...) -> Self {
		return through(pipes)
	}
}

// Convenience methods for `pipe`
public extension AsyncPipeline {
	/// Push additional pipes onto the pipeline.
	func pipe(_ pipes: AsyncPipeType<Value>...) -> Self {
		return pipe(pipes)
	}

	/// Push additional pipes onto the pipeline.
	func pipe(_ pipes: [PipeFn]) -> Self {
		return pipe(pipes.map { .fn($0) })
	}

	/// Push additional pipes onto the pipeline.
	func pipe(_ pipes: [any AsyncPipe<Value>]) -> Self {
		return pipe(pipes.map { .pipe($0) })
	}

	/// Push additional pipes onto the pipeline.
	func pipe(_ pipes: PipeFn...) -> Self {
		return pipe(pipes)
	}

	/// Push additional pipes onto the pipeline.
	func pipe(_ pipes: any AsyncPipe<Value>...) -> Self {
		return pipe(pipes)
	}
}
