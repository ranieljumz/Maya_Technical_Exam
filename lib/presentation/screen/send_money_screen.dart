import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mayaapp/presentation/cubit/auth/auth_cubit.dart';
import 'package:mayaapp/presentation/cubit/send_money/send_money_cubit.dart';
import 'package:mayaapp/service_locator.dart';

class SendMoneyScreen extends StatelessWidget {
  final _mobileController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SendMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SendMoneyCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Send Money')),
        body: BlocListener<SendMoneyCubit, SendMoneyState>(
          listener: (context, state) {
            if (state is SendMoneySuccess || state is SendMoneyFailure) {
              _showResultModal(context, state);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Recipient',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 11,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Recipient\'s Mobile Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      counterText: "",
                    ),
                    validator: (v) => (v == null || v.length != 11)
                        ? 'Enter a valid 11-digit number'
                        : null,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Amount',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Amount to Send',
                      prefixText: '₱ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) {
                      if (v == null ||
                          v.isEmpty ||
                          double.tryParse(v) == null ||
                          double.parse(v) <= 0) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  BlocBuilder<SendMoneyCubit, SendMoneyState>(
                    builder: (context, state) {
                      if (state is SendMoneyLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final user = context
                                .read<AuthCubit>()
                                .loggedInUser!;
                            context.read<SendMoneyCubit>().executeSendMoney(
                              user,
                              _mobileController.text,
                              double.parse(_amountController.text),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue[700],
                        ),
                        child: const Text(
                          'Confirm Transaction',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showResultModal(BuildContext context, SendMoneyState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        bool isSuccess = state is SendMoneySuccess;
        return Container(
          padding: const EdgeInsets.all(24),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.cancel,
                color: isSuccess ? Colors.green : Colors.red,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                isSuccess ? 'Transaction Successful!' : 'Transaction Failed',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isSuccess
                    ? 'The amount has been sent.'
                    : (state as SendMoneyFailure).message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // After modal is closed, if successful, pop the send money screen
      if (state is SendMoneySuccess) {
        Navigator.of(context).pop();
      }
    });
  }
}
