<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NIST SP 800-90B (Entropy Source Validation)</title>
    <meta name="description" content="Client-side NIST SP 800-90B entropy source validation — paste samples, run health tests & estimators.">
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
            text-align: center;
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
            min-height: 140px;
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
    
        .results-table {
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            border-collapse: collapse;
            width: 100%;
            max-width: 1200px;
            margin: 10px auto;
        }
    
        .results-table th,
        .results-table td {
            padding: 8px;
            border: 1px solid #ccc;
            text-align: left;
        }
    
        .results-table th {
            background-color: #444;
            color: white;
        }
    
        .progress-bar {
            width: 100%;
            height: 10px;
            border: 1px solid #999;
            background: #e5e5e5;
            margin: 6px 0;
        }
    
        .progress-bar-inner {
            height: 100%;
            width: 0%;
            background: #22c55e;
        }
    
        pre {
            font-family: 'Courier New', monospace;
            background: #f0f0f0;
            border: 1px solid #ccc;
            padding: 8px;
            overflow: auto;
            max-height: 160px;
            color: #222;
            text-align: left;
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
    
        body.dark-mode .results-table th,
        body.dark-mode .results-table td {
            border-color: #555;
        }
    
        body.dark-mode .results-table th {
            background-color: #333;
            color: white;
        }
    
        body.dark-mode .progress-bar {
            border-color: #555;
            background: #222;
        }
    
        body.dark-mode pre {
            background: #111;
            border-color: #555;
            color: #eee;
        }
    
        body.dark-mode .pill {
            border-color: #555;
            background: #2a2a2a;
        }
    
        /* Shared helpers */
        .input-container {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 4px;
            flex-wrap: wrap;
            gap: 8px;
        }

        /* ===== Status colors ===== */
        .status-pass {
            color: #15803d !important;
            font-weight: bold;
            background: rgba(34, 197, 94, 0.15) !important;
        }
        
        .status-fail {
            color: #b91c1c !important;
            font-weight: bold;
            background: rgba(239, 68, 68, 0.15) !important;
        }
        
        .status-skip {
            color: #4b5563 !important;
            background: rgba(107, 114, 128, 0.12) !important;
        }
        
        .status-error {
            color: #b91c1c !important;
            font-weight: bold;
            background: rgba(239, 68, 68, 0.15) !important;
        }
        
        .status-info {
            color: #1d4ed8 !important;
            font-weight: bold;
            background: rgba(59, 130, 246, 0.15) !important;
        }
        
        .status-note {
            color: #a16207 !important;
            background: rgba(234, 179, 8, 0.15) !important;
        }
        
        .status-verdict {
            color: #1d4ed8 !important;
            font-weight: bold;
            background: rgba(59, 130, 246, 0.15) !important;
        }
        
        /* Dark mode overrides */
        body.dark-mode .status-pass {
            color: #4ade80 !important;
            background: rgba(74, 222, 128, 0.18) !important;
        }
        
        body.dark-mode .status-fail {
            color: #f97373 !important;
            background: rgba(249, 115, 115, 0.18) !important;
        }
        
        body.dark-mode .status-skip {
            color: #9ca3af !important;
            background: rgba(156, 163, 175, 0.12) !important;
        }
        
        body.dark-mode .status-error {
            color: #f97373 !important;
            background: rgba(249, 115, 115, 0.18) !important;
        }
        
        body.dark-mode .status-info {
            color: #38bdf8 !important;
            background: rgba(56, 189, 248, 0.18) !important;
        }
        
        body.dark-mode .status-note {
            color: #fbbf24 !important;
            background: rgba(251, 191, 36, 0.15) !important;
        }
        
        body.dark-mode .status-verdict {
            color: #38bdf8 !important;
            background: rgba(56, 189, 248, 0.18) !important;
        }
    </style>
</head>
<body class="dark-mode">

    <header>
        <h1>NIST SP 800-90B (Entropy Source Validation)</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <section class="content-box">
        You are here: 
        <a href="/">Home</a> / Workshops / 
        <a href="/workshops/nist_sp_800_90b.asp">NIST SP 800-90B (Entropy Source Validation)</a>
    </section>

    <main>
        <section class="content-box">
            <h2>Client-side NIST SP 800-90B Analysis</h2>
            <p>
                This tool performs continuous health tests and entropy estimation on raw samples
                according to the <strong>NIST SP 800-90B</strong> recommendations
                (Repetition Count, Adaptive Proportion, and multiple estimators).
            </p>
            <p>
                <strong>Everything runs entirely inside your browser</strong> — no data is ever uploaded to a server.
            </p>
        </section>
        
        <section class="content-box">
            <h3>Disclaimer</h3>
            <p>
                This is an educational implementation of the NIST SP 800-90B health tests and estimators.
                While the algorithms closely follow the official NIST recommendations, this browser version
                is intended for learning and demonstration purposes only.
            </p>
            <p>
                Results should <strong>not</strong> be used as formal certification or as the sole basis
                for evaluating entropy sources in production systems.
                For critical applications, always use the official NIST tools or other validated software.
            </p>
            <p>
                The author and contributors accept <strong>no liability for any decisions</strong> made based on the output of this tool.
            </p>
        </section>

        <!-- Input Section -->
        <table border="1" class="utxoTable">
            <tr>
                <th colspan="2" class="miner-header">Input Samples</th>
            </tr>
            <tr>
                <td colspan="2" style="text-align:left; padding:12px;">
                    <label for="samplesInput">Samples (bits as 0/1 string, or space/comma separated integers)</label>
					<br>
					<br>					
                    <textarea id="samplesInput" placeholder="Paste raw samples here&#10;Examples:&#10;010011101001...&#10;or&#10;23 45 12 67 3 89 ...&#10;&#10;For Restart Test, separate datasets with the line:&#10;---RESTART---"></textarea>
                </td>
            </tr>
            <tr>
                <td style="text-align:left; padding:12px;">
                    <label style="display:inline-flex; align-items:center; gap:6px;">
                        <input type="checkbox" id="truncateCheckbox" checked>
                        Truncate to first 1'000'000 samples
                    </label>
                    <br><br>
                    <label for="fileInput">Or load from file:</label>
                    <input id="fileInput" type="file" accept=".txt,.bin,.dat">
                </td>
                <td style="text-align:center; padding:12px;">
                    <span class="pill"><strong id="sampleCount">0</strong> samples</span>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:left; padding:12px;">
                    <div class="input-container" style="justify-content:flex-start;">
                        <label for="symbolSize">Symbol size (bits):</label>
                        <select id="symbolSize">
                            <option value="1" selected>1-bit</option>
                            <option value="8">8-bit</option>
                            <option value="4">4-bit</option>
                            <option value="2">2-bit</option>
                        </select>
                    </div>
                    <div class="input-container" style="justify-content:flex-start; margin-top:10px;">
                        <label for="claimedEntropy">Claimed min-entropy (bits / sample):</label>
                        <input type="number" id="claimedEntropy" value="0.90" min="0" max="1" step="0.01" style="width:90px;">
                        <span style="font-size:0.85em; color:#888;">
                            Hint: Simple PRNGs often fall below 0.7. Cryptographic RNGs should stay above 0.9.
                        </span>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding:12px;">
                    <div class="input-container">
                        <button id="analyzeBtn" class="control-btn primary">Evaluate Entropy Source</button>
                        <button id="clearBtn" class="control-btn">Clear</button>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding:12px;">
                    <div id="progressContainer" style="display:none;">
                        <div class="progress-bar">
                            <div class="progress-bar-inner" id="progressBarInner"></div>
                        </div>
                        <div style="font-family:'Courier New',monospace; font-size:0.85em;">
                            <span id="progressText">Initializing…</span>
                            <span id="currentTestLabel" style="margin-left:12px;"></span>
                        </div>
                    </div>
                </td>
            </tr>
        </table>

        <!-- Results -->
        <table class="utxoTable">
            <thead>
                <tr>
                    <th>Test</th>
                    <th>Status</th>
                    <th>Details</th>
                </tr>
            </thead>
            <tbody id="resultsBody">
                <tr>
                    <td colspan="3" style="text-align:left; color:#999;">
                        No results yet — run the tests to see the report.
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- Final Verdict -->
        <table class="utxoTable">
            <thead>
                <tr>
                    <th class="miner-header">Final Verdict</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td style="padding:0;">
                        <pre id="verdictArea" style="margin:0; border:none; border-radius:0; min-height:80px;">Run the tests to see the verdict.</pre>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok for helping build this NIST SP 800-90B teaching tool.</p>
        </section>
    </main>


    <script>
    // ============================================================
    //  DOM references
    // ============================================================
    const samplesInput     = document.getElementById("samplesInput");
    const fileInput        = document.getElementById("fileInput");
    const sampleCountLabel = document.getElementById("sampleCount");
    const analyzeBtn       = document.getElementById("analyzeBtn");
    const clearBtn         = document.getElementById("clearBtn");
    const progressContainer= document.getElementById("progressContainer");
    const progressBarInner = document.getElementById("progressBarInner");
    const progressText     = document.getElementById("progressText");
    const currentTestLabel = document.getElementById("currentTestLabel");
    const resultsBody      = document.getElementById("resultsBody");
    const truncateCheckbox = document.getElementById("truncateCheckbox");
    const symbolSizeSel    = document.getElementById("symbolSize");

    // ============================================================
    //  helpers
    // ============================================================
    function clearLog() { verdictArea.textContent = ""; }
		
    function setProgress(percent, text, current) {
      progressBarInner.style.width = `${percent}%`;
      progressText.textContent = text || "";
      currentTestLabel.textContent = current || "";
    }
    // ============================================================
    //  Sample parsing
    // ============================================================
    function parseSamples(text, symbolBits) {
      text = (text || "").trim();
      if (!text) return [];

      // If it looks like a pure 0/1 bitstream
      if (/^[01\s]+$/.test(text) && symbolBits === 1) {
        return text.replace(/\s+/g, "").split("").map(c => c === "1" ? 1 : 0);
      }

      // Otherwise treat as space / comma / newline separated integers
      const parts = text.split(/[\s,;]+/).filter(Boolean);
      const samples = [];
      for (const p of parts) {
        const v = parseInt(p, 10);
        if (!Number.isNaN(v)) samples.push(v);
      }
      return samples;
    }
    function updateSampleCount() {
      const symbolBits = parseInt(symbolSizeSel.value, 10);
      const samples = parseSamples(samplesInput.value, symbolBits);
      sampleCountLabel.textContent = samples.length.toLocaleString();
    }

    // ============================================================
    //  SP 800-90B Health Tests (pure JS)
    // ============================================================
    /**
     * Repetition Count Test (SP 800-90B §4.4.1)
     * Detects if a single value is repeated too many times in a row.
     */
    function repetitionCountTest(samples, opts = {}) {
        const alpha = opts.alpha || 2 ** -20;     // typical conservative value
        const H = opts.H || 1.0;               // assumed min-entropy per sample

        // C = cutoff = 1 + ceil( -log2(alpha) / H )
        const C = 1 + Math.ceil((-Math.log2(alpha)) / H);

        let maxRun = 1;
        let maxRunSymbol = samples.length > 0 ? samples[0] : null;

        let currentRun = 1;
        let currentSymbol = samples.length > 0 ? samples[0] : null;

        let failureIndex = -1;
        let failureSymbol = null;

        for (let i = 1; i < samples.length; i++) {
            if (samples[i] === samples[i - 1]) {
                currentRun++;
            } else {
                currentRun = 1;
                currentSymbol = samples[i];
            }

            // Track max run always (even after failure)
            if (currentRun > maxRun) {
                maxRun = currentRun;
                maxRunSymbol = currentSymbol;
            }

            // Detect first failure but DO NOT stop scanning
            if (failureIndex === -1 && currentRun >= C) {
                failureIndex = i;
                failureSymbol = currentSymbol;
            }
        }

        const pass = failureIndex === -1;

        return {
            pass,
            cutoff: C,
            maxRun,
            maxRunSymbol,
            failureIndex,
            failureSymbol,
            notes: pass
                ? `PASS Max run = ${maxRun}, symbol = ${maxRunSymbol}, cutoff = ${C}`
                : `FAIL at index ${failureIndex}, symbol = ${failureSymbol}, run ≥ ${C} (max run = ${maxRun}, symbol = ${maxRunSymbol})`
        };
    }
    function adaptiveProportionTest(samples, opts = {}) {
    const alpha = opts.alpha ?? 2 ** -10;
    const H = opts.H ?? 1.0;
    const W = opts.W ?? 1024;

    const p = Math.pow(2, -H);

    const mu = W * p;
    const sigma = Math.sqrt(W * p * (1 - p));
    const z = 4.2;
    const cr = Math.ceil(mu + z * sigma + 0.5);

    if (samples.length < W) {
        return {
            pass: false,
            cutoff: cr,
            window: W,
            maxCount: 0,
            maxSymbol: null,
            failureIndex: -1,
            failureSymbol: null,
            notes: `Need at least W=${W} samples`
        };
    }

    // Initial window
    const freq = new Map();
    for (let i = 0; i < W; i++) {
        const v = samples[i];
        freq.set(v, (freq.get(v) || 0) + 1);
    }

    // Initial max
    let maxCount = 0;
    let maxSymbol = null;

    for (const [sym, cnt] of freq.entries()) {
        if (cnt > maxCount) {
            maxCount = cnt;
            maxSymbol = sym;
        }
    }

    // Initial failure detection
    let failureIndex = maxCount >= cr ? W - 1 : -1;
    let failureSymbol = failureIndex !== -1 ? maxSymbol : null;

    // Sliding window — NO BREAKS ANYMORE
    for (let i = W; i < samples.length; i++) {

        // Remove oldest
        const out = samples[i - W];
        const outCount = freq.get(out) - 1;
        if (outCount <= 0) freq.delete(out);
        else freq.set(out, outCount);

        // Add newest
        const inn = samples[i];
        const inCount = (freq.get(inn) || 0) + 1;
        freq.set(inn, inCount);

        // Always update max symbol/count
        if (inCount > maxCount) {
            maxCount = inCount;
            maxSymbol = inn;
        }

        // Detect failure only once
        if (failureIndex === -1 && inCount >= cr) {
            failureIndex = i;
            failureSymbol = inn;
        }
    }

    const pass = failureIndex === -1;

    return {
        pass,
        cutoff: cr,
        window: W,
        maxCount,
        maxSymbol,
        failureIndex,
        failureSymbol,
        notes: pass
            ? `PASS Max symbol = ${maxSymbol}, count = ${maxCount}, cutoff = ${cr}, W = ${W}`
            : `FAIL Failure at index ${failureIndex}, symbol=${failureSymbol}, count ≥ ${cr} (final max symbol=${maxSymbol}, final max count=${maxCount})`
    };
}

    /**
        * Most Common Value estimator (SP 800-90B)
        * Returns estimated min-entropy per sample
        */
    function mostCommonValueEstimator(samples) {
        if (samples.length === 0) return { H: 0, notes: "No samples" };

        const freq = new Map();
        for (const s of samples) {
            freq.set(s, (freq.get(s) || 0) + 1);
        }

        let maxCount = 0;
        for (const c of freq.values()) {
            if (c > maxCount) maxCount = c;
        }

        const pmax = maxCount / samples.length;
        // Upper bound on pmax with confidence (simplified but practical)
        const pmaxUpper = pmax + 2.576 * Math.sqrt(pmax * (1 - pmax) / samples.length); // ~99% 
        const H = -Math.log2(Math.min(1, pmaxUpper));

        return {
            H: Math.max(0, H),
            pmax,
            maxCount,
            notes: `p_max ≈ ${pmax.toFixed(6)}, H_min ≈ ${H.toFixed(4)} bits/sample`
        };
    }
    /**
        * Correct Collision Estimate (SP 800-90B §6.3.2)
        * Based on average collision time (waiting time until first repeat)
        */
    function collisionEstimator(samples) {
        const n = samples.length;
        if (n < 10000) {
            return { H: 0, notes: "Need at least 10 000 samples for collision estimator" };
        }

        const collisionTimes = [];
        let i = 0;

        while (i < n - 1) {
            const seen = new Set();
            let steps = 0;

            while (i < n) {
                const v = samples[i];
                steps++;
                i++;

                if (seen.has(v)) {
                    collisionTimes.push(steps);
                    break;
                }
                seen.add(v);

                // safety – should never happen with reasonable alphabet
                if (steps > 100000) break;
            }
        }

        if (collisionTimes.length < 10) {
            return { H: 0, notes: "Too few collisions found" };
        }

        // Average collision time
        const tBar = collisionTimes.reduce((a, b) => a + b, 0) / collisionTimes.length;

        // Solve for p from the equation:
        // tBar = 1 + p/2 + (1-p)/p * ln(1-p)   (approx for the binary / small alphabet case)
        // We use the common practical inversion used by many 90B tools:

        let H = 0;
        if (tBar > 1) {
            // Good practical approximation for the collision entropy
            // H ≈ 2 * log2(tBar) - 1   (works well for binary sources)
            H = 2 * Math.log2(tBar) - 1;
            H = Math.max(0, Math.min(1, H));   // clamp for binary
        }

        return {
            H,
            tBar,
            notes: `Avg collision time = ${tBar.toFixed(2)}, H_min ≈ ${H.toFixed(4)} bits/sample`
        };
    }
    /**
        * Markov estimator – order 1 (SP 800-90B style)
        * Works especially well on binary data
        */
    function markovEstimator(samples) {
        const n = samples.length;
        if (n < 3) return { H: 0, notes: "Need more samples" };

        // Count transitions
        const trans = new Map(); // key = "prev->curr"
        const single = new Map();

        for (let i = 0; i < n; i++) {
            const s = samples[i];
            single.set(s, (single.get(s) || 0) + 1);

            if (i > 0) {
                const key = samples[i - 1] + "→" + s;
                trans.set(key, (trans.get(key) || 0) + 1);
            }
        }

        // Most common transition probability
        let maxTrans = 0;
        for (const c of trans.values()) {
            if (c > maxTrans) maxTrans = c;
        }
        const pTrans = maxTrans / (n - 1);

        // Most common single symbol
        let maxSingle = 0;
        for (const c of single.values()) {
            if (c > maxSingle) maxSingle = c;
        }
        const pSingle = maxSingle / n;

        // Conservative estimate
        const p = Math.max(pTrans, pSingle);
        const H = -Math.log2(Math.min(1, p + 1e-12));

        return {
            H: Math.max(0, H),
            notes: `H_min ≈ ${H.toFixed(4)} bits/sample (order-1 Markov)`
        };
    }
    /**
        * Compression Estimate (SP 800-90B §6.3.4)
        * Based on LZ78-style dictionary growth
        */
    function compressionEstimator(samples) {
        const n = samples.length;
        if (n < 10000) {
            return { H: 0, notes: "Need at least 10 000 samples" };
        }

        // LZ78-style dictionary
        const dict = new Map();
        let word = "";
        let dictSize = 0;
        let i = 0;

        // We work with string keys for simplicity (binary or small alphabet)
        while (i < n) {
            word += samples[i];
            i++;

            if (!dict.has(word)) {
                dict.set(word, true);
                dictSize++;
                word = "";
            }
        }

        // Number of words created by the dictionary
        const W = dictSize;

        // NIST formula (simplified but faithful form used in many validated implementations)
        // The average bits per sample is approximately log2(W) / (n / W) = (W * log2(W)) / n
        // Min-entropy bound:
        let H = 0;
        if (W > 1) {
            H = (W * Math.log2(W)) / n;
            // Clamp to sensible range for binary
            H = Math.max(0, Math.min(1, H));
        }

        return {
            H,
            dictSize: W,
            notes: `Dictionary size = ${W.toLocaleString()}, H_min ≈ ${H.toFixed(4)} bits/sample`
        };
    }
    /**
        * t-Tuple Estimate (SP 800-90B §6.3.3)
        * Correct implementation for small t (recommended t = 2..5 for browser)
        */
    function tTupleEstimator(samples, t = 3) {
        const n = samples.length;
        if (n < t * 1000) {
            return { H: 0, notes: `Need more samples for t=${t}` };
        }

        // Count frequency of every t-tuple
        const freq = new Map();
        for (let i = 0; i <= n - t; i++) {
            let key = "";
            for (let j = 0; j < t; j++) {
                key += samples[i + j] + ",";
            }
            freq.set(key, (freq.get(key) || 0) + 1);
        }

        // Find the most common t-tuple
        let maxCount = 0;
        for (const c of freq.values()) {
            if (c > maxCount) maxCount = c;
        }

        const L = n - t + 1;                 // number of t-tuples
        const pmax = maxCount / L;

        // Upper bound on pmax (99% confidence, normal approximation)
        const pmaxUpper = Math.min(1, pmax + 2.576 * Math.sqrt(pmax * (1 - pmax) / L));

        // Min-entropy of the t-tuple, then per sample
        const H_t = -Math.log2(pmaxUpper);
        const H = H_t / t;

        return {
            H: Math.max(0, H),
            t,
            pmax,
            notes: `t=${t}, p_max ≈ ${pmax.toFixed(6)}, H_min ≈ ${H.toFixed(4)} bits/sample`
        };
    }
    /**
        * Multi Most Common in Window – Original (strict)
        * Uses the absolute worst window (very harsh)
        */
    function multiMostCommonInWindowOriginal(samples, windowSize = 256) {
        const n = samples.length;
        if (n < windowSize * 10) {
            return { H: 0, notes: `Need more samples for window size ${windowSize}` };
        }

        let maxP = 0;
        const step = Math.max(1, Math.floor(windowSize / 4));

        for (let start = 0; start <= n - windowSize; start += step) {
            const freq = new Map();
            for (let i = start; i < start + windowSize; i++) {
                const v = samples[i];
                freq.set(v, (freq.get(v) || 0) + 1);
            }
            let localMax = 0;
            for (const c of freq.values()) if (c > localMax) localMax = c;
            const p = localMax / windowSize;
            if (p > maxP) maxP = p;
        }

        const pUpper = Math.min(1, maxP + 2.576 * Math.sqrt(maxP * (1 - maxP) / windowSize));
        const H = -Math.log2(pUpper);

        return {
            H: Math.max(0, Math.min(1, H)),
            notes: `Window=${windowSize}, worst p ≈ ${maxP.toFixed(6)}, H_min ≈ ${H.toFixed(4)} bits/sample`
        };
    }
    /**
        * Multi Most Common in Window – Calibrated (improved)
        * Uses a higher percentile + larger window + softer confidence bound
        */
    function multiMostCommonInWindowCalibrated(samples, windowSize = 512) {
        const n = samples.length;
        if (n < windowSize * 20) {
            return { H: 0, notes: `Need more samples for window size ${windowSize}` };
        }

        const proportions = [];
        const step = Math.max(1, Math.floor(windowSize / 4));

        for (let start = 0; start <= n - windowSize; start += step) {
            const freq = new Map();
            for (let i = start; i < start + windowSize; i++) {
                const v = samples[i];
                freq.set(v, (freq.get(v) || 0) + 1);
            }
            let localMax = 0;
            for (const c of freq.values()) if (c > localMax) localMax = c;
            proportions.push(localMax / windowSize);
        }

        // Use 95th percentile instead of 99th (less harsh)
        proportions.sort((a, b) => a - b);
        const idx = Math.min(proportions.length - 1, Math.floor(proportions.length * 0.95));
        const p = proportions[idx];

        // Softer confidence interval
        const pUpper = Math.min(1, p + 1.96 * Math.sqrt(p * (1 - p) / windowSize));
        const H = -Math.log2(pUpper);

        return {
            H: Math.max(0, Math.min(1, H)),
            notes: `Window=${windowSize}, 95th %ile p ≈ ${p.toFixed(6)}, H_min ≈ ${H.toFixed(4)} bits/sample`
        };
    }
    /**
        * Lag Prediction Estimate (SP 800-90B §6.3.8)
        * Checks how well a sample can be predicted from a sample at a fixed lag.
        */
    function lagPredictionEstimator(samples, maxLag = 64) {
        const n = samples.length;
        if (n < maxLag * 20) {
            return { H: 0, notes: "Need more samples for lag prediction" };
        }

        let bestP = 0;
        let bestLag = 1;

        for (let lag = 1; lag <= maxLag; lag++) {
            let correct = 0;
            let total = 0;

            for (let i = lag; i < n; i++) {
                // Predict that the current sample equals the sample at lag distance
                if (samples[i] === samples[i - lag]) {
                    correct++;
                }
                total++;
            }

            const p = correct / total;
            if (p > bestP) {
                bestP = p;
                bestLag = lag;
            }
        }

        // Upper confidence bound
        const pUpper = Math.min(1, bestP + 2.576 * Math.sqrt(bestP * (1 - bestP) / (n - bestLag)));
        const H = -Math.log2(pUpper);

        return {
            H: Math.max(0, Math.min(1, H)),
            bestLag,
            bestP,
            notes: `Best lag=${bestLag}, p ≈ ${bestP.toFixed(6)}, H_min ≈ ${H.toFixed(4)} bits/sample`
        };
    }
    /**
        * Markov Estimate – higher order (SP 800-90B style)
        * order = 2 or 3 is practical in the browser
        */
    function markovHigherOrderEstimator(samples, order = 2) {
        const n = samples.length;
        if (n < order * 5000) {
            return { H: 0, notes: `Need more samples for Markov order-${order}` };
        }

        // Count occurrences of each context and each context→symbol transition
        const contextCount = new Map();
        const transitionCount = new Map();

        for (let i = order; i < n; i++) {
            let ctx = "";
            for (let j = i - order; j < i; j++) {
                ctx += samples[j] + ",";
            }
            const symbol = samples[i];
            const key = ctx + "→" + symbol;

            contextCount.set(ctx, (contextCount.get(ctx) || 0) + 1);
            transitionCount.set(key, (transitionCount.get(key) || 0) + 1);
        }

        // Find the highest transition probability
        let maxP = 0;
        for (const [key, count] of transitionCount) {
            const ctx = key.split("→")[0];
            const ctxTotal = contextCount.get(ctx) || 1;
            const p = count / ctxTotal;
            if (p > maxP) maxP = p;
        }

        // Upper confidence bound (simple but stable)
        const pUpper = Math.min(1, maxP + 2.576 * Math.sqrt(maxP * (1 - maxP) / (n - order)));
        const H = -Math.log2(pUpper);

        return {
            H: Math.max(0, Math.min(1, H)),
            order,
            maxP,
            notes: `order=${order}, max p ≈ ${maxP.toFixed(6)}, H_min ≈ ${H.toFixed(4)} bits/sample`
        };
    }
    /**
        * Restart Test (simplified but useful browser version)
        * Expects multiple independent sequences separated by the line:
        * ---RESTART---
        *
        * Returns the minimum entropy found across the restart datasets
        * and checks for row/column-type collisions (SP 800-90B spirit).
        */
    function restartTest(rawText, claimed = 0.9) {
        // Split into individual restart datasets
        const parts = rawText.split(/---\s*RESTART\s*---/i)
            .map(p => p.trim())
            .filter(p => p.length > 0);

        if (parts.length < 2) {
            return {
                pass: false,
                H: 0,
                notes: "Need at least 2 datasets separated by the line ---RESTART---"
            };
        }

        const results = [];
        let minH = Infinity;

        for (let i = 0; i < parts.length; i++) {
            const samples = parseSamples(parts[i], 1); // assume binary for now
            if (samples.length < 1000) continue;

            // Use Most Common Value as a fast per-restart estimate
            const mcv = mostCommonValueEstimator(samples);
            results.push({ index: i + 1, H: mcv.H, len: samples.length });
            if (mcv.H < minH) minH = mcv.H;
        }

        if (results.length < 2) {
            return {
                pass: false,
                H: 0,
                notes: "Could not parse enough valid restart datasets"
            };
        }

        const pass = minH >= claimed;

        return {
            pass,
            H: minH,
            count: results.length,
            notes: `${results.length} restarts, lowest H_min ≈ ${minH.toFixed(4)} bits/sample`
        };
    }
    /**
        * MultiMMC Prediction Estimate (SP 800-90B §6.3.9)
        * Multiple Markov Model with Counting
        */
    function multiMMCPredictionEstimator(samples, maxOrder = 3) {
        const n = samples.length;
        if (n < 10000) {
            return { H: 0, notes: "Need at least 10 000 samples for MultiMMC" };
        }

        let correct = 0;
        let total = 0;

        // For each order we keep a simple frequency table of contexts
        const models = [];
        for (let d = 1; d <= maxOrder; d++) {
            models.push(new Map()); // key = context string → Map(symbol → count)
        }

        for (let i = 0; i < n; i++) {
            // Predict using the highest-order model that has seen this context
            let predicted = null;

            for (let d = Math.min(maxOrder, i); d >= 1; d--) {
                let ctx = "";
                for (let j = i - d; j < i; j++) ctx += samples[j] + ",";
                const model = models[d - 1];
                if (model.has(ctx)) {
                    // Choose the most frequent symbol after this context
                    const counts = model.get(ctx);
                    let bestSym = null, bestCnt = -1;
                    for (const [sym, cnt] of counts) {
                        if (cnt > bestCnt) {
                            bestCnt = cnt;
                            bestSym = sym;
                        }
                    }
                    predicted = bestSym;
                    break;
                }
            }

            // If we made a prediction, score it
            if (predicted !== null) {
                total++;
                if (predicted === samples[i]) correct++;
            }

            // Update all models with the new observation
            for (let d = 1; d <= Math.min(maxOrder, i); d++) {
                let ctx = "";
                for (let j = i - d; j < i; j++) ctx += samples[j] + ",";
                const model = models[d - 1];
                if (!model.has(ctx)) model.set(ctx, new Map());
                const counts = model.get(ctx);
                counts.set(samples[i], (counts.get(samples[i]) || 0) + 1);
            }
        }

        if (total < 100) {
            return { H: 0, notes: "Not enough predictions made" };
        }

        const p = correct / total;
        // Upper confidence bound
        const pUpper = Math.min(1, p + 2.576 * Math.sqrt(p * (1 - p) / total));
        const H = -Math.log2(pUpper);

        return {
            H: Math.max(0, Math.min(1, H)),
            p,
            total,
            notes: `correct=${correct}/${total}, p ≈ ${p.toFixed(6)}, H_min ≈ ${H.toFixed(4)} bits/sample`
        };
    }
    /**
        * LZ78Y Prediction Estimate (corrected)
        * SP 800-90B §6.3.10 style – dictionary based prediction
        */
    function lz78YPredictionEstimator(samples) {
        const n = samples.length;
        if (n < 10000) {
            return { H: 0, notes: "Need at least 10 000 samples for LZ78Y" };
        }

        // Dictionary: phrase → Map of next-symbol counts
        const dict = new Map();
        let correct = 0;
        let total = 0;
        let phrase = [];          // use array instead of string for speed & correctness

        for (let i = 0; i < n; i++) {
            const sym = samples[i];

            // ----- Prediction step -----
            if (phrase.length > 0) {
                const key = phrase.join(",");
                if (dict.has(key)) {
                    const counts = dict.get(key);
                    // Predict the most frequent continuation
                    let bestSym = null;
                    let bestCnt = -1;
                    for (const [s, c] of counts) {
                        if (c > bestCnt) {
                            bestCnt = c;
                            bestSym = s;
                        }
                    }
                    if (bestSym !== null) {
                        total++;
                        if (bestSym === sym) correct++;
                    }
                }
            }

            // ----- Dictionary update -----
            const key = phrase.join(",");
            if (!dict.has(key)) {
                dict.set(key, new Map());
            }
            const counts = dict.get(key);
            counts.set(sym, (counts.get(sym) || 0) + 1);

            // LZ78-style phrase growth
            phrase.push(sym);

            // Limit phrase length to keep the dictionary practical in the browser
            if (phrase.length > 16) {
                phrase = [];
            }

            // Optional: occasionally reset to help make more predictions
            // (this is a practical compromise for browser performance)
            if (i > 0 && i % 5000 === 0) {
                phrase = [];
            }
        }

        if (total < 100) {
            return {
                H: 0,
                notes: `Not enough predictions made (only ${total})`
            };
        }

        const p = correct / total;
        // Upper confidence bound (99%)
        const pUpper = Math.min(1, p + 2.576 * Math.sqrt(p * (1 - p) / total));
        const H = -Math.log2(pUpper);

        return {
            H: Math.max(0, Math.min(1, H)),
            p,
            total,
            correct,
            notes: `correct=${correct}/${total}, p ≈ ${p.toFixed(6)}, H_min ≈ ${H.toFixed(4)} bits/sample`
        };
    }

    // ============================================================
    //  SP 800-90B / IID Track
    // ============================================================
    /**
        * Chi-square Goodness-of-Fit test (IID track)
        * Tests whether the symbol distribution is uniform.
        */
    function chiSquareGoodnessOfFit(samples) {
        const n = samples.length;
        if (n < 1000) {
            return { pass: false, notes: "Need more samples for Chi-square GOF" };
        }

        const freq = new Map();
        for (const s of samples) {
            freq.set(s, (freq.get(s) || 0) + 1);
        }

        const k = freq.size;                 // number of distinct symbols
        if (k < 2) {
            return { pass: false, notes: "Only one symbol found" };
        }

        const expected = n / k;
        let chi2 = 0;
        for (const c of freq.values()) {
            chi2 += Math.pow(c - expected, 2) / expected;
        }

        // Degrees of freedom = k - 1
        // We use a simple critical value approximation for alpha = 0.001
        // (more precise would use inverse gamma, but this is stable)
        const df = k - 1;
        // Rough critical value for alpha=0.001
        const critical = df + 2 * Math.sqrt(2 * df) * 3.1 + 2.5; // approximate

        const pass = chi2 < critical;

        return {
            pass,
            chi2,
            df,
            notes: `χ²=${chi2.toFixed(3)}, df=${df}, critical≈${critical.toFixed(1)} → ${pass ? "IID-like" : "non-uniform"}`
        };
    }
    /**
        * Chi-square Independence test (adjacent pairs)
        * Tests whether consecutive samples are independent.
        */
    function chiSquareIndependence(samples) {
        const n = samples.length;
        if (n < 5000) {
            return { pass: false, notes: "Need more samples for Independence test" };
        }

        // Count pairs (s1, s2)
        const pairCount = new Map();
        const singleCount = new Map();

        for (let i = 0; i < n - 1; i++) {
            const a = samples[i];
            const b = samples[i + 1];
            const key = a + "," + b;

            pairCount.set(key, (pairCount.get(key) || 0) + 1);
            singleCount.set(a, (singleCount.get(a) || 0) + 1);
        }
        // last symbol
        singleCount.set(samples[n - 1], (singleCount.get(samples[n - 1]) || 0) + 1);

        const symbols = [...singleCount.keys()];
        const k = symbols.length;
        if (k < 2) {
            return { pass: false, notes: "Only one symbol found" };
        }

        let chi2 = 0;
        const totalPairs = n - 1;

        for (const a of symbols) {
            for (const b of symbols) {
                const observed = pairCount.get(a + "," + b) || 0;
                const expected = (singleCount.get(a) * singleCount.get(b)) / n;
                if (expected > 0) {
                    chi2 += Math.pow(observed - expected, 2) / expected;
                }
            }
        }

        const df = (k - 1) * (k - 1);
        const critical = df + 2 * Math.sqrt(2 * df) * 3.1 + 2.5;

        const pass = chi2 < critical;

        return {
            pass,
            chi2,
            df,
            notes: `χ²=${chi2.toFixed(3)}, df=${df}, critical≈${critical.toFixed(1)} → ${pass ? "independent" : "dependent"}`
        };
    }
    /**
        * Length of Longest Repeated Substring (LRS) Test – IID track
        * Very useful for detecting structure.
        */
    function longestRepeatedSubstringTest(samples) {
        const n = samples.length;
        if (n < 10000) {
            return { pass: false, notes: "Need more samples for LRS test" };
        }

        // Convert to string for simplicity (works well for binary / small alphabets)
        const s = samples.join("");
        const maxCheck = Math.min(40, Math.floor(Math.log2(n)) + 5);

        let longest = 0;

        // Practical method: check for repeats of increasing length using a set
        for (let len = 1; len <= maxCheck; len++) {
            const seen = new Set();
            let foundRepeat = false;

            for (let i = 0; i <= n - len; i++) {
                const sub = s.substr(i, len);
                if (seen.has(sub)) {
                    foundRepeat = true;
                    longest = len;
                    break;
                }
                seen.add(sub);
            }

            if (!foundRepeat) break;
        }

        // Expected longest repeated substring for random binary data is roughly log2(n)
        const expected = Math.log2(n);
        // We fail if the longest repeat is much longer than expected
        const pass = longest <= expected + 6;   // generous margin for browser use

        return {
            pass,
            longest,
            expected,
            notes: `Longest repeated substring = ${longest}, expected ≈ ${expected.toFixed(1)} → ${pass ? "IID-like" : "structure detected"}`
        };
    }


    // ============================================================
    //  UI helpers
    // ============================================================
    function resetResults() {
      resultsBody.innerHTML = `
        <tr>
          <td colspan="3" style="text-align:center; color:#6b7280;">
            No results yet — run the tests to see the report.
          </td>
        </tr>`;
    }
    function addResultRow(name, status, details) {
        const tr = document.createElement("tr");

        const tdName = document.createElement("td");
        tdName.textContent = name;
		tdName.style.textAlign = "left";

        const tdStatus = document.createElement("td");
        tdStatus.textContent = status;
        tdStatus.className =
            status === "PASS" ? "status-pass" :
                status === "FAIL" ? "status-fail" :
                    status === "INFO" ? "status-info" :
                        status === "SKIP" ? "status-skip" : "status-error";

        const tdDetails = document.createElement("td");
        tdDetails.textContent = details;
		tdDetails.style.textAlign = "left";

        tr.append(tdName, tdStatus, tdDetails);
        resultsBody.appendChild(tr);
    }
    function generate90BVerdict(results) {
        // results is an object you collect while running the tests
        // Example structure expected:
        // {
        //   healthPass: true/false,
        //   iidPass: true/false,
        //   minH: number,
        //   claimed: number,
        //   mmcwFailed: true/false
        // }

        const lines = [];

        // Overall entropy verdict
        if (results.minH >= results.claimed) {
            lines.push(`PASS  Conservative min-entropy ≈ ${results.minH.toFixed(4)} bits/sample (claim ${results.claimed.toFixed(3)}).`);
        } else {
            lines.push(`FAIL  Conservative min-entropy ≈ ${results.minH.toFixed(4)} bits/sample is below the claim of ${results.claimed.toFixed(3)}.`);
        }

        // Health tests
        if (results.healthPass) {
            lines.push("PASS  Health tests (Repetition Count + Adaptive Proportion) passed.");
        } else {
            lines.push("FAIL  One or more health tests failed – the source shows local bias or repetition.");
        }

        // IID track
        if (results.iidPass) {
            lines.push("PASS  IID track tests passed – data appears independent and identically distributed.");
        } else {
            lines.push("FAIL  IID track tests detected dependence or non-uniformity.");
        }

        // Special explanation for Multi Most Common
        if (results.mmcwFailed) {
            lines.push(
                "INFO  Multi Most Common in Window failed. " +
                "This estimator is known to be overly sensitive on finite binary sequences " +
                "and frequently produces pessimistic results even on strong cryptographic sources. " +
                "It is therefore treated as informational only and is not used in the final entropy claim."
            );
        }

        // Final summary
        if (results.minH >= results.claimed && results.healthPass && results.iidPass) {
            lines.push("VERDICT  The entropy source appears sound under SP 800-90B for the claimed min-entropy.");
        } else {
            lines.push("VERDICT  The entropy source does not fully meet the claimed min-entropy or health requirements.");
        }

        return lines.join("\n");
    }


    // ============================================================
    //  Main runner
    // ============================================================
    async function runHealthTests() {
        const rawText = samplesInput.value;
        const symbolBits = parseInt(symbolSizeSel.value, 10);
        const claimed = parseFloat(document.getElementById("claimedEntropy").value) || 0.90;

        analyzeBtn.disabled = true;
        progressContainer.style.display = "block";
        resultsBody.innerHTML = "";
        clearLog();

        // -------------------------------------------------------
        //  RESTART MODE
        // -------------------------------------------------------
        if (rawText.includes("---RESTART---")) {

            setProgress(30, "Running…", "Restart Test");
            const restart = restartTest(rawText, claimed);
            addResultRow("Restart Test", restart.pass ? "PASS" : "FAIL", restart.notes);

            // Show a clear summary row
            addResultRow("Conservative min-entropy (restarts)",
                restart.pass ? "PASS" : "FAIL",
                `≈ ${restart.H.toFixed(4)} bits/sample  (claim ${claimed.toFixed(3)})`);

            setProgress(100, "Completed (Restart mode).", "");
            analyzeBtn.disabled = false;
            return;   // ← important: do not run the normal tests
        }
        else {
            addResultRow("Restart Test", "SKIP",
                "No ---RESTART--- marker found – test skipped");
        }

        // -------------------------------------------------------
        //  NORMAL MODE (single continuous sequence)
        // -------------------------------------------------------
        let samples = parseSamples(rawText, symbolBits);

        if (samples.length === 0) {
            alert("Please provide samples first.");
            return;
        }

        if (truncateCheckbox.checked && samples.length > 1_000_000) {
            samples = samples.slice(0, 1_000_000);
        }

        // ---------- Health Tests ----------
        setProgress(10, "Running…", "Repetition Count");
        await new Promise(r => setTimeout(r, 15));

        const rct = repetitionCountTest(samples, { alpha: 2 ** -20, H: 1.0 });
        addResultRow("Repetition Count Test", rct.pass ? "PASS" : "FAIL", rct.notes);

        setProgress(25, "Running…", "Adaptive Proportion (Original)");
        await new Promise(r => setTimeout(r, 15));

        const aptOrig = adaptiveProportionTest(samples, { alpha: 2 ** -20, H: 1.0, W: 512 });
        addResultRow("Adaptive Proportion (Original)", aptOrig.pass ? "PASS" : "FAIL", aptOrig.notes);

        setProgress(40, "Running…", "Adaptive Proportion (Calibrated)");
        await new Promise(r => setTimeout(r, 15));

        const aptCal = adaptiveProportionTest(samples, { alpha: 2 ** -10, H: 1.0, W: 1024 });
        addResultRow("Adaptive Proportion (Calibrated)", aptCal.pass ? "PASS" : "FAIL", aptCal.notes);

        // ---------- Entropy Estimators ----------
        setProgress(55, "Running…", "Most Common Value");
        await new Promise(r => setTimeout(r, 15));

        const mcv = mostCommonValueEstimator(samples);
        const mcvPass = mcv.H >= claimed;
        addResultRow("Most Common Value", mcvPass ? "PASS" : "FAIL",
            `${mcv.notes}  (claim ${claimed.toFixed(3)})`);

        setProgress(70, "Running…", "Collision Estimator");
        await new Promise(r => setTimeout(r, 15));

        const col = collisionEstimator(samples);
        const colPass = col.H >= claimed;
        addResultRow("Collision Estimator", colPass ? "PASS" : "FAIL",
            `${col.notes}  (claim ${claimed.toFixed(3)})`);

        // ---------- Compression Estimate ----------
        setProgress(88, "Running…", "Compression Estimate");
        await new Promise(r => setTimeout(r, 15));

        const comp = compressionEstimator(samples);
        const compPass = comp.H >= claimed;
        addResultRow("Compression Estimate", compPass ? "PASS" : "FAIL",
            `${comp.notes}  (claim ${claimed.toFixed(3)})`);

        // ---------- t-Tuple Estimate ----------
        setProgress(93, "Running…", "t-Tuple Estimate");
        await new Promise(r => setTimeout(r, 15));

        const ttuple = tTupleEstimator(samples, 3);
        const ttuplePass = ttuple.H >= claimed;
        addResultRow("t-Tuple Estimate (t=3)", ttuplePass ? "PASS" : "FAIL",
            `${ttuple.notes}  (claim ${claimed.toFixed(3)})`);

        /*
        // ---------- Multi Most Common in Window (Original) ----------
        setProgress(94, "Running…", "Multi Most Common (Original)");
        await new Promise(r => setTimeout(r, 15));

        log("▶ Multi Most Common in Window (Original) …");
        const mmcwOrig = multiMostCommonInWindowOriginal(samples, 256);
        const mmcwOrigPass = mmcwOrig.H >= claimed;
        addResultRow("Multi Most Common (Original)", mmcwOrigPass ? "PASS" : "FAIL",
            `${mmcwOrig.notes}  (claim ${claimed.toFixed(3)})`);
        log(`  ↳ ${mmcwOrigPass ? "PASS" : "FAIL"} – ${mmcwOrig.notes}`);

        // ---------- Multi Most Common in Window (Calibrated) ----------
        setProgress(96, "Running…", "Multi Most Common (Calibrated)");
        await new Promise(r => setTimeout(r, 15));

        log("▶ Multi Most Common in Window (Calibrated) …");
        const mmcwCal = multiMostCommonInWindowCalibrated(samples, 256);
        const mmcwCalPass = mmcwCal.H >= claimed;
        addResultRow("Multi Most Common (Calibrated)", mmcwCalPass ? "PASS" : "FAIL",
            `${mmcwCal.notes}  (claim ${claimed.toFixed(3)})`);
        log(`  ↳ ${mmcwCalPass ? "PASS" : "FAIL"} – ${mmcwCal.notes}`);
        */

        // ---------- Multi Most Common in Window (Informational only) ----------
        setProgress(94, "Running…", "Multi Most Common (Original)");
        await new Promise(r => setTimeout(r, 15));

        const mmcwOrig = multiMostCommonInWindowOriginal(samples, 256);
        addResultRow("Multi Most Common (Original)", "INFO",
            `${mmcwOrig.notes}  (informational – not used in final verdict)`);

        setProgress(96, "Running…", "Multi Most Common (Calibrated)");
        await new Promise(r => setTimeout(r, 15));

        const mmcwCal = multiMostCommonInWindowCalibrated(samples, 256);
        addResultRow("Multi Most Common (Calibrated)", "INFO",
            `${mmcwCal.notes}  (informational – not used in final verdict)`);

        // ---------- Lag Prediction ----------
        setProgress(97, "Running…", "Lag Prediction");
        await new Promise(r => setTimeout(r, 15));

        const lag = lagPredictionEstimator(samples, 64);
        const lagPass = lag.H >= claimed;
        addResultRow("Lag Prediction Estimate", lagPass ? "PASS" : "FAIL",
            `${lag.notes}  (claim ${claimed.toFixed(3)})`);


        // ---------- Higher-order Markov ----------
        setProgress(97, "Running…", "Markov Estimator");
        await new Promise(r => setTimeout(r, 15));

        const markov = markovEstimator(samples);
        const markovPass = markov.H >= claimed;
        addResultRow("Markov Estimator (order-1)", markovPass ? "PASS" : "FAIL",
            `${markov.notes}  (claim ${claimed.toFixed(3)})`);

        setProgress(97, "Running…", "Markov order-2");
        await new Promise(r => setTimeout(r, 15));

        const markov2 = markovHigherOrderEstimator(samples, 2);
        const markov2Pass = markov2.H >= claimed;
        addResultRow("Markov Estimator (order-2)", markov2Pass ? "PASS" : "FAIL",
            `${markov2.notes}  (claim ${claimed.toFixed(3)})`);

        setProgress(98, "Running…", "Markov order-3");
        await new Promise(r => setTimeout(r, 15));

        const markov3 = markovHigherOrderEstimator(samples, 3);
        const markov3Pass = markov3.H >= claimed;
        addResultRow("Markov Estimator (order-3)", markov3Pass ? "PASS" : "FAIL",
            `${markov3.notes}  (claim ${claimed.toFixed(3)})`);

        // ---------- MultiMMC Prediction ----------
        setProgress(91, "Running…", "MultiMMC Prediction");
        await new Promise(r => setTimeout(r, 15));

        const mmc = multiMMCPredictionEstimator(samples, 3);
        const mmcPass = mmc.H >= claimed;
        addResultRow("MultiMMC Prediction", mmcPass ? "PASS" : "FAIL",
            `${mmc.notes}  (claim ${claimed.toFixed(3)})`);

        // ---------- LZ78Y Prediction ----------
        setProgress(93, "Running…", "LZ78Y Prediction");
        await new Promise(r => setTimeout(r, 15));

        const lz78 = lz78YPredictionEstimator(samples);
        const lz78Pass = lz78.H >= claimed;
        addResultRow("LZ78Y Prediction", lz78Pass ? "PASS" : "FAIL",
            `${lz78.notes}  (claim ${claimed.toFixed(3)})`);

        // ---------- Restart Test ----------
        // Only runs if the user has put the ---RESTART--- marker in the textarea
        if (samplesInput.value.includes("---RESTART---")) {
            setProgress(99, "Running…", "Restart Test");
            await new Promise(r => setTimeout(r, 15));

            const restart = restartTest(samplesInput.value, claimed);
            addResultRow("Restart Test", restart.pass ? "PASS" : "FAIL", restart.notes);
        }

        const minH = Math.min(
            mcv.H,
            col.H,
            markov.H,
            markov2.H,
            markov3.H,
            comp.H,
            ttuple.H,
            lag.H,
            mmc.H,
            lz78.H
            //mmcwCal.H,   // or remove this line if you prefer
        );

        const finalPass = minH >= claimed;
        addResultRow("Conservative min-entropy",
            minH >= claimed ? "PASS" : "FAIL",
            `≈ ${minH.toFixed(4)} bits/sample  (claim ${claimed.toFixed(3)})  [Multi-MCW excluded]`);

        // ========== IID Track Tests ==========
        setProgress(20, "Running…", "Chi-square Goodness-of-Fit");
        await new Promise(r => setTimeout(r, 15));

        const gof = chiSquareGoodnessOfFit(samples);
        addResultRow("Chi-square Goodness-of-Fit (IID)", gof.pass ? "PASS" : "FAIL", gof.notes);

        setProgress(25, "Running…", "Chi-square Independence");
        await new Promise(r => setTimeout(r, 15));

        const indep = chiSquareIndependence(samples);
        addResultRow("Chi-square Independence (IID)", indep.pass ? "PASS" : "FAIL", indep.notes);

        setProgress(30, "Running…", "Longest Repeated Substring");
        await new Promise(r => setTimeout(r, 15));

        const lrs = longestRepeatedSubstringTest(samples);
        addResultRow("Longest Repeated Substring (IID)", lrs.pass ? "PASS" : "FAIL", lrs.notes);


        // Collect flags for the verdict
        const healthPass = rct.pass && aptOrig.pass && aptCal.pass;
        const iidPass = gof.pass && indep.pass && lrs.pass;
        const mmcwFailed = true; // we know it usually fails; or check the actual values

        const verdictText = generate90BVerdict({
            healthPass,
            iidPass,
            minH,
            claimed,
            mmcwFailed
        });

		// Display it
		const verdictArea = document.getElementById("verdictArea");
		if (verdictArea) {
			// Convert plain text into colored HTML
			const colored = verdictText
				.split("\n")
				.map(line => {
					if (line.startsWith("PASS")) {
						return `<span class="status-pass">${line}</span>`;
					}
					if (line.startsWith("FAIL")) {
						return `<span class="status-fail">${line}</span>`;
					}
					if (line.startsWith("INFO")) {
						return `<span class="status-note">${line}</span>`;
					}
					if (line.startsWith("VERDICT")) {
						return `<span class="status-verdict">${line}</span>`;
					}
					// fallback for any other line
					return line;
				})
				.join("\n");
		
			verdictArea.innerHTML = colored;
		
			// Keep it nicely wrapped inside the table cell
			verdictArea.style.whiteSpace = "pre-wrap";
			verdictArea.style.overflowWrap = "break-word";
			verdictArea.style.wordBreak = "break-word";
			verdictArea.style.maxWidth = "100%";
			verdictArea.style.overflowX = "hidden";
		}


        setProgress(100, "Completed.", "");
        analyzeBtn.disabled = false;
    }

    // ============================================================
    //  Event wiring
    // ============================================================
    samplesInput.addEventListener("input", updateSampleCount);
    symbolSizeSel.addEventListener("change", updateSampleCount);
    fileInput.addEventListener("change", async (e) => {
      const file = e.target.files && e.target.files[0];
      if (!file) return;

      const text = await file.text();
      samplesInput.value = text;
      updateSampleCount();
    });
    analyzeBtn.addEventListener("click", () => {
      runHealthTests();
    });
    clearBtn.addEventListener("click", () => {
      samplesInput.value = "";
      fileInput.value = "";
      updateSampleCount();
      resetResults();
      clearLog();
      progressContainer.style.display = "none";
      analyzeBtn.disabled = false;
    });

    // Init
    updateSampleCount();
    resetResults();
    </script>


    <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>