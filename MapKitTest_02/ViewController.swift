import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var hybridBtn: UIBarButtonItem!
    @IBOutlet weak var standardBtn: UIBarButtonItem!
    @IBOutlet weak var satelliteBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(latitude: 35.165841, longitude: 129.072530)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 300, longitudinalMeters: 300)
        
        let marker = MKPointAnnotation()
        
        marker.coordinate = location
        marker.title = "동의과학대학교"
        marker.subtitle = "DIT"
        
        mapView.addAnnotation(marker)
        
        mapView.mapType = MKMapType.hybrid
        setEnables(hybrid: false, standard: true, satellite: true)
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func changeHybrid(_ sender: Any) {
        mapView.mapType = MKMapType.hybrid
        setEnables(hybrid: false, standard: true, satellite: true)
    }
    
    @IBAction func changeStandard(_ sender: Any) {
        mapView.mapType = MKMapType.standard
        setEnables(hybrid: true, standard: false, satellite: true)
    }
    
    @IBAction func changeSatellite(_ sender: Any) {
        mapView.mapType = MKMapType.satellite
        setEnables(hybrid: true, standard: true, satellite: false)
    }
    
    func setEnables(hybrid: Bool, standard : Bool, satellite : Bool) {
        hybridBtn.isEnabled = hybrid
        standardBtn.isEnabled = standard
        satelliteBtn.isEnabled = satellite
    }
}
