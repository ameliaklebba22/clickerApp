
class players{
    
    var name: String
    var score: Int
    var date: String
    
    
    init(n: String, s: Int, d: String){
        name = n
        score = s
        date = d
        
        
        
        
    }

}



import UIKit
import Firebase
import FirebaseFirestoreSwift


class scoreboardView: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    var names: [String] = []
    var scores: [Int] = []
    @IBOutlet weak var tableView: UITableView!
    let database = Firestore.firestore()
    var show: [players] = []
    var dates: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        arraySetup()
        
        let docRef = database.document("people/players")
        docRef.getDocument { snapshot, error in
        guard let data = snapshot?.data(), error == nil else{
        return
        }
        guard let text = data["leaders"] as? [String] else {
        return
        }
        self.names = text
        self.arraySetup()
        self.tableView.reloadData()
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
        self.arraySetup()
        self.tableView.reloadData()
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
        self.arraySetup()
        self.tableView.reloadData()
        }
        
        
        
        
        
        
        
    }
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        show.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CrazyCell
        
       

        
        
        
    cell.nameLabel?.text = show[indexPath.row].name
    cell.scoreLabel?.text = String(show[indexPath.row].score)
    cell.dateLabel?.text = show[indexPath.row].date
    return cell
        
    }
    
    
    
    func arraySetup(){
    show = []
    var x = 0
    while x < names.count{
    show.append(players.init(n: names[x], s: scores[x], d: dates[x]))
        
    x += 1
    }
    show = show.sorted(by: { $0.score > $1.score })
    if show.count > 10{
    var hmm = show.count
    while hmm > 10{
    show.remove(at: hmm - 1)
    hmm -= 1
    }
    }
    }
    
    
    
}
