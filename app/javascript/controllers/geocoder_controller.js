// app/javascript/controllers/geocoder_controller.js
import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

export default class extends Controller {
  static values = { apiKey: String }

  static targets = ["location", "latitude", "longitude"]

  connect() {
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "country,region,place,postcode,locality,neighborhood,address"
    });
    this.geocoder.addTo(this.element);
    this.geocoder.on("result", event => this.#setInputValue(event));
    this.geocoder.on("clear", () => this.#clearInputValue());
    this.geocoder.setPlaceholder(this.locationTarget.value);
  }

  #setInputValue(event) {
    console.log(event);
    this.locationTarget.value = event.result["place_name"];
    this.latitudeTarget.value = event.result["center"][0];
    this.longitudeTarget.value = event.result["center"][1];
  }

  #clearInputValue() {
    this.locationTarget.value = "";
  }
}
