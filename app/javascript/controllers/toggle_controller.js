import { Controller } from "stimulus";

export default class extends Controller {
	static targets = ["toggleBtn", "content"];

	toggle(event) {
		const currentBtn = event.currentTarget;
		const allButtons = this.toggleBtnTargets;
		const content = this.contentTargets;

		allButtons.forEach((element) => {
			element.classList.toggle("active");
		});

		content.forEach((element) => {
			element.classList.toggle("hidden");
		});
	}
}
