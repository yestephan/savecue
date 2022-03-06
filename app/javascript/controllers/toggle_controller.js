import { Controller } from "stimulus";

export default class extends Controller {
	static targets = ["dashBtn", "cues", "transactions", "toggleBtn"];

	toggle(event) {
		const current = event.currentTarget;
		console.log(current);
	}
}
