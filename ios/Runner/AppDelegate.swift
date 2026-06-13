import Flutter
import Contacts
import ContactsUI
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, CNContactPickerDelegate {
  private var contactPickerResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    configureContactPickerChannel()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func configureContactPickerChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let channel = FlutterMethodChannel(
      name: "wingle/contact_picker",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "pickContacts" else {
        result(FlutterMethodNotImplemented)
        return
      }

      self?.presentContactPicker(result: result)
    }
  }

  private func presentContactPicker(result: @escaping FlutterResult) {
    guard contactPickerResult == nil else {
      result(
        FlutterError(
          code: "CONTACT_PICKER_ACTIVE",
          message: "Contact picker is already active.",
          details: nil
        )
      )
      return
    }

    guard let presenter = topViewController(from: window?.rootViewController) else {
      result(
        FlutterError(
          code: "CONTACT_PICKER_UNAVAILABLE",
          message: "Unable to present contact picker.",
          details: nil
        )
      )
      return
    }

    contactPickerResult = result

    let picker = CNContactPickerViewController()
    picker.delegate = self
    picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
    picker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
    presenter.present(picker, animated: true)
  }

  func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
    completeContactPicker(
      canceled: false,
      contacts: contacts.map { contactPayload(from: $0) }
    )
  }

  func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
    completeContactPicker(canceled: true, contacts: [])
  }

  private func completeContactPicker(
    canceled: Bool,
    contacts: [[String: Any]]
  ) {
    guard let result = contactPickerResult else {
      return
    }

    contactPickerResult = nil
    result([
      "canceled": canceled,
      "contacts": contacts,
    ])
  }

  private func contactPayload(from contact: CNContact) -> [String: Any] {
    let phoneNumbers = contact.phoneNumbers.map { $0.value.stringValue }
    let displayName = CNContactFormatter.string(from: contact, style: .fullName)?
      .trimmingCharacters(in: .whitespacesAndNewlines)

    return [
      "id": contact.identifier,
      "displayName": displayName ?? phoneNumbers.first ?? "",
      "phoneNumbers": phoneNumbers,
    ]
  }

  private func topViewController(from controller: UIViewController?) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(from: navigationController.visibleViewController)
    }

    if let tabBarController = controller as? UITabBarController {
      return topViewController(from: tabBarController.selectedViewController)
    }

    if let presentedController = controller?.presentedViewController {
      return topViewController(from: presentedController)
    }

    return controller
  }
}
