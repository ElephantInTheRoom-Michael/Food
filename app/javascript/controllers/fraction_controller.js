import { Controller } from "@hotwired/stimulus";

import { toFraction } from "utils/fractions";

export default class extends Controller {
  static targets = ["input", "fraction"];

  onInput() {
    this.fractionTarget.textContent = toFraction(this.inputTarget.value);
  }
}
