//
//  NewEntityViewController.swift
//  BirthdayReminder
//
//  Created by Max Bystryk on 11.11.2021.
//

import UIKit

protocol NewEntityViewContollerDelegate: AnyObject {
    func newEntityViewController(_ controller: NewEntityViewController, didCreateEntity entity: BirthdayEntity)
    //func newEntity(_ entity: BirthdayEntity) //BAD APPROACH TO NAMING!
}

class NewEntityViewController: UIViewController {
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var dobTextField: UITextField!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet var imageOfEntity: UIImageView!
    private let datePicker = UIDatePicker()
    private var selectedDate: Date?
    
    weak var delegate: NewEntityViewContollerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        dobTextField.delegate = self
        dobTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(onDatePickerValueChanged(sender:)), for: .valueChanged)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapOnMainView))
        view.addGestureRecognizer(tapGestureRecognizer)
        
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
//        toolbar.setItems([done], animated: false)
//        dobTextField.inputAccessoryView = toolbar
        // Do any additional setup after loading the view.
    }
    
    @objc func onTapOnMainView() {
        dobTextField.resignFirstResponder()
    }
    
    @objc func onDatePickerValueChanged(sender: UIDatePicker) {
        let date = sender.date
        selectedDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateString = dateFormatter.string(from: date)
        dobTextField.text = dateString
    }
    
    @IBAction func didPressCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickImageDidPress(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose an image",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    
    @IBAction func didPressConfirmButton(_ sender: UIButton) {
        guard let name = nameTextField.text,
              let selectedDate = selectedDate,
              let selectedImage = imageOfEntity.image?.pngData(),
              name.count > 3
        else { return }
    
        let entity = BirthdayEntity(name: name, date: selectedDate, icon: selectedImage)
        dismiss(animated: true, completion: {
            self.delegate?.newEntityViewController(self, didCreateEntity: entity)
        })
    }
}

extension NewEntityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            dobTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
extension NewEntityViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageOfEntity.image = info[.editedImage] as? UIImage
        imageOfEntity.contentMode = .scaleAspectFill
        imageOfEntity.layer.cornerRadius = imageOfEntity.frame.height / 2
        imageOfEntity.clipsToBounds = true
        dismiss(animated: true)
    }
}
