import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  redeemCode(e) {
    e.preventDefault();
    console.log("Redeeming code...");

    const codeInput = e.target.querySelector('.code');
    const code = codeInput.value;

    fetch(`/tickets/${e.target.dataset.id}/redeem?code=${code}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Code verification failed");
      }
      return response.json();
    })
    .then((data) => {
      console.log("Code verified. Buying ticket...");

      if (!data.error) {
        const redeemURL = e.target.parentElement.querySelector('.buy').href;
        console.log(`Redeem URL: ${redeemURL}`);

        return fetch(redeemURL, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
          }
        });
      } else {
        throw new Error(data.error);
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Ticket redemption failed");
      }
      window.alert("Ticket redeemed successfully!");
    })
    .catch(error => {
      console.error(error);
      window.alert(error.message);
    })
    .finally(() => {
      codeInput.value = ""; // Clear the input
    });
  }
}
