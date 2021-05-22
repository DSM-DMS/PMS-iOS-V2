// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let blackPencil = ImageAsset(name: "BlackPencil")
  internal static let blueLeftArrow = ImageAsset(name: "BlueLeftArrow")
  internal static let blueRightArrow = ImageAsset(name: "BlueRightArrow")
  internal static let bottomArrow = ImageAsset(name: "BottomArrow")
  internal static let check = ImageAsset(name: "Check")
  internal static let circleCheck = ImageAsset(name: "CircleCheck")
  internal static let circlePlus = ImageAsset(name: "CirclePlus")
  internal static let clip = ImageAsset(name: "Clip")
  internal static let dms = ImageAsset(name: "DMS")
  internal static let android1 = ImageAsset(name: "Android1")
  internal static let android2 = ImageAsset(name: "Android2")
  internal static let back1 = ImageAsset(name: "Back1")
  internal static let back2 = ImageAsset(name: "Back2")
  internal static let front1 = ImageAsset(name: "Front1")
  internal static let front2 = ImageAsset(name: "Front2")
  internal static let ios1 = ImageAsset(name: "iOS1")
  internal static let download = ImageAsset(name: "Download")
  internal static let enter = ImageAsset(name: "Enter")
  internal static let eye = ImageAsset(name: "Eye")
  internal static let leftArrow = ImageAsset(name: "LeftArrow")
  internal static let lock = ImageAsset(name: "Lock")
  internal static let mealFlip = ImageAsset(name: "MealFlip")
  internal static let minus = ImageAsset(name: "Minus")
  internal static let navigationArrow = ImageAsset(name: "NavigationArrow")
  internal static let o = ImageAsset(name: "O")
  internal static let apple = ImageAsset(name: "Apple")
  internal static let facebook = ImageAsset(name: "Facebook")
  internal static let kakaoTalk = ImageAsset(name: "KakaoTalk")
  internal static let naver = ImageAsset(name: "Naver")
  internal static let pms = ImageAsset(name: "PMS")
  internal static let person = ImageAsset(name: "Person")
  internal static let recomment = ImageAsset(name: "Recomment")
  internal static let rightArrow = ImageAsset(name: "RightArrow")
  internal static let calendar = ImageAsset(name: "Calendar")
  internal static let introduce = ImageAsset(name: "Introduce")
  internal static let meal = ImageAsset(name: "Meal")
  internal static let mypage = ImageAsset(name: "Mypage")
  internal static let notice = ImageAsset(name: "Notice")
  internal static let whitePencil = ImageAsset(name: "WhitePencil")
  internal static let x = ImageAsset(name: "X")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
