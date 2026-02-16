import { createConsumer } from "@rails/actioncable"

// Make ActionCable available globally for inline scripts
window.ActionCable = { createConsumer }
