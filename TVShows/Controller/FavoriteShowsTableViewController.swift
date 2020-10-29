import UIKit

class FavoriteShowsTableViewController: UITableViewController {
    
    //MARK: Propiedades
    private let cellName: String = "CeldaPeliculaTableViewCell"
    private var seleccion: Int!

    //MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        disenoBarra()
        self.tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    //MARK: Metodos
    private func disenoBarra() -> Void {
        if #available(iOS 13.0, *) {
            let app = UINavigationBarAppearance()
            app.backgroundColor = UIColor(named: "Barras")
            self.navigationController?.navigationBar.scrollEdgeAppearance = app
        }
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "Barras")
    }
    
    private func alerta() -> Void {
        let alerta = UIAlertController(title: "Eliminar", message: "¿Deseas eliminar de favoritos?", preferredStyle: .alert)
        let si = UIAlertAction(title: "Si", style: .destructive) { accion in
            
        }
        let no = UIAlertAction(title: "No", style: .default, handler: nil)
        alerta.addAction(si)
        alerta.addAction(no)
        
        present(alerta, animated: true, completion: nil)
    }

    // MARK: Data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! CeldaPeliculaTableViewCell
        return celda
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let eliminar = UIContextualAction(style: .destructive, title: "Eliminar") {  (contextualAction, view, boolValue) in
            self.alerta()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [eliminar])
        return swipeActions
    }
    
    //MARK: Delegados
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seleccion = indexPath.row + 1
        performSegue(withIdentifier: "detalle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalle" {
            let detalle = segue.destination as! DetalleViewController
            detalle.id = seleccion
        }
    }
    
}
