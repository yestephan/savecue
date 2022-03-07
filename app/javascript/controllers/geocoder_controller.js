// app/javascript/controllers/geocoder_controller.js
import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

export default class extends Controller {
  static values = { apiKey: String }

  static targets = ["metadata"]

  connect() {
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "country,region,place,postcode,locality,neighborhood,address"
    });
    this.geocoder.addTo(this.element);
    this.geocoder.on("result", event => this.#setInputValue(event));
    this.geocoder.on("clear", () => this.#clearInputValue());
    this.geocoder.setPlaceholder(this.metadataTarget.value);
  }

  #setInputValue(event) {
    this.metadataTarget.value = event.result["place_name"];
  }

  #clearInputValue() {
    this.metadataTarget.value = "";
  }
}
