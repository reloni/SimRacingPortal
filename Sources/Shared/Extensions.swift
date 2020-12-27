import Vapor

public extension String {
    func asJsonData() throws -> Data? {
        return try (JSONSerialization.jsonObject(with: Data(self.utf8), options: []) as? [String: AnyObject])
            .map { try JSONSerialization.data(withJSONObject: $0, options: []) }
    }
}

public extension Data {
    func asByteBuffer() -> ByteBuffer {
        var buffer = ByteBufferAllocator().buffer(capacity: count)
        buffer.writeBytes(self)
        return  buffer
    }
}