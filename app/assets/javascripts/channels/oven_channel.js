document.addEventListener("DOMContentLoaded", function() {
  const ovenInfoElement = document.querySelector('.cookie-info')
  App.oven = App.cable.subscriptions.create({
    channel: "OvenChannel",
    oven_id: ovenInfoElement.getAttribute('data-number')
  }, {
    connected: function() {
      console.log('connected');
    },
    disconnected: function() {

    },
    received: function(data) {
      console.log(data);
      if (! data.message.ready) {
        return false;
      }

      const ovenEl = document.querySelector('[data-id="oven-' + data.message.oven_id + '"]');
      const cookieEl = ovenEl.querySelector('[data-id="cookie-' + data.message.cookie_id + '"]');
      const retrieveEl = cookieEl.querySelector('.retrieve')
      retrieveEl.style.display = 'block';
    },
    send_message: function(message, oven_id) {
      this.perform('send_message', {message: message, oven_id: oven_id})
    }
  })
});