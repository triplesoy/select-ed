import { Controller } from "@hotwired/stimulus"
import { end } from "@popperjs/core";

// Connects to data-controller="redeem"
export default class extends Controller {
  connect() {
    console.log("conectado")
  }

  redeemCode(e) {
    e.preventDefault();
    console.log(e.target)
    const code = e.target.querySelector('.code').value;

    fetch(`/tickets/${e.target.dataset.id}/redeem?code=${code}`, {
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
      }
    })
    .then(response => response.json())
    .then((data) => {
      if (!data.error) {
        const buyBtn = e.target.parentElement.querySelector('.buy');
        e.target.classList.add('d-none');
        buyBtn.classList.remove('d-none');
      } else {
        window.alert(data.error);
      }

    });
  }
}
