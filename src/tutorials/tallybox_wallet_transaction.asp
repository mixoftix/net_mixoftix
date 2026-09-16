<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tallybox Wallet - Transaction Tutorial</title>
    <meta name="description" content="A step-by-step tutorial on preparing and broadcasting a transaction using the Tallybox Wallet, with pseudo-code and examples for implementation.">
    <meta name="author" content="shahiN Noursalehi">

	<!--#INCLUDE virtual="/inc_styles.asp"-->

</head>
<body class="dark-mode">
    <header>
        <h1>Tallybox Wallet - Transaction Tutorial</h1>
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
        <a href="tallybox_wallet_transaction.asp">Tallybox Wallet Transaction - Pseudo Edition</a>
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
            <h2>Preparing a Transaction with Tallybox Wallet</h2>
            <p>This tutorial guides you through loading a Tallybox Wallet, checking token balances, and preparing and broadcasting a transaction on a Directed Acyclic Graph (DAG) network. Follow the steps below to implement your own transaction preparation code.</p>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Directed_acyclic_graph">Directed Acyclic Graph (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Cryptocurrency_wallet">Cryptocurrency Wallet (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 1: Load Wallet -->
        <section class="content-box">
            <h3>Step 1: Load Wallet and Decrypt Private Key</h3>
            <p>
                Begin by loading the wallet's XML file, which contains the wallet name, compressed public key, encrypted private key, and wallet address. Prompt the user to select an XML file and enter a local password for decryption. Validate the XML structure and decrypt the private key using the password using a special AES-256-CBC algorithm with custom padding, described below.
            </p>
            <div class="content-box">
                <h4>Special AES-256-CBC with Custom Padding</h4>
                <p>Tallybox uses a unique AES-256-CBC decryption algorithm with custom padding to retrieve the private key. The algorithm derives the key, IV, and salt from a 64-character hex secret key (SHA-256 of wallet_name~password~wallet_address). The plaintext is expected to have random padding around it. The configuration is:
                    <ul>
                        <li><strong>Secret Key</strong>: A 64-character hex string (32 bytes), split into:
                            <ul>
                                <li>Password: First 32 hex chars (16 bytes, ASCII-encoded).</li>
                                <li>IV: Next 16 hex chars (8 bytes, ASCII-encoded, 16 bytes as bytes).</li>
                                <li>Salt: Last 16 hex chars (8 bytes, ASCII-encoded).</li>
                            </ul>
                        </li>
                        <li><strong>Key Derivation</strong>: PBKDF2 with SHA-256, 3 iterations, 32-byte output, using password and salt.</li>
                        <li><strong>Custom Padding</strong>: Expected format is random string (0–99 chars, a-zA-Z) + '|' + plaintext (64-char hex private key) + '|' + random string (0–99 chars, a-zA-Z), followed by PKCS#7 padding.</li>
                        <li><strong>Input</strong>: Base64-encoded ciphertext (no IV prepended).</li>
                    </ul>
                </p>
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
            <div class="gray-box">
                <p><strong>Sample Pseudo-Code: Load Wallet</strong><br><br>
                <pre>
FUNCTION load_wallet(file, password, protocol, graph):
    TRY:
        xml_content = READ_FILE(file)
        xml_doc = PARSE_XML(xml_content)
        wallet_name = xml_doc.GET_TAG("wallet_name")
        public_key_b58 = xml_doc.GET_TAG("public_key_b58_compressed")
        private_key_aes_b64 = xml_doc.GET_TAG("private_key_aes_b64")
        wallet_address = xml_doc.GET_TAG("wallet_address")

        IF NOT (wallet_name AND public_key_b58 AND private_key_aes_b64 AND wallet_address):
            RETURN ERROR("Invalid XML format")

        key_components = wallet_name + "~" + password + "~" + wallet_address
        local_key = SHA256(key_components)
        private_key = aes256_cbc_decrypt_custom(private_key_aes_b64, local_key)

        ec = NEW_ELLIPTIC_CURVE("p256")
        key_pair = ec.KEY_FROM_PRIVATE(private_key, "hex")
        public_key = key_pair.GET_PUBLIC()
        x_hex = public_key.GET_X().TO_HEX().PAD_START(64, "0")
        y_hex = public_key.GET_Y().TO_HEX().PAD_START(64, "0")
        y_parity = public_key.GET_Y().MOD(2)
        suffix = IF y_parity == 0 THEN "2" ELSE "1"
        compressed_key = x_hex + "*" + suffix

        result = CREATE_RECORD()
        result.SET_FIELD("key_pair", key_pair)
        result.SET_FIELD("compressed_key", compressed_key)
        result.SET_FIELD("public_key_b58", public_key_b58)
        result.SET_FIELD("wallet_address", wallet_address)
        result.SET_FIELD("wallet_name", wallet_name)
        RETURN result
    CATCH error:
        RETURN ERROR("Decryption failed or invalid file: " + error)
END FUNCTION
                </pre>
                </p>
                <p>
                    <strong>Notice: XML File Structure</strong><br>
                    The XML file must include <code><wallet_name></code>, <code><public_key_b58_compressed></code>, 
                    <code><private_key_aes_b64></code>, and <code><wallet_address></code>. Ensure the password matches 
                    the one used to encrypt the private key, or decryption will fail.
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                    Step 1 - Loaded Wallet Name:<br>
                    shahin<br><br>
                    Step 2 - Extracted Public Key (Base58 Compressed):<br>
                    3W8iLTuAjbf9d1ih4RCi7Aat6keKxs72SNynZ1A269MY*1<br><br>
                    Step 3 - Extracted Wallet Address:<br>
                    boxBa01d317e6c57Lt8jmf3GNWCJc2K5bU7aAS5gqSbDYnY5UVshnJVHEJP<br><br>
                    Step 4 - Key Components (pre-SHA-256):<br>
                    shahin~11~boxBa01d317e6c57Lt8jmf3GNWCJc2K5bU7aAS5gqSbDYnY5UVshnJVHEJP<br><br>
                    Step 5 - Local Key (SHA-256):<br>
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

        <!-- Step 2: User Choice -->
        <section class="content-box">
            <h3>Step 2: Choose Action (History or Send)</h3>
            <p>
                After successfully loading the wallet, prompt the user to either view their token balances (history) or prepare 
                and sign a transaction to send tokens. Ensure the wallet is loaded before proceeding to either action.
            </p>
            <div class="gray-box">
                <p><strong>Sample Pseudo-Code: User Choice</strong><br><br>
                <pre>
FUNCTION prompt_user_action(wallet_state):
    IF NOT wallet_state.wallet_address:
        RETURN ERROR("No wallet loaded. Load a wallet first.")

    action = PROMPT_USER("Select action: [1] View History, [2] Send Transaction")
    IF action == "1":
        CALL fetch_balances(wallet_state)
    ELSE IF action == "2":
        CALL prepare_transaction(wallet_state)
    ELSE
        RETURN ERROR("Invalid action selected")
END FUNCTION
                </pre>
                </p>
                <p>
                    <strong>Warning: Wallet Validation</strong><br>
                    Always verify that a wallet is loaded (i.e., <code>wallet_address</code> is not empty) before allowing history 
                    or transaction actions. Attempting to proceed without a loaded wallet will result in errors.
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                    No example output provided for this step.
                </p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/User_interface">User Interface Design (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Control_flow">Control Flow in Programming (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 3: Fetch Balances -->
        <section class="content-box">
            <h3>Step 3: Fetch Token Balances</h3>
            <p>
                To view balances, send a POST request to the DAG node's API endpoint 
                (<code>/archive.asmx/order_history</code>) with the wallet address and graph details. Parse the response to 
                extract balances for supported tokens (e.g., 2PN, 2ZR, TLH).
            </p>
            <div class="gray-box">
                <p><strong>Sample Pseudo-Code: Fetch Balances</strong><br><br>
                <pre>
FUNCTION fetch_balances(wallet_state):
    url = wallet_state.protocol + "://" + wallet_state.graph + "/archive.asmx/order_history"
    post_data = "app_name=tallybox&app_version=2.0&in_graph=" + ENCODE_URI_COMPONENT(wallet_state.graph) + "&wallet_address=" + ENCODE_URI_COMPONENT(wallet_state.wallet_address)
    
    TRY:
        response = POST_REQUEST(url, post_data)
        parts = response.SPLIT("~")
        balances = CREATE_RECORD()
        balances.SET_FIELD("2PN", "0.00000000")
        balances.SET_FIELD("2ZR", "0.00000000")
        balances.SET_FIELD("TLH", "0.00000000")
        FOR i = 6 TO parts.LENGTH - 2 STEP 2
            token = parts[i]
            amount = parts[i + 1]
            IF token IN ["2PN", "2ZR", "TLH"] AND amount AND IS_NUMBER(amount):
                balances.SET_FIELD(token, FORMAT_DECIMAL(amount, 8))
            END IF
        END FOR
        RETURN balances
    CATCH error:
        RETURN ERROR("Failed to fetch balances: " + error)
END FUNCTION
                </pre>
                </p>
                <p>
                    <strong>Info: API Endpoint</strong><br>
                    The default graph is <code>tallybox.mixoftix.net</code>, and the protocol is typically <code>https</code>. 
                    The API returns a tilde-separated string where token balances appear as pairs (e.g., <code>2PN~123.456789</code>).
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                    Step 0 - Current Date-Time:<br>
                    2025-04-17 04:30:08<br><br>
                    Step 1 - Constructed POST Data:<br>
                    app_name=tallybox&app_version=2.0&in_graph=tallybox.mixoftix.net&wallet_address=boxBa01d317e6c57Lt8jmf3GNWCJc2K5bU7aAS5gqSbDYnY5UVshnJVHEJP<br><br>
                    Step 2 - Server Endpoint URL:<br>
                    https://tallybox.mixoftix.net/archive.asmx/order_history<br><br>
                    Step 3 - Server Response:<br>
                    tallybox.mixoftix.net~boxBa01d317e6c57Lt8jmf3GNWCJc2K5bU7aAS5gqSbDYnY5UVshnJVHEJP~msg~null~adv~null~null<br><br>
                    Step 4 - Status:<br>
                    History fetched successfully!
                </p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/HTTP#Request_methods">HTTP POST Request (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Percent-encoding">URI Encoding (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Application_programming_interface">API Concepts (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 4: Prepare Transaction -->
		<section class="content-box">
			<h3>Step 4: Prepare Transaction</h3>
			<p>
				Prompt the user for the target wallet address, token name (e.g., 2PN, 2ZR, TLH), amount, and an optional order ID. 
				Validate the target wallet address to ensure it conforms to Tallybox's format. Generate an offline signature using 
				the private key with the ECDSA (Elliptic Curve Digital Signature Algorithm) on the secp256r1 curve, following RFC 6979 
				for deterministic signature generation, to create a signed transaction ready for broadcasting.
			</p>
			<div class="gray-box">
			<p><strong>Sample Pseudo-Code: Prepare Transaction</strong><br><br>
			<pre>
FUNCTION prepare_transaction(wallet_state):
    target_address = PROMPT_USER("Enter target wallet address")
    token = PROMPT_USER("Select token: [2PN, 2ZR, TLH]")
    amount = PROMPT_USER("Enter amount (positive number)")
    order_id = PROMPT_USER("Enter optional order ID", optional=true)
    graph = wallet_state.graph
    utc_unix = CURRENT_TIMESTAMP_SECONDS()

    IF NOT VALIDATE_WALLET_ADDRESS(target_address):
        RETURN ERROR("Invalid target wallet address")
    IF NOT (token IN ["2PN", "2ZR", "TLH"]):
        RETURN ERROR("Invalid token")
    IF NOT IS_NUMBER(amount) OR amount <= 0:
        RETURN ERROR("Invalid amount")

    transaction_data = ENCODE_URI_COMPONENT(graph) + "~" + ENCODE_URI_COMPONENT(graph) + "~" + 
                       ENCODE_URI_COMPONENT(wallet_state.wallet_address) + "~" + 
                       ENCODE_URI_COMPONENT(target_address) + "~" + ENCODE_URI_COMPONENT(token) + "~" + 
                       FORMAT_DECIMAL(amount, 8) + "~" + ENCODE_URI_COMPONENT(order_id) + "~" + utc_unix
    msg_hash = SHA256(transaction_data)
    ec = NEW_ELLIPTIC_CURVE("p256")
    signature = wallet_state.key_pair.SIGN_ECDSA(msg_hash, RFC6979) // Produces (r, s) pair, deterministic per RFC 6979
    sig_der = signature.TO_DER("hex")                              // Encode (r, s) as DER, hex string
    sig_base64 = BASE64_ENCODE(HEX_TO_BYTES(sig_der))             // Convert hex to bytes, encode as Base64
    broadcast_data = CONCATENATE_WITH_SEPARATOR(
        "tallybox",
        "parcel_of_transaction",
        "graph_from", ENCODE_URI_COMPONENT(graph),
        "graph_to", ENCODE_URI_COMPONENT(graph),
        "wallet_from", ENCODE_URI_COMPONENT(wallet_state.wallet_address),
        "wallet_to", ENCODE_URI_COMPONENT(target_address),
        "order_currency", ENCODE_URI_COMPONENT(token),
        "order_amount", FORMAT_DECIMAL(amount, 8),
        "order_id", ENCODE_URI_COMPONENT(order_id),
        "order_utc_unix", utc_unix,
        "the_sign", ENCODE_URI_COMPONENT(sig_base64),
        "publicKey_xy_compressed", ENCODE_URI_COMPONENT(wallet_state.public_key_b58),
        separator="~"
    )

    RETURN broadcast_data
END FUNCTION
				</pre>
				</p>
				<p><strong>Sample Pseudo-Code: Validate Wallet Address</strong><br><br>
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
					<strong>Success: Transaction Signing</strong><br>
					A successful offline signature produces a tilde-separated string containing the transaction details, 
					signature, and public key, ready for broadcasting to the DAG node.
					<br><br>
					<strong>Note:</strong> The ECDSA signing process must comply with RFC 6979 to ensure deterministic signatures, 
					enhancing security and reproducibility.
				</p>
			</div>
			<br>
			<div class="cyan-box">
				<p><strong>Example Process:</strong><br><br>
					Step 1 - Transaction Data:<br>
					tallybox.mixoftix.net~tallybox.mixoftix.net~boxBa01d317e6c57Lt8jmf3GNWCJc2K5bU7aAS5gqSbDYnY5UVshnJVHEJP~boxB8cbfbaf9c1c4Pfyp4JMNThyUhNh4PPdD7hiXBeTJgQtU7npfZSMEH68~2ZR~34.54000000~~1744889500<br><br>
					Step 2 - SHA-256 Hash:<br>
					d838bdb3dfe7f3a8b07931c99f90080d46c0757fbe994a9863a6135ef5645006<br><br>
					Step 3 - Signature (Base64):<br>
					MEUCIQDDK5ALX00hImyHHL/dpKGDMnYLmLG6hkz9Q4vmUsydFQIgLd88G7AUp2IbQMwyNAIAlrSqYlh8zCzq7jOXj+JzmDM=<br><br>
					Step 4 - Broadcast Result:<br>
					tallybox~parcel_of_transaction~graph_from~tallybox.mixoftix.net~graph_to~tallybox.mixoftix.net~wallet_from~boxBa01d317e6c57Lt8jmf3GNWCJc2K5bU7aAS5gqSbDYnY5UVshnJVHEJP~wallet_to~boxB8cbfbaf9c1c4Pfyp4JMNThyUhNh4PPdD7hiXBeTJgQtU7npfZSMEH68~order_currency~2ZR~order_amount~34.54000000~order_id~~order_utc_unix~1744889500~the_sign~MEUCIQDDK5ALX00hImyHHL%2FdpKGDMnYLmLG6hkz9Q4vmUsydFQIgLd88G7AUp2IbQMwyNAIAlrSqYlh8zCzq7jOXj%2BJzmDM%3D~publicKey_xy_compressed~3W8iLTuAjbf9d1ih4RCi7Aat6keKxs72SNynZ1A269MY*1
				</p>
			</div>
			<br>
			<div class="green-box">
				<p><strong>Example Output:</strong><br><br>
				<textarea class="textarea-green" readonly>tallybox~parcel_of_transaction~graph_from~tallybox.mixoftix.net~graph_to~tallybox.mixoftix.net~wallet_from~boxBa01d317e6c57Lt8jmf3GNWCJc2K5bU7aAS5gqSbDYnY5UVshnJVHEJP~wallet_to~boxB8cbfbaf9c1c4Pfyp4JMNThyUhNh4PPdD7hiXBeTJgQtU7npfZSMEH68~order_currency~2ZR~order_amount~34.54000000~order_id~~order_utc_unix~1744889500~the_sign~MEUCIQDDK5ALX00hImyHHL%2FdpKGDMnYLmLG6hkz9Q4vmUsydFQIgLd88G7AUp2IbQMwyNAIAlrSqYlh8zCzq7jOXj%2BJzmDM%3D~publicKey_xy_compressed~3W8iLTuAjbf9d1ih4RCi7Aat6keKxs72SNynZ1A269MY*1</textarea>
				</p>
			</div>
			<p><strong>References:</strong><br>
				<a href="https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm">ECDSA Algorithm (Wikipedia)</a><br>
				<a href="https://tools.ietf.org/html/rfc6979">RFC 6979: Deterministic Usage of DSA and ECDSA</a><br>
				<a href="https://en.wikipedia.org/wiki/SHA-2">SHA-256 Algorithm (Wikipedia)</a><br>
				<a href="https://en.wikipedia.org/wiki/Base64">Base64 Encoding (Wikipedia)</a><br>
				<a href="https://en.wikipedia.org/wiki/MD5">MD5 Algorithm (Wikipedia)</a><br>
				<a href="https://en.wikipedia.org/wiki/Percent-encoding">URI Encoding (Wikipedia)</a>
			</p>
		</section>

        <!-- Step 5: Broadcast Transaction -->
        <section class="content-box">
            <h3>Step 5: Broadcast Transaction</h3>
            <p>
                Broadcast the signed transaction to the DAG node's API endpoint 
                (<code>/broadcast.asmx/order_accept</code>) using a POST request. Handle the response to confirm whether 
                the transaction was accepted or rejected by the network.
            </p>
            <div class="gray-box">
                <p><strong>Sample Pseudo-Code: Broadcast Transaction</strong><br><br>
                <pre>
FUNCTION broadcast_transaction(wallet_state, broadcast_data):
    url = wallet_state.protocol + "://" + wallet_state.graph + "/broadcast.asmx/order_accept"
    post_data = "app_name=tallybox&app_version=2.0&order_csv=" + ENCODE_URI_COMPONENT(broadcast_data.REPLACE("\n", "").REPLACE("\r", ""))
    
    TRY:
        response = POST_REQUEST(url, post_data)
        IF response.STARTS_WITH("submitted~200~"):
            RETURN SUCCESS("Transaction broadcast successfully: " + response)
        ELSE
            RETURN ERROR("Broadcast failed: " + response)
    CATCH error:
        RETURN ERROR("Failed to broadcast transaction: " + error)
END FUNCTION
                </pre>
                </p>
                <p>
                    <strong>Success: Transaction Broadcasting</strong><br>
                    A successful broadcast returns a response starting with <code>submitted~200~</code>, indicating the transaction 
                    was accepted by the DAG node. The response includes a transaction ID for tracking.
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                    Step 1 - Constructed POST Data:<br>
                    app_name=tallybox&app_version=2.0&order_csv=tallybox~parcel_of_transaction~graph_from~tallybox.mixoftix.net~graph_to~tallybox.mixoftix.net~wallet_from~boxBa01d317e6c57Lt8jmf3GNWCJc2K5bU7aAS5gqSbDYnY5UVshnJVHEJP~wallet_to~boxB8cbfbaf9c1c4Pfyp4JMNThyUhNh4PPdD7hiXBeTJgQtU7npfZSMEH68~order_currency~2ZR~order_amount~34.54000000~order_id~~order_utc_unix~1744889500~the_sign~MEUCIQDDK5ALX00hImyHHL%2FdpKGDMnYLmLG6hkz9Q4vmUsydFQIgLd88G7AUp2IbQMwyNAIAlrSqYlh8zCzq7jOXj%2BJzmDM%3D~publicKey_xy_compressed~3W8iLTuAjbf9d1ih4RCi7Aat6keKxs72SNynZ1A269MY*1<br><br>
                    Step 2 - Server Endpoint URL:<br>
                    https://tallybox.mixoftix.net/broadcast.asmx/order_accept<br><br>
                    Step 3 - Server Response:<br>
                    error~203~no enough fee~order_amount<br><br>
                    Step 4 - Status:<br>
                    Broadcast failed!
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
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/HTTP#Request_methods">HTTP POST Request (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Percent-encoding">URI Encoding (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Application_programming_interface">API Concepts (Wikipedia)</a>
            </p>
        </section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its invaluable assistance in creating this TallyBox wallet transaction tutorial.</p>
        </section>

    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->
