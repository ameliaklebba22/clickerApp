
import UIKit
import Firebase
import FirebaseFirestoreSwift

class GameViewController: UIViewController {

    @IBOutlet weak var bugLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var meerkatImage: UIImageView!
    var score = 0
    var timeRemaning: Int = 30
    var timer: Timer!
    var otherName = "Bill"
    var names: [String] = []
    var scores: [Int] = []
    var dates: [String] = []
    let database = Firestore.firestore()
    var add = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let docRef = database.document("people/players")
        docRef.getDocument { snapshot, error in
        guard let data = snapshot?.data(), error == nil else{
        return
        }
        guard let text = data["leaders"] as? [String] else {
        return
        }
        self.names = text
        }
        
        let kocRef = database.document("score/numbers")
        kocRef.getDocument { snapshot, error in
        guard let data = snapshot?.data(), error == nil else{
        return
        }
        guard let text = data["top"] as? [Int] else {
        return
        }
        self.scores = text
        }
        
        let locRef = database.document("day/date")
        locRef.getDocument { snapshot, error in
        guard let data = snapshot?.data(), error == nil else{
        return
        }
        guard let text = data["current"] as? [String] else {
        return
        }
        self.dates = text
        }
        
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("oh...")
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
    
    }
    
    
    @objc func step(){
        if timeRemaning > 0 {
        timeRemaning -= 1
        }
        if timeRemaning == 0{
        timer.invalidate()
        let alert = UIAlertController(title: "Timer is up!", message: "You finished with \(score) bugs. Enter name to send score to global leader board.", preferredStyle: .alert);            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { [self] ale in
                guard let fields = alert.textFields, fields.count == 1 else{
                return
                }
                
                let crazy = fields[0]
                otherName = crazy.text!
                names.append(otherName)
                scores.append(score)
                //date stuff...
                let currentDateTime = Date()
                let userCalendar = Calendar.current
                let requestedComponents: Set<Calendar.Component> = [
                .year,
                .month,
                .day
                ]
                let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
                let year = dateTimeComponents.year!
                let month = dateTimeComponents.month!
                let day = dateTimeComponents.day!
                let date =  String("\(day)/\(month)/\(year)")
               
                dates.append(date)
          
                
                
                let peopleRef = database.document("people/players")
                peopleRef.updateData(["leaders": names])
                let scoreRef = database.document("score/numbers")
                scoreRef.updateData(["top": scores])
                let dateRef = database.document("day/date")
                dateRef.updateData(["current": dates])
              
                }))
        
               //adding fields
               alert.addTextField { field in
               field.placeholder = "name"
               field.returnKeyType = .next
               field.keyboardType = .default
               }
            present(alert, animated: true)
           

        }
        
        else{
            
            }
        
        
        timeLabel.text = "\(timeRemaning)"
       
    }
    
    

    @IBAction func playAgain(_ sender: Any) {
        timer.invalidate()
        timeRemaning = 30
        timeLabel.text = String(30)
        score = 0
        add = 1
        meerkatImage.image = UIImage(named: "yum")
        bugLabel.text = String(0)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
    }
    
    
    
    @IBAction func tappedMeerkat(_ sender: Any) {
        score = score + add
        
        if score == 50{
        add = 4
            meerkatImage.image = UIImage(named: "one")
            
        }
        
        if score == 202{
        add = 11
            meerkatImage.image = UIImage(named: "two")
        
        }
        
    if score > 1000{
        add = 21
            meerkatImage.image = UIImage(named: "three")
        }
        
        
        bugLabel.text = String(score)
        
    }
    
    
    
    
}
