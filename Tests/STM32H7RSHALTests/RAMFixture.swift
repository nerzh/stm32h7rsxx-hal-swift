import XCTest

protocol RAMTestFixture: AnyObject {
  var state: OpaquePointer { get }
  var variant: UInt32 { get }
  func get(_ group: UInt32, _ index: UInt32) -> UInt32
  func set(_ group: UInt32, _ index: UInt32, _ value: UInt32)
  func run(_ operation: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32
  func runReference(_ operation: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32
  func compare(to other: any RAMTestFixture) -> UInt32
  func setParent(_ source: UInt32, to other: any RAMTestFixture)
}
func makeRAMFixture(_ sdram: Bool, variant: UInt32 = 1) -> any RAMTestFixture {
  if sdram { return SDRAMFixture(variant: variant) }
  return SRAMFixture(variant: variant)
}
@discardableResult
func checkRAM(
  _ sdram: Bool, _ setup: (any RAMTestFixture) -> Void = { _ in },
  variant: UInt32 = 1, operation: UInt32,
  _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0,
  file: StaticString = #filePath, line: UInt = #line
) -> any RAMTestFixture {
  let reference = makeRAMFixture(sdram, variant: variant)
  let swift = makeRAMFixture(sdram, variant: variant)
  setup(reference)
  setup(swift)
  let expected = reference.runReference(operation, a, b, c)
  XCTAssertEqual(
    swift.run(operation, a, b, c), expected, "SDRAM \(sdram), operation \(operation)", file: file,
    line: line)
  XCTAssertEqual(
    reference.compare(to: swift), 0, "SDRAM \(sdram), operation \(operation)", file: file,
    line: line)
  return swift
}
