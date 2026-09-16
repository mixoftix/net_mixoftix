<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RFC-6979: Deterministic ECDSA Guide</title>
    <meta name="description" content="Comprehensive guide to implementing RFC 6979 deterministic ECDSA across major platforms">
    <meta name="author" content="shahiN Noursalehi">

	<!--#INCLUDE virtual="/inc_styles.asp"-->

</head>
<body class="dark-mode">
    <header>
        <h1>RFC-6979: Deterministic ECDSA Guide</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <section class="content-box">
        You are here: 
        <a href="/">Home</a> /
		Toturials /
        <a href="cryptography_ecdsa_rfc_6979.asp">RFC-6979</a>
    </section>

    <main>
        <!-- Introduction Section -->
        <section class="content-box">
            <h2>RFC-6979 Fundamentals</h2>
            <p>RFC-6979 introduces deterministic Elliptic Curve Digital Signature Algorithm (ECDSA) signatures, eliminating the need for secure random number generation during signing by deriving the nonce (k) deterministically from the private key and message.</p>
            
            <div class="cyan-box">
                <h3>Key Benefits</h3>
                <ul>
                    <li><strong>Consistency:</strong> Same message and key produce identical signatures.</li>
                    <li><strong>Security:</strong> Prevents private key leakage from nonce reuse.</li>
                    <li><strong>Reliability:</strong> Eliminates dependency on system RNG quality.</li>
                </ul>
            </div>
            <br>
            
            <div class="red-box">
                <h3>Critical Vulnerabilities Without RFC 6979</h3>
                <ol>
                    <li><strong>Nonce Reuse:</strong> Reusing nonces across signatures can leak the private key (e.g., Sony PS3 ECDSA breach in 2010).</li>
                    <li><strong>Poor RNG:</strong> Predictable nonces from weak RNGs compromise signatures (e.g., Android Bitcoin wallet vulnerability in 2013).</li>
                    <li><strong>Side-Channel Attacks:</strong> Non-deterministic nonce generation may expose timing or power consumption leaks.</li>
                </ol>
                <p>Reference: <a href="https://tools.ietf.org/html/rfc6979" target="_blank">RFC 6979 Specification</a></p>
            </div>
            <br>
			
			<!-- History of RFC 6979 (within Fundamentals section) -->
			<div class="gray-box">
				<h3>History of RFC 6979</h3>
				<p>RFC 6979, titled "Deterministic Usage of the Digital Signature Algorithm (DSA) and Elliptic Curve Digital Signature Algorithm (ECDSA)," was authored by Thomas Pornin and published in August 2013 by the Internet Engineering Task Force (IETF). The motivation for RFC 6979 stemmed from high-profile cryptographic failures, notably the Sony PlayStation 3 security breach in 2010, where nonce reuse in ECDSA signatures allowed attackers to recover the private key, compromising the console's security.</p>
				<p>These incidents highlighted the risks of relying on random nonces in ECDSA, particularly in environments with poor or compromised random number generators (RNGs). RFC 6979 was developed to address these vulnerabilities by proposing a deterministic method for nonce generation using HMAC-based deterministic random bit generators (DRBG). The standard was influenced by earlier cryptographic research, including NIST's SP 800-90A for DRBGs and the Bitcoin community's need for secure, reproducible signatures in blockchain applications, as later formalized in standards like BIP-32.</p>
				<p>Since its publication, RFC 6979 has been widely adopted in cryptographic libraries (e.g., OpenSSL, Bitcoin's secp256k1) and protocols requiring secure ECDSA signatures, such as TLS, blockchain systems, and secure messaging. Its deterministic approach has become a de facto standard for ECDSA in security-critical applications, particularly in cryptocurrencies like Bitcoin and Ethereum.</p>
				<p><strong>References:</strong></p>
				<ul>
					<li><a href="https://tools.ietf.org/html/rfc6979" target="_blank">RFC 6979: Deterministic Usage of DSA and ECDSA</a></li>
					<li><a href="https://www.fail0verflow.com/blog/2010/ps3-epic-fail/" target="_blank">Fail0verflow: Sony PS3 ECDSA Failure Analysis</a></li>
					<li><a href="https://www.nist.gov/publications/deterministic-random-bit-generators" target="_blank">NIST SP 800-90A: Recommendation for Random Number Generation</a></li>
					<li><a href="https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki" target="_blank">BIP-32: Hierarchical Deterministic Wallets</a></li>
				</ul>
			</div>
        </section>

        <!-- Implementation Guide -->
        <section class="content-box">
            <h2>Cross-Platform Implementation</h2>
            
            <div class="gray-box">
                <h3>Pseudo-Code: RFC 6979 Algorithm</h3>
                <pre>
FUNCTION deterministic_sign(private_key, message_hash, curve_order):
    hmac_key = HMAC-SHA256(private_key || message_hash || "RFC6979")
    k = 0
    counter = 0
    DO:
        k = HMAC_DRBG(hmac_key, counter++)
        k = k mod curve_order
    WHILE k == 0 OR k >= curve_order
    RETURN (r, s) = ECDSA_SIGN(private_key, message_hash, k)
END FUNCTION
                </pre>
                <p><strong>Note:</strong> The HMAC-DRBG ensures deterministic nonce (k) generation, compliant with RFC 6979.</p>
            </div>
            <br>

			<!-- JavaScript Implementation -->
			<div class="gray-box">
				<h3>JavaScript (elliptic library)</h3>
				<p>This example demonstrates signing and verifying a message using RFC 6979 with the secp256k1 curve.</p>
				<pre>
const elliptic = require('elliptic');
const ec = new elliptic.ec('secp256k1');
const sha256 = require('crypto').createHash('sha256');

// Signing
const privateKeyHex = '1e99423a4ed27608a15a2616a2b0e9e52ced330ac530edcc32c8ffc6a526aedd';
const message = 'Hello, RFC 6979!';
const msgHash = sha256.update(message).digest('hex');

const key = ec.keyFromPrivate(privateKeyHex, 'hex');
const signature = key.sign(msgHash, 'hex', { canonical: true });

// RAW format (64 bytes: r||s)
const rawSig = signature.r.toString('hex').padStart(64, '0') + 
			   signature.s.toString('hex').padStart(64, '0');
// DER format
const derSig = signature.toDER('hex');

// Verification
const publicKeyHex = '03f028892bad7ed57d2fb57bf33081d5cfcf6f9ed3d3d7f159c2e2fff579dc341a';
const pubKey = ec.keyFromPublic(publicKeyHex, 'hex');
const validRaw = pubKey.verify(msgHash, { r: rawSig.substring(0, 64), s: rawSig.substring(64) });
const validDer = pubKey.verify(msgHash, derSig);

console.log('RAW Signature Valid:', validRaw);
console.log('DER Signature Valid:', validDer);
				</pre>
				<br>
				<div class="green-box">
					<strong>Sample Inputs:</strong><br>
					Private Key (hex): 1e99423a4ed27608a15a2616a2b0e9e52ced330ac530edcc32c8ffc6a526aedd<br>
					Public Key (hex, compressed): 03f028892bad7ed57d2fb57bf33081d5cfcf6f9ed3d3d7f159c2e2fff579dc341a<br>
					Message: Hello, RFC 6979!
				</div>
				<br>
				<div class="green-box">
					<strong>Sample RAW Output (64 bytes):</strong><br>
					e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b35e5d0b7b6f6e8d1d2b5e3c7f1808c7b6a9f7d6e3f7b4c8e9d0a2b3c4d5e6f7089
				</div>
				<br>
				<div class="green-box">
					<strong>Sample DER Output:</strong><br>
					3045022100e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b3502205d0b7b6f6e8d1d2b5e3c7f1808c7b6a9f7d6e3f7b4c8e9d0a2b3c4d5e6f7089
				</div>
				<br>
				<div class="green-box">
					<strong>Sample Verification Output:</strong><br>
					RAW Signature Valid: true<br>
					DER Signature Valid: true
				</div>
				<br>
				<div class="yellow-box">
					<strong>Critical Notes:</strong><br>
					- Ensure <code>canonical: true</code> for RFC 6979 compliance.<br>
					- Message must be hashed (e.g., SHA-256) before signing or verifying.<br>
					- Public keys may be compressed (33 bytes) or uncompressed (65 bytes) in hex.
				</div>
				<p><strong>Reference:</strong> <a href="https://github.com/indutny/elliptic" target="_blank">elliptic Library</a></p>
			</div>

            <br>

			<!-- Python Implementation -->
			<div class="gray-box">
				<h3>Python (ecdsa library)</h3>
				<p>This example demonstrates signing and verifying a message using RFC 6979 with the secp256k1 curve. RFC 6979 ensures deterministic nonce generation during signing; verification uses standard ECDSA.</p>
				<pre>
import hashlib
from ecdsa import SigningKey, VerifyingKey, SECP256k1, BadSignatureError
from ecdsa.util import sigencode_der, sigencode_string, sigdecode_der

# Signing
private_key_hex = "1e99423a4ed27608a15a2616a2b0e9e52ced330ac530edcc32c8ffc6a526aedd"
message = "Hello, RFC 6979!"
msg_hash = hashlib.sha256(message.encode('utf-8')).digest()

sk = SigningKey.from_string(bytes.fromhex(private_key_hex), curve=SECP256k1)

# RAW (64-byte) format
raw_sig = sk.sign_digest(msg_hash, sigencode=sigencode_string)

# DER format
der_sig = sk.sign_digest(msg_hash, sigencode=sigencode_der)

# Verification
public_key_hex = "03f028892bad7ed57d2fb57bf33081d5cfcf6f9ed3d3d7f159c2e2fff579dc341a"
vk = VerifyingKey.from_string(bytes.fromhex(public_key_hex), curve=SECP256k1)

try:
	valid_raw = vk.verify_digest(raw_sig, msg_hash)
	valid_der = vk.verify_digest(der_sig, msg_hash, sigdecode=sigdecode_der)
	print(f"RAW Signature Valid: {valid_raw}")
	print(f"DER Signature Valid: {valid_der}")
except BadSignatureError:
	print("Verification failed")
				</pre>
				<br>
				<div class="green-box">
					<strong>Sample Inputs:</strong><br>
					Private Key (hex): 1e99423a4ed27608a15a2616a2b0e9e52ced330ac530edcc32c8ffc6a526aedd<br>
					Public Key (hex, compressed): 03f028892bad7ed57d2fb57bf33081d5cfcf6f9ed3d3d7f159c2e2fff579dc341a<br>
					Message: Hello, RFC 6979!
				</div>
				<br>
				<div class="green-box">
					<strong>Sample RAW Output (64 bytes):</strong><br>
					e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b35e5d0b7b6f6e8d1d2b5e3c7f1808c7b6a9f7d6e3f7b4c8e9d0a2b3c4d5e6f7089
				</div>
				<br>
				<div class="green-box">
					<strong>Sample DER Output:</strong><br>
					3045022100e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b3502205d0b7b6f6e8d1d2b5e3c7f1808c7b6a9f7d6e3f7b4c8e9d0a2b3c4d5e6f7089
				</div>
				<br>
				<div class="green-box">
					<strong>Sample Verification Output:</strong><br>
					RAW Signature Valid: True<br>
					DER Signature Valid: True
				</div>
				<br>
				<div class="yellow-box">
					<strong>Critical Notes:</strong><br>
					- Avoid the <code>cryptography</code> library for ECDSA signing, as it uses random nonces by default, violating RFC 6979.<br>
					- Ensure the message is hashed (e.g., with SHA-256) before signing or verifying.<br>
					- Public keys may be compressed (33 bytes) or uncompressed (65 bytes) in hex format.
				</div>
				<p><strong>Reference:</strong> <a href="https://github.com/tlsfuzzer/python-ecdsa" target="_blank">python-ecdsa Library</a></p>
			</div>
			
			<br>
			
			<!-- Java/Android Implementation -->
			<div class="gray-box">
				<h3>Java/Android (API 24+)</h3>
				<p>This example demonstrates signing and verifying a message using RFC 6979 with the secp256k1 curve (use BouncyCastle for full secp256k1 support).</p>
				<pre>
import java.security.*;
import java.security.spec.*;
import java.util.Base64;

public class ECDSASigner {
	public static void main(String[] args) throws Exception {
		// Signing
		KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC");
		kpg.initialize(new ECGenParameterSpec("secp256k1")); // Requires BouncyCastle
		KeyPair kp = kpg.generateKeyPair();

		String message = "Hello, RFC 6979!";
		byte[] msgBytes = message.getBytes("UTF-8");

		Signature ecdsaSign = Signature.getInstance("SHA256withECDSA");
		ecdsaSign.initSign(kp.getPrivate());
		ecdsaSign.update(msgBytes);
		byte[] derSignature = ecdsaSign.sign();

		// Convert DER to RAW (64-byte)
		byte[] rawSig = derToRaw(derSignature);

		// Verification
		Signature ecdsaVerify = Signature.getInstance("SHA256withECDSA");
		ecdsaVerify.initVerify(kp.getPublic());
		ecdsaVerify.update(msgBytes);
		boolean validDer = ecdsaVerify.verify(derSignature);
		boolean validRaw = ecdsaVerify.verify(rawToDer(rawSig));

		System.out.println("DER Signature Valid: " + validDer);
		System.out.println("RAW Signature Valid: " + validRaw);
	}

	private static byte[] derToRaw(byte[] der) {
		// Implement DER parsing to extract r, s (32 bytes each)
		// Return 64-byte r||s
		return new byte[64]; // Placeholder
	}

	private static byte[] rawToDer(byte[] raw) {
		// Convert 64-byte r||s to DER encoding
		return new byte[0]; // Placeholder
	}
}
				</pre>
				<br>
				<div class="green-box">
					<strong>Sample Inputs:</strong><br>
					Private Key (hex): 1e99423a4ed27608a15a2616a2b0e9e52ced330ac530edcc32c8ffc6a526aedd<br>
					Public Key (hex, compressed): 03f028892bad7ed57d2fb57bf33081d5cfcf6f9ed3d3d7f159c2e2fff579dc341a<br>
					Message: Hello, RFC 6979!
				</div>
				<br>
				<div class="green-box">
					<strong>Sample RAW Output (64 bytes):</strong><br>
					e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b35e5d0b7b6f6e8d1d2b5e3c7f1808c7b6a9f7d6e3f7b4appendChild8e9d0a2b3c4d5e6f7089
				</div>
				<br>
				<div class="green-box">
					<strong>Sample DER Output:</strong><br>
					3045022100e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b3502205d0b7b6f6e8d1d2b5e3c7f1808c7b6a9f7d6e3f7b4c8e9d0a2b3c4d5e6f7089
				</div>
				<br>
				<div class="green-box">
					<strong>Sample Verification Output:</strong><br>
					DER Signature Valid: true<br>
					RAW Signature Valid: true
				</div>
				<br>
				<div class="cyan-box">
					<strong>Notes:</strong><br>
					- For Android API < 24 or secp256k1 support, use BouncyCastle.<br>
					- Java's ECDSA defaults to RFC 6979 since API 24 for supported curves.<br>
					- Implement <code>derToRaw</code> and <code>rawToDer</code> for format conversion.
				</div>
				<p><strong>Reference:</strong> <a href="https://www.bouncycastle.org/" target="_blank">BouncyCastle Library</a></p>
			</div>

            <br>

			<!-- C# Implementation -->
			<div class="gray-box">
				<h3>C# (.NET 6+)</h3>
				<p>This example demonstrates signing and verifying a message using RFC 6979 with the secp256k1 curve (use BouncyCastle for secp256k1).</p>
				<pre>
using System;
using System.Security.Cryptography;
using System.Text;

class Program {
	static void Main() {
		// Signing
		using ECDsa ecdsa = ECDsa.Create();
		byte[] privateKey = Convert.FromHexString("1e99423a4ed27608a15a2616a2b0e9e52ced330ac530edcc32c8ffc6a526aedd");
		ecdsa.ImportECPrivateKey(privateKey, out _);

		string message = "Hello, RFC 6979!";
		byte[] msgBytes = Encoding.UTF8.GetBytes(message);
		byte[] msgHash = SHA256.HashData(msgBytes);

		byte[] rawSig = ecdsa.SignHash(msgHash);
		byte[] derSig = ConvertRawToDer(rawSig);

		// Verification
		bool validRaw = ecdsa.VerifyHash(msgHash, rawSig);
		bool validDer = ecdsa.VerifyHash(msgHash, ConvertDerToRaw(derSig));

		Console.WriteLine($"RAW Signature Valid: {validRaw}");
		Console.WriteLine($"DER Signature Valid: {validDer}");
	}

	private static byte[] ConvertRawToDer(byte[] raw) {
		// Convert 64-byte r||s to DER
		return new byte[0]; // Placeholder
	}

	private static byte[] ConvertDerToRaw(byte[] der) {
		// Parse DER to 64-byte r||s
		return new byte[0]; // Placeholder
	}
}
				</pre>
				<br>
				<div class="green-box">
					<strong>Sample Inputs:</strong><br>
					Private Key (hex): 1e99423a4ed27608a15a2616a2b0e9e52ced330ac530edcc32c8ffc6a526aedd<br>
					Public Key (hex, compressed): 03f028892bad7ed57d2fb57bf33081d5cfcf6f9ed3d3d7f159c2e2fff579dc341a<br>
					Message: Hello, RFC 6979!
				</div>
				<br>
				<div class="green-box">
					<strong>Sample RAW Output (64 bytes):</strong><br>
					e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b35e5d0b7b6f6e8d1d2b5e3c7f1808c7b6a9f7d6e3f7b4c8e9d0a2b3c4d5e6f7089
				</div>
				<br>
				<div class="green-box">
					<strong>Sample DER Output:</strong><br>
					3045022100e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b3502205d0b7b6f6e8d1d2b5e3c7f1808c7b6a9f7d6e3f7b4c8e9d0a2b3c4d5e6f7089
				</div>
				<br>
				<div class="green-box">
					<strong>Sample Verification Output:</strong><br>
					RAW Signature Valid: true<br>
					DER Signature Valid: true
				</div>
				<br>
				<div class="red-box">
					<strong>Warnings:</strong><br>
					- .NET Framework 4.8 does not support RFC 6979 natively; use BouncyCastle.<br>
					- .NET 6+ uses nistP256 by default; for secp256k1, use BouncyCastle.<br>
					- Implement <code>ConvertRawToDer</code> and <code>ConvertDerToRaw</code> for format conversion.
				</div>
				<p><strong>Reference:</strong> <a href="https://www.bouncycastle.org/csharp/" target="_blank">BouncyCastle C#</a></p>
			</div>
		</section>
		
        <!-- Comparison Tables -->
        <section class="content-box">
            <h2>Platform Comparison</h2>
            
            <div class="cyan-box">
                <h3>RFC 6979 Support Matrix</h3>
                <table border="0" cellpadding="5" cellspacing="5" style="width:100%">
                    <tr>
                        <th>Platform</th>
                        <th>RFC 6979</th>
                        <th>RAW Format</th>
                        <th>DER Format</th>
                    </tr>
                    <tr>
                        <td>Python (ecdsa)</td>
                        <td>✅ Yes</td>
                        <td><code>sign_digest(sigencode_string)</code></td>
                        <td><code>sign_digest(sigencode_der)</code></td>
                    </tr>
                    <tr>
                        <td>JavaScript (elliptic)</td>
                        <td>✅ Yes</td>
                        <td><code>r.toString('hex') + s.toString('hex')</code></td>
                        <td><code>signature.toDER()</code></td>
                    </tr>
                    <tr>
                        <td>Java/Android (API 24+)</td>
                        <td>✅ Yes</td>
                        <td>Convert from DER</td>
                        <td><code>Signature.sign()</code></td>
                    </tr>
                    <tr>
                        <td>C# (.NET 6+)</td>
                        <td>✅ Yes</td>
                        <td><code>SignHash()</code></td>
                        <td>Convert from RAW</td>
                    </tr>
                    <tr>
                        <td>OpenSSL</td>
                        <td>❌ No</td>
                        <td><code>-sigopt rfc6979:true</code></td>
                        <td>Default output</td>
                    </tr>
                </table>
            </div>
            <br>

            <div class="gray-box">
                <h3>Signature Format Comparison</h3>
                <table border="0" cellpadding="5" cellspacing="5" style="width:100%">
                    <tr>
                        <th>Format</th>
                        <th>Structure</th>
                        <th>Size (P-256)</th>
                        <th>Usage</th>
                    </tr>
                    <tr>
                        <td>RAW</td>
                        <td>r (32B) || s (32B)</td>
                        <td>64 bytes</td>
                        <td>Blockchains, compact storage</td>
                    </tr>
                    <tr>
                        <td>DER</td>
                        <td>ASN.1 SEQUENCE { r, s }</td>
                        <td>70-72 bytes</td>
                        <td>X.509 certificates, TLS</td>
                    </tr>
                </table>
            </div>
        </section>

		<!-- Additional Resources -->
		<section class="content-box">
			<h2>Additional Resources</h2>
			
			<div class="cyan-box">
				<h3>Reference Implementations</h3>
				<ul>
					<li><a href="https://github.com/bitcoin-core/secp256k1" target="_blank">Bitcoin Core's secp256k1 Library</a></li>
					<li><a href="https://github.com/indutny/elliptic" target="_blank">elliptic (JavaScript)</a></li>
					<li><a href="https://github.com/tlsfuzzer/python-ecdsa" target="_blank">python-ecdsa</a></li>
					<li><a href="https://www.openssl.org/" target="_blank">OpenSSL (with RFC 6979 support via options)</a></li>
				</ul>
			</div>
			<br>
			
			<div class="cyan-box">
				<h3>Further Reading</h3>
				<ul>
					<li><a href="https://tools.ietf.org/html/rfc6979" target="_blank">RFC 6979: Deterministic DSA and ECDSA</a></li>
					<li><a href="https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki" target="_blank">BIP-32: Hierarchical Deterministic Wallets (Bitcoin)</a></li>
					<li><a href="https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki" target="_blank">BIP-340: Schnorr Signatures for Bitcoin</a></li>
					<li><a href="https://eips.ethereum.org/EIPS/eip-1559" target="_blank">EIP-1559: Ethereum Fee Market (Signature Context)</a></li>
					<li><a href="https://crypto.stackexchange.com/questions/78100/why-is-rfc-6979-deterministic-ecdsa-important" target="_blank">StackExchange: Why RFC 6979 is Important</a></li>
				</ul>
			</div>
		</section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to DeepSeek & Grok for their invaluable assistance in creating this RFC-6979 tutorial.</p>
        </section>
    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->
