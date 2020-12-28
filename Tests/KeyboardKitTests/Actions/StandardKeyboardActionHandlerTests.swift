//
//  StandardKeyboardActionHandlerTests.swift
//  KeyboardKitTests
//
//  Created by Daniel Saidi on 2019-05-06.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
import Mockery
import KeyboardKit
import UIKit

class StandardKeyboardActionHandlerTests: QuickSpec {
    
    override func spec() {
        
        var handler: StandardKeyboardActionHandlerTestClass!
        var recorder: MockKeyboardActionHandler!
        var inputViewController: MockInputViewController!
        
        beforeEach {
            recorder = MockKeyboardActionHandler()
            inputViewController = MockInputViewController()
            handler = StandardKeyboardActionHandlerTestClass(
                recorder: recorder,
                inputViewController: inputViewController)
        }
        
        
        // MARK: - KeyboardActionHandler
        
        describe("can handle gesture on action") {
            
            it("can handle any action that isn't nil") {
                expect(handler.canHandle(.tap, on: .backspace, sender: nil)).to(beTrue())
                expect(handler.canHandle(.doubleTap, on: .backspace, sender: nil)).to(beFalse())
            }
        }
        
        describe("handling gesture on action") {
            
            it("performs a bunch of actions") {
                inputViewController.context.keyboardType = .alphabetic(.uppercased)
                handler.handle(.tap, on: .character("a"))
                // TODO: Test animation
                // TODO: Test audio feedback
                // TODO: Test haptic feedback
                expect(inputViewController.hasInvoked(inputViewController.changeKeyboardTypeRef)).to(beTrue())
                expect(inputViewController.hasInvoked(inputViewController.performAutocompleteRef)).to(beTrue())
            }
        }
        
        
        // MARK: - Actions
        
        context("actions") {
            
            let actions = KeyboardAction.testActions
            
            describe("tap action") {
                
                it("is not nil for actions with standard action") {
                    actions.forEach {
                        let action = handler.tapAction(for: $0, sender: nil)
                        expect(action == nil).to(equal($0.standardTapAction == nil))
                    }
                }
            }
            
            describe("double tap action") {
                
                it("is not nil for actions with standard action") {
                    actions.forEach {
                        let action = handler.doubleTapAction(for: $0, sender: nil)
                        expect(action == nil).to(equal($0.standardDoubleTapAction == nil))
                    }
                }
            }
            
            describe("long press action") {
                
                it("is not nil for actions with standard action") {
                    actions.forEach {
                        let action = handler.longPressAction(for: $0, sender: nil)
                        expect(action == nil).to(equal($0.standardLongPressAction == nil))
                    }
                }
            }
            
            describe("repeat action") {
                
                it("is not nil for actions with standard action") {
                    actions.forEach {
                        let action = handler.repeatAction(for: $0, sender: nil)
                        expect(action == nil).to(equal($0.standardRepeatAction == nil))
                    }
                }
            }
        }
        
        
        // MARK: - Action Handling
        
        describe("handling keyboard type change for gesture on action") {
            
            it("does not change type if new type is same as current") {
                inputViewController.context.keyboardType = .alphabetic(.lowercased)
                handler.handleKeyboardTypeChange(after: .tap, on: .character("a"))
                expect(inputViewController.hasInvoked(inputViewController.changeKeyboardTypeRef)).to(beFalse())
            }
            
            it("changes type if new type is different from current") {
                inputViewController.context.keyboardType = .alphabetic(.uppercased)
                handler.handleKeyboardTypeChange(after: .tap, on: .character("a"))
                let inv = inputViewController.invokations(of: inputViewController.changeKeyboardTypeRef)
                expect(inv.count).to(equal(1))
                expect(inv[0].arguments.0).to(equal(.alphabetic(.lowercased)))
            }
        }
        
        describe("triggering animation for gesture on action") {
            // TODO: Test
        }
        
        describe("triggering audio feedback for gesture on action") {
            
            it("can't be properyly tested") {
                handler.triggerAudioFeedback(for: .tap, on: .dismissKeyboard, sender: nil)
                handler.triggerAudioFeedback(for: .tap, on: .backspace, sender: nil)
                handler.triggerAudioFeedback(for: .tap, on: .dismissKeyboard, sender: nil)
                // TODO Test this
            }
        }
        
        describe("triggering autocomplete") {
            
            it("calls input view controller") {
                expect(inputViewController.hasInvoked(inputViewController.performAutocompleteRef)).to(beFalse())
                handler.triggerAutocomplete()
                expect(inputViewController.hasInvoked(inputViewController.performAutocompleteRef)).to(beTrue())
            }
        }
        
        describe("triggering haptic feedback") {
            
            it("can't be properyly tested") {
                handler.triggerHapticFeedback(for: .longPress, on: .dismissKeyboard, sender: nil)
                handler.triggerHapticFeedback(for: .repeatPress, on: .backspace, sender: nil)
                handler.triggerHapticFeedback(for: .tap, on: .dismissKeyboard, sender: nil)
                // TODO Test this
            }
        }
    }
}


private class StandardKeyboardActionHandlerTestClass: StandardKeyboardActionHandler {
    
    public init(
        recorder: MockKeyboardActionHandler,
        inputViewController: KeyboardInputViewController) {
        self.recorder = recorder
        super.init(inputViewController: inputViewController)
    }
    
    let recorder: MockKeyboardActionHandler
    
    override func triggerHapticFeedback(for gesture: KeyboardGesture, on action: KeyboardAction, sender: Any?) {
        switch gesture {
        case .doubleTap: recorder.giveHapticFeedbackForDoubleTap(on: action)
        case .longPress: recorder.giveHapticFeedbackForLongPress(on: action)
        case .repeatPress: recorder.giveHapticFeedbackForRepeat(on: action)
        case .tap: recorder.giveHapticFeedbackForTap(on: action)
        }
    }
}
