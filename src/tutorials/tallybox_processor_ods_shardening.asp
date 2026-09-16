<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TallyBox Tutorial - Transaction Shard Processing</title>
    <meta name="description" content="A step-by-step tutorial on monitoring stable database shards for new transactions and processing them using sql_ods_processor in a TallyBox Windows desktop application, including logic and data flow.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

</head>
<body class="dark-mode">
    <header>
        <h1>TallyBox Tutorial - Transaction Shard Processing</h1>
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
        <a href="tallybox_processor_ods_shardening.asp">TallyBox Payment Processor - Local Shardening</a>
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
            <h2>Processing Transactions in Stable Shards</h2>
            <p>This tutorial guides developers through a TallyBox Windows desktop application that monitors stable database shards for new transactions and processes them using the `sql_ods_processor` function. The application uses a timer-based mechanism (`timer_engine_Tick`) to check sharded tables (`tbl_order_dispatcher_X`) and move new transactions to the `tbl_order_ods` table for processing. This tutorial explains the logic, algorithm, and data flow, with pseudo-code to aid implementation in a C# Windows Forms environment.</p>
        </section>

        <!-- Step 1: Initialize Timer and State -->
        <section class="content-box">
            <h3>Step 1: Initialize Timer and Application State</h3>
            <p>The `timer_engine_Tick` function initializes the application state and sets up periodic shard checking. The process involves:
                <ul>
                    <li>Retrieve the current Unix timestamp (`local_utc_unix`) and update the UI (`txt_tree_local`).</li>
                    <li>On first run (`Program.progress_utc_unix == 0`), set the progress timestamp to the current timestamp minus one and count existing jobs in `tbl_order_ods`.</li>
                    <li>Log initialization messages using `AddText`.</li>
                </ul>
                This step prepares the application to monitor shards and track processing progress.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Initialize Timer</strong><br><br>
                <pre>
FUNCTION initialize_timer():
    local_utc_unix = get_current_unix_timestamp()
    update_ui(txt_tree_local, local_utc_unix)
    IF progress_utc_unix == 0 THEN
        progress_utc_unix = local_utc_unix - 1
        progress_in_ods = sql_count_records("tbl_order_ods", "the_sign")
        log_message("Box - ignites.. [" + progress_utc_unix + "]")
        log_message("ODS - scanner.. [" + progress_in_ods + "]")
    END IF
    RETURN local_utc_unix, progress_utc_unix, progress_in_ods
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                Current Timestamp: 1741675600<br>
                UI Update: txt_tree_local = 1741675600<br>
                Initial State: progress_utc_unix = 1741675599<br>
                ODS Jobs: progress_in_ods = 5<br><br>
                Log Output:<br>
                Box - ignites.. [1741675599]<br>
                ODS - scanner.. [5]</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.timer">Timer Class (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Unix_time">Unix Time (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 2: Check for Pending Jobs -->
        <section class="content-box">
            <h3>Step 2: Check for Pending Jobs</h3>
            <p>If jobs exist in `tbl_order_ods` (`progress_in_ods > 0`), the `timer_engine_Tick` function triggers processing. The process involves:
                <ul>
                    <li>Log the busy state and number of remaining jobs.</li>
                    <li>If `sql_ods_processor` is not running (`in_sql_ods_processor == false`), start it in a new thread.</li>
                </ul>
                This ensures processing occurs without blocking the UI thread.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Check Pending Jobs</strong><br><br>
                <pre>
FUNCTION check_pending_jobs():
    IF progress_in_ods > 0 THEN
        log_message("Box - busy.. [" + progress_utc_unix + "] - job(s) remains: " + progress_in_ods)
        IF NOT in_sql_ods_processor THEN
            start_thread(sql_ods_processor)
        END IF
    END IF
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                progress_in_ods: 5<br>
                in_sql_ods_processor: false<br>
                Log Output: Box - busy.. [1741675599] - job(s) remains: 5<br>
                Action: Start sql_ods_processor thread</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/dotnet/api/system.threading.thread">Thread Class (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Multithreading_(computer_architecture)">Multithreading (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 3: Monitor Shards for New Transactions -->
        <section class="content-box">
            <h3>Step 3: Monitor Shards for New Transactions</h3>
            <p>If no jobs are pending, `timer_engine_Tick` checks sharded tables (`tbl_order_dispatcher_X`) for new transactions. The process involves:
                <ul>
                    <li>Increment `progress_utc_unix` and select the shard table based on its last digit (`dispatcher_line`).</li>
                    <li>Check for records in the shard using `sql_find_record`.</li>
                    <li>If records are found, move them to `tbl_order_ods` using `sql_move_record_extended` with a condition (`local_utc_unix <= progress_utc_unix`).</li>
                    <li>Update `progress_in_ods` and log the number of moved jobs.</li>
                    <li>Handle timestamp alignment (e.g., reset if ahead of current time).</li>
                </ul>
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Monitor Shards</strong><br><br>
                <pre>
FUNCTION monitor_shards(local_utc_unix, progress_utc_unix):
    WHILE true:
        progress_utc_unix = progress_utc_unix + 1
        IF local_utc_unix - progress_utc_unix == 1 THEN
            log_message("Box - listens.. [" + progress_utc_unix + "]")
            BREAK
        ELSE IF local_utc_unix - progress_utc_unix < 1 THEN
            progress_utc_unix = progress_utc_unix - 1
            log_message("Box - exception.. [" + progress_utc_unix + "]")
            BREAK
        ELSE
            log_message("Box - jumps.. [" + progress_utc_unix + "]")
        END IF
        dispatcher_line = last_digit(progress_utc_unix)
        job_found = sql_find_record("tbl_order_dispatcher_" + dispatcher_line, "the_sign")
        IF job_found != "no_record" THEN
            jobs_moved = sql_move_records("tbl_order_dispatcher_" + dispatcher_line,
                                          "tbl_order_ods",
                                          "graph_from,graph_to,wallet_from,wallet_to,order_currency,order_amount,order_utc_unix,order_id,public_key,the_sign,local_utc_unix",
                                          "local_utc_unix<=" + progress_utc_unix)
            IF jobs_moved > 0 THEN
                log_message("dispatcher[" + dispatcher_line + "][" + jobs_moved + "] moved to ods..")
                progress_in_ods = sql_count_records("tbl_order_ods", "the_sign")
                log_message("- job(s) found: " + progress_in_ods)
                BREAK
            END IF
        END IF
    END WHILE
    update_ui(txt_tree_progress, progress_utc_unix)
    update_ui(txt_dispatcher_line, dispatcher_line)
    update_ui(txt_ods_jobs, progress_in_ods)
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                local_utc_unix: 1741675600<br>
                progress_utc_unix: 1741675599<br>
                dispatcher_line: 9<br>
                Job Found: the_sign = MEYCIQCxzNKhOUXijLr+z2mI9npu/+KZijiEv3//W7Ya3VpvzgIhAI1m7wJLJ9ldP2m5jmYfUreuvoKTjoZmFQmt5e6foakp<br>
                Jobs Moved: 3<br>
                Log Output:<br>
                Box - listens.. [1741675599]<br>
                dispatcher[9][3] moved to ods..<br>
                - job(s) found: 3<br><br>
                UI Update:<br>
                txt_tree_progress = 1741675599<br>
                txt_dispatcher_line = 9<br>
                txt_ods_jobs = 3</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/t-sql/statements/insert-transact-sql">SQL INSERT Statement (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Database_sharding">Database Sharding (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 4: Process ODS Records -->
        <section class="content-box">
            <h3>Step 4: Process ODS Records</h3>
            <p>The `sql_ods_processor` function processes records from `tbl_order_ods`, performing validation and ledger updates. The process involves:
                <ul>
                    <li>Query `tbl_order_ods` for records, ordered by `local_utc_unix`.</li>
                    <li>For each record, extract fields (e.g., `graph_from`, `wallet_from`, `order_currency`).</li>
                    <li>Decrement `progress_in_ods` to track remaining jobs.</li>
                    <li>Validate formats, graph domains, currency, and signatures, marking invalid records for deletion.</li>
                    <li>Handle treasury (`$`) and group (`#`) transactions with specific checks.</li>
                </ul>
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Process ODS Records</strong><br><br>
                <pre>
FUNCTION sql_ods_processor():
    in_sql_ods_processor = true
    records = sql_query("SELECT * FROM tbl_order_ods ORDER BY local_utc_unix")
    IF records.is_empty THEN
        in_sql_ods_processor = false
        RETURN
    END IF
    FOR EACH record IN records:
        progress_in_ods = progress_in_ods - 1
        order_data = extract_fields(record, ["graph_from", "graph_to", "wallet_from", "wallet_to", 
                                             "order_currency", "order_amount", "order_utc_unix", 
                                             "order_id", "public_key", "the_sign", "local_utc_unix"])
        delete_record = validate_record(order_data)
        IF delete_record THEN
            sql_delete("tbl_order_ods", "the_sign='" + order_data.the_sign + "'")
            sql_delete("tbl_order_ods_multiple", "the_sign_md5='" + hash_md5(order_data.the_sign) + "'")
            CONTINUE
        END IF
        // Proceed to further processing (next steps)
    END FOR
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                Query: SELECT * FROM tbl_order_ods ORDER BY local_utc_unix<br>
                Record: graph_from=tallybox.mixoftix.net, wallet_from=boxB2bbc15c8c135..., order_currency=2ZR, order_amount=3500.00000000<br>
                progress_in_ods: 4 (after decrement)<br>
                Validation: All formats valid<br>
                Result: Proceed to next steps</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqldatareader">SqlDataReader (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/SQL">SQL (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 5: Validate Transactions -->
        <section class="content-box">
            <h3>Step 5: Validate Transactions</h3>
            <p>Validate each transaction’s format, database records, treasury/group details, and signature. The process involves:
                <ul>
                    <li>Check formats: Ensure `graph_from`/`graph_to` contain dots, wallets are valid, and timestamps/amounts are numeric.</li>
                    <li>Verify graph domains and currency in database tables (`tbl_system_graph`, `tbl_system_currency`).</li>
                    <li>For treasury transactions (`order_id` starts with `$`): Validate treasury ID, check for double-spending, and match currency/amount/wallet.</li>
                    <li>For group transactions (`order_id` starts with `#`): Validate multiple recipients and amounts, check for duplicates, and verify total amount.</li>
                    <li>Verify ECDSA signature using `secp256r1` curve.</li>
                </ul>
                Invalid records are marked for deletion.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Validate Transactions</strong><br><br>
                <pre>
FUNCTION validate_record(order_data):
    delete_record = false
    IF NOT contains(order_data.graph_from, ".") OR NOT contains(order_data.graph_to, ".") THEN
        log_message("check format failed: graph")
        delete_record = true
    END IF
    IF NOT wallet_qc(order_data.wallet_from) OR (NOT order_data.order_id.starts_with("#") AND NOT wallet_qc(order_data.wallet_to)) THEN
        log_message("check format failed: wallet")
        delete_record = true
    END IF
    IF NOT isnumeric(order_data.order_utc_unix) OR NOT isnumeric(order_data.local_utc_unix) THEN
        log_message("check format failed: timestamp")
        delete_record = true
    END IF
    IF graph_id_from = sql_find_record("tbl_system_graph", "graph_id", "graph_domain", order_data.graph_from) == "no_record" THEN
        log_message("error~207~invalid graph~graph_from")
        delete_record = true
    END IF
    IF graph_id_to = sql_find_record("tbl_system_graph", "graph_id", "graph_domain", order_data.graph_to) == "no_record" THEN
        log_message("error~207~invalid graph~graph_to")
        delete_record = true
    END IF
    IF currency_id = sql_find_record("tbl_system_currency", "currency_id", "currency_name", order_data.order_currency) == "no_record" THEN
        log_message("not found (currency_name): " + order_data.order_currency)
        delete_record = true
    END IF
    the_sign_md5 = hash_md5(order_data.the_sign)
    IF order_data.order_id.starts_with("$") THEN
        treasury_id = sql_find_record("tbl_system_treasury", "treasury_id", "treasury_id", order_data.order_id)
        IF treasury_id == "no_record" OR sql_find_record("tbl_tallybox_sign", "order_id", "order_id", treasury_id) != "no_record" THEN
            log_message("error~204 or 205~treasury error")
            delete_record = true
        ELSE IF treasury details mismatch THEN
            log_message("error~206~treasury mismatch error")
            delete_record = true
        END IF
    ELSE IF order_data.order_id.starts_with("#") THEN
        num_tnxs = sql_max_field_id("tbl_order_ods_multiple", "row_id", "the_sign_md5", the_sign_md5) OR 1
        IF check_duplicate(the_sign_md5) THEN
            delete_record = true
        END IF
        FOR i = 1 TO num_tnxs:
            wallet_to = sql_find_record_with_where("tbl_order_ods_multiple", "wallet_to", "row_id='" + i + "' and the_sign_md5='" + the_sign_md5 + "'")
            order_amount = sql_find_record_with_where("tbl_order_ods_multiple", "order_amount", "row_id='" + i + "' and the_sign_md5='" + the_sign_md5 + "'")
            IF NOT wallet_qc(wallet_to) OR NOT isnumeric(order_amount) THEN
                delete_record = true
            END IF
        END FOR
    ELSE IF NOT order_data.order_id.is_empty AND NOT isnumeric(order_data.order_id) THEN
        log_message("warning~503~invalid numeric data~order_id")
        order_data.order_id = ""
    END IF
    IF NOT order_data.order_id.starts_with("#") AND NOT isnumeric(order_data.order_amount) THEN
        log_message("error~303~invalid numeric data~order_amount")
        delete_record = true
    END IF
    order_string = join([order_data.graph_from, order_data.graph_to, order_data.wallet_from, 
                         order_data.wallet_to, order_data.order_currency, order_data.order_amount, 
                         order_data.order_id, order_data.order_utc_unix], "~")
    public_key_decompressed = decompress_b58_in_b58_out(order_data.public_key.replace("*", "~"), "secp256r1")
    IF NOT sign_data_b64_check(order_string, order_data.the_sign, public_key_decompressed, "secp256r1") THEN
        log_message("error mis-match (ecc_sign)")
        delete_record = true
    END IF
    RETURN delete_record
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                order_id: 778844 (Numeric, single transaction)<br>
                graph_from: tallybox.mixoftix.net (Valid)<br>
                wallet_from: boxB2bbc15c8c135... (Valid)<br>
                order_currency: 2ZR (Valid in tbl_system_currency)<br>
                order_amount: 3500.00000000 (Numeric)<br>
                Signature: Valid<br>
                Result: delete_record = false</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm">ECDSA Algorithm (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/Double-spending">Double-Spending (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 6: Update Ledger and Wallets -->
        <section class="content-box">
            <h3>Step 6: Update Ledger and Wallets</h3>
            <p>For valid transactions, update wallet records and ledger entries. The process involves:
                <ul>
                    <li>Generate a unique transaction ID (`tnx_id`) using a tree-branch structure (`tree_id.local_utc_unix.branch_id_reverse`).</li>
                    <li>Register new wallets (`wallet_from`, `wallet_to`) in `tbl_tallybox_wallet` and `tbl_tallybox_wallet_pubkey`, with buffer tables.</li>
                    <li>Calculate fees (2 * 250.0 IRR + num_tnxs * 250.0 IRR) and update sender’s balance in `tbl_tallybox_book`.</li>
                    <li>Update sender and receiver balances for the transaction amount in `tbl_tallybox_book`.</li>
                    <li>Record the signature in `tbl_tallybox_sign` with a transaction hash.</li>
                    <li>Delete processed records from `tbl_order_ods` and `tbl_order_ods_multiple`.</li>
                </ul>
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Update Ledger and Wallets</strong><br><br>
                <pre>
FUNCTION update_ledger_and_wallets(order_data, num_tnxs, wallet_to_arr, order_amount_arr):
    tree_id = order_data.local_utc_unix
    row_number = increment_row_number(tree_id)
    branch_id = row_number
    branch_id_reverse = reverse(branch_id)
    tnx_id = tree_id + "." + branch_id_reverse
    session_wallet_id = sql_max_field_id("tbl_tallybox_wallet", "wallet_id")
    wallet_from_id = register_wallet(order_data.wallet_from, session_wallet_id)
    register_public_key(order_data.public_key, wallet_from_id)
    FOR j = 0 TO num_tnxs - 1:
        wallet_to_id_arr[j] = register_wallet(wallet_to_arr[j], session_wallet_id)
    END FOR
    currency_id_fee = "1"
    currency_amount_fee = (2 * base_fee_amount) + (num_tnxs * base_fee_amount)
    left_amount_fee = calculate_balance(order_data.graph_from, wallet_from_id, currency_id_fee, currency_amount_fee)
    tally_hash_fee = hash_sha256(previous_tally_hash + components)
    sql_insert("tbl_tallybox_book", fee_entry)
    sql_insert("tbl_tallybox_book_buffer", fee_entry, archive_id="1")
    sql_insert("tbl_tallybox_book_buffer", fee_entry, archive_id="2")
    left_amount_from = calculate_balance(order_data.graph_from, wallet_from_id, currency_id, order_data.order_amount)
    tally_hash_from = hash_sha256(previous_tally_hash + components)
    sql_insert("tbl_tallybox_book", from_entry)
    sql_insert("tbl_tallybox_book_buffer", from_entry, archive_id="1")
    sql_insert("tbl_tallybox_book_buffer", from_entry, archive_id="2")
    FOR j = 0 TO num_tnxs - 1:
        left_amount_to = calculate_balance(order_data.graph_to, wallet_to_id_arr[j], currency_id, order_amount_arr[j])
        tally_hash_to = hash_sha256(previous_tally_hash + components)
        sql_insert("tbl_tallybox_book", to_entry[j])
        sql_insert("tbl_tallybox_book_buffer", to_entry[j], archive_id="1")
        sql_insert("tbl_tallybox_book_buffer", to_entry[j], archive_id="2")
    END FOR
    tnx_md5 = hash_md5(hash_sha256(tally_hash_fee + tally_hash_from + tally_hash_to))
    sql_insert("tbl_tallybox_sign", signature_entry)
    sql_insert("tbl_tallybox_sign_buffer", signature_entry, archive_id="1")
    sql_insert("tbl_tallybox_sign_buffer", signature_entry, archive_id="2")
    sql_delete("tbl_order_ods", "the_sign='" + order_data.the_sign + "'")
    sql_delete("tbl_order_ods_multiple", "the_sign_md5='" + hash_md5(order_data.the_sign) + "'")
END FUNCTION
                </pre>
                </p>
            </div>
            <br>

			<div class="green-box">
				<p><strong>Example Output:</strong><br><br>
				<textarea class="textarea-green" readonly>
sql_book_keeper_sign: INSERT INTO tbl_tallybox_sign (tree_id,branch_id,tnx_id,order_id,utc_unix_order,the_sign,the_sign_md5,the_tnx_md5) VALUES ('1741675600','1','1741675600.1','778844','1741675583','MEYCIQCxzNKhOUXijLr+z2mI9npu/+KZijiEv3//W7Ya3VpvzgIhAI1m7wJLJ9ldP2m5jmYfUreuvoKTjoZmFQmt5e6foakp','a01d317e6c52656bb188a55736dc5aab','b2e3f94169f3d82b9b67d93acbc288a4')

sql_book_keeper_fee: INSERT INTO tbl_tallybox_book (tnx_id_dag,tnx_id,tnx_type,graph_id,wallet_id,currency_id,currency_amount,left_amount,tally_hash_dag,tally_hash) VALUES ('1741675599.1','1741675600.1','0','123','1001','1','750.0','250.0','a1b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef','7c4a8d09ca3762af61e59520943dc26494f8941b020f740c4c4b7c8d9e0f1a2b')

sql_book_keeper_from: INSERT INTO tbl_tallybox_book (tnx_id_dag,tnx_id,tnx_type,graph_id,wallet_id,currency_id,currency_amount,left_amount,tally_hash_dag,tally_hash) VALUES ('1741675599.2','1741675600.1','1','123','1001','2','3500.00000000','1500.00000000','b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef','8d9e0f1a2b3c4d5e6f7890123456789abcdef0123456789abcdef012345678')

sql_book_keeper_to: INSERT INTO tbl_tallybox_book (tnx_id_dag,tnx_id,tnx_type,graph_id,wallet_id,currency_id,currency_amount,left_amount,tally_hash_dag,tally_hash) VALUES ('1741675599.3','1741675600.1','2','123','1002','2','3500.00000000','4500.00000000','c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef','9e0f1a2b3c4d5e6f7890123456789abcdef0123456789abcdef0123456789ab')
				</textarea></p>
			</div>

            <p><strong>References:</strong><br>
                <a href="https://en.wikipedia.org/wiki/SHA-2">SHA-256 Algorithm (Wikipedia)</a><br>
                <a href="https://en.wikipedia.org/wiki/MD5">MD5 Algorithm (Wikipedia)</a>
            </p>
        </section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its invaluable assistance in creating this TallyBox transaction shard processing tutorial.</p>
        </section>

    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->