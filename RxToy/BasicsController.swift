//
//  BasicsController.swift
//  RxToy
//
//  Created by Dmytro Nasyrov on 3/31/18.
//  Copyright © 2018 Pharos Production Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BasicsController: UIViewController {

    //MARK: - Variables
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var textViewLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btLabel: UILabel!
    @IBOutlet weak var infoBt: UIButton!
    @IBOutlet weak var segmentLabel: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var multiLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private let disposeBag = DisposeBag()
    private let tapped = PublishSubject<String>()
    private let input = Variable<String?>("")
    
    //MARK: - Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapKeyboardDismiss(tapRecognizer, view: view, bag: disposeBag)
        linkLabelTo(field: inputField, label: inputLabel, bag: disposeBag)
        linkLabelTo(textView: textView, label: textViewLabel, bag: disposeBag)
        linkLabelTo(bt: infoBt, label: btLabel, bag: disposeBag)
        linkLabelTo(segment: segment, label: segmentLabel, bag: disposeBag)
        linkProgressTo(slider: slider, progress: progress, bag: disposeBag)
        linkActivityTo(switcher: switcher, activity: activity, bag: disposeBag)
        linkLabelTo(stepper: stepper, label: multiLabel, bag: disposeBag)
        linkLabelTo(datePicker: datePicker, label: multiLabel, bag: disposeBag)
        
        linkFieldTo(variable: input, field: inputField, bag: disposeBag)
        onChange(variable: input, bag: disposeBag) {
            print("Input said: \(String(describing: $0))")
        }
        
        publishButtonTo(subject: tapped, bt: infoBt, bag: disposeBag)
        subscribeOn(subject: tapped, bag: disposeBag) {
            print("Button said: \($0)\n")
        }
    }
    
    //MARK: - Public
    
    static func create() -> BasicsController {
        return UIStoryboard(name: "BasicsController", bundle: nil).instantiateInitialViewController() as! BasicsController
    }
    
    //MARK: - Private
    
    private func addTapKeyboardDismiss(_ recognizer: UITapGestureRecognizer, view: UIView, bag: DisposeBag) {
        recognizer.rx.event.asDriver()
            .drive(onNext: { _ in view.endEditing(true) }, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
    
    private func linkLabelTo(field: UITextField, label: UILabel, bag: DisposeBag) {
        field.rx.text.asDriver()
            .drive(label.rx.text)
            .disposed(by: bag)
    }
    
    private func linkLabelTo(textView: UITextView, label: UILabel, bag: DisposeBag) {
        textView.rx.text
            .bind(onNext: {
                label.text = "Char count: \($0?.count ?? 0)"
            })
            .disposed(by: bag)
    }
    
    private func linkLabelTo(bt: UIButton, label: UILabel, bag: DisposeBag) {
        bt.rx.controlEvent(.touchUpInside).asDriver()
            .drive(onNext: {
                label.text! += "Tapped. "
                label.superview?.endEditing(true)
                
                UIView.animate(withDuration: 0.3) {
                    label.superview?.layoutIfNeeded()
                }
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
    
    private func linkLabelTo(segment: UISegmentedControl, label: UILabel, bag: DisposeBag) {
        segment.rx.value.asDriver()
            .skip(1)
            .drive(onNext: {
                label.text = "Selected segment: \($0)"
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
    
    private func linkProgressTo(slider: UISlider, progress: UIProgressView, bag: DisposeBag) {
        slider.rx.value.asDriver()
            .drive(progress.rx.progress)
            .disposed(by: bag)
    }
    
    private func linkActivityTo(switcher: UISwitch, activity: UIActivityIndicatorView, bag: DisposeBag) {
        switcher.rx.value.asDriver()
            .map { !$0 }
            .drive(activity.rx.isHidden)
            .disposed(by: bag)
        
        switcher.rx.value.asDriver()
            .drive(activity.rx.isAnimating)
            .disposed(by: bag)
    }
    
    private func linkLabelTo(stepper: UIStepper, label: UILabel, bag: DisposeBag) {
        stepper.rx.value.asDriver()
            .map { String(Int($0)) }
            .drive(label.rx.text)
            .disposed(by: bag)
    }
    
    private func linkLabelTo(datePicker: UIDatePicker, label: UILabel, bag: DisposeBag) {
        datePicker.rx.date.asDriver()
            .map { (date: Date) -> String in
                let formatter = DateFormatter()
                formatter.dateStyle = .full
            
                return formatter.string(from: date)
            }.drive(onNext: {
                label.text = $0
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
    
    private func linkFieldTo(variable: Variable<String?>, field: UITextField, bag: DisposeBag) {
        field.rx.text.bind(to: variable).disposed(by: bag)
    }
    
    private func publishButtonTo(subject: PublishSubject<String>, bt: UIButton, bag: DisposeBag) {
        bt.rx.tap
            .map { "Tapped!" }
            .bind(to: subject)
            .disposed(by: bag)
    }
    
    private func subscribeOn<T>(subject: PublishSubject<T>, bag: DisposeBag, handler: ((T) -> Void)?) {
        subject.subscribe(onNext: handler, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
    
    private func onChange<T>(variable: Variable<T>,  bag: DisposeBag, handler: ((T) -> Void)?) {
        variable.asObservable()
            .subscribe(onNext: handler, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}

