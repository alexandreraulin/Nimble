import XCTest
import Nimble
import Foundation

final class PostNotificationTest: XCTestCase, XCTestCaseProvider {
    let notificationCenter = NotificationCenter()

    func testPassesWhenNoNotificationsArePosted() {
        expect {
            // no notifications here!
            return nil
        }.to(postNotifications(beEmpty(), from: notificationCenter))
    }

    func testPassesWhenExpectedNotificationIsPosted() {
        let testNotification = Notification(name: Notification.Name("Foo"), object: nil)
        expect {
            self.notificationCenter.post(testNotification)
        }.to(postNotifications(equal([testNotification]), from: notificationCenter))
    }

    func testPassesWhenAllExpectedNotificationsArePosted() {
        let foo = NSNumber(value: 1)
        let bar = NSNumber(value: 2)
        let n1 = Notification(name: Notification.Name("Foo"), object: foo)
        let n2 = Notification(name: Notification.Name("Bar"), object: bar)
        expect {
            self.notificationCenter.post(n1)
            self.notificationCenter.post(n2)
            return nil
        }.to(postNotifications(equal([n1, n2]), from: notificationCenter))
    }

    func testFailsWhenNoNotificationsArePosted() {
        let testNotification = Notification(name: Notification.Name("Foo"), object: nil)
        failsWithErrorMessage("expected to equal <[\(testNotification)]>, got no notifications") {
            expect {
                // no notifications here!
                return nil
            }.to(postNotifications(equal([testNotification]), from: self.notificationCenter))
        }
    }

    func testFailsWhenNotificationWithWrongNameIsPosted() {
        let n1 = Notification(name: Notification.Name("Foo"), object: nil)
        let n2 = Notification(name: Notification.Name(n1.name.rawValue + "a"), object: nil)
        failsWithErrorMessage("expected to equal <[\(n1)]>, got <[\(n2)]>") {
            expect {
                self.notificationCenter.post(n2)
                return nil
            }.to(postNotifications(equal([n1]), from: self.notificationCenter))
        }
    }

    func testFailsWhenNotificationWithWrongObjectIsPosted() {
        let n1 = Notification(name: Notification.Name("Foo"), object: nil)
        let n2 = Notification(name: n1.name, object: NSObject())
        failsWithErrorMessage("expected to equal <[\(n1)]>, got <[\(n2)]>") {
            expect {
                self.notificationCenter.post(n2)
                return nil
            }.to(postNotifications(equal([n1]), from: self.notificationCenter))
        }
    }

    func testPassesWhenExpectedNotificationEventuallyIsPosted() {
        let testNotification = Notification(name: Notification.Name("Foo"), object: nil)
        expect {
            deferToMainQueue {
                self.notificationCenter.post(testNotification)
            }
            return nil
        }.toEventually(postNotifications(equal([testNotification]), from: notificationCenter))
    }
}
