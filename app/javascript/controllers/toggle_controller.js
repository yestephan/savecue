import { Controller } from "stimulus";

export default class extends Controller {
	static targets = ["toggleBtn", "content"];

	toggle(event) {
		const currentBtn = event.currentTarget;
		const allButtons = this.toggleBtnTargets;
		const content = this.contentTargets;

		allButtons.forEach((element) => {
			element.classList.remove("active");
		});

		currentBtn.classList.add("active");

		console.log(currentBtn.dataset.value);

		content.forEach((element) => {
			element.classList.add("hidden");
			if (element.dataset.value == currentBtn.dataset.value) {
				console.log(element.dataset.value);
				element.classList.remove("hidden");
			}
		});
	}
}
