<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tallybox Wallet - Transaction Group Tutorial</title>
    <meta name="description" content="A step-by-step tutorial on preparing and broadcasting Transaction Groups using the Tallybox Wallet, with pseudo-code and examples for implementation in any programming language.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

</head>
<body class="dark-mode">
    <header>
        <h1>Tallybox Wallet - Transaction Group Tutorial</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()" aria-label="Toggle dark mode"> Dark Mode
        </label>
    </header>

    <!-- Navigation Bar -->
    <section class="content-box">
        You are here: 
        <a href="/">Home</a> /
        Tutorials /
        <a href="tallybox_wallet_transaction_group.asp">Tallybox Wallet Transaction Group - Pseudo Edition</a>
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
            <h2>Preparing Transaction Groups with Tallybox Wallet</h2>
            <p>
                This tutorial guides you through loading a Tallybox Wallet, reading and validating a Transaction Group file, preparing a consolidated Transaction Group, and broadcasting it on a Directed Acyclic Graph (DAG) network. The script loads wallets from an XML file, decrypts the private key, processes multiple transactions from a text file, checks for duplicate target wallet addresses, signs the group using ECDSA (secp256r1) with RFC 6979-compliant signatures, and saves it offline. To ensure consistency and prevent sorting issues, it hashes the concatenated <code>wallet_to~order_amount~</code> strings for the transaction group and uses a unique order ID formatted as <code>#</code> followed by the Unix timestamp. The transaction file format excludes order IDs, aligning with consistent data flow across implementations. Follow the steps below to implement your own Transaction Group preparation code.
            </p>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Directed_acyclic_graph">Directed Acyclic Graph (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Cryptocurrency_wallet">Cryptocurrency Wallet (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 1: Load Wallet -->
        <section class="content-box">
            <h3>Step 1: Load Wallet and Decrypt Private Key</h3>
            <p>
                Load the wallet's XML file, which contains the wallet name, compressed public key (Base58-encoded), encrypted private key (Base64-encoded AES-256-CBC), and wallet address. Prompt the user to select an XML file and enter a password for decryption. Validate the XML structure and decrypt the private key using a special AES-256-CBC algorithm with custom padding. Reconstruct the ECDSA key pair using the secp256r1 curve.
            </p>
            <div class="content-box">
                <h4>Special AES-256-CBC with Custom Padding</h4>
                <p>
                    Tallybox uses a unique AES-256-CBC decryption algorithm with custom padding to retrieve the private key. The algorithm derives the key, IV, and salt from a 64-character hex secret (SHA-256 of <code>wallet_name~password~wallet_address</code>). The plaintext is padded with random strings. The configuration is:
                    <ul>
                        <li><strong>Secret Key</strong>: A 64-character hex string (32 bytes), split into:
                            <ul>
                                <li>Password: First 32 hex chars (16 bytes, ASCII-encoded).</li>
                                <li>IV: Next 16 hex chars (8 bytes, ASCII-encoded, used as 16-byte IV).</li>
                                <li>Salt: Last 16 hex chars (8 bytes, ASCII-encoded).</li>
                            </ul>
                        </li>
                        <li><strong>Key Derivation</strong>: PBKDF2 with SHA-256, 3 iterations, 32-byte output, using password and salt.</li>
                        <li><strong>Custom Padding</strong>: Format is <code>random_string(0–99 chars, a-zA-Z)|plaintext(64-char hex private key)|random_string(0–99 chars, a-zA-Z)</code>, followed by PKCS#7 padding.</li>
                        <li><strong>Input</strong>: Base64-encoded ciphertext (no IV prepended, may include newlines).</li>
                    </ul>
                </p>
                <div class="gray-box">
                    <p><strong>Pseudo-Code: AES-256-CBC Decrypt with Custom Padding</strong><br><br>
                    <pre>
FUNCTION aes256_cbc_decrypt_custom(base64_ciphertext, secret):
    IF length(secret) < 64 OR NOT is_hex(secret):
        THROW "Secret must be a 64-char hex string"
    END IF
    ciphertext = base64_decode(base64_ciphertext.replace('\n', ''))  // Strip newlines
    password = secret[0:32].encode('ascii')  // First 32 hex chars
    iv = secret[32:48].encode('ascii')       // Next 16 hex chars
    salt = secret[48:64].encode('ascii')     // Last 16 hex chars
    key = PBKDF2_HMAC_SHA256(password, salt, iterations=3, output_bytes=32)
    cipher = initialize_aes256_cbc_decrypt(key, iv)
    padded_data = cipher.decrypt(ciphertext)
    padding_length = padded_data[-1]
    IF padding_length > 16 OR padding_length == 0:
        THROW "Invalid PKCS#7 padding"
    END IF
    padded_data = padded_data[:-padding_length]  // Remove PKCS#7 padding
    TRY:
        padded_text = padded_data.decode('utf-8')
        parts = padded_text.split('|')
        IF length(parts) != 3:
            THROW "Invalid padding format: expected 'left|data|right'"
        END IF
        plaintext = parts[1]
    CATCH decode_error:
        parts = padded_data.split(b'|')
        IF length(parts) != 3:
            THROW "Invalid padding format in bytes"
        END IF
        plaintext = parts[1].decode('ascii')
    END TRY
    IF NOT is_hex(plaintext) OR length(plaintext) != 64:
        THROW "Decrypted private key must be a 64-char hex string"
    END IF
    RETURN plaintext
END FUNCTION
                    </pre>
                    </p>
                </div>
            </div>
            <br>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Load Wallet</strong><br><br>
                <pre>
FUNCTION load_wallet(file, password, protocol="https", graph="tallybox.mixoftix.net"):
    TRY:
        xml_content = READ_FILE(file)
        xml_doc = PARSE_XML(xml_content)
        wallet_name = xml_doc.GET_TAG("wallet_name")
        public_key_b58 = xml_doc.GET_TAG("public_key_b58_compressed")
        private_key_aes_b64 = xml_doc.GET_TAG("private_key_aes_b64")
        wallet_address = xml_doc.GET_TAG("wallet_address")

        IF NOT (wallet_name AND public_key_b58 AND private_key_aes_b64 AND wallet_address):
            THROW "Invalid XML format"

        key_components = wallet_name + "~" + password + "~" + wallet_address
        secret = SHA256(key_components.encode('utf-8')).hex()
        private_key_hex = aes256_cbc_decrypt_custom(private_key_aes_b64, secret)

        private_key_int = PARSE_HEX_TO_INT(private_key_hex)
        SECP256R1_ORDER = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551
        IF NOT (1 <= private_key_int < SECP256R1_ORDER):
            THROW "Private key out of range for secp256r1"

        ec = NEW_ELLIPTIC_CURVE("secp256r1")
        key_pair = ec.KEY_FROM_PRIVATE(private_key_int)
        public_key = key_pair.GET_PUBLIC()
        public_key_bytes = public_key.ENCODE("x962", "uncompressed")
        x_bytes = public_key_bytes[1:33]
        y_bytes = public_key_bytes[33:]
        y_parity = PARSE_INT(y_bytes) MOD 2
        suffix = "1" IF y_parity == 1 ELSE "2"
        compressed_key = x_bytes.hex() + "*" + suffix

        result = CREATE_RECORD()
        result.SET_FIELD("key_pair", key_pair)
        result.SET_FIELD("compressed_key", compressed_key)
        result.SET_FIELD("public_key_b58", public_key_b58)
        result.SET_FIELD("wallet_address", wallet_address)
        result.SET_FIELD("wallet_name", wallet_name)
        result.SET_FIELD("protocol", protocol)
        result.SET_FIELD("graph", graph)
        RETURN result
    CATCH error:
        THROW "Decryption failed or invalid file: " + error
END FUNCTION
                </pre>
                </p>
                <p>
                    <strong>Notice: XML File Structure</strong><br>
                    The XML file must include <code>&lt;wallet_name&gt;</code>, <code>&lt;public_key_b58_compressed&gt;</code>, 
                    <code>&lt;private_key_aes_b64&gt;</code>, and <code>&lt;wallet_address&gt;</code>. The password must match 
                    the one used to encrypt the private key, or decryption will fail.
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                    Step 1 - Loaded Wallet Name:<br>
                    shahin<br><br>
                    Step 2 - Extracted Public Key (Base58 Compressed):<br>
                    8mDnzMdZUKu2GQVLVfBLgVvw9VroBG8GoYHR9JjY7kzg*2<br><br>
                    Step 3 - Extracted Wallet Address:<br>
                    boxBd0e08436d01CSjqsUPgP9uamYUYsPFv6NyzvLfHGMBXmuubEp8MdZdz<br><br>
                    Step 4 - Key Components (pre-SHA-256):<br>
                    shahin~mypassword~boxBd0e08436d01CSjqsUPgP9uamYUYsPFv6NyzvLfHGMBXmuubEp8MdZdz<br><br>
                    Step 5 - Secret Key (SHA-256):<br>
                    7e9b4699f7d3eea878f51a9d4e238922116cccc558b15f2db257d92a9779becc<br><br>
                    Step 6 - Encrypted Private Key (Base64):<br>
                    Lu8xEpnACOtVrmZxRt7I2m7Zc5pZI8sxIGhXV6FqwN6N2VG8yt4jof5c0Xo5slF+VyOLORhls2auG27Xmjd20Z/9YiBZ2E5ePFsQV7ZkeqKFZa+k5IrOHGjDcyJtiJt22zAzOaSvyTFFGRHwDGI1FCJ5BppBvYkoGhro9MxHp3MVS7eW2N3z2NEQV2Gxm+IErv0ExkxfesyXqw/kTwk2qHBuTUtKRgkOY8RCAPPkNglOjfo4ct+YCdkzoIS/Ww6xatWmAUA6bhtxK2q3vZly1iteNAa+Uz0Pyn166f7Y90cCGJPINc5x7WGcolqPeWf5<br><br>
                    Step 7 - Decrypted Private Key (hex):<br>
                    7a8d26a42f45ecc68bc9d9ad2de9e4868429de2b185ab7e023f93845c58c4fa1<br><br>
                    Step 8 - Status:<br>
                    Wallet loaded successfully!
                </p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://www.w3.org/TR/xml/">XML Specification (W3C)</a><br>
                <a href="https://en.wikipedia.org/wiki/Advanced_Encryption_Standard">AES Encryption (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/SHA-2">SHA-256 Algorithm (Wikipedia)</a><br>
                <a href="https://www.secg.org/sec2-v2.pdf">SEC 2: Recommended Elliptic Curve Domain Parameters (secp256r1)</a>
            </p>
        </section>

        <!-- Step 2: Read and Validate Transaction File -->
        <section class="content-box">
            <h3>Step 2: Read and Validate Transaction Group File</h3>
            <p>
                Prompt the user to provide a text file containing multiple transactions. The file must follow a specific format with a header and transaction details (wallet address and amount, no order ID). Validate the file structure, wallet addresses, amounts, and check for duplicate wallet addresses. Compute the total wallet_to string and total order amount.
            </p>
            <div class="content-box">
                <h4>Transaction File Format</h4>
                <p>
                    The transaction file is a tilde-separated text file with:
                    <ul>
                        <li><strong>Header</strong>: <code>tallybox~parcel_of_transactions</code></li>
                        <li><strong>Transactions</strong>: Each transaction has 4 fields:
                            <ul>
                                <li><code>wallet_to_N</code>: Label (e.g., <code>wallet_to_1</code>)</li>
                                <li><code>wallet_address</code>: Valid Tallybox address starting with <code>box</code></li>
                                <li><code>order_amount_N</code>: Label (e.g., <code>order_amount_1</code>)</li>
                                <li><code>amount</code>: Positive number (e.g., <code>3500.00000000</code>)</li>
                            </ul>
                        </li>
                    </ul>
                </p>
                <p><strong>Example Transaction File:</strong></p>
                <textarea class="textarea-cyan" readonly>
tallybox~parcel_of_transactions~
wallet_to_1~boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~order_amount_1~3500.00000000~
wallet_to_2~boxBff9b94f6471HQTnUgStoT5gwUkJLiVUWQbXkTcjqshqkD94vSTymkhF~order_amount_2~3700.00000000
                </textarea>
                <p><strong>Single-Line Format (Optional):</strong></p>
                <textarea class="textarea-green" readonly>
tallybox~parcel_of_transactions~wallet_to_1~boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~order_amount_1~3500.00000000~wallet_to_2~boxBff9b94f6471HQTnUgStoT5gwUkJLiVUWQbXkTcjqshqkD94vSTymkhF~order_amount_2~3700.00000000
                </textarea>
                <p><strong>Validation Rules:</strong></p>
                <ul>
                    <li>File must start with <code>tallybox~parcel_of_transactions</code>.</li>
                    <li>Total fields = 2 (header) + 4N (N transactions).</li>
                    <li>Labels must be <code>wallet_to_N</code>, <code>order_amount_N</code> (N starts at 1).</li>
                    <li>Wallet addresses must start with <code>box</code> and pass MD5 checksum validation.</li>
                    <li>Amounts must be positive numbers (integer or decimal).</li>
                    <li>No duplicate <code>wallet_to</code> addresses are allowed; raise error <code>error~304~duplicate wallet address found~&lt;address&gt;</code>.</li>
                </ul>
                <p><strong>Error Example (Duplicate Wallet Addresses):</strong></p>
                <textarea class="textarea-red" readonly>
tallybox~parcel_of_transactions~
wallet_to_1~boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~order_amount_1~3500.00000000~
wallet_to_2~boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~order_amount_2~3700.00000000
                </textarea>
                <p><strong>Error Output:</strong></p>
                <textarea class="textarea-red" readonly>
Error: error~304~duplicate wallet address found~boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7
                </textarea>
            </div>
            <br>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Read and Validate Transaction File</strong><br><br>
                <pre>
FUNCTION read_transaction_file(file_path):
    TRY:
        content = READ_FILE(file_path).TRIM()
        parts = content.SPLIT("~")
        IF length(parts) < 2 OR parts[0] != "tallybox" OR parts[1] != "parcel_of_transactions":
            THROW "Invalid file format: must start with tallybox~parcel_of_transactions"
        IF (length(parts) - 2) MOD 4 != 0:
            THROW "Invalid number of fields: expected 2 + 4N"
        
        transactions = CREATE_LIST()
        total_wallet_to = ""
        total_amount = 0.0
        wallet_to_set = CREATE_SET()  // For duplicate checking
        
        FOR i = 2 TO length(parts) - 1 STEP 4:
            wallet_to_label = parts[i]
            wallet_to = parts[i + 1]
            order_amount_label = parts[i + 2]
            order_amount = parts[i + 3]
            
            transaction_num = (i - 2) / 4 + 1
            IF wallet_to_label != "wallet_to_" + transaction_num OR
               order_amount_label != "order_amount_" + transaction_num:
                THROW "Invalid field labels for transaction " + transaction_num
            
            IF wallet_to IN wallet_to_set:
                THROW "error~304~duplicate wallet address found~" + wallet_to
            END IF
            wallet_to_set.ADD(wallet_to)
            
            IF NOT VALIDATE_WALLET_ADDRESS(wallet_to):
                THROW "error~301~invalid wallet format~" + wallet_to
            IF NOT IS_NUMBER(order_amount) OR PARSE_NUMBER(order_amount) <= 0:
                THROW "error~303~invalid numeric data~order_amount_" + order_amount
            
            transaction = CREATE_RECORD()
            transaction.SET_FIELD("wallet_to", wallet_to)
            transaction.SET_FIELD("order_amount", order_amount)
            transactions.APPEND(transaction)
            
            total_wallet_to = total_wallet_to + wallet_to + "~" + order_amount + "~"
            total_amount = total_amount + PARSE_NUMBER(order_amount)
        
        IF length(transactions) == 0:
            THROW "No valid transactions found"
        
        RETURN transactions, total_wallet_to, total_amount
    CATCH error:
        THROW "Failed to read transaction file: " + error
END FUNCTION
                </pre>
                </p>
                <p><strong>Pseudo-Code: Validate Wallet Address</strong><br><br>
                <pre>
FUNCTION VALIDATE_WALLET_ADDRESS(address):
    // Check for null/empty or insufficient length
    IF address IS NULL OR address.LENGTH < 40:
        RETURN FALSE
    END IF
    
    // Check prefix
    IF NOT address.STARTS_WITH("box"):
        RETURN FALSE
    END IF
    
    // Check curve character (4th character)
    curve_char = address[3]
    IF curve_char NOT IN ["A", "B", "C"]:
        RETURN FALSE
    END IF
    
    // Checksum validation
    checksum_md5 = address.SUBSTRING(4, 15) // Characters 4 to 14 (11 characters)
    base58_part = address.SUBSTRING(15)     // From character 15 to end
    computed_md5 = MD5(base58_part.encode()).SUBSTRING(0, 11)
    
    IF checksum_md5 == computed_md5:
        RETURN TRUE
    END IF
    
    RETURN FALSE
END FUNCTION
                </pre>
                </p>
                <p>
                    <strong>Warning: File Validation</strong><br>
                    Ensure the transaction file adheres to the specified format. Incorrect labels, invalid wallet addresses, non-positive amounts, or duplicate wallet addresses will cause validation errors.
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                    Step 1 - File Content:<br>
                    tallybox~parcel_of_transactions~wallet_to_1~boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~order_amount_1~3500.00000000~wallet_to_2~boxBff9b94f6471HQTnUgStoT5gwUkJLiVUWQbXkTcjqshqkD94vSTymkhF~order_amount_2~3700.00000000<br><br>
                    Step 2 - Parsed Fields (10 total):<br>
                    ['tallybox', 'parcel_of_transactions', 'wallet_to_1', 'boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7', 'order_amount_1', '3500.00000000', 'wallet_to_2', 'boxBff9b94f6471HQTnUgStoT5gwUkJLiVUWQbXkTcjqshqkD94vSTymkhF', 'order_amount_2', '3700.00000000']<br><br>
                    Step 3 - Transaction 1:<br>
                    Wallet To: boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7<br>
                    Amount: 3500.00000000<br><br>
                    Step 4 - Transaction 2:<br>
                    Wallet To: boxBff9b94f6471HQTnUgStoT5gwUkJLiVUWQbXkTcjqshqkD94vSTymkhF<br>
                    Amount: 3700.00000000<br><br>
                    Step 5 - Totals:<br>
                    Total Wallet To: boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~3500.00000000~boxBff9b94f6471HQTnUgStoT5gwUkJLiVUWQbXkTcjqshqkD94vSTymkhF~3700.00000000~<br>
                    Total Amount: 7200.00000000<br><br>
                    Step 6 - Status:<br>
                    2 transactions loaded successfully!
                </p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/File_format">File Formats (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/MD5">MD5 Algorithm (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Data_validation">Data Validation (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 3: Prepare Transaction Group -->
        <section class="content-box">
            <h3>Step 3: Prepare Transaction Group</h3>
            <p>
                Prompt the user for the token name (e.g., 2PN, 2ZR, TLH). Use the transaction file data to compute the total wallet_to string (concatenated <code>wallet_to~order_amount~</code>) and total order amount. Generate a SHA-256 hash of the total wallet_to string. Set the order ID to the Unix timestamp prefixed with '#'. Sign the consolidated transaction using ECDSA (secp256r1) with RFC 6979 deterministic signatures. Save the signed transaction to an offline file.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Prepare Transaction Group</strong><br><br>
                <pre>
FUNCTION prepare_group_transaction(wallet_state, transactions, total_wallet_to, total_amount):
    token = PROMPT_USER("Select token: [2PN, 2ZR, TLH]")
    graph = wallet_state.graph
    utc_unix = CURRENT_TIMESTAMP_SECONDS()

    IF NOT (token IN ["2PN", "2ZR", "TLH"]):
        THROW "Invalid token"

    wallet_to_hash = SHA256(total_wallet_to.encode('utf-8')).hex()
    order_id = "#" + utc_unix

    transaction_data = graph + "~" + graph + "~" + 
                      wallet_state.wallet_address + "~" + wallet_to_hash + "~" + 
                      token + "~" + FORMAT_DECIMAL(total_amount, 8) + "~" + order_id + "~" + utc_unix
    msg_hash = SHA256(transaction_data.encode('utf-8')).bytes()
    
    signature = wallet_state.key_pair.SIGN_ECDSA(msg_hash, curve="secp256r1", deterministic=RFC6979)
    sig_der = signature.TO_DER()
    sig_base64 = BASE64_ENCODE(sig_der)
    
    broadcast_data = CONCATENATE_WITH_SEPARATOR(
        "tallybox",
        "parcel_of_transaction",
        "number_of_transactions", length(transactions),
        "graph_from", graph,
        "graph_to", graph,
        "wallet_from", wallet_state.wallet_address,
        "wallet_to", wallet_to_hash,
        "order_currency", token,
        "order_amount", FORMAT_DECIMAL(total_amount, 8),
        "order_id", order_id,
        "order_utc_unix", utc_unix,
        "the_sign", sig_base64,
        "publicKey_xy_compressed", wallet_state.public_key_b58,
        separator="~"
    )
    
    timestamp = FORMAT_TIMESTAMP(utc_unix, "YYYY_MM_DD_HH_MM_SS")
    filename = CONCATENATE("sample_tx", "_offline_", token, "_", timestamp, ".txt")
    WRITE_FILE(filename, broadcast_data)
    
    RETURN broadcast_data, token
END FUNCTION
                </pre>
                </p>
                <p>
                    <strong>Success: Transaction Group Signing</strong><br>
                    The signed transaction is a tilde-separated string including the number of transactions, hashed wallet_to, signature, and public key, saved to an offline file for later broadcasting. The signature is not URI-encoded in the offline file but will be encoded during broadcasting.
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                    Step 1 - Selected Token:<br>
                    TLH<br><br>
                    Step 2 - Total Wallet To:<br>
                    boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~3500.00000000~boxBff9b94f6471HQTnUgStoT5gwUkJLiVUWQbXkTcjqshqkD94vSTymkhF~3700.00000000~<br><br>
                    Step 3 - Wallet To Hash (SHA-256):<br>
                    7b9e4f2e8a3e9c1d6b2f4e8c7a5d3b9f1c2e4a6b7d8e9f0a1b2c3d4e5f6a7b8<br><br>
                    Step 4 - Order ID:<br>
                    #1745562261<br><br>
                    Step 5 - Transaction Data:<br>
                    tallybox.mixoftix.net~tallybox.mixoftix.net~boxBd0e08436d01CSjqsUPgP9uamYUYsPFv6NyzvLfHGMBXmuubEp8MdZdz~7b9e4f2e8a3e9c1d6b2f4e8c7a5d3b9f1c2e4a6b7d8e9f0a1b2c3d4e5f6a7b8~TLH~7200.00000000~#1745562261~1745562261<br><br>
                    Step 6 - Message Hash (SHA-256):<br>
                    3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4<br><br>
                    Step 7 - Signature (Base64):<br>
                    MEQCIBhk5tzsQJFNnBBrus8BZqJBqDeRsAa2HNj151wFhCxJAiBqTefQGjboPcSKLIQUlvHDdjzzgM4MrrA9rOa7KFDDsA==<br><br>
                    Step 8 - Broadcast Data:<br>
                    tallybox~parcel_of_transaction~number_of_transactions~2~graph_from~tallybox.mixoftix.net~graph_to~tallybox.mixoftix.net~wallet_from~boxBd0e08436d01CSjqsUPgP9uamYUYsPFv6NyzvLfHGMBXmuubEp8MdZdz~wallet_to~7b9e4f2e8a3e9c1d6b2f4e8c7a5d3b9f1c2e4a6b7d8e9f0a1b2c3d4e5f6a7b8~order_currency~TLH~order_amount~7200.00000000~order_id~#1745562261~order_utc_unix~1745562261~the_sign~MEQCIBhk5tzsQJFNnBBrus8BZqJBqDeRsAa2HNj151wFhCxJAiBqTefQGjboPcSKLIQUlvHDdjzzgM4MrrA9rOa7KFDDsA==~publicKey_xy_compressed~8mDnzMdZUKu2GQVLVfBLgVvw9VroBG8GoYHR9JjY7kzg*2<br><br>
                    Step 9 - Saved File:<br>
                    sample_tx_offline_TLH_2025_04_26_06_25_18.txt
                </p>
            </div>
            <br>
            <div class="green-box">
                <p><strong>Example Output:</strong><br><br>
                <textarea class="textarea-green">
tallybox~parcel_of_transaction~number_of_transactions~2~graph_from~tallybox.mixoftix.net~graph_to~tallybox.mixoftix.net~wallet_from~boxBd0e08436d01CSjqsUPgP9uamYUYsPFv6NyzvLfHGMBXmuubEp8MdZdz~wallet_to~7b9e4f2e8a3e9c1d6b2f4e8c7a5d3b9f1c2e4a6b7d8e9f0a1b2c3d4e5f6a7b8~order_currency~TLH~order_amount~7200.00000000~order_id~#1745562261~order_utc_unix~1745562261~the_sign~MEQCIBhk5tzsQJFNnBBrus8BZqJBqDeRsAa2HNj151wFhCxJAiBqTefQGjboPc instant messaging~publicKey_xy_compressed~8mDnzMdZUKu2GQVLVfBLgVvw9VroBG8GoYHR9JjY7kzg*2
                </textarea>
                </p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm">ECDSA Algorithm (Wikipedia)</a><br>
                <a href="https://tools.ietf.org/html/rfc6979">RFC 6979: Deterministic Usage of DSA and ECDSA</a><br>
                <a href="https://en.wikipedia.org/wiki/SHA-2">SHA-256 Algorithm (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Base64">Base64 Encoding (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 4: Broadcast Transaction Group -->
        <section class="content-box">
            <h3>Step 4: Broadcast Transaction Group</h3>
            <p>
                Broadcast the signed Transaction Group to the DAG node's API endpoint (<code>/broadcast.asmx/order_accept_multiple</code>) using a POST request. Include both the consolidated transaction and the original transaction details (without order IDs). The signature in the broadcast data must be URI-encoded. Handle the response to confirm whether the transaction was accepted or rejected.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Broadcast Transaction Group</strong><br><br>
                <pre>
FUNCTION broadcast_group_transaction(wallet_state, broadcast_data, transactions):
    url = wallet_state.protocol + "://" + wallet_state.graph + "/broadcast.asmx/order_accept_multiple"
    
    order_csv_multiple = CONCATENATE_WITH_SEPARATOR(
        "tallybox",
        "parcel_of_transactions",
        FOR EACH transaction IN transactions WITH index:
            "wallet_to_" + index,
            transaction.wallet_to,
            "order_amount_" + index,
            transaction.order_amount,
        separator="~"
    )
    
    broadcast_parts = broadcast_data.SPLIT("~")
    
    tallybox, parcel_type, num_label, num_txs, graph_from_label, graph_from, graph_to_label, graph_to, \
    wallet_from_label, wallet_from, wallet_to_label, wallet_to, order_currency_label, order_currency, \
    order_amount_label, order_amount, order_id_label, order_id, order_utc_unix_label, order_utc_unix, \
    the_sign_label, sig_base64, public_key_label, public_key_b58 = broadcast_parts
    
    IF NOT (tallybox == "tallybox" AND parcel_type == "parcel_of_transaction" AND
            num_label == "number_of_transactions" AND graph_from_label == "graph_from" AND
            graph_to_label == "graph_to" AND wallet_from_label == "wallet_from" AND
            wallet_to_label == "wallet_to" AND order_currency_label == "order_currency" AND
            order_amount_label == "order_amount" AND order_id_label == "order_id" AND
            order_utc_unix_label == "order_utc_unix" AND the_sign_label == "the_sign" AND
            public_key_label == "publicKey_xy_compressed"):
        THROW "Invalid broadcast data structure"
    END IF
    
    broadcast_data_quoted = CONCATENATE_WITH_SEPARATOR(
        tallybox, parcel_type, num_label, num_txs, graph_from_label, graph_from, graph_to_label, graph_to,
        wallet_from_label, wallet_from, wallet_to_label, wallet_to, order_currency_label, order_currency,
        order_amount_label, order_amount, order_id_label, ENCODE_URI_COMPONENT(order_id), order_utc_unix_label, order_utc_unix,
        the_sign_label, ENCODE_URI_COMPONENT(sig_base64), public_key_label, public_key_b58,
        separator="~"
    )
    
    post_data = "app_name=tallybox&app_version=2.0&order_csv=" + broadcast_data_quoted + 
                "&order_csv_multiple=" + order_csv_multiple)
    
    TRY:
        response = POST_REQUEST(url, post_data, headers={"Content-Type": "application/x-www-form-urlencoded"})
        IF response.STARTS_WITH("submitted~200~"):
            RETURN "Group transaction broadcast successfully: " + response
        ELSE:
            parts = response.SPLIT("~")
            error_code = parts[1] OR "unknown"
            error_message = parts[2] OR "no details provided"
            THROW "Broadcast failed with error " + error_code + ": " + error_message
    CATCH error:
        THROW "Failed to broadcast Transaction Group: " + error
END FUNCTION
                </pre>
                </p>
                <p>
                    <strong>Success: Transaction Group Broadcasting</strong><br>
                    A successful broadcast returns a response starting with <code>submitted~200~</code>, indicating the Transaction Group was accepted by the DAG node.
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                    Step 1 - Constructed POST Data:<br>
                    app_name=tallybox&app_version=2.0&order_csv=tallybox~parcel_of_transaction~number_of_transactions~2~graph_from~tallybox.mixoftix.net~graph_to~tallybox.mixoftix.net~wallet_from~boxBd0e08436d01CSjqsUPgP9uamYUYsPFv6NyzvLfHGMBXmuubEp8MdZdz~wallet_to~7b9e4f2e8a3e9c1d6b2f4e8c7a5d3b9f1c2e4a6b7d8e9f0a1b2c3d4e5f6a7b8~order_currency~TLH~order_amount~7200.00000000~order_id~%231745562261~order_utc_unix~1745562261~the_sign~MEQCIBhk5tzsQJFNnBBrus8BZqJBqDeRsAa2HNj151wFhCxJAiBqTefQGjboPcSKLIQUlvHDdjzzgM4MrrA9rOa7KFDDsA%3D%3D~publicKey_xy_compressed~8mDnzMdZUKu2GQVLVfBLgVvw9VroBG8GoYHR9JjY7kzg*2&order_csv_multiple=tallybox~parcel_of_transactions~wallet_to_1~boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~order_amount_1~3500.00000000~wallet_to_2~boxBff9b94f6471HQTnUgStoT5gwUkJLiVUWQbXkTcjqshqkD94vSTymkhF~order_amount_2~3700.00000000<br><br>
                    Step 2 - Server Endpoint URL:<br>
                    https://tallybox.mixoftix.net/broadcast.asmx/order_accept_multiple<br><br>
                    Step 3 - Server Response:<br>
                    submitted~200~1745562265<br><br>
                    Step 4 - Status:<br>
                    Group transaction broadcast successfully!
                </p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/HTTP#Request_methods">HTTP POST Request (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Percent-encoding">URI Encoding (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Application_programming_interface">API Concepts (Wikipedia)</a>
            </p>
        </section>

        <!-- Main Workflow -->
        <section class="content-box">
            <h3>Main Workflow</h3>
            <p>
                Combine the above steps into a main function that orchestrates the entire process: loading the wallet, reading the transaction file, preparing the transaction group, saving it offline, and optionally broadcasting it. Prompt the user for inputs and provide options to enable debug logging or quit without broadcasting.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Main Workflow</strong><br><br>
                <pre>
FUNCTION main():
    TRY:
        file_path = PROMPT_USER("Enter wallet XML file path: ")
        password = PROMPT_USER_SECURE("Enter wallet password: ")
        
        log_choice = PROMPT_USER("Show decryption logs? [1] Yes [2] No")
        show_logs = (log_choice == "1")
        
        wallet_state = load_wallet(file_path, password, show_logs=show_logs)
        OUTPUT("Wallet loaded successfully!")
        
        txn_file_path = PROMPT_USER("Enter transaction file path: ")
        transactions, total_wallet_to, total_amount = read_transaction_file(txn_file_path, show_logs=show_logs)
        OUTPUT("Loaded " + length(transactions) + " transactions from " + txn_file_path)
        
        broadcast_data, token = prepare_group_transaction(wallet_state, transactions, total_wallet_to, total_amount, show_logs=show_logs)
        OUTPUT("Group transaction signed: " + broadcast_data)
        OUTPUT("Group transaction saved to " + filename)
        
        action = PROMPT_USER("Select action: [1] Broadcast [2] Quit")
        IF action == "1":
            result = broadcast_group_transaction(wallet_state, broadcast_data, transactions, show_logs=show_logs)
            OUTPUT(result)
        ELSE IF action == "2":
            OUTPUT("Exiting")
            RETURN
        ELSE:
            THROW "Invalid action selected"
    CATCH error:
        OUTPUT("Error: " + error)
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
			<div class="cyan-box">
				<h3>Required Dependencies and Setup for Python edition</h3>
				<p>
					To run python script, ensure you have Python 3.7 or higher installed. The following dependencies are required:
				</p>
				<ul>
					<li><strong>ecdsa</strong>: Install using <pre style="background-color: #222; color: #aaa; padding: 5px; border-radius: 5px;">pip install ecdsa</pre>. Provides RFC 6979-compliant ECDSA signatures for transaction signing.</li>
					<li><strong>cryptography</strong>: Install using <pre style="background-color: #222; color: #aaa; padding: 5px; border-radius: 5px;">pip install cryptography</pre>. Handles AES-256-CBC encryption/decryption and key pair derivation.</li>
					<li><strong>requests</strong>: Install using <pre style="background-color: #222; color: #aaa; padding: 5px; border-radius: 5px;">pip install requests</pre>. Enables HTTP requests to the Tallybox network.</li>
					<li><strong>Standard Libraries</strong>: The script uses <code>xml.etree.ElementTree</code>, <code>hashlib</code>, <code>base64</code>, <code>urllib.parse</code>, <code>time</code>, <code>re</code>, <code>getpass</code>, <code>random</code>, <code>string</code>, and <code>datetime</code>, which are included in Python's standard library.</li>
				</ul>
				<p>
					<strong>Setup Instructions:</strong>
					<ol>
						<li>Install Python 3.7+ from <a href="https://www.python.org/downloads/" target="_blank">python.org</a>.</li>
						<li>Install the required packages by running:
							<pre style="background-color: #222; color: #aaa; padding: 5px; border-radius: 5px;">pip install ecdsa cryptography requests</pre>
						</li>
						<li>Prepare a valid Tallybox wallet XML file (e.g., <code>&lt;wallet_name&gt;.xml</code>) containing <code>wallet_name</code>, <code>public_key_b58_compressed</code>, <code>private_key_aes_b64</code>, and <code>wallet_address</code>.</li>
						<li>Ensure internet access to communicate with the Tallybox network (<code>tallybox.mixoftix.net</code>) and write permissions for saving offline transaction files.</li>
					</ol>
					<strong>Alternative:</strong>
					You can run the script using an online interpreter like <a href="https://colab.research.google.com/" target="_blank">Google Colab</a>, which pre-installs Python and supports the required packages.
				</p>
			</div>
            <br>

        </section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok 3, for its invaluable assistance in creating and updating this TallyBox wallet Transaction Group tutorial.</p>
        </section>

    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->