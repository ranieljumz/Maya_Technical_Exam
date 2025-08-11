// src/api/wallet/controllers/wallet.js
'use strict';

module.exports = {
  async send(ctx) {
    const { recipientMobile, amount } = ctx.request.body;
    const sender = ctx.state.user; // Strapi automatically attaches the authenticated user here

    if (!recipientMobile || !amount) {
      return ctx.badRequest('Recipient mobile number and amount are required.');
    }

    if (amount <= 0) {
      return ctx.badRequest('Amount must be positive.');
    }

    // Ensure we are working with numbers
    const transferAmount = parseFloat(amount);
    
    // 1. Check if sender has enough balance
    if (sender.balance < transferAmount) {
      return ctx.badRequest('Insufficient balance.');
    }

    // 2. Find the recipient user
    const recipient = await strapi.db.query('plugin::users-permissions.user').findOne({
      where: { username: recipientMobile },
    });

    if (!recipient) {
      return ctx.notFound('Recipient not found.');
    }

    if (recipient.id === sender.id) {
        return ctx.badRequest('Cannot send money to yourself.');
    }

    try {
      // 3. Perform the transaction atomically
      await strapi.db.transaction(async ({ trx }) => {
        // Debit sender
        await trx('up_users').where({ id: sender.id }).update({
          balance: sender.balance - transferAmount,
        });

        // Credit recipient
        await trx('up_users').where({ id: recipient.id }).update({
          balance: recipient.balance + transferAmount,
        });

        // Create transaction log for sender (debit)
        await strapi.entityService.create('api::transaction.transaction', {
          data: {
            amount: transferAmount,
            sender: sender.id,
            recipient: recipient.id,
            txnStatus: 'success',
            type: 'debit',
            publishedAt: new Date(), // Important for it to be visible via API
          },
        });
        
        // Create transaction log for recipient (credit)
        await strapi.entityService.create('api::transaction.transaction', {
            data: {
              amount: transferAmount,
              sender: sender.id,
              recipient: recipient.id,
              txnStatus: 'success',
              type: 'credit',
              publishedAt: new Date(),
            },
          });
      });

      return ctx.send({ message: 'Transaction successful!' });

    } catch (error) {
      console.error('Transaction Error:', error);
      return ctx.internalServerError('An error occurred during the transaction.');
    }
  },
};