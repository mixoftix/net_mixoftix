<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TallyBox Tutorial - Treasury Accept</title>
    <meta name="description" content="A step-by-step tutorial on the treasury_accept web method in the TallyBox broadcast.asmx web service, including its algorithm, logic, signature verification, and data flow for managing treasury records.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

</head>
<body class="dark-mode">
    <header>
        <h1>TallyBox Tutorial - Treasury Accept</h1>
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
        <a href="tallybox_processor_treasury_accept.asp">TallyBox Payment Processor - Treasury Accept</a>
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
            <h2>Managing Treasury Records with treasury_accept</h2>
            <p>This tutorial guides developers through the `treasury_accept` web method in the `broadcast.asmx` C# web service, part of the TallyBox ecosystem. The method adds authorized treasury records to the `tbl_system_treasury` table, allowing assigned wallets to use these records for transactions. It includes a signature verification step to ensure record validity, dropping any records with invalid signatures. This tutorial covers the algorithm, logic, signature verification, and data flow, with pseudo-code and examples to aid implementation.</p>
        </section>

        <!-- Step 1: Parse Input Parameters -->
        <section class="content-box">
            <h3>Step 1: Parse Input Parameters</h3>
            <p>The `treasury_accept` method receives treasury details as individual parameters. The process involves:
                <ul>
                    <li>Accept input parameters: `authorized_currency`, `authorized_amount`, `authorized_wallet`, `blockchain_entity`, `blockchain_wallet`, `blockchain_hash`, and a new `signature` field (introduced for record validation).</li>
                    <li>Validate that required fields (`authorized_currency`, `authorized_amount`, `authorized_wallet`, `blockchain_hash`) are not null or empty.</li>
                    <li>Assign values to variables for further processing.</li>
                </ul>
                This step ensures all necessary treasury details are provided before proceeding.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Parse Input Parameters</strong><br><br>
                <pre>
FUNCTION parse_inputs(authorized_currency, authorized_amount, authorized_wallet, blockchain_entity, blockchain_wallet, blockchain_hash, signature):
    IF is_empty(authorized_currency) OR is_empty(authorized_amount) OR is_empty(authorized_wallet) OR is_empty(blockchain_hash) OR is_empty(signature) THEN
        RETURN error("301", "Missing required parameters")
    END IF
    treasury_data = {
        "currency": authorized_currency,
        "amount": authorized_amount,
        "wallet": authorized_wallet,
        "entity": blockchain_entity,
        "blockchain_wallet": blockchain_wallet,
        "hash": blockchain_hash,
        "signature": signature
    }
    RETURN treasury_data
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                authorized_currency: IRR<br>
                authorized_amount: 10000.00000000<br>
                authorized_wallet: boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7<br>
                blockchain_entity: TallyBoxChain<br>
                blockchain_wallet: chainA1b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef<br>
                blockchain_hash: 7c4a8d09ca3762af61e59520943dc26494f8941b<br>
                signature: MEYCIQCxzNKhOUXijLr+z2mI9npu/+KZijiEv3//W7Ya3VpvzgIhAI1m7wJLJ9ldP2m5jmYfUreuvoKTjoZmFQmt5e6foakp<br><br>
                Result: All fields provided, proceed to validation</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/dotnet/api/system.string.isnullorempty">String.IsNullOrEmpty Method (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Data_validation">Data Validation (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 2: Validate Input Formats -->
        <section class="content-box">
            <h3>Step 2: Validate Input Formats</h3>
            <p>Validate the format of input parameters to ensure they meet expected standards. The process involves:
                <ul>
                    <li>Verify `authorized_currency` is a recognized currency using an `iscurrency` function (e.g., IRR, 2ZR).</li>
                    <li>Ensure `authorized_amount` is a valid decimal number using an `isnumeric` function.</li>
                    <li>Confirm `authorized_wallet` and `blockchain_wallet` pass a wallet quality check (`wallet_qc`).</li>
                    <li>Check `blockchain_hash` is a valid hash format (e.g., 40-character hexadecimal for SHA-1).</li>
                    <li>Validate `signature` format (e.g., base64-encoded ECDSA signature).</li>
                </ul>
                If any check fails, return an error with a specific code (e.g., `302` for invalid currency).
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Validate Formats</strong><br><br>
                <pre>
FUNCTION validate_formats(treasury_data):
    IF NOT iscurrency(treasury_data.currency) THEN
        RETURN error("302", "Invalid currency", treasury_data.currency)
    END IF
    IF NOT isnumeric(treasury_data.amount) THEN
        RETURN error("303", "Invalid amount format", treasury_data.amount)
    END IF
    IF NOT wallet_qc(treasury_data.wallet) THEN
        RETURN error("301", "Invalid wallet format", treasury_data.wallet)
    END IF
    IF NOT is_empty(treasury_data.blockchain_wallet) AND NOT wallet_qc(treasury_data.blockchain_wallet) THEN
        RETURN error("301", "Invalid blockchain wallet format", treasury_data.blockchain_wallet)
    END IF
    IF NOT is_valid_hash(treasury_data.hash) THEN
        RETURN error("304", "Invalid blockchain hash", treasury_data.hash)
    END IF
    IF NOT is_valid_signature_format(treasury_data.signature) THEN
        RETURN error("300", "Invalid signature format", treasury_data.signature)
    END IF
    RETURN success
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                authorized_currency: IRR (Valid: recognized currency)<br>
                authorized_amount: 10000.00000000 (Valid: numeric decimal)<br>
                authorized_wallet: boxB2bbc15c8c135... (Valid: passes wallet_qc)<br>
                blockchain_wallet: chainA1b2c3d4e5f... (Valid: passes wallet_qc)<br>
                blockchain_hash: 7c4a8d09ca3762af61e59520943dc26494f8941b (Valid: 40-character hex)<br>
                signature: MEYCIQCxzNKhOUXijLr+z2mI9npu... (Valid: base64 ECDSA format)<br><br>
                Result: Proceed to signature verification</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/dotnet/api/system.decimal">Decimal Type (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Hash_function">Hash Functions (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 3: Verify Cryptographic Signature -->
        <section class="content-box">
            <h3>Step 3: Verify Cryptographic Signature</h3>
            <p>Verify the authenticity of the treasury record using an ECDSA signature on the secp256r1 curve. The process involves:
                <ul>
                    <li>Construct the treasury string: `authorized_currency~authorized_amount~authorized_wallet~blockchain_entity~blockchain_wallet~blockchain_hash`.</li>
                    <li>Retrieve the public key associated with `authorized_wallet` from `tbl_tallybox_wallet_pubkey`.</li>
                    <li>Verify the `signature` against the treasury string using ECDSA on secp256r1.</li>
                    <li>If the signature is invalid, drop the record and return an error (`300`).</li>
                </ul>
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Verify Signature</strong><br><br>
                <pre>
FUNCTION verify_signature(treasury_data):
    treasury_string = join([treasury_data.currency, treasury_data.amount, treasury_data.wallet, 
                            treasury_data.entity, treasury_data.blockchain_wallet, treasury_data.hash], "~")
    public_key = sql_find_record("tbl_tallybox_wallet_pubkey", "public_key", "wallet_id", 
                                 sql_find_record("tbl_tallybox_wallet", "wallet_id", "the_wallet", treasury_data.wallet))
    IF public_key == "no_record" THEN
        RETURN error("301", "Wallet not found", treasury_data.wallet)
    END IF
    IF NOT sign_data_b64_check(treasury_string, treasury_data.signature, public_key, "secp256r1") THEN
        RETURN error("300", "Invalid signature", "Signature verification failed")
    END IF
    RETURN success
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                Treasury String: IRR~10000.00000000~boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~TallyBoxChain~chainA1b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef~7c4a8d09ca3762af61e59520943dc26494f8941b<br><br>
                Public Key Query: SELECT public_key FROM tbl_tallybox_wallet_pubkey WHERE wallet_id = (SELECT wallet_id FROM tbl_tallybox_wallet WHERE the_wallet = 'boxB2bbc15c8c135...')<br>
                Public Key: 2C7SVvEj45VMWwbd8UQNoYYWMeCMeyKm6qfDNQXhHkKK<br><br>
                Signature: MEYCIQCxzNKhOUXijLr+z2mI9npu/+KZijiEv3//W7Ya3VpvzgIhAI1m7wJLJ9ldP2m5jmYfUreuvoKTjoZmFQmt5e6foakp<br><br>
                Signature Verification Result: Valid</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm">ECDSA Algorithm (Wikipedia)</a><br>
                <a href="https://www.secg.org/sec2-v2.pdf">SEC 2: Recommended Elliptic Curve Domain Parameters (secp256r1)</a>
            </p>
        </section>

        <!-- Step 4: Verify Database Records -->
        <section class="content-box">
            <h3>Step 4: Verify Database Records</h3>
            <p>Ensure that the treasury record is valid by checking database records. The process involves:
                <ul>
                    <li>Verify `authorized_currency` exists in `tbl_system_currency` using a `sql_find_record` function.</li>
                    <li>Confirm `authorized_wallet` exists in `tbl_tallybox_wallet`.</li>
                    <li>Check that `treasury_id` (generated as `$` + Unix timestamp) does not already exist in `tbl_system_treasury` to prevent duplicates.</li>
                </ul>
                If any check fails, return an error (e.g., `302` for invalid currency, `301` for invalid wallet, `305` for duplicate treasury ID).
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Verify Database Records</strong><br><br>
                <pre>
FUNCTION verify_database_records(treasury_data, treasury_id):
    currency_id = sql_find_record("tbl_system_currency", "currency_id", "currency_name", treasury_data.currency)
    IF currency_id == "no_record" THEN
        RETURN error("302", "Invalid currency", treasury_data.currency)
    END IF
    wallet_id = sql_find_record("tbl_tallybox_wallet", "wallet_id", "the_wallet", treasury_data.wallet)
    IF wallet_id == "no_record" THEN
        RETURN error("301", "Invalid wallet", treasury_data.wallet)
    END IF
    existing_treasury = sql_find_record("tbl_system_treasury", "treasury_id", "treasury_id", treasury_id)
    IF existing_treasury != "no_record" THEN
        RETURN error("305", "Duplicate treasury ID", treasury_id)
    END IF
    RETURN success
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                authorized_currency: IRR<br>
                Database Query: SELECT currency_id FROM tbl_system_currency WHERE currency_name = 'IRR'<br>
                Result: currency_id = 1 (Valid)<br><br>
                authorized_wallet: boxB2bbc15c8c135...<br>
                Database Query: SELECT wallet_id FROM tbl_tallybox_wallet WHERE the_wallet = 'boxB2bbc15c8c135...'<br>
                Result: wallet_id = 1001 (Valid)<br><br>
                treasury_id: $1741675600<br>
                Database Query: SELECT treasury_id FROM tbl_system_treasury WHERE treasury_id = '$1741675600'<br>
                Result: No record (Valid)<br><br>
                Result: Proceed to save record</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/relational-databases/databases/database-concepts">Database Concepts (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/SQL">SQL (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 5: Save Treasury Record to Database -->
        <section class="content-box">
            <h3>Step 5: Save Treasury Record to Database</h3>
            <p>Store the validated treasury record in the `tbl_system_treasury` table. The process involves:
                <ul>
                    <li>Generate a unique `treasury_id` by concatenating `$` with the current Unix timestamp (`local_utc_unix`).</li>
                    <li>Construct an SQL INSERT statement with all parameters, including `local_utc_unix`.</li>
                    <li>Execute the SQL statement using the `Tallybox.run_sqlstr` method.</li>
                    <li>Return the `treasury_id` as the response.</li>
                </ul>
                If the signature is invalid, the record is not saved, and an error is returned in Step 3.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Save Treasury Record</strong><br><br>
                <pre>
FUNCTION save_treasury_record(treasury_data):
    local_utc_unix = get_current_unix_timestamp()
    treasury_id = "$" + local_utc_unix
    sql = "INSERT INTO tbl_system_treasury " +
          "(treasury_id, authorized_currency, authorized_amount, authorized_wallet, " +
          "blockchain_entity, blockchain_wallet, blockchain_hash, local_utc_unix) " +
          "VALUES ('" + treasury_id + "', '" + treasury_data.currency + "', '" +
          treasury_data.amount + "', '" + treasury_data.wallet + "', '" +
          treasury_data.entity + "', '" + treasury_data.blockchain_wallet + "', '" +
          treasury_data.hash + "', '" + local_utc_unix + "')"
    run_sql(sql)
    RETURN treasury_id
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="green-box">
                <p><strong>Example Output:</strong><br><br>
                <textarea class="textarea-green" readonly>
$1741675600
                </textarea></p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/t-sql/statements/insert-transact-sql">SQL INSERT Statement (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Unix_time">Unix Time (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 6: Dropping Invalid Signatures -->
        <section class="content-box">
            <h3>Step 6: Dropping Invalid Signatures</h3>
            <p>Records with invalid signatures are dropped to maintain the integrity of the `tbl_system_treasury` table. The process involves:
                <ul>
                    <li>Signature verification in Step 3 ensures only valid records proceed to the database insertion step.</li>
                    <li>If a record fails signature verification, it is not inserted, and an error (`300`) is returned to the caller.</li>
                    <li>Periodic maintenance (e.g., via a stored procedure or job) can query `tbl_system_treasury` and re-verify signatures, deleting records with invalid signatures.</li>
                </ul>
                This ensures that only authorized and cryptographically verified treasury records are available for use.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Periodic Signature Verification</strong><br><br>
                <pre>
PROCEDURE cleanup_invalid_treasury_records():
    FOR EACH record IN tbl_system_treasury:
        treasury_string = join([record.authorized_currency, record.authorized_amount, 
                                record.authorized_wallet, record.blockchain_entity, 
                                record.blockchain_wallet, record.blockchain_hash], "~")
        public_key = sql_find_record("tbl_tallybox_wallet_pubkey", "public_key", "wallet_id", 
                                     sql_find_record("tbl_tallybox_wallet", "wallet_id", "the_wallet", record.authorized_wallet))
        IF public_key == "no_record" OR NOT sign_data_b64_check(treasury_string, record.signature, public_key, "secp256r1") THEN
            DELETE FROM tbl_system_treasury WHERE treasury_id = record.treasury_id
        END IF
    END FOR
END PROCEDURE
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                Treasury Record: treasury_id = $1741675590, authorized_wallet = boxB2bbc15c8c135..., signature = invalid_signature<br>
                Verification: Fails ECDSA check<br>
                Action: DELETE FROM tbl_system_treasury WHERE treasury_id = '$1741675590'<br><br>
                Result: Record dropped</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/t-sql/statements/delete-transact-sql">SQL DELETE Statement (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Data_integrity">Data Integrity (Wikipedia)</a>
            </p>
        </section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its invaluable assistance in creating this TallyBox treasury accept tutorial.</p>
        </section>

    </main>

    <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>