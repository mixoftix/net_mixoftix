<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TallyBox Tutorial - Buffer Archiving</title>
    <meta name="description" content="A step-by-step tutorial on monitoring buffered records and moving them to archive tables using timer_buffer_Tick in a TallyBox Windows desktop application, including logic and data flow.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

</head>
<body class="dark-mode">
    <header>
        <h1>TallyBox Tutorial - Buffer Archiving</h1>
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
        <a href="tallybox_processor_buffer_archiving.asp">TallyBox Payment Processor - Buffer Archiving</a>
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
            <h2>Moving Buffered Records to Archive Tables</h2>
            <p>This tutorial guides developers through a TallyBox Windows desktop application that monitors buffered records in database tables and moves them to their respective archive tables using the `timer_buffer_Tick` function. The function periodically checks buffer tables for records and transfers them to archive tables based on an archive ID. This tutorial explains the logic, algorithm, and data flow, with pseudo-code to aid implementation in a C# Windows Forms environment.</p>
        </section>

        <!-- Step 1: Check Buffer Status -->
        <section class="content-box">
            <h3>Step 1: Check Buffer Status</h3>
            <p>The `timer_buffer_Tick` function begins by checking the status of buffer tables using `Program.buffer_stats()`. The process involves:
                <ul>
                    <li>Call `Program.buffer_stats()` to retrieve the status of buffered records, which returns a string in the format `archive_id~tnx_id` or `"empty"` if no records are found.</li>
                    <li>Update the UI (`txt_buffer_jobs`) with the buffer status to display the current state.</li>
                    <li>If the buffer is empty, log a minimal message (optional, commented out in the code).</li>
                </ul>
                This step determines whether there are records to process.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Check Buffer Status</strong><br><br>
                <pre>
FUNCTION check_buffer_status():
    buffer_stats = Program.buffer_stats()
    update_ui(txt_buffer_jobs, buffer_stats)
    IF buffer_stats == "empty" THEN
        // Optionally log empty state
        RETURN null
    END IF
    RETURN buffer_stats
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                buffer_stats: 1~1741675600.1<br>
                UI Update: txt_buffer_jobs = 1~1741675600.1<br>
                Result: Proceed to parse buffer status</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.timer">Timer Class (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Database">Database (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 2: Parse Buffer Status -->
        <section class="content-box">
            <h3>Step 2: Parse Buffer Status</h3>
            <p>If the buffer is not empty, parse the status string to extract `archive_id` and `tnx_id`. The process involves:
                <ul>
                    <li>Split the `buffer_stats` string using the tilde (`~`) separator to obtain `archive_id` and `tnx_id`.</li>
                    <li>Store these values for use in subsequent database operations.</li>
                </ul>
                This step prepares the identifiers needed to move records to the correct archive tables.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Parse Buffer Status</strong><br><br>
                <pre>
FUNCTION parse_buffer_status(buffer_stats):
    IF buffer_stats != "empty" THEN
        parts = split(buffer_stats, "~")
        archive_id = parts[0]
        tnx_id = parts[1]
        RETURN archive_id, tnx_id
    END IF
    RETURN null, null
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                buffer_stats: 1~1741675600.1<br>
                Parsed Output:<br>
                archive_id: 1<br>
                tnx_id: 1741675600.1<br><br>
                Result: Proceed to move records</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/dotnet/api/system.string.split">String.Split Method (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Delimiter-separated_values">Delimiter-Separated Values (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 3: Move Records to Archive Tables -->
        <section class="content-box">
            <h3>Step 3: Move Records to Archive Tables</h3>
            <p>Move records from buffer tables to their respective archive tables based on `archive_id` and `tnx_id`. The process involves:
                <ul>
                    <li>Move wallet records from `tbl_tallybox_wallet_buffer` to `tbl_tallybox_wallet_archive_X` (where `X` is `archive_id`) for matching `archive_id`.</li>
                    <li>Move public key records from `tbl_tallybox_wallet_pubkey_buffer` to `tbl_tallybox_wallet_pubkey_archive_X`.</li>
                    <li>Move book-keeping records from `tbl_tallybox_book_buffer` to `tbl_tallybox_book_archive_X`, filtering by both `archive_id` and `tnx_id`.</li>
                    <li>Move signature records from `tbl_tallybox_sign_buffer` to `tbl_tallybox_sign_archive_X`, also filtering by `archive_id` and `tnx_id`.</li>
                    <li>Log the number of records moved to the UI (`rtb_buffer_monitor`).</li>
                </ul>
                This step ensures buffered records are archived for long-term storage.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Move Records to Archive</strong><br><br>
                <pre>
FUNCTION move_records_to_archive(archive_id, tnx_id):
    jobs_affected = 0
    jobs_affected += sql_move_records("tbl_tallybox_wallet_buffer",
                                     "tbl_tallybox_wallet_archive_" + archive_id,
                                     "the_wallet,wallet_id",
                                     "archive_id='" + archive_id + "'")
    jobs_affected += sql_move_records("tbl_tallybox_wallet_pubkey_buffer",
                                     "tbl_tallybox_wallet_pubkey_archive_" + archive_id,
                                     "public_key,wallet_id",
                                     "archive_id='" + archive_id + "'")
    jobs_affected += sql_move_records("tbl_tallybox_book_buffer",
                                     "tbl_tallybox_book_archive_" + archive_id,
                                     "tnx_id_dag,tnx_id,tnx_type,graph_id,wallet_id,currency_id,currency_amount,left_amount,tally_hash_dag,tally_hash",
                                     "archive_id='" + archive_id + "' AND tnx_id='" + tnx_id + "'")
    jobs_affected += sql_move_records("tbl_tallybox_sign_buffer",
                                     "tbl_tallybox_sign_archive_" + archive_id,
                                     "tree_id,branch_id,tnx_id,order_id,utc_unix_order,the_sign,the_sign_md5,the_tnx_md5",
                                     "archive_id='" + archive_id + "' AND tnx_id='" + tnx_id + "'")
    log_message("buffer channel [" + archive_id + "][" + tnx_id + "] moved to archive [" + archive_id + "]..")
    RETURN jobs_affected
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Process:</strong><br><br>
                archive_id: 1<br>
                tnx_id: 1741675600.1<br>
                Wallet Move: 2 records moved to tbl_tallybox_wallet_archive_1<br>
                Pubkey Move: 1 record moved to tbl_tallybox_wallet_pubkey_archive_1<br>
                Book Move: 3 records moved to tbl_tallybox_book_archive_1<br>
                Sign Move: 1 record moved to tbl_tallybox_sign_archive_1<br><br>
                Log Output:<br>
                buffer channel [1][1741675600.1] moved to archive [1]..</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/t-sql/statements/insert-transact-sql">SQL INSERT Statement (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Database_sharding">Database Sharding (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 4: Update UI with Results -->
        <section class="content-box">
            <h3>Step 4: Update UI with Results</h3>
            <p>Update the Windows Forms UI to reflect the movement of records to archive tables. The process involves:
                <ul>
                    <li>Display the buffer status (`archive_id~tnx_id` or "empty") in `txt_buffer_jobs`.</li>
                    <li>Append a log message to `rtb_buffer_monitor` indicating the archive channel and transaction ID.</li>
                </ul>
                This step keeps the user informed of archiving activity.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Update UI</strong><br><br>
                <pre>
FUNCTION update_ui(buffer_stats, archive_id, tnx_id):
    update_ui(txt_buffer_jobs, buffer_stats)
    IF buffer_stats != "empty" THEN
        log_message("buffer channel [" + archive_id + "][" + tnx_id + "] moved to archive [" + archive_id + "]..", rtb_buffer_monitor)
    END IF
END FUNCTION
                </pre>
                </p>
            </div>
            <br>
            <div class="green-box">
                <p><strong>Example Output:</strong><br><br>
                <textarea class="textarea-green" readonly>
txt_buffer_jobs: 1~1741675600.1
rtb_buffer_monitor: buffer channel [1][1741675600.1] moved to archive [1]..
                </textarea></p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.richtextbox">RichTextBox Class (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Windows_Forms">Windows Forms (Wikipedia)</a>
            </p>
        </section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its invaluable assistance in creating this TallyBox buffer to archive processing tutorial.</p>
        </section>

    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->