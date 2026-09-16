<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TallyBox Tutorial - Wallet Creation</title>
    <meta name="description" content="A step-by-step tutorial on creating a TallyBox cryptocurrency wallet using the secp256r1 elliptic curve, with pseudo-code and examples for implementation.">
    <meta name="author" content="shahiN Noursalehi">

	<!--#INCLUDE virtual="/inc_styles.asp"-->

</head>
<body class="dark-mode">
    <header>
        <h1>TallyBox Tutorial - Wallet Creation</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()" aria-label="Toggle dark mode"> Dark Mode
        </label>
    </header>

    <!-- Navigation Bar -->
    <section class="content-box">
        You are here: 
        <a href="/">Home</a> /
		Toturials /
        <a href="tallybox_wallet_creation.asp">Tallybox Wallet Creation - Pseudo Edition</a>
    </section>

    <br>

    <!-- AI-Friendly Notice -->
    <section class="yellow-box">
        <p><strong>Note:</strong> This tutorial is structured to be <strong>AI-Friendly</strong>. An AI can generate code in any programming language based on the content of this URL, thanks to its clear steps, pseudo-code, and examples.</p>
    </section>

    <!-- Main Content -->
    <main>
        <!-- Introduction -->
        <section class="content-box">
            <h2>Creating a TallyBox Wallet</h2>
            <p>This tutorial guides tech-savvy users through the process of creating a secure TallyBox wallet using the secp256r1 elliptic curve. You'll generate a key pair, derive a unique wallet address, verify its integrity, and provision it for use in the TallyBox ecosystem, ensuring compatibility with TallyBox's cryptographic standards. The focus is on the algorithms and math behind each step, making it easy to implement in any programming language. Pseudo-code is provided for complex steps to aid implementation without libraries.</p>
        </section>

        <!-- Step 1: Generate Key Pair -->
        <section class="content-box">
            <h3>Step 1: Generate a Private-Public Key Pair</h3>
            <p>Use the secp256r1 elliptic curve (also known as P-256) to generate a key pair. This curve is defined by the equation y² = x³ + ax + b over a finite field, where a and b are specific constants, and the field size is a 256-bit prime (P). The process involves:
                <ul>
                    <li>Define the curve parameters: P (prime), a, b, G (base point), and n (order).</li>
                    <li>Select a random 256-bit integer as the private key (d), within the range [1, n-1].</li>
                    <li>Compute the public key (Q) as Q = d * G, where * denotes elliptic curve point multiplication.</li>
                    <li>The public key Q is a point (X, Y) on the curve, where X and Y are 256-bit integers.</li>
                </ul>
                The private key must be kept secret, while the public key (X, Y coordinates) is used in subsequent steps.
            </p>
            <div class="gray-box">
                <p><strong>Secp256r1 Curve Parameters:</strong><br><br>
                <pre>
P = 0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF  // Prime field
a = 0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFC  // Curve coefficient
b = 0x5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B  // Curve coefficient
Gx = 0x6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296  // Base point X
Gy = 0x4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5  // Base point Y
n = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551  // Order of the curve
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                Private Key: 7a8d26a42f45ecc68bc9d9ad2de9e4868429de2b185ab7e023f93845c58c4fa1<br><br>
                Public Key (Uncompressed):<br><br>
                X: 252df02599b4560df18cb5e7486769303c0ec0dcb0f64a5a980e41feba7d593f<br><br>
                Y: 7020405e0700461be964eaf159e3e20bd9aee2fda2f93b0c6ef03ee63876db47</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://www.secg.org/sec2-v2.pdf">SEC 2: Recommended Elliptic Curve Domain Parameters (secp256r1)</a><br>
                <a href="https://en.wikipedia.org/wiki/Elliptic-curve_cryptography">Elliptic Curve Cryptography (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 2: Compress and Encode Public Key -->
        <section class="content-box">
            <h3>Step 2: Compress and Encode the Public Key</h3>
            <p>Compress the public key to reduce its size, then encode it in Base58. The process involves:
                <ul>
                    <li>Take the X-coordinate of the public key (a 256-bit integer).</li>
                    <li>Determine the parity of the Y-coordinate: if Y is odd, suffix = '1'; if Y is even, suffix = '2'. Parity is computed as Y mod 2.</li>
                    <li>Form the compressed key as X + '*' + suffix (as a string).</li>
                    <li>Encode the X-coordinate (as a byte array) in Base58, then append the suffix. Base58 encoding converts a byte array to a string using a 58-character alphabet, avoiding ambiguous characters like '0', 'O', 'I', and 'l'.</li>
                </ul>
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Compress Public Key</strong><br><br>
                <pre>
FUNCTION compress_public_key(X, Y):
    parity = Y % 2
    IF parity == 1 THEN
        suffix = '1'
    ELSE
        suffix = '2'
    END IF
    compressed_key = X + '*' + suffix
    RETURN compressed_key
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Base58 Encode</strong><br><br>
                <pre>
FUNCTION base58_encode(bytes):
    alphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
    value = bytes_to_integer(bytes)  // Convert byte array to big integer (unsigned)
    result = ''
    WHILE value > 0:
        remainder = value % 58
        result = alphabet[remainder] + result
        value = value / 58  // Integer division
    END WHILE
    // Handle leading zeros in the byte array
    FOR each byte in bytes:
        IF byte == 0 THEN
            result = '1' + result
        ELSE
            BREAK
        END IF
    END FOR
    RETURN result
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                Compressed Key: 252df02599b4560df18cb5e7486769303c0ec0dcb0f64a5a980e41feba7d593f*1<br><br>
                Base58 Compressed Public Key: 3W8iLTuAjbf9d1ih4RCi7Aat6keKxs72SNynZ1A269MY*1</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Base58">Base58 Encoding (Wikipedia)</a><br>
                <a href="https://bitcoin.stackexchange.com/questions/3059/what-is-a-compressed-bitcoin-key">Compressed Public Key Explanation (Bitcoin Stack Exchange)</a>
            </p>
        </section>

        <!-- Step 3: Derive Wallet Address -->
        <section class="content-box">
            <h3>Step 3: Derive the TallyBox Wallet Address</h3>
            <p>Derive a unique wallet address from the Base58-encoded public key. The process involves:
                <ul>
                    <li>Compute the SHA-256 hash of the Base58-encoded public key (treat the string as bytes using UTF-8 encoding).</li>
                    <li>Ensure the SHA-256 hash is converted to a big integer as an unsigned value across all platforms (e.g., use unsigned conversion in C#, Python, Java, JavaScript).</li>
                    <li>Encode the raw wallet string (as bytes) in Base58 (see pseudo-code in Step 2).</li>
                    <li>Compute the MD5 hash of the Base58-encoded string (as bytes).</li>
                    <li>Take the first 11 characters of the MD5 hash and prefix it with 'boxB' to form the checksum.</li>
                    <li>Combine the checksum and the Base58-encoded string to form the final wallet address: checksum + Base58-encoded string.</li>
                </ul>
                <strong>Note:</strong> MD5 is outdated and insecure for cryptographic purposes. However, in TallyBox's wallet address structure, we use it solely to detect copy-paste errors, not for security-critical operations.
            </p>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                Base58 Compressed Public Key: 3W8iLTuAjbf9d1ih4RCi7Aat6keKxs72SNynZ1A269MY*1<br><br>
                SHA-256 Hash: 5e3df94169f3d82b9b67d93acbc288a42c9812ced307297f78ed3058d338b1e4<br><br>
                Raw Wallet (Bigint): 42626905736173508565770948203518737897276237144762802425237770121056689369572<br><br>
                Base58 Encoded: 7Lt8jmf3GNWCJc2K5bU7aAS5gqSbDYnY5UVshnJVHEJP<br><br>
                MD5 Hash: a01d317e6c52656bb188a55736dc5aab<br><br>
                Checksum: boxBa01d317e6c5<br><br>
                Final Wallet Address: boxBa01d317e6c57Lt8jmf3GNWCJc2K5bU7aAS5gqSbDYnY5UVshnJVHEJP</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/SHA-2">SHA-256 Algorithm (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/MD5">MD5 Algorithm (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Base58">Base58 Encoding (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 4: Verify Key Pair -->
		<section class="content-box">
			<h3>Step 4: Verify the Key Pair Integrity</h3>
			<p>Verify the key pair to ensure it is valid for TallyBox transactions. The process involves:
				<ul>
					<li>Sign the message "TallyBox, a tool for curious minds.." using the private key with the ECDSA (Elliptic Curve Digital Signature Algorithm) on the secp256r1 curve, following RFC 6979 for deterministic signature generation. This produces a signature (r, s).</li>
					<li>Decompress the compressed public key: given X and the suffix ('1' or '2'), compute Y using the curve equation y² = x³ + ax + b mod p, where p is the field prime. Solve for Y (two possible values) and select the one matching the parity (odd for '1', even for '2').</li>
					<li>Verify the signature using the decompressed public key (X, Y) with ECDSA. If the signature is valid, the key pair is trustworthy.</li>
					<li>If verification fails, discard the key pair and restart from Step 1.</li>
				</ul>
				<strong>Note:</strong> The ECDSA signing process must comply with RFC 6979 to ensure deterministic signatures, enhancing security and reproducibility.
			</p>
			<div class="cyan-box">
				<p><strong>Example Process:</strong><br><br>
				Message Signed: "TallyBox, a tool for curious minds.."<br><br>
				Signature (Base64): MEYCIQD6BLlP29AzfKK/SPyuMdVYrWzn/wQElsdkVF+ewvBgDQIhANy4lgejq9JChhQM/9PWyxfLKJYxRz4SWcoBak468i5s<br><br>
				Base58 Compressed Public Key: 3W8iLTuAjbf9d1ih4RCi7Aat6keKxs72SNynZ1A269MY*1<br><br>
				Decompressed Public Key (X*Y): 252df02599b4560df18cb5e7486769303c0ec0dcb0f64a5a980e41feba7d593f*7020405e0700461be964eaf159e3e20bd9aee2fda2f93b0c6ef03ee63876db47<br><br>
				Signature Verification Result: Valid</p>
			</div>
			<p><strong>References:</strong><br>
				<a href="https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm">ECDSA Algorithm (Wikipedia)</a><br>
				<a href="https://www.secg.org/sec2-v2.pdf">SEC 2: Recommended Elliptic Curve Domain Parameters (secp256r1)</a><br>
				<a href="https://tools.ietf.org/html/rfc6979">RFC 6979: Deterministic Usage of DSA and ECDSA</a>
			</p>
		</section>

        <!-- Step 5: Provision Wallet -->
        <section class="content-box">
            <h3>Step 5: Provision the TallyBox Wallet</h3>
            <p>Provision the wallet by securely storing its data. The process involves:
                <ul>
                    <li>Select a wallet name and a strong local password.</li>
                    <li>Form a key string as wallet_name + '~' + password + '~' + wallet_address.</li>
                    <li>Compute the SHA-256 hash of the key string (as bytes) to generate a 64-character hex secret key.</li>
                    <li>Encrypt the private key (as a hex string) using a special AES-256-CBC algorithm with custom padding, described below. Encode the ciphertext in Base64.</li>
                    <li>Decrypt the encrypted private key to verify correctness: use the same secret key and decrypt the ciphertext. Compare the result with the original private key.</li>
                    <li>Create an XML file containing the wallet name, wallet address, Base58-encoded compressed public key, encrypted private key (Base64), and a tech info URL.</li>
                    <li>Store the XML file and private key offline securely.</li>
                </ul>
                <strong>Note:</strong> Ensure the private key and XML file are stored securely (e.g., on an encrypted drive) to prevent unauthorized access.
            </p>

            <!-- AES with Custom Padding Subsection -->
            <div class="content-box">
                <h4>Special AES-256-CBC with Custom Padding</h4>
                <p>TallyBox uses a unique AES-256-CBC encryption algorithm with custom padding to secure the private key. The algorithm derives the key, IV, and salt from a 64-character hex secret key (SHA-256 of wallet_name~password~wallet_address). Random padding is added around the plaintext for enhanced security. The configuration is:
                    <ul>
                        <li><strong>Secret Key</strong>: A 64-character hex string (32 bytes), split into:
                            <ul>
                                <li>Password: First 32 hex chars (16 bytes, ASCII-encoded).</li>
                                <li>IV: Next 16 hex chars (8 bytes, ASCII-encoded, 16 bytes as bytes).</li>
                                <li>Salt: Last 16 hex chars (8 bytes, ASCII-encoded).</li>
                            </ul>
                        </li>
                        <li><strong>Key Derivation</strong>: PBKDF2 with SHA-256, 3 iterations, 32-byte output, using password and salt.</li>
                        <li><strong>Custom Padding</strong>: Random string (0–99 chars, a-zA-Z) + '|' + plaintext (64-char hex private key) + '|' + random string (0–99 chars, a-zA-Z), followed by PKCS#7 padding.</li>
                        <li><strong>Output</strong>: Base64-encoded ciphertext (no IV prepended).</li>
                    </ul>
                </p>
                <div class="gray-box">
                    <p><strong>Pseudo-Code: AES-256-CBC Encrypt with Custom Padding</strong><br><br>
                    <pre>
FUNCTION aes256_cbc_encrypt_custom(data, secret):
    IF length(secret) < 64 OR NOT is_hex(secret) THEN
        THROW "Secret must be a 64-char hex string"
    END IF
    password = secret[0:32]  // First 32 hex chars (ASCII)
    iv = secret[32:48]       // Next 16 hex chars (ASCII)
    salt = secret[48:64]     // Last 16 hex chars (ASCII)
    key = PBKDF2_HMAC_SHA256(password, salt, iterations=3, output_bytes=32)
    left_padding_size = random_integer(0, 99)
    left_padding = random_string(left_padding_size, 'a-zA-Z')
    right_padding_size = random_integer(0, 99)
    right_padding = random_string(right_padding_size, 'a-zA-Z')
    padded_data = left_padding + '|' + data + '|' + right_padding
    padding_length = 16 - (length(padded_data) % 16)
    padded_data = padded_data + (padding_length as byte) * padding_length  // PKCS#7
    cipher = initialize_aes256_cbc_encrypt(key, iv)
    ciphertext = cipher.encrypt(padded_data)
    base64_result = base64_encode(ciphertext)
    RETURN base64_result
END FUNCTION
                    </pre>
                    </p>
                </div>
				<br>
                <div class="gray-box">
                    <p><strong>Pseudo-Code: AES-256-CBC Decrypt with Custom Padding</strong><br><br>
                    <pre>
FUNCTION aes256_cbc_decrypt_custom(base64_ciphertext, secret):
    IF length(secret) < 64 OR NOT is_hex(secret) THEN
        THROW "Secret must be a 64-char hex string"
    END IF
    ciphertext = base64_decode(base64_ciphertext.replace('\n', ''))  // Strip newlines
    password = secret[0:32]  // First 32 hex chars (ASCII)
    iv = secret[32:48]       // Next 16 hex chars (ASCII)
    salt = secret[48:64]     // Last 16 hex chars (ASCII)
    key = PBKDF2_HMAC_SHA256(password, salt, iterations=3, output_bytes=32)
    cipher = initialize_aes256_cbc_decrypt(key, iv)
    padded_data = cipher.decrypt(ciphertext)
    padding_length = padded_data[-1]
    IF padding_length > 16 OR padding_length == 0 THEN
        THROW "Invalid PKCS#7 padding"
    END IF
    padded_data = padded_data[:-padding_length]  // Remove PKCS#7 padding
    padded_text = padded_data.decode('utf-8')
    parts = padded_text.split('|')
    IF length(parts) != 3 THEN
        THROW "Invalid padding format: expected 'left|data|right'"
    END IF
    plaintext = parts[1]
    IF NOT is_hex(plaintext) OR length(plaintext) != 64 THEN
        THROW "Decrypted private key must be a 64-char hex string"
    END IF
    RETURN plaintext
END FUNCTION
                    </pre>
                    </p>
                </div>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                Original Private Key (hex): 7a8d26a42f45ecc68bc9d9ad2de9e4868429de2b185ab7e023f93845c58c4fa1<br><br>
                Key Components (pre-SHA-256): shahin~11~boxBa01d317e6c57Lt8jmf3GNWCJc2K5bU7aAS5gqSbDYnY5UVshnJVHEJP<br><br>
                Local Key (SHA-256): 7e9b4699f7d3eea878f51a9d4e238922116cccc558b15f2db257d92a9779becc<br><br>
                Encrypted Private Key (Base64): Lu8xEpnACOtVrmZxRt7I2m7Zc5pZI8sxIGhXV6FqwN6N2VG8yt4jof5c0Xo5slF+VyOLORhls2auG27Xmjd20Z/9YiBZ2E5ePFsQV7ZkeqKFZa+k5IrOHGjDcyJtiJt22zAzOaSvyTFFGRHwDGI1FCJ5BppBvYkoGhro9MxHp3MVS7eW2N3z2NEQV2Gxm+IErv0ExkxfesyXqw/kTwk2qHBuTUtKRgkOY8RCAPPkNglOjfo4ct+YCdkzoIS/Ww6xatWmAUA6bhtxK2q3vZly1iteNAa+Uz0Pyn166f7Y90cCGJPINc5x7WGcolqPeWf5<br><br>
                Decrypted Private Key (hex): 7a8d26a42f45ecc68bc9d9ad2de9e4868429de2b185ab7e023f93845c58c4fa1<br><br>
                Verification Result: Verified</p>
            </div>
            <br>
			<div class="cyan-box">
				<h3>Required Dependencies and Setup for Python edition</h3>
				<p>
					To run python script, ensure you have Python 3.7 or higher installed. The following dependencies are required:
				</p>
				<ul>
					<li><strong>ecdsa</strong>: Install using <pre style="background-color: #222; color: #aaa; padding: 5px; border-radius: 5px;">pip install ecdsa</pre>. This library provides RFC 6979-compliant ECDSA signatures for key pair verification.</li>
					<li><strong>cryptography</strong>: Install using <pre style="background-color: #222; color: #aaa; padding: 5px; border-radius: 5px;">pip install cryptography</pre>. This library provides cryptographic primitives (e.g., secp256r1, AES-256-CBC) for key generation and encryption.</li>
					<li><strong>Standard Libraries</strong>: The script uses <code>hashlib</code>, <code>base64</code>, <code>xml.etree.ElementTree</code>, <code>os</code>, <code>random</code>, <code>string</code>, and <code>re</code>, which are included in Python's standard library.</li>
				</ul>
				<p>
					<strong>Setup Instructions:</strong>
					<ol>
						<li>Install Python 3.7+ from <a href="https://www.python.org/downloads/" target="_blank">python.org</a>.</li>
						<li>Install the required packages by running: <pre style="background-color: #222; color: #aaa; padding: 5px; border-radius: 5px;">pip install ecdsa cryptography</pre>.</li>
						<li>Ensure your working directory has write permissions, as the script will save an XML file (<code>&lt;wallet_name&gt;.xml</code>).</li>
					</ol>
					
					<strong>Alternative:</strong>
					You can run the script using online interpreters like <a href="https://colab.research.google.com/" target="_blank">Google Colab</a>, which supports Python 3.7+ and the required packages.
				</p>
			</div>
			<br>
            <div class="green-box">
                <p><strong>Example Output:</strong><br><br>
                <textarea class="textarea-green" readonly>
<tallybox_wallet>

    <wallet_name>shahin</wallet_name>

    <wallet_address>boxBa01d317e6c57Lt8jmf3GNWCJc2K5bU7aAS5gqSbDYnY5UVshnJVHEJP</wallet_address>

    <public_key_b58_compressed>3W8iLTuAjbf9d1ih4RCi7Aat6keKxs72SNynZ1A269MY*1</public_key_b58_compressed>

    <private_key_aes_b64>Lu8xEpnACOtVrmZxRt7I2m7Zc5pZI8sxIGhXV6FqwN6N2VG8yt4jof5c0Xo5slF+VyOLORhls2auG27Xmjd20Z/9YiBZ2E5ePFsQV7ZkeqKFZa+k5IrOHGjDcyJtiJt22zAzOaSvyTFFGRHwDGI1FCJ5BppBvYkoGhro9MxHp3MVS7eW2N3z2NEQV2Gxm+IErv0ExkxfesyXqw/kTwk2qHBuTUtKRgkOY8RCAPPkNglOjfo4ct+YCdkzoIS/Ww6xatWmAUA6bhtxK2q3vZly1iteNAa+Uz0Pyn166f7Y90cCGJPINc5x7WGcolqPeWf5</private_key_aes_b64>

    <tech_info>https://mailarchive.ietf.org/arch/msg/ideas/VEzD4RXKlCFIUftYIrrEdMFgoW0/</tech_info>

</tallybox_wallet>
				</textarea></p>
            </div>
			<br>
			<!-- Warning About Private Key and Password -->
			<div class="red-box">
				<h3>Important Warning: Save Your Private Key and Password</h3>
				<p>
					<strong>Critical:</strong> When generating a new wallet the script will display your private key in the output. You <strong>must</strong> write down this private key. These are required to recover your wallet later if needed. Store it securely offline (e.g., on paper or an encrypted drive). Losing private key may result in permanent loss of access to your wallet.
				</p>
			</div>
			<br>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Advanced_Encryption_Standard">AES Encryption (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/SHA-2">SHA-256 Algorithm (Wikipedia)</a><br>
                <a href="https://www.w3.org/TR/xml/">XML Specification (W3C)</a>
            </p>
        </section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its invaluable assistance in creating this TallyBox wallet creation tutorial.</p>
        </section>

    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->
