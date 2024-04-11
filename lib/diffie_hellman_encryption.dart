import 'package:flutter/material.dart';
import 'dart:math';

class DiffieHellmanPage extends StatelessWidget {
  const DiffieHellmanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diffie-Hellman Key Exchange'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text(
              'Diffie-Hellman Key Exchange',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              'What is Diffie-Hellman?',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Diffie-Hellman key exchange is a method of securely exchanging cryptographic keys over a public channel. It allows two parties to establish a shared secret key without ever transmitting the key.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'How does it work?',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              '1. Both parties agree on a large prime number (p) and a base value (g).\n'
              '2. Each party generates a private key (a and b, respectively).\n'
              '3. They calculate their public keys (A and B) using the formula: A = g^a % p, B = g^b % p.\n'
              '4. They exchange public keys.\n'
              '5. Finally, each party computes the shared secret key using the received public key and its own private key.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Flutter Code Example',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Here\'s a simple Flutter code example demonstrating the Diffie-Hellman key exchange algorithm:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            CodeBlock(
              code: '''
import 'dart:math';

void main() {
  int p = 23; // Prime number
  int g = 5; // Base value
  int privateA = Random().nextInt(p - 2) + 1; // 1 <= privateA <= p-2
  int privateB = Random().nextInt(p - 2) + 1; // 1 <= privateB <= p-2
  int publicA = modPow(g, privateA, p);
  int publicB = modPow(g, privateB, p);
  int sharedSecretA = modPow(publicB, privateA, p);
  int sharedSecretB = modPow(publicA, privateB, p);

  print('Shared Secret A: \$sharedSecretA');
  print('Shared Secret B: \$sharedSecretB');
}

int modPow(int base, int exponent, int modulus) {
  int result = 1;
  base = base % modulus;
  while (exponent > 0) {
    if (exponent % 2 == 1) {
      result = (result * base) % modulus;
    }
    exponent = exponent >> 1;
    base = (base * base) % modulus;
  }
  return result;
}
              ''',
            ),
          ],
        ),
      ),
    );
  }
}

class CodeBlock extends StatelessWidget {
  final String code;

  const CodeBlock({
    Key? key,
    required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Text(
        code,
        style: const TextStyle(fontFamily: 'monospace'),
      ),
    );
  }
}
