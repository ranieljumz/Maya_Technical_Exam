// src/api/wallet/routes/wallet.js
module.exports = {
  routes: [
    {
      method: 'POST',
      path: '/wallet/send', // Our custom endpoint
      handler: 'wallet.send',
      config: {
        policies: [],
        middlewares: [],
      },
    },
  ],
};