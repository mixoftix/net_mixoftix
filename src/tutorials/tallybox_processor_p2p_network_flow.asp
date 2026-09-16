<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TallyBox Tutorial - P2P Network Flow</title>
    <meta name="description" content="A step-by-step tutorial on peer-to-peer (P2P) networking in a TallyBox Directed Acyclic Graph (DAG) application using Python, focusing on transaction recomposition by the sender, decomposition by the receiver, data flow, messaging formats, and hash-based synchronization.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

</head>
<body class="dark-mode">
    <header>
        <h1>TallyBox Tutorial - P2P Network Flow</h1>
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
        <a href="tallybox_processor_p2p_network_flow.asp">TallyBox Payment Processor - P2P Network Flow</a>
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
			<h2>P2P Networking in TallyBox DAG</h2>
			<p>This tutorial guides developers through the peer-to-peer (P2P) networking flow in a TallyBox application, which operates on a Directed Acyclic Graph (DAG) structure for scalable and efficient transaction processing. The tutorial emphasizes the sender's role in recomposing transactions from the database into XML messages using the <code>main_recomposer</code> function (with supporting functions <code>transaction_recomposer</code>, <code>group_transaction_recomposer</code>, and <code>minting_transaction_recomposer</code>), followed by the receiver's role in decomposing incoming XML messages using <code>transaction_decomposer</code>.
			<br>
			<br>
			Unlike most blockchain systems that rely on bidirectional synchronization, where peers mutually exchange and reconcile transaction data to maintain a consistent ledger, TallyBox employs unidirectional synchronization. In this approach, the sender peer pushes transaction data to the receiver, which processes and validates it, returning a SHA256 hash to confirm successful integration into the DAG without sending back its own transaction data. This unidirectional flow enhances efficiency in high-throughput scenarios by reducing network overhead and simplifying conflict resolution.
			<br>
			<br>
			This tutorial covers data flow, messaging formats, and the hash-based synchronization mechanism where the receiver generates a SHA256 hash that the sender verifies to confirm synchronization before sending subsequent records. The implementation is in Python, using a SQL Server database for ledger storage and ECDSA (secp256r1) for cryptographic validation.</p>
		</section>
		
        <!-- Step 1: Overview of P2P Networking in TallyBox DAG -->
        <section class="content-box">
            <h3>Step 1: Overview of P2P Networking in TallyBox DAG</h3>
            <p>TallyBox operates as a decentralized P2P network where nodes (peers) exchange transaction records using a DAG structure, allowing transactions to reference multiple previous transactions for scalability. The sender peer uses <code>main_recomposer</code> to construct XML messages in the <code>sync_transaction</code> format from database records and broadcasts them to other peers. The receiver peer processes these messages with <code>transaction_decomposer</code>, validates them, stores them in the database, and generates a final SHA256 hash. This hash is sent back to the sender, who verifies it to ensure successful processing before sending the next record. The system supports three transaction types:
                <ul>
                    <li><strong>Single Transactions:</strong> Transfers between two wallets with a numeric <code>order_id</code>.</li>
                    <li><strong>Group Transactions:</strong> Transfers to multiple recipients, identified by <code>order_id</code> starting with '#', with a hashed <code>wallet_to</code> field.</li>
                    <li><strong>Minting Transactions:</strong> Treasury-based transactions, identified by <code>order_id</code> starting with '$'.</li>
                </ul>
                The data flow starts with the sender recomposing and broadcasting transactions, followed by the receiver decomposing, validating, and storing them, with hash-based synchronization ensuring DAG consistency.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: P2P Networking Overview</strong><br><br>
                <pre>
FUNCTION sender_broadcast_and_sync(tnx_id, the_tnx_md5):
    xml_string = main_recomposer(tnx_id, the_tnx_md5)
    IF xml_string IS NOT NULL THEN
        log_message("Broadcasting transaction: " + tnx_id)
        broadcast_to_peers(xml_string)
        RETURN xml_string
    ELSE
        log_message("Failed to recompose transaction")
        RETURN NULL
    END IF

FUNCTION receiver_process(xml_string):
    sha256_hash = transaction_decomposer(xml_string)
    IF sha256_hash IS NOT NULL THEN
        log_message("Processed transaction, hash: " + sha256_hash)
        send_to_sender(sha256_hash)  // Notify sender for synchronization
        broadcast_to_peers(xml_string)
        RETURN sha256_hash
    ELSE
        log_message("Failed to process transaction")
        RETURN NULL
    END IF
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                Sender Peer: Reconstructs XML with main_recomposer, broadcasts to Peer B<br>
                Receiver Peer (B): Processes XML with transaction_decomposer, generates SHA256 hash (e.g., '7c4a8d09ca3762af61e59520943dc26494f8941b'), sends to Sender<br>
                Sender Peer: Verifies hash, sends next transaction<br>
                Receiver Peer (B): Broadcasts XML to Peer C</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Directed_acyclic_graph">Directed Acyclic Graph (Wikipedia)</a><br>
                <a href="https://learn.microsoft.com/en-us/sql/connect/python/pyodbc/python-sql-driver-pyodbc">PyODBC (Microsoft Docs)</a>
            </p>
        </section>

        <!-- Step 2: Sender - Transaction Recomposition -->
        <section class="content-box">
            <h3>Step 2: Sender - Transaction Recomposition</h3>
            <p>The sender peer uses the <code>main_recomposer</code> function to retrieve transaction data from the database and construct XML messages in the <code>sync_transaction</code> format for broadcasting. It delegates to one of three functions based on the <code>order_id</code> prefix:
                <ul>
                    <li><code>transaction_recomposer</code>: For single transactions (numeric <code>order_id</code>).</li>
                    <li><code>group_transaction_recomposer</code>: For group transactions (<code>order_id</code> starts with '#').</li>
                    <li><code>minting_transaction_recomposer</code>: For minting transactions (<code>order_id</code> starts with '$').</li>
                </ul>
                The process involves querying database tables, reconstructing the <code>order_csv</code> and <code>order_csv_multiple</code> fields, and formatting the XML with precise decimal handling for <code>tnx_id</code>.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Recompose Transaction</strong><br><br>
                <pre>
FUNCTION main_recomposer(tnx_id, the_tnx_md5):
    order_id = sql_find_record("tbl_tallybox_sign", "order_id", "tnx_id", tnx_id, "the_tnx_md5", the_tnx_md5)
    IF order_id == "no_record" THEN
        log_error("Transaction not found")
        RETURN NULL
    END IF
    IF order_id.starts_with("$") THEN
        RETURN minting_transaction_recomposer(tnx_id, the_tnx_md5)
    ELSE IF order_id.starts_with("#") THEN
        RETURN group_transaction_recomposer(tnx_id, the_tnx_md5)
    ELSE
        RETURN transaction_recomposer(tnx_id, the_tnx_md5)
    END IF

FUNCTION transaction_recomposer(tnx_id, the_tnx_md5):
    sign_data = sql_query("tbl_tallybox_sign", tnx_id, the_tnx_md5)
    sender_data = sql_query("tbl_tallybox_book", tnx_type="1", tnx_id)
    wallet_from = sql_query("tbl_tallybox_wallet", sender_data.wallet_id)
    public_key = sql_query("tbl_tallybox_wallet_pubkey", sender_data.wallet_id)
    order_currency = sql_query("tbl_system_currency", sender_data.currency_id)
    graph_from = sql_query("tbl_system_graph", sender_data.graph_id)
    recipient_data = sql_query("tbl_tallybox_book", tnx_type="2", tnx_id)
    wallet_to = sql_query("tbl_tallybox_wallet", recipient_data.wallet_id)
    graph_to = sql_query("tbl_system_graph", recipient_data.graph_id)
    order_csv = join_fields(["tallybox", "parcel_of_transaction", "graph_from", graph_from, ..., "publicKey_xy_compressed", public_key], "~")
    xml = create_xml(order_csv, "", tnx_id, the_tnx_md5)
    RETURN xml
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Recomposed XML:</strong><br><br>
                <textarea class="textarea-cyan" readonly>
<sync_transaction>
  <order_csv>tallybox~parcel_of_transaction~graph_from~tallybox.mixoftix.net~graph_to~tallybox.mixoftix.net~wallet_from~tjbB2bbc15c8c135...~wallet_to~tjbA3ccd26d9e246...~order_currency~2ZR~order_amount~3500.00000000~order_id~778844~order_utc_unix~1741675583~the_sign~MEYCIQCxzNKhOUXijLr+z2mI9npu/+KZijiEv3//W7Ya3VpvzgIhAI1m7wJLJ9ldP2m5jmYfUreuvoKTjoZmFQmt5e6foakp~publicKey_xy_compressed~base58key*1</order_csv>
  <order_csv_multiple></order_csv_multiple>
  <enforce_tnx_id>1741675600.1</enforce_tnx_id>
  <checksum>b2e3f94169f3d82b9b67d93acbc288a4</checksum>
</sync_transaction>
                </textarea>
                </p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://docs.python.org/3/library/xml.dom.minidom.html">MiniDOM XML (Python Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/XML">XML (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 3: Sender - Broadcasting Transactions -->
        <section class="content-box">
            <h3>Step 3: Sender - Broadcasting Transactions</h3>
            <p>After recomposing the transaction into an XML message, the sender peer broadcasts it to other peers in the TallyBox network. The process involves:
                <ul>
                    <li>Retrieve <code>tnx_id</code> and <code>the_tnx_md5</code> from <code>tbl_tallybox_sign</code> to identify transactions for broadcasting.</li>
                    <li>Use <code>main_recomposer</code> to generate the XML message.</li>
                    <li>Send the XML to connected peers via a socket or other P2P protocol, awaiting a SHA256 hash from each receiver to confirm successful processing.</li>
                </ul>
                The sender waits for hash confirmation before sending the next transaction, ensuring synchronization.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Broadcast Transactions</strong><br><br>
                <pre>
FUNCTION broadcast_transactions():
    transactions = sql_query("tbl_tallybox_sign", "tnx_id, the_tnx_md5")
    FOR tnx_id, the_tnx_md5 IN transactions:
        xml_string = main_recomposer(tnx_id, the_tnx_md5)
        IF xml_string IS NOT NULL THEN
            broadcast_to_peers(xml_string)
            expected_hash = calculate_expected_hash(tnx_id)
            received_hash = await_receiver_hash()
            IF received_hash == expected_hash THEN
                log_message("Synchronization confirmed, sending next record")
                continue
            ELSE
                log_error("Synchronization failed, retrying")
                request_resend(xml_string)
            END IF
        END IF
    END FOR
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Broadcast:</strong><br><br>
                Sender Peer: Queries tnx_id='1741675600.1', the_tnx_md5='b2e3f94169f3d82b9b67d93acbc288a4'<br>
                XML Generated: &lt;sync_transaction&gt;...&lt;/sync_transaction&gt;<br>
                Action: Broadcasts XML to Peer B, awaits SHA256 hash</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Peer-to-peer">Peer-to-Peer Networking (Wikipedia)</a><br>
                <a href="https://docs.python.org/3/library/socket.html">Socket Programming (Python Docs)</a>
            </p>
        </section>

        <!-- Step 4: Receiver - Parsing XML Messages -->
        <section class="content-box">
            <h3>Step 4: Receiver - Parsing XML Messages</h3>
            <p>The receiver peer processes incoming XML messages using the <code>transaction_decomposer</code> function, extracting fields from the <code>sync_transaction</code> structure. The process involves:
                <ul>
                    <li>Parse the XML to extract <code>order_csv</code>, <code>order_csv_multiple</code>, <code>enforce_tnx_id</code>, and <code>checksum</code>.</li>
                    <li>Split <code>order_csv</code> by '~' to obtain fields like <code>graph_from</code>, <code>wallet_from</code>, <code>order_currency</code>, and <code>the_sign</code>.</li>
                    <li>For group transactions, parse <code>order_csv_multiple</code> to extract multiple <code>wallet_to</code> and <code>order_amount</code> pairs.</li>
                    <li>Extract <code>tree_id</code> and <code>branch_id</code> from <code>enforce_tnx_id</code> (format: <code>tree_id.branch_id_reverse</code>).</li>
                </ul>
                The XML format ensures standardized communication across peers, with fields encoded in a tilde-separated string for efficient parsing.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Parse XML Message</strong><br><br>
                <pre>
FUNCTION transaction_decomposer(xml_string):
    TRY:
        root = parse_xml(xml_string)
        order_csv = root.find("order_csv").text
        order_csv_multiple = root.find("order_csv_multiple").text OR ""
        enforce_tnx_id = root.find("enforce_tnx_id").text
        checksum = root.find("checksum").text
        csv_parts = split(order_csv, "~")
        is_group = csv_parts[2] == "number_of_transactions"
        offset = 2 IF is_group ELSE 0
        graph_from = csv_parts[3 + offset]
        graph_to = csv_parts[5 + offset]
        wallet_from = csv_parts[7 + offset]
        wallet_to = csv_parts[9 + offset]
        order_currency = csv_parts[11 + offset]
        order_amount = Decimal(csv_parts[13 + offset])
        order_id = csv_parts[15 + offset]
        order_utc_unix = csv_parts[17 + offset]
        the_sign = csv_parts[19 + offset]
        public_key = csv_parts[21 + offset]
        IF is_group THEN
            multiple_fields = split(order_csv_multiple, "~")
            wallet_to_arr, order_amount_arr = parse_multiple_fields(multiple_fields)
        ELSE
            wallet_to_arr = [wallet_to]
            order_amount_arr = [order_amount]
        END IF
        tree_id, branch_id_reverse = split(enforce_tnx_id, ".")
        branch_id = reverse(branch_id_reverse)
        RETURN parsed_data
    CATCH Exception e:
        log_error("XML parsing error: " + e)
        RETURN NULL
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example XML Input:</strong><br><br>
                <textarea class="textarea-cyan" readonly>
<sync_transaction>
  <order_csv>tallybox~parcel_of_transaction~graph_from~tallybox.mixoftix.net~graph_to~tallybox.mixoftix.net~wallet_from~tjbB2bbc15c8c135...~wallet_to~tjbA3ccd26d9e246...~order_currency~2ZR~order_amount~3500.00000000~order_id~778844~order_utc_unix~1741675583~the_sign~MEYCIQCxzNKhOUXijLr+z2mI9npu/+KZijiEv3//W7Ya3VpvzgIhAI1m7wJLJ9ldP2m5jmYfUreuvoKTjoZmFQmt5e6foakp~publicKey_xy_compressed~base58key*1</order_csv>
  <order_csv_multiple></order_csv_multiple>
  <enforce_tnx_id>1741675600.1</enforce_tnx_id>
  <checksum>b2e3f94169f3d82b9b67d93acbc288a4</checksum>
</sync_transaction>
                </textarea>
                <br><br>
                Parsed Output:<br>
                graph_from: tallybox.mixoftix.net<br>
                wallet_from: tjbB2bbc15c8c135...<br>
                order_currency: 2ZR<br>
                order_amount: 3500.00000000<br>
                tree_id: 1741675600<br>
                branch_id: 1
                </p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://docs.python.org/3/library/xml.etree.elementtree.html">ElementTree XML API (Python Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/XML">XML (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 5: Receiver - Validation and Hash Generation -->
        <section class="content-box">
            <h3>Step 5: Receiver - Validation and Hash Generation</h3>
            <p>The receiver peer validates the parsed transaction and generates a final SHA256 hash for synchronization. The validation and hash generation process includes:
                <ul>
                    <li><strong>Format Validation:</strong> Ensure <code>graph_from</code> and <code>graph_to</code> contain dots, wallets start with 'tjb' and have a valid MD5 checksum, and amounts/timestamps are numeric.</li>
                    <li><strong>Database Validation:</strong> Verify <code>graph_from</code>, <code>graph_to</code>, and <code>order_currency</code> exist in <code>tbl_system_graph</code> and <code>tbl_system_currency</code>.</li>
                    <li><strong>Treasury Transactions ($):</strong> Validate treasury ID, check for double-spending, and ensure currency, amount, and wallet match treasury records.</li>
                    <li><strong>Group Transactions (#):</strong> Verify the SHA256 hash of <code>wallet_to</code> and <code>order_amount</code> pairs, check for duplicates, and ensure total amount matches.</li>
                    <li><strong>Balance Checks:</strong> For non-minting transactions, ensure sufficient IRR for fees (2 * 250.0 + num_tnxs * 250.0) and sufficient currency balance for the sender.</li>
                    <li><strong>Signature Verification:</strong> Use ECDSA (secp256r1) to verify the signature against the SHA256 digest of the order string.</li>
                    <li><strong>Hash Generation:</strong> Generate ledger entries in <code>tbl_tallybox_book</code> (fee, sender, recipient(s)) with <code>tally_hash</code> fields linking to previous transactions. Concatenate these hashes (e.g., <code>tally_hash_fee~tally_hash_from~total_tally_hash_to</code> for non-minting, or <code>total_tally_hash_to</code> for minting), compute a SHA256 hash, and verify its MD5 against the input <code>checksum</code>. Send the SHA256 hash to the sender for synchronization.</li>
                </ul>
                The sender compares the received hash to its expected value to confirm successful processing before sending the next record.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Validate and Generate Hash</strong><br><br>
                <pre>
FUNCTION validate_and_generate_hash(parsed_data):
    IF NOT validate_formats(parsed_data) THEN
        log_error("Invalid format")
        RETURN NULL
    END IF
    IF NOT validate_database_records(parsed_data) THEN
        log_error("Invalid database records")
        RETURN NULL
    END IF
    IF parsed_data.order_id.starts_with("$") THEN
        IF NOT validate_treasury(parsed_data) THEN
            log_error("Treasury validation failed")
            RETURN NULL
        END IF
    ELSE IF parsed_data.order_id.starts_with("#") THEN
        IF NOT validate_group_transaction(parsed_data) THEN
            log_error("Group transaction validation failed")
            RETURN NULL
        END IF
    END IF
    IF NOT parsed_data.order_id.starts_with("$") THEN
        IF NOT validate_balances(parsed_data) THEN
            log_error("Insufficient balance")
            RETURN NULL
        END IF
    END IF
    order_string = join_fields(parsed_data, ["graph_from", "graph_to", "wallet_from", "wallet_to", "order_currency", "order_amount", "order_id", "order_utc_unix"])
    digest = hash_sha256(order_string)
    IF NOT verify_digest(digest, parsed_data.the_sign, parsed_data.public_key) THEN
        log_error("Signature verification failed")
        RETURN NULL
    END IF
    ledger_entries = generate_ledger_entries(parsed_data)
    IF NOT parsed_data.order_id.starts_with("$") THEN
        total_tally_hash = ledger_entries.tally_hash_fee + "~" + ledger_entries.tally_hash_from + "~" + join(ledger_entries.tally_hash_to_arr, "~")
    ELSE
        total_tally_hash = join(ledger_entries.tally_hash_to_arr, "~")
    END IF
    sha256_output = hash_sha256(total_tally_hash)
    computed_tnx_md5 = hash_md5(sha256_output)
    IF computed_tnx_md5 != parsed_data.checksum THEN
        log_error("Checksum mismatch")
        RETURN NULL
    END IF
    store_ledger_entries(ledger_entries)
    store_signature(parsed_data, computed_tnx_md5)
    RETURN sha256_output
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Hash Generation:</strong><br><br>
                Input: XML with checksum='b2e3f94169f3d82b9b67d93acbc288a4'<br>
                Ledger Entries: tally_hash_fee, tally_hash_from, tally_hash_to<br>
                Total Hash: 'tally_hash_fee~tally_hash_from~tally_hash_to'<br>
                SHA256 Output: '7c4a8d09ca3762af61e59520943dc26494f8941b'<br>
                MD5 of SHA256: 'b2e3f94169f3d82b9b67d93acbc288a4' (Matches checksum)<br>
                Sender Peer: Receives SHA256 hash, confirms match, sends next record</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm">ECDSA (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/SHA-2">SHA-256 (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 6: Receiver - Database Storage -->
        <section class="content-box">
            <h3>Step 6: Receiver - Database Storage</h3>
            <p>After validation, the receiver peer stores the transaction data in the SQL Server database, maintaining the DAG structure. The process involves:
                <ul>
                    <li>Register <code>wallet_from</code> and <code>wallet_to</code> in <code>tbl_tallybox_wallet</code> and <code>public_key</code> in <code>tbl_tallybox_wallet_pubkey</code>.</li>
                    <li>Store fee record (tnx_type='0') in <code>tbl_tallybox_book</code> for non-minting transactions, with a <code>tally_hash</code> linking to the previous fee record.</li>
                    <li>Store sender record (tnx_type='1') and recipient record(s) (tnx_type='2' or higher for group transactions) in <code>tbl_tallybox_book</code>, each with a <code>tally_hash</code> linking to the previous record for that wallet and currency.</li>
                    <li>Store the signature in <code>tbl_tallybox_sign</code> with the transaction’s MD5 checksum.</li>
                    <li>The DAG structure is maintained by <code>tally_hash_dag</code> fields, which reference previous transactions, forming a graph of dependencies.</li>
                </ul>
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Store in Database</strong><br><br>
                <pre>
FUNCTION store_transaction(parsed_data):
    session_wallet_id = sql_max_field_id("tbl_tallybox_wallet", "wallet_id") + 1
    wallet_from_id = register_wallet(parsed_data.wallet_from, session_wallet_id)
    register_public_key(parsed_data.public_key, wallet_from_id)
    wallet_to_id_arr = []
    FOR wallet_to IN parsed_data.wallet_to_arr:
        wallet_to_id = register_wallet(wallet_to, session_wallet_id)
        wallet_to_id_arr.append(wallet_to_id)
    END FOR
    ledger_entries = []
    IF NOT parsed_data.order_id.starts_with("$") THEN
        fee_entry = create_fee_entry(parsed_data, wallet_from_id)
        ledger_entries.append(fee_entry)
    END IF
    from_entry = create_sender_entry(parsed_data, wallet_from_id)
    ledger_entries.append(from_entry)
    FOR i = 0 TO len(parsed_data.wallet_to_arr) - 1:
        to_entry = create_recipient_entry(parsed_data, wallet_to_id_arr[i], i)
        ledger_entries.append(to_entry)
    END FOR
    FOR entry IN ledger_entries:
        sql_insert("tbl_tallybox_book", entry)
    END FOR
    signature_entry = create_signature_entry(parsed_data, computed_tnx_md5)
    sql_insert("tbl_tallybox_sign", signature_entry)
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="green-box">
                <p><strong>Example Database Entries:</strong><br><br>
                <textarea class="textarea-green" readonly>
sql_book_keeper_sign: INSERT INTO tbl_tallybox_sign (tree_id,branch_id,tnx_id,order_id,utc_unix_order,the_sign,the_sign_md5,the_tnx_md5) VALUES ('1741675600','1','1741675600.1','778844','1741675583','MEYCIQCxzNKhOUXijLr+z2mI9npu/+KZijiEv3//W7Ya3VpvzgIhAI1m7wJLJ9ldP2m5jmYfUreuvoKTjoZmFQmt5e6foakp','a01d317e6c52656bb188a55736dc5aab','b2e3f94169f3d82b9b67d93acbc288a4')

sql_book_keeper_fee: INSERT INTO tbl_tallybox_book (tnx_id_dag,tnx_id,tnx_type,graph_id,wallet_id,currency_id,currency_amount,left_amount,tally_hash_dag,tally_hash) VALUES ('1741675599.1','1741675600.1','0','123','1001','1','750.0','250.0','a1b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef','7c4a8d09ca3762af61e59520943dc26494f8941b')

sql_book_keeper_from: INSERT INTO tbl_tallybox_book (tnx_id_dag,tnx_id,tnx_type,graph_id,wallet_id,currency_id,currency_amount,left_amount,tally_hash_dag,tally_hash) VALUES ('1741675599.2','1741675600.1','1','123','1001','2','3500.00000000','1500.00000000','b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef','8d9e0f1a2b3c4d5e6f7890123456789abcdef0123456789abcdef012345678')

sql_book_keeper_to: INSERT INTO tbl_tallybox_book (tnx_id_dag,tnx_id,tnx_type,graph_id,wallet_id,currency_id,currency_amount,left_amount,tally_hash_dag,tally_hash) VALUES ('1741675599.3','1741675600.1','2','123','1002','2','3500.00000000','4500.00000000','c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef','9e0f1a2b3c4d5e6f7890123456789abcdef0123456789abcdef0123456789ab')
                </textarea></p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/t-sql/statements/insert-transact-sql">SQL INSERT Statement (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Directed_acyclic_graph">DAG Structure (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 7: Synchronization via Hash Confirmation -->
        <section class="content-box">
            <h3>Step 7: Synchronization via Hash Confirmation</h3>
            <p>The TallyBox P2P network relies on a hash-based synchronization mechanism to ensure reliable data exchange. After the receiver processes a transaction with <code>transaction_decomposer</code>, it generates a final SHA256 hash from the concatenated <code>tally_hash</code> fields of ledger entries. This hash is sent back to the sender peer, which compares it to its expected hash to confirm successful processing. Only then does the sender proceed to send the next transaction record. The process ensures that the DAG remains consistent across peers, as each transaction’s hash depends on previous transactions in the graph. The data flow is:
                <ul>
                    <li><strong>Sender Peer:</strong> Reconstructs XML with <code>main_recomposer</code>, broadcasts to receiver, and awaits SHA256 hash.</li>
                    <li><strong>Receiver Peer:</strong> Processes XML, stores in database, generates SHA256 hash of <code>tally_hash_fee~tally_hash_from~total_tally_hash_to</code> (or <code>total_tally_hash_to</code> for minting), and sends it to the sender.</li>
                    <li><strong>Sender Peer:</strong> Verifies the received hash matches its expected value, confirming synchronization, and sends the next record.</li>
                    <li><strong>Receiver Peer:</strong> Broadcasts the XML to other peers, who repeat the process.</li>
                </ul>
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Synchronization via Hash</strong><br><br>
                <pre>
FUNCTION synchronize_transaction(xml_string):
    sha256_hash = transaction_decomposer(xml_string)
    IF sha256_hash IS NOT NULL THEN
        send_to_sender(sha256_hash)
        broadcast_to_peers(xml_string)
        RETURN true
    ELSE
        send_to_sender(NULL)
        RETURN false
    END IF

FUNCTION sender_verify_hash(received_hash, expected_hash):
    IF received_hash == expected_hash THEN
        log_message("Synchronization confirmed, sending next record")
        send_next_record()
    ELSE
        log_error("Synchronization failed, hash mismatch")
        request_resend()
    END IF
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Synchronization Flow:</strong><br><br>
                Sender Peer: Sends XML transaction to Peer B<br>
                Peer B: Processes transaction, generates SHA256 hash '7c4a8d09ca3762af61e59520943dc26494f8941b', sends to Sender<br>
                Sender Peer: Verifies hash matches, sends next transaction<br>
                Peer B: Broadcasts XML to Peer C<br>
                Peer C: Repeats process, ensuring DAG consistency</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/SHA-2">SHA-256 Algorithm (Wikipedia)</a><br>
                <a href="https://docs.python.org/3/library/socket.html">Socket Programming (Python Docs)</a>
            </p>
        </section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, created by xAI, for its invaluable assistance in creating this TallyBox P2P DAG networking tutorial.</p>
        </section>
    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->