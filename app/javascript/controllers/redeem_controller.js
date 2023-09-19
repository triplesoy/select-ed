import { Controller } from "@hotwired/stimulus";import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["code", "buy", "form"];

  redeemCode(event) {
    event.preventDefault();

    const code = this.codeTarget.value;
    const buyButton = this.buyTarget;
    const form = this.formTarget;
    const ticketId = form.getAttribute("data-ticket-id"); // Assuming you set this attribute in your form

    fetch(`/tickets/${ticketId}/redeem?code=${code}`, {
      headers: {
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.code) {
        form.classList.add("d-none"); // Hide the form
        buyButton.classList.remove("d-none"); // Show the "Get your ticket" button
        buyButton.classList.add("d-block");
      } else {
        alert("Wrong code");
      }
    })
    .catch(error => {
      console.error("There was an error redeeming the code", error);
    });
  }
}
