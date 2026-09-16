<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TallyBox Tutorial - Order Acceptance Web Method</title>
    <meta name="description" content="A step-by-step tutorial on the order_accept web method in the TallyBox broadcast.asmx web service, including its algorithm, logic, and data flow for processing financial orders.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

</head>
<body class="dark-mode">
    <header>
        <h1>TallyBox Tutorial - Order Acceptance</h1>
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
        <a href="tallybox_processor_order_accept.asp">TallyBox Payment Processor - Order Accept</a>
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
            <h2>Processing Orders with the order_accept</h2>
            <p>This tutorial guides developers through the `order_accept` web method in the `broadcast.asmx` C# web service, part of the TallyBox ecosystem. The method processes financial orders by validating inputs, checking balances, verifying cryptographic signatures, and storing orders in a database. It uses a tilde-separated `order_csv` string to receive order details and employs robust checks to ensure security and integrity. This tutorial focuses on the algorithm, logic, and data flow, with pseudo-code to aid implementation and understanding.</p>
        </section>

        <!-- Step 1: Parse Order Data -->
        <section class="content-box">
            <h3>Step 1: Parse Order Data from order_csv</h3>
            <p>The `order_accept` method receives order details in a tilde (`~`) separated string (`order_csv`). The process involves:
                <ul>
                    <li>Split the `order_csv` string into an array using the tilde separator.</li>
                    <li>Verify the first element is "tallybox" to confirm the parcel's starting point.</li>
                    <li>Iterate through the array to extract key-value pairs (e.g., `graph_from`, `wallet_from`, `order_currency`) and assign values to variables.</li>
                    <li>Expected fields include: `graph_from`, `graph_to`, `wallet_from`, `wallet_to`, `order_currency`, `order_amount`, `order_id`, `order_utc_unix`, `the_sign`, and `publicKey_xy_compressed`.</li>
                </ul>
                This step ensures all necessary order details are extracted for subsequent validation.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Parse order_csv</strong><br><br>
                <pre>
FUNCTION parse_order_csv(order_csv):
    separators = ["~"]
    fields = split(order_csv, separators)
    IF fields[0] != "tallybox" THEN
        RETURN error("Invalid parcel starting point")
    END IF
    order_data = {}
    FOR i = 0 TO length(fields) - 2:
        key = fields[i]
        value = fields[i + 1]
        IF key IN ["graph_from", "graph_to", "wallet_from", "wallet_to", "order_currency", 
                   "order_amount", "order_id", "order_utc_unix", "the_sign", 
                   "publicKey_xy_compressed"]:
            order_data[key] = value
        END IF
    END FOR
    RETURN order_data
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                order_csv: tallybox~parcel_of_transaction~graph_from~tallybox.mixoftix.net~graph_to~tallybox.mixoftix.net~wallet_from~boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~wallet_to~boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~order_currency~2ZR~order_amount~3500.00000000~order_id~778844~order_utc_unix~1741675583~the_sign~MEYCIQCxzNKhOUXijLr+z2mI9npu/+KZijiEv3//W7Ya3VpvzgIhAI1m7wJLJ9ldP2m5jmYfUreuvoKTjoZmFQmt5e6foakp~publicKey_xy_compressed~2C7SVvEj45VMWwbd8UQNoYYWMeCMeyKm6qfDNQXhHkKK*1<br><br>
                Parsed Output:<br><br>
                graph_from: tallybox.mixoftix.net<br>
                graph_to: tallybox.mixoftix.net<br>
                wallet_from: boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7<br>
                wallet_to: boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7<br>
                order_currency: 2ZR<br>
                order_amount: 3500.00000000<br>
                order_id: 778844<br>
                order_utc_unix: 1741675583<br>
                the_sign: MEYCIQCxzNKhOUXijLr+z2mI9npu/+KZijiEv3//W7Ya3VpvzgIhAI1m7wJLJ9ldP2m5jmYfUreuvoKTjoZmFQmt5e6foakp<br>
                publicKey_xy_compressed: 2C7SVvEj45VMWwbd8UQNoYYWMeCMeyKm6qfDNQXhHkKK*1</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/dotnet/api/system.string.split">String.Split Method (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Delimiter-separated_values">Delimiter-Separated Values (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 2: Validate Input Formats -->
        <section class="content-box">
            <h3>Step 2: Validate Input Formats</h3>
            <p>Validate the format of extracted order data to ensure compliance with expected standards. The process involves:
                <ul>
                    <li>Check that `graph_from` and `graph_to` contain a dot (`.`) to resemble domain names (e.g., `tallybox.mixoftix.net`).</li>
                    <li>Verify `wallet_from` and `wallet_to` using a wallet quality check function (`wallet_qc`).</li>
                    <li>Confirm `order_currency` is a recognized currency using an `iscurrency` function.</li>
                    <li>Ensure `order_utc_unix` is a numeric value using an `isnumeric` function.</li>
                </ul>
                If any check fails, return an error with a specific code (e.g., `305` for invalid graph format).
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Validate Formats</strong><br><br>
                <pre>
FUNCTION validate_formats(order_data):
    IF NOT contains(order_data.graph_from, ".") THEN
        RETURN error("305", "invalid graph format", "graph_from - " + order_data.graph_from)
    END IF
    IF NOT contains(order_data.graph_to, ".") THEN
        RETURN error("305", "invalid graph format", "graph_to - " + order_data.graph_to)
    END IF
    IF NOT wallet_qc(order_data.wallet_from) THEN
        RETURN error("301", "invalid wallet format", "wallet_from")
    END IF
    IF NOT wallet_qc(order_data.wallet_to) THEN
        RETURN error("301", "invalid wallet format", "wallet_to")
    END IF
    IF NOT iscurrency(order_data.order_currency) THEN
        RETURN error("302", "invalid currency", "order_currency")
    END IF
    IF NOT isnumeric(order_data.order_utc_unix) THEN
        RETURN error("303", "invalid numeric data", "order_utc_unix")
    END IF
    RETURN success
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                graph_from: tallybox.mixoftix.net (Valid: contains ".")<br>
                graph_to: tallybox.mixoftix.net (Valid: contains ".")<br>
                wallet_from: boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7 (Valid: passes wallet_qc)<br>
                wallet_to: boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7 (Valid: passes wallet_qc)<br>
                order_currency: 2ZR (Valid: recognized currency)<br>
                order_utc_unix: 1741675583 (Valid: numeric)<br><br>
                Result: Proceed to next step</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Domain_Name_System">Domain Name System (Wikipedia)</a><br>
                <a href="https://learn.microsoft.com/en-us/dotnet/api/system.string.contains">String.Contains Method (Microsoft Docs)</a>
            </p>
        </section>

        <!-- Step 3: Verify Database Records -->
        <section class="content-box">
            <h3>Step 3: Verify Database Records</h3>
            <p>Ensure that `graph_from` and `graph_to` exist in the database. The process involves:
                <ul>
                    <li>Query the `tbl_system_graph` table to check if `graph_from` and `graph_to` are registered domains using a `sql_find_record` function.</li>
                    <li>If either returns `no_record`, return an error (`207`).</li>
                </ul>
                This step ensures the order operates within valid graph domains.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Verify Database Records</strong><br><br>
                <pre>
FUNCTION verify_database_records(order_data):
    graph_from_id = sql_find_record("tbl_system_graph", "graph_id", "graph_domain", order_data.graph_from)
    IF graph_from_id == "no_record" THEN
        RETURN error("207", "invalid graph", "graph_from")
    END IF
    graph_to_id = sql_find_record("tbl_system_graph", "graph_id", "graph_domain", order_data.graph_to)
    IF graph_to_id == "no_record" THEN
        RETURN error("207", "invalid graph", "graph_to")
    END IF
    RETURN success
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                graph_from: tallybox.mixoftix.net<br>
                Database Query: SELECT graph_id FROM tbl_system_graph WHERE graph_domain = 'tallybox.mixoftix.net'<br>
                Result: graph_id = 123 (Valid)<br><br>
                graph_to: tallybox.mixoftix.net<br>
                Database Query: SELECT graph_id FROM tbl_system_graph WHERE graph_domain = 'tallybox.mixoftix.net'<br>
                Result: graph_id = 123 (Valid)<br><br>
                Result: Proceed to next step</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/relational-databases/databases/database-concepts">Database Concepts (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/SQL">SQL (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 4: Validate Treasury and Balances -->
        <section class="content-box">
            <h3>Step 4: Validate Treasury and Balances</h3>
            <p>Verify treasury orders (if `order_id` starts with `$`) and ensure sufficient balances for non-treasury orders. The process involves:
                <ul>
                    <li><strong>Treasury Orders</strong>:
                        <ul>
                            <li>Check if `order_id` exists in `tbl_system_treasury`.</li>
                            <li>Ensure it hasn’t been used (check `tbl_tallybox_sign`).</li>
                            <li>Verify that treasury’s currency, amount, and wallet match the order’s details.</li>
                        </ul>
                    </li>
                    <li><strong>Non-Treasury Orders</strong>:
                        <ul>
                            <li>Ensure `order_id` is numeric.</li>
                            <li>Verify `wallet_from` has enough balance for fees (3 * 250.0 IRR).</li>
                            <li>Check `wallet_from` balance for `order_amount` (plus fees if currency is IRR).</li>
                        </ul>
                    </li>
                </ul>
                Errors are returned for invalid treasury IDs (`204`), double-spending (`205`), treasury mismatches (`206`), or insufficient balances (`203`, `204`, `205`).
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Validate Treasury and Balances</strong><br><br>
                <pre>
FUNCTION validate_treasury_and_balances(order_data, base_fee_amount, base_fee_token):
    IF starts_with(order_data.order_id, "$"):
        treasury_id = sql_find_record("tbl_system_treasury", "treasury_id", "treasury_id", order_data.order_id)
        IF treasury_id == "no_record" THEN
            RETURN error("204", "invalid treasury_id", "order_id")
        END IF
        used_id = sql_find_record("tbl_tallybox_sign", "order_id", "order_id", order_data.order_id)
        IF used_id != "no_record" THEN
            RETURN error("205", "double spending error", "order_id")
        END IF
        treasury_currency = sql_find_record("tbl_system_treasury", "authorized_currency", "treasury_id", order_data.order_id)
        treasury_amount = sql_find_record("tbl_system_treasury", "authorized_amount", "treasury_id", order_data.order_id)
        treasury_wallet = sql_find_record("tbl_system_treasury", "authorized_wallet", "treasury_id", order_data.order_id)
        IF treasury_currency != order_data.order_currency OR 
           treasury_amount != order_data.order_amount OR 
           treasury_wallet != order_data.wallet_from THEN
            RETURN error("206", "treasury mismatch error", "order_id")
        END IF
    ELSE
        IF NOT isnumeric(order_data.order_id) THEN
            RETURN error("303", "invalid numeric data", "order_id")
        END IF
    END IF
    IF NOT isnumeric(order_data.order_amount) THEN
        RETURN error("303", "invalid numeric data", "order_amount")
    END IF
    IF NOT starts_with(order_data.order_id, "$"):
        fee_balance = wallet_left_amount(order_data.graph_from, order_data.wallet_from, base_fee_token)
        IF fee_balance < 3 * base_fee_amount THEN
            RETURN error("203", "no enough fee", "balance of " + base_fee_token + " < " + (3 * base_fee_amount))
        END IF
        IF order_data.order_currency == base_fee_token:
            total_balance = wallet_left_amount(order_data.graph_from, order_data.wallet_from, order_data.order_currency)
            IF total_balance < (order_data.order_amount + 3 * base_fee_amount) THEN
                RETURN error("204", "no enough balance", "order_amount: " + total_balance)
            END IF
        ELSE
            total_balance = wallet_left_amount(order_data.graph_from, order_data.wallet_from, order_data.order_currency)
            IF total_balance < order_data.order_amount THEN
                RETURN error("205", "no enough balance", "order_amount: " + total_balance)
            END IF
        END IF
    END IF
    RETURN success
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                order_id: 778844 (Non-treasury, numeric)<br>
                order_amount: 3500.00000000 (Numeric)<br>
                Fee Balance Check: wallet_left_amount(tallybox.mixoftix.net, wallet_from, IRR) = 1000.0 IRR<br>
                Result: Valid (1000.0 > 3 * 250.0 = 750.0)<br><br>
                Currency Balance Check: wallet_left_amount(tallybox.mixoftix.net, wallet_from, 2ZR) = 5000.0 2ZR<br>
                Result: Valid (5000.0 > 3500.0)<br><br>
                Result: Proceed to next step</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Double-spending">Double-Spending (Wikipedia)</a><br>
                <a href="https://learn.microsoft.com/en-us/dotnet/api/system.decimal">Decimal Type (Microsoft Docs)</a>
            </p>
        </section>

        <!-- Step 5: Verify Cryptographic Signature -->
        <section class="content-box">
            <h3>Step 5: Verify Cryptographic Signature</h3>
            <p>Verify the order’s authenticity using an ECDSA signature on the secp256r1 curve. The process involves:
                <ul>
                    <li>Construct the order string: `graph_from~graph_to~wallet_from~wallet_to~order_currency~order_amount~order_id~order_utc_unix`.</li>
                    <li>Decompress the `publicKey_xy_compressed` to obtain the public key coordinates (X, Y).</li>
                    <li>Verify the signature (`the_sign`) against the order string using ECDSA.</li>
                    <li>If the signature is invalid, return an error (`300`).</li>
                </ul>
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Verify Signature</strong><br><br>
                <pre>
FUNCTION verify_signature(order_data, the_sign, public_key_compressed):
    order_string = join([order_data.graph_from, order_data.graph_to, order_data.wallet_from, 
                         order_data.wallet_to, order_data.order_currency, order_data.order_amount, 
                         order_data.order_id, order_data.order_utc_unix], "~")
    public_key_decompressed = decompress_b58_in_b58_out(public_key_compressed.replace("*", "~"), "secp256r1")
    IF NOT sign_data_b64_check(order_string, the_sign, public_key_decompressed, "secp256r1") THEN
        RETURN error("300", "invalid sign", "the_sign")
    END IF
    RETURN success
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                Order String: tallybox.mixoftix.net~tallybox.mixoftix.net~boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~boxB2bbc15c8c135W8PzPEZf98cEu2h2muhkeJQS3MwTYUaTHVkFTgihcS7~2ZR~3500.00000000~778844~1741675583<br><br>
                Signature: MEYCIQCxzNKhOUXijLr+z2mI9npu/+KZijiEv3//W7Ya3VpvzgIhAI1m7wJLJ9ldP2m5jmYfUreuvoKTjoZmFQmt5e6foakp<br><br>
                Public Key (Compressed): 2C7SVvEj45VMWwbd8UQNoYYWMeCMeyKm6qfDNQXhHkKK*1<br><br>
                Signature Verification Result: Valid</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm">ECDSA Algorithm (Wikipedia)</a><br>
                <a href="https://www.secg.org/sec2-v2.pdf">SEC 2: Recommended Elliptic Curve Domain Parameters (secp256r1)</a>
            </p>
        </section>

        <!-- Step 6: Save Order to Database -->
        <section class="content-box">
            <h3>Step 6: Save Order to Database</h3>
            <p>Store the validated order in a sharded database table. The process involves:
                <ul>
                    <li>Generate the current Unix timestamp (`local_utc_unix`).</li>
                    <li>Use the last digit of the timestamp to select a table shard (`tbl_order_dispatcher_X`).</li>
                    <li>Construct and execute an SQL INSERT statement with order details.</li>
                    <li>Return a success response: `submitted~200~<local_utc_unix>`.</li>
                </ul>
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Save Order</strong><br><br>
                <pre>
FUNCTION save_order(order_data):
    local_utc_unix = get_current_unix_timestamp()
    dispatcher_line = last_digit(local_utc_unix)
    sql = "INSERT INTO tbl_order_dispatcher_" + dispatcher_line + " " +
          "(graph_from, graph_to, wallet_from, wallet_to, order_currency, order_amount, " +
          "order_utc_unix, order_id, public_key, the_sign, local_utc_unix) " +
          "VALUES ('" + order_data.graph_from + "', '" + order_data.graph_to + "', '" +
          order_data.wallet_from + "', '" + order_data.wallet_to + "', '" +
          order_data.order_currency + "', '" + order_data.order_amount + "', '" +
          order_data.order_utc_unix + "', '" + order_data.order_id + "', '" +
          order_data.publicKey_xy_compressed + "', '" + order_data.the_sign + "', '" +
          local_utc_unix + "')"
    run_sql(sql)
    RETURN "submitted~200~" + local_utc_unix
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="green-box">
                <p><strong>Example Output:</strong><br><br>
                <textarea class="textarea-green" readonly>
submitted~200~1741675600
                </textarea></p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/t-sql/statements/insert-transact-sql">SQL INSERT Statement (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Unix_time">Unix Time (Wikipedia)</a>
            </p>
        </section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its invaluable assistance in creating this TallyBox order acceptance tutorial.</p>
        </section>

    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->