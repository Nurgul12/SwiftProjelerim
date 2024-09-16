//
//  DetailsVC.swift
//  ArtBookProject
//
//  Created by Nurgül Ergünöz on 18.04.2024.
//

import UIKit
import CoreData

class DetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var artistText: UITextField!
    
    @IBOutlet weak var yearText: UITextField!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    var chosenPainting = ""
    var chosenPaintingId : UUID?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if chosenPainting != "" {
            // .isEneabled gözükür ama tıklanmaz.
            saveButton.isHidden = true
            
            //Core Data
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            //filtreleme
            let idString = chosenPaintingId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {      //dizi verir
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let name = result.value(forKey: "name") as? String {
                            nameText.text = name
                        }
                        
                        if let artist = result.value(forKey: "artist") as? String {
                            artistText.text = artist
                        }
                        
                        if let year = result.value(forKey: "year") as? Int {
                            yearText.text = String(year)
                        }
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                        
                    }
                }
                
            } catch{
                print("error")
            }
            
            
        } else {
            saveButton.isHidden = false
            saveButton.isEnabled = false
            nameText.text = ""
            artistText.text = ""
            yearText.text = ""
        }
        
        
        
        
        //Recognizers
        // kullanıcı ekrana herhangi bir yere dokunduğunda bir işlevi tetikleyen
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        
        //kullanıcı görsele tıklama
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)

        
    }
    @objc func selectImage() {
        
        
        //galeriye gitmek için picker
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
          
      }
    
    //kullanıcı resmi seçtikten sonra ne olacak
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        saveButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
      }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // context içine ne koycam
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        //Attributes
        
        newPainting.setValue(nameText.text!, forKey: "name")
        newPainting.setValue(artistText.text!, forKey: "artist")
        
        if let year = Int(yearText.text!) {
            newPainting.setValue(year, forKey: "year")
        }
        
        newPainting.setValue(UUID(), forKey: "id")
        
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        
        newPainting.setValue(data, forKey: "image")
        
        do {
            try context.save()
            print("success")
        } catch {
            print("error")
        }
        // viewcontroler arası mesaj yollama
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        //önceki viewcontrollera gitmek
        self.navigationController?.popViewController(animated: true)
        
        
    }
    


}
