//
//  ViewController.swift
//  Food
//
//  Created by Gouthami Reddy on 8/14/18.
//  Copyright © 2018 Gouthami Reddy. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var textLbl: UITextField!
    @IBOutlet weak var photoSelected: UIImageView!    
    @IBOutlet weak var starRating: ratingFile!        
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var meal: Meal?
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       textLbl.delegate = self
        
        if let meal = meal {
            navigationItem.title = meal.name
            textLbl.text = meal.name
            photoSelected.image = meal.photo
            starRating.rating = meal.rating
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        updateSaveButtonState()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
//        mealName.text = textField.text
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    @IBAction func selectedImageForPhotoLibrary(_ sender: UITapGestureRecognizer) {
        textLbl.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController,animated: true,completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selctedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing image\(info)")
        }
      photoSelected.image = selctedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let ispresentingInAddMealMode = presentingViewController is UINavigationController
        
        if ispresentingInAddMealMode {
        dismiss(animated: true, completion: nil)
        }
            else if let owningNavigationController = navigationController {
                owningNavigationController.popViewController(animated: true)
            }
            else {
                fatalError("the viewController is not inside a navigation controller")
            }
    
    }
    @IBAction func Buttonpressed(_ sender: Any) {
//    mealName.text = "Default Text"
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("the save button was not pressed, cancelled", log: OSLog.default, type: .debug)
            return
        }
        let name = textLbl.text ?? "'"
        let photo = photoSelected.image
        let rating = starRating.rating
        
        meal = Meal(name: name, photo: photo, rating: rating)
    }
   
    private func updateSaveButtonState() {
        let text = textLbl.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
