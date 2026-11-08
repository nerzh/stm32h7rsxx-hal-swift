// swift-tools-version: 6.4

import PackageDescription

// Select exactly one device for the hardware product, as required by swift-stm32.
let device = Context.environment["SWIFT_STM32_DEVICES"]?.uppercased()
if let device {
    precondition(device == "STM32H7R" || device == "STM32H7S",
                 "Select STM32H7R or STM32H7S using SWIFT_STM32_DEVICES.")
}

var products: [Product] = [.library(name: "STM32H7RSHAL", targets: ["STM32H7RSHAL"])]
var targets: [Target] = [
    .target(name: "STM32H7RSHAL"),
    .target(name: "CGPIOReference", path: "Tests/CGPIOReference", publicHeadersPath: "include"),
    .target(name: "CTimeReference", path: "Tests/CTimeReference", publicHeadersPath: "include"),
    .target(name: "CRCCReference", path: "Tests/CRCCReference", publicHeadersPath: "include"),
    .target(name: "CRCCControlReference", path: "Tests/CRCCControlReference", publicHeadersPath: "include"),
    .target(name: "CRCCExtendedReference", path: "Tests/CRCCExtendedReference", publicHeadersPath: "include"),
    .target(name: "CRNGReference", path: "Tests/CRNGReference", publicHeadersPath: "include"),
    .target(name: "CWatchdogReference", path: "Tests/CWatchdogReference", publicHeadersPath: "include"),
    .target(name: "CDMAReference", path: "Tests/CDMAReference", publicHeadersPath: "include"),
    .target(name: "CICacheReference", path: "Tests/CICacheReference", publicHeadersPath: "include"),
    .target(name: "CRAMECCReference", path: "Tests/CRAMECCReference", publicHeadersPath: "include"),
    .target(name: "CUARTReference", path: "Tests/CUARTReference", publicHeadersPath: "include"),
    .target(name: "CDTSReference", path: "Tests/CDTSReference", publicHeadersPath: "include"),
    .target(name: "CFLASHReference", path: "Tests/CFLASHReference", publicHeadersPath: "include"),
    .target(name: "CCORDICReference", path: "Tests/CCORDICReference", publicHeadersPath: "include"),
    .target(name: "CSystemReference", path: "Tests/CSystemReference", publicHeadersPath: "include"),
    .target(name: "CHASHReference", path: "Tests/CHASHReference", publicHeadersPath: "include"),
    .target(name: "CFDCANReference", path: "Tests/CFDCANReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CADCReference", path: "Tests/CADCReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CPKAReference", path: "Tests/CPKAReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CRTCReference", path: "Tests/CRTCReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CJPEGReference", path: "Tests/CJPEGReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CMDFReference", path: "Tests/CMDFReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CSPDIFRXReference", path: "Tests/CSPDIFRXReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CMCEReference", path: "Tests/CMCEReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CPSSIReference", path: "Tests/CPSSIReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CSerialControlReference", path: "Tests/CSerialControlReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CLPTIMReference", path: "Tests/CLPTIMReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CDCMIPPReference", path: "Tests/CDCMIPPReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CLTDCReference", path: "Tests/CLTDCReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CDMA2DReference", path: "Tests/CDMA2DReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CGFXTIMReference", path: "Tests/CGFXTIMReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .target(name: "CGraphicsReference", path: "Tests/CGraphicsReference", publicHeadersPath: "include",
            cSettings: [.headerSearchPath(".")]),
    .testTarget(name: "STM32H7RSHALTests", dependencies: ["STM32H7RSHAL", "CGPIOReference", "CTimeReference", "CRCCReference", "CRCCControlReference", "CRCCExtendedReference", "CRNGReference", "CWatchdogReference", "CDMAReference", "CICacheReference", "CUARTReference", "CDTSReference", "CFLASHReference", "CCORDICReference", "CSystemReference", "CHASHReference", "CGraphicsReference", "CGFXTIMReference", "CDMA2DReference", "CLTDCReference", "CDCMIPPReference", "CLPTIMReference", "CSerialControlReference", "CPSSIReference", "CMCEReference", "CSPDIFRXReference", "CMDFReference", "CJPEGReference", "CRTCReference", "CPKAReference", "CADCReference", "CFDCANReference"]),
]
var dependencies: [Package.Dependency] = []
if let device {
    dependencies = [
        .package(url: "https://github.com/cryshado/swift-stm32", revision: "928e0a88c23a9148749072519207cbdf25854ddf"),
        .package(url: "https://github.com/cryshado/swift-cortex-m", revision: "a88916299fecb18c146ee563fb6412f630eababe"),
        .package(url: "https://github.com/apple/swift-mmio", revision: "b43b13d5acab79f099860c52e0e5dbd72bfe81e3"),
    ]
    products.append(.library(name: "STM32H7RSHardware", targets: ["STM32H7RSHardware"]))
    targets.append(.target(name: "CCortexHALSupport"))
    targets.append(.target(
        name: "STM32H7RSHardware",
        dependencies: ["STM32H7RSHAL", "CCortexHALSupport",
                       .product(name: device, package: "swift-stm32"),
                       .product(name: "MMIO", package: "swift-mmio"),
                       .product(name: "CortexMCore", package: "swift-cortex-m")],
        swiftSettings: [.define(device)]
    ))
    targets.append(.testTarget(
        name: "STM32H7RSHardwareTests",
        dependencies: ["STM32H7RSHardware"],
        swiftSettings: [.define(device)]
    ))
}

let package = Package(
    name: "stm32h7rsxx-hal-swift",
    platforms: [.macOS(.v26)],
    products: products,
    dependencies: dependencies,
    targets: targets
)
