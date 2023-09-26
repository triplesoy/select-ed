import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["code", "form"];
  static values = { postUrl: String }; // Define postUrl as a static value

  // This method is triggered when the user tries to redeem a code
  redeemCode(event) {
    event.preventDefault(); // Prevent the default form submission behavior

    // Get the value of the code from the input field
    const code = this.codeTarget.value;
    // Get the ticketId from the data attribute of the element
    const ticketId = this.element.getAttribute("data-ticket-id-value");
    // Construct the redeemUrl using the ticketId and code
    const redeemUrl = `/tickets/${ticketId}/redeem?code=${code}`;
    // Access the postUrl value
    const postUrl = this.postUrlValue;

    // Call the fetchRedeemCode method with the redeemUrl
    this.fetchRedeemCode(redeemUrl)
      .then(data => {
        if (data.code) {
          // Log the postUrl to the console if the code is present in the response data
          alert("Code is correct, ticket will be generated!!");
          console.log('Post URL:', postUrl);
          // Call the postTicket method with the postUrl
          this.postTicket(postUrl);
        } else {
          // Alert the user if the wrong code is entered
          alert("Wrong code wey!");
        }
      })
      .catch(error => {
        // Log any errors that occur during the redeem code process
        console.error("There was an error redeeming the code", error);
      });
  }

  // This method fetches the redeem code from the server
  fetchRedeemCode(url) {
    return fetch(url, {
      headers: {
        'Accept': 'application/json' // Set the Accept header to expect a JSON response
      }
    })
    .then(response => response.json()); // Parse the JSON response
  }

  // This method posts the ticket to the server
  postTicket(url) {
    fetch(url, {
      method: 'POST', // Set the HTTP method to POST
      headers: {
        'Accept': 'text/html', // Set the Accept header to expect an HTML response
        'X-CSRF-Token': this.getCsrfToken() // Include the CSRF token for Rails
      }
    })
    .then(response => {
      if (response.ok) {
        if (response.redirected) {
          // Redirect the user to the URL provided by the server if the response is a redirection
          window.location.href = response.url;
        } else {
          // Handle other successful responses, e.g., update the DOM
        }
      } else {
        return response.json().then(data => {
          // Log the error message from the server and reject the promise with the error data
          console.error('Server Error:', data.error);
          return Promise.reject(data);
        });
      }
    })
    .catch(error => {
      // Log any errors that occur during the ticket creation process
      console.error('Error creating ticket:', error);
    });
  }

  // This method gets the CSRF token from the meta tag
  getCsrfToken() {
    const metaTag = document.querySelector('meta[name="csrf-token"]'); // Select the meta tag with the name "csrf-token"
    return metaTag ? metaTag.content : ''; // Return the content of the meta tag or an empty string if the meta tag is not found
  }
}
