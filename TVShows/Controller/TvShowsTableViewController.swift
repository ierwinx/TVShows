import UIKit
import SkeletonView

class TvShowsTableViewController: UITableViewController {
    
    //MARK: Propiedades
    private let cellName: String = "CeldaPeliculaTableViewCell"
    private var tvShows: Array<TvShowRes> = []
    private var seleccion: Int!
    
    //MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        disenoBarra()
        self.startSkeleton()
        self.traerInformacion()
        self.tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    //MARK: Metodos
    private func disenoBarra() -> Void {
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = UIColor(named: "Barras")
            UIApplication.shared.windows.first?.addSubview(statusBar)
        }
    }
    
    private func traerInformacion() -> Void {
        let tvShowService = TvShowService()
        tvShowService.consulta { (error, resultado) in
            DispatchQueue.main.async {
                self.stopSkeleton()
                if error != nil {
                    self.alertaRecarga()
                    return
                }
                self.tvShows = resultado
                self.tableView.reloadData()
            }
        }
    }
    
    private func alertaRecarga() -> Void {

        Alertas.errorInternet(controlador: self) { (res) in
            if res {
                self.traerInformacion()
            }
        }
        
    }
    
    private func startSkeleton() -> Void {
        self.tableView.showAnimatedGradientSkeleton()
    }
    
    private func stopSkeleton() -> Void {
        self.tableView.hideSkeleton()
    }
    
    // MARK: - Data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! CeldaPeliculaTableViewCell
        celda.llenarInfo(tvShows: tvShows[indexPath.row])
        return celda
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let serie = self.tvShows[indexPath.row]
        
        let serieEncontrada = ShowsRepository.consultar(id: serie.id!)
        
        var swipeActions = UISwipeActionsConfiguration()
        
        let accion = UIContextualAction(style: .normal, title: serieEncontrada == nil ? "Favoritos" : "Eliminar") {  (contextualAction, view, boolValue) in
            if serieEncontrada == nil {
                self.present(Alertas.eliminaGuarda(status: ShowsRepository.guardar(tvShow: self.tvShows[indexPath.row]), eliminar: false), animated: true, completion: nil)
            } else {
                Alertas.preguntaEliminar(controlador: self) { (res) in
                    if res {
                        let res = serieEncontrada == nil ? ShowsRepository.guardar(tvShow: self.tvShows[indexPath.row]) : ShowsRepository.eliminar(id: serie.id!)
                        self.present(Alertas.eliminaGuarda(status: res, eliminar: serieEncontrada != nil), animated: true, completion: nil)
                    }
                }
            }
        }
        accion.backgroundColor = serieEncontrada == nil ? .green : .red
        swipeActions = UISwipeActionsConfiguration(actions: [accion])
        
        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    //MARK: Delegados
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seleccion = indexPath.row
        performSegue(withIdentifier: "detalle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detalle" {
            let detalle = segue.destination as! DetalleViewController
            let serie = tvShows[seleccion]
            detalle.idTvShow = serie.id
            detalle.tvShowRes = serie
        }
    }
    
}
