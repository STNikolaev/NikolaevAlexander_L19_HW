//
//  ViewController.swift
//  BirthdayReminder
//
//  Created by Max Bystryk on 11.11.2021.
//

import UIKit

fileprivate struct ViewConfig {
    static let kCellHeight: CGFloat = 80
}

class RootViewController: UIViewController {
    @IBOutlet weak var birthdayListTableView: UITableView! {
        didSet {
            birthdayListTableView.delegate = self
            birthdayListTableView.dataSource = self
        }
    }
    
    var entities: [BirthdayEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillBirthdayArray()
        title = "Birthday Reminder"
        
        guard let savedEntities = UserDefaultManager.shared.array(forKey: .allEntities) else { return }
        entities = savedEntities
    }
    
    private func fillBirthdayArray() {
//        let one = BirthdayEntity(name: "Denis Suhov", dateString: "25.03.2001", icon: nil)
//        let two = BirthdayEntity(name: "Irina Dantsova", dateString: "22.02.1993", icon: nil)
//        let three = BirthdayEntity(name: "Michael Jackson", dateString: "25.08.1959", icon: nil)
//        let four = BirthdayEntity(name: "Michael Jordan", dateString: "25.06.2001", icon: nil)
//        let five = BirthdayEntity(name: "Merlin Dudnik", dateString: "25.02.2001", icon: nil)
//        let six = BirthdayEntity(name: "Dasha Suhova", dateString: "25.06.2001", icon: nil)
//
//        entities = [one, two, three, four, five, six]
    }
    
    @IBAction func addButtonDidTap(_ sender: UIBarButtonItem) {
        let vc = NewEntityViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: id) as? BirthdayEntityCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("BirthdayEntityCell", owner: nil, options: nil)?[0] as? BirthdayEntityCell
        }

        let currentEntity = entities[indexPath.row]
        
        cell?.nameLabel.text = currentEntity.name
        cell?.birthdayDateLabel.text = currentEntity.formattedDate
        cell?.iconImageView.image = UIImage(data: currentEntity.icon!)
        cell?.iconImageView.contentMode = .scaleAspectFill
        cell?.iconImageView.layer.cornerRadius = (cell?.iconImageView.frame.height)! / 2
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ViewConfig.kCellHeight
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        
        let allertController = UIAlertController(title: "Delete \(entities[indexPath.row].name)", message: "Are you sure?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.entities.remove(at: indexPath.row)
            UserDefaultManager.shared.save(array: self.entities, forKey: .allEntities)
            allertController.dismiss(animated: true, completion: nil)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            allertController.dismiss(animated: true, completion: nil)
        }
        
        allertController.addAction(deleteAction)
        allertController.addAction(cancelAction)
        present(allertController, animated: true, completion: nil)
        
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntity = entities[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "EntityDetailsViewController") as! EntityDetailsViewController
        
        vc.currentEntity = selectedEntity
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension RootViewController: NewEntityViewContollerDelegate {
    func newEntityViewController(_ controller: NewEntityViewController, didCreateEntity entity: BirthdayEntity) {
        entities.append(entity)
        UserDefaultManager.shared.save(array: entities, forKey: .allEntities)
        guard let index = entities.firstIndex(of: entity) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        birthdayListTableView.insertRows(at: [indexPath], with: .fade)
    }
}
