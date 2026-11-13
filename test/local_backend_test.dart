import 'package:flutter_test/flutter_test.dart';
import 'package:rayan_garden/data/local/local_simulated_backend.dart';

void main() {
  test('local backend exposes active seasonal offers', () {
    expect(LocalSimulatedBackend.offers, hasLength(3));
    expect(LocalSimulatedBackend.offers.map((offer) => offer.code), contains('VIP15'));
  });

  test('Iranian mobile OTP simulation registers a VIP customer', () {
    final backend = LocalSimulatedBackend(clock: () => DateTime.utc(2026, 11, 13));
    final otp = backend.requestOtp('+989123456789');
    expect(otp.phone, '09123456789');
    expect(otp.testCode, '1234');
    final customer = backend.verifyOtp(rawPhone: otp.phone, name: 'علی رضایی', code: '1234');
    expect(customer.phone, '09123456789');
    expect(backend.customers, hasLength(1));
  });

  test('promotional SMS simulation reports all registered recipients', () {
    final backend = LocalSimulatedBackend();
    final otp = backend.requestOtp('09123456789');
    backend.verifyOtp(rawPhone: otp.phone, name: 'Test Customer', code: otp.testCode);
    final result = backend.sendPromotionalSms();
    expect(result.recipientCount, 1);
    expect(result.offerTitle, isNotEmpty);
  });
}
