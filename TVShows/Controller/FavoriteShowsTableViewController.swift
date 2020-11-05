import UIKit
import CoreData

class FavoriteShowsTableViewController: UITableViewController {
    
    //MARK: Propiedades
    private let cellName: String = "CeldaPeliculaTableViewCell"
    private var seleccion: Int!
    private var tvShows: Array<NSManagedObject> = []

    //MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        cargaDatos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargaDatos()
    }
    
    //MARK: Metodos
    private func cargaDatos() -> Void {
        disenoBarra()
        let datos = ShowsRepository.consultar()
        if datos.count > 0 {
            tvShows = datos
            self.tableView.reloadData()
        }
        self.tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    private func disenoBarra() -> Void {
        if #available(iOS 13.0, *) {
            let app = UINavigationBarAppearance()
            app.backgroundColor = UIColor(named: "Barras")
            self.navigationController?.navigationBar.scrollEdgeAppearance = app
        }
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "BarraTexto")
        self.navigationController?.navigationBar.tintColor = UIColor(named: "BarraTexto")
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "Barras")
    }
    
    private func alerta(status: Bool) -> Void {
        let titulo = status ? "Eliminado" : "Oops, algo salió mal!"
        let mensaje = status ? "Se elimino de favoritos" : "Hubo un problema al eliminar este show de TV"
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alerta, animated: true, completion: nil)
    }

    // MARK: Data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvShows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! CeldaPeliculaTableViewCell
        let serie = tvShows[indexPath.row] as! Series
        celda.llenarDatosBase(tvShow: serie)
        return celda
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let eliminar = UIContextualAction(style: .destructive, title: "Eliminar") {  (contextualAction, view, boolValue) in
            let alerta = UIAlertController(title: "Eliminar", message: "¿Deseas eliminar de favoritos?", preferredStyle: .alert)
            let si = UIAlertAction(title: "Si", style: .destructive) { accion in
                let serie = self.tvShows[indexPath.row] as! Series
                let elimina = ShowsRepository.eliminar(id: Int(serie.id))
                self.alerta(status: elimina)
                if elimina {
                    self.tvShows.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }
            let no = UIAlertAction(title: "No", style: .default, handler: nil)
            alerta.addAction(si)
            alerta.addAction(no)
            
            self.present(alerta, animated: true, completion: nil)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [eliminar])
        return swipeActions
    }
    
    //MARK: Delegados
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seleccion = indexPath.row
        performSegue(withIdentifier: "detalle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalle" {
            let detalle = segue.destination as! DetalleViewController
            let serie = tvShows[seleccion] as! Series
            detalle.tvShow = serie
        }
    }
    
}
