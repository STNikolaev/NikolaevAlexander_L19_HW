//
//  EntityDetailsViewController.swift
//  BirthdayReminder
//
//  Created by Max Bystryk on 11.11.2021.
//

import UIKit

class EntityDetailsViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var currentEntityImage: UIImageView!
    
    var currentEntity: BirthdayEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentEntity = currentEntity else { return }
        nameLabel.text = currentEntity.name
        dateOfBirthLabel.text = currentEntity.formattedDate
        currentEntityImage.image = UIImage(data: currentEntity.icon!)
        currentEntityImage.contentMode = .scaleAspectFill
        currentEntityImage.layer.cornerRadius = (currentEntityImage.frame.height) / 2
        
        
    }

}
