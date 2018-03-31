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

class BasicsController: UIViewController {

    // Variables
    
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
    
    lazy var disposeBag = DisposeBag()
    
    // Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapKeyboardDismiss(tapRecognizer, view: view, bag: disposeBag)
        linkLabelToField(inputField, label: inputLabel, bag: disposeBag)
        linkLabelToTextView(textView, label: textViewLabel, bag: disposeBag)
        linkLabelToBt(infoBt, label: btLabel, bag: disposeBag)
        linkLabelToSegment(segment, label: segmentLabel, bag: disposeBag)
        linkProgressToSlider(slider, progress: progress, bag: disposeBag)
        linkActivityToSwitch(switcher, activity: activity, bag: disposeBag)
        linkLabelToStepper(stepper, label: multiLabel, bag: disposeBag)
        linkLabelToDatePicker(datePicker, label: multiLabel, bag: disposeBag)
    }
    
    // Private
    
    private func addTapKeyboardDismiss(_ recognizer: UITapGestureRecognizer, view: UIView, bag: DisposeBag) {
        recognizer.rx.event.asDriver()
            .drive(onNext: { _ in view.endEditing(true) }, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
    
    private func linkLabelToField(_ field: UITextField, label: UILabel, bag: DisposeBag) {
        field.rx.text.asDriver()
            .drive(label.rx.text)
            .disposed(by: bag)
    }
    
    private func linkLabelToTextView(_ textView: UITextView, label: UILabel, bag: DisposeBag) {
        textView.rx.text
            .bind(onNext: {
                label.text = "Char count: \($0?.count ?? 0)"
            })
            .disposed(by: bag)
    }
    
    private func linkLabelToBt(_ bt: UIButton, label: UILabel, bag: DisposeBag) {
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
    
    private func linkLabelToSegment(_ segment: UISegmentedControl, label: UILabel, bag: DisposeBag) {
        segment.rx.value.asDriver()
            .skip(1)
            .drive(onNext: {
                label.text = "Selected segment: \($0)"
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
    
    private func linkProgressToSlider(_ slider: UISlider, progress: UIProgressView, bag: DisposeBag) {
        slider.rx.value.asDriver()
            .drive(progress.rx.progress)
            .disposed(by: bag)
    }
    
    private func linkActivityToSwitch(_ switcher: UISwitch, activity: UIActivityIndicatorView, bag: DisposeBag) {
        switcher.rx.value.asDriver()
            .map { !$0 }
            .drive(activity.rx.isHidden)
            .disposed(by: bag)
        
        switcher.rx.value.asDriver()
            .drive(activity.rx.isAnimating)
            .disposed(by: bag)
    }
    
    private func linkLabelToStepper(_ stepper: UIStepper, label: UILabel, bag: DisposeBag) {
        stepper.rx.value.asDriver()
            .map { String(Int($0)) }
            .drive(label.rx.text)
            .disposed(by: bag)
    }
    
    private func linkLabelToDatePicker(_ picker: UIDatePicker, label: UILabel, bag: DisposeBag) {
        picker.rx.date.asDriver()
            .map { (date: Date) -> String in
                let formatter = DateFormatter()
                formatter.dateStyle = .full
            
                return formatter.string(from: date)
            }.drive(onNext: {
                label.text = $0
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
}

