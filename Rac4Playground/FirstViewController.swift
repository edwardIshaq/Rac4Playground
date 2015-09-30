//
//  FirstViewController.swift
//  Rac4Playground
//
//  Created by Edward Ishaq on 9/30/15.
//  Copyright © 2015 Zuno. All rights reserved.
//

import UIKit
import ReactiveCocoa

func makeArray(text: String) -> [String] {
    var result = [String]()
    for _ in 0...5 {
        result.append(text)
    }
    return result
}


class DummyViewModel {
    let searchText = MutableProperty<String>("")
    
    func arraySignal(text: String) -> SignalProducer<String, NoError> {
        let arrayProducer = SignalProducer<String, NoError>(values: makeArray(text))
        return arrayProducer
    }
    
}

class FirstViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var button: UIButton!
    let viewModel = DummyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    func bindViewModel() {
        let searchStrings = searchField.rac_textSignal()
            .toSignalProducer()
            .map{ text in text as! String}
        

        let searchStringsNoError = searchStrings.flatMapError { (error:NSError) -> SignalProducer<String, NoError> in
            return SignalProducer<String, NoError>.empty
        }
        
        let flatMapped = searchStringsNoError.flatMap(.Latest) { (txt: String) in
            return self.viewModel.arraySignal(txt)
        }
        
        flatMapped.on(next: { txt in
            print("flatMapped \(txt)")
        })
        .start()
//        searchStringsNoError.flatMap(.Latest) { txt in
//            return self.viewModel.arraySignal(txt).promoteError(NSError.self)
//        }


//        searchStrings.flatMap(.Latest) { txt in
//            self.viewModel.arraySignal(txt).promoteError(NSError.self)
//        }
        
//        searchStrings
//            .mapError{ err ->  SignalProducer<String, NoError> in
//                SignalProducer<String, NoError>.empty
//            }
        
//        searchStrings.producer
//            .promoteError(NoError.self)
//            .flatMap(.Latest) { text in
//            return viewModel.arraySignal(text)
//        }

        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

