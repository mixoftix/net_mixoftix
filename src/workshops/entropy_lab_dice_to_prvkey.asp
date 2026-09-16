<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dice to Private Key (Entropy Lab)</title>
    <meta name="description" content="Convert dice rolls into a private key using pure base-6 or PBKDF2.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->
    <style>
        body {
            transition: background-color 0.15s, color 0.15s;
        }
    
        /* ========== Light mode (default) ========== */
        body {
            background-color: #f5f5f5;
            color: #222;
        }
    
        .utxoTable {
            font-family: 'Courier New', monospace;
            border-collapse: separate;
            border-spacing: 0;
            border: 1px solid #999;
            border-radius: 10px;
            overflow: hidden;
            margin: 20px auto;
            width: 100%;
            max-width: 1200px;
            background: #fff;
        }
    
        .utxoTable th,
        .utxoTable td {
            padding: 10px;
            text-align: left;
            vertical-align: middle;
            border: 1px solid #ccc;
        }
    
        .utxoTable tr:first-child th:first-child { border-top-left-radius: 10px; }
        .utxoTable tr:first-child th:last-child  { border-top-right-radius: 10px; }
        .utxoTable tr:last-child td:first-child  { border-bottom-left-radius: 10px; }
        .utxoTable tr:last-child td:last-child   { border-bottom-right-radius: 10px; }
    
        .miner-header {
            background-color: #444;
            color: white;
            text-align: center !important;
        }
    
        input[type="text"],
        input[type="number"],
        input,
        select,
        textarea {
            font-family: 'Courier New', monospace;
            padding: 4px 6px;
            background: #fff;
            color: #222;
            border: 1px solid #999;
        }
    
        textarea {
            width: 100%;
            min-height: 120px;
            resize: vertical;
            box-sizing: border-box;
        }
    
        .control-btn {
            font-family: 'Courier New', monospace;
            padding: 5px 12px;
            cursor: pointer;
            margin: 0 2px;
            background: #e0e0e0;
            color: #222;
            border: 1px solid #999;
        }
    
        .control-btn.primary {
            background: #2563eb;
            color: white;
            font-weight: bold;
            border-color: #1d4ed8;
        }
    
        .pill {
            font-family: 'Courier New', monospace;
            border: 1px solid #999;
            padding: 3px 8px;
            display: inline-block;
            margin: 2px;
            background: #f0f0f0;
        }
    
        label {
            font-family: 'Courier New', monospace;
            margin-right: 6px;
        }
    
        pre, #log, #result {
            font-family: 'Courier New', monospace;
            background: #f0f0f0;
            border: 1px solid #ccc;
            padding: 8px;
            overflow: auto;
            color: #222;
            text-align: left;
            white-space: pre-wrap;
            word-break: break-word;
        }
    
        /* Status / log colors */
        .log-error   { color: #b91c1c; font-weight: bold; }
        .log-success { color: #15803d; font-weight: bold; }
        .log-info    { color: #1d4ed8; }
        .log-normal  { color: inherit; }

        /* ========== Dark mode ========== */
        body.dark-mode {
            background-color: #1a1a1a;
            color: #e0e0e0;
        }
    
        body.dark-mode .utxoTable {
            border-color: #555;
            background: #222;
        }
    
        body.dark-mode .utxoTable th,
        body.dark-mode .utxoTable td {
            border-color: #555;
        }
    
        body.dark-mode .miner-header {
            background-color: #333;
            color: white;
        }
    
        body.dark-mode input[type="text"],
        body.dark-mode input[type="number"],
        body.dark-mode input,
        body.dark-mode select,
        body.dark-mode textarea {
            background: #222;
            color: #eee;
            border-color: #555;
        }
    
        body.dark-mode .control-btn {
            background: #333;
            color: #eee;
            border-color: #555;
        }
    
        body.dark-mode .control-btn.primary {
            background: #2563eb;
            color: white;
            border-color: #3b82f6;
        }
    
        body.dark-mode .pill {
            border-color: #555;
            background: #2a2a2a;
        }
    
        body.dark-mode pre,
        body.dark-mode #log,
        body.dark-mode #result {
            background: #111;
            border-color: #555;
            color: #eee;
        }

        body.dark-mode .log-error   { color: #f97373; }
        body.dark-mode .log-success { color: #4ade80; }
        body.dark-mode .log-info    { color: #38bdf8; }
    
        .input-container {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            margin-top: 4px;
            flex-wrap: wrap;
            gap: 8px;
        }
    </style>
</head>
<body class="dark-mode">

    <header>
        <h1>Dice to Private Key (Entropy Lab)</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <section class="content-box">
        You are here: 
        <a href="/">Home</a> / Workshops / 
        <a href="/workshops/entropy_lab_dice_to_prvkey.asp">Dice to Private Key (Entropy Lab)</a>
    </section>

    <main>

        <!-- Introduction -->
        <section class="content-box">
            <h2>Dice to Private Key Generator</h2>
            <p>
                This educational tool converts a sequence of physical dice rolls (digits 1–6) into a valid
                elliptic-curve private key. Two complementary approaches are offered:
            </p>
            <ul>
                <li>
                    <strong>Approach A: Direct Entropy by Base-6 Conversion</strong><br>
                    Each dice roll becomes a digit in base-6. The resulting large number is converted to a BigInt
                    and used directly as the private key (provided it is smaller than the selected curve order).
                    This method preserves entropy exactly and demonstrates a pure mathematical mapping from
                    randomness to a private key.
                </li>
				<br>
                <li>
                    <strong>Approach B: Entropy to Randomness by PBKDF2-HMAC-SHA512</strong><br>
                    The dice sequence is fed into the standard Key Derivation Function PBKDF2 (200 000 iterations,
                    SHA-512). A user-supplied salt is required. The 256-bit output is interpreted as the private key.
                    This approach reduces any small bias present in the dice and makes exhaustive search of the
                    original dice sequence computationally expensive.
                </li>
            </ul>
            <p>
                You can choose between the two most common 256-bit curves:
                <strong>secp256k1</strong> and <strong>secp256r1</strong> (NIST P-256).
                Both approaches produce a cryptographically valid private key for the selected curve when the
                numeric value lies in the proper range.
            </p>
			<p>
				<strong>Everything runs entirely inside your browser</strong> — no data is ever uploaded to a server.
			</p>
        </section>

        <!-- Disclaimer -->
        <section class="content-box">
            <h3>Disclaimer</h3>
            <p>
                This is an educational demonstration only. The generated private keys should
                <strong>never</strong> be used for real funds, production systems, or any security-critical purpose.
            </p>
            <p>
                Always use well-reviewed, hardware-backed, or officially audited entropy sources and key-generation
                tools when creating real private keys. The author and contributors accept
                <strong>no liability</strong> for any loss or damage resulting from the use of this page. 
				Use for high-stakes cryptography is entirely at the user’s own risk. 
            </p>
        </section>

        <table border="1" class="utxoTable">
            <tr>
                <th colspan="2" class="miner-header">Input Dice Rolls</th>
            </tr>
            <tr>
                <td colspan="2" style="padding:12px;">
                    <label for="diceInput">Enter dice rolls (digits 1–6 only, ideally >= 100 rolls):</label>
					<br>
					<br>
                    <textarea id="diceInput" placeholder="e.g. 314265143625..."></textarea>
                </td>
            </tr>

            <!-- Curve selection -->
            <tr>
                <td colspan="2" style="padding:12px;">
                    <div style="margin-bottom:8px;"><strong>Select elliptic curve:</strong></div>
                    <label>
                        <input type="radio" name="curve" value="secp256k1" checked>
                        secp256k1
                    </label>
                    &nbsp;&nbsp;
                    <label>
                        <input type="radio" name="curve" value="secp256r1">
                        secp256r1 (NIST P-256)
                    </label>
                </td>
            </tr>

            <!-- Method selection -->
            <tr>
                <td colspan="2" style="padding:12px;">
                    <div style="margin-bottom:8px;"><strong>Choose derivation approach:</strong></div>
                    <label>
                        <input type="radio" name="method" value="A" checked>
                        Approach A (Direct Entropy): Base-6 > BigInt > curve order
                    </label><br>
                    <label>
                        <input type="radio" name="method" value="B">
                        Approach B (Entropy to Randomness): PBKDF2-HMAC-SHA512 > 32 bytes > curve order
                    </label>
                </td>
            </tr>

            <!-- Salt (only for Approach B) -->
            <tr id="saltBox" style="display:none;">
                <td colspan="2" style="padding:12px;">
                    <label for="saltInput">Enter salt (hex):</label>
					<br>
					<br>
                    <textarea id="saltInput" style="min-height:60px;" placeholder="e.g. a1b2c3d4e5f6..."></textarea>
                </td>
            </tr>

            <tr>
                <td colspan="2" style="padding:12px; text-align:center;">
                    <button id="goBtn" class="control-btn primary">Generate Private Key</button>
                </td>
            </tr>
        </table>

        <!-- Log -->
        <table class="utxoTable">
            <thead>
                <tr>
                    <th class="miner-header">Log</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td style="padding:0;">
                        <pre id="log" style="margin:0; border:none; border-radius:0; min-height:120px;"></pre>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- Result -->
        <table class="utxoTable">
            <thead>
                <tr>
                    <th class="miner-header">Final Private Key (hex)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td style="padding:0;">
                        <pre id="result" style="margin:0; border:none; border-radius:0; min-height:40px; font-size:1.1em;"></pre>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>
                Special thanks to <strong>Grok</strong> and <strong>Copilot</strong> for helping build this educational tool.
            </p>
        </section>
    </main>

<script>
// Curve orders
const CURVE_ORDERS = {
    secp256k1: BigInt("0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141"),
    secp256r1: BigInt("0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551")
};

function log(msg, type = "normal") {
    const el = document.getElementById("log");
    let cls = "log-normal";
    if (type === "error")   cls = "log-error";
    if (type === "success") cls = "log-success";
    if (type === "info")    cls = "log-info";

    // Auto-detect common keywords if type not explicitly given
    if (type === "normal") {
        if (msg.startsWith("ERROR") || msg.includes("invalid") || msg.includes("must be")) {
            cls = "log-error";
        } else if (msg.includes("valid") || msg.includes("Final private key")) {
            cls = "log-success";
        } else if (msg.startsWith("Approach") || msg.startsWith("User-provided") || msg.startsWith("PBKDF2") || msg.startsWith("Base-6")) {
            cls = "log-info";
        }
    }

    el.innerHTML += `<span class="${cls}">${msg}</span>\n`;
    el.scrollTop = el.scrollHeight;
}

function clearLog() {
    document.getElementById("log").innerHTML = "";
}

function hex(buffer) {
    return [...new Uint8Array(buffer)]
        .map(b => b.toString(16).padStart(2, "0"))
        .join("");
}

function getSelectedCurve() {
    return document.querySelector("input[name='curve']:checked").value;
}

function getCurveOrder() {
    return CURVE_ORDERS[getSelectedCurve()];
}

// --- Approach A: Base-6 → BigInt ---
function approachA(diceStr) {
    const curve = getSelectedCurve();
    log(`Approach A selected: Base-6 → BigInt → ${curve}`, "info");

    let n = BigInt(0);
    for (let i = 0; i < diceStr.length; i++) {
        const d = BigInt(diceStr[i]);
        n = n * BigInt(6) + (d - BigInt(1)); // digits 1–6 → values 0–5
    }

    log("Base-6 number as BigInt:", "info");
    log(n.toString());

    const order = getCurveOrder();
    if (n === BigInt(0)) throw "Key is zero — invalid.";
    if (n >= order) throw `Key ≥ ${curve} order — invalid.`;

    log(`Key is valid (< ${curve} order).`, "success");
    return n;
}

// --- Approach B: PBKDF2-HMAC-SHA512 ---
async function approachB(diceStr, saltHex) {
    const curve = getSelectedCurve();
    log(`Approach B selected: PBKDF2-HMAC-SHA512 → 32 bytes → ${curve}`, "info");

    if (!/^[0-9a-fA-F]+$/.test(saltHex)) {
        throw "Salt must be valid hex.";
    }

    const saltBytes = new Uint8Array(saltHex.match(/.{1,2}/g).map(b => parseInt(b, 16)));
    log("User-provided salt (hex): " + saltHex, "info");

    const encoder = new TextEncoder();

    const keyMaterial = await crypto.subtle.importKey(
        "raw",
        encoder.encode(diceStr),
        { name: "PBKDF2" },
        false,
        ["deriveBits"]
    );

    const bits = await crypto.subtle.deriveBits(
        {
            name: "PBKDF2",
            hash: "SHA-512",
            salt: saltBytes,
            iterations: 200000
        },
        keyMaterial,
        256
    );

    const bytes = new Uint8Array(bits);
    log("PBKDF2 output (hex): " + hex(bytes), "info");

    let n = BigInt("0x" + hex(bytes));

    const order = getCurveOrder();
    if (n === BigInt(0)) throw "Key is zero — invalid.";
    if (n >= order) throw `Key ≥ ${curve} order — invalid.`;

    log(`Key is valid (< ${curve} order).`, "success");
    return n;
}

// --- Show/hide salt box ---
document.querySelectorAll("input[name='method']").forEach(r => {
    r.addEventListener("change", () => {
        const method = document.querySelector("input[name='method']:checked").value;
        document.getElementById("saltBox").style.display = (method === "B") ? "table-row" : "none";
    });
});

// --- Main button ---
document.getElementById("goBtn").addEventListener("click", async () => {
    clearLog();
    document.getElementById("result").textContent = "";

    const diceStr = document.getElementById("diceInput").value.trim();
    log("Input dice string: " + diceStr);

    if (!/^[1-6]+$/.test(diceStr)) {
        log("ERROR: Dice rolls must be digits 1–6 only.", "error");
        return;
    }

    if (diceStr.length < 50) {
        log("WARNING: Very short dice sequence — entropy will be low.", "error");
    }

    const method = document.querySelector("input[name='method']:checked").value;
    const curve  = getSelectedCurve();
    log(`Selected curve: ${curve}`, "info");

    try {
        let key;

        if (method === "A") {
            key = approachA(diceStr);
        } else {
            const saltHex = document.getElementById("saltInput").value.trim();
            key = await approachB(diceStr, saltHex);
        }

        const hexKey = key.toString(16).padStart(64, "0");
        document.getElementById("result").textContent = hexKey;
        log("Final private key (hex): " + hexKey, "success");

    } catch (err) {
        log("ERROR: " + err, "error");
    }
});
</script>

    <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>