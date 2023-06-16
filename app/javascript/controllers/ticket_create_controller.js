import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ticket-create"
export default class extends Controller {
  connect() {
    console.log("conectate esta")
  }

  addTicketField(e) {
    console.log("anadiendo nuevo campo de ticket")
  }
}
